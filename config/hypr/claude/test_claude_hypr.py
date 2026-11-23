"""Tests of claude_hypr.py: the pure logic and the daemon, against a fake Hyprland IPC."""
import copy
import importlib.util
import json
import os
import pathlib
import signal
import socket
import subprocess
import sys
import tempfile
import threading
import time
import unittest
from unittest import mock

_spec = importlib.util.spec_from_file_location("claude_hypr", pathlib.Path(__file__).with_name("claude_hypr.py"))
ch = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(ch)

COLORS = {"foreground": "#ffffff", "claude_label": "#999999", "active": "#88aaff",
          "claude_done": "#66cc66", "claude_action": "#ff6666"}


def client(address, pid, workspace="Work", at=(8, 38), title="zsh", cls="Alacritty", grouped=(), **extra):
    """A window in the format of `hyprctl -j clients` (Hyprland 0.57)."""
    data = {
        "address": address, "mapped": True, "hidden": False, "visible": True, "acceptsInput": True,
        "at": list(at), "size": [940, 500],
        "workspace": {"address": f"name:{workspace}", "id": 1, "type": "regular", "name": workspace},
        "floating": False, "monitor": 0, "class": cls, "title": title, "initialClass": cls,
        "initialTitle": title, "pid": pid, "xwayland": False, "pinned": False, "pinFullscreened": False,
        "fullscreen": 0, "fullscreenClient": 0, "fullscreenHandler": "none", "allowedOverFullscreen": False,
        "grouped": list(grouped), "tags": [], "swallowing": "0x0", "focusHistoryID": 0, "inhibitingIdle": False,
        "xdgTag": "", "xdgDescription": "", "contentType": "none", "tearingHint": False, "stableId": "1",
    }
    data.update(extra)
    return data


def monitor(name, workspace, index=0):
    return {"id": index, "name": name, "x": 0, "y": 0, "width": 1920, "height": 1080, "focused": index == 0,
            "activeWorkspace": {"address": f"name:{workspace}", "id": 1, "type": "regular", "name": workspace},
            "specialWorkspace": {"address": "", "type": "regular", "name": ""}}


def workspace(name, last="0x0"):
    return {"address": f"name:{name}", "id": 1, "type": "regular", "name": name, "monitor": "DP-1",
            "monitorID": 1, "windows": 1, "hasfullscreen": False, "lastwindow": last, "lastwindowtitle": "",
            "ispersistent": True, "tiledLayout": "master"}


class FakeIpc:
    events_path = "/nonexistent/.socket2.sock"

    def __init__(self):
        self.data = {
            "clients": [], "monitors": [], "workspaces": [], "activewindow": {},
        }
        self.batches = []
        self.reply = "ok"

    on_query = None

    def query(self, command):
        if self.on_query:
            self.on_query(command)
        value = self.data.get(command)
        return copy.deepcopy(value)

    def dispatch_many(self, expressions):
        if expressions:
            self.batches.append(list(expressions))
        return [self.reply] * len(expressions)

    def dispatch(self, expression):
        return self.dispatch_many([expression])


class Fixture(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        root = pathlib.Path(self.tmp.name)
        self.state_dir = root / "state"
        self.bar_dir = root / "bar"
        self.labels_file = root / "labels.json"
        self.colors_file = root / "colors.json"
        self.colors_file.write_text(json.dumps(COLORS))
        self.state_dir.mkdir()
        self.alive = {100, 200, 300, 400}
        self.signals = 0
        self.ipc = FakeIpc()
        self.daemon = ch.Daemon(self.ipc, state_dir=str(self.state_dir), labels_file=str(self.labels_file),
                                bar_dir=str(self.bar_dir), colors_file=str(self.colors_file),
                                pid_alive=lambda p: p in self.alive, signal_waybar=self.signal)

    def tearDown(self):
        self.tmp.cleanup()

    def signal(self):
        self.signals += 1

    def write_state(self, session, state, pids):
        (self.state_dir / f"{session}.json").write_text(json.dumps({"state": state, "pids": pids}))

    def write_labels(self, labels):
        self.labels_file.write_text(json.dumps(labels))

    def bar(self, output):
        return json.loads((self.bar_dir / f"{output}.json").read_text())

    def set_world(self, clients, monitors=None, workspaces=None, active=None):
        self.ipc.data["clients"] = clients
        self.ipc.data["monitors"] = monitors if monitors is not None else [monitor("DP-1", "Work")]
        self.ipc.data["workspaces"] = workspaces if workspaces is not None else [workspace("Work")]
        self.ipc.data["activewindow"] = active if active is not None else {}


class Events(unittest.TestCase):
    def test_addresses_from_events_and_json_agree(self):
        self.assertEqual(ch.normalize_address("55D1c0"), "0x55d1c0")
        self.assertEqual(ch.normalize_address("0x55d1c0"), "0x55d1c0")
        for empty in ("", None, "0x0", "0", "zz"):
            self.assertIsNone(ch.normalize_address(empty))

    def test_event_lines(self):
        self.assertEqual(ch.parse_event("activewindowv2>>55d1c0"), ("activewindowv2", "55d1c0"))
        self.assertEqual(ch.parse_event("windowtitlev2>>55,a >> b"), ("windowtitlev2", "55,a >> b"))
        self.assertEqual(ch.parse_event("activewindowv2>>"), ("activewindowv2", ""))
        self.assertIsNone(ch.parse_event("garbage"))
        self.assertIsNone(ch.parse_event(">>x"))


class StateFiles(Fixture):
    def test_loads_valid_files_only(self):
        self.write_state("a", "done", [100, 1])
        self.write_state("b", "bogus", [100])
        self.write_state("c", "action", "nope")
        (self.state_dir / "d.json").write_text("not json")
        (self.state_dir / "e.json.123.tmp").write_text("{}")
        (self.state_dir / "f").write_text('{"state": "done", "pids": [1]}')
        found = ch.load_states(str(self.state_dir))
        self.assertEqual([(os.path.basename(f.path), f.state, f.pids, f.claude_pid) for f in found],
                         [("a.json", "done", [100, 1], None)])

    def test_claude_pid_is_read_when_valid(self):
        (self.state_dir / "a.json").write_text('{"state": "done", "pids": [5, 6], "claude_pid": 6}')
        (self.state_dir / "b.json").write_text('{"state": "done", "pids": [5, 6], "claude_pid": "x"}')
        found = {os.path.basename(f.path): f.claude_pid for f in ch.load_states(str(self.state_dir))}
        self.assertEqual(found, {"a.json": 6, "b.json": None})

    def test_missing_directory(self):
        self.assertEqual(ch.load_states(str(self.state_dir / "absent")), [])

    def test_file_belongs_to_the_first_pid_that_is_a_client(self):
        clients = [client("0xa1", 300), client("0xa2", 400)]
        files = [("/s/x.json", "done", [900, 300, 400], 1)]
        self.assertEqual(ch.associate(files, clients), {"0xa1": ("done", "/s/x.json")})

    def test_file_without_a_matching_client_is_unassociated(self):
        self.assertEqual(ch.associate([("/s/x.json", "done", [900, 901], 1)], [client("0xa1", 300)]), {})

    def test_newest_file_wins_for_a_window(self):
        files = [("/s/new.json", "action", [300], 20), ("/s/old.json", "done", [300], 10)]
        self.assertEqual(ch.associate(files, [client("0xa1", 300)]), {"0xa1": ("action", "/s/new.json")})

    def test_event_style_client_addresses_are_normalised(self):
        files = [("/s/x.json", "done", [300], 1)]
        self.assertEqual(ch.associate(files, [client("0xA1", 300)]), {"0xa1": ("done", "/s/x.json")})

    def test_session_is_dead_when_the_recorded_claude_process_is_gone(self):
        alive = {7, 8}
        self.assertTrue(ch.is_dead([5, 6, 7, 8], {8}, alive.__contains__, claude_pid=6))
        self.assertFalse(ch.is_dead([5, 6, 7, 8], {8}, alive.__contains__, claude_pid=7))

    def test_without_a_recorded_process_the_pids_before_the_terminal_decide(self):
        # chain: hook wrapper 5, claude 6, shell 7, terminal 8 (a client)
        alive = {7, 8}
        self.assertFalse(ch.is_dead([5, 6, 7, 8, 1000], {8}, alive.__contains__))
        self.assertTrue(ch.is_dead([5, 6, 8], {8}, alive.__contains__))
        self.assertFalse(ch.is_dead([5, 6, 8], {8}, {6}.__contains__))

    def test_a_pid_chain_starting_at_the_terminal_is_alive_while_it_is(self):
        self.assertFalse(ch.is_dead([8, 1000], {8}, {8}.__contains__))
        self.assertTrue(ch.is_dead([8, 1000], {8}, {1000}.__contains__))

    def test_without_a_matching_client_the_first_pid_and_its_parent_decide(self):
        self.assertTrue(ch.is_dead([5, 6, 7], set(), {7}.__contains__))
        self.assertFalse(ch.is_dead([5, 6, 7], set(), {6}.__contains__))

    def test_no_pids_is_dead(self):
        self.assertTrue(ch.is_dead([], set(), lambda p: True))

    def test_claude_window_criteria(self):
        plain = client("0xa1", 1, title="vim")
        self.assertFalse(ch.is_claude(plain, {}, {}))
        self.assertTrue(ch.is_claude(plain, {"0xa1": "x"}, {}))
        self.assertTrue(ch.is_claude(plain, {}, {"0xa1": "done"}))
        self.assertTrue(ch.is_claude(client("0xa1", 1, title="✳ Claude Code"), {}, {}))

    def test_labels_of_vanished_windows_are_purged(self):
        self.assertEqual(ch.purge_labels({"0xa1": "x", "0xb2": "y"}, {"0xb2"}), {"0xb2": "y"})


class Bar(unittest.TestCase):
    def render(self, clients, labels=None, states=None, monitors=None, workspaces=None):
        monitors = monitors or [monitor("DP-1", "Work")]
        return ch.render_bar(monitors, workspaces or [workspace("Work")], clients, labels or {}, states or {}, COLORS)

    def test_no_claude_window_gives_an_empty_text(self):
        self.assertEqual(self.render([client("0xa1", 1, title="vim")]), {"DP-1": {"text": "", "tooltip": ""}})

    def test_windows_are_ordered_top_to_bottom_then_left_to_right(self):
        clients = [client("0xa1", 1, at=(960, 38)), client("0xa2", 2, at=(8, 540)), client("0xa3", 3, at=(8, 38))]
        labels = {"0xa1": "right", "0xa2": "bottom", "0xa3": "left"}
        text = self.render(clients, labels)["DP-1"]["text"]
        self.assertEqual([t.split(">")[1].split("<")[0] for t in text.split("  ")], ["left", "right", "bottom"])

    def test_colours_underline_and_unnamed(self):
        clients = [client("0xa1", 1, at=(8, 38), title="Claude Code"), client("0xa2", 2, at=(8, 540)),
                   client("0xa3", 3, at=(8, 900))]
        text = self.render(clients, {"0xa2": "doing"}, {"0xa3": "action"}, workspaces=[workspace("Work", "0xa2")])
        parts = text["DP-1"]["text"].split("  ")
        self.assertEqual(parts, [
            '<span foreground="#999999">sans nom</span>',
            '<span foreground="#ffffff" underline="single" underline_color="#88aaff">doing</span>',
            '<span foreground="#ff6666">sans nom</span>'])

    def test_a_state_colour_wins_over_the_focus_colour(self):
        clients = [client("0xa1", 1)]
        text = self.render(clients, {"0xa1": "x"}, {"0xa1": "done"}, workspaces=[workspace("Work", "0xa1")])
        self.assertEqual(text["DP-1"]["text"],
                         '<span foreground="#66cc66" underline="single" underline_color="#88aaff">x</span>')

    def test_labels_are_escaped_and_cleaned(self):
        text = self.render([client("0xa1", 1)], {"0xa1": "a <b> & c\nd\x07"})["DP-1"]["text"]
        self.assertEqual(text, '<span foreground="#999999">a &lt;b&gt; &amp; c d</span>')

    def test_each_output_shows_its_own_active_workspace(self):
        clients = [client("0xa1", 1, workspace="Work"), client("0xa2", 2, workspace="Dev")]
        monitors = [monitor("DP-1", "Work", 0), monitor("HDMI-A-2", "Dev", 1), monitor("eDP-1", "www", 2)]
        out = self.render(clients, {"0xa1": "one", "0xa2": "two"}, monitors=monitors,
                          workspaces=[workspace("Work"), workspace("Dev"), workspace("www")])
        self.assertIn("one", out["DP-1"]["text"])
        self.assertNotIn("two", out["DP-1"]["text"])
        self.assertIn("two", out["HDMI-A-2"]["text"])
        self.assertEqual(out["eDP-1"]["text"], "")

    def test_hidden_tabs_of_a_group_follow_the_group_order(self):
        group = ["0xa2", "0xa1"]
        clients = [client("0xa1", 1, grouped=group), client("0xa2", 2, grouped=group)]
        text = self.render(clients, {"0xa1": "first", "0xa2": "second"})["DP-1"]["text"]
        self.assertLess(text.index("second"), text.index("first"))

    def test_unmapped_windows_are_ignored(self):
        self.assertEqual(self.render([client("0xa1", 1, mapped=False)], {"0xa1": "x"})["DP-1"]["text"], "")


class WorkspaceModules(unittest.TestCase):
    def render(self, monitors, workspaces):
        return ch.render_workspaces(monitors, workspaces)

    def test_every_output_gets_the_seven_workspaces_in_order(self):
        out = self.render([monitor("DP-1", "Work"), monitor("eDP-1", "Dev", 1)], [])
        self.assertEqual(sorted(out), sorted(f"{o}-ws{i}" for o in ("DP-1", "eDP-1") for i in range(1, 8)))
        self.assertEqual([out[f"DP-1-ws{i}"]["text"] for i in range(1, 8)],
                         ["Work", "Dev", "www", "www-2", "Data", "Audio", "Other"])

    def test_classes_follow_the_group_box_highlighting(self):
        focused = monitor("DP-1", "Work", 0)
        other = monitor("HDMI-A-2", "Dev", 1)
        workspaces = [dict(workspace("Work"), windows=2), dict(workspace("Dev"), windows=0),
                      dict(workspace("Data"), windows=1)]
        out = self.render([focused, other], workspaces)
        self.assertEqual(out["DP-1-ws1"]["class"], ["occupied", "here-focused"])
        self.assertEqual(out["DP-1-ws2"]["class"], ["empty", "elsewhere"])
        self.assertEqual(out["DP-1-ws5"]["class"], ["occupied"])
        self.assertEqual(out["DP-1-ws3"]["class"], ["empty"])
        self.assertEqual(out["HDMI-A-2-ws2"]["class"], ["empty", "here"])
        self.assertEqual(out["HDMI-A-2-ws1"]["class"], ["occupied", "elsewhere"])

    def test_a_workspace_that_does_not_exist_yet_is_empty(self):
        out = self.render([monitor("DP-1", "Work")], [dict(workspace("Work"), windows=1)])
        self.assertEqual(out["DP-1-ws7"]["class"], ["empty"])

    def test_an_active_workspace_outside_the_list_highlights_nothing(self):
        out = self.render([monitor("DP-1", "special:scratch")], [])
        self.assertTrue(all(p["class"] == ["empty"] for p in out.values()))


class Switch(unittest.TestCase):
    def test_order_rows_states_and_addresses(self):
        clients = [
            client("0xa1", 1, workspace="www", title="Zed"),
            client("0xa2", 2, workspace="Dev", title="beta"),
            client("0xa3", 3, workspace="Work", title="alpha"),
            client("0xa4", 4, workspace="Other", title="Done one"),
            client("0xa5", 5, workspace="Audio", title="Needs <you>"),
            client("0xa6", 6, workspace="Work", title="gamma"),
        ]
        rows, addresses, row_states = ch.switch_rows(clients, {"0xa6": "Alpha label"},
                                                     {"0xa4": "done", "0xa5": "action"})
        self.assertEqual(addresses, ["0xa5", "0xa4", "0xa3", "0xa6", "0xa2", "0xa1"])
        self.assertEqual(rows[:4], ["Needs <you>  Audio", "Done one  Other", "alpha  Work", "Alpha label  Work"])
        self.assertEqual(row_states, ["action", "done", None, None, None, None])

    def test_state_marks(self):
        self.assertEqual(ch.state_marks(["action", "done", None, "action"]), ["-u", "0,3", "-a", "1"])
        self.assertEqual(ch.state_marks([None, "done"]), ["-a", "1"])
        self.assertEqual(ch.state_marks([None]), [])

    def test_name_falls_back_to_the_class_then_a_question_mark(self):
        clients = [client("0xa1", 1, title="", cls="foot"), client("0xa2", 2, title="", cls="")]
        rows, _, _ = ch.switch_rows(clients, {}, {})
        self.assertIn("foot  Work", rows)
        self.assertIn("?  Work", rows)

    def test_a_row_is_always_one_line(self):
        rows, _, _ = ch.switch_rows([client("0xa1", 1, title="a\nb\x00c")], {}, {})
        self.assertEqual(len(rows), 1)
        self.assertNotIn("\n", rows[0])
        self.assertIn("a b c", rows[0])

    def test_workspaces_outside_the_known_order_come_last(self):
        clients = [client("0xa1", 1, workspace="special:x", title="a"), client("0xa2", 2, workspace="Other", title="b")]
        _, addresses, _ = ch.switch_rows(clients, {}, {})
        self.assertEqual(addresses, ["0xa2", "0xa1"])


class Dispatchers(unittest.TestCase):
    def test_lua_expressions(self):
        self.assertEqual(ch.focus_lua("0x55d1c0"), 'hl.dsp.focus({ window = "address:0x55d1c0" })')

    def test_arguments_cannot_inject_lua(self):
        with self.assertRaises(ValueError):
            ch.focus_lua('0x1" })--')


class DaemonRefresh(Fixture):
    def setUp(self):
        super().setUp()
        self.set_world([client("0xa1", 100, at=(8, 38)), client("0xa2", 200, at=(960, 38), title="✳ Claude Code")],
                       workspaces=[workspace("Work", "0xa1")], active={"address": "0xa1"})

    def test_unreadable_hyprland_leaves_everything_as_is(self):
        self.write_state("s1", "done", [200])
        self.write_labels({"0xa1": "keep"})
        self.ipc.data["clients"] = None
        self.assertFalse(self.daemon.refresh())
        self.assertEqual(self.ipc.batches, [])
        self.assertEqual(json.loads(self.labels_file.read_text()), {"0xa1": "keep"})
        self.assertTrue((self.state_dir / "s1.json").exists())

    def test_state_of_dead_sessions_is_deleted(self):
        self.write_state("alive", "done", [200])
        self.write_state("dead", "done", [555, 556])
        self.daemon.refresh()
        self.assertEqual(sorted(os.listdir(self.state_dir)), ["alive.json"])

    def test_state_of_a_killed_claude_is_deleted_while_its_terminal_lives(self):
        self.write_state("killed", "action", [300, 200, 1])
        self.alive.discard(300)
        self.daemon.refresh()
        self.assertEqual(os.listdir(self.state_dir), [])
        self.assertEqual(self.ipc.batches, [])

    def test_recorded_claude_process_decides_over_the_chain(self):
        (self.state_dir / "r.json").write_text(json.dumps({"state": "done", "pids": [300, 400, 200], "claude_pid": 400}))
        self.alive.discard(300)
        self.daemon.refresh()
        self.assertEqual(os.listdir(self.state_dir), ["r.json"])
        self.alive.discard(400)
        self.daemon.refresh()
        self.assertEqual(os.listdir(self.state_dir), [])

    def test_unmatched_but_living_state_is_kept(self):
        self.write_state("other", "done", [100000])
        self.alive.add(100000)
        self.daemon.refresh()
        self.assertEqual(os.listdir(self.state_dir), ["other.json"])

    def test_labels_of_vanished_windows_are_removed_from_disk(self):
        self.write_labels({"0xa1": "keep", "0xdead": "gone"})
        self.daemon.refresh()
        self.assertEqual(json.loads(self.labels_file.read_text()), {"0xa1": "keep"})

    def test_labels_written_by_rename_are_picked_up(self):
        self.daemon.refresh()
        self.write_labels({"0xa1": "fresh"})
        self.daemon.refresh()
        self.assertIn("fresh", self.bar("DP-1")["text"])


class DaemonBar(Fixture):
    def setUp(self):
        super().setUp()
        self.set_world([client("0xa1", 100), client("0xa2", 200, at=(960, 38))],
                       monitors=[monitor("DP-1", "Work"), monitor("eDP-1", "Dev", 1)],
                       workspaces=[workspace("Work", "0xa1"), workspace("Dev")], active={"address": "0xa1"})
        self.write_labels({"0xa1": "main", "0xa2": "side"})

    def test_bar_files_are_written_for_every_output_and_waybar_is_signalled_once(self):
        self.daemon.refresh()
        self.assertEqual(self.bar("eDP-1"), {"text": "", "tooltip": ""})
        self.assertEqual(self.bar("DP-1")["text"],
                         '<span foreground="#ffffff" underline="single" underline_color="#88aaff">main</span>'
                         '  <span foreground="#999999">side</span>')
        self.assertEqual(self.signals, 1)

    def test_unchanged_content_is_not_rewritten_or_signalled(self):
        self.daemon.refresh()
        path = self.bar_dir / "DP-1.json"
        before = path.stat().st_mtime_ns
        self.daemon.refresh()
        self.assertEqual((path.stat().st_mtime_ns, self.signals), (before, 1))

    def test_state_change_updates_the_bar(self):
        self.daemon.refresh()
        self.write_state("s1", "done", [200])
        self.daemon.refresh()
        self.assertIn('foreground="#66cc66">side', self.bar("DP-1")["text"])
        self.assertEqual(self.signals, 2)

    def test_bar_file_of_a_removed_output_is_deleted(self):
        self.daemon.refresh()
        self.ipc.data["monitors"] = [monitor("DP-1", "Work")]
        self.daemon.refresh()
        self.assertFalse((self.bar_dir / "eDP-1.json").exists())
        self.assertEqual(self.signals, 2)

    def test_no_temporary_files_are_left(self):
        self.daemon.refresh()
        names = os.listdir(self.bar_dir)
        self.assertFalse([n for n in names if n.endswith(".tmp")])
        self.assertIn("DP-1.json", names)

    def test_workspace_files_are_written_and_follow_the_focus(self):
        self.ipc.data["workspaces"] = [dict(workspace("Work"), windows=2), dict(workspace("Dev"), windows=0)]
        self.daemon.refresh()
        self.assertEqual(self.bar("DP-1-ws1"), {"text": "Work", "class": ["occupied", "here-focused"]})
        self.assertEqual(self.bar("eDP-1-ws2"), {"text": "Dev", "class": ["empty", "here"]})
        self.assertEqual(self.bar("eDP-1-ws1"), {"text": "Work", "class": ["occupied", "elsewhere"]})
        self.assertEqual(self.signals, 1)
        self.daemon.refresh()
        self.assertEqual(self.signals, 1)
        self.ipc.data["monitors"][0]["focused"] = False
        self.ipc.data["monitors"][1]["focused"] = True
        self.daemon.refresh()
        self.assertEqual(self.bar("DP-1-ws1")["class"], ["occupied", "here"])
        self.assertEqual(self.bar("eDP-1-ws2")["class"], ["empty", "here-focused"])
        self.assertEqual(self.signals, 2)

    def test_workspace_files_of_a_removed_output_are_deleted(self):
        self.daemon.refresh()
        self.ipc.data["monitors"] = [monitor("DP-1", "Work")]
        self.daemon.refresh()
        self.assertFalse([n for n in os.listdir(self.bar_dir) if n.startswith("eDP-1")])


class DaemonEvents(Fixture):
    def setUp(self):
        super().setUp()
        self.set_world([client("0xa1", 100), client("0xa2", 200, title="Claude Code")])
        self.daemon.refresh()
        self.daemon.dirty = False

    def test_listed_events_mark_the_daemon_dirty(self):
        for name in ("activewindowv2", "openwindow", "workspacev2", "focusedmonv2", "movewindowv2",
                     "monitoraddedv2", "togglegroup"):
            self.daemon.dirty = False
            self.daemon.handle_event(name, "x")
            self.assertTrue(self.daemon.dirty, name)

    def test_other_events_are_ignored(self):
        for name in ("activelayout", "submap", "screencast", "bell"):
            self.daemon.handle_event(name, "x")
        self.assertFalse(self.daemon.dirty)

    def test_title_animation_of_a_claude_window_does_not_refresh(self):
        self.daemon.handle_event("windowtitlev2", "a2,⠂ Claude Code")
        self.daemon.handle_event("windowtitlev2", "a1,vim")
        self.assertFalse(self.daemon.dirty)

    def test_title_gaining_or_losing_claude_code_refreshes(self):
        self.daemon.handle_event("windowtitlev2", "a1,✳ Claude Code")
        self.assertTrue(self.daemon.dirty)
        self.daemon.dirty = False
        self.daemon.handle_event("windowtitlev2", "a2,zsh")
        self.assertTrue(self.daemon.dirty)

    def test_title_of_an_unknown_window_refreshes(self):
        self.daemon.handle_event("windowtitlev2", "ff,whatever")
        self.assertTrue(self.daemon.dirty)

    def test_closing_a_window_removes_its_state_file(self):
        self.write_state("s2", "done", [200])
        self.daemon.refresh()
        self.daemon.handle_event("closewindow", "a2")
        self.assertFalse((self.state_dir / "s2.json").exists())
        self.assertTrue(self.daemon.dirty)

    def test_closing_a_window_removes_every_state_file_of_it(self):
        self.write_state("old", "action", [300, 200])
        self.write_state("new", "done", [200])
        self.daemon.refresh()
        self.assertEqual(sorted(os.listdir(self.state_dir)), ["new.json", "old.json"])
        self.daemon.handle_event("closewindow", "a2")
        self.assertEqual(os.listdir(self.state_dir), [])

    def test_a_file_written_during_a_refresh_is_read_by_the_next_one(self):
        written = []

        def write_late(command):
            if command == "workspaces" and not written:
                written.append(1)
                self.write_state("late", "done", [200])

        self.ipc.on_query = write_late
        self.daemon.refresh()
        self.daemon.dirty = False
        self.daemon.poll_files()
        self.assertTrue(self.daemon.dirty)

    def test_file_changes_are_noticed_by_the_poll(self):
        self.daemon.poll_files()
        self.daemon.dirty = False
        self.write_state("s1", "done", [200])
        self.daemon.poll_files()
        self.assertTrue(self.daemon.dirty)

    def test_a_session_whose_processes_died_is_noticed_by_the_poll(self):
        self.write_state("s1", "done", [200])
        self.daemon.refresh()
        self.daemon.poll_files()
        self.daemon.dirty = False
        self.alive.discard(200)
        self.daemon.poll_files()
        self.assertTrue(self.daemon.dirty)

    def test_event_loop_refreshes_on_events_and_stops_when_the_socket_closes(self):
        mine, theirs = socket.socketpair()
        self.write_state("s1", "done", [200])
        result = []
        refreshes = []
        self.ipc.on_query = lambda command: refreshes.append(1) if command == "clients" else None

        def run():
            try:
                self.daemon.serve(mine)
            except ConnectionError as error:
                result.append(error)

        thread = threading.Thread(target=run)
        thread.start()
        try:
            theirs.sendall(b"activewindowv2>>a1\nwindowtitlev2>>a2,x\nopenwin")
            deadline = time.time() + 3
            while not refreshes and time.time() < deadline:
                time.sleep(0.01)
            time.sleep(0.2)
            self.assertEqual(len(refreshes), 1)
        finally:
            theirs.close()
            thread.join(3)
            mine.close()
        self.assertEqual(len(result), 1)


class RealSocket(unittest.TestCase):
    """The Ipc class against a stand-in Hyprland on a unix socket."""

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        os.makedirs(os.path.join(self.tmp.name, "hypr", "sig"))
        self.ipc = ch.Ipc("sig", self.tmp.name)
        self.server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.server.bind(self.ipc.request_path)
        self.server.listen(4)
        self.requests = []
        self.replies = []

        def serve():
            for reply in iter(lambda: self.replies.pop(0) if self.replies else None, None):
                conn, _ = self.server.accept()
                self.requests.append(conn.recv(65536).decode())
                conn.sendall(reply.encode())
                conn.close()

        self.thread = threading.Thread(target=serve, daemon=True)

    def tearDown(self):
        self.server.close()
        self.tmp.cleanup()

    def test_query_sends_the_json_flag_and_parses_the_reply(self):
        self.replies.append('[{"address": "0x1"}]')
        self.thread.start()
        self.assertEqual(self.ipc.query("clients"), [{"address": "0x1"}])
        self.assertEqual(self.requests, ["j/clients"])

    def test_dispatch_batch_format(self):
        self.replies.append("ok\n\n\nok")
        self.thread.start()
        self.assertEqual(self.ipc.dispatch_many(["a(1)", "b(2)"]), ["ok", "ok"])
        self.assertEqual(self.requests, ["[[BATCH]]dispatch a(1);dispatch b(2)"])

    def test_malformed_reply_is_none(self):
        self.replies.append("unknown request")
        self.thread.start()
        with self.assertLogs("claude_hypr", "WARNING"):
            self.assertIsNone(self.ipc.query("nope"))

    def test_missing_socket_is_an_error_not_a_crash(self):
        self.server.close()
        os.remove(self.ipc.request_path)
        with self.assertLogs("claude_hypr", "WARNING"):
            self.assertIsNone(self.ipc.query("clients"))
        self.assertEqual(self.ipc.dispatch_many(["x"]), [])

    def test_requires_a_signature(self):
        with mock.patch.dict(os.environ, clear=False):
            os.environ.pop("HYPRLAND_INSTANCE_SIGNATURE", None)
            with self.assertRaises(RuntimeError):
                ch.Ipc()


class Commands(Fixture):
    def setUp(self):
        super().setUp()
        patches = [mock.patch.object(ch, "LABELS_FILE", str(self.labels_file)),
                   mock.patch.object(ch, "STATE_DIR", str(self.state_dir)),
                   mock.patch.object(ch, "COLORS_FILE", str(self.colors_file))]
        for patch in patches:
            patch.start()
            self.addCleanup(patch.stop)
        self.set_world([client("0xa1", 100, title="one"), client("0xa2", 200, title="two", workspace="Dev")],
                       active={"address": "0xa1"})

    def test_rename_prompts_with_the_current_label_and_saves_the_answer(self):
        self.write_labels({"0xa1": "old", "0xa2": "other"})
        with mock.patch.object(ch, "picker", return_value="new name") as picker:
            ch.rename_command(self.ipc)
        picker.assert_called_once_with("--prompt-only", "-p", "Nom de la fenêtre", "--placeholder", "old",
                                       "--mesg", "« - » retire le nom")
        self.assertEqual(json.loads(self.labels_file.read_text()), {"0xa1": "new name", "0xa2": "other"})

    def test_rename_with_a_dash_removes_the_label(self):
        self.write_labels({"0xa1": "old"})
        with mock.patch.object(ch, "picker", return_value="-"):
            ch.rename_command(self.ipc)
        self.assertEqual(json.loads(self.labels_file.read_text()), {})

    def test_rename_with_a_blank_answer_changes_nothing(self):
        self.write_labels({"0xa1": "old"})
        with mock.patch.object(ch, "picker", return_value=""):
            ch.rename_command(self.ipc)
        self.assertEqual(json.loads(self.labels_file.read_text()), {"0xa1": "old"})

    def test_rename_cancelled_changes_nothing(self):
        self.write_labels({"0xa1": "old"})
        with mock.patch.object(ch, "picker", return_value=None):
            ch.rename_command(self.ipc)
        self.assertEqual(json.loads(self.labels_file.read_text()), {"0xa1": "old"})

    def test_rename_without_an_active_window_does_not_prompt(self):
        self.ipc.data["activewindow"] = {}
        with mock.patch.object(ch, "picker") as picker:
            ch.rename_command(self.ipc)
        picker.assert_not_called()

    def test_rename_of_a_window_closed_meanwhile_is_dropped(self):
        def closes(*args, **kwargs):
            self.ipc.data["clients"] = [c for c in self.ipc.data["clients"] if c["address"] != "0xa1"]
            return "late"

        with mock.patch.object(ch, "picker", side_effect=closes):
            ch.rename_command(self.ipc)
        self.assertFalse(self.labels_file.exists())

    def test_switch_lists_rows_and_focuses_the_pick(self):
        self.write_state("s1", "action", [200])
        self.write_state("s2", "done", [100])
        with mock.patch.object(ch, "picker", return_value="0") as picker:
            ch.switch_command(self.ipc)
        args, kwargs = picker.call_args
        self.assertEqual(args, ("--no-custom", "--format", "i", "-u", "0", "-a", "1", "-p", "Fenêtre"))
        self.assertEqual(len(kwargs["rows"]), 2)
        self.assertIn("two", kwargs["rows"][0])
        self.assertEqual(self.ipc.batches, [['hl.dsp.focus({ window = "address:0xa2" })'],
                                            ["hl.dsp.cursor.move({ x = 478, y = 288 })"]])

    def test_cursor_lua_needs_the_window_geometry(self):
        self.assertEqual(ch.cursor_lua({"at": [1080, 420], "size": [1921, 1080]}),
                         "hl.dsp.cursor.move({ x = 2040, y = 960 })")
        self.assertIsNone(ch.cursor_lua({"at": [0, 0]}))
        self.assertIsNone(ch.cursor_lua({"at": None, "size": [1, 1]}))

    def test_switch_cancelled_or_out_of_range_focuses_nothing(self):
        for answer in (None, "", "7", "x"):
            with mock.patch.object(ch, "picker", return_value=answer):
                ch.switch_command(self.ipc)
        self.assertEqual(self.ipc.batches, [])


class Picker(unittest.TestCase):
    def test_cancel_and_failure_give_none(self):
        with mock.patch.object(ch.subprocess, "run", return_value=mock.Mock(returncode=1, stdout="")):
            self.assertIsNone(ch.picker("-p", "x"))
        with mock.patch.object(ch.subprocess, "run", return_value=mock.Mock(returncode=2, stdout="")), \
                self.assertLogs("claude_hypr", "ERROR"):
            self.assertIsNone(ch.picker("-p", "x"))
        with mock.patch.object(ch.subprocess, "run", return_value=mock.Mock(returncode=139, stdout="")), \
                self.assertLogs("claude_hypr", "ERROR"):
            self.assertIsNone(ch.picker("-p", "x"))
        with mock.patch.object(ch.subprocess, "run", side_effect=FileNotFoundError):
            self.assertIsNone(ch.picker("-p", "x"))

    def test_rows_go_to_stdin_and_the_answer_is_stripped(self):
        with mock.patch.object(ch.subprocess, "run", return_value=mock.Mock(returncode=0, stdout="3\n")) as run:
            self.assertEqual(ch.picker("--format", "i", rows=["a", "b"]), "3")
        self.assertEqual(run.call_args.args[0], ["dms", "dmenu", "--format", "i"])
        self.assertEqual(run.call_args.kwargs["input"], "a\nb")


class WaybarSignal(unittest.TestCase):
    def fake_proc(self, root, pid, comm, caught, uid=None):
        directory = os.path.join(root, str(pid))
        os.makedirs(directory)
        with open(os.path.join(directory, "comm"), "w") as f:
            f.write(comm + "\n")
        with open(os.path.join(directory, "status"), "w") as f:
            f.write(f"Name:\t{comm}\nSigBlk:\t0000000000000000\nSigCgt:\t{caught:016x}\n")

    def test_only_waybars_with_a_handler_are_signalled(self):
        mask = 1 << (ch.WAYBAR_SIGNAL - 1)
        with tempfile.TemporaryDirectory() as root:
            self.fake_proc(root, 11, "waybar", mask | 0x4000)
            self.fake_proc(root, 12, "waybar", 0x4000)
            self.fake_proc(root, 13, "alacritty", mask)
            os.makedirs(os.path.join(root, "self"))
            sent = []
            complete = ch.send_waybar_signal(root, lambda pid, sig: sent.append((pid, sig)))
        self.assertEqual(sent, [(11, ch.WAYBAR_SIGNAL)])
        self.assertFalse(complete)

    def test_nothing_to_signal_is_complete(self):
        with tempfile.TemporaryDirectory() as root:
            self.assertTrue(ch.send_waybar_signal(root, lambda *a: self.fail("signalled")))
        self.assertTrue(ch.send_waybar_signal("/nonexistent", lambda *a: self.fail("signalled")))

    def test_signal_number_matches_waybar_signal_8(self):
        self.assertEqual(ch.WAYBAR_SIGNAL, signal.SIGRTMIN + 8)


class SignalRetry(Fixture):
    def test_a_waybar_without_handler_is_retried_a_bounded_number_of_times(self):
        calls = []
        self.daemon.signal_waybar = lambda: calls.append(1) or False
        self.daemon.notify_waybar(ch.MAX_SIGNAL_RETRIES)
        for _ in range(ch.MAX_SIGNAL_RETRIES * 2):
            self.daemon.poll_files()
        self.assertEqual(len(calls), ch.MAX_SIGNAL_RETRIES + 1)

    def test_retry_stops_once_delivered(self):
        answers = [False, False, True]
        calls = []
        self.daemon.signal_waybar = lambda: calls.append(1) or answers.pop(0)
        self.daemon.notify_waybar(5)
        for _ in range(5):
            self.daemon.poll_files()
        self.assertEqual(len(calls), 3)


class ConnectionLoop(Fixture):
    def test_a_refused_connection_to_a_dead_instance_ends_the_daemon(self):
        attempts = []

        def refuse():
            attempts.append(1)
            raise ConnectionRefusedError("refused")

        self.ipc.connect_events = refuse
        with mock.patch.object(ch.time, "sleep"), self.assertLogs("claude_hypr"):
            self.daemon.run()
        self.assertEqual(len(attempts), ch.MAX_CONNECT_FAILURES)

    def test_a_missing_socket_ends_the_daemon_too(self):
        def missing():
            raise FileNotFoundError("gone")

        self.ipc.connect_events = missing
        with mock.patch.object(ch.time, "sleep"), self.assertLogs("claude_hypr"):
            self.daemon.run()

    def test_a_successful_connection_resets_the_count(self):
        results = [ConnectionRefusedError()] * (ch.MAX_CONNECT_FAILURES - 1)
        sockets = []

        def connect():
            if results:
                raise results.pop()
            if not sockets:
                sockets.append(1)
                return mock.Mock()
            raise ConnectionRefusedError()

        self.ipc.connect_events = connect
        served = []
        self.daemon.serve = lambda sock: served.append(1) or (_ for _ in ()).throw(ConnectionError("closed"))
        with mock.patch.object(ch.time, "sleep"), self.assertLogs("claude_hypr"):
            self.daemon.run()
        self.assertEqual(len(served), 1)


class Singleton(unittest.TestCase):
    def test_second_daemon_does_not_get_the_lock(self):
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, "run", "daemon.lock")
            first = ch.acquire_lock(path)
            self.assertIsNotNone(first)
            self.assertIsNone(ch.acquire_lock(path))
            os.close(first)
            second = ch.acquire_lock(path)
            self.assertIsNotNone(second)
            os.close(second)

    def test_the_lock_records_the_pid_and_the_instance(self):
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, "daemon.lock")
            fd = ch.acquire_lock(path, "sigA")
            with open(path) as f:
                self.assertEqual(json.load(f), {"signature": "sigA", "pid": os.getpid()})
            os.close(fd)

    def test_a_daemon_of_the_same_instance_is_not_replaced(self):
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, "daemon.lock")
            first = ch.acquire_lock(path, "sigA")
            kill = mock.Mock()
            self.assertIsNone(ch.acquire_lock(path, "sigA", takeover_s=0.3, kill=kill, is_daemon=lambda p: True))
            kill.assert_not_called()
            os.close(first)

    def test_a_daemon_of_another_instance_is_terminated_and_replaced(self):
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, "daemon.lock")
            old = ch.acquire_lock(path, "sigA")
            killed = []

            def kill(pid, sig):
                killed.append((pid, sig))
                os.close(old)

            fd = ch.acquire_lock(path, "sigB", takeover_s=3, kill=kill, is_daemon=lambda p: True,
                                 instance_alive=lambda sig: False)
            self.assertIsNotNone(fd)
            self.assertEqual(killed, [(os.getpid(), signal.SIGTERM)])
            with open(path) as f:
                self.assertEqual(json.load(f)["signature"], "sigB")
            os.close(fd)

    def test_a_daemon_whose_instance_is_still_running_is_left_alone(self):
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, "daemon.lock")
            old = ch.acquire_lock(path, "sigA")
            kill = mock.Mock()
            asked = []
            with self.assertLogs("claude_hypr", "INFO"):
                result = ch.acquire_lock(path, "sigB", takeover_s=3, kill=kill, is_daemon=lambda p: True,
                                         instance_alive=lambda sig: asked.append(sig) or True)
            self.assertIsNone(result)
            self.assertEqual(asked, ["sigA"])
            kill.assert_not_called()
            os.close(old)

    def test_instance_liveness_follows_its_event_socket(self):
        with tempfile.TemporaryDirectory() as d, mock.patch.object(ch, "RUNTIME_DIR", d):
            self.assertFalse(ch.hyprland_instance_alive("sig"))
            os.makedirs(os.path.join(d, "hypr", "sig"))
            server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            server.bind(os.path.join(d, "hypr", "sig", ".socket2.sock"))
            server.listen(1)
            self.assertTrue(ch.hyprland_instance_alive("sig"))
            server.close()
            # The socket file stays behind after Hyprland exits, but nothing listens on it.
            self.assertTrue(os.path.exists(os.path.join(d, "hypr", "sig", ".socket2.sock")))
            self.assertFalse(ch.hyprland_instance_alive("sig"))

    def test_a_pid_that_is_not_a_daemon_is_never_signalled(self):
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, "daemon.lock")
            old = ch.acquire_lock(path, "sigA")
            kill = mock.Mock()
            self.assertIsNone(ch.acquire_lock(path, "sigB", takeover_s=0.3, kill=kill, is_daemon=lambda p: False))
            kill.assert_not_called()
            os.close(old)

    def test_a_holder_that_never_releases_leaves_the_lock_untaken(self):
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, "daemon.lock")
            old = ch.acquire_lock(path, "sigA")
            self.assertIsNone(ch.acquire_lock(path, "sigB", takeover_s=0.3, kill=lambda *a: None,
                                              is_daemon=lambda p: True))
            os.close(old)

    def spawn(self, directory, script_name, *args):
        script = os.path.join(directory, script_name)
        with open(script, "w") as f:
            f.write("import time\ntime.sleep(30)\n")
        child = subprocess.Popen([sys.executable, "-B", script, *args])
        self.addCleanup(lambda: (child.kill(), child.wait()))
        # The command line only shows the script once the interpreter has started.
        deadline = time.time() + 5
        while time.time() < deadline and script.encode() not in pathlib.Path(f"/proc/{child.pid}/cmdline").read_bytes():
            time.sleep(0.01)
        return child

    def test_a_real_daemon_process_is_recognised(self):
        with tempfile.TemporaryDirectory() as d:
            self.assertTrue(ch.is_daemon_process(self.spawn(d, "claude_hypr.py", "daemon").pid))

    def test_other_processes_are_not_taken_for_a_daemon(self):
        with tempfile.TemporaryDirectory() as d:
            self.assertFalse(ch.is_daemon_process(self.spawn(d, "claude_hypr.py", "rename").pid))
            self.assertFalse(ch.is_daemon_process(self.spawn(d, "other.py", "daemon").pid))

    def test_daemon_process_detection(self):
        self.assertFalse(ch.is_daemon_process(os.getpid()))
        self.assertFalse(ch.is_daemon_process(2 ** 22 + 12345))


class ColorsFile(Fixture):
    def test_missing_names_and_bad_values_fall_back(self):
        self.colors_file.write_text(json.dumps({"claude_done": "#123456", "active": "red", "wallpaper": "/x.png"}))
        colors = ch.load_colors(str(self.colors_file))
        self.assertEqual(colors["claude_done"], "#123456")
        self.assertEqual(colors["active"], ch.DEFAULT_COLORS["active"])
        self.assertNotIn("wallpaper", colors)

    def test_missing_file(self):
        self.assertEqual(ch.load_colors(str(self.colors_file) + ".absent"), ch.DEFAULT_COLORS)


if __name__ == "__main__":
    unittest.main()

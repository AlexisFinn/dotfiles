"""Labels and attention states of Claude Code windows.

Labels are typed through a rofi prompt and saved in RUNTIME_DIR/labels.json. States are written by
the Claude Code hook as one file per X window id in RUNTIME_DIR/state/, containing "done" or
"action"; a missing file means nothing to report. Everything lives under $XDG_RUNTIME_DIR, so it
survives a qtile restart and is wiped at logout.

Unfocused windows with a state get a border half as wide, in the state colour, from
the MonadTall and MonadWide layouts below, so that the focused window keeps the widest border.
ClaudeTaskList shows every Claude window of the group with its label, and switch_window picks any
window through rofi.
"""
import asyncio
import json
import os
import re

import libqtile
from libqtile import hook, layout, pangocffi
from libqtile.log_utils import logger
from libqtile.utils import create_task
from libqtile.widget import TaskList

RUNTIME_DIR = os.path.join(os.environ.get("XDG_RUNTIME_DIR") or f"/run/user/{os.getuid()}", "claude-qtile")
LABELS_FILE = os.path.join(RUNTIME_DIR, "labels.json")
STATE_DIR = os.path.join(RUNTIME_DIR, "state")
# The hook only writes a file, so qtile polls the state directory instead of being called.
POLL_INTERVAL_S = 1
# Claude Code keeps this in the terminal title, after a status glyph.
CLAUDE_TITLE = "Claude Code"
UNNAMED = "sans nom"
_CONTROL_CHARS = re.compile(r"[\x00-\x1f\x7f]")

_colors: dict[str, str] = {}
_labels: dict[int, str] = {}
_states: dict[int, str] = {}
_task_lists: list["ClaudeTaskList"] = []


def setup(done_color, action_color):
    _colors.update(done=done_color, action=action_color)
    _labels.update(_load_labels())
    _states.update(_read_states())


def _load_labels():
    try:
        with open(LABELS_FILE) as f:
            return {int(wid): str(label) for wid, label in json.load(f).items()}
    except (OSError, ValueError, AttributeError):
        return {}


def _save_labels():
    os.makedirs(RUNTIME_DIR, mode=0o700, exist_ok=True)
    tmp = f"{LABELS_FILE}.tmp"
    with open(tmp, "w") as f:
        json.dump({str(wid): label for wid, label in _labels.items()}, f)
    os.replace(tmp, LABELS_FILE)


def _read_states():
    states = {}
    try:
        names = os.listdir(STATE_DIR)
    except OSError:
        return states
    for name in names:
        if not name.isdigit():
            continue
        try:
            with open(os.path.join(STATE_DIR, name)) as f:
                state = f.read().strip()
        except OSError:
            continue
        if state in _colors:
            states[int(name)] = state
    return states


def attention_color(window):
    return _colors.get(_states.get(window.wid))


def is_claude(window):
    return window.wid in _labels or window.wid in _states or CLAUDE_TITLE in (window.name or "")


def _redraw(wids=()):
    qtile = libqtile.qtile
    groups = {getattr(qtile.windows_map.get(wid), "group", None) for wid in wids}
    for group in groups:
        if group is not None and group.screen is not None:
            group.layout_all()
    for task_list in _task_lists:
        if task_list.configured:
            task_list.bar.draw()


def _poll():
    # A config reload imports this module anew: the loop of the previous copy stops here.
    if getattr(libqtile.qtile, "claude_sessions_poll", None) is not _poll:
        return
    try:
        states = _read_states()
        if states != _states:
            changed = {wid for wid, _ in set(states.items()) ^ set(_states.items())}
            _states.clear()
            _states.update(states)
            _redraw(changed)
    except Exception:  # noqa: BLE001 - the poll loop must keep running
        logger.exception("claude_sessions: state poll failed")
    libqtile.qtile.call_later(POLL_INTERVAL_S, _poll)


def _start_polling():
    qtile = libqtile.qtile
    if getattr(qtile, "claude_sessions_poll", None) is not _poll:
        qtile.claude_sessions_poll = _poll
        _poll()


@hook.subscribe.startup_complete
def _prune_labels():
    """Drops the labels of windows closed while qtile was not running."""
    live = set(libqtile.qtile.windows_map)
    if any(wid not in live for wid in _labels):
        for wid in [wid for wid in _labels if wid not in live]:
            del _labels[wid]
        _save_labels()


@hook.subscribe.client_killed
def _forget(window):
    if _labels.pop(window.wid, None) is not None:
        _save_labels()
    _states.pop(window.wid, None)
    try:
        os.remove(os.path.join(STATE_DIR, str(window.wid)))
    except OSError:
        pass


def rename_window(qtile):
    """lazy.function target: asks for a label for the focused window; an empty answer removes it."""
    window = qtile.current_window
    if window is not None:
        create_task(_prompt_label(window.wid))


async def _rofi(*args, rows=None):
    """Runs rofi -dmenu and returns its output, or None when it is cancelled or fails."""
    try:
        proc = await asyncio.create_subprocess_exec(
            "rofi", "-dmenu", *args,
            stdin=asyncio.subprocess.DEVNULL if rows is None else asyncio.subprocess.PIPE,
            stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.DEVNULL)
        out, _ = await proc.communicate(None if rows is None else "\n".join(rows).encode())
    except OSError:
        logger.exception("claude_sessions: rofi failed")
        return None
    # rofi exits with 1 when cancelled.
    if proc.returncode != 0:
        return None
    return out.decode(errors="replace").strip()


async def _prompt_label(wid):
    label = await _rofi("-l", "0", "-p", "Nom de la fenêtre", "-filter", _labels.get(wid, ""))
    if label is None or wid not in libqtile.qtile.windows_map:
        return
    if label:
        _labels[wid] = label
    else:
        _labels.pop(wid, None)
    _save_labels()
    _redraw()


def switch_window(qtile):
    """lazy.function target: picks a window in rofi and focuses it, on whatever group and screen.

    Windows waiting for an action come first, then finished ones, then the others, each by group.
    A window shows its label when it has one, otherwise its title.
    """
    rank = {"action": 0, "done": 1}
    group_index = {group.name: i for i, group in enumerate(qtile.groups)}
    windows = sorted(
        (w for w in qtile.windows_map.values() if getattr(w, "group", None) is not None),
        key=lambda w: (rank.get(_states.get(w.wid), len(rank)), group_index.get(w.group.name, 0),
                       _window_name(w).casefold()))
    if windows:
        create_task(_pick_window([w.wid for w in windows], [_switch_row(w) for w in windows]))


def _window_name(window):
    return _labels.get(window.wid) or window.name or next(iter(window.get_wm_class() or []), "?")


def _switch_row(window):
    color = attention_color(window)
    # The invisible dot keeps names aligned whether or not a window has a state.
    dot = f'<span foreground="{color}">●</span>' if color else '<span alpha="1">●</span>'
    # rofi reads one row per line and row options after a NUL, and Pango rejects the other control
    # characters: none of them may reach the row.
    name = " ".join(_CONTROL_CHARS.sub(" ", _window_name(window)).split()) or "?"
    name = pangocffi.markup_escape_text(name)
    group = pangocffi.markup_escape_text(window.group.label or window.group.name)
    return f'{dot} {name}  <span alpha="50%">{group}</span>'


async def _pick_window(wids, rows):
    index = await _rofi("-i", "-markup-rows", "-format", "i", "-p", "Fenêtre", rows=rows)
    if not index or not index.isdigit() or int(index) >= len(wids):
        return
    window = libqtile.qtile.windows_map.get(wids[int(index)])
    if window is not None and getattr(window, "group", None) is not None:
        try:
            focus_window(window)
        except Exception:  # noqa: BLE001 - create_task does not report a failed task
            logger.exception("claude_sessions: focusing the picked window failed")


def focus_window(window, warp=True):
    """Brings the window's group to a screen if needed, then focuses the window."""
    qtile = libqtile.qtile
    group = window.group
    if group.screen is None:
        qtile.current_screen.set_group(group, warp=warp)
    else:
        qtile.focus_screen(group.screen.index, warp=False)
    if window.minimized:
        window.minimized = False
    group.focus(window, warp)
    if window.floating:
        window.bring_to_front()


class _AttentionBorders:
    """Gives an unfocused window that has a state a border half as wide, in the state colour, after
    the layout placed it.

    The border is a real narrower X border rather than a partly painted one: with rounded corners,
    picom redraws the whole border in the colour of its outer edge, which would make it as thick
    as the focused window's. The frame shrinks around an unchanged client area, so a focus change
    does not resize the window.
    """

    def configure(self, client, screen_rect):
        super().configure(client, screen_rect)
        color = attention_color(client)
        width = client.borderwidth
        if color and not client.has_focus and client in self.clients and width:
            inset = width - width // 2
            client.place(client.x + inset, client.y + inset, client.width, client.height,
                         width - inset, color)


# Same class names as the stock layouts, so the layout names stay "monadtall" and "monadwide".
class MonadTall(_AttentionBorders, layout.MonadTall):
    pass


class MonadWide(_AttentionBorders, layout.MonadWide):
    pass


class ClaudeTaskList(TaskList):
    """TaskList restricted to Claude windows, drawn like a GroupBox with highlight_method="line".

    A label takes its window's state colour, otherwise `foreground`, or `focused_foreground` for the
    group's current window, which is also underlined in `border`.
    """

    defaults = [
        ("focused_foreground", "#ffffff", "Text colour of the group's current window when it has no state."),
        ("line_width", 3, "Height of the line under the group's current window."),
    ]

    def __init__(self, **config):
        # Any markup_* option switches TaskList to pango markup, which get_taskname relies on.
        config.setdefault("markup_normal", "{}")
        TaskList.__init__(self, **config)
        self.add_defaults(ClaudeTaskList.defaults)
        self._shown = set()
        _task_lists.append(self)

    def _configure(self, qtile, bar):
        TaskList._configure(self, qtile, bar)
        _start_polling()

    @property
    def windows(self):
        windows = [w for w in TaskList.windows.fget(self) if is_claude(w)]
        self._shown = {w.wid for w in windows}
        return windows

    def get_taskname(self, window):
        return pangocffi.markup_escape_text(_labels.get(window.wid) or UNNAMED)

    def draw(self):
        background = self.background or self.bar.background
        self.drawer.clear(background)
        offset = self.margin_side
        self._box_end_positions = []
        for window, _icon, task, box_width in self.calc_box_widths():
            self._box_end_positions.append(offset + box_width)
            focused = window is window.group.current_window
            self.layout.text = task
            self.layout.colour = attention_color(window) or (
                self.focused_foreground if focused else self.foreground)
            self.layout.width = box_width - 2 * self.padding_side
            # Same vertical centring as GroupBox, so both labels share a baseline.
            pad_y = [(self.bar.size - self.layout.height - self.line_width) / 2,
                     (self.bar.size - self.layout.height + self.line_width) / 2]
            framed = self.layout.framed(
                self.line_width, self.border if focused else background, self.padding_side, pad_y)
            framed.draw_line(offset, 0, False)
            offset += box_width + self.spacing
        self.draw_at_default_position()

    def select_window(self):
        """Focuses the clicked window, where the stock TaskList minimizes it when already current."""
        window = self.clicked
        if window is not None and window.group is not None:
            focus_window(window, warp=False)

    def setup_hooks(self):
        # Claude Code animates its title while working: only a change of membership needs a redraw.
        hook.subscribe.client_name_updated(self._on_name_updated)
        hook.subscribe.focus_change(self.update)
        hook.subscribe.float_change(self.update)
        hook.subscribe.client_urgent_hint_changed(self.update)
        hook.subscribe.client_killed(self.remove_icon_cache)

    def _on_name_updated(self, window):
        if self.configured and window.group is self.bar.screen.group \
                and is_claude(window) != (window.wid in self._shown):
            self.bar.draw()

    def finalize(self):
        if self in _task_lists:
            _task_lists.remove(self)
        TaskList.finalize(self)

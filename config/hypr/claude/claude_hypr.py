#!/usr/bin/env python3
"""Labels and attention states of Claude Code windows under Hyprland.

Subcommands:
  daemon  keeps the waybar Claude module and the workspace modules up to date
  rename  asks for a label for the active window through the DMS launcher; a lone "-" removes it
  switch  picks any window through the DMS launcher and focuses it

Everything lives under $XDG_RUNTIME_DIR/claude-hypr, so it survives a Hyprland config reload and is wiped
at logout:
  labels.json         {window address: label}
  state/<session>.json  written by the Claude Code hook: {"state": "done"|"action", "pids": [...]}
  bar/<output>.json   {"text": pango markup, "tooltip": ""}, read by the waybar custom/claude module
  bar/<output>-ws<i>.json  {"text": workspace name, "class": [...]}, read by the waybar custom/ws<i> modules
                      (plain labels that cannot be clicked)

A state file belongs to the window whose pid is the first of its "pids" that matches a Hyprland client.
A window shows as a Claude window when it has a label, a state, or "Claude Code" in its title.

Hyprland is driven over its two sockets: requests (.socket.sock) and events (.socket2.sock). The config is
Lua, so windows are focused and the pointer is moved with Lua dispatchers. The daemon never changes the
borders of a window.
"""
import fcntl
import html
import json
import logging
import os
import re
import select
import signal
import socket
import subprocess
import sys
import time
from typing import NamedTuple, Optional

RUNTIME_DIR = os.environ.get("XDG_RUNTIME_DIR") or f"/run/user/{os.getuid()}"
BASE_DIR = os.path.join(RUNTIME_DIR, "claude-hypr")
LABELS_FILE = os.path.join(BASE_DIR, "labels.json")
STATE_DIR = os.path.join(BASE_DIR, "state")
BAR_DIR = os.path.join(BASE_DIR, "bar")
LOCK_FILE = os.path.join(BASE_DIR, "daemon.lock")
COLORS_FILE = os.path.expanduser("~/.cache/hypr-theme/colors.json")

# Hyprland closes the event socket's connection only when it exits; the files are polled at this interval.
POLL_INTERVAL_S = 1.0
# Events arriving in a burst trigger a single refresh, delayed by at most MAX_DELAY_S.
DEBOUNCE_S = 0.03
MAX_DELAY_S = 0.25
# Consecutive failed connections to the event socket (missing or refused: Hyprland has exited, which leaves
# the socket file behind) before the daemon gives up.
MAX_CONNECT_FAILURES = 10
# How long a new daemon waits for the daemon of a previous Hyprland instance to release the lock.
LOCK_TAKEOVER_S = 5.0
# Claude Code keeps this in the terminal title, after a status glyph.
CLAUDE_TITLE = "Claude Code"
UNNAMED = "sans nom"
BAR_SEPARATOR = "  "
# waybar's custom/claude module refreshes on SIGRTMIN+8.
WAYBAR_SIGNAL = signal.SIGRTMIN + 8
# A waybar that has not installed its handler yet is signalled again at the next polls, up to this many times.
MAX_SIGNAL_RETRIES = 30
STATES = ("done", "action")
# Workspace order of the window picker.
WORKSPACE_ORDER = ("Work", "Dev", "www", "www-2", "Data", "Audio", "Other")
# Hyprland events after which the windows, workspaces or monitors may have changed.
REFRESH_EVENTS = {
    "activewindowv2", "openwindow", "closewindow", "movewindowv2", "workspacev2", "focusedmonv2",
    "moveworkspacev2", "createworkspacev2", "destroyworkspacev2", "monitoraddedv2", "monitorremovedv2",
    "changefloatingmode", "togglegroup", "moveintogroup", "moveoutofgroup", "configreloaded",
}
DEFAULT_COLORS = {"foreground": "#ffffff", "claude_label": "#aaaaaa", "active": "#ffffff",
                  "claude_done": "#66cc66", "claude_action": "#ff6666"}

_CONTROL_CHARS = re.compile(r"[\x00-\x1f\x7f]")
_ADDRESS = re.compile(r"^0x[0-9a-f]+$")
_HEX_COLOR = re.compile(r"^#[0-9a-fA-F]{6}$")

log = logging.getLogger("claude_hypr")


# ---------------------------------------------------------------------------------------------------------
# Pure helpers
# ---------------------------------------------------------------------------------------------------------

def normalize_address(value):
    """Canonical "0x..." form of a window address, from an event ("55d1c0") or the JSON ("0x55d1c0").

    Returns None for an empty or null address.
    """
    text = str(value or "").strip().lower()
    if not text:
        return None
    if not text.startswith("0x"):
        text = "0x" + text
    try:
        if int(text, 16) == 0:
            return None
    except ValueError:
        return None
    return text


def parse_event(line):
    """Splits a socket2 line "name>>data"; returns None for anything else."""
    name, sep, data = line.partition(">>")
    if not sep or not name:
        return None
    return name, data


def clean_text(text):
    """One line of text with no control characters, which picker rows and markup cannot carry."""
    return " ".join(_CONTROL_CHARS.sub(" ", str(text)).split())


def window_name(client, labels):
    """Label, otherwise title, otherwise class."""
    return labels.get(client_address(client)) or client.get("title") or client.get("class") or "?"


def client_address(client):
    return normalize_address(client.get("address"))


def workspace_name(client):
    workspace = client.get("workspace")
    return workspace.get("name") if isinstance(workspace, dict) else None


def is_claude(client, labels, states):
    address = client_address(client)
    return address in labels or address in states or CLAUDE_TITLE in (client.get("title") or "")


class StateFile(NamedTuple):
    path: str
    state: str
    pids: list
    mtime: int
    # The Claude Code process itself, when the hook recorded it.
    claude_pid: Optional[int] = None


def _is_pid(value):
    return isinstance(value, int) and not isinstance(value, bool)


def load_states(state_dir):
    """Reads the hook's state files; unreadable or malformed ones are skipped."""
    found = []
    try:
        names = os.listdir(state_dir)
    except OSError:
        return found
    for name in names:
        if not name.endswith(".json"):
            continue
        path = os.path.join(state_dir, name)
        try:
            with open(path) as f:
                data = json.load(f)
            mtime = os.stat(path).st_mtime_ns
        except (OSError, ValueError):
            continue
        state = data.get("state") if isinstance(data, dict) else None
        pids = data.get("pids") if isinstance(data, dict) else None
        if state not in STATES or not isinstance(pids, list):
            continue
        claude_pid = data.get("claude_pid")
        found.append(StateFile(path, state, [p for p in pids if _is_pid(p)], mtime,
                               claude_pid if _is_pid(claude_pid) else None))
    return found


def pids_by_client(clients):
    """{pid: window address} of the Hyprland clients; the first client wins when several share a pid."""
    by_pid = {}
    for client in clients:
        address = client_address(client)
        if address and _is_pid(client.get("pid")):
            by_pid.setdefault(client["pid"], address)
    return by_pid


def window_of(pids, by_pid):
    """The window a state file belongs to: the client matching the first of its pids that matches one."""
    return next((by_pid[p] for p in pids if p in by_pid), None)


def associate(state_files, clients):
    """Maps window addresses to their state: {address: (state, path)}.

    When several files land on the same window, the most recently written wins.
    """
    by_pid = pids_by_client(clients)
    result = {}
    for path, state, pids, mtime in sorted((f[:4] for f in state_files), key=lambda f: f[3]):
        address = window_of(pids, by_pid)
        if address:
            result[address] = (state, path)
    return result


def is_dead(pids, client_pids, pid_alive, claude_pid=None):
    """True when the Claude Code session behind a state file is gone.

    The session is the recorded Claude process when there is one. Otherwise every pid before the terminal
    (the first pid that is a client) is watched, so the session counts as gone only once the shell it was
    started from has exited too; the terminal and its ancestors are left out because they outlive Claude.
    Without a matching client, the first pid and its parent are watched.
    """
    if claude_pid is not None:
        watched = [claude_pid]
    else:
        index = next((i for i, p in enumerate(pids) if p in client_pids), None)
        watched = pids[:2] if index is None else pids[:max(index, 1)]
    return not any(pid_alive(p) for p in watched)


def proc_alive(pid):
    return os.path.exists(f"/proc/{pid}")


def purge_labels(labels, live_addresses):
    """The labels of windows that still exist."""
    return {address: label for address, label in labels.items() if address in live_addresses}


def attention_colors(colors):
    return {"done": colors["claude_done"], "action": colors["claude_action"]}


def render_bar(monitors, workspaces, clients, labels, states, colors):
    """The custom/claude payload of each output: {output name: {"text": ..., "tooltip": ""}}.

    Each output lists the Claude windows of its active workspace, from top to bottom then left to right.
    A label takes the state colour of its window, otherwise `foreground` for the workspace's last focused
    window, which is also underlined in `active`, otherwise `claude_label`.
    """
    state_colors = attention_colors(colors)
    last_focused = {w.get("name"): normalize_address(w.get("lastwindow")) for w in workspaces}
    payloads = {}
    for monitor in monitors:
        output = monitor.get("name")
        active = monitor.get("activeWorkspace")
        name = active.get("name") if isinstance(active, dict) else None
        if not output:
            continue
        members = [c for c in clients if c.get("mapped", True) and name and workspace_name(c) == name
                   and is_claude(c, labels, states)]
        members.sort(key=lambda c: _position_key(c))
        parts = []
        for client in members:
            address = client_address(client)
            focused = address is not None and address == last_focused.get(name)
            colour = state_colors[states[address]] if address in states else (
                colors["foreground"] if focused else colors["claude_label"])
            text = html.escape(clean_text(labels.get(address, "")) or UNNAMED, quote=False)
            attributes = f'foreground="{colour}"'
            if focused:
                attributes += f' underline="single" underline_color="{colors["active"]}"'
            parts.append(f"<span {attributes}>{text}</span>")
        payloads[output] = {"text": BAR_SEPARATOR.join(parts), "tooltip": ""}
    return payloads


def render_workspaces(monitors, workspaces):
    """The custom/ws<i> payloads: {"<output>-ws<i>": {"text": name, "class": [...]}} for each output and each
    workspace of WORKSPACE_ORDER (i from 1).

    Classes: "occupied" or "empty", plus one position class: "here-focused" when the workspace is the active
    one of this output and this output has the focus, "here" when it is active on this output without the
    focus, "elsewhere" when it is the active workspace of another output.
    """
    windows = {w.get("name"): w.get("windows") or 0 for w in workspaces}
    active = {m.get("name"): (m.get("activeWorkspace") or {}).get("name") for m in monitors}
    payloads = {}
    for monitor in monitors:
        output = monitor.get("name")
        if not output:
            continue
        for index, name in enumerate(WORKSPACE_ORDER, 1):
            classes = ["occupied" if windows.get(name) else "empty"]
            if active.get(output) == name:
                classes.append("here-focused" if monitor.get("focused") else "here")
            elif name in (v for o, v in active.items() if o != output):
                classes.append("elsewhere")
            payloads[f"{output}-ws{index}"] = {"text": name, "class": classes}
    return payloads


def _position_key(client):
    at = client.get("at") or [0, 0]
    grouped = [normalize_address(a) for a in client.get("grouped") or []]
    address = client_address(client)
    return (at[1], at[0], grouped.index(address) if address in grouped else 0, address or "")


def switch_rows(clients, labels, states):
    """The window picker: (rows, addresses, row states), windows waiting for an action first, then finished
    ones, then the others, each by workspace order and name."""
    rank = {"action": 0, "done": 1}
    order = {name: i for i, name in enumerate(WORKSPACE_ORDER)}
    windows = [c for c in clients if c.get("mapped", True) and client_address(c)]
    windows.sort(key=lambda c: (rank.get(states.get(client_address(c)), len(rank)),
                                order.get(workspace_name(c), len(order)),
                                clean_text(window_name(c, labels)).casefold()))
    # Rows stay plain text: the picker filters on the raw row, markup included.
    rows = [f"{clean_text(window_name(c, labels)) or '?'}  {clean_text(workspace_name(c) or '')}" for c in windows]
    return rows, [client_address(c) for c in windows], [states.get(client_address(c)) for c in windows]


def state_marks(row_states):
    """Picker arguments that mark rows waiting for an action as urgent and finished ones as active."""
    args = []
    for flag, state in (("-u", "action"), ("-a", "done")):
        indexes = [str(i) for i, s in enumerate(row_states) if s == state]
        if indexes:
            args += [flag, ",".join(indexes)]
    return args


def focus_lua(address):
    if not _ADDRESS.match(address):
        raise ValueError(f"bad window address: {address!r}")
    return f'hl.dsp.focus({{ window = "address:{address}" }})'


def cursor_lua(client):
    """Moves the pointer to the centre of `client`, or None when its geometry is missing."""
    try:
        (x, y), (w, h) = client["at"], client["size"]
        return f"hl.dsp.cursor.move({{ x = {int(x + w // 2)}, y = {int(y + h // 2)} }})"
    except (KeyError, TypeError, ValueError):
        return None


def write_atomic(path, content):
    os.makedirs(os.path.dirname(path), mode=0o700, exist_ok=True)
    tmp = f"{path}.{os.getpid()}.tmp"
    with open(tmp, "w") as f:
        f.write(content)
    os.replace(tmp, path)


def load_labels(path=None):
    try:
        with open(path or LABELS_FILE) as f:
            return {str(a): str(label) for a, label in json.load(f).items() if normalize_address(a)}
    except (OSError, ValueError, AttributeError):
        return {}


def save_labels(labels, path=None):
    write_atomic(path or LABELS_FILE, json.dumps(labels))


def load_colors(path=None):
    """The theme colours, with fallbacks for a missing file or missing names."""
    colors = dict(DEFAULT_COLORS)
    try:
        with open(path or COLORS_FILE) as f:
            data = json.load(f)
        colors.update({k: v for k, v in data.items() if isinstance(v, str) and _HEX_COLOR.match(v)})
    except (OSError, ValueError, AttributeError):
        pass
    return colors


# ---------------------------------------------------------------------------------------------------------
# Hyprland IPC
# ---------------------------------------------------------------------------------------------------------

class Ipc:
    """The two Hyprland sockets of the running instance."""

    def __init__(self, signature=None, runtime_dir=None):
        signature = signature or os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
        if not signature:
            raise RuntimeError("HYPRLAND_INSTANCE_SIGNATURE is not set: not running under Hyprland")
        directory = os.path.join(runtime_dir or RUNTIME_DIR, "hypr", signature)
        self.signature = signature
        self.request_path = os.path.join(directory, ".socket.sock")
        self.events_path = os.path.join(directory, ".socket2.sock")

    def request(self, text, timeout=5.0):
        """One request on its own connection; Hyprland closes it after the reply."""
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
            sock.settimeout(timeout)
            sock.connect(self.request_path)
            sock.sendall(text.encode())
            chunks = []
            while True:
                chunk = sock.recv(65536)
                if not chunk:
                    break
                chunks.append(chunk)
        return b"".join(chunks).decode("utf-8", "replace")

    def query(self, command):
        """The JSON answer of `hyprctl -j <command>`, or None when it is unavailable or malformed."""
        try:
            return json.loads(self.request("j/" + command))
        except (OSError, ValueError) as error:
            log.warning("query %s failed: %s", command, error)
            return None

    def dispatch_many(self, expressions):
        """Runs Lua dispatcher expressions in one batch; returns the replies."""
        if not expressions:
            return []
        try:
            reply = self.request("[[BATCH]]" + ";".join("dispatch " + e for e in expressions))
        except OSError as error:
            log.warning("dispatch failed: %s", error)
            return []
        return reply.split("\n\n\n")

    def dispatch(self, expression):
        return self.dispatch_many([expression])

    def connect_events(self):
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        try:
            sock.connect(self.events_path)
        except OSError:
            sock.close()
            raise
        return sock


# ---------------------------------------------------------------------------------------------------------
# Daemon
# ---------------------------------------------------------------------------------------------------------

class Daemon:
    def __init__(self, ipc, state_dir=STATE_DIR, labels_file=LABELS_FILE, bar_dir=BAR_DIR,
                 colors_file=COLORS_FILE, pid_alive=proc_alive, signal_waybar=None):
        self.ipc = ipc
        self.state_dir = state_dir
        self.labels_file = labels_file
        self.bar_dir = bar_dir
        self.colors_file = colors_file
        self.pid_alive = pid_alive
        self.signal_waybar = signal_waybar or send_waybar_signal
        self.signal_pending = 0
        self.labels = load_labels(labels_file)
        self.written = {}
        self.window_files = {}
        self.claude_titles = {}
        self.known_files = []
        self.client_pids = set()
        self.fingerprint = None
        self.dirty = True
        self.dirty_since = time.monotonic()
        self.retry_at = 0.0

    # -- events -------------------------------------------------------------------------------------------

    def mark_dirty(self):
        if not self.dirty:
            self.dirty = True
            self.dirty_since = time.monotonic()

    def handle_event(self, name, data):
        if name == "windowtitlev2":
            address, _, title = data.partition(",")
            known = self.claude_titles.get(normalize_address(address))
            # Claude Code animates its title while working: only a change of membership needs a redraw.
            if known is None or known != (CLAUDE_TITLE in title):
                self.mark_dirty()
        elif name == "closewindow":
            self.forget_window(normalize_address(data))
            self.mark_dirty()
        elif name in REFRESH_EVENTS:
            self.mark_dirty()

    def forget_window(self, address):
        """Drops what is tied to a closed window; its label goes with the next refresh."""
        if address is None:
            return
        self.claude_titles.pop(address, None)
        for path in self.window_files.pop(address, []):
            remove_quietly(path)

    # -- files --------------------------------------------------------------------------------------------

    def files_fingerprint(self):
        parts = []
        for path in (self.labels_file, self.colors_file):
            try:
                parts.append(os.stat(path).st_mtime_ns)
            except OSError:
                parts.append(None)
        try:
            with os.scandir(self.state_dir) as entries:
                for entry in sorted(entries, key=lambda e: e.name):
                    if entry.name.endswith(".json"):
                        stat = entry.stat()
                        parts.append((entry.name, stat.st_mtime_ns, stat.st_size))
        except OSError:
            pass
        return parts

    def poll_files(self):
        """Marks the daemon dirty when the state files, labels or colours changed, or a session died."""
        fingerprint = self.files_fingerprint()
        if fingerprint != self.fingerprint:
            self.fingerprint = fingerprint
            self.mark_dirty()
        if self.signal_pending:
            self.notify_waybar(self.signal_pending - 1)
        if any(is_dead(f.pids, self.client_pids, self.pid_alive, f.claude_pid) for f in self.known_files):
            self.mark_dirty()

    # -- refresh ------------------------------------------------------------------------------------------

    def refresh(self):
        """Reads Hyprland and the files, then updates the bar. Returns False when the
        windows could not be read, in which case nothing changes."""
        # Taken before reading anything, so that a file written during the refresh triggers another one.
        fingerprint = self.files_fingerprint()
        clients = self.ipc.query("clients")
        monitors = self.ipc.query("monitors")
        workspaces = self.ipc.query("workspaces")
        if not (isinstance(clients, list) and isinstance(monitors, list) and isinstance(workspaces, list)):
            return False
        self.labels = purge_and_reload_labels(self.labels_file, clients)
        colors = load_colors(self.colors_file)

        by_pid = pids_by_client(clients)
        self.client_pids = set(by_pid)
        files = []
        for entry in load_states(self.state_dir):
            if is_dead(entry.pids, self.client_pids, self.pid_alive, entry.claude_pid):
                remove_quietly(entry.path)
            else:
                files.append(entry)
        self.known_files = files
        states = {address: state for address, (state, _path) in associate(files, clients).items()}
        self.window_files = {}
        for entry in files:
            address = window_of(entry.pids, by_pid)
            if address:
                self.window_files.setdefault(address, []).append(entry.path)
        self.claude_titles = {client_address(c): CLAUDE_TITLE in (c.get("title") or "")
                              for c in clients if client_address(c)}

        self.update_bar(monitors, workspaces, clients, states, colors)
        self.fingerprint = fingerprint
        self.dirty = False
        return True

    def update_bar(self, monitors, workspaces, clients, states, colors):
        payloads = render_bar(monitors, workspaces, clients, self.labels, states, colors)
        payloads.update(render_workspaces(monitors, workspaces))
        changed = False
        for output, payload in payloads.items():
            content = json.dumps(payload, ensure_ascii=False)
            if self.written.get(output) == content:
                continue
            try:
                write_atomic(os.path.join(self.bar_dir, f"{output}.json"), content)
            except OSError as error:
                log.warning("writing the bar of %s failed: %s", output, error)
                continue
            self.written[output] = content
            changed = True
        for output in [o for o in self.written if o not in payloads]:
            remove_quietly(os.path.join(self.bar_dir, f"{output}.json"))
            del self.written[output]
            changed = True
        if changed:
            self.notify_waybar(MAX_SIGNAL_RETRIES)

    def notify_waybar(self, retries):
        self.signal_pending = 0 if self.signal_waybar() is not False else retries

    def safe_refresh(self):
        try:
            if not self.refresh():
                # Hyprland did not answer properly: try again shortly.
                self.retry_at = time.monotonic() + POLL_INTERVAL_S
        except Exception:  # noqa: BLE001 - the daemon must keep running
            log.exception("refresh failed")
            self.dirty = False

    # -- main loop ----------------------------------------------------------------------------------------

    def serve(self, sock):
        """Handles events from one connection until it closes."""
        self.mark_dirty()
        buffer = b""
        next_poll = time.monotonic() + POLL_INTERVAL_S
        while True:
            now = time.monotonic()
            wait = max(0.0, next_poll - now)
            if self.dirty:
                wait = min(wait, DEBOUNCE_S)
            readable, _, _ = select.select([sock], [], [], wait)
            if readable:
                chunk = sock.recv(65536)
                if not chunk:
                    raise ConnectionError("event socket closed")
                buffer += chunk
                *lines, buffer = buffer.split(b"\n")
                for line in lines:
                    event = parse_event(line.decode("utf-8", "replace"))
                    if event:
                        self.handle_event(*event)
            now = time.monotonic()
            if now >= next_poll:
                next_poll = now + POLL_INTERVAL_S
                self.poll_files()
                burst_over = True
            else:
                burst_over = not readable or now - self.dirty_since >= MAX_DELAY_S
            if self.dirty and burst_over and now >= self.retry_at:
                self.safe_refresh()

    def run(self):
        failures = 0
        while True:
            try:
                sock = self.ipc.connect_events()
            except OSError as error:
                failures += 1
                if failures >= MAX_CONNECT_FAILURES:
                    log.info("Hyprland instance is gone, exiting")
                    return
                log.warning("cannot connect to the event socket: %s", error)
                time.sleep(1)
                continue
            failures = 0
            try:
                self.serve(sock)
            except (OSError, ConnectionError) as error:
                log.warning("event connection lost: %s", error)
            except Exception:  # noqa: BLE001 - the daemon must keep running
                log.exception("event loop failed")
            finally:
                sock.close()
            time.sleep(1)


def purge_and_reload_labels(path, clients):
    """The labels from disk (the rename command writes them), without those of vanished windows.

    The file is rewritten only when something was dropped.
    """
    labels = load_labels(path)
    live = {client_address(c) for c in clients}
    kept = purge_labels(labels, live)
    if kept != labels:
        try:
            save_labels(kept, path)
        except OSError as error:
            log.warning("saving labels failed: %s", error)
    return kept


def remove_quietly(path):
    try:
        os.remove(path)
    except OSError:
        pass


def send_waybar_signal(proc_root="/proc", send=os.kill):
    """Sends SIGRTMIN+8 to this user's waybar processes. Returns False when one of them has not installed
    a handler for it yet: the default action of that signal would terminate it, so it is left alone.
    """
    complete = True
    mask = 1 << (WAYBAR_SIGNAL - 1)
    try:
        names = os.listdir(proc_root)
    except OSError:
        return True
    for name in names:
        if not name.isdigit():
            continue
        directory = os.path.join(proc_root, name)
        try:
            with open(os.path.join(directory, "comm")) as f:
                if f.read().strip() != "waybar" or os.stat(directory).st_uid != os.getuid():
                    continue
            with open(os.path.join(directory, "status")) as f:
                caught = next((int(line.split()[1], 16) for line in f if line.startswith("SigCgt:")), 0)
            if caught & mask:
                send(int(name), WAYBAR_SIGNAL)
            else:
                complete = False
        except (OSError, ValueError, IndexError):
            continue
    return complete


def read_lock_holder(fd):
    """{"signature": ..., "pid": ...} written by the daemon holding the lock, or None."""
    try:
        data = json.loads(os.pread(fd, 4096, 0).decode("utf-8", "replace"))
    except (OSError, ValueError):
        return None
    return data if isinstance(data, dict) else None


def is_daemon_process(pid):
    """True when the pid is a claude_hypr daemon: a recycled pid must never be signalled."""
    try:
        with open(f"/proc/{pid}/cmdline", "rb") as f:
            words = f.read().split(b"\0")
    except OSError:
        return False
    return any(w.endswith(b"claude_hypr.py") for w in words) and b"daemon" in words


def hyprland_instance_alive(signature):
    """True when a Hyprland instance still accepts connections on its event socket."""
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    try:
        sock.settimeout(1.0)
        sock.connect(os.path.join(RUNTIME_DIR, "hypr", signature, ".socket2.sock"))
    except OSError:
        return False
    finally:
        sock.close()
    return True


def acquire_lock(path=LOCK_FILE, signature="", takeover_s=LOCK_TAKEOVER_S, kill=os.kill,
                 is_daemon=is_daemon_process, sleep=time.sleep, instance_alive=hyprland_instance_alive):
    """An exclusive lock held for the life of the process, recording this daemon's pid and Hyprland instance.

    Returns None when a daemon of the same instance holds it, or of another instance that is still running
    (a nested Hyprland). A daemon whose instance has gone is asked to terminate and the lock is taken once
    it is released, within `takeover_s`.
    """
    os.makedirs(os.path.dirname(path), mode=0o700, exist_ok=True)
    fd = os.open(path, os.O_RDWR | os.O_CREAT, 0o600)
    deadline = time.monotonic() + takeover_s
    asked = False
    while True:
        try:
            fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
            break
        except OSError:
            pass
        holder = read_lock_holder(fd)
        if holder and holder.get("signature") == signature:
            os.close(fd)
            return None
        pid = holder.get("pid") if holder else None
        other = holder.get("signature") if holder else None
        if not asked and isinstance(other, str) and other and instance_alive(other):
            log.info("a daemon of the running Hyprland instance %s holds the lock", other)
            os.close(fd)
            return None
        if not asked and _is_pid(pid) and is_daemon(pid):
            asked = True
            try:
                kill(pid, signal.SIGTERM)
            except OSError:
                pass
        if time.monotonic() >= deadline:
            os.close(fd)
            return None
        sleep(0.1)
    os.ftruncate(fd, 0)
    os.pwrite(fd, json.dumps({"signature": signature, "pid": os.getpid()}).encode(), 0)
    return fd


# ---------------------------------------------------------------------------------------------------------
# Picker commands
# ---------------------------------------------------------------------------------------------------------

# The answer to the rename prompt that removes the label: the DMS prompt ignores Enter on an empty field.
REMOVE_LABEL = "-"

# Shows a `dms dmenu` in the launcher chosen for the session: the one of the bar, or the DMS one.
PICKER = "/home/alexis/bin/hyprland-theme-picker"


def picker(*args, rows=None):
    """Runs a `dms dmenu` in the session's chosen launcher and returns its output, or None when it is
    cancelled or fails."""
    try:
        result = subprocess.run([PICKER, "dmenu", *args], input=None if rows is None else "\n".join(rows),
                                stdin=subprocess.DEVNULL if rows is None else None,
                                stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
    except OSError as error:
        log.error("the picker failed: %s", error)
        return None
    # The picker exits with 1 when cancelled; dms dmenu exits with 2 when the DMS shell is not running.
    if result.returncode == 2:
        log.error("the picker failed: the DMS shell is not running")
    elif result.returncode not in (0, 1):
        log.error("the picker failed with exit code %s", result.returncode)
    if result.returncode != 0:
        return None
    return result.stdout.strip()


def rename_command(ipc):
    active = ipc.query("activewindow")
    address = normalize_address(active.get("address")) if isinstance(active, dict) else None
    if address is None:
        return 0
    label = picker("--prompt-only", "-p", "Nom de la fenêtre", "--placeholder", load_labels().get(address, ""),
                   "--mesg", f"« {REMOVE_LABEL} » retire le nom")
    clients = ipc.query("clients")
    if not label or not isinstance(clients, list) or address not in {client_address(c) for c in clients}:
        return 0
    labels = load_labels()
    if label != REMOVE_LABEL:
        labels[address] = label
    else:
        labels.pop(address, None)
    save_labels(labels)
    return 0


def switch_command(ipc):
    clients = ipc.query("clients")
    if not isinstance(clients, list):
        return 1
    states = {a: s for a, (s, _p) in associate(load_states(STATE_DIR), clients).items()}
    rows, addresses, row_states = switch_rows(clients, load_labels(), states)
    if not rows:
        return 0
    index = picker("--no-custom", "--format", "i", *state_marks(row_states), "-p", "Fenêtre", rows=rows)
    if not index or not index.isdigit() or int(index) >= len(addresses):
        return 0
    address = addresses[int(index)]
    for reply in ipc.dispatch(focus_lua(address)):
        if not reply.strip().startswith("ok"):
            log.warning("focusing the picked window failed: %s", reply.strip())
    # Focus follows the pointer: once the picker closes, Hyprland refocuses the window under it, so the
    # pointer moves to the picked window, whose position is read after the focus switched workspaces.
    clients = ipc.query("clients")
    picked = next((c for c in clients if client_address(c) == address), None) if isinstance(clients, list) else None
    move = cursor_lua(picked) if picked else None
    if move:
        ipc.dispatch(move)
    return 0


def daemon_command(ipc):
    lock = acquire_lock(signature=ipc.signature)
    if lock is None:
        log.info("another daemon is already running")
        return 0
    signal.signal(signal.SIGTERM, lambda *_: sys.exit(0))
    Daemon(ipc).run()
    return 0


def main(argv):
    logging.basicConfig(level=logging.INFO, stream=sys.stderr, format="claude_hypr: %(levelname)s %(message)s")
    commands = {"daemon": daemon_command, "rename": rename_command, "switch": switch_command}
    if len(argv) != 2 or argv[1] not in commands:
        print(f"usage: {os.path.basename(argv[0])} daemon|rename|switch", file=sys.stderr)
        return 2
    try:
        return commands[argv[1]](Ipc())
    except KeyboardInterrupt:
        return 0
    except Exception:  # noqa: BLE001 - report on stderr, never a traceback in the compositor's log
        log.exception("%s failed", argv[1])
        return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))

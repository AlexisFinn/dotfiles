#!/bin/bash
# Session services, started once by hyprland.lua when the compositor is ready.

hypr_dir=/home/alexis/.config/hypr
start() {
    if command -v "$1" >/dev/null 2>&1; then
        "$@" &
    else
        echo "autostart: $1 not found" >&2
    fi
}

# The systemd and D-Bus activation environments are shared with other
# sessions: only the variables specific to this compositor are exported.
dbus-update-activation-environment --systemd \
    WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE 2>/dev/null

# The compositor configuration reads the theme at load time: --reload reloads it
# when the regenerated theme differs.
# Plugins enabled with hyprpm; -n keeps it from notifying.
hyprpm reload -n || echo "autostart: hyprpm reload failed" >&2

"$hypr_dir/scripts/gen-colors.py" --reload || echo "autostart: gen-colors.py failed" >&2

# Software dimming of every monitor; the backlight itself is left untouched.
start hyprsunset --gamma 60 --temperature 6000
start "$hypr_dir/claude/claude_hypr.py" daemon
# Bar, wallpaper, notifications, launcher, lock screen and polkit agent.
start dms run

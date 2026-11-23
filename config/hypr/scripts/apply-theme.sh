#!/bin/bash
# Applies the current wpg/wal palette and wallpaper to the running Hyprland session.
set -u

hypr_dir=/home/alexis/.config/hypr

if [ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    echo "apply-theme: not running under Hyprland" >&2
    exit 1
fi

"$hypr_dir/scripts/gen-colors.py" || { echo "apply-theme: gen-colors.py failed" >&2; exit 1; }
"$hypr_dir/scripts/gen-borders.py" || echo "apply-theme: gen-borders.py failed" >&2

# hyprland.lua reads the colours at load time.
hyprctl reload >/dev/null

# DMS draws the wallpaper; its bar colours follow it.
wallpaper=$(python3 -c 'import json; print(json.load(open("/home/alexis/.cache/hypr-theme/colors.json"))["wallpaper"])')
dms ipc call wallpaper set "$wallpaper" >/dev/null 2>&1 || echo "apply-theme: DMS did not take the wallpaper" >&2

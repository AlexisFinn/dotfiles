#!/usr/bin/env python3
"""Generate the Hyprland session theme from the wal palette (set by wpgtk).

Loads the palette, derives the accent colours with the same computations as the
qtile configuration, and writes the result atomically to ~/.cache/hypr-theme/ in four formats:

  colors.json  flat {name: "#rrggbb"} object plus "wallpaper"
  colors.css   one "@define-color name #rrggbb;" line per colour (waybar)
  colors.conf  hyprlang variables "$name = rgb(rrggbb)" (hyprlock, hyprpaper)
  colors.lua   a Lua table returned by the file (hyprland.lua)

With --reload, Hyprland reloads its configuration when the generated colours changed.
"""
import importlib.util
import json
import os
import subprocess
import sys
import tempfile

from colour import Color

PALETTE_PATH = "/home/alexis/.config/qtile/PyColors.py"
OUTPUT_DIR = "/home/alexis/.cache/hypr-theme"


def load_palette(path):
    spec = importlib.util.spec_from_file_location("PyColors", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


PyColors = load_palette(PALETTE_PATH)


def make_inactive_color(active_color):
    InactiveColor = Color(active_color)
    if (InactiveColor.get_saturation() >= 0.3):
        InactiveColor.set_saturation(InactiveColor.get_saturation() - 0.3)
    if (InactiveColor.get_red() >= 0.2):
        InactiveColor.set_red(InactiveColor.get_red() - 0.2)
    if (InactiveColor.get_green() >= 0.2):
        InactiveColor.set_green(InactiveColor.get_green() - 0.2)
    if (InactiveColor.get_blue() >= 0.2):
        InactiveColor.set_blue(InactiveColor.get_blue() - 0.2)

    return InactiveColor.get_hex_l()


def color_contrast_difference(color1, color2):
    Color1 = Color(color1)
    Color2 = Color(color2)
    redVal = (Color1.get_red() * 255) - (Color2.get_red() * 255)
    greenVal = (Color1.get_green() * 255) - (Color2.get_green() * 255)
    blueVal = (Color1.get_blue() * 255) - (Color2.get_blue() * 255)

    return abs(redVal) + abs(greenVal) + abs(blueVal)


def make_foreground_color(background_color):
    if (color_contrast_difference(background_color, PyColors.foreground) > 280):
        return PyColors.foreground

    return PyColors.background


def colors_equal(color1, color2):
    Color1 = Color(color1)
    Color2 = Color(color2)

    return Color1.get_hex_l() == Color2.get_hex_l()


def get_standout_color():
    colors = [
            PyColors.color1,
            PyColors.color2,
            PyColors.color3,
            PyColors.color4,
            PyColors.color5,
            PyColors.color6,
            PyColors.color7,
            PyColors.color8,
            PyColors.color9
            ]
    results = [0] * len(colors)
    for index, color1 in enumerate(colors):
        for color2 in colors:
            if not colors_equal(color1, color2):
                results[index] += color_contrast_difference(color1, color2)
    max_contrast = max(results)
    max_index = results.index(max_contrast)

    return colors[max_index]


def _hue_distance(hue, others):
    return min((min(abs(hue - h), 1 - abs(hue - h)) for h in others), default=0.5)


def _hues(colors, min_saturation=0.15):
    """Hues of the colours that have one: greys are left out, their hue is meaningless."""
    return [Color(c).get_hue() for c in colors if Color(c).get_saturation() >= min_saturation]


def get_distinct_color(*avoid, luminance=0.65):
    """Returns the palette accent whose hue is furthest from every colour in `avoid`, lightened to
    `luminance` so it stays readable on the dark bar."""
    accents = [PyColors.color1, PyColors.color2, PyColors.color3,
               PyColors.color4, PyColors.color5, PyColors.color6]
    hues = _hues(avoid)
    color = Color(max(accents, key=lambda c: _hue_distance(Color(c).get_hue(), hues)))
    color.set_luminance(luminance)
    return color.get_hex_l()


def get_theme_saturation(low=0.3, high=0.4):
    """Median saturation of the palette accents, kept within pastel bounds."""
    saturations = sorted(Color(c).get_saturation() for c in [
        PyColors.color1, PyColors.color2, PyColors.color3,
        PyColors.color4, PyColors.color5, PyColors.color6])
    return min(max(saturations[len(saturations) // 2], low), high)


def get_signal_color(target_hue, hue_range, *avoid, min_gap=40, saturation=0.45, luminance=0.65):
    """Returns a saturated colour whose hue (degrees) lies in `hue_range`, as close as possible to
    `target_hue` while staying at least `min_gap` degrees from every colour in `avoid`. When the
    whole range is too close, returns the hue of the range that is furthest from them.
    `hue_range` is (start, end) going clockwise, so (320, 60) spans red."""
    hues = _hues(avoid)
    start, end = hue_range
    span = (end - start) % 360
    candidates = [((start + step) % 360) / 360 for step in range(0, span + 1, 5)]
    allowed = [h for h in candidates if _hue_distance(h, hues) >= min_gap / 360]
    if allowed:
        hue = min(allowed, key=lambda h: _hue_distance(h, [target_hue / 360]))
    else:
        hue = max(candidates, key=lambda h: _hue_distance(h, hues))
    return Color(hsl=(hue, saturation, luminance)).get_hex_l()


def compute_colors():
    """Returns the ordered {name: "#rrggbb"} mapping of every theme colour."""
    active_color = get_standout_color()
    active_color_alt = PyColors.color5
    inactive_color = PyColors.background
    inactive_color_alt = make_inactive_color(active_color_alt)
    claude_label_color = get_distinct_color(
        active_color, active_color_alt, Color(hsl=(15 / 360, 0.75, 0.6)).get_hex_l(),
        Color(hsl=(120 / 360, 0.75, 0.6)).get_hex_l())
    claude_signal_tone = dict(saturation=get_theme_saturation(), luminance=0.65)
    claude_action_color = get_signal_color(
        15, (330, 60), active_color, active_color_alt, claude_label_color, **claude_signal_tone)
    claude_done_color = get_signal_color(
        120, (80, 180), active_color, active_color_alt, claude_label_color, claude_action_color,
        min_gap=60, **claude_signal_tone)

    colors = {
        "background": PyColors.background,
        "foreground": PyColors.foreground,
    }
    for index in range(16):
        colors["color%d" % index] = getattr(PyColors, "color%d" % index)
    colors.update({
        "active": active_color,
        "active_alt": active_color_alt,
        "inactive": inactive_color,
        "inactive_alt": inactive_color_alt,
        "claude_label": claude_label_color,
        "claude_done": claude_done_color,
        "claude_action": claude_action_color,
    })
    for index in range(1, 10):
        colors["fg_on_color%d" % index] = make_foreground_color(colors["color%d" % index])

    return {name: Color(value).get_hex_l() for name, value in colors.items()}


def render_json(colors, wallpaper):
    return json.dumps({**colors, "wallpaper": wallpaper}, indent=2) + "\n"


def render_css(colors):
    return "".join("@define-color %s %s;\n" % (name, value) for name, value in colors.items())


def render_conf(colors, wallpaper):
    lines = ["$%s = rgb(%s)\n" % (name, value.lstrip("#")) for name, value in colors.items()]
    lines.append("$wallpaper = %s\n" % wallpaper)
    return "".join(lines)


def render_lua(colors, wallpaper):
    entries = ["  %s = %s,\n" % (name, json.dumps(value)) for name, value in colors.items()]
    entries.append("  wallpaper = %s,\n" % json.dumps(wallpaper))
    return "return {\n" + "".join(entries) + "}\n"


def write_atomic(path, content):
    directory = os.path.dirname(path)
    fd, tmp_path = tempfile.mkstemp(dir=directory, prefix=".tmp-")
    try:
        with os.fdopen(fd, "w") as handle:
            handle.write(content)
        os.chmod(tmp_path, 0o644)
        os.replace(tmp_path, path)
    except BaseException:
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)
        raise


def main():
    colors = compute_colors()
    wallpaper = PyColors.wallpaper
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    outputs = {
        "colors.json": render_json(colors, wallpaper),
        "colors.css": render_css(colors),
        "colors.conf": render_conf(colors, wallpaper),
        "colors.lua": render_lua(colors, wallpaper),
    }
    changed = False
    for filename, content in outputs.items():
        path = os.path.join(OUTPUT_DIR, filename)
        try:
            with open(path) as handle:
                changed = changed or handle.read() != content
        except OSError:
            changed = True
        write_atomic(path, content)
    # hyprland.lua reads the colours at load time.
    if changed and "--reload" in sys.argv[1:] and os.environ.get("HYPRLAND_INSTANCE_SIGNATURE"):
        subprocess.run(["hyprctl", "reload"], stdout=subprocess.DEVNULL)


if __name__ == "__main__":
    sys.exit(main())

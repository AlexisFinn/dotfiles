#!/usr/bin/env python3
"""Generate the window frames drawn by the imgborders plugin from the session theme.

Each style is a nine-slice PNG: the plugin draws the four corner squares as they are and repeats
the strips between them along each side, starting from the top or left end. A frame hugs the
native border, whose rounded outer contour lies inside the corner squares; the part of each slice
that reaches over the window (the inset) stays transparent unless a style paints on it.

Reads ~/.cache/hypr-theme/colors.json and writes to ~/.cache/hypr-theme/:

  borders/<style>.png  one image per style
  borders.lua          {style = {image, sizes, insets, scale, smooth}} for hyprland.lua

The corner radius and the native border width come from the running Hyprland session.
"""
import colorsys
import json
import math
import os
import subprocess
import sys
import tempfile

import numpy as np
from PIL import Image

THEME_DIR = "/home/alexis/.cache/hypr-theme"
COLORS_PATH = os.path.join(THEME_DIR, "colors.json")
OUTPUT_DIR = os.path.join(THEME_DIR, "borders")
META_PATH = os.path.join(THEME_DIR, "borders.lua")

DEFAULT_ROUNDING = 16
DEFAULT_BORDER_SIZE = 2

SQRT1_2 = math.sqrt(0.5)


# Colours -----------------------------------------------------------------------------------------

def from_hex(value):
    value = value.lstrip("#")
    return np.array([int(value[i:i + 2], 16) / 255 for i in (0, 2, 4)])


def hls(color):
    return colorsys.rgb_to_hls(*color)


def toned(color, luminance=None, saturation=None, max_saturation=None):
    """Returns `color` with its hue kept and its luminance or saturation replaced or capped."""
    hue, lum, sat = hls(color)
    if luminance is not None:
        lum = luminance
    if saturation is not None:
        sat = saturation
    if max_saturation is not None:
        sat = min(sat, max_saturation)
    return np.array(colorsys.hls_to_rgb(hue, lum, sat))


def mix(color1, color2, amount):
    return color1 * (1 - amount) + color2 * amount


def hue_distance(color1, color2):
    delta = abs(hls(color1)[0] - hls(color2)[0])
    return min(delta, 1 - delta)


class Palette:
    """Frame colours derived from the theme: `accent` is the theme's secondary focus colour and
    `second` the palette accent whose hue is furthest from it, both kept pastel."""

    def __init__(self, colors):
        self.background = from_hex(colors["background"])
        self.foreground = from_hex(colors["foreground"])
        accent = from_hex(colors["active_alt"])
        candidates = [from_hex(colors["color%d" % i]) for i in range(1, 7)]
        colourful = [c for c in candidates if hls(c)[2] >= 0.15] or candidates
        second = max(colourful, key=lambda c: hue_distance(c, accent))
        self.accent = toned(accent, luminance=0.65, max_saturation=0.45)
        self.second = toned(second, luminance=0.65, max_saturation=0.45)


# Canvas ------------------------------------------------------------------------------------------

def rounded_rect_sdf(x, y, low, high, radius):
    """Signed distance to the square [low, high]² with rounded corners, negative inside."""
    centre = (low + high) / 2
    half = (high - low) / 2 - radius
    qx = np.abs(x - centre) - half
    qy = np.abs(y - centre) - half
    outside = np.hypot(np.maximum(qx, 0), np.maximum(qy, 0))
    return outside + np.minimum(np.maximum(qx, qy), 0) - radius


class Canvas:
    """A square nine-slice image. `d` is the distance of each pixel to the outer contour of the
    native border, positive towards the outside; `side` goes from 1 on the top and left sides to
    -1 on the bottom and right ones, turning smoothly around the two other corners.

    `thickness` is the width of the frame outside the native border, `inset` how far each slice
    reaches over the window, `period` the length of the repeated strips."""

    def __init__(self, thickness, inset, period, radius):
        self.thickness = thickness
        self.inset = inset
        self.slice = thickness + inset
        self.radius = radius
        self.size = 2 * self.slice + period
        centres = np.arange(self.size) + 0.5
        self.x, self.y = np.meshgrid(centres, centres)
        self.d = rounded_rect_sdf(self.x, self.y, thickness, self.size - thickness, radius)
        gy, gx = np.gradient(self.d)
        self.side = np.clip(-(gx + gy) / 2 / SQRT1_2, -1, 1)
        self.rgb = np.zeros((self.size, self.size, 3))
        self.alpha = np.zeros((self.size, self.size))

    def in_corner(self):
        """Mask of the four corner squares."""
        edge = np.minimum(self.size - self.x, self.x) < self.slice
        return edge & (np.minimum(self.size - self.y, self.y) < self.slice)

    def band(self, start, end, field=None):
        """Antialiased coverage of the pixels whose distance lies between `start` and `end`."""
        d = self.d if field is None else field
        return np.clip(d - start + 0.5, 0, 1) * np.clip(end - d + 0.5, 0, 1)

    def paint(self, color, coverage):
        """Draws `color` (one colour or one per pixel) over the image with the given coverage."""
        color = np.broadcast_to(color, self.rgb.shape)
        coverage = np.clip(coverage, 0, 1)
        alpha = coverage + self.alpha * (1 - coverage)
        blended = color * coverage[..., None] + self.rgb * (self.alpha * (1 - coverage))[..., None]
        self.rgb = blended / np.maximum(alpha, 1e-6)[..., None]
        self.alpha = alpha

    def by_side(self, lit, shaded):
        """One colour per pixel: `lit` on the top and left sides, `shaded` on the others."""
        amount = ((1 - self.side) / 2)[..., None]
        return lit * (1 - amount) + shaded * amount

    def image(self):
        data = np.dstack([self.rgb, self.alpha])
        return Image.fromarray((np.clip(data, 0, 1) * 255 + 0.5).astype(np.uint8), "RGBA")


# Styles ------------------------------------------------------------------------------------------
# Each style returns (canvas, plugin scale, smooth).

def aurora(palette, radius):
    """A thin luminous line with a soft halo, accent on the top and left, second colour on the
    bottom and right."""
    canvas = Canvas(thickness=12, inset=radius, period=8, radius=radius)
    d = canvas.d
    glow = canvas.by_side(toned(palette.accent, luminance=0.62),
                          toned(palette.second, luminance=0.62))
    line = canvas.by_side(toned(palette.accent, luminance=0.78),
                          toned(palette.second, luminance=0.78))
    halo = 0.8 * np.exp(-np.maximum(d - 3.5, 0) / 3.2) * np.clip((11.5 - d) / 5, 0, 1)
    canvas.paint(glow, np.where(d > 2.5, halo, 0))
    canvas.paint(palette.background, canvas.band(-0.5, 2.2))
    canvas.paint(line, canvas.band(2.3, 4))
    return canvas, 1, True


def bezel(palette, radius):
    """A matte raised frame lit from the top left, casting a soft shadow on both sides."""
    canvas = Canvas(thickness=11, inset=radius, period=8, radius=radius)
    d = canvas.d
    side = canvas.side[..., None]
    base = toned(palette.accent, luminance=0.27, saturation=0.2)
    # Outer shadow, then the body with a convex profile.
    canvas.paint(np.zeros(3), 0.45 * np.clip((11 - d) / 3.5, 0, 1) ** 2 * (d > 7))
    profile = np.sin(np.clip(d / 8, 0, 1) * math.pi)[..., None]
    body = base * (1 + 0.22 * side + 0.25 * profile)
    canvas.paint(body, canvas.band(-0.5, 8))
    # The outer rim catches the light on the lit sides, the inner lip on the shaded ones.
    rim = mix(base, palette.foreground, 0.55)
    dark = mix(base, palette.background, 0.75)
    canvas.paint(np.where(side > 0, rim, dark), canvas.band(7, 8) * np.abs(canvas.side) * 0.9)
    canvas.paint(np.where(side > 0, dark, rim), canvas.band(-0.5, 0.8) * np.abs(canvas.side) * 0.8)
    canvas.paint(mix(base, palette.background, 0.6), canvas.band(3, 5.2))
    canvas.paint(canvas.by_side(toned(palette.accent, luminance=0.7),
                                toned(palette.second, luminance=0.7)), canvas.band(3.6, 4.6))
    # Shadow cast on the window, past the native border.
    depth = -d - (radius - DEFAULT_ROUNDING)
    canvas.paint(np.zeros(3), 0.32 * np.clip(1 - depth / 6, 0, 1) ** 2 * (depth > 0))
    return canvas, 1, True


def deco(palette, radius):
    """Two keylines on a dark plate: a hairline around the window and a square outer line, with a
    diamond set in each corner between them."""
    thickness = 12
    canvas = Canvas(thickness=thickness, inset=radius, period=8, radius=radius)
    margin = 1.5
    square = rounded_rect_sdf(canvas.x, canvas.y, margin, canvas.size - margin, 2)
    line = mix(palette.foreground, palette.second, 0.45)
    inside_square = np.clip(0.5 - square, 0, 1)
    canvas.paint(palette.background, 0.72 * inside_square * np.clip(canvas.d + 0.5, 0, 1))
    canvas.paint(line, canvas.band(-1.6, 0, field=square))
    canvas.paint(mix(line, palette.background, 0.25), canvas.band(3, 4))
    # Diamond halfway between the corner of the outer line and the hairline.
    arc_centre = thickness + radius
    corner_to_arc = (arc_centre - margin) * math.sqrt(2) - (radius + 4)
    offset = margin + corner_to_arc / 2 * SQRT1_2 + 0.3
    fx = np.minimum(canvas.x, canvas.size - canvas.x)
    fy = np.minimum(canvas.y, canvas.size - canvas.y)
    diamond = np.abs(fx - offset) + np.abs(fy - offset)
    canvas.paint(toned(palette.accent, luminance=0.72), np.clip(3.6 - diamond + 0.5, 0, 1))
    return canvas, 1, True


def ribbon(palette, radius):
    """A band of soft diagonal stripes between square corner brackets, each held by two studs."""
    period = 14
    thickness = 10
    canvas = Canvas(thickness=thickness, inset=radius, period=period, radius=radius)
    light = toned(palette.accent, luminance=0.66)
    deep = toned(palette.accent, luminance=0.5)
    phase = ((canvas.x + canvas.y) % period) / period
    stripe = np.clip((np.abs(phase - 0.5) - 0.25) * period * SQRT1_2 + 0.5, 0, 1)[..., None]
    canvas.paint(palette.background, 0.5 * canvas.band(0, 9.5))
    canvas.paint(light * stripe + deep * (1 - stripe), canvas.band(2, 8))
    # The brackets fill the corner squares outside the window, which hides the end of the strips.
    corner = canvas.in_corner() * np.clip(canvas.d + 0.5, 0, 1)
    plate = canvas.by_side(toned(palette.second, luminance=0.72),
                           toned(palette.second, luminance=0.6))
    canvas.paint(plate, corner)
    fx = np.minimum(canvas.x, canvas.size - canvas.x)
    fy = np.minimum(canvas.y, canvas.size - canvas.y)
    rim = np.minimum(np.minimum(fx, fy), np.maximum(canvas.slice - fx, canvas.slice - fy))
    canvas.paint(mix(toned(palette.second, luminance=0.45), palette.background, 0.3),
                 corner * np.clip(1.5 - rim, 0, 1))
    along = np.maximum(fx, fy)
    across = np.minimum(fx, fy)
    stud = np.hypot(along - (canvas.slice - 6), across - thickness / 2)
    canvas.paint(palette.background, corner * np.clip(2.1 - stud, 0, 1) * 0.85)
    return canvas, 1, True


def pixel(palette, radius):
    """A chunky pixel-art frame drawn at half resolution, with a stud in each corner."""
    scale = 2
    thickness = 5
    canvas = Canvas(thickness=thickness, inset=math.ceil(radius / scale), period=4,
                    radius=radius / scale)
    step = np.floor(canvas.d)
    outline = palette.background
    body = canvas.by_side(toned(palette.accent, luminance=0.52),
                          toned(palette.accent, luminance=0.4))
    shine = canvas.by_side(toned(palette.accent, luminance=0.76),
                           toned(palette.accent, luminance=0.56))
    shade = canvas.by_side(toned(palette.accent, luminance=0.4),
                           toned(palette.accent, luminance=0.28))
    # In the corners the stepped contour cannot follow the smooth native border: the outline
    # covers it there, two cells deep.
    canvas.paint(outline, ((step < 0) & (step >= -2) & canvas.in_corner()).astype(float))
    canvas.paint(outline, (step == 0).astype(float))
    canvas.paint(shade, (step == 1).astype(float))
    canvas.paint(body, (step == 2).astype(float))
    canvas.paint(shine, (step == 3).astype(float))
    canvas.paint(outline, (step == 4).astype(float))
    arc_centre = thickness + canvas.radius
    stud = arc_centre - (canvas.radius + 2.5) * SQRT1_2
    fx = np.minimum(canvas.x, canvas.size - canvas.x)
    fy = np.minimum(canvas.y, canvas.size - canvas.y)
    on_stud = (np.floor(fx) == math.floor(stud)) & (np.floor(fy) == math.floor(stud))
    canvas.paint(toned(palette.second, luminance=0.8), on_stud.astype(float))
    return canvas, scale, False


def paint_blade(canvas, mask, dx, dy, angle, length, width, color, bend):
    """Draws a slender leaf from its base (the origin of the `dx`, `dy` offsets) along `angle`:
    two halves of slightly different tone on either side of a pale midrib, over a faint shadow."""
    cos, sin = math.cos(angle), math.sin(angle)

    def shape(ox, oy, grow):
        u = (dx - ox) * cos + (dy - oy) * sin
        v = -(dx - ox) * sin + (dy - oy) * cos
        t = np.clip(u / length, 0, 1)
        v = v - bend * 4 * t * (1 - t)
        half = (width + grow) * t ** 0.75 * (1 - t) ** 1.15 / 0.274
        return np.clip(half - np.abs(v) + 0.5, 0, 1) * (u > 0) * (u < length) * mask, t, v

    canvas.paint(np.zeros(3), 0.28 * shape(0.6, 1.0, 1.0)[0])
    cover, t, v = shape(0, 0, 0)
    tone = 1 + 0.12 * np.clip(v * 2, -1, 1) + 0.12 * (t - 0.5)
    rib = np.clip(1 - np.abs(v) / 0.55, 0, 1) * (t < 0.8) * 0.35
    canvas.paint(np.clip(color * (tone + rib)[..., None], 0, 1), cover)


def vines(palette, radius):
    """A translucent dark band edged with two keylines and inlaid with a fine botanical line: two
    hairline stems twining in opposite phase, a slender leaf at each crest pointing the way the
    vine runs, a bud now and then, in muted sage.

    Each side is drawn in the frame of the top one, the image being turned a quarter each time,
    together with the corner at its left. The stems make a whole number of waves in a strip and
    one in a corner, and cross on the stem line wherever a strip starts."""
    # Opacity of the band behind the vine and of its keylines: 0 leaves only the vine over the
    # wallpaper.
    PLATE_OPACITY = 0
    thickness = 15
    stem = 7.25
    wave = 40
    amplitude = 2.4
    period = 4 * wave
    canvas = Canvas(thickness=thickness, inset=radius, period=period, radius=radius)
    size, corner_size = canvas.size, canvas.slice

    accent_hue = hls(palette.accent)[0]
    hue = 0.31 + (accent_hue - 0.31) * 0.15
    sage = np.array(colorsys.hls_to_rgb(hue, 0.56, 0.2))
    deep = np.array(colorsys.hls_to_rgb(hue, 0.44, 0.22))
    pale = np.array(colorsys.hls_to_rgb(hue - 0.05, 0.76, 0.2))
    bud = toned(palette.second, luminance=0.78, max_saturation=0.35)

    turns = [(canvas.x, canvas.y), (canvas.y, size - canvas.x),
             (size - canvas.x, size - canvas.y), (size - canvas.y, canvas.x)]

    along = np.zeros_like(canvas.d)
    region = np.zeros_like(canvas.d)
    for x, y in turns:
        strip = (x >= corner_size) & (x < corner_size + period) & (y < corner_size)
        corner = (x < corner_size) & (y < corner_size)
        turn = np.arctan2(corner_size - x, corner_size - y)
        along = np.where(strip, x - corner_size, along)
        along = np.where(corner, -turn / (math.pi / 2) * wave, along)
        region = np.where(strip | corner, 1.0, region)
    across = canvas.d - stem
    swing = amplitude * np.sin(2 * math.pi * along / wave)

    def line(offset, width, color, alpha):
        canvas.paint(color, alpha * np.clip(width - np.abs(across - offset) + 0.5, 0, 1) * region)

    canvas.paint(palette.background, PLATE_OPACITY * canvas.band(-0.5, thickness - 1))
    keyline = mix(deep, palette.background, 0.35)
    # The keylines edge the band and fade out with it.
    edge = 0.7 * min(1, PLATE_OPACITY / 0.3)
    canvas.paint(keyline, edge * canvas.band(1.6, 2.4))
    canvas.paint(keyline, edge * canvas.band(thickness - 3.2, thickness - 2.4))
    line(swing + 0.8, 1.5, np.zeros(3), 0.22)
    line(-swing + 0.8, 1.3, np.zeros(3), 0.18)
    line(-swing, 0.5, mix(pale, deep, 0.5), 1)
    line(swing, 0.75, pale, 1)

    def leaf(mask, dx, dy, tangent, normal, outward, length, width):
        tilt = math.radians(15)
        direction = math.cos(tilt) * tangent + (1 if outward else -1) * math.sin(tilt) * normal
        paint_blade(canvas, mask, dx, dy, math.atan2(direction[1], direction[0]), length, width,
                    sage if outward else deep, (0.9 if outward else -0.9))

    def dot(mask, dx, dy):
        canvas.paint(np.zeros(3), 0.25 * np.clip(2.2 - np.hypot(dx - 0.5, dy - 0.9), 0, 1) * mask)
        canvas.paint(bud, np.clip(1.25 - np.hypot(dx, dy) + 0.5, 0, 1) * mask)

    for x, y in turns:
        strip = (x >= corner_size) & (x < corner_size + period) & (y < corner_size)
        corner = (x < corner_size) & (y < corner_size)
        right, up = np.array([1.0, 0.0]), np.array([0.0, -1.0])
        for index in range(2 * period // wave):
            outward = index % 2 == 0
            position = wave / 4 + index * wave / 2
            dx = (x - corner_size - position + period / 2) % period - period / 2
            lift = amplitude if outward else -amplitude
            leaf(strip, dx, y - (thickness - stem - lift), right, up, outward, 13, 2.0)
            if index % 4 == 3:
                dot(strip, dx + wave / 4, y - (thickness - stem + amplitude + 1.4))
        for along_corner, outward in ((-0.75 * wave, True), (-0.25 * wave, False)):
            turn = -along_corner / wave * math.pi / 2
            tangent = np.array([math.cos(turn), -math.sin(turn)])
            normal = np.array([-math.sin(turn), -math.cos(turn)])
            lift = amplitude if outward else -amplitude
            anchor = corner_size + (radius + stem + lift) * normal
            leaf(corner, x - anchor[0], y - anchor[1], tangent, normal, outward,
                 15 if outward else 11, 2.3 if outward else 1.8)
    return canvas, 1, True


def cyber(palette, radius):
    """A neon head-up frame over the wallpaper: a glowing cyan line with cut corners and a magenta
    ghost, ruler ticks and a magenta dash along each side, a magenta slab on the top left and
    bottom right corners, three yellow marks on the two others."""
    thickness = 15
    margin = 9
    tick = 12
    period = 10 * tick
    canvas = Canvas(thickness=thickness, inset=radius, period=period, radius=radius)
    size, corner_size = canvas.size, canvas.slice
    # The cut passes 5 px outside the rounded corner of the native border.
    cut = round(2 * (thickness + radius * (1 - SQRT1_2)) - 5 / SQRT1_2)

    cyan = np.array(colorsys.hls_to_rgb(0.5, 0.62, 0.85))
    magenta = np.array(colorsys.hls_to_rgb(0.9, 0.6, 0.85))
    yellow = np.array(colorsys.hls_to_rgb(0.15, 0.6, 0.9))

    def edges(x, y):
        return np.minimum(x, size - x), np.minimum(y, size - y)

    def contour(x, y):
        """Distance to the frame line, positive towards the outside."""
        fx, fy = edges(x, y)
        return np.maximum(np.maximum(margin - fx, margin - fy), (cut - fx - fy) * SQRT1_2)

    fx, fy = edges(canvas.x, canvas.y)
    fade = np.clip(np.minimum(fx, fy) / 3, 0, 1)
    line = contour(canvas.x, canvas.y)
    ghost = contour(canvas.x - 1.4, canvas.y - 1.4)

    def stroke(field, width):
        return np.clip(width - np.abs(field) + 0.5, 0, 1)

    canvas.paint(cyan, 0.42 * np.exp(-np.abs(line) / 2.6) * fade)
    canvas.paint(magenta, 0.6 * stroke(ghost, 0.55))
    canvas.paint(mix(cyan, np.ones(3), 0.35), stroke(line, 0.7))

    # Sides: ruler ticks outside the line, every fifth one longer, and a dash inside it.
    for along, across in ((canvas.x, fy), (canvas.y, fx)):
        strip = (along >= corner_size) & (along < corner_size + period) & (across < corner_size)
        step = np.floor(along - corner_size)
        long_tick = step % (5 * tick) == 0
        reach = np.where(long_tick, 6.5, 4)
        ticks = (step % tick == 0) & (across > margin - reach) & (across < margin - 2)
        canvas.paint(cyan, 0.75 * ticks * strip)
        dash = (step >= 70) & (step < 104) & (across > margin + 2.5) & (across < margin + 4.5)
        canvas.paint(magenta, 0.4 * strip * (step >= 68) * (step < 106)
                     * np.exp(-np.abs(across - margin - 3.5) / 1.8))
        canvas.paint(magenta, 1.0 * dash * strip)

    # Corners.
    left, top = canvas.x < size / 2, canvas.y < size / 2
    slab_corner = (left & top) | (~left & ~top)
    outside = (cut - fx - fy) * SQRT1_2
    span = np.clip(9 - np.abs(fx - fy) * SQRT1_2 + 0.5, 0, 1)
    canvas.paint(magenta, 0.4 * np.exp(-np.abs(outside - 4.2) / 2) * span * slab_corner * fade)
    canvas.paint(magenta, stroke(outside - 4.2, 0.9) * span * slab_corner)
    marks = np.zeros_like(line, dtype=bool)
    for position in (13, 18, 23):
        marks |= (np.floor(fx) >= position) & (np.floor(fx) < position + 3)
    marks &= (np.floor(fy) >= 3) & (np.floor(fy) < 6)
    canvas.paint(yellow, 1.0 * marks * ~slab_corner)
    return canvas, 1, True


def machine(palette, radius):
    """Plumbing over the wallpaper: a gunmetal pipe and a thin copper tube run side by side around
    the window, held by riveted clamps and joined by copper flanges; each corner is an elbow
    between two flanges, with a cog on the top left and bottom right and a gauge on the others."""
    thickness = 15
    period = 120
    tube, tube_radius = 3.2, 1.4
    pipe, pipe_radius = 9.0, 3.0
    canvas = Canvas(thickness=thickness, inset=radius, period=period, radius=radius)
    size, corner_size = canvas.size, canvas.slice
    d, side = canvas.d, canvas.side

    steel = np.array(colorsys.hls_to_rgb(0.6, 0.27, 0.09))
    copper = np.array(colorsys.hls_to_rgb(0.065, 0.5, 0.46))
    dark = mix(steel, np.zeros(3), 0.7)

    fx = np.minimum(canvas.x, size - canvas.x)
    fy = np.minimum(canvas.y, size - canvas.y)
    corner = canvas.in_corner()

    def cylinder(centre, half, color, coverage):
        """A length of pipe seen from the side, lit from the top left."""
        profile = np.clip((d - centre) / half, -1, 1)
        body = 0.5 + 0.62 * (1 - profile ** 2)
        gleam = 0.75 * np.exp(-((profile - 0.42 * side) / 0.22) ** 2)
        tint = np.clip(color * body[..., None] + gleam[..., None] * (1 - color) * 0.6, 0, 1)
        canvas.paint(np.zeros(3), 0.3 * canvas.band(centre - half + 0.4, centre + half + 1.6)
                     * coverage)
        canvas.paint(tint, canvas.band(centre - half, centre + half) * coverage)
        canvas.paint(dark, 0.55 * coverage * np.clip(
            1.2 - np.abs(np.abs(d - centre) - half), 0, 1) * canvas.band(centre - half, centre + half))

    whole = np.ones_like(d)
    cylinder(tube, tube_radius, copper, whole)
    cylinder(pipe, pipe_radius, steel, whole)

    # Sides: two clamps across both pipes and a pair of copper flanges on the large one.
    for along, across in ((canvas.x, fy), (canvas.y, fx)):
        strip = (along >= corner_size) & (along < corner_size + period) & (across < corner_size)
        step = np.floor(along - corner_size)
        for start in (27, 87):
            clamp = strip * (step >= start) * (step < start + 6) * canvas.band(0.8, 13.6)
            canvas.paint(np.zeros(3), 0.3 * strip * (step >= start) * (step < start + 7)
                         * canvas.band(0.8, 14.6))
            relief = 1.25 - 0.4 * np.abs(step - start - 2.5) / 2.5
            canvas.paint(steel * 1.5 * (relief * (1 + 0.15 * side))[..., None], clamp)
            for rivet in (5.4, 12.6):
                distance = np.hypot(along - corner_size - start - 3, d - rivet)
                canvas.paint(copper * 1.15, strip * np.clip(1.15 - distance + 0.5, 0, 1))
        for start in (56, 61):
            cylinder(pipe, pipe_radius + 1.5, copper, strip * (step >= start) * (step < start + 3))

    # Corners: a flange where each pipe enters the elbow.
    joint = corner * (np.maximum(fx, fy) >= corner_size - 3)
    cylinder(pipe, pipe_radius + 1.5, copper, joint)
    cylinder(tube, tube_radius + 0.9, steel * 1.5, joint)

    # A cog or a gauge sits in the angle outside each elbow.
    left, top = canvas.x < size / 2, canvas.y < size / 2
    cog_corner = (left & top) | (~left & ~top)
    centre = corner_size - (radius + 19) * SQRT1_2
    dx, dy = fx - centre, fy - centre
    distance = np.hypot(dx, dy)
    canvas.paint(np.zeros(3), 0.3 * np.clip(7 - np.hypot(dx + 0.8, dy + 0.8), 0, 1) * corner)

    teeth = 4.7 + 1.5 * np.clip(np.cos(8 * np.arctan2(dy, dx)) * 2.2 + 0.5, 0, 1)
    cog = corner * cog_corner
    canvas.paint(steel * (1.25 + 0.3 * side)[..., None], np.clip(teeth - distance + 0.5, 0, 1) * cog)
    canvas.paint(dark, 0.6 * np.clip(1 - np.abs(distance - 3.6), 0, 1) * cog)
    canvas.paint(copper, np.clip(2.1 - distance + 0.5, 0, 1) * cog)
    canvas.paint(dark, np.clip(0.8 - distance + 0.5, 0, 1) * cog)

    gauge = corner * ~cog_corner
    canvas.paint(copper * (1 + 0.25 * side)[..., None], np.clip(6 - distance + 0.5, 0, 1) * gauge)
    canvas.paint(mix(palette.background, steel, 0.25), np.clip(4.5 - distance + 0.5, 0, 1) * gauge)
    marks = (np.cos(10 * np.arctan2(dy, dx)) > 0.75) & (distance > 3.2) & (distance < 4.4)
    canvas.paint(mix(steel, np.ones(3), 0.45), 0.8 * marks * gauge)
    needle = np.abs(dx * 0.6 - dy * 0.8)
    reach = dx * 0.8 + dy * 0.6
    canvas.paint(mix(copper, np.ones(3), 0.5),
                 np.clip(0.9 - needle, 0, 1) * (reach > -1) * (reach < 3.8) * gauge)
    canvas.paint(copper, np.clip(1.1 - distance + 0.5, 0, 1) * gauge)
    return canvas, 1, True


def mesh_phase(phase, teeth, bearing, other_teeth):
    """Phase of a gear of `other_teeth` teeth lying in the direction `bearing` from a gear of
    `teeth` teeth at `phase`, such that the teeth of one fall between those of the other. The
    phase of a gear is the direction of one of its teeth."""
    facing = ((bearing - phase) * teeth / (2 * math.pi) + 0.5) % 1
    return bearing + math.pi - facing * 2 * math.pi / other_teeth


def paint_gear(canvas, mask, dx, dy, teeth, pitch_radius, phase, color, spoked=False):
    """Draws a gear seen face-on, centred on the origin of the `dx`, `dy` offsets: bright rim,
    darker web (cut into spokes when `spoked`), dark hub and a pale axle, over a shadow."""
    def outline(ox, oy):
        distance = np.hypot(dx - ox, dy - oy)
        angle = np.arctan2(dy - oy, dx - ox)
        tooth = np.clip(np.cos(teeth * (angle - phase)) * 1.8 + 0.5, 0, 1)
        return pitch_radius - 0.8 + 1.6 * tooth - distance, distance, angle

    root = pitch_radius - 0.8
    edge, distance, angle = outline(0, 0)
    holes = 0
    if spoked:
        holes = (np.clip(distance - 2.9, 0, 1) * np.clip(root - 1.5 - distance, 0, 1)
                 * np.clip((0.6 - np.cos(4 * (angle - phase))) * 3, 0, 1))
    solid = mask * (1 - holes)
    canvas.paint(np.zeros(3), 0.38 * np.clip(outline(0.9, 1.4)[0] + 1.2, 0, 1) * solid)
    rim = np.exp(-((distance - root + 0.7) / 0.9) ** 2)
    web = np.clip(root - 1.4 - distance, 0, 1)
    shade = 0.95 + 0.4 * rim - 0.28 * web - 0.3 * np.clip(1.1 - edge, 0, 1)
    canvas.paint(np.clip(color * shade[..., None], 0, 1), np.clip(edge + 0.5, 0, 1) * solid)
    canvas.paint(color * 0.35, np.clip(2.3 - distance + 0.5, 0, 1) * mask)
    canvas.paint(mix(color, np.ones(3), 0.45), np.clip(1.0 - distance + 0.5, 0, 1) * mask)


def steam(palette, radius):
    """A brass and copper machine around the window. A large copper steam pipe fills most of the
    frame, in riveted lengths; a toothed iron rack runs along its outer edge. On each side two
    pinions ride the rack in front of the pipe, each driving a small idler, next to a valve
    wheel, a pair of flanges and a gauge mounted on the pipe. In each corner the two racks stop short and a large spoked gear,
    driven by a pinion on either rack, carries the motion around the pipe elbow; riveted
    bulkheads close the corner."""
    thickness = 20
    pitch = 4
    period = 40 * pitch
    canvas = Canvas(thickness=thickness, inset=radius, period=period, radius=radius)
    size, corner_size = canvas.size, canvas.slice
    d, side = canvas.d, canvas.side

    brass = np.array(colorsys.hls_to_rgb(0.105, 0.44, 0.33))
    bronze = np.array(colorsys.hls_to_rgb(0.085, 0.31, 0.3))
    copper = np.array(colorsys.hls_to_rgb(0.055, 0.47, 0.46))
    iron = np.array(colorsys.hls_to_rgb(0.08, 0.17, 0.1))
    cream = np.array(colorsys.hls_to_rgb(0.12, 0.8, 0.3))
    dark = iron * 0.4

    pipe, pipe_radius = 9.0, 6.5
    rack_line = thickness - 4.3
    pinion_teeth, idler_teeth, wheel_teeth = 8, 6, 12
    radius_of = lambda teeth: teeth * pitch / (2 * math.pi)
    pinion_line = rack_line - radius_of(pinion_teeth)

    fx = np.minimum(canvas.x, size - canvas.x)
    fy = np.minimum(canvas.y, size - canvas.y)
    corner = canvas.in_corner()
    rack_stop = 17

    def cylinder(centre, half, color, coverage):
        profile = np.clip((d - centre) / half, -1, 1)
        body = 0.5 + 0.62 * (1 - profile ** 2)
        gleam = 0.75 * np.exp(-((profile - 0.42 * side) / 0.22) ** 2)
        tint = np.clip(color * body[..., None] + gleam[..., None] * (1 - color) * 0.6, 0, 1)
        canvas.paint(np.zeros(3), 0.3 * canvas.band(centre - half + 0.4, centre + half + 1.6)
                     * coverage)
        canvas.paint(tint, canvas.band(centre - half, centre + half) * coverage)
        canvas.paint(dark, 0.5 * coverage * np.clip(
            1.2 - np.abs(np.abs(d - centre) - half), 0, 1) * canvas.band(centre - half, centre + half))

    def disc(mask, dx, dy, size_, color, alpha=1.0):
        canvas.paint(color, alpha * np.clip(size_ - np.hypot(dx, dy) + 0.5, 0, 1) * mask)

    cylinder(pipe, pipe_radius, copper, np.ones_like(d))

    # The racks are straight: they follow the sides and run into the corner squares, where
    # they stop. `along` counts from the start of the strip, so the teeth line up across it.
    def rack(mask, along, across):
        step = np.floor(along - corner_size)
        canvas.paint(np.zeros(3), 0.3 * mask * (across >= 1) * (across < 6.5))
        teeth = (across >= 3.5) & (across < 5) & (step % pitch >= 2)
        rail = (across >= 1.5) & (across < 3.5)
        canvas.paint(iron * 1.7, 1.0 * mask * teeth)
        canvas.paint(iron * np.where(across < 2.5, 2.6, 1.9)[..., None], 1.0 * mask * rail)
        canvas.paint(dark, 0.8 * mask * rail * (step % (2 * pitch) == 1) * (across >= 2) * (across < 3))

    for along, across in ((canvas.x, fy), (canvas.y, fx)):
        strip = (along >= corner_size) & (along < corner_size + period) & (across < corner_size)
        position = along - corner_size
        step = np.floor(position)
        depth = thickness - across

        # Riveted collars between the lengths of pipe, and a pair of flanges.
        for start in (20, 60, 100, 140):
            collar = strip * (step >= start) * (step < start + 3)
            cylinder(pipe, pipe_radius + 0.5, bronze, collar)
            for rivet in (-4.2, -1.5, 1.2, 4):
                disc(collar, position - start - 1.5, depth - pipe - rivet, 0.7, brass * 1.5)
        for start in (76, 81):
            cylinder(pipe, pipe_radius + 1.2, brass, strip * (step >= start) * (step < start + 3))
        rack(strip, along, across)

        # Valve wheel on the pipe.
        dx, dy = position - 9, depth - pipe + 1.5
        reach = np.hypot(dx, dy)
        canvas.paint(np.zeros(3), 0.35 * np.clip(6.6 - np.hypot(dx - 0.9, dy - 1.4), 0, 1)
                     * np.clip(np.hypot(dx - 0.9, dy - 1.4) - 3.4, 0, 1) * strip)
        spokes = np.minimum(np.abs(dx), np.abs(dy)) < 0.7
        canvas.paint(iron * 2.4, strip * np.clip(1.1 - np.abs(reach - 5) + 0.3, 0, 1))
        canvas.paint(iron * 2.0, strip * spokes * (reach < 5))
        disc(strip, dx, dy, 1.4, brass * 1.3)

        # Gauge on a stem.
        dx, dy = position - 94, depth - pipe + 1.5
        disc(strip, dx - 0.9, dy - 1.4, 5.4, np.zeros(3), 0.35)
        disc(strip, dx, dy, 4.8, brass)
        disc(strip, dx, dy, 3.6, cream)
        needle = np.abs(dx * 0.75 + dy * 0.66)
        along_needle = dx * 0.66 - dy * 0.75
        canvas.paint(dark, strip * np.clip(0.75 - needle, 0, 1) * (along_needle > -0.8)
                     * (along_needle < 3.2))
        disc(strip, dx, dy, 0.6, copper)

        # Pinions on the rack, each with an idler.
        for centre, direction in ((41, 1), (121, -1)):
            pinion_phase = math.pi / 2
            offset_x = direction * 8.58
            idler_depth = pinion_line - 2.4
            bearing = math.atan2(idler_depth - pinion_line, offset_x)
            paint_gear(canvas, strip, position - centre - offset_x, depth - idler_depth,
                       idler_teeth, radius_of(idler_teeth),
                       mesh_phase(pinion_phase, pinion_teeth, bearing, idler_teeth), copper)
            paint_gear(canvas, strip, position - centre, depth - pinion_line, pinion_teeth,
                       radius_of(pinion_teeth), pinion_phase, brass)

    # Corners.
    top_rack = corner * (fy < fx) * (fx >= rack_stop)
    left_rack = corner * (fx < fy) * (fy >= rack_stop)
    rack(top_rack, fx, fy)
    rack(left_rack, fy, fx)
    for along, across, mask in ((fx, fy, top_rack), (fy, fx, left_rack)):
        block = corner * (across < along) * (along >= rack_stop - 3) * (along < rack_stop) \
            * (across >= 0.5) * (across < 6.5)
        canvas.paint(iron * np.where(across < 1.5, 2.8, 2.0)[..., None], 1.0 * block)

    wheel_radius = radius_of(wheel_teeth)
    gap = wheel_radius + radius_of(pinion_teeth)
    pinion_at = np.array([26.0, thickness - pinion_line])
    # Centre of the large gear on the diagonal, at meshing distance from both pinions.
    total = pinion_at.sum()
    wheel_at = (total - math.sqrt(total ** 2 - 2 * (pinion_at @ pinion_at - gap ** 2))) / 2
    wheel_phase = -3 * math.pi / 4
    paint_gear(canvas, corner, fx - wheel_at, fy - wheel_at, wheel_teeth, wheel_radius,
               wheel_phase, bronze, spoked=True)
    for px, py in (pinion_at, pinion_at[::-1]):
        bearing = math.atan2(py - wheel_at, px - wheel_at)
        paint_gear(canvas, corner, fx - px, fy - py, pinion_teeth, radius_of(pinion_teeth),
                   mesh_phase(wheel_phase, wheel_teeth, bearing, pinion_teeth), brass)

    # Bulkheads where the sides enter the corner squares.
    for along, across in ((fx, fy), (fy, fx)):
        plate = corner * (along >= corner_size - 4) * (across < along) \
            * (across >= 0.5) * (across < thickness - 0.5)
        canvas.paint(np.zeros(3), 0.3 * corner * (along >= corner_size - 5.5)
                     * (across < along) * (across < thickness + 0.5))
        relief = np.where(along < corner_size - 3, 1.35, np.where(along >= corner_size - 1, 0.8, 1.05))
        canvas.paint(np.clip(bronze * 0.85 * relief[..., None], 0, 1), 1.0 * plate)
        for rivet in (3.5, 10, 16.5):
            disc(plate, along - (corner_size - 2), across - rivet, 0.8, brass * 1.4)
    return canvas, 1, True


STYLES = {"aurora": aurora, "bezel": bezel, "deco": deco, "ribbon": ribbon, "pixel": pixel,
          "vines": vines, "cyber": cyber,
          "machine": machine, "steam": steam}


# Output ------------------------------------------------------------------------------------------

def hypr_option(name, default):
    """Integer value of a Hyprland option, or `default` outside a session."""
    try:
        reply = subprocess.run(["hyprctl", "-j", "getoption", name], capture_output=True,
                               text=True, timeout=5)
        return int(json.loads(reply.stdout)["int"])
    except (OSError, subprocess.SubprocessError, ValueError, KeyError, TypeError):
        return default


def render(colors, rounding, border_size):
    """Returns {style: (image, meta)} where meta holds the plugin options of the style."""
    palette = Palette(colors)
    frames = {}
    for name, style in STYLES.items():
        canvas, scale, smooth = style(palette, rounding + border_size)
        frames[name] = (canvas.image(), {
            "image": os.path.join(OUTPUT_DIR, name + ".png"),
            "sizes": canvas.slice,
            "insets": canvas.inset,
            "scale": scale,
            "smooth": smooth,
        })
    return frames


def render_lua(frames):
    lines = ["return {\n"]
    for name, (_, meta) in frames.items():
        fields = ", ".join("%s = %s" % (key, json.dumps(value)) for key, value in meta.items())
        lines.append("  %s = { %s },\n" % (name, fields))
    lines.append("}\n")
    return "".join(lines)


def write_atomic(path, write):
    fd, tmp_path = tempfile.mkstemp(dir=os.path.dirname(path), prefix=".tmp-")
    try:
        with os.fdopen(fd, "wb") as handle:
            write(handle)
        os.chmod(tmp_path, 0o644)
        os.replace(tmp_path, path)
    except BaseException:
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)
        raise


def main():
    with open(COLORS_PATH) as handle:
        colors = json.load(handle)
    frames = render(colors,
                    hypr_option("decoration:rounding", DEFAULT_ROUNDING),
                    hypr_option("general:border_size", DEFAULT_BORDER_SIZE))
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    for image, meta in frames.values():
        write_atomic(meta["image"], lambda handle: image.save(handle, "PNG"))
    write_atomic(META_PATH, lambda handle: handle.write(render_lua(frames).encode()))


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""Cuts the launcher's textures out of the steampunk wallpaper.

    make-assets.py [wallpaper]

The crops are tied to this one picture: the launcher lays its rows out in the frame's opening.
"""
import colorsys
import os
import sys

from PIL import Image, ImageDraw, ImageFilter

WALLPAPER = os.path.expanduser("~/wallpapers/steampunk-gear-frame.jpg")
HERE = os.path.dirname(os.path.abspath(__file__))

# (left, top, right, bottom) in the 8000 x 4563 picture, and the size each crop is saved at:
# twice the size it is drawn at.
CROPS = {
    # The whole frame of pipes and gears; the plate around it is made transparent.
    "frame.webp": ((550, 0, 7325, 4325), (2168, 1384)),
    # The worn brass bar under the opening: the bezel of the search field, and the wear of the
    # selected row's nameplate.
    "bar.jpg": ((2900, 3600, 5700, 3790), (1120, 88)),
}


# The outline of the frame, in the frame crop at its saved size: the iron plate the pipes are
# fixed on, as a rectangle, and the gears that reach beyond it, as (centre x, centre y, radius).
FRAME_PLATE = (88, 64, 2128, 1376)
FRAME_GEARS = [
    (248, 176, 170), (1976, 208, 178), (304, 968, 194), (80, 979, 62), (200, 1256, 117),
    (424, 1240, 90), (1832, 1120, 194), (2024, 1040, 117), (2040, 1264, 85), (141, 389, 74),
]


def is_brass(red, green, blue):
    """Whether a pixel is lit brass, as opposed to the rusty plate behind or a shadow on it."""
    hue, saturation, value = colorsys.rgb_to_hsv(red / 255, green / 255, blue / 255)
    return value > 0.24 and saturation > 0.25 and 0.065 < hue < 0.17


def cut_out(frame):
    """The frame with everything beyond its outline made transparent. Inside the plate
    everything is kept; beyond it, only the brass of the gears, so the plate does not show
    between their teeth."""
    width, height = frame.size
    mask = Image.new("L", (width, height), 0)
    draw = ImageDraw.Draw(mask)
    pixels = frame.load()
    left, top, right, bottom = FRAME_PLATE
    for centre_x, centre_y, radius in FRAME_GEARS:
        for y in range(max(0, centre_y - radius), min(height, centre_y + radius + 1)):
            for x in range(max(0, centre_x - radius), min(width, centre_x + radius + 1)):
                inside = left <= x < right and top <= y < bottom
                if inside or (x - centre_x) ** 2 + (y - centre_y) ** 2 > radius ** 2:
                    continue
                if is_brass(*pixels[x, y]):
                    mask.putpixel((x, y), 255)
    # Closes the pinholes the colour test leaves in the gears, then softens the edge.
    mask = mask.filter(ImageFilter.MaxFilter(5)).filter(ImageFilter.MinFilter(5))
    draw = ImageDraw.Draw(mask)
    draw.rectangle((left, top, right - 1, bottom - 1), fill=255)
    mask = mask.filter(ImageFilter.GaussianBlur(0.8))
    cut = frame.convert("RGBA")
    cut.putalpha(mask)
    return cut


def main():
    Image.MAX_IMAGE_PIXELS = None
    picture = Image.open(sys.argv[1] if len(sys.argv) > 1 else WALLPAPER).convert("RGB")
    for name, (box, size) in CROPS.items():
        crop = picture.crop(box).resize(size, Image.LANCZOS)
        if name == "frame.webp":
            crop = cut_out(crop)
        crop.save(os.path.join(HERE, name), quality=90)


if __name__ == "__main__":
    main()

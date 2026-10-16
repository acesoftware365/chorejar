#!/usr/bin/env python3
"""Build localized, text-safe marketing images from ChoreJar source artwork.

The generated images are not screenshots.  Store screenshots are captured from
the installed app and placed in store_assets/.../screenshots/.
"""

from pathlib import Path
from typing import Optional, Tuple

from PIL import Image, ImageDraw, ImageFont, ImageOps


ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "store_assets" / "marketing" / "1.0.0"
SOURCE = ASSETS / "source"
FONT_BOLD = ROOT / "assets" / "fonts" / "Nunito-900.ttf"
FONT_REGULAR = ROOT / "assets" / "fonts" / "Nunito-700.ttf"
INK = "#17344D"
GREEN = "#087D61"
CREAM = "#FFF9EF"


COPY = {
    "en-US": {
        "name": "ChoreJar",
        "headline": "Chores, goals & family habits",
        "body": "Small steps today. Proud moments tomorrow.",
    },
    "es-419": {
        "name": "Mi Mesadita",
        "headline": "Tareas, metas y hábitos en familia",
        "body": "Pequeños pasos hoy. Grandes sueños mañana.",
    },
    "es-ES": {
        "name": "Mi Paga",
        "headline": "Tareas, metas y hábitos en familia",
        "body": "Pequeños pasos hoy. Grandes sueños mañana.",
    },
}


def font(path: Path, size: int):
    return ImageFont.truetype(str(path), size)


def fitted(source: Path, size: Tuple[int, int]) -> Image.Image:
    return ImageOps.fit(
        Image.open(source).convert("RGB"), size, method=Image.Resampling.LANCZOS
    )


def text(draw: ImageDraw.ImageDraw, xy: Tuple[int, int], value: str, size: int,
         *, color: str = INK, max_width: Optional[int] = None, gap: int = 8):
    use_font = font(FONT_BOLD, size)
    if not max_width:
        draw.text(xy, value, font=use_font, fill=color)
        return xy[1] + size
    words, line, lines = value.split(), "", []
    for word in words:
        candidate = f"{line} {word}".strip()
        if line and draw.textlength(candidate, font=use_font) > max_width:
            lines.append(line)
            line = word
        else:
            line = candidate
    if line:
        lines.append(line)
    y = xy[1]
    for line in lines:
        draw.text((xy[0], y), line, font=use_font, fill=color)
        y += size + gap
    return y


def make_wide(locale: str, size: Tuple[int, int], destination: Path):
    canvas = fitted(SOURCE / "family-chores-wide.png", size).convert("RGBA")
    overlay = Image.new("RGBA", size, (255, 249, 239, 0))
    pixels = overlay.load()
    start = int(size[0] * 0.47)
    for x in range(start, size[0]):
        opacity = int(230 * (x - start) / (size[0] - start))
        for y in range(size[1]):
            pixels[x, y] = (255, 249, 239, opacity)
    canvas = Image.alpha_composite(canvas, overlay)
    draw = ImageDraw.Draw(canvas)
    copy = COPY[locale]
    x, y, width = int(size[0] * 0.60), int(size[1] * 0.22), int(size[0] * 0.34)
    y = text(draw, (x, y), copy["name"], int(size[1] * 0.105), color=GREEN)
    y += int(size[1] * 0.05)
    y = text(draw, (x, y), copy["headline"], int(size[1] * 0.068), max_width=width)
    y += int(size[1] * 0.025)
    draw.text((x, y), copy["body"], font=font(FONT_REGULAR, int(size[1] * 0.032)), fill=INK)
    destination.parent.mkdir(parents=True, exist_ok=True)
    canvas.convert("RGB").save(destination, quality=95)


def make_portrait(locale: str, destination: Path):
    size = (1080, 1350)
    canvas = fitted(SOURCE / "family-chores-portrait.png", size).convert("RGBA")
    draw = ImageDraw.Draw(canvas)
    copy = COPY[locale]
    x, y, width = 76, 895, 928
    y = text(draw, (x, y), copy["name"], 76, color=GREEN)
    y += 20
    y = text(draw, (x, y), copy["headline"], 58, max_width=width)
    y += 16
    draw.text((x, y), copy["body"], font=font(FONT_REGULAR, 34), fill=INK)
    destination.parent.mkdir(parents=True, exist_ok=True)
    canvas.convert("RGB").save(destination, quality=95)


def main():
    for locale in COPY:
        make_wide(
            locale,
            (1024, 500),
            ASSETS / "google_play" / f"feature-graphic-{locale}.png",
        )
        make_wide(
            locale,
            (1200, 628),
            ASSETS / "app_store" / f"promo-{locale}.png",
        )
        make_portrait(locale, ASSETS / "social" / f"portrait-{locale}.png")


if __name__ == "__main__":
    main()

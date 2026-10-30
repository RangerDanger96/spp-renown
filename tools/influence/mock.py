"""Mockups of the Barrens Front influence tabards (original designs)."""
import math, random
from PIL import Image, ImageDraw, ImageFilter, ImageFont

S = 4                       # supersampling
W, H = 360, 520             # one tabard panel (final px)
FONT = "/usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf"


def tabard_shape(d, w, h, fill, trim, trim_w):
    """Front view of a tabard: shoulders, straight body, notched hem."""
    m = w * 0.08
    pts = [(m + w * 0.10, 0), (w - m - w * 0.10, 0), (w - m, h * 0.06), (w - m, h * 0.88),
           (w * 0.5 + w * 0.08, h * 0.96), (w * 0.5, h * 0.90), (w * 0.5 - w * 0.08, h * 0.96), (m, h * 0.88), (m, h * 0.06)]
    d.polygon(pts, fill=trim)
    inset = trim_w
    inner = [(m + w * 0.10 + inset, inset), (w - m - w * 0.10 - inset, inset), (w - m - inset, h * 0.06 + inset),
             (w - m - inset, h * 0.88 - inset), (w * 0.5 + w * 0.08, h * 0.96 - inset * 2.2), (w * 0.5, h * 0.90 - inset * 1.8),
             (w * 0.5 - w * 0.08, h * 0.96 - inset * 2.2), (m + inset, h * 0.88 - inset), (m + inset, h * 0.06 + inset)]
    d.polygon(inner, fill=fill)
    # neck opening
    d.ellipse([w * 0.36, -h * 0.05, w * 0.64, h * 0.07], fill=(0, 0, 0, 0))
    return inner


def cloth_texture(img, strength=10, seed=1):
    """Subtle woven noise so it reads as fabric."""
    rnd = random.Random(seed)
    px = img.load()
    for y in range(img.height):
        row = rnd.randint(-strength, strength) // 2
        for x in range(img.width):
            r, g, b, a = px[x, y]
            if a:
                n = row + rnd.randint(-strength, strength) // 2 + (3 if (x // (2 * S)) % 2 else -3)
                px[x, y] = (max(0, min(255, r + n)), max(0, min(255, g + n)), max(0, min(255, b + n)), a)


def branch(d, x, y, ang, length, width, depth, col, rnd):
    if depth == 0 or length < 3:
        return
    x2 = x + math.cos(ang) * length
    y2 = y - math.sin(ang) * length
    d.line([(x, y), (x2, y2)], fill=col, width=max(1, int(width)))
    d.ellipse([x2 - width / 2, y2 - width / 2, x2 + width / 2, y2 + width / 2], fill=col)
    spread = 0.42 + rnd.uniform(-0.05, 0.05)
    for s in (-1, 1):
        branch(d, x2, y2, ang + s * spread + rnd.uniform(-0.08, 0.08), length * 0.74, width * 0.68, depth - 1, col, rnd)
    if depth > 3:
        branch(d, x2, y2, ang + rnd.uniform(-0.1, 0.1), length * 0.6, width * 0.6, depth - 2, col, rnd)


def white_tree(size, col=(242, 240, 230, 255)):
    """Original design: a broad, rounded oak with two main limbs and spreading roots inside a ring."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    rnd = random.Random(11)
    cx = size / 2
    base = size * 0.72
    fork = size * 0.47
    # canopy: a wide dome built from overlapping leaf clusters, scalloped underside
    ccy, rx, ry = size * 0.31, size * 0.28, size * 0.23
    for i in range(46):
        t = rnd.uniform(0, 1)
        a = math.pi * t
        rr = math.sqrt(rnd.uniform(0.0, 1.0))
        lx = cx + math.cos(a) * rx * rr
        ly = ccy - math.sin(a) * ry * rr + ry * 0.35
        lr = size * rnd.uniform(0.045, 0.07)
        d.ellipse([lx - lr, ly - lr * 0.85, lx + lr, ly + lr * 0.85], fill=col)
    for i in range(9):   # rim clusters for a clean silhouette
        a = math.pi * (i + 0.5) / 9
        lx, ly = cx + math.cos(a) * rx, ccy - math.sin(a) * ry + ry * 0.35
        lr = size * 0.06
        d.ellipse([lx - lr, ly - lr * 0.85, lx + lr, ly + lr * 0.85], fill=col)
    # trunk with flared base
    d.polygon([(cx - size * 0.085, base), (cx - size * 0.035, base - size * 0.06), (cx - size * 0.03, fork),
               (cx + size * 0.03, fork), (cx + size * 0.035, base - size * 0.06), (cx + size * 0.085, base)], fill=col)
    # two main limbs into the canopy
    for s in (-1, 1):
        d.polygon([(cx - size * 0.03 * s, fork + size * 0.01), (cx + size * 0.005 * s, fork - size * 0.01),
                   (cx + size * 0.17 * s, ccy + ry * 0.55), (cx + size * 0.13 * s, ccy + ry * 0.70)], fill=col)
    # roots
    for a in (0.12, 0.45, 0.9):
        for s in (-1, 1):
            ang = -a if s > 0 else -(math.pi - a)
            branch(d, cx + s * size * 0.03, base, ang, size * 0.07, size * 0.04, 3, col, rnd)
    d.rectangle([cx - size * 0.30, base - size * 0.004, cx + size * 0.30, base + size * 0.008], fill=col)
    r = size * 0.47
    d.ellipse([cx - r, size / 2 - r, cx + r, size / 2 + r], outline=col, width=int(size * 0.02))
    return img


def red_eye(size):
    """Original design: an angular war-painted eye with a slit pupil and jagged orcish strokes."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    cx, cy = size / 2, size / 2
    red, dark, glow = (200, 20, 15, 255), (110, 5, 5, 255), (255, 120, 40, 255)
    # jagged brush strokes radiating (axe-cut, not flames)
    rnd = random.Random(3)
    for i in range(14):
        a = i / 14 * 2 * math.pi + rnd.uniform(-0.08, 0.08)
        r1, r2 = size * 0.30, size * rnd.uniform(0.40, 0.47)
        w = size * 0.035
        p1 = (cx + math.cos(a) * r1, cy + math.sin(a) * r1 * 0.75)
        p2 = (cx + math.cos(a) * r2, cy + math.sin(a) * r2 * 0.75)
        nx, ny = -math.sin(a) * w, math.cos(a) * w
        d.polygon([(p1[0] + nx, p1[1] + ny), (p1[0] - nx, p1[1] - ny), p2], fill=dark)
    # almond (angular) eye outline
    ew, eh = size * 0.32, size * 0.15
    outer = [(cx - ew, cy), (cx - ew * 0.45, cy - eh), (cx + ew * 0.45, cy - eh), (cx + ew, cy), (cx + ew * 0.45, cy + eh), (cx - ew * 0.45, cy + eh)]
    d.polygon(outer, fill=red)
    k = 0.72
    inner = [(cx + (x - cx) * k, cy + (y - cy) * k) for x, y in outer]
    d.polygon(inner, fill=(20, 0, 0, 255))
    # iris and slit pupil
    ir = eh * 0.95
    d.ellipse([cx - ir, cy - ir, cx + ir, cy + ir], fill=glow)
    d.ellipse([cx - ir * 0.75, cy - ir * 0.75, cx + ir * 0.75, cy + ir * 0.75], fill=red)
    d.ellipse([cx - ir * 0.38, cy - ir * 0.38, cx + ir * 0.38, cy + ir * 0.38], fill=(10, 0, 0, 255))
    d.ellipse([cx - ir * 0.38 + ir * 0.12, cy - ir * 0.30, cx - ir * 0.38 + ir * 0.30, cy - ir * 0.12], fill=(255, 200, 150, 255))
    # war-paint slash under the eye
    d.polygon([(cx - ew * 0.6, cy + eh * 1.5), (cx + ew * 0.7, cy + eh * 1.25), (cx + ew * 0.55, cy + eh * 1.55), (cx - ew * 0.7, cy + eh * 1.75)], fill=red)
    return img


def make_tabard(name, fill, trim, emblem, emblem_scale=0.62):
    w, h = W * S, H * S
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    tabard_shape(d, w, h, fill, trim, w * 0.035)
    # inner pinstripe
    cloth_texture(img, strength=14, seed=hash(name) & 0xffff)
    es = int(w * emblem_scale)
    e = emblem(es)
    img.alpha_composite(e, (int(w / 2 - es / 2), int(h * 0.40 - es / 2)))
    img = img.resize((W, H), Image.LANCZOS)
    # soft shadow
    shadow = Image.new("RGBA", (W + 30, H + 30), (0, 0, 0, 0))
    shadow.paste((0, 0, 0, 120), (15, 18), img.split()[3])
    shadow = shadow.filter(ImageFilter.GaussianBlur(8))
    shadow.alpha_composite(img, (15, 10))
    return shadow


def ingame_preview(tabard_img):
    """Rough idea of the 1.12 texture resolution: the chest region is about 64 px tall."""
    small = tabard_img.resize((tabard_img.width // 6, tabard_img.height // 6), Image.BILINEAR)
    return small.resize((small.width * 3, small.height * 3), Image.NEAREST)


def sheet():
    a = make_tabard("alliance", (22, 44, 110, 255), (196, 160, 70, 255), white_tree)
    h = make_tabard("horde", (16, 16, 18, 255), (130, 18, 14, 255), red_eye, 0.70)
    pad = 90
    big_w = a.width * 2 + pad * 3
    prev_a, prev_h = ingame_preview(a), ingame_preview(h)
    total_h = 90 + a.height + 60 + prev_a.height + 70
    out = Image.new("RGBA", (big_w, total_h), (28, 24, 20, 255))
    d = ImageDraw.Draw(out)
    title = ImageFont.truetype(FONT, 30)
    label = ImageFont.truetype(FONT, 17)
    small = ImageFont.truetype(FONT, 15)
    d.text((big_w / 2, 30), "Barrens Front - Influence Tabards (mockup)", font=title, fill=(255, 210, 90), anchor="mm")
    out.alpha_composite(a, (pad, 70))
    out.alpha_composite(h, (pad * 2 + a.width, 70))
    y = 70 + a.height + 18
    d.text((pad + a.width / 2, y), "Alliance: Tabard of the Barrens Vanguard", font=label, fill=(150, 190, 255), anchor="mm")
    d.text((pad * 2 + a.width * 1.5, y), "Horde: Tabard of the Barrens Warband", font=label, fill=(255, 110, 90), anchor="mm")
    y += 30
    d.text((big_w / 2, y), "Approximate in-game sharpness (1.12 tabard textures are small):", font=small, fill=(200, 190, 170), anchor="mm")
    y += 20
    out.alpha_composite(prev_a, (int(pad + a.width / 2 - prev_a.width / 2), y))
    out.alpha_composite(prev_h, (int(pad * 2 + a.width * 1.5 - prev_h.width / 2), y))
    out.convert("RGB").save("tabard_mockup.png")
    a.save("tabard_alliance.png"); h.save("tabard_horde.png")
    print(out.size)


if __name__ == "__main__":
    sheet()

"""Build the Barrens Front influence tabard textures from the stock Stormwind / Warsong tabards.

Front centre of the torso is the left edge of the TU/TL textures and back centre the right edge (the body mirrors
the texture), so each emblem is drawn as a half at both edges.
"""
import sys, colorsys
sys.path.insert(0, '/root/wf/tabards')
from PIL import Image
import blp
import mock   # emblem drawings (white_tree, red_eye)

OUT = 'out'


def combine(tu, tl):
    c = Image.new('RGBA', (128, 96), (0, 0, 0, 0))
    c.paste(tu, (0, 0)); c.paste(tl, (0, 64))
    return c


def inpaint(img, mask, skip=lambda p: False):
    """Fill masked pixels from their unmasked neighbours (repeated averaging)."""
    px = img.load(); w, h = img.size
    todo = {(x, y) for y in range(h) for x in range(w) if mask(x, y, px[x, y])}
    while todo:
        done = {}
        for x, y in todo:
            acc, n = [0, 0, 0], 0
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (1, -1), (-1, 1)):
                q = (x + dx, y + dy)
                if 0 <= q[0] < w and 0 <= q[1] < h and q not in todo and px[q][3] > 0 and not skip(px[q]):
                    c = px[q]; acc[0] += c[0]; acc[1] += c[1]; acc[2] += c[2]; n += 1
            if n:
                done[(x, y)] = (acc[0] // n, acc[1] // n, acc[2] // n, px[x, y][3])
        if not done:
            break
        for k, v in done.items():
            px[k] = v
        todo -= set(done)


def lum(c):
    return 0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2]


def in_boxes(x, y, boxes):
    return any(x0 <= x < x1 and y0 <= y < y1 for x0, y0, x1, y1 in boxes)


def place_emblems(canvas, emblem_fn, size, cy):
    big = emblem_fn(size * 4).resize((size, size), Image.LANCZOS)
    half = size // 2
    right_half = big.crop((half, 0, size, size))      # centre -> outer edge
    left_half = big.crop((0, 0, half, size))
    top = cy - size // 2
    # only paint on the tabard (keep the transparent neckline/shoulders)
    for part, x0 in ((right_half, 0), (left_half, 128 - half)):
        layer = Image.new('RGBA', canvas.size, (0, 0, 0, 0))
        layer.paste(part, (x0, top))
        a = layer.getchannel('A')
        a = Image.composite(a, Image.new('L', a.size, 0), canvas.getchannel('A').point(lambda v: 255 if v > 128 else 0))
        layer.putalpha(a)
        canvas.alpha_composite(layer)


def alliance(gender):
    tu, _ = blp.read('Tabard_A_01Stormwind_Chest_TU_%s.blp' % gender)
    tl, _ = blp.read('Tabard_A_01Stormwind_Chest_TL_%s.blp' % gender)
    c = combine(tu, tl)
    remove_lion(c)
    place_emblems(c, mock.white_tree, 40, 52)
    return c


def remove_lion(c):
    # Find the front trim (the tall gold component left of x=64) and clear everything left of it below the neckline
    px = c.load()
    gold = {(x, y) for y in range(96) for x in range(64) if px[x, y][3] > 0 and px[x, y][0] > px[x, y][2] + 10}
    seen, best = set(), None
    for start in gold:
        if start in seen:
            continue
        comp, stack = [], [start]
        seen.add(start)
        while stack:
            x, y = stack.pop(); comp.append((x, y))
            for q in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if q in gold and q not in seen:
                    seen.add(q); stack.append(q)
        ys = [p[1] for p in comp]
        span = max(ys) - min(ys)
        if best is None or span > best[0]:
            best = (span, comp)
    left = {}
    for x, y in best[1]:
        left[y] = min(left.get(y, 999), x)
    def trim_x(y):
        return left.get(y, 64)
    inpaint(c, lambda x, y, p: 36 <= y < 92 and x < trim_x(y) - 1 and p[3] > 0, skip=lambda p: p[0] > p[2] + 10)
    # a little fabric grain back on the flat fill
    import random
    rnd = random.Random(5); px = c.load()
    for y in range(36, 92):
        for x in range(0, int(trim_x(y)) - 1):
            r, g, b, a = px[x, y]
            if a:
                n = rnd.randint(-6, 6)
                px[x, y] = (max(0, min(255, r + n)), max(0, min(255, g + n)), max(0, min(255, b + n)), a)


def horde(gender):
    # same cut as the Alliance tabard (Stormwind base): blue cloth -> black, gold trim -> blood red
    tu, _ = blp.read('Tabard_A_01Stormwind_Chest_TU_%s.blp' % gender)
    tl, _ = blp.read('Tabard_A_01Stormwind_Chest_TL_%s.blp' % gender)
    c = combine(tu, tl)
    remove_lion(c)
    px = c.load()
    for y in range(96):
        for x in range(128):
            r, g, b, a = px[x, y]
            if not a:
                continue
            L = lum((r, g, b))
            gold = (r - b) / 255.0                       # >0 for gold trim, <0 for blue cloth
            t = max(0.0, min(1.0, (gold + 0.05) / 0.35)) # 0 = cloth, 1 = trim (soft edge)
            cloth = (int(L * 0.32), int(L * 0.30), int(L * 0.32))
            k = min(1.0, L / 200)
            trim = (int(60 + 170 * k), int(8 + 20 * k), int(6 + 14 * k))
            px[x, y] = (int(cloth[0] * (1 - t) + trim[0] * t), int(cloth[1] * (1 - t) + trim[1] * t),
                        int(cloth[2] * (1 - t) + trim[2] * t), a)
    place_emblems(c, mock.red_eye, 46, 52)
    return c


def split_save(c, name, gender):
    tu = c.crop((0, 0, 128, 64)); tl = c.crop((0, 64, 128, 96))
    blp.write(tu, '%s/%s_Chest_TU_%s.blp' % (OUT, name, gender))
    blp.write(tl, '%s/%s_Chest_TL_%s.blp' % (OUT, name, gender))
    return tu, tl


if __name__ == '__main__':
    import os
    os.makedirs(OUT, exist_ok=True)
    preview = Image.new('RGB', (1060, 420), (255, 0, 255))
    for i, (fn, name) in enumerate(((alliance, 'Tabard_A_01RenownVanguard'), (horde, 'Tabard_A_01RenownWarband'))):
        for g in 'MF':
            c = fn(g)
            split_save(c, name, g)
            if g == 'M':
                bg = Image.new('RGBA', c.size, (255, 0, 255, 255)); bg.alpha_composite(c)
                preview.paste(bg.convert('RGB').resize((512, 384), Image.NEAREST), (10 + i * 530, 10))
    preview.save('preview.png')
    print(sorted(os.listdir(OUT)))

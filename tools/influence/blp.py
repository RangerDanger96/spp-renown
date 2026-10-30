"""Minimal BLP2 (WoW 1.x) palettized reader/writer with 8-bit alpha and mipmaps."""
import struct
from PIL import Image

HDR = '<4sIBBBBII16I16I'


def read(path):
    d = open(path, 'rb').read()
    magic, typ, comp, adepth, atype, mips, w, h, *rest = struct.unpack_from(HDR, d, 0)
    offs, sizes = rest[:16], rest[16:]
    assert magic == b'BLP2' and comp == 1, (magic, comp)
    pal = struct.unpack_from('<1024B', d, struct.calcsize(HDR))
    o = offs[0]
    idx = d[o:o + w * h]
    alpha = None
    if adepth == 8:
        alpha = d[o + w * h:o + 2 * w * h]
    elif adepth == 1:
        bits = d[o + w * h:o + w * h + (w * h + 7) // 8]
        alpha = bytes(255 if (bits[i >> 3] >> (i & 7)) & 1 else 0 for i in range(w * h))
    img = Image.new('RGBA', (w, h))
    px = []
    for i, c in enumerate(idx):
        b, g, r = pal[c * 4], pal[c * 4 + 1], pal[c * 4 + 2]
        a = alpha[i] if alpha is not None else 255
        px.append((r, g, b, a))
    img.putdata(px)
    return img, dict(alpha_depth=adepth, alpha_type=atype, mips=mips)


def write(img, path, alpha_depth=8):
    img = img.convert('RGBA')
    w, h = img.size
    rgb = img.convert('RGB')
    # one palette for all mip levels
    q = rgb.quantize(colors=256, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    palette = q.getpalette()[:768]
    palette += [0] * (768 - len(palette))
    levels = []
    lw, lh, cur = w, h, img
    while True:
        lvl = cur.resize((lw, lh), Image.BOX) if (lw, lh) != img.size else img
        qi = lvl.convert('RGB').quantize(palette=q, dither=Image.Dither.NONE)
        data = bytes(qi.getdata())
        if alpha_depth == 8:
            data += bytes(lvl.getchannel('A').getdata())
        levels.append(data)
        if lw == 1 and lh == 1:
            break
        lw, lh = max(1, lw // 2), max(1, lh // 2)
        if len(levels) == 16:
            break
    hdr_size = struct.calcsize(HDR) + 1024
    offs, sizes, pos = [], [], hdr_size
    for lv in levels:
        offs.append(pos); sizes.append(len(lv)); pos += len(lv)
    offs += [0] * (16 - len(offs)); sizes += [0] * (16 - len(sizes))
    out = bytearray(struct.pack(HDR, b'BLP2', 1, 1, alpha_depth, 8 if alpha_depth == 8 else 0, 1, w, h, *offs, *sizes))
    pal = bytearray()
    for i in range(256):
        r, g, b = palette[i * 3:i * 3 + 3]
        pal += bytes((b, g, r, 0))
    out += pal
    for lv in levels:
        out += lv
    open(path, 'wb').write(out)

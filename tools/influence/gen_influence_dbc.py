#!/usr/bin/env python3
"""Client/server data for the Barrens Front influence system.

  * ItemDisplayInfo: the two influence tabards (custom textures + icons)
  * CreatureModelData / CreatureDisplayInfo: the war boards as NPC bodies (War Map table, Call to Arms board)
Writes to out_inf/ : DBCs plus the texture/icon BLPs with their in-MPQ paths.
"""
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, '/root/wf/tex'); sys.path.insert(0, '/root/wf/tabards')
from dbc import DBC, f2u
from PIL import Image, ImageDraw
import blp, mock

OUT = 'out_inf'
os.makedirs(OUT, exist_ok=True)

TABARD_DISPLAY = {'Vanguard': 50100, 'Warband': 50101}
BOARD_MODEL = {17600: (2400, r'World\Generic\Passive Doodads\WantedPosters\NewWantedPoster02.mdx', 1.6, 2.4),      # Call to Arms (Alliance)
               17601: (2401, r'World\Kalimdor\Orgrimmar\PassiveDoodads\MapTable\HordeMapTable.mdx', 2.2, 1.4)}       # War Map (Horde)
FILES = {}   # in-MPQ path -> local file

# ---------------------------------------------------------------- tabard icons (64x64)
def icon(name, emblem_fn, cloth, trim, emblem_scale):
    S = 256
    img = Image.new('RGBA', (S, S), trim + (255,))
    d = ImageDraw.Draw(img)
    d.rectangle([14, 14, S - 15, S - 15], fill=cloth + (255,))
    e = emblem_fn(int(S * emblem_scale))
    img.alpha_composite(e, ((S - e.width) // 2, (S - e.height) // 2))
    img = img.resize((64, 64), Image.LANCZOS)
    path = r'Interface\Icons\%s.blp' % name
    local = os.path.join(OUT, name + '.blp')
    blp.write(img, local, alpha_depth=0)
    FILES[path] = local
    img.save(os.path.join(OUT, name + '.png'))

icon('INV_Misc_Tabard_RenownVanguard', mock.white_tree, (22, 44, 110), (196, 160, 70), 0.86)
icon('INV_Misc_Tabard_RenownWarband', mock.red_eye, (16, 16, 18), (130, 18, 14), 0.98)

# ---------------------------------------------------------------- tabard textures (built by tex/make_tex.py)
for key in ('Vanguard', 'Warband'):
    for part, folder in (('TU', 'TorsoUpperTexture'), ('TL', 'TorsoLowerTexture')):
        for g in 'MF':
            fn = 'Tabard_A_01Renown%s_Chest_%s_%s.blp' % (key, part, g)
            FILES['Item\\TextureComponents\\%s\\%s' % (folder, fn)] = os.path.join('/root/wf/tex/out', fn)

# ---------------------------------------------------------------- ItemDisplayInfo
idi = DBC('ItemDisplayInfo.dbc'); ii = idi.index()
idi.rows = [r for r in idi.rows if r[0] not in TABARD_DISPLAY.values()]
base = ii[32031]   # Warsong Battle Tabard
for key, did in TABARD_DISPLAY.items():
    r = list(base); r[0] = did
    r[5] = idi.addstr('INV_Misc_Tabard_Renown' + key)
    r[17] = idi.addstr('Tabard_A_01Renown%s_Chest_TU' % key)
    r[18] = idi.addstr('Tabard_A_01Renown%s_Chest_TL' % key)
    idi.rows.append(r)
idi.save(os.path.join(OUT, 'ItemDisplayInfo.dbc'))

# ---------------------------------------------------------------- creature bodies for the war boards
cmd = DBC('CreatureModelData.dbc'); cdi = DBC('CreatureDisplayInfo.dbc')
model_ids = [m[0] for m in BOARD_MODEL.values()]
cmd.rows = [r for r in cmd.rows if r[0] not in model_ids]
cdi.rows = [r for r in cdi.rows if r[0] not in BOARD_MODEL]
mbase = next(r for r in cmd.rows if r[0] == 181)       # Stasis Totem: a static, non-animated creature model
dbase = next(r for r in cdi.rows if r[0] == 1421)
for disp, (mid, path, width, height) in BOARD_MODEL.items():
    m = list(mbase); m[0] = mid; m[2] = cmd.addstr(path); m[14] = f2u(width / 2); m[15] = f2u(height)
    cmd.rows.append(m)
    d = list(dbase); d[0] = disp; d[1] = mid; d[2] = 0; d[3] = 0; d[4] = f2u(1.0); d[5] = 255; d[6] = d[7] = d[8] = 0; d[9] = 0; d[10] = 0; d[11] = 0
    cdi.rows.append(d)
cmd.rows.sort(key=lambda r: r[0]); cdi.rows.sort(key=lambda r: r[0])
cmd.save(os.path.join(OUT, 'CreatureModelData.dbc'))
cdi.save(os.path.join(OUT, 'CreatureDisplayInfo.dbc'))

for n in ('ItemDisplayInfo', 'CreatureModelData', 'CreatureDisplayInfo'):
    FILES['DBFilesClient\\%s.dbc' % n] = os.path.join(OUT, n + '.dbc')
with open(os.path.join(OUT, 'files.txt'), 'w') as f:
    for k, v in FILES.items():
        f.write('%s=%s\n' % (v, k))
print(len(FILES), 'files')

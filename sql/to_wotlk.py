#!/usr/bin/env python3
"""Convert the classic SQL outputs of the generators into WotLK (CMaNGOS-WOTLK) SQL.

The generators target the classic world database; WotLK differs in a few columns:
  creature_template  DisplayIdN -> ModelIdN, no DisplayIdProbabilityN / Civilian / stat multipliers
  battleground_template  no MinLvl/MaxLvl (brackets come from PvPDifficulty.dbc)
  areatrigger_teleport   no status_failed_text
  quest_template     quest XP comes from RewXPId
Usage: to_wotlk.py zz_rvr.sql zz_influence.sql ...  -> wotlk/<name>
"""
import os, re, sys

DROP_COLS = re.compile(r"^(DisplayIdProbability\d|Civilian|StrengthMultiplier|AgilityMultiplier|StaminaMultiplier|IntellectMultiplier|SpiritMultiplier|DamageMultiplierOLD|DamageVarianceOLD|status_failed_text)$")


def split_assignments(body):
    """Split 'a=1, b='x,y', c=3' at top-level commas."""
    parts, cur, q = [], '', False
    i = 0
    while i < len(body):
        ch = body[i]
        if ch == "'":
            if q and i + 1 < len(body) and body[i + 1] == "'":
                cur += "''"; i += 2; continue
            q = not q
        if ch == ',' and not q:
            parts.append(cur); cur = ''
        else:
            cur += ch
        i += 1
    if cur.strip():
        parts.append(cur)
    return parts


def fix_update(stmt):
    m = re.match(r"(?is)^(UPDATE\s+\S+\s+SET\s+)(.*?)(\s+WHERE\s+.*|;)\s*$", stmt)
    if not m:
        return stmt
    head, body, tail = m.groups()
    out = []
    for a in split_assignments(body):
        k = a.split('=', 1)[0].strip()
        if DROP_COLS.match(k):
            continue
        a = re.sub(r"^(\s*)DisplayId(\d)(\s*=)", r"\1ModelId\2\3", a)
        out.append(a.strip())
    if not out:
        return ''
    if not tail.strip().endswith(';'):
        tail += ';'
    return head + ', '.join(out) + tail


EVENT_TOKEN = re.compile(r"(?<![\d.])(-?)(11[0-3]\d)(?![\d.])")
GO_GUID = re.compile(r"(?<![\d.])540(\d{4})(?![\d.])")


def remap(ln):
    """WotLK collisions: game_event 1100+ is taken (ours move to 2100+), gameobject guids 5400000+ too (-> 9600000+)."""
    low = ln.lower()
    if 'event' in low or 'conditions' in low or ('between' in low and '11' in low and 'game_event' in low):
        ln = EVENT_TOKEN.sub(lambda m: m.group(1) + str(int(m.group(2)) + 1000), ln)
    ln = GO_GUID.sub(lambda m: '960' + m.group(1), ln)
    return ln


def convert(sql):
    lines = sql.replace('\r\n', '\n').split('\n')
    res = []
    ctx = None   # table of a multi-line INSERT in progress
    for ln in lines:
        m = re.match(r"(?i)^\s*INSERT\s+(?:IGNORE\s+)?INTO\s+(\w+)", ln)
        if m:
            ctx = m.group(1).lower()
        elif ctx == 'game_event':
            ln = re.sub(r"^\((11[0-3]\d),", lambda mm: "(%d," % (int(mm.group(1)) + 1000), ln)
        elif ctx == 'conditions':
            ln = re.sub(r"^\((\d+),12,(11[0-3]\d),", lambda mm: "(%s,12,%d," % (mm.group(1), int(mm.group(2)) + 1000), ln)
        if ln.rstrip().endswith(';'):
            ctx_next = None
        else:
            ctx_next = ctx
        ln = remap(ln)
        ctx = ctx_next
        s = ln.strip()
        if re.match(r"(?i)^UPDATE\s+battleground_template\b", s):
            continue                                            # level ranges live in PvPDifficulty.dbc
        if re.match(r"(?i)^UPDATE\s+\S+\s+SET\s", s) and s.endswith(';'):
            ln = fix_update(s)
            if not ln:
                continue
        res.append(ln)
    out = '\n'.join(res)
    # war board quests: WotLK needs an XP reward index
    if 'INSERT INTO quest_template' in out:
        out += "\nUPDATE quest_template SET RewXPId=5 WHERE entry BETWEEN 90101 AND 90119 AND RewXPId=0;\n"
    return out


if __name__ == '__main__':
    here = os.path.dirname(os.path.abspath(__file__))
    os.makedirs(os.path.join(here, 'wotlk'), exist_ok=True)
    for f in sys.argv[1:]:
        src = open(os.path.join(here, f), encoding='utf-8').read()
        dst = os.path.join(here, 'wotlk', os.path.basename(f))
        open(dst, 'w', encoding='utf-8', newline='\r\n').write(convert(src))
        print('wrote', dst)

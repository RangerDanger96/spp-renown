#!/usr/bin/env python3
"""WoW Forever warrior talents for the 1.12 Renown realm.

Reads the original Spell.dbc / Talent.dbc (1.12.1), writes:
  out/Spell.dbc, out/Talent.dbc, out/SkillLineAbility.dbc  (client patch + server Talent.dbc)
  out/zz_warrior_talents.sql                                (server spell_template etc.)
  out/specs.txt                                             (playerbot premade spec links)
"""
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from dbc import DBC, S, i32

os.makedirs('out', exist_ok=True)
sp = DBC('Spell.dbc'); SI = sp.index()
tal = DBC('Talent.dbc')
sla = DBC('SkillLineAbility.dbc')

ARMS, FURY, PROT = 161, 164, 163

# ---------------------------------------------------------------- spell helpers
SQL = []
# dbc field -> sql column (per-effect fields get 1..3 suffix)
COL = dict(School='School', Category='Category', Dispel='Dispel', Mechanic='Mechanic', Attr='Attributes',
           AttrEx='AttributesEx', AttrEx2='AttributesEx2', AttrEx3='AttributesEx3', Stances='Stances',
           StancesNot='StancesNot', Targets='Targets', CasterAuraState='CasterAuraState',
           TargetAuraState='TargetAuraState', CastTime='CastingTimeIndex', Recovery='RecoveryTime',
           CatRecovery='CategoryRecoveryTime', InterruptFlags='InterruptFlags', AuraInterrupt='AuraInterruptFlags',
           ProcFlags='ProcFlags', ProcChance='ProcChance', ProcCharges='ProcCharges', MaxLevel='MaxLevel',
           BaseLevel='BaseLevel', SpellLevel='SpellLevel', Duration='DurationIndex', PowerType='PowerType',
           ManaCost='ManaCost', Range='RangeIndex', StackAmount='StackAmount', EquipClass='EquippedItemClass',
           EquipSubMask='EquippedItemSubClassMask', EquipInvMask='EquippedItemInventoryTypeMask',
           Effect='Effect', DieSides='EffectDieSides', BaseDice='EffectBaseDice', BasePoints='EffectBasePoints',
           Mechanic_E='EffectMechanic', TargetA='EffectImplicitTargetA', TargetB='EffectImplicitTargetB',
           Radius='EffectRadiusIndex', Aura='EffectApplyAuraName', Amplitude='EffectAmplitude',
           ChainTarget='EffectChainTarget', ItemType='EffectItemType', MiscValue='EffectMiscValue',
           TriggerSpell='EffectTriggerSpell', Visual='SpellVisual', Icon='SpellIconID', Family='SpellFamilyName',
           DmgClass='DmgClass', Prevention='PreventionType', StartRecCat='StartRecoveryCategory',
           StartRecTime='StartRecoveryTime')
PER_EFFECT = {'Effect', 'DieSides', 'BaseDice', 'BasePoints', 'Mechanic_E', 'TargetA', 'TargetB', 'Radius', 'Aura',
              'Amplitude', 'ChainTarget', 'ItemType', 'MiscValue', 'TriggerSpell'}
STR = {'Name': 'SpellName', 'Rank': 'Rank1'}

def setf(sid, field, value, eff=None):
    """Set a spell field in the DBC row and queue the matching SQL update."""
    r = SI[sid]
    if field in STR:
        r[S[field]] = sp.addstr(value)
        r[S[field] + 8] = 0x3f007e  # enUS string flags as in the stock file
        SQL.append("UPDATE spell_template SET %s='%s' WHERE Id=%d;" % (STR[field], value.replace("'", "''"), sid))
        return
    if field in ('Desc', 'Tooltip'):
        r[S[field]] = sp.addstr(value)
        r[S[field] + 8] = 0x3f007e if value else 0
        return
    if field == 'FamilyFlags':
        r[S['FamilyFlags']] = value & 0xffffffff
        r[S['FamilyFlags2']] = value >> 32
        SQL.append("UPDATE spell_template SET SpellFamilyFlags=%d WHERE Id=%d;" % (value, sid))
        return
    idx = S[field] + (eff or 0)
    r[idx] = value & 0xffffffff
    col = COL[field] + (str((eff or 0) + 1) if field in PER_EFFECT else '')
    SQL.append("UPDATE spell_template SET %s=%d WHERE Id=%d;" % (col, value, sid))

def setv(sid, value, eff=0):
    """Effect value as shown in game (stored = value - 1 with 1 die side)."""
    setf(sid, 'DieSides', 1, eff)
    setf(sid, 'BasePoints', value - 1, eff)

def clear_effect(sid, eff):
    for f in ('Effect', 'Aura', 'BasePoints', 'DieSides', 'MiscValue', 'TriggerSpell', 'ItemType', 'TargetA',
              'TargetB', 'Radius', 'Amplitude', 'ChainTarget', 'Mechanic_E'):
        setf(sid, f, 0, eff)

def clone(new_id, base_id):
    """New spell copied from base (DBC row + SQL row)."""
    assert new_id not in SI, new_id
    row = list(SI[base_id]); row[0] = new_id
    sp.rows.append(row); SI[new_id] = row
    SQL.append("DELETE FROM spell_template WHERE Id=%d;" % new_id)
    SQL.append("INSERT INTO tmp_wsp SELECT * FROM spell_template WHERE Id=%d;" % base_id)
    SQL.append("UPDATE tmp_wsp SET Id=%d;" % new_id)
    SQL.append("INSERT INTO spell_template SELECT * FROM tmp_wsp; DELETE FROM tmp_wsp;")
    # neutral defaults
    setf(new_id, 'Rank', '')
    setf(new_id, 'Tooltip', '')
    return new_id

def passive(new_id, name, icon, desc, rank='', base=12320):
    """Talent passive (copied from Cruelty rank 1): effect 1 = aura 4 (dummy) unless overridden."""
    clone(new_id, base)
    setf(new_id, 'Name', name); setf(new_id, 'Rank', rank); setf(new_id, 'Icon', icon); setf(new_id, 'Desc', desc)
    setf(new_id, 'Aura', 4, 0); setv(new_id, 0, 0); setf(new_id, 'MiscValue', 0, 0); setf(new_id, 'ItemType', 0, 0)
    setf(new_id, 'EquipClass', -1); setf(new_id, 'EquipSubMask', 0); setf(new_id, 'EquipInvMask', 0)
    setf(new_id, 'ProcFlags', 0); setf(new_id, 'ProcChance', 101); setf(new_id, 'ProcCharges', 0)
    setf(new_id, 'Family', 4); setf(new_id, 'FamilyFlags', 0)
    return new_id

def dummy_trigger(new_id, name, icon, self_target=False):
    """Triggered dummy (copied from Deep Wounds 12162): handled in RenownTalents.cpp OnHit."""
    clone(new_id, 12162)
    setf(new_id, 'Name', name); setf(new_id, 'Icon', icon); setf(new_id, 'Desc', '')
    setf(new_id, 'Effect', 3, 0); setf(new_id, 'TargetA', 1 if self_target else 6, 0); setf(new_id, 'TargetB', 0, 0)
    setf(new_id, 'DmgClass', 0); setf(new_id, 'Family', 4); setf(new_id, 'FamilyFlags', 0)
    setf(new_id, 'Range', 1 if self_target else 2)
    return new_id

def rank_str(i):
    return 'Rank %d' % (i + 1)

W = dict(HS=0x40, REND=0x20, HAM=0x2, OP=0x4, TC=0x80, BLOODRAGE=0x100, DISARM=0x200, REVENGE=0x400, SBASH=0x800,
         SBLOCK=0x1000, SWALL=0x2000, SUNDER=0x4000, TAUNT=0x8000, BSHOUT=0x10000, DSHOUT=0x20000, ISHOUT=0x40000,
         CSHOUT=0x80000, SLAM=0x200000, CLEAVE=0x400000, MS_BT=0x2000000, CONC=0x4000000, MOCK=0x8000000,
         BRAGE=0x10000000, EXEC=0x20000000, INTERCEPT=0x40000000, WW=0x80000000)

def talent_ranks(tid):
    r = next(x for x in tal.rows if x[0] == tid)
    return [x for x in r[4:13] if x]

# ================================================================ changed existing talents
# --- Arms
for i, s in enumerate(talent_ranks(127)):                       # Improved Rend 12/24/36
    setv(s, 12 * (i + 1))
for i, s in enumerate(talent_ranks(641)):                       # Improved Tactical Mastery (core: 10 base + 3/rank)
    setf(s, 'Name', 'Improved Tactical Mastery')
    setf(s, 'Desc', 'You retain up to %d of your rage points when you change stances (10 without this talent).' % (10 + 3 * (i + 1)))
setf(12296, 'Desc', 'Generates 1 rage every 3 sec while in combat, and increases the time required for your rage to decay while out of combat by 30%.')
two_hand = talent_ranks(136)[:3]                                # Two-Handed Weapon Specialization: 3 ranks, 1%/rank
for i, s in enumerate(two_hand):
    setv(s, i + 1)
for s in talent_ranks(662):
    setf(s, 'Desc', 'Increases the critical strike damage bonus of your abilities by $s1%.')
slam = talent_ranks(168)[:2]                                    # Improved Slam: 2 ranks, 0.25 sec each
for i, s in enumerate(slam):
    setv(s, -250 * (i + 1))
    setf(s, 'Desc', 'Decreases the casting time of your Slam ability by $/1000;S1 sec.')

# --- Fury
shouts = W['BSHOUT'] | W['DSHOUT'] | W['ISHOUT'] | W['CSHOUT']
for i, s in enumerate(talent_ranks(158)):                       # Booming Voice: shouts +10% area, -5% rage cost per rank
    setf(s, 'MiscValue', 14, 0); setv(s, -5 * (i + 1), 0); setf(s, 'ItemType', shouts, 0)
    setf(s, 'MiscValue', 6, 1); setv(s, 10 * (i + 1), 1); setf(s, 'ItemType', shouts, 1)
    setf(s, 'Desc', 'Increases the area of effect of your Shouts by $s2%% and reduces their rage cost by %d%%.' % (5 * (i + 1)))
for i, s in enumerate(talent_ranks(159)):                       # Unbridled Wrath 12%/rank
    setf(s, 'ProcChance', 12 * (i + 1))
SQL.append("UPDATE spell_proc_event SET ppmRate=3 WHERE entry=12322;")
for i, s in enumerate(talent_ranks(661)):                       # Blood Craze: also on big hits (RenownTalents.cpp)
    setf(s, 'Desc', 'Regenerates $%do1%% of your total Health over $%dd after being the victim of a critical strike or a hit for more than 20%% of your maximum Health.' % ((16488, 16490, 16491)[i], (16488, 16490, 16491)[i]))
for i, s in enumerate(talent_ranks(1581)):                      # Dual Wield Specialization: +10% off-hand rage/rank (core hook)
    setf(s, 'Desc', 'Increases the damage done by your offhand weapon by $s1%% and the rage it generates by %d%%.' % (10 * (i + 1)))
enrage_buffs = (12880, 14201, 14202, 14203, 14204)              # Enrage: 30% on any hit taken, +2% physical/rank for 12 sec
for i, s in enumerate(talent_ranks(155)):
    setf(s, 'ProcChance', 30)
    setf(s, 'Desc', 'Gives you a 30%% chance after being hit to increase your Physical damage by %d%% for 12 sec.' % (2 * (i + 1)))
for i, b in enumerate(enrage_buffs):
    setv(b, 2 * (i + 1)); setf(b, 'ProcCharges', 0); setf(b, 'ProcFlags', 0); setf(b, 'Duration', 29)
    setf(b, 'Tooltip', 'Physical damage increased by $s1%.')
SQL.append("UPDATE spell_proc_event SET procEx=3 WHERE entry=12317;")
for i, s in enumerate(talent_ranks(1542)):                      # Improved Execute 3/5
    setv(s, (-30, -50)[i])
setf(12328, 'Aura', 87, 2); setf(12328, 'MiscValue', 127, 2); setv(12328, 5, 2)   # Death Wish: +5% damage taken
setf(12328, 'Desc', 'When activated, increases your physical damage by $s1% and makes you immune to Fear effects, but increases all damage taken by $s3%.  Lasts $d.')
setf(12328, 'Tooltip', 'Physical damage increased by $s1%.  Immune to Fear.  Damage taken increased by $s3%.')
for i, b in enumerate((12966, 12967, 12968, 12969, 12970)):    # Flurry 5%/rank
    setv(b, 5 * (i + 1))
for s in talent_ranks(1541):
    setf(s, 'Desc', 'The Berserker Rage ability will generate $/10;%ds1 rage when used and has a %d%% chance to remove movement impairing effects.' % ((23690, 23691)[talent_ranks(1541).index(s)], 50 * (talent_ranks(1541).index(s) + 1)))
setf(23881, 'Desc', 'Instantly attack the target causing damage equal to $s1% of your attack power and increasing your movement speed by 10% for 10 sec.  In addition, the next $23885n successful melee attacks will restore $23880s1 health.  This effect lasts $23885d.')

# --- Protection
for i, s in enumerate(talent_ranks(142)):                       # Improved Bloodrage: +25% rage/rank
    setf(s, 'Aura', 108, 0); setv(s, 25 * (i + 1), 0); setf(s, 'ItemType', W['BLOODRAGE'], 0)
    setf(s, 'Desc', 'Increases the instant Rage generated by your Bloodrage ability by $s1%.')
setv(23602, 5)                                                  # Shield Specialization: 5 rage per block proc
for s in talent_ranks(1601):
    setf(s, 'Desc', 'Increases your chance to block attacks with a shield by $s1% and has a $h% chance to generate 5 rage when a block occurs.')
for i, s in enumerate(talent_ranks(141)):                       # Iron Will: Stun and Fear
    setf(s, 'MiscValue', 5, 0)
    setf(s, 'Desc', 'Increases your chance to resist Stun and Fear effects by an additional $s1%.')
for i, s in enumerate(talent_ranks(138)):                       # Anticipation +4 defense/rank
    setv(s, 4 * (i + 1))
for i, s in enumerate(talent_ranks(147)):                       # Improved Revenge: +20% damage/rank
    setf(s, 'Aura', 108, 0); setf(s, 'MiscValue', 0, 0); setv(s, 20 * (i + 1), 0); setf(s, 'TriggerSpell', 0, 0)
    setf(s, 'ItemType', W['REVENGE'], 0); setf(s, 'ProcFlags', 0); setf(s, 'ProcChance', 101)
    setf(s, 'Desc', 'Increases the damage of your Revenge ability by $s1%.')
SQL.append("DELETE FROM spell_proc_event WHERE entry=12797;")
for i, s in enumerate(talent_ranks(128)):                       # Improved Thunder Clap -2 rage/rank (moved to Protection)
    setv(s, -20 * (i + 1))
setf(12975, 'Desc', 'When activated, this ability temporarily grants you 30% of your maximum hit points for 20 seconds.  After the effect expires, the hit points are lost.')
for i, s in enumerate(talent_ranks(151)):                       # Improved Disarm: -7 sec cooldown/rank
    setf(s, 'MiscValue', 11, 0); setv(s, -7000 * (i + 1), 0)
    setf(s, 'Desc', 'Reduces the cooldown of your Disarm ability by $/1000;S1 sec.')
defiance = talent_ranks(144)[:3]                                # Defiance: 3 ranks, 5%/rank
for i, s in enumerate(defiance):
    setv(s, 5 * (i + 1))
for i, s in enumerate(talent_ranks(150)):                       # Improved Shield Wall: -5.5 min cooldown/rank
    setf(s, 'MiscValue', 11, 0); setv(s, -330000 * (i + 1), 0)
    setf(s, 'Desc', 'Reduces the cooldown of your Shield Wall ability by %s min.' % ('5.5', '11')[i])
for i, s in enumerate(talent_ranks(702)):                       # Bastion (was One-Handed Weapon Specialization)
    setf(s, 'Name', 'Bastion'); setf(s, 'Icon', 917); setv(s, 2 * (i + 1), 0)
    setf(s, 'EquipClass', 4); setf(s, 'EquipSubMask', 0x40); setf(s, 'EquipInvMask', 0)
    setf(s, 'Desc', 'Increases all damage you deal by $s1% while you have a shield equipped.')
for s, (lo, hi) in zip((23922, 23923, 23924, 23925), ((421, 439), (494, 516), (567, 593), (640, 670))):   # Shield Slam
    setf(s, 'BasePoints', lo - 1, 1); setf(s, 'DieSides', hi - lo + 1, 1)
# folded talents
SQL.append("UPDATE spell_template SET ProcCharges=2 WHERE Id IN (2565);")      # Shield Block blocks 2 attacks
SI[2565][S['ProcCharges']] = 2
setf(2565, 'Desc', 'Increases your chance to block by 75% for $d.  Will block at most 2 attacks.')
setf(2565, 'Tooltip', 'Block chance increased by 75%.')

# ================================================================ new spells
N = {}
nid = [45000]
def new(key):
    N[key] = nid[0]; nid[0] += 1; return N[key]

# Spearing Strike (active, from Mortal Strike)
s = clone(new('spear'), 12294)
setf(s, 'Name', 'Spearing Strike'); setf(s, 'Icon', 370)
clear_effect(s, 1); clear_effect(s, 2)
setf(s, 'Effect', 31, 0); setf(s, 'Aura', 0, 0); setv(s, 40, 0); setf(s, 'MiscValue', 0, 0); setf(s, 'TargetA', 6, 0)
setf(s, 'Stances', 0x10000); setf(s, 'ManaCost', 150); setf(s, 'Recovery', 20000); setf(s, 'CatRecovery', 0)
setf(s, 'Category', 0); setf(s, 'Duration', 0); setf(s, 'FamilyFlags', 0); setf(s, 'Mechanic', 0)
setf(s, 'Desc', 'A thrust that deals $s1% weapon damage, increased by 80% against Giants, Dragonkin and mounted targets, and knocks a mounted target off its mount.  Requires Battle Stance.')
setf(s, 'Tooltip', '')

# Bloodthrill
bt_dummy = dummy_trigger(new('bloodthrill_t'), 'Bloodthrill', 541)
bloodthrill = []
for i in range(5):
    s = passive(new('bloodthrill%d' % i), 'Bloodthrill', 541,
                'Your melee hits against targets afflicted by your Rend have a $h% chance to allow the use of Overpower.', rank_str(i))
    setf(s, 'Aura', 42, 0); setf(s, 'TriggerSpell', bt_dummy, 0); setf(s, 'ProcFlags', 0x4); setf(s, 'ProcChance', 4 * (i + 1))
    bloodthrill.append(s)

# Weaponmaster
wm_dummy = dummy_trigger(new('wm_t'), 'Weaponmaster', 996)
weaponmaster = []
for i in range(5):
    s = passive(new('wm%d' % i), 'Weaponmaster', 996,
                'Axes and Polearms: increases your critical strike chance by %d%%.  Maces and Staves: your attacks ignore %d%% of your target\'s armor.  Swords: gives you a $h%% chance to get an extra attack on the same target after dealing damage.' % (i + 1, 3 * (i + 1)), rank_str(i))
    setf(s, 'Aura', 42, 0); setf(s, 'TriggerSpell', wm_dummy, 0); setf(s, 'ProcFlags', 0x14); setf(s, 'ProcChance', i + 1)
    weaponmaster.append(s)

# Lingering Rage
lingering = [passive(new('lr%d' % i), 'Lingering Rage', 561,
                     'Your rage begins to decay %d sec later after you leave combat.' % (2 * (i + 1)), rank_str(i)) for i in range(5)]
# Furious Precision
FP = (4, 7, 10)
furious = [passive(new('fp%d' % i), 'Furious Precision', 1504,
                   'Increases your chance to hit with off-hand melee attacks by %d%%.' % FP[i], rank_str(i)) for i in range(3)]
# Raging Blows
s = passive(new('rb'), 'Raging Blows', 83,
            'Reduces the rage cost of your Cleave and Whirlwind abilities by $/10;s1, and your Whirlwind also strikes with your off-hand weapon.')
setf(s, 'Aura', 107, 0); setf(s, 'MiscValue', 14, 0); setv(s, -30, 0); setf(s, 'ItemType', W['WW'] | W['CLEAVE'], 0)
raging = [s]
s = clone(new('ww_oh'), 1680)                                   # Whirlwind off-hand strike
setf(s, 'Name', 'Whirlwind'); setf(s, 'Rank', 'Off-Hand'); setf(s, 'Desc', '')
setf(s, 'AttrEx3', SI[1680][S['AttrEx3']] | 0x01000000); setf(s, 'TargetA', 6, 0); setf(s, 'TargetB', 0, 0)
setf(s, 'Radius', 0, 0); setf(s, 'ChainTarget', 0, 0); setf(s, 'ManaCost', 0); setf(s, 'Recovery', 0)
setf(s, 'CatRecovery', 0); setf(s, 'Category', 0); setf(s, 'Stances', 0); setf(s, 'FamilyFlags', 0)
setf(s, 'StartRecTime', 0); setf(s, 'StartRecCat', 0); setf(s, 'Range', 2)
# Gore Drinker
gore_heal = dummy_trigger(new('gore_heal'), 'Gore Drinker', 1568, self_target=True)
s = clone(new('gore_buff'), 23885)
setf(s, 'Name', 'Gore Drinker'); setf(s, 'Icon', 1568); setf(s, 'TriggerSpell', gore_heal, 0); setf(s, 'ProcCharges', 3)
setf(s, 'Desc', ''); setf(s, 'Tooltip', 'Your next $n melee attacks restore health.'); setf(s, 'FamilyFlags', 0)
gore = [passive(new('gore%d' % i), 'Gore Drinker', 1568,
                'After using Bloodthirst, Death Wish, Recklessness or Berserker Rage, or when Enrage activates, your next 3 melee attacks each restore %s%% of your maximum health.' % ('0.5', '1.0')[i], rank_str(i)) for i in range(2)]
# Master of Defense
mod_energize = clone(new('mod_e'), 23602)
setf(mod_energize, 'Name', 'Master of Defense'); setf(mod_energize, 'Icon', 563); setv(mod_energize, 5)
master = []
for i in range(2):
    s = passive(new('mod%d' % i), 'Master of Defense', 563,
                'Gives you a $h% chance to generate 5 rage when you dodge or parry an attack while you have a shield equipped.', rank_str(i))
    setf(s, 'Aura', 42, 0); setf(s, 'TriggerSpell', mod_energize, 0); setf(s, 'ProcFlags', 0x28); setf(s, 'ProcChance', 50 * (i + 1))
    setf(s, 'EquipClass', 4); setf(s, 'EquipSubMask', 0x40)
    master.append(s)
# Vanguard
vanguard = [passive(new('vanguard'), 'Vanguard', 276, 'Allows the use of Charge in Defensive Stance.')]
# Focused Rage
offensive = (W['HS'] | W['REND'] | W['HAM'] | W['OP'] | W['TC'] | W['REVENGE'] | W['SBASH'] | W['SUNDER'] | W['SLAM'] |
             W['CLEAVE'] | W['MS_BT'] | W['CONC'] | W['MOCK'] | W['EXEC'] | W['INTERCEPT'] | W['WW'] | W['DISARM'])
focused = []
for i in range(3):
    s = passive(new('fr%d' % i), 'Focused Rage', 1661, 'Reduces the rage cost of your offensive abilities by $/10;s1.', rank_str(i))
    setf(s, 'Aura', 107, 0); setf(s, 'MiscValue', 14, 0); setv(s, -10 * (i + 1), 0); setf(s, 'ItemType', offensive, 0)
    focused.append(s)
# Bloodthirst movement speed
s = clone(new('bt_speed'), 23885)
setf(s, 'Aura', 31, 0); setv(s, 10, 0); setf(s, 'TriggerSpell', 0, 0); setf(s, 'ProcFlags', 0); setf(s, 'ProcChance', 101)
setf(s, 'ProcCharges', 0); setf(s, 'Duration', 1); setf(s, 'Desc', ''); setf(s, 'Tooltip', 'Movement speed increased by $s1%.')
setf(s, 'FamilyFlags', 0)

# Charge in Defensive Stance on the client (server keeps Battle Stance and lets Vanguard through in core)
for c in (100, 6178, 11578):
    SI[c][S['Stances']] |= 0x20000

# ================================================================ talent grid
# talent id -> (tab, row, col, ranks, (dep talent, dep rank index))
GRID = {
    # Arms
    124: (ARMS, 0, 0, None, None), 130: (ARMS, 0, 1, None, None), 127: (ARMS, 0, 2, None, None),
    126: (ARMS, 1, 0, None, None), 641: (ARMS, 1, 1, None, None), 131: (ARMS, 1, 3, None, None),
    137: (ARMS, 2, 1, None, (641, 4)), 121: (ARMS, 2, 2, None, (127, 2)),
    2100: (ARMS, 3, 0, [N['spear']], None), 136: (ARMS, 3, 1, two_hand, None), 662: (ARMS, 3, 2, None, (121, 2)),
    2101: (ARMS, 4, 0, bloodthrill, None), 133: (ARMS, 4, 1, None, None), 2102: (ARMS, 4, 2, weaponmaster, None),
    168: (ARMS, 5, 0, slam, None), 129: (ARMS, 5, 2, None, None),
    135: (ARMS, 6, 1, None, (133, 0)),
    # Fury
    158: (FURY, 0, 1, None, None), 157: (FURY, 0, 2, None, None),
    2103: (FURY, 1, 1, lingering, None), 159: (FURY, 1, 2, None, None),
    2104: (FURY, 2, 0, furious, None), 160: (FURY, 2, 1, None, None), 661: (FURY, 2, 2, None, None),
    1581: (FURY, 3, 0, None, None), 2105: (FURY, 3, 1, raging, None), 155: (FURY, 3, 2, None, None), 1542: (FURY, 3, 3, None, None),
    1541: (FURY, 4, 0, None, None), 165: (FURY, 4, 1, None, None), 1543: (FURY, 4, 3, None, None),
    156: (FURY, 5, 1, None, (165, 0)), 2106: (FURY, 5, 2, gore, (155, 4)),
    167: (FURY, 6, 1, None, 'none'),
    # Protection
    142: (PROT, 0, 0, None, None), 1601: (PROT, 0, 1, None, None), 141: (PROT, 0, 2, None, None),
    138: (PROT, 1, 0, None, None), 147: (PROT, 1, 1, None, None), 128: (PROT, 1, 2, None, None),
    153: (PROT, 2, 0, None, 'none'), 2107: (PROT, 2, 1, master, None), 151: (PROT, 2, 2, None, None), 144: (PROT, 2, 3, defiance, None),
    146: (PROT, 3, 0, None, None), 2108: (PROT, 3, 1, vanguard, None), 149: (PROT, 3, 2, None, None),
    150: (PROT, 4, 0, None, None), 152: (PROT, 4, 1, None, None), 2109: (PROT, 4, 2, focused, None),
    702: (PROT, 5, 2, None, None),
    148: (PROT, 6, 1, None, (152, 0)),
}
REMOVED = [132, 125, 123, 134, 161, 166, 154, 140, 145, 143]

old_rows = {r[0]: r for r in tal.rows}
removed_spells = []
dropped_rank_spells = []
for t in REMOVED:
    removed_spells += [x for x in old_rows[t][4:13] if x]
new_rows = [r for r in tal.rows if r[0] not in REMOVED and r[1] not in (ARMS, FURY, PROT)]
for tid, (tab, row, col, ranks, dep) in GRID.items():
    if tid in old_rows:
        r = list(old_rows[tid])
        old_ranks = [x for x in r[4:13] if x]
        if ranks is not None:
            dropped_rank_spells += [x for x in old_ranks if x not in ranks]
    else:
        r = [0] * 21; r[0] = tid
    r[1], r[2], r[3] = tab, row, col
    if ranks is not None:
        r[4:13] = (ranks + [0] * 9)[:9]
    if dep == 'none':
        r[13:19] = [0] * 6
    elif dep is not None:
        r[13:19] = [dep[0], 0, 0, dep[1], 0, 0]
    new_rows.append(r)
# sanity: grid cells unique, rows fit, deps go straight down
cells = {}
for r in new_rows:
    if r[1] in (ARMS, FURY, PROT):
        k = (r[1], r[2], r[3]); assert k not in cells, (k, r[0], cells.get(k)); cells[k] = r[0]
for r in new_rows:
    if r[1] in (ARMS, FURY, PROT) and r[13]:
        d = next(x for x in new_rows if x[0] == r[13])
        assert d[1] == r[1] and d[3] == r[3] and d[2] < r[2], ('dep not straight', r[0], d[0])
        for rr in range(d[2] + 1, r[2]):
            assert (r[1], rr, r[3]) not in cells, ('arrow blocked', r[0], rr)
counts = {t: sum(1 for r in new_rows if r[1] == t) for t in (ARMS, FURY, PROT)}
print('talents per tree', counts)
tal.rows = sorted(new_rows, key=lambda r: r[0])

# Spearing Strike in the Arms spellbook tab (copy Mortal Strike's SkillLineAbility row)
ms = next(r for r in sla.rows if r[2] == 12294)
row = list(ms); row[0] = max(r[0] for r in sla.rows) + 1; row[2] = N['spear']
sla.rows.append(row)

# ================================================================ SQL extras
warrior_talent_spells = sorted(set(s for r in tal.rows if r[1] in (ARMS, FURY, PROT) for s in r[4:13] if s) |
                               set(s for r in old_rows.values() if r[1] in (ARMS, FURY, PROT) for s in r[4:13] if s))
learned_by_talent = [21551, 21552, 21553, 23892, 23893, 23894, 23923, 23924, 23925]   # trained ranks of MS/BT/Shield Slam
all_purge = sorted(set(removed_spells + dropped_rank_spells))

out = []
out.append("-- WoW Forever warrior talents (generated by gen_warrior.py)")
out.append("CREATE TEMPORARY TABLE IF NOT EXISTS tmp_wsp LIKE spell_template; DELETE FROM tmp_wsp;")
out += SQL
out.append("DROP TEMPORARY TABLE IF EXISTS tmp_wsp;")
# Shield Slam's high ranks beyond 32 bits need spell_affect for Focused Rage? (0x2000000 bit covers it)
out.append("DELETE FROM spell_proc_event WHERE entry IN (%d,%d,%d);" % (master[0], bloodthrill[0], weaponmaster[0]))
out.append("INSERT INTO spell_proc_event (entry,SchoolMask,SpellFamilyName,SpellFamilyMask0,SpellFamilyMask1,SpellFamilyMask2,procFlags,procEx,ppmRate,CustomChance,Cooldown) VALUES "
           "(%d,0,0,0,0,0,0,48,0,0,0),(%d,0,0,0,0,0,0,0,0,0,0),(%d,0,0,0,0,0,0,0,0,0,200);" % (master[0], bloodthrill[0], weaponmaster[0]))
open('out/zz_warrior_talents.sql', 'w').write('\n'.join(out) + '\n')

# character reset (characters DB), run once
reset = []
reset.append("-- One-time warrior talent reset for the WoW Forever trees (characters DB)")
reset.append("CREATE TABLE IF NOT EXISTS custom_renown_migrations (name VARCHAR(64) PRIMARY KEY, applied TIMESTAMP DEFAULT CURRENT_TIMESTAMP);")
reset.append("DROP PROCEDURE IF EXISTS renown_warrior_reset;")
reset.append("DELIMITER //")
reset.append("CREATE PROCEDURE renown_warrior_reset() BEGIN")
reset.append("  IF NOT EXISTS (SELECT 1 FROM custom_renown_migrations WHERE name='warrior_forever_v1') THEN")
spells_csv = ','.join(str(x) for x in sorted(set(warrior_talent_spells + learned_by_talent)))
reset.append("    DELETE cs FROM character_spell cs JOIN characters c ON c.guid=cs.guid WHERE c.class=1 AND cs.spell IN (%s);" % spells_csv)
reset.append("    DELETE ca FROM character_aura ca JOIN characters c ON c.guid=ca.guid WHERE c.class=1 AND ca.spell IN (%s);" % spells_csv)
reset.append("    INSERT INTO custom_renown_migrations (name) VALUES ('warrior_forever_v1');")
reset.append("  END IF;")
reset.append("END //")
reset.append("DELIMITER ;")
reset.append("CALL renown_warrior_reset();")
reset.append("DROP PROCEDURE renown_warrior_reset;")
open('out/zz_warrior_reset_chars.sql', 'w').write('\n'.join(reset) + '\n')

sp.save('out/Spell.dbc'); tal.save('out/Talent.dbc'); sla.save('out/SkillLineAbility.dbc')

# ================================================================ playerbot spec links
def link(spec):
    """spec: {talent id: points}; returns calculator link (tabs in Arms-Fury-Prot order)."""
    parts = []
    for tab in (ARMS, FURY, PROT):
        rows = sorted([r for r in tal.rows if r[1] == tab], key=lambda r: (r[2], r[3]))
        s = ''.join(str(spec.get(r[0], 0)) for r in rows).rstrip('0')
        parts.append(s)
    return '-'.join(parts).rstrip('-')

def check(spec, name):
    total = sum(spec.values()); assert total == 51, (name, total)
    for tab in (ARMS, FURY, PROT):
        spent = 0
        rows = sorted([r for r in tal.rows if r[1] == tab], key=lambda r: (r[2], r[3]))
        for rr in range(7):
            need = rr * 5
            pts = sum(spec.get(r[0], 0) for r in rows if r[2] == rr)
            if pts:
                assert spent >= need, (name, tab, rr, spent)
            spent += pts
        for r in rows:
            p = spec.get(r[0], 0)
            n = sum(1 for x in r[4:13] if x)
            assert p <= n, (name, r[0], p, n)
            if p and r[13]:
                assert spec.get(r[13], 0) >= r[16] + 1, (name, 'dep', r[0])

SPECS = {
    'arms': {124: 3, 127: 3, 126: 2, 641: 5, 131: 2, 137: 1, 121: 3, 2100: 1, 136: 3, 662: 2, 2101: 5, 133: 1, 2102: 5, 168: 2, 129: 3, 135: 1,
             157: 5, 159: 4, 2103: 0},
    'fury': {124: 3, 127: 3, 641: 5, 131: 2, 137: 1, 121: 3, 662: 2,
             158: 2, 157: 5, 2103: 0, 159: 5, 2104: 3, 160: 1, 1581: 5, 2105: 1, 155: 2, 1542: 2, 165: 1, 1541: 0, 156: 5, 167: 1},
    'prot': {124: 3, 130: 5, 127: 3, 126: 2, 131: 0,
             142: 2, 1601: 5, 141: 0, 138: 5, 147: 3, 128: 3, 153: 1, 2107: 2, 151: 0, 144: 3, 146: 3, 2108: 1, 149: 0, 150: 0, 152: 1, 2109: 3, 702: 5, 148: 1},
}
# top up each spec to exactly 51 with sensible extras
SPECS['fury'][158] = 1
for name, spec in SPECS.items():
    spec = {k: v for k, v in spec.items() if v}
    SPECS[name] = spec
    print(name, sum(spec.values()))
with open('out/specs.txt', 'w') as f:
    for name, spec in SPECS.items():
        try:
            check(spec, name)
            f.write('%s %s\n' % (name, link(spec)))
            print(name, link(spec))
        except AssertionError as e:
            print('SPEC ERROR', e)
print('new spells', min(N.values()), '-', max(N.values()))
print('purged spells', all_purge)

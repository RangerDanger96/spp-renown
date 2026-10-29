import struct

class DBC:
    def __init__(self, path):
        d = open(path, 'rb').read()
        assert d[:4] == b'WDBC'
        self.n, self.f, self.rs, self.ss = struct.unpack('<4I', d[4:20])
        assert self.rs == self.f * 4
        body = d[20:20 + self.n * self.rs]
        self.rows = [list(struct.unpack_from('<%dI' % self.f, body, i * self.rs)) for i in range(self.n)]
        self.strings = bytearray(d[20 + self.n * self.rs:])
        self._cache = {}

    def s(self, off):
        e = self.strings.index(b'\0', off)
        return self.strings[off:e].decode('utf-8', 'replace')

    def addstr(self, txt):
        if txt == '':
            return 0
        b = txt.encode('utf-8')
        if b in self._cache:
            return self._cache[b]
        off = len(self.strings)
        self.strings += b + b'\0'
        self._cache[b] = off
        return off

    def index(self):
        return {r[0]: r for r in self.rows}

    def save(self, path):
        out = bytearray(b'WDBC')
        out += struct.pack('<4I', len(self.rows), self.f, self.rs, len(self.strings))
        for r in self.rows:
            assert len(r) == self.f
            out += struct.pack('<%dI' % self.f, *[x & 0xffffffff for x in r])
        out += self.strings
        open(path, 'wb').write(out)

def f2u(x):
    return struct.unpack('<I', struct.pack('<f', x))[0]

def u2f(x):
    return struct.unpack('<f', struct.pack('<I', x))[0]

def i32(x):
    return x - (1 << 32) if x & 0x80000000 else x

# Spell.dbc 1.12.1 field indexes
S = dict(ID=0, School=1, Category=2, Dispel=4, Mechanic=5, Attr=6, AttrEx=7, AttrEx2=8, AttrEx3=9, AttrEx4=10,
         Stances=11, StancesNot=12, Targets=13, CasterAuraState=16, TargetAuraState=17, CastTime=18, Recovery=19,
         CatRecovery=20, InterruptFlags=21, AuraInterrupt=22, ChannelInterrupt=23, ProcFlags=24, ProcChance=25,
         ProcCharges=26, MaxLevel=27, BaseLevel=28, SpellLevel=29, Duration=30, PowerType=31, ManaCost=32,
         Range=36, StackAmount=39, EquipClass=58, EquipSubMask=59, EquipInvMask=60,
         Effect=61, DieSides=64, BaseDice=67, BasePoints=76, Mechanic_E=79, TargetA=82, TargetB=85, Radius=88,
         Aura=91, Amplitude=94, MultipleValue=97, ChainTarget=100, ItemType=103, MiscValue=106, TriggerSpell=109,
         Visual=115, Icon=117, Name=120, Rank=129, Desc=138, Tooltip=147, StartRecCat=157, StartRecTime=158,
         Family=160, FamilyFlags=161, FamilyFlags2=162, DmgClass=164, Prevention=165, DmgMult=167)

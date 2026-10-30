import subprocess
def q(sql):
    out=subprocess.run(["mariadb","world","-B","-N","-e",sql],capture_output=True,text=True,check=True).stdout
    return [l.split("\t") for l in out.strip().split("\n") if l]

AGI,STR,INT,SPI,STA=3,4,5,6,7
# (key, armor subclass, stat weights, name stem)
VARIANTS=[
 ("cloth",  1, {INT:0.45,STA:0.35,SPI:0.20}, "Silk"),       # mage, priest, warlock
 ("lagi",   2, {AGI:0.55,STA:0.45},          "Leather"),    # rogue, feral druid, hunter, enh shaman
 ("lcast",  2, {INT:0.45,STA:0.30,SPI:0.25}, "Hide"),       # druid / shaman healers
 ("mail",   3, {STR:0.55,STA:0.45},          "Chain"),      # warrior, paladin
]
ARMOR_SLOTS=[(5,"Tunic",1.0,[5,20]),(7,"Leggings",1.0,[7]),(1,"Helm",0.9,[1]),(3,"Shoulders",0.75,[3]),(10,"Gloves",0.75,[10]),(8,"Boots",0.75,[8]),(6,"Belt",0.75,[6]),(9,"Bracers",0.5,[9])]
# From level 40 on warriors/paladins wear plate and hunters/shamans mail
VARIANTS_40=[
 ("cloth",    1, {INT:0.45,STA:0.35,SPI:0.20}, "Silk"),
 ("lagi",     2, {AGI:0.55,STA:0.45},          "Leather"),
 ("lcast",    2, {INT:0.45,STA:0.30,SPI:0.25}, "Hide"),
 ("mail",     3, {AGI:0.50,STA:0.35,INT:0.15}, "Chain"),       # hunter, enhancement shaman
 ("mailcast", 3, {INT:0.45,STA:0.30,SPI:0.25}, "Mail"),        # shaman healer
 ("plate",    4, {STR:0.55,STA:0.45},          "Plate"),       # warrior, paladin
]
VARIANT_SLOTNAME={"cloth":{5:"Robe",7:"Pants",1:"Cowl",3:"Mantle",10:"Gloves",8:"Slippers",6:"Sash",9:"Cuffs"},
                  "lagi":{5:"Jerkin",7:"Pants",1:"Cap",3:"Shoulderpads",10:"Gloves",8:"Boots",6:"Belt",9:"Bracers"},
                  "lcast":{5:"Vest",7:"Leggings",1:"Headband",3:"Spaulders",10:"Handwraps",8:"Boots",6:"Cord",9:"Wristwraps"},
                  "mail":{5:"Hauberk",7:"Legguards",1:"Helm",3:"Pauldrons",10:"Gauntlets",8:"Sabatons",6:"Girdle",9:"Bracers"},
                  "mailcast":{5:"Vestment",7:"Kilt",1:"Coif",3:"Epaulets",10:"Grips",8:"Greaves",6:"Waistband",9:"Bindings"},
                  "plate":{5:"Breastplate",7:"Legplates",1:"Greathelm",3:"Spaulders",10:"Handguards",8:"Warboots",6:"Waistguard",9:"Vambraces"}}
ACCESSORIES=[ # (class,subclass,invtypes,name,weight,stats)
 (4,1,[16],"Cloak of Fury",0.55,{STR:0.5,STA:0.5}),
 (4,1,[16],"Cloak of Swiftness",0.55,{AGI:0.5,STA:0.5}),
 (4,1,[16],"Cloak of Insight",0.55,{INT:0.6,STA:0.4}),
 (4,0,[11],"Band of Fury",0.55,{STR:0.5,STA:0.5}),
 (4,0,[11],"Band of Swiftness",0.55,{AGI:0.5,STA:0.5}),
 (4,0,[11],"Band of Insight",0.55,{INT:0.6,STA:0.4}),
 (4,0,[2],"Pendant of Fury",0.55,{STR:0.5,STA:0.5}),
 (4,0,[2],"Pendant of Swiftness",0.55,{AGI:0.5,STA:0.5}),
 (4,0,[2],"Pendant of Insight",0.55,{INT:0.6,STA:0.4}),
]
WEAPONS=[ # (class,subclass,invtypes,name,weight,stats)
 (2,7,[13,21],"Longsword",0.6,{STR:0.5,STA:0.5}),
 (2,1,[17],"Greataxe",1.0,{STR:0.55,STA:0.45}),
 (2,15,[13,21],"Dirk",0.6,{AGI:0.6,STA:0.4}),
 (2,4,[13,21],"Scepter",0.6,{INT:0.5,STA:0.3,SPI:0.2}),
 (2,10,[17],"Battle Staff",1.0,{INT:0.45,STA:0.35,SPI:0.2}),
 (2,2,[15],"Recurve Bow",0.45,{AGI:0.6,STA:0.4}),
 (2,19,[26],"Wand",0.4,{INT:0.6,SPI:0.4}),
 (4,6,[14],"Kite Shield",0.6,{STR:0.4,STA:0.6}),
]
BRACKETS=[ # (key, title prefix, required level, base target level, stat budget at weight 1.0)
 ("t0","Recruit's",1,9,8),
 ("t1","Skirmisher's",10,19,14),
 ("t2","Footman's",20,29,20),
 ("t3","Lancer's",30,39,27),
 ("t4","Veteran's",40,49,34),
 ("t5","Vanguard's",50,59,42),
 ("t6","Frontline",60,57,46),   # level 60 green starter set (no insignia needed)
]
NEW_BRACKET_BASE={"t2":191000,"t3":191100,"t4":191200,"t5":191300,"t6":191400}   # later brackets: fixed ID blocks
def base(cls,sub,invs,target,span=3):
    inv=",".join(map(str,invs))
    r=q(f"""SELECT entry FROM item_template WHERE class={cls} AND subclass={sub} AND InventoryType IN ({inv})
        AND Quality IN (2,3) AND RandomProperty=0 AND RequiredLevel BETWEEN {max(1,target-6)} AND {target+span}
        AND entry<190000 AND name NOT LIKE '%Deprecated%' AND name NOT LIKE '%Test%' AND name NOT LIKE '%Monster%'
        ORDER BY ABS(CAST(RequiredLevel AS SIGNED)-{target}), Quality DESC, entry LIMIT 1""")
    if r: return int(r[0][0])
    if span<30: return base(cls,sub,invs,target,span+6)
    return None
def stats(weights,budget):
    out=[];left=budget
    items=sorted(weights.items(),key=lambda kv:-kv[1])
    for i,(st,wt) in enumerate(items):
        v=max(1,round(budget*wt)) if i<len(items)-1 else max(1,left)
        v=min(v,left) if i==len(items)-1 else v
        left-=v; out.append((st,v))
        if left<=0: break
    return [(s,v) for s,v in out if v>0]
def build():
    items=[] # dict entries
    eid=190600
    for bkey,prefix,req,target,budget in BRACKETS:
        for vkey,sub,wts,stem in (VARIANTS_40 if req>=40 else VARIANTS):
            for inv,_,wt,invs in ARMOR_SLOTS:
                b=base(4,sub,invs,target)
                items.append(dict(entry=eid,bracket=bkey,base=b,name=f"{prefix} {stem} {VARIANT_SLOTNAME[vkey][inv]}",
                                  req=req,ilvl=target+3,stats=stats(wts,round(budget*wt)),weight=wt,scale_armor=True)); eid+=1
        for cls,sub,invs,nm,wt,wts in ACCESSORIES+WEAPONS:
            b=base(cls,sub,invs,target)
            items.append(dict(entry=eid,bracket=bkey,base=b,name=f"{prefix} {nm}",req=req,ilvl=target+3,
                              stats=stats(wts,round(budget*wt)),weight=wt)); eid+=1
    # Keep the item IDs of the first release (190600-190667) stable; slots added later get 190700+
    OLD_SLOTS=[5,7,10,8,6]; OLD_ACC=6
    old=[]
    for bkey,prefix,req,target,budget in BRACKETS[:2]:
        for vkey,sub,wts,stem in VARIANTS:
            for inv in OLD_SLOTS: old.append(f"{prefix} {stem} {VARIANT_SLOTNAME[vkey][inv]}")
        for cls,sub,invs,nm,wt,wts in ACCESSORIES[:OLD_ACC]+WEAPONS: old.append(f"{prefix} {nm}")
    oldid={n:190600+i for i,n in enumerate(old)}
    nxt=190700
    counters=dict(NEW_BRACKET_BASE)
    for it in items:
        if it["bracket"] in counters:
            it["entry"]=counters[it["bracket"]]; counters[it["bracket"]]+=1
        elif it["name"] in oldid: it["entry"]=oldid[it["name"]]
        else: it["entry"]=nxt; nxt+=1
    return items
if __name__=="__main__":
    for it in build(): print(it["entry"],it["base"],it["name"],it["stats"])

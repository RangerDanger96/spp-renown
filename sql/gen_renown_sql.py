import subprocess
def q(sql):
    out=subprocess.run(["mariadb","world","-B","-N","-e",sql],capture_output=True,text=True,check=True).stdout
    return [l.split("\t") for l in out.strip().split("\n") if l]
TIERS=[(5,190520,0,20),(10,190521,21,29),(15,190522,30,39),(20,190523,40,49),(25,190524,50,58),(30,190525,59,60),
       (33,190526,60,60),(36,190527,60,60),(40,190528,60,60)]   # tiers 7-9: level 60 Arathi Basin / Alterac Valley + rare rank sets / epic rank sets
def tier_for(req):
    if req==0: return 2   # tabard -> tier 3 (index 2)
    for i,(_,_,lo,hi) in enumerate(TIERS[:6]):
        if lo<=req<=hi: return i
    return 5
L=[];w=L.append
w("-- ============================================================")
w("-- Renown: insignia items + tiered reward stock at the Battleground Quartermasters")
w("-- Requires the Renown server module (mangosd.exe built with BUILD_MODULE_RENOWN)")
w("-- Re-runnable. Items 190520-190528. Runs after zz_bg_hub.sql (alphabetical order).")
w("-- ============================================================")
w("DELETE FROM item_template WHERE entry BETWEEN 190520 AND 190528;")
w("DELETE FROM npc_vendor WHERE entry IN (190100,190101,190108,190109,190110,190111);")
w("DELETE FROM gossip_menu_option WHERE menu_id=59000 AND id=10;")
w("")
w("-- Insignias (given by the server module on reaching a renown rank)")
for i,(rank,item,lo,hi) in enumerate(TIERS):
    w("DROP TEMPORARY TABLE IF EXISTS tmp_it;")
    w("CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;")
    desc=f"Renown Rank {rank}. Unlocks tier {i+1} rewards at the Battleground Quartermaster."
    w(f"UPDATE tmp_it SET entry={item}, name='Renown Insignia: Tier {i+1}', class=15, subclass=0, displayid=4841, Quality=4, Flags=0, BuyPrice=0, SellPrice=0, bonding=1, maxcount=1, stackable=1, description='{desc}', minMoneyLoot=0, maxMoneyLoot=0;")
    w("INSERT INTO item_template SELECT * FROM tmp_it;")
w("DROP TEMPORARY TABLE IF EXISTS tmp_it;")
w("")
w("-- One condition per tier: player owns the insignia (bags or bank). IDs 59101-59106: the core reads vendor condition_id as 16-bit, so IDs must stay below 65536.")
w("DELETE FROM conditions WHERE condition_entry BETWEEN 59101 AND 59109 OR condition_entry BETWEEN 5310111 AND 5310116 OR (type=23 AND value1 BETWEEN 190520 AND 190528);")
w("INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) VALUES")
w(",\n".join("({},23,{},1,0,0,0,'Renown: owns Renown Insignia Tier {}')".format(59101+i,item,i+1) for i,(rank,item,lo,hi) in enumerate(TIERS))+";")
w("-- Level filters for the low-level sets (a vendor shows at most 128 items, so each player only sees gear for their level):")
w("-- 59110 level <= 9 (Recruit's), 59111 level 10-19 (uses existing 107 'level >= 10' and 326 'level <= 19'), 59112 = 59111 AND tier 1 insignia (Skirmisher's)")
w("DELETE FROM conditions WHERE condition_entry BETWEEN 59110 AND 59112 OR condition_entry BETWEEN 59150 AND 59399;")
w("INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) VALUES")
w("(59110,15,9,2,0,0,0,'Renown: player level <= 9'),")
w("(59111,-1,107,326,0,0,0,'Renown: player level 10-19'),")
w("(59112,-1,59111,59101,0,0,0,'Renown: level 10-19 and Renown tier 1');")
w("")
# Level bands + insignia for everything else, so each player only sees gear for their level (vendors show at most 128)
COND=[]; _next=[59150]; _cache={}
def _new(t,v1,v2,cmt):
    # conditions are unique on (type, values, flags): reuse an existing identical row, else add ours.
    # Each condition is held in a SQL variable (@rcN) that the vendor rows use.
    key=(t,v1,v2)
    if key in _cache: return _cache[key]
    cid=_next[0]; _next[0]+=1; var=f"@rc{cid}"; _cache[key]=var
    where=f"type={t} AND value1={v1} AND value2={v2} AND value3=0 AND value4=0 AND flags=0"
    COND.append(f"INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT {cid},{t},{v1},{v2},0,0,0,'Renown: {cmt}' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE {where});")
    COND.append(f"SET {var} := (SELECT condition_entry FROM conditions WHERE {where} ORDER BY condition_entry LIMIT 1);")
    return var
def lvl_ge(n): return _new(15,n,1,f'level >= {n}')
def lvl_le(n): return _new(15,n,2,f'level <= {n}')
def c_and(a,b,cmt): return _new(-1,a,b,cmt)
def band(lo,hi,tier):   # level lo..hi (hi>=60: no cap) and owns the insignia of tier (1-based)
    lo=max(1,lo)
    rng=lvl_ge(lo) if hi>=60 else c_and(lvl_ge(lo),lvl_le(hi),f'level {lo}-{hi}')
    return c_and(rng,59100+tier,f'level {lo}-{hi}, tier {tier}')

w("-- Quartermasters become vendors too")
w("UPDATE creature_template SET NpcFlags = (NpcFlags & ~128) | 4 WHERE Entry IN (190100,190101); -- 4 = vendor in 1.12 (128 is innkeeper)")
w("INSERT INTO gossip_menu_option (menu_id,id,option_icon,option_text,option_broadcast_text,option_id,npc_option_npcflag,action_menu_id,action_poi_id,action_script_id,box_coded,box_money,box_text,box_broadcast_text,condition_id) VALUES")
w("(59000,10,1,'Show me the Renown rewards.',0,3,4,0,0,0,0,0,'',0,0);")
w("")
import lowgear
TIER_COST=[500,750,1000,1400,1800,2500,3000,3500,6000]   # T1..T9 base Renown cost (chest/legs/two-hander); ~400 Renown per BG
FRONTLINE_COST=400                    # level 60 "Frontline" green starter set, no insignia needed
T0_COST=300                           # level 1-9 "Recruit's" set (~6-7 BGs for a full set), no insignia needed
SLOT_MULT={1:0.9,3:0.9,5:1.0,20:1.0,7:1.0,17:1.0,10:0.75,8:0.75,6:0.75,9:0.5,16:0.6,11:0.6,2:0.6,12:0.6,
           13:0.8,21:0.8,22:0.6,14:0.6,23:0.6,15:0.6,26:0.6,25:0.6,19:0.5}
def cost(base,inv): return max(5,int(round(base*SLOT_MULT.get(inv,0.7)/5.0))*5)

gear=lowgear.build()
w("-- Renown sets: Recruit's 1-9, Skirmisher's 10-19, Footman's 20-29, Lancer's 30-39, Veteran's 40-49, Vanguard's 50-59")
w("DELETE FROM item_template WHERE entry BETWEEN 190600 AND 190799 OR entry BETWEEN 191000 AND 191499;")
for it in gear:
    # armor first: MySQL applies SET left to right, so ItemLevel is still the base item's here
    sets=[f"armor=IF(ItemLevel>{it['ilvl']}, ROUND(armor*{it['ilvl']}/ItemLevel), armor)" if it.get('scale_armor') else "armor=armor",
          f"entry={it['entry']}", "name='"+it['name'].replace("'","''")+"'", "Quality=2" if it['bracket']=='t6' else "Quality=3", f"ItemLevel={60 if it['bracket']=='t6' else it['ilvl']}",
          f"RequiredLevel={it['req']}", "BuyCount=1", "SellPrice=0", "bonding=1", "AllowableClass=-1", "AllowableRace=-1",
          "RandomProperty=0", "itemset=0", "description='Renown reward'", "Flags=0", "RequiredReputationFaction=0",
          "RequiredReputationRank=0", "requiredhonorrank=0", "startquest=0", "minMoneyLoot=0", "maxMoneyLoot=0"]
    for k in range(1,11):
        st,val=(it['stats'][k-1] if k<=len(it['stats']) else (0,0))
        sets+= [f"stat_type{k}={st}", f"stat_value{k}={val}"]
    for k in range(1,6):
        sets+= [f"spellid_{k}=0", f"spelltrigger_{k}=0", f"spellcharges_{k}=0", f"spellcooldown_{k}=-1", f"spellcategory_{k}=0", f"spellcategorycooldown_{k}=-1"]
    w("DROP TEMPORARY TABLE IF EXISTS tmp_it;")
    w(f"CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry={it['base']};")
    w("UPDATE tmp_it SET "+", ".join(sets)+";")
    w("INSERT INTO item_template SELECT * FROM tmp_it;")
w("DROP TEMPORARY TABLE IF EXISTS tmp_it;")
w("")

w("-- Reward stock. Quartermasters (190100/190101) carry levels 1-39, Renown Armorers (190108/190109) 40-60, Warmasters (190110/190111) the level 60 tiers 7-9:")
w("-- a vendor holds at most 255 items. Every item is shown only to players of its level band who own its insignia.")
rows=[]; costs={}; tiers={}; fixups=set()
BRACKET_TIER={'t1':1,'t2':2,'t3':3,'t4':4,'t5':5}
BRACKET_LVL={'t1':(10,19),'t2':(20,29),'t3':(30,39),'t4':(40,49),'t5':(50,59)}
TIER_BAND={1:(10,29),2:(12,38),3:(21,48),4:(31,58),5:(41,60),6:(50,60),7:(55,60),8:(55,60),9:(55,60)}
ab_vendor={}
for e in (15126,15127):
    r=q(f"select count(*) from npc_vendor v join item_template i on i.entry=v.item where v.entry={e} and i.name like 'Highlander%'")
    ab_vendor['A' if int(r[0][0])>0 else 'H']=e
AV_BOTH=[19099,19100,19102,19103,19104,19106,19107,19108,20648,19105,19325,19308,19309,19310,19311,19312,19315,19323,19321,19324,19319,19320]
AV_SIDE={'A':[19084,19086,19091,19092,19093,19094,19097,19098],'H':[19083,19085,19087,19088,19089,19090,19095,19096]}
RANK_VENDOR={'A':12777,'H':12792}
c_lvl60=lvl_ge(60)
counts={}
for side,qm,arm,war,wsg in [('A',190100,190108,190110,14753),('H',190101,190109,190111,14754)]:
    slot={qm:0,arm:0,war:0}; seen=set()
    def add(vendor,item,cond,tier,inv,cmt,base_cost=None):
        if item in seen: return
        seen.add(item)
        rows.append(f"({vendor},{item},0,0,{min(slot[vendor],255)},{cond},'"+cmt.replace("'","''")+"')"); slot[vendor]+=1
        if tier is not None:
            costs[item]=cost(base_cost if base_cost else TIER_COST[tier-1], inv); tiers[item]=tier
    # Renown sets
    for it in gear:
        inv=int(q(f"select InventoryType from item_template where entry={it['base']}")[0][0])
        if it['bracket']=='t0':
            add(qm,it['entry'],59110,None,inv,'Renown Recruit\'s, levels 1-9'); costs[it['entry']]=cost(T0_COST,inv); tiers[it['entry']]=0
            continue
        if it['bracket']=='t6':   # level 60 green starter set: no insignia, only level 60
            add(arm,it['entry'],c_lvl60,None,inv,'Renown Frontline set (level 60 greens)'); costs[it['entry']]=cost(FRONTLINE_COST,inv); tiers[it['entry']]=0
            continue
        t=BRACKET_TIER[it['bracket']]; lo,hi=BRACKET_LVL[it['bracket']]
        cond=59112 if it['bracket']=='t1' else band(lo,hi,t)
        add(qm if t<=3 else arm,it['entry'],cond,t,inv,f"Renown set, levels {lo}-{hi}, tier {t}")
    # Warsong Gulch rewards (consumables keep their gold price and need no insignia band)
    for item,req,cls,inv in q(f"select v.item,i.RequiredLevel,i.class,i.InventoryType from npc_vendor v join item_template i on i.entry=v.item where v.entry={wsg} order by i.RequiredLevel,v.item"):
        item=int(item); t=tier_for(int(req))+1; lo,hi=TIER_BAND[t]
        if int(cls)==0:
            add(qm,item,59100+t,None,int(inv),f'WSG consumable, tier {t}')
        else:
            add(qm if t<=3 else arm,item,band(lo,hi,t),t,int(inv),f'WSG reward, tier {t}')
    # Arathi Basin rewards (level 60 -> tier 7)
    for item,req,cls,inv in q(f"select v.item,i.RequiredLevel,i.class,i.InventoryType from npc_vendor v join item_template i on i.entry=v.item where v.entry={ab_vendor[side]} and i.class in (2,4) order by i.RequiredLevel,v.item"):
        item=int(item); req=int(req); t=7 if req>=58 else tier_for(req)+1; lo,hi=TIER_BAND[t]
        add(qm if t<=3 else (arm if t<=6 else war),item,band(lo,hi,t),t,int(inv),f'AB reward, tier {t}'); fixups.add(item)
    # Alterac Valley rewards (tier 8)
    for item in AV_BOTH+AV_SIDE[side]:
        inv=int(q(f"select InventoryType from item_template where entry={item}")[0][0])
        add(war,item,band(55,60,8),8,inv,'AV reward, tier 8'); fixups.add(item)
    # PvP rank sets: rare (tier 8) and epic (tier 9); class-locked, soulbound
    for item,ql,inv in q(f"select v.item,i.Quality,i.InventoryType from npc_vendor v join item_template i on i.entry=v.item where v.entry={RANK_VENDOR[side]} and i.class in (2,4) and i.Quality in (3,4) order by i.Quality,i.ItemLevel,v.item"):
        item=int(item); t=8 if int(ql)==3 else 9
        add(war,item,band(55,60,t),t,int(inv),f'PvP rank set, tier {t}'); fixups.add(item)
    counts[qm]=slot[qm]; counts[arm]=slot[arm]; counts[war]=slot[war]
for v,c in counts.items():
    assert c<=255, (v,c)
print('vendor sizes',counts)
for line in COND: w(line)
w("-- Rewards bought with Renown need no reputation or PvP rank")
w("UPDATE item_template SET RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0 WHERE entry IN ("+",".join(str(i) for i in sorted(fixups))+");")
w("INSERT INTO npc_vendor (entry,item,maxcount,incrtime,slot,condition_id,comments) VALUES")
w(",\n".join(rows)+";")
w("")
w("-- Renown prices: read by the Renown server module (paid with spendable Renown points, not gold).")
w("-- Gold price is 0 so the client never blocks the purchase for lack of money; the RenownBar addon shows the Renown cost.")
w("-- tier: Renown reward tier that unlocks the item (0 = no insignia needed); also used for battleground loot bags")
w("DROP TABLE IF EXISTS custom_renown_vendor;")
w("CREATE TABLE custom_renown_vendor (item MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY, cost INT UNSIGNED NOT NULL DEFAULT 0, tier TINYINT UNSIGNED NOT NULL DEFAULT 0) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Renown vendor prices';")
w("INSERT INTO custom_renown_vendor (item,cost,tier) VALUES")
w(",\n".join(f"({i},{c},{tiers[i]})" for i,c in sorted(costs.items()))+";")
w("UPDATE item_template i JOIN custom_renown_vendor c ON c.item=i.entry SET i.BuyPrice=0, i.SellPrice=0;")
w("")
w("-- Loot bag gear from on-level dungeons: everything the elites and bosses of the 5-player dungeons can drop")
w("-- (uncommon to epic weapons and armor), built from this server's own loot tables. Read by the Renown module.")
DUNGEONS="389,36,43,33,48,34,90,47,189,129,70,209,349,109,230,229,429,289,329"
w("DROP TABLE IF EXISTS custom_renown_dungeon_loot;")
w("CREATE TABLE custom_renown_dungeon_loot (item MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY, map SMALLINT UNSIGNED NOT NULL, reqlevel TINYINT UNSIGNED NOT NULL, quality TINYINT UNSIGNED NOT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Renown loot bags: dungeon loot';")
def dl(join, cond):
    w("INSERT IGNORE INTO custom_renown_dungeon_loot (item,map,reqlevel,quality) SELECT i.entry, MIN(c.map), i.RequiredLevel, i.Quality "
      "FROM creature c JOIN creature_template t ON t.Entry=c.id AND t.`Rank`>=1 AND t.LootId>0 "
      "JOIN creature_loot_template l ON l.entry=t.LootId " + join +
      f" WHERE c.map IN ({DUNGEONS}) AND {cond} AND i.Quality BETWEEN 2 AND 4 AND i.class IN (2,4) AND i.InventoryType>0 AND i.InventoryType<>19 "
      "AND i.RequiredLevel>0 AND i.startquest=0 AND i.entry<190000 GROUP BY i.entry;")
dl("JOIN item_template i ON i.entry=l.item", "l.mincountOrRef>0")
dl("JOIN reference_loot_template r ON r.entry=-l.mincountOrRef JOIN item_template i ON i.entry=r.item", "l.mincountOrRef<0 AND r.mincountOrRef>0")
dl("JOIN reference_loot_template r ON r.entry=-l.mincountOrRef JOIN reference_loot_template r2 ON r2.entry=-r.mincountOrRef JOIN item_template i ON i.entry=r2.item",
   "l.mincountOrRef<0 AND r.mincountOrRef<0 AND r2.mincountOrRef>0")
w("SELECT 'dungeon_loot', COUNT(*) FROM custom_renown_dungeon_loot;")
open('/root/renown/zz_renown.sql','w',newline='\r\n').write("\n".join(L)+"\n")
print(len(rows),'vendor rows',len(costs),'renown items')

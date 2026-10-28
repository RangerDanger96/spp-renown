import subprocess
def q(sql):
    out=subprocess.run(["mariadb","world","-B","-N","-e",sql],capture_output=True,text=True,check=True).stdout
    return [l.split("\t") for l in out.strip().split("\n") if l]
TIERS=[(5,190520,0,20),(10,190521,21,29),(15,190522,30,39),(20,190523,40,49),(25,190524,50,58),(30,190525,59,60)]
def tier_for(req):
    if req==0: return 2   # tabard -> tier 3 (index 2)
    for i,(_,_,lo,hi) in enumerate(TIERS):
        if lo<=req<=hi: return i
    return len(TIERS)-1
L=[];w=L.append
w("-- ============================================================")
w("-- Renown: insignia items + tiered reward stock at the Battleground Quartermasters")
w("-- Requires the Renown server module (mangosd.exe built with BUILD_MODULE_RENOWN)")
w("-- Re-runnable. Items 190520-190525. Runs after zz_bg_hub.sql (alphabetical order).")
w("-- ============================================================")
w("DELETE FROM item_template WHERE entry BETWEEN 190520 AND 190525;")
w("DELETE FROM npc_vendor WHERE entry IN (190100,190101);")
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
w("DELETE FROM conditions WHERE condition_entry BETWEEN 59101 AND 59106 OR condition_entry BETWEEN 5310111 AND 5310116 OR (type=23 AND value1 BETWEEN 190520 AND 190525);")
w("INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) VALUES")
w(",\n".join("({},23,{},1,0,0,0,'Renown: owns Renown Insignia Tier {}')".format(59101+i,item,i+1) for i,(rank,item,lo,hi) in enumerate(TIERS))+";")
w("-- Level filters for the low-level sets (a vendor shows at most 128 items, so each player only sees gear for their level):")
w("-- 59110 level <= 9 (Recruit's), 59111 level 10-19 (uses existing 107 'level >= 10' and 326 'level <= 19'), 59112 = 59111 AND tier 1 insignia (Skirmisher's)")
w("DELETE FROM conditions WHERE condition_entry BETWEEN 59110 AND 59112;")
w("INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) VALUES")
w("(59110,15,9,2,0,0,0,'Renown: player level <= 9'),")
w("(59111,-1,107,326,0,0,0,'Renown: player level 10-19'),")
w("(59112,-1,59111,59101,0,0,0,'Renown: level 10-19 and Renown tier 1');")
w("")
w("-- Quartermasters become vendors too")
w("UPDATE creature_template SET NpcFlags = (NpcFlags & ~128) | 4 WHERE Entry IN (190100,190101); -- 4 = vendor in 1.12 (128 is innkeeper)")
w("INSERT INTO gossip_menu_option (menu_id,id,option_icon,option_text,option_broadcast_text,option_id,npc_option_npcflag,action_menu_id,action_poi_id,action_script_id,box_coded,box_money,box_text,box_broadcast_text,condition_id) VALUES")
w("(59000,10,1,'Show me the Renown rewards.',0,3,4,0,0,0,0,0,'',0,0);")
w("")
import lowgear
TIER_COST=[80,150,250,400,600,900]   # T1..T6 base Renown cost (chest/legs/two-hander)
T0_COST=30                            # level 1-9 "Recruit's" set, no insignia needed
SLOT_MULT={1:0.9,3:0.9,5:1.0,20:1.0,7:1.0,17:1.0,10:0.75,8:0.75,6:0.75,9:0.5,16:0.6,11:0.6,2:0.6,12:0.6,
           13:0.8,21:0.8,22:0.6,14:0.6,23:0.6,15:0.6,26:0.6,25:0.6,19:0.5}
def cost(base,inv): return max(5,int(round(base*SLOT_MULT.get(inv,0.7)/5.0))*5)

gear=lowgear.build()
w("-- Low-level PvP gear: Recruit's (shown to levels 1-9) and Skirmisher's (shown to levels 10-19 with Renown tier 1)")
w("DELETE FROM item_template WHERE entry BETWEEN 190600 AND 190799;")
for it in gear:
    # armor first: MySQL applies SET left to right, so ItemLevel is still the base item's here
    sets=[f"armor=IF(ItemLevel>{it['ilvl']}, ROUND(armor*{it['ilvl']}/ItemLevel), armor)" if it.get('scale_armor') else "armor=armor",
          f"entry={it['entry']}", "name='"+it['name'].replace("'","''")+"'", "Quality=3", f"ItemLevel={it['ilvl']}",
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

w("-- Reward stock: low-level sets first, then the Warsong Gulch reward lists, unlocked by renown tier instead of reputation")
rows=[]; costs={}
for qm,src in [(190100,14753),(190101,14754)]:
    k=0
    for it in gear:
        inv=int(q(f"select InventoryType from item_template where entry={it['base']}")[0][0])
        cond=59110 if it['bracket']=='t0' else 59112
        costs[it['entry']]=cost(T0_COST if it['bracket']=='t0' else TIER_COST[0], inv)
        rows.append(f"({qm},{it['entry']},0,0,{k},{cond},'Renown {'levels 1-9' if cond==59110 else 'levels 10-19, tier 1'}')"); k+=1
    items=q(f"select v.item,i.RequiredLevel,i.class,i.InventoryType from npc_vendor v join item_template i on i.entry=v.item where v.entry={src} order by i.RequiredLevel,v.item")
    for item,req,cls,inv in items:
        t=tier_for(int(req))
        rows.append(f"({qm},{item},0,0,{k},{59101+t},'Renown tier {t+1}')"); k+=1
        if int(cls)!=0:            # consumables (rations, bandages, draughts) keep their gold price
            costs[int(item)]=cost(TIER_COST[t], int(inv))
w("INSERT INTO npc_vendor (entry,item,maxcount,incrtime,slot,condition_id,comments) VALUES")
w(",\n".join(rows)+";")
w("")
w("-- Renown prices: read by the Renown server module (paid with spendable Renown points, not gold).")
w("-- Gold price is 0 so the client never blocks the purchase for lack of money; the RenownBar addon shows the Renown cost.")
w("CREATE TABLE IF NOT EXISTS custom_renown_vendor (item MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY, cost INT UNSIGNED NOT NULL DEFAULT 0) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Renown vendor prices';")
w("DELETE FROM custom_renown_vendor;")
w("INSERT INTO custom_renown_vendor (item,cost) VALUES")
w(",\n".join(f"({i},{c})" for i,c in sorted(costs.items()))+";")
w("UPDATE item_template i JOIN custom_renown_vendor c ON c.item=i.entry SET i.BuyPrice=0, i.SellPrice=0;")
open('/root/renown/zz_renown.sql','w',newline='\r\n').write("\n".join(L)+"\n")
print(len(rows),'vendor rows',len(costs),'renown items')

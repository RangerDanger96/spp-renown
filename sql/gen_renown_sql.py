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
w("")
w("-- Quartermasters become vendors too")
w("UPDATE creature_template SET NpcFlags = (NpcFlags & ~128) | 4 WHERE Entry IN (190100,190101); -- 4 = vendor in 1.12 (128 is innkeeper)")
w("INSERT INTO gossip_menu_option (menu_id,id,option_icon,option_text,option_broadcast_text,option_id,npc_option_npcflag,action_menu_id,action_poi_id,action_script_id,box_coded,box_money,box_text,box_broadcast_text,condition_id) VALUES")
w("(59000,10,1,'Show me the Renown rewards.',0,3,4,0,0,0,0,0,'',0,0);")
w("")
w("-- Reward stock: the Warsong Gulch reward lists, unlocked by renown tier instead of reputation")
rows=[]
for qm,src in [(190100,14753),(190101,14754)]:
    items=q(f"select v.item,i.RequiredLevel,v.slot from npc_vendor v join item_template i on i.entry=v.item where v.entry={src} order by i.RequiredLevel,v.item")
    for k,(item,req,slot) in enumerate(items):
        t=tier_for(int(req))
        rows.append(f"({qm},{item},0,0,{k},{59101+t},'Renown tier {t+1}')")
w("INSERT INTO npc_vendor (entry,item,maxcount,incrtime,slot,condition_id,comments) VALUES")
w(",\n".join(rows)+";")
w("")
w("-- Renown rewards are earned, not bought: no gold cost and no vendor sell value (stops a free-gold loop).")
w("-- Items also sold by other vendors (e.g. Superior Healing/Mana Draught) keep their normal price.")
w("UPDATE item_template i JOIN npc_vendor v ON v.item=i.entry AND v.entry IN (190100,190101) SET i.BuyPrice=0, i.SellPrice=0 WHERE NOT EXISTS (SELECT 1 FROM npc_vendor o WHERE o.item=i.entry AND o.entry NOT IN (190100,190101,14753,14754));")
open('/root/renown/zz_renown.sql','w',newline='\r\n').write("\n".join(L)+"\n")
print(len(rows),"vendor rows")

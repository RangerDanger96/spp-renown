import json
picks=json.load(open('/root/wow/build/picks.json'))
layout=json.load(open('/root/wow/build/layout.json'))
picks['Paladin'].pop('Ranged',None)
CLASSES=[('Warrior',1,1),('Paladin',2,2),('Hunter',3,4),('Rogue',4,8),('Priest',5,16),('Shaman',7,64),('Mage',8,128),('Warlock',9,256),('Druid',11,1024)]
ARMOR={'Head','Shoulder','Chest','Waist','Legs','Feet','Wrist','Hands'}
ARROWS={'Warrior':2515,'Hunter':2515,'Rogue':2515}
QM_A,QM_H=190100,190101
BM={'A':{'wsg':(190102,14981),'ab':(190103,15008),'av':(190104,7410)},
    'H':{'wsg':(190105,3890),'ab':(190106,15006),'av':(190107,14942)}}
BG_ID={'wsg':2,'ab':3,'av':1}
MENU=59000; TEXT=59000
L=[]
w=L.append
w("-- ============================================================")
w("-- Custom: Battleground Hub at every starting area")
w("-- Battlemasters (WSG/AB/AV) + Battleground Quartermaster")
w("-- Quartermaster: free weapon-skill training + class kits (gear + 15g)")
w("-- Re-runnable: deletes its own rows first. IDs 190100-190107,")
w("-- items 190500-190517, menu/text/scripts 59000-59009, conditions 59001-59009")
w("-- ============================================================")
allc=[QM_A,QM_H]+[e for s in BM.values() for e,_ in s.values()]
ids=",".join(map(str,allc))
w(f"DELETE FROM creature WHERE id IN ({ids});")
w(f"DELETE FROM creature_template WHERE Entry IN ({ids});")
w(f"DELETE FROM battlemaster_entry WHERE entry IN ({ids});")
w(f"DELETE FROM npc_trainer WHERE entry IN ({QM_A},{QM_H});")
w("DELETE FROM item_template WHERE entry BETWEEN 190500 AND 190517;")
w("DELETE FROM item_loot_template WHERE entry BETWEEN 190500 AND 190517;")
w(f"DELETE FROM gossip_menu WHERE entry={MENU};")
w(f"DELETE FROM gossip_menu_option WHERE menu_id={MENU};")
w(f"DELETE FROM npc_text WHERE ID={TEXT};")
w("DELETE FROM dbscripts_on_gossip WHERE id BETWEEN 59001 AND 59009;")
w("")
w("-- Quartermasters (cloned from Highlord Boosterian, neutral)")
for e,name,disp in [(QM_A,'Captain Brightshield',12918),(QM_H,'Warmaster Grakk',12678)]:
    w("DROP TEMPORARY TABLE IF EXISTS tmp_ct;")
    w("CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190011;")
    w(f"UPDATE tmp_ct SET Entry={e}, Name='{name}', SubName='Battleground Quartermaster', DisplayId1={disp}, NpcFlags=17, TrainerType=2, TrainerClass=0, TrainerRace=0, GossipMenuId={MENU}, MinLevel=60, MaxLevel=60, Faction=35;")
    w("INSERT INTO creature_template SELECT * FROM tmp_ct;")
w("")
w("-- Battlemasters (clones of the real ones, so they keep their battleground menus)")
for side,d in BM.items():
    for bg,(e,src) in d.items():
        w("DROP TEMPORARY TABLE IF EXISTS tmp_ct;")
        w(f"CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry={src};")
        w(f"UPDATE tmp_ct SET Entry={e};")
        w("INSERT INTO creature_template SELECT * FROM tmp_ct;")
        w(f"INSERT INTO battlemaster_entry (entry,bg_template) VALUES ({e},{BG_ID[bg]});")
w("DROP TEMPORARY TABLE IF EXISTS tmp_ct;")
w("")
w("-- Free weapon-skill training (every weapon master's list, 0 cost)")
w("INSERT INTO npc_trainer (entry,spell,spellcost,reqskill,reqskillvalue,reqlevel)")
w(" SELECT q.e, t.spell, 0, 0, 0, 1 FROM (SELECT DISTINCT spell FROM npc_trainer WHERE entry IN (2704,11865,11866,11867,11868,11869,11870,13084)) t")
w(f" CROSS JOIN (SELECT {QM_A} AS e UNION SELECT {QM_H}) q;")
w("")
w("-- Class conditions (type 14 = player race/class mask); reuse existing rows if present")
for i,(cn,cid,mask) in enumerate(CLASSES):
    w(f"INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT {5310101+i},14,0,{mask},0,0,0,'Player ClassMask: {mask}' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=14 AND value1=0 AND value2={mask} AND value3=0 AND value4=0 AND flags=0) AND NOT EXISTS (SELECT 1 FROM conditions WHERE condition_entry={5310101+i});")
    w(f"SET @bgc{i+1} := (SELECT condition_entry FROM conditions WHERE type=14 AND value1=0 AND value2={mask} AND value3=0 AND value4=0 AND flags=0 LIMIT 1);")
w("")
w("-- Gossip")
txt="Glory is earned on the battlefield, $C.$B$BEvery foe you defeat and every flag and banner you claim earns you Renown. Earn enough and the Quartermaster's stores are yours to choose from.$B$BI can also train you in any weapon for free, and the battlemasters beside me will send you to Warsong Gulch, Arathi Basin or Alterac Valley. When you are ready for open war, the Barrens Front awaits."
w("INSERT INTO npc_text (ID,text0_0,text0_1,lang0,prob0) VALUES ("+str(TEXT)+",'"+txt.replace("'","''")+"','',0,1);")
w(f"INSERT INTO gossip_menu (entry,text_id,script_id,condition_id) VALUES ({MENU},{TEXT},0,0);")
w("INSERT INTO gossip_menu_option (menu_id,id,option_icon,option_text,option_broadcast_text,option_id,npc_option_npcflag,action_menu_id,action_poi_id,action_script_id,box_coded,box_money,box_text,box_broadcast_text,condition_id) VALUES")
opts=[f"({MENU},0,3,'Train me in weapon skills.',0,5,16,0,0,0,0,0,'',0,0)"]
for i,(cn,cid,mask) in enumerate(CLASSES):
    opts.append(f"({MENU},{i+1},1,'Give me my {cn} battleground kit.',0,1,1,-1,0,{59001+i},0,0,'',0,@bgc{i+1})")
w(",\n".join(opts)+";")
w("")
w("-- Kits: lootable sacks, two per class (armor / arms and accessories)")
loot=[]; scripts=[]
for i,(cn,cid,mask) in enumerate(CLASSES):
    p=picks[cn]
    armor=[v[0] for k,v in p.items() if v and k in ARMOR]
    arms=[v[0] for k,v in p.items() if v and k not in ARMOR]
    for j,(label,lst,money) in enumerate([('Armor',armor,0),('Arms & Accessories',arms,150000)]):
        e=190500+i*2+j
        w("DROP TEMPORARY TABLE IF EXISTS tmp_it;")
        w("CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;")
        w(f"UPDATE tmp_it SET entry={e}, name='Battleground Kit: {cn} {label}', Quality=3, AllowableClass={mask}, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot={money}, maxMoneyLoot={money};")
        w("INSERT INTO item_template SELECT * FROM tmp_it;")
        for it in lst: loot.append(f"({e},{it},100,0,1,1,0,'BG Hub kit')")
        if j==1 and cn in ARROWS: loot.append(f"({e},{ARROWS[cn]},100,0,200,200,0,'BG Hub kit arrows')")
        scripts.append(f"({59001+i},0,{j},17,{e},1,0,'BG Hub: give {cn} {label} kit')")
w("DROP TEMPORARY TABLE IF EXISTS tmp_it;")
w("INSERT INTO item_loot_template (entry,item,ChanceOrQuestChance,groupid,mincountOrRef,maxcount,condition_id,comments) VALUES")
w(",\n".join(loot)+";")
w("INSERT INTO dbscripts_on_gossip (id,delay,priority,command,datalong,datalong2,datalong3,comments) VALUES")
w(",\n".join(scripts)+";")
w("")
w("-- Faster queues: battlegrounds start with fewer players; bots keep joining until full")
w("UPDATE battleground_template SET MinPlayersPerTeam=2 WHERE id=2; -- Warsong Gulch (default 5)")
w("UPDATE battleground_template SET MinPlayersPerTeam=3 WHERE id=3; -- Arathi Basin (default 8)")
w("UPDATE battleground_template SET MinPlayersPerTeam=5 WHERE id=1; -- Alterac Valley (default 20)")
w("")
w("-- Battlegrounds open at level 1 (needs the patched mangosd with the 1-9 bracket)")
w("UPDATE battleground_template SET MinLvl=1 WHERE id IN (2,3); -- Warsong Gulch (default 10), Arathi Basin (default 20)")
w("-- Battlemasters: drop the level 10/20 requirement on the 'go to the battleground' option and greeting")
w("DROP TEMPORARY TABLE IF EXISTS tmp_bm;")
w("CREATE TEMPORARY TABLE tmp_bm SELECT DISTINCT menu_id FROM gossip_menu_option WHERE option_id=12 AND condition_id IN (107,1011);")
w("UPDATE gossip_menu_option SET condition_id=0 WHERE option_id=12 AND condition_id IN (107,1011);")
w("DELETE g0 FROM gossip_menu g0 JOIN gossip_menu g1 ON g1.entry=g0.entry AND g1.condition_id IN (107,1011) WHERE g0.condition_id=0 AND g0.entry IN (SELECT menu_id FROM tmp_bm);")
w("UPDATE gossip_menu SET condition_id=0 WHERE condition_id IN (107,1011) AND entry IN (SELECT menu_id FROM tmp_bm);")
w("DROP TEMPORARY TABLE IF EXISTS tmp_bm;")
w("")
w("-- Spawns: fixed guids 9100300-9100323 (auto-increment guids could collide with other custom spawn ranges)")
w("DELETE FROM creature WHERE guid BETWEEN 9100300 AND 9100399;")
rows=[]
for r in layout:
    if r['role']=='quartermaster': e=QM_A if r['side']=='A' else QM_H
    else: e=BM[r['side']][r['role']][0]
    rows.append(f"({9100300+len(rows)},{e},{r['map']},1,{r['x']},{r['y']},{r['z']},{r['o']},25,25,0,0) -- {r['area']} {r['role']}")
w("INSERT INTO creature (guid,id,map,spawnMask,position_x,position_y,position_z,orientation,spawntimesecsmin,spawntimesecsmax,spawndist,MovementType) VALUES")
for k,row in enumerate(rows):
    body,cmt=row.split(' -- ')
    w(body+(";" if k==len(rows)-1 else ",")+" -- "+cmt)
open('/root/wow/build/zz_bg_hub.sql','w',newline='\r\n').write("\n".join(L)+"\n")
print(len(L),"lines")

import sys, math
sys.path.insert(0,'/root/wow/build')
from height import load, height
S=533.3333333
cache={}
def H(x,y):
    f='%03d%02d%02d'%(1,int(32-x/S),int(32-y/S))
    if f not in cache: cache[f]=load('/root/wow/maps/%s.map'%f)
    return height(cache[f],x,y)

OBJ=[('Kolkar Watch',-849.0,-2858.0,True),('Stagnant Oasis',-1255.0,-3150.0,False),('Raptor Grounds',-1790.0,-3280.0,True)]
H_CMD=(-680.0,-2740.0); A_CMD=(-1965.0,-3395.0)
EV=1100; EV_SIEGE_NW=1110; EV_SIEGE_CR=1111
GO_NEUTRAL,GO_ALLI,GO_HORDE=190800,190801,190802
C_A_DEF,C_H_DEF,C_A_CMD,C_H_CMD=190810,190811,190812,190813
GUID_C=9100000; GUID_G=5400000
L=[];w=L.append
w("-- ============================================================")
w("-- The Barrens Front: tier 1 RvR lake for the Renown module (Crossroads vs Northwatch Hold)")
w("-- Banners, objective guards and siege commanders are spawned by server-side game events 1100-1111,")
w("-- which the Renown module starts and stops. Re-runnable.")
w("-- ============================================================")
w(f"DELETE FROM game_event_creature WHERE event BETWEEN {EV} AND {EV_SIEGE_CR} OR guid BETWEEN {GUID_C} AND {GUID_C+199};")
w(f"DELETE FROM game_event_gameobject WHERE event BETWEEN {EV} AND {EV_SIEGE_CR} OR guid BETWEEN {GUID_G} AND {GUID_G+99};")
w(f"DELETE FROM game_event WHERE entry BETWEEN {EV} AND {EV_SIEGE_CR};")
w(f"DELETE FROM creature WHERE guid BETWEEN {GUID_C} AND {GUID_C+199};")
w(f"DELETE FROM gameobject WHERE guid BETWEEN {GUID_G} AND {GUID_G+99};")
w(f"DELETE FROM creature_template WHERE Entry BETWEEN {C_A_DEF} AND {C_H_CMD};")
w(f"DELETE FROM gameobject_template WHERE entry BETWEEN {GO_NEUTRAL} AND {GO_HORDE};")
w("")
w("-- Server-side events (schedule_type 0): only the module starts them")
ev=[]
for i,(n,x,y,t) in enumerate(OBJ):
    for s,sn in enumerate(['neutral','Alliance','Horde']):
        ev.append(f"({EV+i*3+s},0,525600,1,0,0,'Barrens Front: {n} {sn}')")
ev.append(f"({EV_SIEGE_NW},0,525600,1,0,0,'Barrens Front: siege on Northwatch (Alliance commander)')")
ev.append(f"({EV_SIEGE_CR},0,525600,1,0,0,'Barrens Front: siege on the Crossroads (Horde commander)')")
w("INSERT INTO game_event (entry,schedule_type,occurence,length,holiday,linkedTo,description) VALUES")
w(",\n".join(ev)+";")
w("")
w("-- Banners (look only, no interaction): neutral, Alliance, Horde")
w("INSERT INTO gameobject_template (entry,type,displayId,name,faction,flags,size) VALUES")
w(f"({GO_NEUTRAL},5,6211,'Barrens Front Banner',0,16,1.6),({GO_ALLI},5,5651,'Alliance Banner',0,16,1.6),({GO_HORDE},5,5652,'Horde Banner',0,16,1.6);")
w("")
w("-- Defenders and field commanders (level 20 defenders, level 23 elite commanders)")
def clone(src,entry,name,sub,lvl,rank,hp,dmin,dmax,armor):
    w("DROP TEMPORARY TABLE IF EXISTS tmp_ct;")
    w(f"CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry={src};")
    w(f"UPDATE tmp_ct SET Entry={entry}, Name='{name}', SubName='{sub}', MinLevel={lvl}, MaxLevel={lvl}, `Rank`={rank}, "
      f"MinLevelHealth={hp}, MaxLevelHealth={hp}, MinMeleeDmg={dmin}, MaxMeleeDmg={dmax}, Armor={armor}, NpcFlags=0, GossipMenuId=0, "
      "AIName='', ScriptName='', LootId=0, PickpocketLootId=0, SkinningLootId=0, MinLootGold=0, MaxLootGold=0, KillCredit1=0, KillCredit2=0, "
      "MovementType=0, Civilian=0, VendorTemplateId=0, TrainerTemplateId=0, TrainerType=0, ExperienceMultiplier=0;")
    w("INSERT INTO creature_template SELECT * FROM tmp_ct;")
clone(3385,C_A_DEF,'Theramore Vanguard','Barrens Front',20,0,700,30,40,850)
clone(3501,C_H_DEF,'Crossroads Vanguard','Barrens Front',20,0,700,30,40,850)
clone(3385,C_A_CMD,'Northwatch Field Commander','Barrens Front',23,1,6000,70,95,1150)
clone(3501,C_H_CMD,'Crossroads Warlord','Barrens Front',23,1,6000,70,95,1150)
w("DROP TEMPORARY TABLE IF EXISTS tmp_ct;")
w("")

# clear wildlife near the objectives and command points
pts=[(x,y) for _,x,y,_ in OBJ]+[H_CMD,A_CMD]
cond=" OR ".join(f"(POW(c.position_x-({x}),2)+POW(c.position_y-({y}),2)<{45*45})" for x,y in pts)
w("-- Clear wildlife within 45 yards of the objectives and command posts (no vendors, quest givers or event spawns)")
w("DROP TEMPORARY TABLE IF EXISTS tmp_clear;")
w("CREATE TEMPORARY TABLE tmp_clear (guid INT UNSIGNED PRIMARY KEY);")
w(f"INSERT IGNORE INTO tmp_clear SELECT c.guid FROM creature c LEFT JOIN creature_template t ON t.Entry=c.id WHERE c.map=1 AND ({cond}) "
  f"AND c.guid NOT BETWEEN {GUID_C} AND {GUID_C+199} AND COALESCE(t.NpcFlags,0)=0 AND c.guid NOT IN (SELECT guid FROM game_event_creature);")
for tbl,col in [('creature_addon','guid'),('creature_movement','Id'),('creature_linking','guid'),('creature_linking','master_guid'),
                ('creature_spawn_data','Guid'),('creature_spawn_entry','guid'),('creature_battleground','guid'),('pool_creature','guid'),
                ('creature_conditional_spawn','Guid'),('creature','guid')]:
    w(f"DELETE FROM {tbl} WHERE {col} IN (SELECT guid FROM tmp_clear);")
w("DROP TEMPORARY TABLE IF EXISTS tmp_clear;")
w("")

gos=[];gev=[];cr=[];cev=[]
gid=GUID_G; cid=GUID_C
def face(x,y,tx,ty): return math.atan2(ty-y,tx-x)%(2*math.pi)
for i,(n,x,y,tower) in enumerate(OBJ):
    z=H(x,y)
    for s,go in enumerate([GO_NEUTRAL,GO_ALLI,GO_HORDE]):
        o=0.0
        gos.append(f"({gid},{go},1,1,{x:.3f},{y:.3f},{z+0.05:.3f},{o},0,0,{math.sin(o/2):.6f},{math.cos(o/2):.6f},0,0)")
        gev.append(f"({gid},{EV+i*3+s})"); gid+=1
    count=3 if tower else 2
    for s,entry in [(1,C_A_DEF),(2,C_H_DEF)]:
        for k in range(count):
            a=2*math.pi*k/count+(0.4 if s==2 else 0.0)
            gx,gy=x+9*math.cos(a),y+9*math.sin(a)
            cr.append(f"({cid},{entry},1,1,{gx:.3f},{gy:.3f},{H(gx,gy)+0.1:.3f},{face(gx,gy,x,y)+math.pi:.4f},120,120,0,0)")
            cev.append(f"({cid},{EV+i*3+s})"); cid+=1
for (cx,cy),cmd,esc,event in [(A_CMD,C_A_CMD,C_A_DEF,EV_SIEGE_NW),(H_CMD,C_H_CMD,C_H_DEF,EV_SIEGE_CR)]:
    cr.append(f"({cid},{cmd},1,1,{cx:.3f},{cy:.3f},{H(cx,cy)+0.1:.3f},0,3600,3600,0,0)"); cev.append(f"({cid},{event})"); cid+=1
    for k in range(4):
        a=2*math.pi*k/4+0.785
        gx,gy=cx+6*math.cos(a),cy+6*math.sin(a)
        cr.append(f"({cid},{esc},1,1,{gx:.3f},{gy:.3f},{H(gx,gy)+0.1:.3f},{face(gx,gy,cx,cy)+math.pi:.4f},3600,3600,0,0)")
        cev.append(f"({cid},{event})"); cid+=1
w("-- Banners: one per state at each objective")
w("INSERT INTO gameobject (guid,id,map,spawnMask,position_x,position_y,position_z,orientation,rotation0,rotation1,rotation2,rotation3,spawntimesecsmin,spawntimesecsmax) VALUES")
w(",\n".join(gos)+";")
w("INSERT INTO game_event_gameobject (guid,event) VALUES "+",".join(gev)+";")
w("")
w("-- Guards for the owner of each objective, and the commanders with their escorts")
w("INSERT INTO creature (guid,id,map,spawnMask,position_x,position_y,position_z,orientation,spawntimesecsmin,spawntimesecsmax,spawndist,MovementType) VALUES")
w(",\n".join(cr)+";")
w("INSERT INTO game_event_creature (guid,event) VALUES "+",".join(cev)+";")
open('/root/rvr/zz_rvr.sql','w',newline='\r\n').write("\n".join(L)+"\n")
print(len(gos),'banners',len(cr),'creatures')

# ======================================================================= war board quests
Q=[]; q=Q.append
EVQ=1120
q("")
q("-- ============================================================")
q("-- Barrens Front war boards: 8 rotating daily quests (3 a day) and a weekly quest per faction")
q("-- Rotation events 1120-1127 (started by the Renown module), conditions 59120-59127, quests 90101-90119,")
q("-- credit markers 190820-190829, board 190803. Daily = QuestFlags 0x1000 (core patch).")
q("-- ============================================================")
q("DELETE FROM game_event WHERE entry BETWEEN 1120 AND 1127;")
q("DELETE FROM conditions WHERE condition_entry BETWEEN 59120 AND 59127;")
q("DELETE FROM creature_template WHERE Entry BETWEEN 190820 AND 190829;")
q("DELETE FROM gameobject_template WHERE entry=190803;")
q("DELETE FROM gameobject WHERE guid BETWEEN 5400100 AND 5400109;")
q("DELETE FROM quest_template WHERE entry BETWEEN 90101 AND 90119;")
q("DELETE FROM gameobject_questrelation WHERE quest BETWEEN 90101 AND 90119;")
q("DELETE FROM gameobject_involvedrelation WHERE quest BETWEEN 90101 AND 90119;")
q("INSERT INTO game_event (entry,schedule_type,occurence,length,holiday,linkedTo,description) VALUES")
q(",\n".join(f"({EVQ+i},0,525600,1,0,0,'Barrens Front war board: daily order {i+1}')" for i in range(8))+";")
q("INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) VALUES")
q(",\n".join(f"({59120+i},12,{EVQ+i},0,0,0,0,'Renown: war board daily order {i+1} is posted')" for i in range(8))+";")
q("")
q("-- Credit markers (never spawned; the Renown module credits them to the quests)")
credits=[(190820,'Objective captured'),(190821,'Objective defended'),(190822,'Enemy soldier defeated'),(190823,'Healing assist'),
         (190824,'Killing spree ended'),(190825,'Kolkar Watch scouted'),(190826,'Stagnant Oasis scouted'),(190827,'Raptor Grounds scouted'),
         (190828,'Enemy defeated at the Oasis'),(190829,'Barrens Front won')]
for e,n in credits:
    q("DROP TEMPORARY TABLE IF EXISTS tmp_ct;")
    q("CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190810;")
    q(f"UPDATE tmp_ct SET Entry={e}, Name='{n}', SubName='Barrens Front';")
    q("INSERT INTO creature_template SELECT * FROM tmp_ct;")
q("DROP TEMPORARY TABLE IF EXISTS tmp_ct;")
q("")
q("-- War Board (clone of the Wanted Board quest giver)")
q("DROP TEMPORARY TABLE IF EXISTS tmp_gt;")
q("CREATE TEMPORARY TABLE tmp_gt SELECT * FROM gameobject_template WHERE entry=2713;")
q("UPDATE tmp_gt SET entry=190803, name='Barrens Front War Board', faction=0, size=1.2;")
q("INSERT INTO gameobject_template SELECT * FROM tmp_gt;")
q("DROP TEMPORARY TABLE IF EXISTS tmp_gt;")
boards=[(5400100,-462.0,-2617.0,(-450.0,-2630.0)),(5400101,-2086.0,-3628.0,(-2093.0,-3639.0))]
rows=[]
for g,x,y,(fx,fy) in boards:
    o=math.atan2(fy-y,fx-x)%(2*math.pi)
    z=H(x,y)
    if g==5400101: z=max(z,61.8)
    rows.append(f"({g},190803,1,1,{x:.3f},{y:.3f},{z+0.05:.3f},{o:.4f},0,0,{math.sin(o/2):.6f},{math.cos(o/2):.6f},120,120)")
q("INSERT INTO gameobject (guid,id,map,spawnMask,position_x,position_y,position_z,orientation,rotation0,rotation1,rotation2,rotation3,spawntimesecsmin,spawntimesecsmax) VALUES")
q(",\n".join(rows)+";")
q("")

def esc(t): return t.replace("'","''")
HORDE,ALLI=178,77
# (index, horde title, alliance title, objectives text, [(reqId,count,objtext)], details_h, details_a, reward text)
DAILIES=[
 (0,"Seize the Front","Seize the Front","Capture an objective on the Barrens Front.",
  [(190820,1,"Objective captured")],
  "The front is a line on a map until somebody plants a banner on it, $N. Take Kolkar Watch, the Stagnant Oasis or the Raptor Grounds for the Horde.",
  "Theramore does not hold ground by wishing for it, $N. Take an objective on the front: the Raptor Grounds, the Stagnant Oasis or Kolkar Watch.",
  "A banner planted is a promise kept. Well done."),
 (1,"Hold the Line","Hold the Line","Defeat 5 enemies near an objective your side holds.",
  [(190821,5,"Objective defended")],
  "Taking ground is easy. Keeping it is what wins wars. Stand guard at an objective we hold and cut down any Alliance dog who tries to take it.",
  "Every banner we raise draws the Horde like flies. Stand watch at an objective we hold and drive them off.",
  "The line held. That is all I ask."),
 (2,"Blood and Thunder","For Theramore!","Defeat 10 enemy players on the Barrens Front.",
  [(190822,10,"Enemy soldier defeated")],
  "The Alliance has marched an army into our Barrens. Remind them why orcs are feared. Ten of them, $N, on the front.",
  "The Horde has been raiding our caravans from the Crossroads for too long. Meet them on the front and bring down ten of their soldiers.",
  "Lok'tar! The front is quieter for it."),
 (3,"Field Medic","Field Medic","Earn 10 healing assists on the Barrens Front.",
  [(190823,10,"Healing assist")],
  "Warriors win battles, but healers win wars. Keep our fighters standing while they cut down the enemy.",
  "Our soldiers are brave, but brave soldiers bleed. Keep them on their feet while they fight.",
  "Many owe you their lives today, though few of them will say it."),
 (4,"Bounty Hunter","Break Their Spirit","End an enemy's killing spree on the Barrens Front.",
  [(190824,1,"Killing spree ended")],
  "Some Alliance hero is always strutting about the front with blood on his blade. Find one on a killing spree and end it.",
  "There is always one of them on a rampage, howling over a pile of our dead. Find a Horde soldier on a killing spree and put an end to it.",
  "The braggart is silenced. Good."),
 (5,"Scout the Front","Scout the Front","Visit Kolkar Watch, the Stagnant Oasis and the Raptor Grounds.",
  [(190825,1,"Kolkar Watch scouted"),(190826,1,"Stagnant Oasis scouted"),(190827,1,"Raptor Grounds scouted")],
  "I need fresh eyes on the whole front. Ride past Kolkar Watch, the Stagnant Oasis and the Raptor Grounds and tell me what you see.",
  "Our maps are a day old and a day is a long time in war. Scout Kolkar Watch, the Stagnant Oasis and the Raptor Grounds.",
  "Good. Now I know where to send the others."),
 (6,"Thin the Vanguard","Break the Vanguard","",
  None,
  "Theramore has sent its Vanguard to guard the objectives they hold. Kill five of them.",
  "The Warsong have posted their Vanguard at every objective they hold. Kill five of them.",
  "Their Vanguard will think twice before standing guard."),
 (7,"Blood in the Oasis","Waters of War","Defeat 5 enemies at the Stagnant Oasis.",
  [(190828,5,"Enemy defeated at the Oasis")],
  "Whoever holds the Stagnant Oasis holds the Barrens. Make its waters run red. Five kills at the Oasis.",
  "The Stagnant Oasis is the heart of the front. Fight there and bring down five of the enemy.",
  "The Oasis remembers who fought for it."),
]
qrows=[]
def quest(entry,races,flags,cond,title,obj,reqs,details,offer,weekly=False):
    reqid=[0,0,0,0]; reqcnt=[0,0,0,0]; otext=['','','','']
    for k,(rid,cnt,ot) in enumerate(reqs):
        reqid[k]=rid; reqcnt[k]=cnt; otext[k]=ot
    details=details+("$B$BThese orders are posted every week." if weekly else "$B$BThe war board's orders change daily.")
    cols=("entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,"
          "Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,"
          "ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,"
          "ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel")
    vals=[entry,2,17,1,255,10,41,races,cond,flags,1,
          f"'{esc(title)}'",f"'{esc(details)}'",f"'{esc(obj)}'",f"'{esc(offer)}'","'Report back when it is done, $N.'","''"]+[f"'{esc(t)}'" for t in otext]+reqid+reqcnt+[5000 if weekly else 2500,0]
    qrows.append(f"INSERT INTO quest_template ({cols}) VALUES ("+",".join(str(v) for v in vals)+");")
for idx,th,ta,obj,reqs,dh,da,offer in DAILIES:
    for base,races,title,details,enemyVanguard,objtxt in [(90101,HORDE,th,dh,190810,"Slay 5 Theramore Vanguards."),(90111,ALLI,ta,da,190811,"Slay 5 Crossroads Vanguards.")]:
        r=reqs if reqs else [(enemyVanguard,5,'')]
        o=obj if obj else objtxt
        quest(base+idx,races,0x1000|0x8,59120+idx,title,o,r,details,offer)
for entry,races,title,details in [(90109,HORDE,"Victory on the Barrens Front","Hold the whole front, break their siege line and kill their field commander. Do that, $N, and the Barrens belong to the Horde for a time."),
                                  (90119,ALLI,"Victory on the Barrens Front","Take the whole front, open the siege and bring down the Crossroads Warlord. Win the Barrens Front for the Alliance.")]:
    quest(entry,races,0x8000|0x8,0,title,"Help your side win the Barrens Front.",[(190829,1,"Barrens Front won")],details,"A victory worth singing about. Take this, you have earned it.",weekly=True)
Q.extend(qrows)
q("INSERT INTO gameobject_questrelation (id,quest) VALUES "+",".join(f"(190803,{e})" for e in list(range(90101,90110))+list(range(90111,90120)))+";")
q("INSERT INTO gameobject_involvedrelation (id,quest) VALUES "+",".join(f"(190803,{e})" for e in list(range(90101,90110))+list(range(90111,90120)))+";")
with open('/root/rvr/zz_rvr.sql','a',newline='\r\n') as f:
    f.write("\n".join(Q)+"\n")
print(len(qrows),'quests')

# ------------------------------------------------------------------ lake wildlife (event 1112)
# While event 1112 is active (started by the Renown module) the natural mob spawns inside the lake are removed:
# beasts, centaurs, silithid... Town NPCs, guards (Crossroads, Northwatch/Theramore), quest givers and critters stay.
# Computed in the server's own database (distance to the lake path), so it works whatever the spawn guids are.
LAKE=[(-680,-2740),(-849,-2858),(-1255,-3150),(-1790,-3280),(-1965,-3395)]
def segsql(a,b,r=200):
    ax,ay=a; bx,by=b; dx,dy=bx-ax,by-ay; L=dx*dx+dy*dy
    t=f"GREATEST(0,LEAST(1,((c.position_x-({ax}))*({dx})+(c.position_y-({ay}))*({dy}))/{L}))"
    return f"(POW(c.position_x-({ax})-{t}*({dx}),2)+POW(c.position_y-({ay})-{t}*({dy}),2) <= {r*r})"
cond=" OR ".join(segsql(LAKE[i],LAKE[i+1]) for i in range(len(LAKE)-1))
S=[]
S.append("")
S.append("-- ============================================================")
S.append("-- Barrens Front: lake wildlife removed while game event 1112 is active (the Renown module starts it)")
S.append("-- ============================================================")
S.append("DELETE FROM game_event_creature WHERE event=-1112;")
S.append("DELETE FROM game_event WHERE entry=1112;")
S.append("INSERT INTO game_event (entry,schedule_type,occurence,length,holiday,linkedTo,description) VALUES (1112,0,525600,1,0,0,'Barrens Front: lake wildlife cleared');")
S.append("-- Kolkar patrols and the Brokespear rare in the lake are spawn groups: take them out of their groups first")
S.append("DELETE s FROM spawn_group_spawn s JOIN spawn_group g ON g.Id=s.Id JOIN creature c ON c.guid=s.Guid "
         "WHERE g.Name LIKE 'Barrens - %' AND c.map=1 AND c.position_x BETWEEN -2300 AND -300 AND c.position_y BETWEEN -3700 AND -2400 "
         f"AND ({cond.replace('c.position','c.position')});")
S.append("INSERT IGNORE INTO game_event_creature (guid,event) SELECT c.guid,-1112 FROM creature c JOIN creature_template t ON t.Entry=c.id "
         "WHERE c.map=1 AND c.position_x BETWEEN -2300 AND -300 AND c.position_y BETWEEN -3700 AND -2400 "
         "AND c.id < 190000 AND t.NpcFlags=0 AND t.CreatureType<>8 AND t.Faction NOT IN (85,1077,29,104,126) "
         "AND c.guid NOT IN (SELECT guid FROM (SELECT guid FROM game_event_creature) e) "
         "AND c.guid NOT IN (SELECT Guid FROM spawn_group_spawn) "
         f"AND ({cond});")
S.append("SELECT 'lake_wildlife_removed', COUNT(*) FROM game_event_creature WHERE event=-1112;")
with open('/root/rvr/zz_rvr.sql','a',newline='\r\n') as f: f.write("\n".join(S)+"\n")

# ------------------------------------------------------------------ separate front graveyards
# Ratchet's graveyard served the whole Barrens for both sides and sits right next to the lake, so everyone came
# back at the same spirit healer. On the front: Horde -> the Crossroads (already Horde only), Alliance -> a new
# graveyard inside Northwatch Hold. Ratchet keeps serving the town of Ratchet itself (area 392).
G=[]
G.append("")
G.append("-- ============================================================")
G.append("-- Barrens Front: separate graveyards (Horde: the Crossroads, Alliance: Northwatch Hold)")
G.append("-- ============================================================")
G.append("DELETE FROM world_safe_locs WHERE id=1900;")
G.append("INSERT INTO world_safe_locs (id,map,x,y,z,o,name) VALUES (1900,1,-2093.0,-3639.0,62.0,1.0,'The Barrens, Northwatch Hold');")
G.append("DELETE FROM game_graveyard_zone WHERE id=1900 OR (id=249 AND ghost_loc IN (17,392));")
G.append("INSERT INTO game_graveyard_zone (id,ghost_loc,link_kind,faction) VALUES (1900,17,0,469),(249,392,0,0);")
G.append("DELETE FROM creature WHERE guid=9100340;")
G.append("INSERT INTO creature (guid,id,map,spawnMask,position_x,position_y,position_z,orientation,spawntimesecsmin,spawntimesecsmax,spawndist,MovementType) VALUES (9100340,6491,1,1,-2093.0,-3639.0,62.0,1.0,60,60,0,0);")
with open('/root/rvr/zz_rvr.sql','a',newline='\r\n') as f: f.write("\n".join(G)+"\n")

# ------------------------------------------------------------------ front life NPCs (summoned by the Renown module)
F=[]
F.append("")
F.append("-- ============================================================")
F.append("-- Barrens Front life: supply caravans (190840 kodo, 190841 mule) and standard-bearers (190842 Horde, 190843 Alliance)")
F.append("-- ============================================================")
F.append("DELETE FROM creature_template WHERE Entry BETWEEN 190840 AND 190843;")
def fclone(src,entry,name,sub,lvl,rank,hp,dmin,dmax,armor,faction):
    F.append("DROP TEMPORARY TABLE IF EXISTS tmp_ct;")
    F.append(f"CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry={src};")
    F.append(f"UPDATE tmp_ct SET Entry={entry}, Name='{name}', SubName='{sub}', MinLevel={lvl}, MaxLevel={lvl}, `Rank`={rank}, Faction={faction}, "
      f"MinLevelHealth={hp}, MaxLevelHealth={hp}, MinMeleeDmg={dmin}, MaxMeleeDmg={dmax}, Armor={armor}, NpcFlags=0, GossipMenuId=0, UnitFlags=0, "
      "AIName='', ScriptName='', LootId=0, PickpocketLootId=0, SkinningLootId=0, MinLootGold=0, MaxLootGold=0, KillCredit1=0, KillCredit2=0, "
      "MovementType=0, Civilian=0, VendorTemplateId=0, TrainerTemplateId=0, TrainerType=0, ExperienceMultiplier=0;")
    F.append("INSERT INTO creature_template SELECT * FROM tmp_ct;")
fclone(10636,190840,'Crossroads Supply Kodo','Barrens Front',20,1,3500,10,15,900,85)
fclone(16225,190841,'Northwatch Supply Mule','Barrens Front',20,1,3500,10,15,900,1077)
fclone(3501,190842,'Horde Standard-Bearer','Barrens Front',21,1,2500,45,60,950,85)
fclone(3385,190843,'Alliance Standard-Bearer','Barrens Front',21,1,2500,45,60,950,1077)
F.append("DROP TEMPORARY TABLE IF EXISTS tmp_ct;")
with open('/root/rvr/zz_rvr.sql','a',newline='\r\n') as f: f.write("\n".join(F)+"\n")

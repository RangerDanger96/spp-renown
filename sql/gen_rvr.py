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

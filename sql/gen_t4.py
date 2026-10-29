# Plaguelands Front (tier 4 RvR, level 60): keeps, Darkness Falls (Stratholme) access, graveyards
import math
L=[]; w=L.append
w("-- ============================================================")
w("-- Plaguelands Front (tier 4 RvR, levels 55-60) for the Renown module")
w("-- Towers: the 1.12 Eastern Plaguelands world PvP towers (core outdoor PvP)")
w("-- Keeps: Darrowshire (Alliance) and Northdale (Horde); creatures 190850-190853, spawns 9100400-9100419")
w("-- Events 1130/1131 = Plaguelands held by Alliance/Horde (Darkness Falls: Stratholme opens to that side only)")
w("-- Event 1132 = keep sites cleared of monsters. Re-runnable. Runs after zz_rvr.sql.")
w("-- ============================================================")
w("DELETE FROM creature_template WHERE Entry BETWEEN 190850 AND 190853;")
w("DELETE FROM creature WHERE guid BETWEEN 9100400 AND 9100419;")
w("DELETE FROM game_event WHERE entry BETWEEN 1130 AND 1132;")
w("DELETE FROM game_event_creature WHERE event=-1132;")
def clone(src,entry,name,sub,lvl,rank,hp,dmin,dmax,armor):
    w("DROP TEMPORARY TABLE IF EXISTS tmp_ct;")
    w(f"CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry={src};")
    w(f"UPDATE tmp_ct SET Entry={entry}, Name='{name}', SubName='{sub}', MinLevel={lvl}, MaxLevel={lvl}, `Rank`={rank}, "
      f"MinLevelHealth={hp}, MaxLevelHealth={hp}, MinMeleeDmg={dmin}, MaxMeleeDmg={dmax}, Armor={armor};")
    w("INSERT INTO creature_template SELECT * FROM tmp_ct;")
clone(190812,190850,'Marshal of Darrowshire','Plaguelands Front',62,1,45000,450,650,4200)
clone(190813,190851,'Warlord of Northdale','Plaguelands Front',62,1,45000,450,650,4200)
clone(190810,190852,'Darrowshire Keep Guard','Plaguelands Front',60,1,9000,220,320,3600)
clone(190811,190853,'Northdale Keep Guard','Plaguelands Front',60,1,9000,220,320,3600)
w("DROP TEMPORARY TABLE IF EXISTS tmp_ct;")
w("")
w("-- Keep guards (always there; the keep lord only takes the field during a siege)")
A=[(1476.0,-3717.0,79.98),(1471.5,-3709.2,79.70),(1462.5,-3709.2,78.56),(1458.0,-3717.0,79.67),(1462.5,-3724.8,80.15),(1471.5,-3724.8,80.02)]
H=[(3001.0,-5005.0,104.30),(2996.5,-4997.2,106.80),(2987.5,-4997.2,107.04),(2983.0,-5005.0,105.16),(2987.5,-5012.8,104.78),(2996.5,-5012.8,103.83)]
rows=[]
for k,(x,y,z) in enumerate(A):
    o=math.atan2(y+3717,x-1467)%(2*math.pi); rows.append(f"({9100400+k},190852,0,1,{x},{y},{z+0.3:.2f},{o:.3f},120,120,0,0)")
for k,(x,y,z) in enumerate(H):
    o=math.atan2(y+5005,x-2992)%(2*math.pi); rows.append(f"({9100406+k},190853,0,1,{x},{y},{z+0.3:.2f},{o:.3f},120,120,0,0)")
rows.append("(9100412,6491,0,1,2975.0,-4990.0,110.0,3.0,60,60,0,0)")   # spirit healer at the Northdale graveyard
w("INSERT INTO creature (guid,id,map,spawnMask,position_x,position_y,position_z,orientation,spawntimesecsmin,spawntimesecsmax,spawndist,MovementType) VALUES")
w(",\n".join(rows)+";")
w("")
w("INSERT INTO game_event (entry,schedule_type,occurence,length,holiday,linkedTo,description) VALUES")
w("(1130,0,525600,1,0,0,'Plaguelands Front: held by the Alliance (Darkness Falls)'),")
w("(1131,0,525600,1,0,0,'Plaguelands Front: held by the Horde (Darkness Falls)'),")
w("(1132,0,525600,1,0,0,'Plaguelands Front: keep sites cleared');")
w("-- Monsters within 80 yards of the keeps leave while event 1132 is active (the Renown module starts it)")
w("INSERT IGNORE INTO game_event_creature (guid,event) SELECT c.guid,-1132 FROM creature c JOIN creature_template t ON t.Entry=c.id "
  "WHERE c.map=0 AND c.id < 190000 AND t.NpcFlags=0 AND t.CreatureType<>8 "
  "AND c.guid NOT IN (SELECT guid FROM (SELECT guid FROM game_event_creature) e) AND c.guid NOT IN (SELECT Guid FROM spawn_group_spawn) "
  "AND (POW(c.position_x-1467,2)+POW(c.position_y+3717,2) <= 6400 OR POW(c.position_x-2992,2)+POW(c.position_y+5005,2) <= 6400);")
w("")
w("-- Graveyards on the front: Alliance at Darrowshire, Horde at a new Northdale graveyard, Light's Hope stays neutral;")
w("-- Blackwood Lake (between the lines) no longer serves the zone. The Crown Guard graveyard is the tower's own reward.")
w("DELETE FROM world_safe_locs WHERE id=1901;")
w("INSERT INTO world_safe_locs (id,map,x,y,z,o,name) VALUES (1901,0,2975.0,-4990.0,110.0,3.0,'Eastern Plaguelands, Northdale');")
w("DELETE FROM game_graveyard_zone WHERE (id=1901) OR (id=909 AND ghost_loc=139);")
w("UPDATE game_graveyard_zone SET faction=469 WHERE id=634 AND ghost_loc=139;")
w("INSERT INTO game_graveyard_zone (id,ghost_loc,link_kind,faction) VALUES (1901,139,0,67);")
w("")
w("-- Darkness Falls: while a side holds the Plaguelands, Stratholme opens only to that side (open to all while nobody holds it)")
def cond(var,cid,t,v1,v2,flags,cmt):
    where=f"type={t} AND value1={v1} AND value2={v2} AND value3=0 AND value4=0 AND flags={flags}"
    w(f"INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT {cid},{t},{v1},{v2},0,0,{flags},'Renown T4: {cmt}' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE {where});")
    w(f"SET {var} := (SELECT condition_entry FROM conditions WHERE {where} ORDER BY condition_entry LIMIT 1);")
w("DELETE FROM conditions WHERE condition_entry BETWEEN 59400 AND 59409;")
cond("@t4a",59400,6,469,0,0,"team Alliance")
cond("@t4h",59401,6,67,0,0,"team Horde")
cond("@t4nh",59402,12,1131,0,1,"Horde does not hold the Plaguelands")
cond("@t4na",59403,12,1130,0,1,"Alliance does not hold the Plaguelands")
cond("@t4oka",59404,-1,"@t4a","@t4nh",0,"Alliance may enter Stratholme")
cond("@t4okh",59405,-1,"@t4h","@t4na",0,"Horde may enter Stratholme")
cond("@t4ok",59406,-2,"@t4oka","@t4okh",0,"may enter Stratholme (Darkness Falls)")
w("UPDATE areatrigger_teleport SET condition_id=@t4ok, status_failed_text='Darkness Falls: the enemy holds the Plaguelands, and Stratholme is sealed to you. Win the Plaguelands Front to open it.' WHERE target_map=329;")
w("SELECT 't4_keep_site_cleared', COUNT(*) FROM game_event_creature WHERE event=-1132;")
open('/root/t4/zz_t4.sql','w',newline='\r\n').write("\n".join(L)+"\n")
print(len(L),'lines')

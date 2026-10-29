-- ============================================================
-- Plaguelands Front (tier 4 RvR, levels 55-60) for the Renown module
-- Towers: the 1.12 Eastern Plaguelands world PvP towers (core outdoor PvP)
-- Keeps: Darrowshire (Alliance) and Northdale (Horde); creatures 190850-190853, spawns 9100400-9100419
-- Events 1130/1131 = Plaguelands held by Alliance/Horde (Darkness Falls: Stratholme opens to that side only)
-- Event 1132 = keep sites cleared of monsters. Re-runnable. Runs after zz_rvr.sql.
-- ============================================================
DELETE FROM creature_template WHERE Entry BETWEEN 190850 AND 190853;
DELETE FROM creature WHERE guid BETWEEN 9100400 AND 9100419;
DELETE FROM game_event WHERE entry BETWEEN 1130 AND 1132;
DELETE FROM game_event_creature WHERE event=-1132;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190812;
UPDATE tmp_ct SET Entry=190850, Name='Marshal of Darrowshire', SubName='Plaguelands Front', MinLevel=62, MaxLevel=62, `Rank`=1, MinLevelHealth=45000, MaxLevelHealth=45000, MinMeleeDmg=450, MaxMeleeDmg=650, Armor=4200;
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190813;
UPDATE tmp_ct SET Entry=190851, Name='Warlord of Northdale', SubName='Plaguelands Front', MinLevel=62, MaxLevel=62, `Rank`=1, MinLevelHealth=45000, MaxLevelHealth=45000, MinMeleeDmg=450, MaxMeleeDmg=650, Armor=4200;
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190810;
UPDATE tmp_ct SET Entry=190852, Name='Darrowshire Keep Guard', SubName='Plaguelands Front', MinLevel=60, MaxLevel=60, `Rank`=1, MinLevelHealth=9000, MaxLevelHealth=9000, MinMeleeDmg=220, MaxMeleeDmg=320, Armor=3600;
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190811;
UPDATE tmp_ct SET Entry=190853, Name='Northdale Keep Guard', SubName='Plaguelands Front', MinLevel=60, MaxLevel=60, `Rank`=1, MinLevelHealth=9000, MaxLevelHealth=9000, MinMeleeDmg=220, MaxMeleeDmg=320, Armor=3600;
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;

-- Keep guards (always there; the keep lord only takes the field during a siege)
INSERT INTO creature (guid,id,map,spawnMask,position_x,position_y,position_z,orientation,spawntimesecsmin,spawntimesecsmax,spawndist,MovementType) VALUES
(9100400,190852,0,1,1476.0,-3717.0,80.28,0.000,120,120,0,0),
(9100401,190852,0,1,1471.5,-3709.2,80.00,1.048,120,120,0,0),
(9100402,190852,0,1,1462.5,-3709.2,78.86,2.094,120,120,0,0),
(9100403,190852,0,1,1458.0,-3717.0,79.97,3.142,120,120,0,0),
(9100404,190852,0,1,1462.5,-3724.8,80.45,4.189,120,120,0,0),
(9100405,190852,0,1,1471.5,-3724.8,80.32,5.236,120,120,0,0),
(9100406,190853,0,1,3001.0,-5005.0,104.60,0.000,120,120,0,0),
(9100407,190853,0,1,2996.5,-4997.2,107.10,1.048,120,120,0,0),
(9100408,190853,0,1,2987.5,-4997.2,107.34,2.094,120,120,0,0),
(9100409,190853,0,1,2983.0,-5005.0,105.46,3.142,120,120,0,0),
(9100410,190853,0,1,2987.5,-5012.8,105.08,4.189,120,120,0,0),
(9100411,190853,0,1,2996.5,-5012.8,104.13,5.236,120,120,0,0),
(9100412,6491,0,1,2975.0,-4990.0,110.0,3.0,60,60,0,0);

INSERT INTO game_event (entry,schedule_type,occurence,length,holiday,linkedTo,description) VALUES
(1130,0,525600,1,0,0,'Plaguelands Front: held by the Alliance (Darkness Falls)'),
(1131,0,525600,1,0,0,'Plaguelands Front: held by the Horde (Darkness Falls)'),
(1132,0,525600,1,0,0,'Plaguelands Front: keep sites cleared');
-- Monsters within 80 yards of the keeps leave while event 1132 is active (the Renown module starts it)
INSERT IGNORE INTO game_event_creature (guid,event) SELECT c.guid,-1132 FROM creature c JOIN creature_template t ON t.Entry=c.id WHERE c.map=0 AND c.id < 190000 AND t.NpcFlags=0 AND t.CreatureType<>8 AND c.guid NOT IN (SELECT guid FROM (SELECT guid FROM game_event_creature) e) AND c.guid NOT IN (SELECT Guid FROM spawn_group_spawn) AND (POW(c.position_x-1467,2)+POW(c.position_y+3717,2) <= 6400 OR POW(c.position_x-2992,2)+POW(c.position_y+5005,2) <= 6400);

-- Graveyards on the front: Alliance at Darrowshire, Horde at a new Northdale graveyard, Light's Hope stays neutral;
-- Blackwood Lake (between the lines) no longer serves the zone. The Crown Guard graveyard is the tower's own reward.
DELETE FROM world_safe_locs WHERE id=1901;
INSERT INTO world_safe_locs (id,map,x,y,z,o,name) VALUES (1901,0,2975.0,-4990.0,110.0,3.0,'Eastern Plaguelands, Northdale');
DELETE FROM game_graveyard_zone WHERE (id=1901) OR (id=909 AND ghost_loc=139);
UPDATE game_graveyard_zone SET faction=469 WHERE id=634 AND ghost_loc=139;
INSERT INTO game_graveyard_zone (id,ghost_loc,link_kind,faction) VALUES (1901,139,0,67);

-- Darkness Falls: while a side holds the Plaguelands, Stratholme opens only to that side (open to all while nobody holds it)
DELETE FROM conditions WHERE condition_entry BETWEEN 59400 AND 59409;
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59400,6,469,0,0,0,0,'Renown T4: team Alliance' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=6 AND value1=469 AND value2=0 AND value3=0 AND value4=0 AND flags=0);
SET @t4a := (SELECT condition_entry FROM conditions WHERE type=6 AND value1=469 AND value2=0 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59401,6,67,0,0,0,0,'Renown T4: team Horde' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=6 AND value1=67 AND value2=0 AND value3=0 AND value4=0 AND flags=0);
SET @t4h := (SELECT condition_entry FROM conditions WHERE type=6 AND value1=67 AND value2=0 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59402,12,1131,0,0,0,1,'Renown T4: Horde does not hold the Plaguelands' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=12 AND value1=1131 AND value2=0 AND value3=0 AND value4=0 AND flags=1);
SET @t4nh := (SELECT condition_entry FROM conditions WHERE type=12 AND value1=1131 AND value2=0 AND value3=0 AND value4=0 AND flags=1 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59403,12,1130,0,0,0,1,'Renown T4: Alliance does not hold the Plaguelands' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=12 AND value1=1130 AND value2=0 AND value3=0 AND value4=0 AND flags=1);
SET @t4na := (SELECT condition_entry FROM conditions WHERE type=12 AND value1=1130 AND value2=0 AND value3=0 AND value4=0 AND flags=1 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59404,-1,@t4a,@t4nh,0,0,0,'Renown T4: Alliance may enter Stratholme' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@t4a AND value2=@t4nh AND value3=0 AND value4=0 AND flags=0);
SET @t4oka := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@t4a AND value2=@t4nh AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59405,-1,@t4h,@t4na,0,0,0,'Renown T4: Horde may enter Stratholme' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@t4h AND value2=@t4na AND value3=0 AND value4=0 AND flags=0);
SET @t4okh := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@t4h AND value2=@t4na AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59406,-2,@t4oka,@t4okh,0,0,0,'Renown T4: may enter Stratholme (Darkness Falls)' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-2 AND value1=@t4oka AND value2=@t4okh AND value3=0 AND value4=0 AND flags=0);
SET @t4ok := (SELECT condition_entry FROM conditions WHERE type=-2 AND value1=@t4oka AND value2=@t4okh AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
UPDATE areatrigger_teleport SET condition_id=@t4ok, status_failed_text='Darkness Falls: the enemy holds the Plaguelands, and Stratholme is sealed to you. Win the Plaguelands Front to open it.' WHERE target_map=329;
SELECT 't4_keep_site_cleared', COUNT(*) FROM game_event_creature WHERE event=-1132;

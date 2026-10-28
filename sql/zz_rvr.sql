-- ============================================================
-- The Barrens Front: tier 1 RvR lake for the Renown module (Crossroads vs Northwatch Hold)
-- Banners, objective guards and siege commanders are spawned by server-side game events 1100-1111,
-- which the Renown module starts and stops. Re-runnable.
-- ============================================================
DELETE FROM game_event_creature WHERE event BETWEEN 1100 AND 1111 OR guid BETWEEN 9100000 AND 9100199;
DELETE FROM game_event_gameobject WHERE event BETWEEN 1100 AND 1111 OR guid BETWEEN 5400000 AND 5400099;
DELETE FROM game_event WHERE entry BETWEEN 1100 AND 1111;
DELETE FROM creature WHERE guid BETWEEN 9100000 AND 9100199;
DELETE FROM gameobject WHERE guid BETWEEN 5400000 AND 5400099;
DELETE FROM creature_template WHERE Entry BETWEEN 190810 AND 190813;
DELETE FROM gameobject_template WHERE entry BETWEEN 190800 AND 190802;

-- Server-side events (schedule_type 0): only the module starts them
INSERT INTO game_event (entry,schedule_type,occurence,length,holiday,linkedTo,description) VALUES
(1100,0,525600,1,0,0,'Barrens Front: Kolkar Watch neutral'),
(1101,0,525600,1,0,0,'Barrens Front: Kolkar Watch Alliance'),
(1102,0,525600,1,0,0,'Barrens Front: Kolkar Watch Horde'),
(1103,0,525600,1,0,0,'Barrens Front: Stagnant Oasis neutral'),
(1104,0,525600,1,0,0,'Barrens Front: Stagnant Oasis Alliance'),
(1105,0,525600,1,0,0,'Barrens Front: Stagnant Oasis Horde'),
(1106,0,525600,1,0,0,'Barrens Front: Raptor Grounds neutral'),
(1107,0,525600,1,0,0,'Barrens Front: Raptor Grounds Alliance'),
(1108,0,525600,1,0,0,'Barrens Front: Raptor Grounds Horde'),
(1110,0,525600,1,0,0,'Barrens Front: siege on Northwatch (Alliance commander)'),
(1111,0,525600,1,0,0,'Barrens Front: siege on the Crossroads (Horde commander)');

-- Banners (look only, no interaction): neutral, Alliance, Horde
INSERT INTO gameobject_template (entry,type,displayId,name,faction,flags,size) VALUES
(190800,5,6211,'Barrens Front Banner',0,16,1.6),(190801,5,5651,'Alliance Banner',0,16,1.6),(190802,5,5652,'Horde Banner',0,16,1.6);

-- Defenders and field commanders (level 20 defenders, level 23 elite commanders)
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=3385;
UPDATE tmp_ct SET Entry=190810, Name='Theramore Vanguard', SubName='Barrens Front', MinLevel=20, MaxLevel=20, `Rank`=0, MinLevelHealth=700, MaxLevelHealth=700, MinMeleeDmg=30, MaxMeleeDmg=40, Armor=850, NpcFlags=0, GossipMenuId=0, AIName='', ScriptName='', LootId=0, PickpocketLootId=0, SkinningLootId=0, MinLootGold=0, MaxLootGold=0, KillCredit1=0, KillCredit2=0, MovementType=0, Civilian=0, VendorTemplateId=0, TrainerTemplateId=0, TrainerType=0, ExperienceMultiplier=0;
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=3501;
UPDATE tmp_ct SET Entry=190811, Name='Crossroads Vanguard', SubName='Barrens Front', MinLevel=20, MaxLevel=20, `Rank`=0, MinLevelHealth=700, MaxLevelHealth=700, MinMeleeDmg=30, MaxMeleeDmg=40, Armor=850, NpcFlags=0, GossipMenuId=0, AIName='', ScriptName='', LootId=0, PickpocketLootId=0, SkinningLootId=0, MinLootGold=0, MaxLootGold=0, KillCredit1=0, KillCredit2=0, MovementType=0, Civilian=0, VendorTemplateId=0, TrainerTemplateId=0, TrainerType=0, ExperienceMultiplier=0;
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=3385;
UPDATE tmp_ct SET Entry=190812, Name='Northwatch Field Commander', SubName='Barrens Front', MinLevel=23, MaxLevel=23, `Rank`=1, MinLevelHealth=6000, MaxLevelHealth=6000, MinMeleeDmg=70, MaxMeleeDmg=95, Armor=1150, NpcFlags=0, GossipMenuId=0, AIName='', ScriptName='', LootId=0, PickpocketLootId=0, SkinningLootId=0, MinLootGold=0, MaxLootGold=0, KillCredit1=0, KillCredit2=0, MovementType=0, Civilian=0, VendorTemplateId=0, TrainerTemplateId=0, TrainerType=0, ExperienceMultiplier=0;
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=3501;
UPDATE tmp_ct SET Entry=190813, Name='Crossroads Warlord', SubName='Barrens Front', MinLevel=23, MaxLevel=23, `Rank`=1, MinLevelHealth=6000, MaxLevelHealth=6000, MinMeleeDmg=70, MaxMeleeDmg=95, Armor=1150, NpcFlags=0, GossipMenuId=0, AIName='', ScriptName='', LootId=0, PickpocketLootId=0, SkinningLootId=0, MinLootGold=0, MaxLootGold=0, KillCredit1=0, KillCredit2=0, MovementType=0, Civilian=0, VendorTemplateId=0, TrainerTemplateId=0, TrainerType=0, ExperienceMultiplier=0;
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;

-- Clear wildlife within 45 yards of the objectives and command posts (no vendors, quest givers or event spawns)
DROP TEMPORARY TABLE IF EXISTS tmp_clear;
CREATE TEMPORARY TABLE tmp_clear (guid INT UNSIGNED PRIMARY KEY);
INSERT IGNORE INTO tmp_clear SELECT c.guid FROM creature c LEFT JOIN creature_template t ON t.Entry=c.id WHERE c.map=1 AND ((POW(c.position_x-(-849.0),2)+POW(c.position_y-(-2858.0),2)<2025) OR (POW(c.position_x-(-1255.0),2)+POW(c.position_y-(-3150.0),2)<2025) OR (POW(c.position_x-(-1790.0),2)+POW(c.position_y-(-3280.0),2)<2025) OR (POW(c.position_x-(-680.0),2)+POW(c.position_y-(-2740.0),2)<2025) OR (POW(c.position_x-(-1965.0),2)+POW(c.position_y-(-3395.0),2)<2025)) AND c.guid NOT BETWEEN 9100000 AND 9100199 AND COALESCE(t.NpcFlags,0)=0 AND c.guid NOT IN (SELECT guid FROM game_event_creature);
DELETE FROM creature_addon WHERE guid IN (SELECT guid FROM tmp_clear);
DELETE FROM creature_movement WHERE Id IN (SELECT guid FROM tmp_clear);
DELETE FROM creature_linking WHERE guid IN (SELECT guid FROM tmp_clear);
DELETE FROM creature_linking WHERE master_guid IN (SELECT guid FROM tmp_clear);
DELETE FROM creature_spawn_data WHERE Guid IN (SELECT guid FROM tmp_clear);
DELETE FROM creature_spawn_entry WHERE guid IN (SELECT guid FROM tmp_clear);
DELETE FROM creature_battleground WHERE guid IN (SELECT guid FROM tmp_clear);
DELETE FROM pool_creature WHERE guid IN (SELECT guid FROM tmp_clear);
DELETE FROM creature_conditional_spawn WHERE Guid IN (SELECT guid FROM tmp_clear);
DELETE FROM creature WHERE guid IN (SELECT guid FROM tmp_clear);
DROP TEMPORARY TABLE IF EXISTS tmp_clear;

-- Banners: one per state at each objective
INSERT INTO gameobject (guid,id,map,spawnMask,position_x,position_y,position_z,orientation,rotation0,rotation1,rotation2,rotation3,spawntimesecsmin,spawntimesecsmax) VALUES
(5400000,190800,1,1,-849.000,-2858.000,91.900,0.0,0,0,0.000000,1.000000,0,0),
(5400001,190801,1,1,-849.000,-2858.000,91.900,0.0,0,0,0.000000,1.000000,0,0),
(5400002,190802,1,1,-849.000,-2858.000,91.900,0.0,0,0,0.000000,1.000000,0,0),
(5400003,190800,1,1,-1255.000,-3150.000,91.717,0.0,0,0,0.000000,1.000000,0,0),
(5400004,190801,1,1,-1255.000,-3150.000,91.717,0.0,0,0,0.000000,1.000000,0,0),
(5400005,190802,1,1,-1255.000,-3150.000,91.717,0.0,0,0,0.000000,1.000000,0,0),
(5400006,190800,1,1,-1790.000,-3280.000,93.117,0.0,0,0,0.000000,1.000000,0,0),
(5400007,190801,1,1,-1790.000,-3280.000,93.117,0.0,0,0,0.000000,1.000000,0,0),
(5400008,190802,1,1,-1790.000,-3280.000,93.117,0.0,0,0,0.000000,1.000000,0,0);
INSERT INTO game_event_gameobject (guid,event) VALUES (5400000,1100),(5400001,1101),(5400002,1102),(5400003,1103),(5400004,1104),(5400005,1105),(5400006,1106),(5400007,1107),(5400008,1108);

-- Guards for the owner of each objective, and the commanders with their escorts
INSERT INTO creature (guid,id,map,spawnMask,position_x,position_y,position_z,orientation,spawntimesecsmin,spawntimesecsmax,spawndist,MovementType) VALUES
(9100000,190810,1,1,-840.000,-2858.000,91.767,6.2832,120,120,0,0),
(9100001,190810,1,1,-853.500,-2850.206,92.845,8.3776,120,120,0,0),
(9100002,190810,1,1,-853.500,-2865.794,91.773,4.1888,120,120,0,0),
(9100003,190811,1,1,-840.710,-2854.495,91.767,6.6832,120,120,0,0),
(9100004,190811,1,1,-856.180,-2852.573,92.940,8.7776,120,120,0,0),
(9100005,190811,1,1,-850.110,-2866.931,91.768,4.5888,120,120,0,0),
(9100006,190810,1,1,-1246.000,-3150.000,91.793,6.2832,120,120,0,0),
(9100007,190810,1,1,-1264.000,-3150.000,94.378,3.1416,120,120,0,0),
(9100008,190811,1,1,-1246.710,-3146.495,91.783,6.6832,120,120,0,0),
(9100009,190811,1,1,-1263.290,-3153.505,94.459,3.5416,120,120,0,0),
(9100010,190810,1,1,-1781.000,-3280.000,93.400,6.2832,120,120,0,0),
(9100011,190810,1,1,-1794.500,-3272.206,91.887,8.3776,120,120,0,0),
(9100012,190810,1,1,-1794.500,-3287.794,92.893,4.1888,120,120,0,0),
(9100013,190811,1,1,-1781.710,-3276.495,92.955,6.6832,120,120,0,0),
(9100014,190811,1,1,-1797.180,-3274.573,92.115,8.7776,120,120,0,0),
(9100015,190811,1,1,-1791.110,-3288.931,93.095,4.5888,120,120,0,0),
(9100016,190812,1,1,-1965.000,-3395.000,56.365,0,3600,3600,0,0),
(9100017,190810,1,1,-1960.756,-3390.759,57.030,7.0682,3600,3600,0,0),
(9100018,190810,1,1,-1969.241,-3390.756,56.172,8.6390,3600,3600,0,0),
(9100019,190810,1,1,-1969.244,-3399.241,56.043,3.9266,3600,3600,0,0),
(9100020,190810,1,1,-1960.759,-3399.244,56.816,5.4974,3600,3600,0,0),
(9100021,190813,1,1,-680.000,-2740.000,92.540,0,3600,3600,0,0),
(9100022,190811,1,1,-675.756,-2735.759,92.139,7.0682,3600,3600,0,0),
(9100023,190811,1,1,-684.241,-2735.756,92.121,8.6390,3600,3600,0,0),
(9100024,190811,1,1,-684.244,-2744.241,93.381,3.9266,3600,3600,0,0),
(9100025,190811,1,1,-675.759,-2744.244,93.212,5.4974,3600,3600,0,0);
INSERT INTO game_event_creature (guid,event) VALUES (9100000,1101),(9100001,1101),(9100002,1101),(9100003,1102),(9100004,1102),(9100005,1102),(9100006,1104),(9100007,1104),(9100008,1105),(9100009,1105),(9100010,1107),(9100011,1107),(9100012,1107),(9100013,1108),(9100014,1108),(9100015,1108),(9100016,1110),(9100017,1110),(9100018,1110),(9100019,1110),(9100020,1110),(9100021,1111),(9100022,1111),(9100023,1111),(9100024,1111),(9100025,1111);

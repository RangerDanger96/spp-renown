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

-- ============================================================
-- Barrens Front war boards: 8 rotating daily quests (3 a day) and a weekly quest per faction
-- Rotation events 1120-1127 (started by the Renown module), conditions 59120-59127, quests 90101-90119,
-- credit markers 190820-190829, board 190803. Daily = QuestFlags 0x1000 (core patch).
-- ============================================================
DELETE FROM game_event WHERE entry BETWEEN 1120 AND 1127;
DELETE FROM conditions WHERE condition_entry BETWEEN 59120 AND 59127;
DELETE FROM creature_template WHERE Entry BETWEEN 190820 AND 190829;
DELETE FROM gameobject_template WHERE entry=190803;
DELETE FROM gameobject WHERE guid BETWEEN 5400100 AND 5400109;
DELETE FROM quest_template WHERE entry BETWEEN 90101 AND 90119;
DELETE FROM gameobject_questrelation WHERE quest BETWEEN 90101 AND 90119;
DELETE FROM gameobject_involvedrelation WHERE quest BETWEEN 90101 AND 90119;
INSERT INTO game_event (entry,schedule_type,occurence,length,holiday,linkedTo,description) VALUES
(1120,0,525600,1,0,0,'Barrens Front war board: daily order 1'),
(1121,0,525600,1,0,0,'Barrens Front war board: daily order 2'),
(1122,0,525600,1,0,0,'Barrens Front war board: daily order 3'),
(1123,0,525600,1,0,0,'Barrens Front war board: daily order 4'),
(1124,0,525600,1,0,0,'Barrens Front war board: daily order 5'),
(1125,0,525600,1,0,0,'Barrens Front war board: daily order 6'),
(1126,0,525600,1,0,0,'Barrens Front war board: daily order 7'),
(1127,0,525600,1,0,0,'Barrens Front war board: daily order 8');
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) VALUES
(59120,12,1120,0,0,0,0,'Renown: war board daily order 1 is posted'),
(59121,12,1121,0,0,0,0,'Renown: war board daily order 2 is posted'),
(59122,12,1122,0,0,0,0,'Renown: war board daily order 3 is posted'),
(59123,12,1123,0,0,0,0,'Renown: war board daily order 4 is posted'),
(59124,12,1124,0,0,0,0,'Renown: war board daily order 5 is posted'),
(59125,12,1125,0,0,0,0,'Renown: war board daily order 6 is posted'),
(59126,12,1126,0,0,0,0,'Renown: war board daily order 7 is posted'),
(59127,12,1127,0,0,0,0,'Renown: war board daily order 8 is posted');

-- Credit markers (never spawned; the Renown module credits them to the quests)
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190810;
UPDATE tmp_ct SET Entry=190820, Name='Objective captured', SubName='Barrens Front';
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190810;
UPDATE tmp_ct SET Entry=190821, Name='Objective defended', SubName='Barrens Front';
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190810;
UPDATE tmp_ct SET Entry=190822, Name='Enemy soldier defeated', SubName='Barrens Front';
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190810;
UPDATE tmp_ct SET Entry=190823, Name='Healing assist', SubName='Barrens Front';
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190810;
UPDATE tmp_ct SET Entry=190824, Name='Killing spree ended', SubName='Barrens Front';
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190810;
UPDATE tmp_ct SET Entry=190825, Name='Kolkar Watch scouted', SubName='Barrens Front';
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190810;
UPDATE tmp_ct SET Entry=190826, Name='Stagnant Oasis scouted', SubName='Barrens Front';
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190810;
UPDATE tmp_ct SET Entry=190827, Name='Raptor Grounds scouted', SubName='Barrens Front';
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190810;
UPDATE tmp_ct SET Entry=190828, Name='Enemy defeated at the Oasis', SubName='Barrens Front';
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190810;
UPDATE tmp_ct SET Entry=190829, Name='Barrens Front won', SubName='Barrens Front';
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;

-- War Board (clone of the Wanted Board quest giver)
DROP TEMPORARY TABLE IF EXISTS tmp_gt;
CREATE TEMPORARY TABLE tmp_gt SELECT * FROM gameobject_template WHERE entry=2713;
UPDATE tmp_gt SET entry=190803, name='Barrens Front War Board', faction=0, size=1.2;
INSERT INTO gameobject_template SELECT * FROM tmp_gt;
DROP TEMPORARY TABLE IF EXISTS tmp_gt;
INSERT INTO gameobject (guid,id,map,spawnMask,position_x,position_y,position_z,orientation,rotation0,rotation1,rotation2,rotation3,spawntimesecsmin,spawntimesecsmax) VALUES
(5400100,190803,1,1,-462.000,-2617.000,98.615,5.4578,0,0,0.401073,-0.916046,120,120),
(5400101,190803,1,1,-2086.000,-3628.000,61.850,4.1457,0,0,0.876606,-0.481209,120,120);

INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90101,2,17,1,255,10,41,178,59120,4104,1,'Seize the Front','The front is a line on a map until somebody plants a banner on it, $N. Take Kolkar Watch, the Stagnant Oasis or the Raptor Grounds for the Horde.$B$BThe war board''s orders change daily.','Capture an objective on the Barrens Front.','A banner planted is a promise kept. Well done.','Report back when it is done, $N.','','Objective captured','','','',190820,0,0,0,1,0,0,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90111,2,17,1,255,10,41,77,59120,4104,1,'Seize the Front','Theramore does not hold ground by wishing for it, $N. Take an objective on the front: the Raptor Grounds, the Stagnant Oasis or Kolkar Watch.$B$BThe war board''s orders change daily.','Capture an objective on the Barrens Front.','A banner planted is a promise kept. Well done.','Report back when it is done, $N.','','Objective captured','','','',190820,0,0,0,1,0,0,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90102,2,17,1,255,10,41,178,59121,4104,1,'Hold the Line','Taking ground is easy. Keeping it is what wins wars. Stand guard at an objective we hold and cut down any Alliance dog who tries to take it.$B$BThe war board''s orders change daily.','Defeat 5 enemies near an objective your side holds.','The line held. That is all I ask.','Report back when it is done, $N.','','Objective defended','','','',190821,0,0,0,5,0,0,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90112,2,17,1,255,10,41,77,59121,4104,1,'Hold the Line','Every banner we raise draws the Horde like flies. Stand watch at an objective we hold and drive them off.$B$BThe war board''s orders change daily.','Defeat 5 enemies near an objective your side holds.','The line held. That is all I ask.','Report back when it is done, $N.','','Objective defended','','','',190821,0,0,0,5,0,0,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90103,2,17,1,255,10,41,178,59122,4104,1,'Blood and Thunder','The Alliance has marched an army into our Barrens. Remind them why orcs are feared. Ten of them, $N, on the front.$B$BThe war board''s orders change daily.','Defeat 10 enemy players on the Barrens Front.','Lok''tar! The front is quieter for it.','Report back when it is done, $N.','','Enemy soldier defeated','','','',190822,0,0,0,10,0,0,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90113,2,17,1,255,10,41,77,59122,4104,1,'For Theramore!','The Horde has been raiding our caravans from the Crossroads for too long. Meet them on the front and bring down ten of their soldiers.$B$BThe war board''s orders change daily.','Defeat 10 enemy players on the Barrens Front.','Lok''tar! The front is quieter for it.','Report back when it is done, $N.','','Enemy soldier defeated','','','',190822,0,0,0,10,0,0,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90104,2,17,1,255,10,41,178,59123,4104,1,'Field Medic','Warriors win battles, but healers win wars. Keep our fighters standing while they cut down the enemy.$B$BThe war board''s orders change daily.','Earn 10 healing assists on the Barrens Front.','Many owe you their lives today, though few of them will say it.','Report back when it is done, $N.','','Healing assist','','','',190823,0,0,0,10,0,0,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90114,2,17,1,255,10,41,77,59123,4104,1,'Field Medic','Our soldiers are brave, but brave soldiers bleed. Keep them on their feet while they fight.$B$BThe war board''s orders change daily.','Earn 10 healing assists on the Barrens Front.','Many owe you their lives today, though few of them will say it.','Report back when it is done, $N.','','Healing assist','','','',190823,0,0,0,10,0,0,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90105,2,17,1,255,10,41,178,59124,4104,1,'Bounty Hunter','Some Alliance hero is always strutting about the front with blood on his blade. Find one on a killing spree and end it.$B$BThe war board''s orders change daily.','End an enemy''s killing spree on the Barrens Front.','The braggart is silenced. Good.','Report back when it is done, $N.','','Killing spree ended','','','',190824,0,0,0,1,0,0,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90115,2,17,1,255,10,41,77,59124,4104,1,'Break Their Spirit','There is always one of them on a rampage, howling over a pile of our dead. Find a Horde soldier on a killing spree and put an end to it.$B$BThe war board''s orders change daily.','End an enemy''s killing spree on the Barrens Front.','The braggart is silenced. Good.','Report back when it is done, $N.','','Killing spree ended','','','',190824,0,0,0,1,0,0,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90106,2,17,1,255,10,41,178,59125,4104,1,'Scout the Front','I need fresh eyes on the whole front. Ride past Kolkar Watch, the Stagnant Oasis and the Raptor Grounds and tell me what you see.$B$BThe war board''s orders change daily.','Visit Kolkar Watch, the Stagnant Oasis and the Raptor Grounds.','Good. Now I know where to send the others.','Report back when it is done, $N.','','Kolkar Watch scouted','Stagnant Oasis scouted','Raptor Grounds scouted','',190825,190826,190827,0,1,1,1,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90116,2,17,1,255,10,41,77,59125,4104,1,'Scout the Front','Our maps are a day old and a day is a long time in war. Scout Kolkar Watch, the Stagnant Oasis and the Raptor Grounds.$B$BThe war board''s orders change daily.','Visit Kolkar Watch, the Stagnant Oasis and the Raptor Grounds.','Good. Now I know where to send the others.','Report back when it is done, $N.','','Kolkar Watch scouted','Stagnant Oasis scouted','Raptor Grounds scouted','',190825,190826,190827,0,1,1,1,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90107,2,17,1,255,10,41,178,59126,4104,1,'Thin the Vanguard','Theramore has sent its Vanguard to guard the objectives they hold. Kill five of them.$B$BThe war board''s orders change daily.','Slay 5 Theramore Vanguards.','Their Vanguard will think twice before standing guard.','Report back when it is done, $N.','','','','','',190810,0,0,0,5,0,0,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90117,2,17,1,255,10,41,77,59126,4104,1,'Break the Vanguard','The Warsong have posted their Vanguard at every objective they hold. Kill five of them.$B$BThe war board''s orders change daily.','Slay 5 Crossroads Vanguards.','Their Vanguard will think twice before standing guard.','Report back when it is done, $N.','','','','','',190811,0,0,0,5,0,0,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90108,2,17,1,255,10,41,178,59127,4104,1,'Blood in the Oasis','Whoever holds the Stagnant Oasis holds the Barrens. Make its waters run red. Five kills at the Oasis.$B$BThe war board''s orders change daily.','Defeat 5 enemies at the Stagnant Oasis.','The Oasis remembers who fought for it.','Report back when it is done, $N.','','Enemy defeated at the Oasis','','','',190828,0,0,0,5,0,0,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90118,2,17,1,255,10,41,77,59127,4104,1,'Waters of War','The Stagnant Oasis is the heart of the front. Fight there and bring down five of the enemy.$B$BThe war board''s orders change daily.','Defeat 5 enemies at the Stagnant Oasis.','The Oasis remembers who fought for it.','Report back when it is done, $N.','','Enemy defeated at the Oasis','','','',190828,0,0,0,5,0,0,0,2500,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90109,2,17,1,255,10,41,178,0,32776,1,'Victory on the Barrens Front','Hold the whole front, break their siege line and kill their field commander. Do that, $N, and the Barrens belong to the Horde for a time.$B$BThese orders are posted every week.','Help your side win the Barrens Front.','A victory worth singing about. Take this, you have earned it.','Report back when it is done, $N.','','Barrens Front won','','','',190829,0,0,0,1,0,0,0,5000,0);
INSERT INTO quest_template (entry,Method,ZoneOrSort,MinLevel,MaxLevel,QuestLevel,Type,RequiredRaces,RequiredCondition,QuestFlags,SpecialFlags,Title,Details,Objectives,OfferRewardText,RequestItemsText,EndText,ObjectiveText1,ObjectiveText2,ObjectiveText3,ObjectiveText4,ReqCreatureOrGOId1,ReqCreatureOrGOId2,ReqCreatureOrGOId3,ReqCreatureOrGOId4,ReqCreatureOrGOCount1,ReqCreatureOrGOCount2,ReqCreatureOrGOCount3,ReqCreatureOrGOCount4,RewOrReqMoney,RewMoneyMaxLevel) VALUES (90119,2,17,1,255,10,41,77,0,32776,1,'Victory on the Barrens Front','Take the whole front, open the siege and bring down the Crossroads Warlord. Win the Barrens Front for the Alliance.$B$BThese orders are posted every week.','Help your side win the Barrens Front.','A victory worth singing about. Take this, you have earned it.','Report back when it is done, $N.','','Barrens Front won','','','',190829,0,0,0,1,0,0,0,5000,0);
INSERT INTO gameobject_questrelation (id,quest) VALUES (190803,90101),(190803,90102),(190803,90103),(190803,90104),(190803,90105),(190803,90106),(190803,90107),(190803,90108),(190803,90109),(190803,90111),(190803,90112),(190803,90113),(190803,90114),(190803,90115),(190803,90116),(190803,90117),(190803,90118),(190803,90119);
INSERT INTO gameobject_involvedrelation (id,quest) VALUES (190803,90101),(190803,90102),(190803,90103),(190803,90104),(190803,90105),(190803,90106),(190803,90107),(190803,90108),(190803,90109),(190803,90111),(190803,90112),(190803,90113),(190803,90114),(190803,90115),(190803,90116),(190803,90117),(190803,90118),(190803,90119);

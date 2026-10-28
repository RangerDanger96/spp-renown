-- ============================================================
-- Custom: Battleground Hub at every starting area
-- Battlemasters (WSG/AB/AV) + Battleground Quartermaster
-- Quartermaster: free weapon-skill training + class kits (gear + 15g)
-- Re-runnable: deletes its own rows first. IDs 190100-190107,
-- items 190500-190517, menu/text/scripts 59000-59009, conditions 59001-59009
-- ============================================================
DELETE FROM creature WHERE id IN (190100,190101,190102,190103,190104,190105,190106,190107);
DELETE FROM creature_template WHERE Entry IN (190100,190101,190102,190103,190104,190105,190106,190107);
DELETE FROM battlemaster_entry WHERE entry IN (190100,190101,190102,190103,190104,190105,190106,190107);
DELETE FROM npc_trainer WHERE entry IN (190100,190101);
DELETE FROM item_template WHERE entry BETWEEN 190500 AND 190517;
DELETE FROM item_loot_template WHERE entry BETWEEN 190500 AND 190517;
DELETE FROM gossip_menu WHERE entry=59000;
DELETE FROM gossip_menu_option WHERE menu_id=59000;
DELETE FROM npc_text WHERE ID=59000;
DELETE FROM dbscripts_on_gossip WHERE id BETWEEN 59001 AND 59009;

-- Quartermasters (cloned from Highlord Boosterian, neutral)
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190011;
UPDATE tmp_ct SET Entry=190100, Name='Captain Brightshield', SubName='Battleground Quartermaster', DisplayId1=12918, NpcFlags=17, TrainerType=2, TrainerClass=0, TrainerRace=0, GossipMenuId=59000, MinLevel=60, MaxLevel=60, Faction=35;
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=190011;
UPDATE tmp_ct SET Entry=190101, Name='Warmaster Grakk', SubName='Battleground Quartermaster', DisplayId1=12678, NpcFlags=17, TrainerType=2, TrainerClass=0, TrainerRace=0, GossipMenuId=59000, MinLevel=60, MaxLevel=60, Faction=35;
INSERT INTO creature_template SELECT * FROM tmp_ct;

-- Battlemasters (clones of the real ones, so they keep their battleground menus)
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=14981;
UPDATE tmp_ct SET Entry=190102;
INSERT INTO creature_template SELECT * FROM tmp_ct;
INSERT INTO battlemaster_entry (entry,bg_template) VALUES (190102,2);
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=15008;
UPDATE tmp_ct SET Entry=190103;
INSERT INTO creature_template SELECT * FROM tmp_ct;
INSERT INTO battlemaster_entry (entry,bg_template) VALUES (190103,3);
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=7410;
UPDATE tmp_ct SET Entry=190104;
INSERT INTO creature_template SELECT * FROM tmp_ct;
INSERT INTO battlemaster_entry (entry,bg_template) VALUES (190104,1);
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=3890;
UPDATE tmp_ct SET Entry=190105;
INSERT INTO creature_template SELECT * FROM tmp_ct;
INSERT INTO battlemaster_entry (entry,bg_template) VALUES (190105,2);
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=15006;
UPDATE tmp_ct SET Entry=190106;
INSERT INTO creature_template SELECT * FROM tmp_ct;
INSERT INTO battlemaster_entry (entry,bg_template) VALUES (190106,3);
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=14942;
UPDATE tmp_ct SET Entry=190107;
INSERT INTO creature_template SELECT * FROM tmp_ct;
INSERT INTO battlemaster_entry (entry,bg_template) VALUES (190107,1);
DROP TEMPORARY TABLE IF EXISTS tmp_ct;

-- Free weapon-skill training (every weapon master's list, 0 cost)
INSERT INTO npc_trainer (entry,spell,spellcost,reqskill,reqskillvalue,reqlevel)
 SELECT q.e, t.spell, 0, 0, 0, 1 FROM (SELECT DISTINCT spell FROM npc_trainer WHERE entry IN (2704,11865,11866,11867,11868,11869,11870,13084)) t
 CROSS JOIN (SELECT 190100 AS e UNION SELECT 190101) q;

-- Class conditions (type 14 = player race/class mask); reuse existing rows if present
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 5310101,14,0,1,0,0,0,'Player ClassMask: 1' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=14 AND value1=0 AND value2=1 AND value3=0 AND value4=0 AND flags=0) AND NOT EXISTS (SELECT 1 FROM conditions WHERE condition_entry=5310101);
SET @bgc1 := (SELECT condition_entry FROM conditions WHERE type=14 AND value1=0 AND value2=1 AND value3=0 AND value4=0 AND flags=0 LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 5310102,14,0,2,0,0,0,'Player ClassMask: 2' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=14 AND value1=0 AND value2=2 AND value3=0 AND value4=0 AND flags=0) AND NOT EXISTS (SELECT 1 FROM conditions WHERE condition_entry=5310102);
SET @bgc2 := (SELECT condition_entry FROM conditions WHERE type=14 AND value1=0 AND value2=2 AND value3=0 AND value4=0 AND flags=0 LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 5310103,14,0,4,0,0,0,'Player ClassMask: 4' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=14 AND value1=0 AND value2=4 AND value3=0 AND value4=0 AND flags=0) AND NOT EXISTS (SELECT 1 FROM conditions WHERE condition_entry=5310103);
SET @bgc3 := (SELECT condition_entry FROM conditions WHERE type=14 AND value1=0 AND value2=4 AND value3=0 AND value4=0 AND flags=0 LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 5310104,14,0,8,0,0,0,'Player ClassMask: 8' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=14 AND value1=0 AND value2=8 AND value3=0 AND value4=0 AND flags=0) AND NOT EXISTS (SELECT 1 FROM conditions WHERE condition_entry=5310104);
SET @bgc4 := (SELECT condition_entry FROM conditions WHERE type=14 AND value1=0 AND value2=8 AND value3=0 AND value4=0 AND flags=0 LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 5310105,14,0,16,0,0,0,'Player ClassMask: 16' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=14 AND value1=0 AND value2=16 AND value3=0 AND value4=0 AND flags=0) AND NOT EXISTS (SELECT 1 FROM conditions WHERE condition_entry=5310105);
SET @bgc5 := (SELECT condition_entry FROM conditions WHERE type=14 AND value1=0 AND value2=16 AND value3=0 AND value4=0 AND flags=0 LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 5310106,14,0,64,0,0,0,'Player ClassMask: 64' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=14 AND value1=0 AND value2=64 AND value3=0 AND value4=0 AND flags=0) AND NOT EXISTS (SELECT 1 FROM conditions WHERE condition_entry=5310106);
SET @bgc6 := (SELECT condition_entry FROM conditions WHERE type=14 AND value1=0 AND value2=64 AND value3=0 AND value4=0 AND flags=0 LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 5310107,14,0,128,0,0,0,'Player ClassMask: 128' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=14 AND value1=0 AND value2=128 AND value3=0 AND value4=0 AND flags=0) AND NOT EXISTS (SELECT 1 FROM conditions WHERE condition_entry=5310107);
SET @bgc7 := (SELECT condition_entry FROM conditions WHERE type=14 AND value1=0 AND value2=128 AND value3=0 AND value4=0 AND flags=0 LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 5310108,14,0,256,0,0,0,'Player ClassMask: 256' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=14 AND value1=0 AND value2=256 AND value3=0 AND value4=0 AND flags=0) AND NOT EXISTS (SELECT 1 FROM conditions WHERE condition_entry=5310108);
SET @bgc8 := (SELECT condition_entry FROM conditions WHERE type=14 AND value1=0 AND value2=256 AND value3=0 AND value4=0 AND flags=0 LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 5310109,14,0,1024,0,0,0,'Player ClassMask: 1024' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=14 AND value1=0 AND value2=1024 AND value3=0 AND value4=0 AND flags=0) AND NOT EXISTS (SELECT 1 FROM conditions WHERE condition_entry=5310109);
SET @bgc9 := (SELECT condition_entry FROM conditions WHERE type=14 AND value1=0 AND value2=1024 AND value3=0 AND value4=0 AND flags=0 LIMIT 1);

-- Gossip
INSERT INTO npc_text (ID,text0_0,text0_1,lang0,prob0) VALUES (59000,'Glory is earned on the battlefield, $C.$B$BEvery foe you defeat and every flag and banner you claim earns you Renown. Earn enough and the Quartermaster''s stores are yours to choose from.$B$BI can also train you in any weapon for free, and the battlemasters beside me will send you to Warsong Gulch, Arathi Basin or Alterac Valley. When you are ready for open war, the Barrens Front awaits.','',0,1);
INSERT INTO gossip_menu (entry,text_id,script_id,condition_id) VALUES (59000,59000,0,0);
INSERT INTO gossip_menu_option (menu_id,id,option_icon,option_text,option_broadcast_text,option_id,npc_option_npcflag,action_menu_id,action_poi_id,action_script_id,box_coded,box_money,box_text,box_broadcast_text,condition_id) VALUES
(59000,0,3,'Train me in weapon skills.',0,5,16,0,0,0,0,0,'',0,0),
(59000,1,1,'Give me my Warrior battleground kit.',0,1,1,-1,0,59001,0,0,'',0,@bgc1),
(59000,2,1,'Give me my Paladin battleground kit.',0,1,1,-1,0,59002,0,0,'',0,@bgc2),
(59000,3,1,'Give me my Hunter battleground kit.',0,1,1,-1,0,59003,0,0,'',0,@bgc3),
(59000,4,1,'Give me my Rogue battleground kit.',0,1,1,-1,0,59004,0,0,'',0,@bgc4),
(59000,5,1,'Give me my Priest battleground kit.',0,1,1,-1,0,59005,0,0,'',0,@bgc5),
(59000,6,1,'Give me my Shaman battleground kit.',0,1,1,-1,0,59006,0,0,'',0,@bgc6),
(59000,7,1,'Give me my Mage battleground kit.',0,1,1,-1,0,59007,0,0,'',0,@bgc7),
(59000,8,1,'Give me my Warlock battleground kit.',0,1,1,-1,0,59008,0,0,'',0,@bgc8),
(59000,9,1,'Give me my Druid battleground kit.',0,1,1,-1,0,59009,0,0,'',0,@bgc9);

-- Kits: lootable sacks, two per class (armor / arms and accessories)
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190500, name='Battleground Kit: Warrior Armor', Quality=3, AllowableClass=1, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190501, name='Battleground Kit: Warrior Arms & Accessories', Quality=3, AllowableClass=1, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=150000, maxMoneyLoot=150000;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190502, name='Battleground Kit: Paladin Armor', Quality=3, AllowableClass=2, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190503, name='Battleground Kit: Paladin Arms & Accessories', Quality=3, AllowableClass=2, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=150000, maxMoneyLoot=150000;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190504, name='Battleground Kit: Hunter Armor', Quality=3, AllowableClass=4, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190505, name='Battleground Kit: Hunter Arms & Accessories', Quality=3, AllowableClass=4, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=150000, maxMoneyLoot=150000;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190506, name='Battleground Kit: Rogue Armor', Quality=3, AllowableClass=8, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190507, name='Battleground Kit: Rogue Arms & Accessories', Quality=3, AllowableClass=8, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=150000, maxMoneyLoot=150000;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190508, name='Battleground Kit: Priest Armor', Quality=3, AllowableClass=16, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190509, name='Battleground Kit: Priest Arms & Accessories', Quality=3, AllowableClass=16, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=150000, maxMoneyLoot=150000;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190510, name='Battleground Kit: Shaman Armor', Quality=3, AllowableClass=64, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190511, name='Battleground Kit: Shaman Arms & Accessories', Quality=3, AllowableClass=64, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=150000, maxMoneyLoot=150000;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190512, name='Battleground Kit: Mage Armor', Quality=3, AllowableClass=128, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190513, name='Battleground Kit: Mage Arms & Accessories', Quality=3, AllowableClass=128, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=150000, maxMoneyLoot=150000;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190514, name='Battleground Kit: Warlock Armor', Quality=3, AllowableClass=256, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190515, name='Battleground Kit: Warlock Arms & Accessories', Quality=3, AllowableClass=256, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=150000, maxMoneyLoot=150000;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190516, name='Battleground Kit: Druid Armor', Quality=3, AllowableClass=1024, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190517, name='Battleground Kit: Druid Arms & Accessories', Quality=3, AllowableClass=1024, BuyPrice=0, SellPrice=0, bonding=1, maxcount=0, description='Right-click to open.', minMoneyLoot=150000, maxMoneyLoot=150000;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
INSERT INTO item_loot_template (entry,item,ChanceOrQuestChance,groupid,mincountOrRef,maxcount,condition_id,comments) VALUES
(190500,14730,100,0,1,1,0,'BG Hub kit'),
(190500,6460,100,0,1,1,0,'BG Hub kit'),
(190500,6087,100,0,1,1,0,'BG Hub kit'),
(190500,12982,100,0,1,1,0,'BG Hub kit'),
(190500,15459,100,0,1,1,0,'BG Hub kit'),
(190500,16978,100,0,1,1,0,'BG Hub kit'),
(190501,2059,100,0,1,1,0,'BG Hub kit'),
(190501,20442,100,0,1,1,0,'BG Hub kit'),
(190501,6414,100,0,1,1,0,'BG Hub kit'),
(190501,20429,100,0,1,1,0,'BG Hub kit'),
(190501,7230,100,0,1,1,0,'BG Hub kit'),
(190501,20437,100,0,1,1,0,'BG Hub kit'),
(190501,2515,100,0,200,200,0,'BG Hub kit arrows'),
(190502,14730,100,0,1,1,0,'BG Hub kit'),
(190502,6460,100,0,1,1,0,'BG Hub kit'),
(190502,6087,100,0,1,1,0,'BG Hub kit'),
(190502,12982,100,0,1,1,0,'BG Hub kit'),
(190502,15459,100,0,1,1,0,'BG Hub kit'),
(190502,16978,100,0,1,1,0,'BG Hub kit'),
(190503,20427,100,0,1,1,0,'BG Hub kit'),
(190503,20442,100,0,1,1,0,'BG Hub kit'),
(190503,6414,100,0,1,1,0,'BG Hub kit'),
(190503,20426,100,0,1,1,0,'BG Hub kit'),
(190503,7230,100,0,1,1,0,'BG Hub kit'),
(190504,2041,100,0,1,1,0,'BG Hub kit'),
(190504,5355,100,0,1,1,0,'BG Hub kit'),
(190504,10410,100,0,1,1,0,'BG Hub kit'),
(190504,16977,100,0,1,1,0,'BG Hub kit'),
(190504,15462,100,0,1,1,0,'BG Hub kit'),
(190504,5299,100,0,1,1,0,'BG Hub kit'),
(190505,2059,100,0,1,1,0,'BG Hub kit'),
(190505,20442,100,0,1,1,0,'BG Hub kit'),
(190505,6414,100,0,1,1,0,'BG Hub kit'),
(190505,20426,100,0,1,1,0,'BG Hub kit'),
(190505,20425,100,0,1,1,0,'BG Hub kit'),
(190505,20437,100,0,1,1,0,'BG Hub kit'),
(190505,2515,100,0,200,200,0,'BG Hub kit arrows'),
(190506,2041,100,0,1,1,0,'BG Hub kit'),
(190506,5355,100,0,1,1,0,'BG Hub kit'),
(190506,10410,100,0,1,1,0,'BG Hub kit'),
(190506,16977,100,0,1,1,0,'BG Hub kit'),
(190506,15462,100,0,1,1,0,'BG Hub kit'),
(190506,14572,100,0,1,1,0,'BG Hub kit'),
(190507,2059,100,0,1,1,0,'BG Hub kit'),
(190507,20442,100,0,1,1,0,'BG Hub kit'),
(190507,6414,100,0,1,1,0,'BG Hub kit'),
(190507,20429,100,0,1,1,0,'BG Hub kit'),
(190507,6504,100,0,1,1,0,'BG Hub kit'),
(190507,1935,100,0,1,1,0,'BG Hub kit'),
(190507,20437,100,0,1,1,0,'BG Hub kit'),
(190507,2515,100,0,200,200,0,'BG Hub kit arrows'),
(190508,2913,100,0,1,1,0,'BG Hub kit'),
(190508,1486,100,0,1,1,0,'BG Hub kit'),
(190508,16975,100,0,1,1,0,'BG Hub kit'),
(190508,12987,100,0,1,1,0,'BG Hub kit'),
(190508,15461,100,0,1,1,0,'BG Hub kit'),
(190508,1974,100,0,1,1,0,'BG Hub kit'),
(190508,12977,100,0,1,1,0,'BG Hub kit'),
(190509,20427,100,0,1,1,0,'BG Hub kit'),
(190509,20442,100,0,1,1,0,'BG Hub kit'),
(190509,6332,100,0,1,1,0,'BG Hub kit'),
(190509,1156,100,0,1,1,0,'BG Hub kit'),
(190509,6505,100,0,1,1,0,'BG Hub kit'),
(190509,7001,100,0,1,1,0,'BG Hub kit'),
(190510,10399,100,0,1,1,0,'BG Hub kit'),
(190510,16987,100,0,1,1,0,'BG Hub kit'),
(190510,10410,100,0,1,1,0,'BG Hub kit'),
(190510,16977,100,0,1,1,0,'BG Hub kit'),
(190510,14569,100,0,1,1,0,'BG Hub kit'),
(190510,14572,100,0,1,1,0,'BG Hub kit'),
(190511,20427,100,0,1,1,0,'BG Hub kit'),
(190511,20442,100,0,1,1,0,'BG Hub kit'),
(190511,6414,100,0,1,1,0,'BG Hub kit'),
(190511,20429,100,0,1,1,0,'BG Hub kit'),
(190511,890,100,0,1,1,0,'BG Hub kit'),
(190512,2913,100,0,1,1,0,'BG Hub kit'),
(190512,1486,100,0,1,1,0,'BG Hub kit'),
(190512,16975,100,0,1,1,0,'BG Hub kit'),
(190512,12987,100,0,1,1,0,'BG Hub kit'),
(190512,6095,100,0,1,1,0,'BG Hub kit'),
(190512,1974,100,0,1,1,0,'BG Hub kit'),
(190512,12977,100,0,1,1,0,'BG Hub kit'),
(190513,20427,100,0,1,1,0,'BG Hub kit'),
(190513,20442,100,0,1,1,0,'BG Hub kit'),
(190513,1156,100,0,1,1,0,'BG Hub kit'),
(190513,6414,100,0,1,1,0,'BG Hub kit'),
(190513,6505,100,0,1,1,0,'BG Hub kit'),
(190513,7001,100,0,1,1,0,'BG Hub kit'),
(190514,10657,100,0,1,1,0,'BG Hub kit'),
(190514,1486,100,0,1,1,0,'BG Hub kit'),
(190514,16975,100,0,1,1,0,'BG Hub kit'),
(190514,12987,100,0,1,1,0,'BG Hub kit'),
(190514,6095,100,0,1,1,0,'BG Hub kit'),
(190514,1974,100,0,1,1,0,'BG Hub kit'),
(190514,12977,100,0,1,1,0,'BG Hub kit'),
(190515,20427,100,0,1,1,0,'BG Hub kit'),
(190515,20442,100,0,1,1,0,'BG Hub kit'),
(190515,6414,100,0,1,1,0,'BG Hub kit'),
(190515,1156,100,0,1,1,0,'BG Hub kit'),
(190515,6505,100,0,1,1,0,'BG Hub kit'),
(190515,7001,100,0,1,1,0,'BG Hub kit'),
(190516,10399,100,0,1,1,0,'BG Hub kit'),
(190516,16987,100,0,1,1,0,'BG Hub kit'),
(190516,10410,100,0,1,1,0,'BG Hub kit'),
(190516,16977,100,0,1,1,0,'BG Hub kit'),
(190516,15462,100,0,1,1,0,'BG Hub kit'),
(190516,14572,100,0,1,1,0,'BG Hub kit'),
(190517,2059,100,0,1,1,0,'BG Hub kit'),
(190517,20442,100,0,1,1,0,'BG Hub kit'),
(190517,6414,100,0,1,1,0,'BG Hub kit'),
(190517,20429,100,0,1,1,0,'BG Hub kit'),
(190517,6505,100,0,1,1,0,'BG Hub kit');
INSERT INTO dbscripts_on_gossip (id,delay,priority,command,datalong,datalong2,datalong3,comments) VALUES
(59001,0,0,17,190500,1,0,'BG Hub: give Warrior Armor kit'),
(59001,0,1,17,190501,1,0,'BG Hub: give Warrior Arms & Accessories kit'),
(59002,0,0,17,190502,1,0,'BG Hub: give Paladin Armor kit'),
(59002,0,1,17,190503,1,0,'BG Hub: give Paladin Arms & Accessories kit'),
(59003,0,0,17,190504,1,0,'BG Hub: give Hunter Armor kit'),
(59003,0,1,17,190505,1,0,'BG Hub: give Hunter Arms & Accessories kit'),
(59004,0,0,17,190506,1,0,'BG Hub: give Rogue Armor kit'),
(59004,0,1,17,190507,1,0,'BG Hub: give Rogue Arms & Accessories kit'),
(59005,0,0,17,190508,1,0,'BG Hub: give Priest Armor kit'),
(59005,0,1,17,190509,1,0,'BG Hub: give Priest Arms & Accessories kit'),
(59006,0,0,17,190510,1,0,'BG Hub: give Shaman Armor kit'),
(59006,0,1,17,190511,1,0,'BG Hub: give Shaman Arms & Accessories kit'),
(59007,0,0,17,190512,1,0,'BG Hub: give Mage Armor kit'),
(59007,0,1,17,190513,1,0,'BG Hub: give Mage Arms & Accessories kit'),
(59008,0,0,17,190514,1,0,'BG Hub: give Warlock Armor kit'),
(59008,0,1,17,190515,1,0,'BG Hub: give Warlock Arms & Accessories kit'),
(59009,0,0,17,190516,1,0,'BG Hub: give Druid Armor kit'),
(59009,0,1,17,190517,1,0,'BG Hub: give Druid Arms & Accessories kit');

-- Faster queues: battlegrounds start with fewer players; bots keep joining until full
UPDATE battleground_template SET MinPlayersPerTeam=2 WHERE id=2; -- Warsong Gulch (default 5)
UPDATE battleground_template SET MinPlayersPerTeam=3 WHERE id=3; -- Arathi Basin (default 8)
UPDATE battleground_template SET MinPlayersPerTeam=5 WHERE id=1; -- Alterac Valley (default 20)

-- Battlegrounds open at level 1 (needs the patched mangosd with the 1-9 bracket)
UPDATE battleground_template SET MinLvl=1 WHERE id IN (2,3); -- Warsong Gulch (default 10), Arathi Basin (default 20)
-- Battlemasters: drop the level 10/20 requirement on the 'go to the battleground' option and greeting
DROP TEMPORARY TABLE IF EXISTS tmp_bm;
CREATE TEMPORARY TABLE tmp_bm SELECT DISTINCT menu_id FROM gossip_menu_option WHERE option_id=12 AND condition_id IN (107,1011);
UPDATE gossip_menu_option SET condition_id=0 WHERE option_id=12 AND condition_id IN (107,1011);
DELETE g0 FROM gossip_menu g0 JOIN gossip_menu g1 ON g1.entry=g0.entry AND g1.condition_id IN (107,1011) WHERE g0.condition_id=0 AND g0.entry IN (SELECT menu_id FROM tmp_bm);
UPDATE gossip_menu SET condition_id=0 WHERE condition_id IN (107,1011) AND entry IN (SELECT menu_id FROM tmp_bm);
DROP TEMPORARY TABLE IF EXISTS tmp_bm;

-- Spawns: fixed guids 9100300-9100323 (auto-increment guids could collide with other custom spawn ranges)
DELETE FROM creature WHERE guid BETWEEN 9100300 AND 9100399;
INSERT INTO creature (guid,id,map,spawnMask,position_x,position_y,position_z,orientation,spawntimesecsmin,spawntimesecsmax,spawndist,MovementType) VALUES
(9100300,190100,0,1,-8943.882,-136.901,83.783,2.5133,25,25,0,0), -- Northshire Valley quartermaster
(9100301,190102,0,1,-8942.614,-134.052,83.78,2.9322,25,25,0,0), -- Northshire Valley wsg
(9100302,190103,0,1,-8942.614,-130.934,83.681,3.351,25,25,0,0), -- Northshire Valley ab
(9100303,190104,0,1,-8943.882,-128.085,83.566,3.7699,25,25,0,0), -- Northshire Valley av
(9100304,190100,0,1,-6234.753,326.007,382.729,2.4072,25,25,0,0), -- Coldridge Valley quartermaster
(9100305,190102,0,1,-6233.19,328.706,382.918,2.8261,25,25,0,0), -- Coldridge Valley wsg
(9100306,190103,0,1,-6232.86,331.807,383.134,3.245,25,25,0,0), -- Coldridge Valley ab
(9100307,190104,0,1,-6233.82,334.775,383.228,3.6639,25,25,0,0), -- Coldridge Valley av
(9100308,190100,1,1,10312.344,824.036,1326.467,1.7104,25,25,0,0), -- Shadowglen quartermaster
(9100309,190102,1,1,10315.274,825.103,1326.439,2.1293,25,25,0,0), -- Shadowglen wsg
(9100310,190103,1,1,10317.518,827.269,1326.428,2.5482,25,25,0,0), -- Shadowglen ab
(9100311,190104,1,1,10318.686,830.161,1326.426,2.9671,25,25,0,0), -- Shadowglen av
(9100312,190101,1,1,-612.45,-4256.078,39.006,2.5133,25,25,0,0), -- Valley of Trials quartermaster
(9100313,190105,1,1,-611.182,-4253.229,39.006,2.9322,25,25,0,0), -- Valley of Trials wsg
(9100314,190106,1,1,-611.182,-4250.111,39.006,3.351,25,25,0,0), -- Valley of Trials ab
(9100315,190107,1,1,-612.45,-4247.262,39.006,3.7699,25,25,0,0), -- Valley of Trials av
(9100316,190101,1,1,-2911.512,-262.388,53.212,2.5133,25,25,0,0), -- Camp Narache quartermaster
(9100317,190105,1,1,-2910.244,-259.539,53.024,2.9322,25,25,0,0), -- Camp Narache wsg
(9100318,190106,1,1,-2910.244,-256.421,52.991,3.351,25,25,0,0), -- Camp Narache ab
(9100319,190107,1,1,-2911.512,-253.572,52.991,3.7699,25,25,0,0), -- Camp Narache av
(9100320,190101,0,1,1669.082,1666.318,140.888,4.1095,25,25,0,0), -- Deathknell quartermaster
(9100321,190105,0,1,1666.202,1667.513,141.297,4.5284,25,25,0,0), -- Deathknell wsg
(9100322,190106,0,1,1663.084,1667.434,141.051,4.9473,25,25,0,0), -- Deathknell ab
(9100323,190107,0,1,1660.269,1666.093,141.016,5.3662,25,25,0,0); -- Deathknell av

-- All-class trainer: trains every class's trainer spells (each player only sees their own class), no class check
DELETE FROM creature_template WHERE Entry IN (190832,190833);
DELETE FROM npc_trainer WHERE entry IN (190832,190833);
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=913;
UPDATE tmp_ct SET Entry=190832, Name='Master-at-Arms Callen', SubName='All-Class Trainer', NpcFlags=16, GossipMenuId=0, TrainerType=2, TrainerClass=0, TrainerRace=0, TrainerTemplateId=0, TrainerSpell=0;
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=3153;
UPDATE tmp_ct SET Entry=190833, Name='Master-at-Arms Grukk', SubName='All-Class Trainer', NpcFlags=16, GossipMenuId=0, TrainerType=2, TrainerClass=0, TrainerRace=0, TrainerTemplateId=0, TrainerSpell=0;
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ts;
CREATE TEMPORARY TABLE tmp_ts SELECT spell, MIN(spellcost) spellcost, MIN(reqskill) reqskill, MIN(reqskillvalue) reqskillvalue, MIN(reqlevel) reqlevel, MIN(condition_id) condition_id FROM (SELECT n.spell,n.spellcost,n.reqskill,n.reqskillvalue,n.reqlevel,n.condition_id FROM npc_trainer n JOIN creature_template c ON c.Entry=n.entry WHERE c.TrainerType=0 AND c.TrainerClass>0 UNION ALL SELECT t.spell,t.spellcost,t.reqskill,t.reqskillvalue,t.reqlevel,t.condition_id FROM npc_trainer_template t JOIN creature_template c ON c.TrainerTemplateId=t.entry WHERE c.TrainerType=0 AND c.TrainerClass>0) x GROUP BY spell;
INSERT INTO npc_trainer (entry,spell,spellcost,reqskill,reqskillvalue,reqlevel,condition_id) SELECT 190832,spell,spellcost,reqskill,reqskillvalue,reqlevel,condition_id FROM tmp_ts;
INSERT INTO npc_trainer (entry,spell,spellcost,reqskill,reqskillvalue,reqlevel,condition_id) SELECT 190833,spell,spellcost,reqskill,reqskillvalue,reqlevel,condition_id FROM tmp_ts;
DROP TEMPORARY TABLE IF EXISTS tmp_ts;

-- War Boards and all-class trainers at the hubs (boards: gameobjects 5400110-5400115, trainers: creatures 9100330-9100335)
DELETE FROM gameobject WHERE guid BETWEEN 5400110 AND 5400119;
DELETE FROM creature WHERE guid BETWEEN 9100330 AND 9100339;
INSERT INTO gameobject (guid,id,map,spawnMask,position_x,position_y,position_z,orientation,rotation0,rotation1,rotation2,rotation3,spawntimesecsmin,spawntimesecsmax) VALUES
(5400110,190803,0,1,-8946.429,-139.115,83.685,2.0595,0,0,0.857167,0.515038,120,120), -- Northshire Valley
(5400111,190803,0,1,-6237.520,324.075,382.638,1.9535,0,0,0.828672,0.559734,120,120), -- Coldridge Valley
(5400112,190803,1,1,10308.982,824.330,1326.542,1.2566,0,0,0.587784,0.809018,120,120), -- Shadowglen
(5400113,190803,1,1,-614.997,-4258.292,39.006,2.0595,0,0,0.857167,0.515038,120,120), -- Valley of Trials
(5400114,190803,1,1,-2914.059,-264.602,53.585,2.0595,0,0,0.857167,0.515038,120,120), -- Camp Narache
(5400115,190803,0,1,1671.360,1663.829,139.843,3.6557,0,0,0.967137,-0.254256,120,120); -- Deathknell
INSERT INTO creature (guid,id,map,spawnMask,position_x,position_y,position_z,orientation,spawntimesecsmin,spawntimesecsmax,spawndist,MovementType) VALUES
(9100330,190832,0,1,-8946.429,-125.871,83.433,4.2237,25,25,0,0), -- Northshire Valley
(9100331,190832,0,1,-6236.118,337.245,383.167,4.1177,25,25,0,0), -- Coldridge Valley
(9100332,190832,1,1,10318.509,833.530,1326.426,3.4208,25,25,0,0), -- Shadowglen
(9100333,190833,1,1,-614.997,-4245.048,39.006,4.2237,25,25,0,0), -- Valley of Trials
(9100334,190833,1,1,-2914.059,-251.358,52.999,4.2237,25,25,0,0), -- Camp Narache
(9100335,190833,0,1,1658.120,1663.491,141.126,5.8200,25,25,0,0); -- Deathknell

-- ============================================================
-- Renown: insignia items + tiered reward stock at the Battleground Quartermasters
-- Requires the Renown server module (mangosd.exe built with BUILD_MODULE_RENOWN)
-- Re-runnable. Items 190520-190525. Runs after zz_bg_hub.sql (alphabetical order).
-- ============================================================
DELETE FROM item_template WHERE entry BETWEEN 190520 AND 190525;
DELETE FROM npc_vendor WHERE entry IN (190100,190101);
DELETE FROM gossip_menu_option WHERE menu_id=59000 AND id=10;

-- Insignias (given by the server module on reaching a renown rank)
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190520, name='Renown Insignia: Tier 1', class=15, subclass=0, displayid=4841, Quality=4, Flags=0, BuyPrice=0, SellPrice=0, bonding=1, maxcount=1, stackable=1, description='Renown Rank 5. Unlocks tier 1 rewards at the Battleground Quartermaster.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190521, name='Renown Insignia: Tier 2', class=15, subclass=0, displayid=4841, Quality=4, Flags=0, BuyPrice=0, SellPrice=0, bonding=1, maxcount=1, stackable=1, description='Renown Rank 10. Unlocks tier 2 rewards at the Battleground Quartermaster.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190522, name='Renown Insignia: Tier 3', class=15, subclass=0, displayid=4841, Quality=4, Flags=0, BuyPrice=0, SellPrice=0, bonding=1, maxcount=1, stackable=1, description='Renown Rank 15. Unlocks tier 3 rewards at the Battleground Quartermaster.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190523, name='Renown Insignia: Tier 4', class=15, subclass=0, displayid=4841, Quality=4, Flags=0, BuyPrice=0, SellPrice=0, bonding=1, maxcount=1, stackable=1, description='Renown Rank 20. Unlocks tier 4 rewards at the Battleground Quartermaster.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190524, name='Renown Insignia: Tier 5', class=15, subclass=0, displayid=4841, Quality=4, Flags=0, BuyPrice=0, SellPrice=0, bonding=1, maxcount=1, stackable=1, description='Renown Rank 25. Unlocks tier 5 rewards at the Battleground Quartermaster.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190525, name='Renown Insignia: Tier 6', class=15, subclass=0, displayid=4841, Quality=4, Flags=0, BuyPrice=0, SellPrice=0, bonding=1, maxcount=1, stackable=1, description='Renown Rank 30. Unlocks tier 6 rewards at the Battleground Quartermaster.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;

-- One condition per tier: player owns the insignia (bags or bank). IDs 59101-59106: the core reads vendor condition_id as 16-bit, so IDs must stay below 65536.
DELETE FROM conditions WHERE condition_entry BETWEEN 59101 AND 59106 OR condition_entry BETWEEN 5310111 AND 5310116 OR (type=23 AND value1 BETWEEN 190520 AND 190525);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) VALUES
(59101,23,190520,1,0,0,0,'Renown: owns Renown Insignia Tier 1'),
(59102,23,190521,1,0,0,0,'Renown: owns Renown Insignia Tier 2'),
(59103,23,190522,1,0,0,0,'Renown: owns Renown Insignia Tier 3'),
(59104,23,190523,1,0,0,0,'Renown: owns Renown Insignia Tier 4'),
(59105,23,190524,1,0,0,0,'Renown: owns Renown Insignia Tier 5'),
(59106,23,190525,1,0,0,0,'Renown: owns Renown Insignia Tier 6');

-- Quartermasters become vendors too
UPDATE creature_template SET NpcFlags = (NpcFlags & ~128) | 4 WHERE Entry IN (190100,190101); -- 4 = vendor in 1.12 (128 is innkeeper)
INSERT INTO gossip_menu_option (menu_id,id,option_icon,option_text,option_broadcast_text,option_id,npc_option_npcflag,action_menu_id,action_poi_id,action_script_id,box_coded,box_money,box_text,box_broadcast_text,condition_id) VALUES
(59000,10,1,'Show me the Renown rewards.',0,3,4,0,0,0,0,0,'',0,0);

-- Reward stock: the Warsong Gulch reward lists, unlocked by renown tier instead of reputation
INSERT INTO npc_vendor (entry,item,maxcount,incrtime,slot,condition_id,comments) VALUES
(190100,19506,0,0,0,59103,'Renown tier 3'),
(190100,20428,0,0,1,59101,'Renown tier 1'),
(190100,20431,0,0,2,59101,'Renown tier 1'),
(190100,20434,0,0,3,59101,'Renown tier 1'),
(190100,20438,0,0,4,59101,'Renown tier 1'),
(190100,20439,0,0,5,59101,'Renown tier 1'),
(190100,20440,0,0,6,59101,'Renown tier 1'),
(190100,20443,0,0,7,59101,'Renown tier 1'),
(190100,20444,0,0,8,59101,'Renown tier 1'),
(190100,21566,0,0,9,59101,'Renown tier 1'),
(190100,21568,0,0,10,59101,'Renown tier 1'),
(190100,19062,0,0,11,59102,'Renown tier 2'),
(190100,19068,0,0,12,59102,'Renown tier 2'),
(190100,19517,0,0,13,59102,'Renown tier 2'),
(190100,19525,0,0,14,59102,'Renown tier 2'),
(190100,19533,0,0,15,59102,'Renown tier 2'),
(190100,19541,0,0,16,59102,'Renown tier 2'),
(190100,19549,0,0,17,59102,'Renown tier 2'),
(190100,19557,0,0,18,59102,'Renown tier 2'),
(190100,19565,0,0,19,59102,'Renown tier 2'),
(190100,19573,0,0,20,59102,'Renown tier 2'),
(190100,17349,0,0,21,59103,'Renown tier 3'),
(190100,17352,0,0,22,59103,'Renown tier 3'),
(190100,19061,0,0,23,59103,'Renown tier 3'),
(190100,19067,0,0,24,59103,'Renown tier 3'),
(190100,19515,0,0,25,59103,'Renown tier 3'),
(190100,19524,0,0,26,59103,'Renown tier 3'),
(190100,19532,0,0,27,59103,'Renown tier 3'),
(190100,19540,0,0,28,59103,'Renown tier 3'),
(190100,19548,0,0,29,59103,'Renown tier 3'),
(190100,19556,0,0,30,59103,'Renown tier 3'),
(190100,19564,0,0,31,59103,'Renown tier 3'),
(190100,19572,0,0,32,59103,'Renown tier 3'),
(190100,19581,0,0,33,59104,'Renown tier 4'),
(190100,19584,0,0,34,59104,'Renown tier 4'),
(190100,19590,0,0,35,59104,'Renown tier 4'),
(190100,19597,0,0,36,59104,'Renown tier 4'),
(190100,21565,0,0,37,59104,'Renown tier 4'),
(190100,21567,0,0,38,59104,'Renown tier 4'),
(190100,17348,0,0,39,59104,'Renown tier 4'),
(190100,17351,0,0,40,59104,'Renown tier 4'),
(190100,19060,0,0,41,59104,'Renown tier 4'),
(190100,19066,0,0,42,59104,'Renown tier 4'),
(190100,19516,0,0,43,59104,'Renown tier 4'),
(190100,19523,0,0,44,59104,'Renown tier 4'),
(190100,19531,0,0,45,59104,'Renown tier 4'),
(190100,19539,0,0,46,59104,'Renown tier 4'),
(190100,19547,0,0,47,59104,'Renown tier 4'),
(190100,19555,0,0,48,59104,'Renown tier 4'),
(190100,19563,0,0,49,59104,'Renown tier 4'),
(190100,19571,0,0,50,59104,'Renown tier 4'),
(190100,19580,0,0,51,59105,'Renown tier 5'),
(190100,19583,0,0,52,59105,'Renown tier 5'),
(190100,19589,0,0,53,59105,'Renown tier 5'),
(190100,19596,0,0,54,59105,'Renown tier 5'),
(190100,19514,0,0,55,59105,'Renown tier 5'),
(190100,19522,0,0,56,59105,'Renown tier 5'),
(190100,19530,0,0,57,59105,'Renown tier 5'),
(190100,19538,0,0,58,59105,'Renown tier 5'),
(190100,19546,0,0,59,59105,'Renown tier 5'),
(190100,19554,0,0,60,59105,'Renown tier 5'),
(190100,19562,0,0,61,59105,'Renown tier 5'),
(190100,19570,0,0,62,59105,'Renown tier 5'),
(190100,19578,0,0,63,59106,'Renown tier 6'),
(190100,19582,0,0,64,59106,'Renown tier 6'),
(190100,19587,0,0,65,59106,'Renown tier 6'),
(190100,19595,0,0,66,59106,'Renown tier 6'),
(190100,22672,0,0,67,59106,'Renown tier 6'),
(190100,22748,0,0,68,59106,'Renown tier 6'),
(190100,22749,0,0,69,59106,'Renown tier 6'),
(190100,22750,0,0,70,59106,'Renown tier 6'),
(190100,22752,0,0,71,59106,'Renown tier 6'),
(190100,22753,0,0,72,59106,'Renown tier 6'),
(190101,19505,0,0,0,59103,'Renown tier 3'),
(190101,20425,0,0,1,59101,'Renown tier 1'),
(190101,20426,0,0,2,59101,'Renown tier 1'),
(190101,20427,0,0,3,59101,'Renown tier 1'),
(190101,20429,0,0,4,59101,'Renown tier 1'),
(190101,20430,0,0,5,59101,'Renown tier 1'),
(190101,20437,0,0,6,59101,'Renown tier 1'),
(190101,20441,0,0,7,59101,'Renown tier 1'),
(190101,20442,0,0,8,59101,'Renown tier 1'),
(190101,21566,0,0,9,59101,'Renown tier 1'),
(190101,21568,0,0,10,59101,'Renown tier 1'),
(190101,19062,0,0,11,59102,'Renown tier 2'),
(190101,19068,0,0,12,59102,'Renown tier 2'),
(190101,19513,0,0,13,59102,'Renown tier 2'),
(190101,19521,0,0,14,59102,'Renown tier 2'),
(190101,19529,0,0,15,59102,'Renown tier 2'),
(190101,19537,0,0,16,59102,'Renown tier 2'),
(190101,19545,0,0,17,59102,'Renown tier 2'),
(190101,19553,0,0,18,59102,'Renown tier 2'),
(190101,19561,0,0,19,59102,'Renown tier 2'),
(190101,19569,0,0,20,59102,'Renown tier 2'),
(190101,17349,0,0,21,59103,'Renown tier 3'),
(190101,17352,0,0,22,59103,'Renown tier 3'),
(190101,19061,0,0,23,59103,'Renown tier 3'),
(190101,19067,0,0,24,59103,'Renown tier 3'),
(190101,19512,0,0,25,59103,'Renown tier 3'),
(190101,19520,0,0,26,59103,'Renown tier 3'),
(190101,19528,0,0,27,59103,'Renown tier 3'),
(190101,19536,0,0,28,59103,'Renown tier 3'),
(190101,19544,0,0,29,59103,'Renown tier 3'),
(190101,19552,0,0,30,59103,'Renown tier 3'),
(190101,19560,0,0,31,59103,'Renown tier 3'),
(190101,19568,0,0,32,59103,'Renown tier 3'),
(190101,19581,0,0,33,59104,'Renown tier 4'),
(190101,19584,0,0,34,59104,'Renown tier 4'),
(190101,19590,0,0,35,59104,'Renown tier 4'),
(190101,19597,0,0,36,59104,'Renown tier 4'),
(190101,21565,0,0,37,59104,'Renown tier 4'),
(190101,21567,0,0,38,59104,'Renown tier 4'),
(190101,17348,0,0,39,59104,'Renown tier 4'),
(190101,17351,0,0,40,59104,'Renown tier 4'),
(190101,19060,0,0,41,59104,'Renown tier 4'),
(190101,19066,0,0,42,59104,'Renown tier 4'),
(190101,19511,0,0,43,59104,'Renown tier 4'),
(190101,19519,0,0,44,59104,'Renown tier 4'),
(190101,19527,0,0,45,59104,'Renown tier 4'),
(190101,19535,0,0,46,59104,'Renown tier 4'),
(190101,19543,0,0,47,59104,'Renown tier 4'),
(190101,19551,0,0,48,59104,'Renown tier 4'),
(190101,19559,0,0,49,59104,'Renown tier 4'),
(190101,19567,0,0,50,59104,'Renown tier 4'),
(190101,19580,0,0,51,59105,'Renown tier 5'),
(190101,19583,0,0,52,59105,'Renown tier 5'),
(190101,19589,0,0,53,59105,'Renown tier 5'),
(190101,19596,0,0,54,59105,'Renown tier 5'),
(190101,19510,0,0,55,59105,'Renown tier 5'),
(190101,19518,0,0,56,59105,'Renown tier 5'),
(190101,19526,0,0,57,59105,'Renown tier 5'),
(190101,19534,0,0,58,59105,'Renown tier 5'),
(190101,19542,0,0,59,59105,'Renown tier 5'),
(190101,19550,0,0,60,59105,'Renown tier 5'),
(190101,19558,0,0,61,59105,'Renown tier 5'),
(190101,19566,0,0,62,59105,'Renown tier 5'),
(190101,19578,0,0,63,59106,'Renown tier 6'),
(190101,19582,0,0,64,59106,'Renown tier 6'),
(190101,19587,0,0,65,59106,'Renown tier 6'),
(190101,19595,0,0,66,59106,'Renown tier 6'),
(190101,22651,0,0,67,59106,'Renown tier 6'),
(190101,22673,0,0,68,59106,'Renown tier 6'),
(190101,22676,0,0,69,59106,'Renown tier 6'),
(190101,22740,0,0,70,59106,'Renown tier 6'),
(190101,22741,0,0,71,59106,'Renown tier 6'),
(190101,22747,0,0,72,59106,'Renown tier 6');

-- Renown rewards are earned, not bought: no gold cost and no vendor sell value (stops a free-gold loop).
-- Items also sold by other vendors (e.g. Superior Healing/Mana Draught) keep their normal price.
UPDATE item_template i JOIN npc_vendor v ON v.item=i.entry AND v.entry IN (190100,190101) SET i.BuyPrice=0, i.SellPrice=0 WHERE NOT EXISTS (SELECT 1 FROM npc_vendor o WHERE o.item=i.entry AND o.entry NOT IN (190100,190101,14753,14754));

-- ============================================================
-- Renown: insignia items + tiered reward stock at the Battleground Quartermasters
-- Requires the Renown server module (mangosd.exe built with BUILD_MODULE_RENOWN)
-- Re-runnable. Items 190520-190528. Runs after zz_bg_hub.sql (alphabetical order).
-- ============================================================
DELETE FROM item_template WHERE entry BETWEEN 190520 AND 190528;
DELETE FROM npc_vendor WHERE entry IN (190100,190101,190108,190109,190110,190111);
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
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190526, name='Renown Insignia: Tier 7', class=15, subclass=0, displayid=4841, Quality=4, Flags=0, BuyPrice=0, SellPrice=0, bonding=1, maxcount=1, stackable=1, description='Renown Rank 33. Unlocks tier 7 rewards at the Battleground Quartermaster.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190527, name='Renown Insignia: Tier 8', class=15, subclass=0, displayid=4841, Quality=4, Flags=0, BuyPrice=0, SellPrice=0, bonding=1, maxcount=1, stackable=1, description='Renown Rank 36. Unlocks tier 8 rewards at the Battleground Quartermaster.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17962;
UPDATE tmp_it SET entry=190528, name='Renown Insignia: Tier 9', class=15, subclass=0, displayid=4841, Quality=4, Flags=0, BuyPrice=0, SellPrice=0, bonding=1, maxcount=1, stackable=1, description='Renown Rank 40. Unlocks tier 9 rewards at the Battleground Quartermaster.', minMoneyLoot=0, maxMoneyLoot=0;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;

-- One condition per tier: player owns the insignia (bags or bank). IDs 59101-59106: the core reads vendor condition_id as 16-bit, so IDs must stay below 65536.
DELETE FROM conditions WHERE condition_entry BETWEEN 59101 AND 59109 OR condition_entry BETWEEN 5310111 AND 5310116 OR (type=23 AND value1 BETWEEN 190520 AND 190528);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) VALUES
(59101,23,190520,1,0,0,0,'Renown: owns Renown Insignia Tier 1'),
(59102,23,190521,1,0,0,0,'Renown: owns Renown Insignia Tier 2'),
(59103,23,190522,1,0,0,0,'Renown: owns Renown Insignia Tier 3'),
(59104,23,190523,1,0,0,0,'Renown: owns Renown Insignia Tier 4'),
(59105,23,190524,1,0,0,0,'Renown: owns Renown Insignia Tier 5'),
(59106,23,190525,1,0,0,0,'Renown: owns Renown Insignia Tier 6'),
(59107,23,190526,1,0,0,0,'Renown: owns Renown Insignia Tier 7'),
(59108,23,190527,1,0,0,0,'Renown: owns Renown Insignia Tier 8'),
(59109,23,190528,1,0,0,0,'Renown: owns Renown Insignia Tier 9');
-- Level filters for the low-level sets (a vendor shows at most 128 items, so each player only sees gear for their level):
-- 59110 level <= 9 (Recruit's), 59111 level 10-19 (uses existing 107 'level >= 10' and 326 'level <= 19'), 59112 = 59111 AND tier 1 insignia (Skirmisher's)
DELETE FROM conditions WHERE condition_entry BETWEEN 59110 AND 59112 OR condition_entry BETWEEN 59150 AND 59399;
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) VALUES
(59110,15,9,2,0,0,0,'Renown: player level <= 9'),
(59111,-1,107,326,0,0,0,'Renown: player level 10-19'),
(59112,-1,59111,59101,0,0,0,'Renown: level 10-19 and Renown tier 1');

-- Quartermasters become vendors too
UPDATE creature_template SET NpcFlags = (NpcFlags & ~128) | 4 WHERE Entry IN (190100,190101); -- 4 = vendor in 1.12 (128 is innkeeper)
INSERT INTO gossip_menu_option (menu_id,id,option_icon,option_text,option_broadcast_text,option_id,npc_option_npcflag,action_menu_id,action_poi_id,action_script_id,box_coded,box_money,box_text,box_broadcast_text,condition_id) VALUES
(59000,10,1,'Show me the Renown rewards.',0,3,4,0,0,0,0,0,'',0,0);

-- Renown sets: Recruit's 1-9, Skirmisher's 10-19, Footman's 20-29, Lancer's 30-39, Veteran's 40-49, Vanguard's 50-59
DELETE FROM item_template WHERE entry BETWEEN 190600 AND 190799 OR entry BETWEEN 191000 AND 191399;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2578;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190600, name='Recruit''s Silk Robe', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4309;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190601, name='Recruit''s Silk Pants', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2721;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190700, name='Recruit''s Silk Cowl', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12998;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190701, name='Recruit''s Silk Mantle', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3308;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190602, name='Recruit''s Silk Gloves', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3307;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190603, name='Recruit''s Silk Slippers', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2283;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190604, name='Recruit''s Silk Sash', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3645;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190702, name='Recruit''s Silk Cuffs', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=2, stat_type2=7, stat_value2=1, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=821;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190605, name='Recruit''s Leather Jerkin', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4242;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190606, name='Recruit''s Leather Pants', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3392;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190703, name='Recruit''s Leather Cap', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4709;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190704, name='Recruit''s Leather Shoulderpads', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=3, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2312;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190607, name='Recruit''s Leather Gloves', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=3, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2309;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190608, name='Recruit''s Leather Boots', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=3, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2899;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190609, name='Recruit''s Leather Belt', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=3, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3205;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190705, name='Recruit''s Leather Bracers', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=821;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190610, name='Recruit''s Hide Vest', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4242;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190611, name='Recruit''s Hide Leggings', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3392;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190706, name='Recruit''s Hide Headband', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4709;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190707, name='Recruit''s Hide Spaulders', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2312;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190612, name='Recruit''s Hide Handwraps', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2309;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190613, name='Recruit''s Hide Boots', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2899;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190614, name='Recruit''s Hide Cord', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3205;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190708, name='Recruit''s Hide Wristwraps', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=2, stat_type2=7, stat_value2=1, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2273;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190615, name='Recruit''s Chain Hauberk', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2978;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190616, name='Recruit''s Chain Legguards', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6389;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190709, name='Recruit''s Chain Helm', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3231;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190710, name='Recruit''s Chain Pauldrons', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=3, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14703;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190617, name='Recruit''s Chain Gauntlets', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=3, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3302;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190618, name='Recruit''s Chain Sabatons', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=3, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=832;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190619, name='Recruit''s Chain Girdle', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=3, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14723;
UPDATE tmp_it SET armor=IF(ItemLevel>12, ROUND(armor*12/ItemLevel), armor), entry=190711, name='Recruit''s Chain Bracers', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1355;
UPDATE tmp_it SET armor=armor, entry=190620, name='Recruit''s Cloak of Fury', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1355;
UPDATE tmp_it SET armor=armor, entry=190621, name='Recruit''s Cloak of Swiftness', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1355;
UPDATE tmp_it SET armor=armor, entry=190622, name='Recruit''s Cloak of Insight', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8350;
UPDATE tmp_it SET armor=armor, entry=190623, name='Recruit''s Band of Fury', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8350;
UPDATE tmp_it SET armor=armor, entry=190624, name='Recruit''s Band of Swiftness', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8350;
UPDATE tmp_it SET armor=armor, entry=190625, name='Recruit''s Band of Insight', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20442;
UPDATE tmp_it SET armor=armor, entry=190712, name='Recruit''s Pendant of Fury', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20442;
UPDATE tmp_it SET armor=armor, entry=190713, name='Recruit''s Pendant of Swiftness', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20442;
UPDATE tmp_it SET armor=armor, entry=190714, name='Recruit''s Pendant of Insight', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4765;
UPDATE tmp_it SET armor=armor, entry=190626, name='Recruit''s Longsword', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=2, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3488;
UPDATE tmp_it SET armor=armor, entry=190627, name='Recruit''s Greataxe', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1287;
UPDATE tmp_it SET armor=armor, entry=190628, name='Recruit''s Dirk', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1394;
UPDATE tmp_it SET armor=armor, entry=190629, name='Recruit''s Scepter', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1933;
UPDATE tmp_it SET armor=armor, entry=190630, name='Recruit''s Battle Staff', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3036;
UPDATE tmp_it SET armor=armor, entry=190631, name='Recruit''s Recurve Bow', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=5071;
UPDATE tmp_it SET armor=armor, entry=190632, name='Recruit''s Wand', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=2, stat_type2=6, stat_value2=1, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3652;
UPDATE tmp_it SET armor=armor, entry=190633, name='Recruit''s Kite Shield', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=7, stat_value1=3, stat_type2=4, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1486;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190634, name='Skirmisher''s Silk Robe', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=23173;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190635, name='Skirmisher''s Silk Pants', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2721;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190715, name='Skirmisher''s Silk Cowl', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12998;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190716, name='Skirmisher''s Silk Mantle', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3066;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190636, name='Skirmisher''s Silk Gloves', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14374;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190637, name='Skirmisher''s Silk Slippers', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4708;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190638, name='Skirmisher''s Silk Sash', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3647;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190717, name='Skirmisher''s Silk Cuffs', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10399;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190639, name='Skirmisher''s Leather Jerkin', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10410;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190640, name='Skirmisher''s Leather Pants', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3392;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190718, name='Skirmisher''s Leather Cap', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=7, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4709;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190719, name='Skirmisher''s Leather Shoulderpads', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=7284;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190641, name='Skirmisher''s Leather Gloves', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1121;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190642, name='Skirmisher''s Leather Boots', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3429;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190643, name='Skirmisher''s Leather Belt', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3202;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190720, name='Skirmisher''s Leather Bracers', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10399;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190644, name='Skirmisher''s Hide Vest', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10410;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190645, name='Skirmisher''s Hide Leggings', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3392;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190721, name='Skirmisher''s Hide Headband', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4709;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190722, name='Skirmisher''s Hide Spaulders', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=7284;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190646, name='Skirmisher''s Hide Handwraps', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1121;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190647, name='Skirmisher''s Hide Boots', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3429;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190648, name='Skirmisher''s Hide Cord', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3202;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190723, name='Skirmisher''s Hide Wristwraps', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6642;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190649, name='Skirmisher''s Chain Hauberk', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4816;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190650, name='Skirmisher''s Chain Legguards', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6389;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190724, name='Skirmisher''s Chain Helm', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=7, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3231;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190725, name='Skirmisher''s Chain Pauldrons', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12994;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190651, name='Skirmisher''s Chain Gauntlets', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14742;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190652, name='Skirmisher''s Chain Sabatons', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6460;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190653, name='Skirmisher''s Chain Girdle', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2867;
UPDATE tmp_it SET armor=IF(ItemLevel>22, ROUND(armor*22/ItemLevel), armor), entry=190726, name='Skirmisher''s Chain Bracers', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2059;
UPDATE tmp_it SET armor=armor, entry=190654, name='Skirmisher''s Cloak of Fury', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2059;
UPDATE tmp_it SET armor=armor, entry=190655, name='Skirmisher''s Cloak of Swiftness', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2059;
UPDATE tmp_it SET armor=armor, entry=190656, name='Skirmisher''s Cloak of Insight', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=5, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4998;
UPDATE tmp_it SET armor=armor, entry=190657, name='Skirmisher''s Band of Fury', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4998;
UPDATE tmp_it SET armor=armor, entry=190658, name='Skirmisher''s Band of Swiftness', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4998;
UPDATE tmp_it SET armor=armor, entry=190659, name='Skirmisher''s Band of Insight', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=5, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20442;
UPDATE tmp_it SET armor=armor, entry=190727, name='Skirmisher''s Pendant of Fury', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20442;
UPDATE tmp_it SET armor=armor, entry=190728, name='Skirmisher''s Pendant of Swiftness', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20442;
UPDATE tmp_it SET armor=armor, entry=190729, name='Skirmisher''s Pendant of Insight', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=5, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1482;
UPDATE tmp_it SET armor=armor, entry=190660, name='Skirmisher''s Longsword', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1455;
UPDATE tmp_it SET armor=armor, entry=190661, name='Skirmisher''s Greataxe', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1935;
UPDATE tmp_it SET armor=armor, entry=190662, name='Skirmisher''s Dirk', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=5, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2256;
UPDATE tmp_it SET armor=armor, entry=190663, name='Skirmisher''s Scepter', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=890;
UPDATE tmp_it SET armor=armor, entry=190664, name='Skirmisher''s Battle Staff', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6469;
UPDATE tmp_it SET armor=armor, entry=190665, name='Skirmisher''s Recurve Bow', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=4, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=5198;
UPDATE tmp_it SET armor=armor, entry=190666, name='Skirmisher''s Wand', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=6, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12997;
UPDATE tmp_it SET armor=armor, entry=190667, name='Skirmisher''s Kite Shield', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=7, stat_value1=5, stat_type2=4, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=7728;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191000, name='Footman''s Silk Robe', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=7, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2277;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191001, name='Footman''s Silk Pants', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=7, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4323;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191002, name='Footman''s Silk Cowl', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4718;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191003, name='Footman''s Silk Mantle', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=7, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=9395;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191004, name='Footman''s Silk Gloves', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=7, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6406;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191005, name='Footman''s Silk Slippers', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=7, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14414;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191006, name='Footman''s Silk Sash', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=7, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14416;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191007, name='Footman''s Silk Cuffs', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=5782;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191008, name='Footman''s Leather Jerkin', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=11, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=5963;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191009, name='Footman''s Leather Pants', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=11, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3020;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191010, name='Footman''s Leather Cap', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=10, stat_type2=7, stat_value2=8, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4721;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191011, name='Footman''s Leather Shoulderpads', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=8, stat_type2=7, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6408;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191012, name='Footman''s Leather Gloves', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=8, stat_type2=7, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4055;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191013, name='Footman''s Leather Boots', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=8, stat_type2=7, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4258;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191014, name='Footman''s Leather Belt', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=8, stat_type2=7, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6410;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191015, name='Footman''s Leather Bracers', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=5782;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191016, name='Footman''s Hide Vest', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=6, stat_type3=6, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=5963;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191017, name='Footman''s Hide Leggings', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=6, stat_type3=6, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3020;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191018, name='Footman''s Hide Headband', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=8, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4721;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191019, name='Footman''s Hide Spaulders', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=7, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6408;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191020, name='Footman''s Hide Handwraps', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=7, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4055;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191021, name='Footman''s Hide Boots', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=7, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4258;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191022, name='Footman''s Hide Cord', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=7, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6410;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191023, name='Footman''s Hide Wristwraps', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=7688;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191024, name='Footman''s Chain Hauberk', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=11, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3843;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191025, name='Footman''s Chain Legguards', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=11, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3836;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191026, name='Footman''s Chain Helm', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=10, stat_type2=7, stat_value2=8, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3841;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191027, name='Footman''s Chain Pauldrons', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=9445;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191028, name='Footman''s Chain Gauntlets', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10332;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191029, name='Footman''s Chain Sabatons', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4717;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191030, name='Footman''s Chain Girdle', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14759;
UPDATE tmp_it SET armor=IF(ItemLevel>32, ROUND(armor*32/ItemLevel), armor), entry=191031, name='Footman''s Chain Bracers', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13108;
UPDATE tmp_it SET armor=armor, entry=191032, name='Footman''s Cloak of Fury', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=6, stat_type2=7, stat_value2=5, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13108;
UPDATE tmp_it SET armor=armor, entry=191033, name='Footman''s Cloak of Swiftness', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=6, stat_type2=7, stat_value2=5, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13108;
UPDATE tmp_it SET armor=armor, entry=191034, name='Footman''s Cloak of Insight', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=7, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=9447;
UPDATE tmp_it SET armor=armor, entry=191035, name='Footman''s Band of Fury', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=6, stat_type2=7, stat_value2=5, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=9447;
UPDATE tmp_it SET armor=armor, entry=191036, name='Footman''s Band of Swiftness', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=6, stat_type2=7, stat_value2=5, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=9447;
UPDATE tmp_it SET armor=armor, entry=191037, name='Footman''s Band of Insight', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=7, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=5180;
UPDATE tmp_it SET armor=armor, entry=191038, name='Footman''s Pendant of Fury', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=6, stat_type2=7, stat_value2=5, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=5180;
UPDATE tmp_it SET armor=armor, entry=191039, name='Footman''s Pendant of Swiftness', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=6, stat_type2=7, stat_value2=5, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=5180;
UPDATE tmp_it SET armor=armor, entry=191040, name='Footman''s Pendant of Insight', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=7, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=9446;
UPDATE tmp_it SET armor=armor, entry=191041, name='Footman''s Longsword', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=6, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6687;
UPDATE tmp_it SET armor=armor, entry=191042, name='Footman''s Greataxe', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=11, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=7682;
UPDATE tmp_it SET armor=armor, entry=191043, name='Footman''s Dirk', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=7, stat_type2=7, stat_value2=5, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2816;
UPDATE tmp_it SET armor=armor, entry=191044, name='Footman''s Scepter', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=19569;
UPDATE tmp_it SET armor=armor, entry=191045, name='Footman''s Battle Staff', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=7, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3037;
UPDATE tmp_it SET armor=armor, entry=191046, name='Footman''s Recurve Bow', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=5, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13063;
UPDATE tmp_it SET armor=armor, entry=191047, name='Footman''s Wand', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=5, stat_type2=6, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4477;
UPDATE tmp_it SET armor=armor, entry=191048, name='Footman''s Kite Shield', Quality=3, ItemLevel=32, RequiredLevel=20, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=7, stat_value1=7, stat_type2=4, stat_value2=5, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10762;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191100, name='Lancer''s Silk Robe', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=9, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10010;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191101, name='Lancer''s Silk Pants', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=9, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=7720;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191102, name='Lancer''s Silk Cowl', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=11, stat_type2=7, stat_value2=8, stat_type3=6, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4734;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191103, name='Lancer''s Silk Mantle', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=7, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10011;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191104, name='Lancer''s Silk Gloves', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=7, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13100;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191105, name='Lancer''s Silk Slippers', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=7, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20098;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191106, name='Lancer''s Silk Sash', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=7, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14429;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191107, name='Lancer''s Silk Cuffs', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14601;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191108, name='Lancer''s Leather Jerkin', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=15, stat_type2=7, stat_value2=12, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1718;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191109, name='Lancer''s Leather Pants', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=15, stat_type2=7, stat_value2=12, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8201;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191110, name='Lancer''s Leather Cap', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=13, stat_type2=7, stat_value2=11, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4737;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191111, name='Lancer''s Leather Shoulderpads', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=11, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4063;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191112, name='Lancer''s Leather Gloves', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=11, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20101;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191113, name='Lancer''s Leather Boots', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=11, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20104;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191114, name='Lancer''s Leather Belt', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=11, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14654;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191115, name='Lancer''s Leather Bracers', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14601;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191116, name='Lancer''s Hide Vest', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=8, stat_type3=6, stat_value3=7, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1718;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191117, name='Lancer''s Hide Leggings', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=8, stat_type3=6, stat_value3=7, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8201;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191118, name='Lancer''s Hide Headband', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=11, stat_type2=7, stat_value2=7, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4737;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191119, name='Lancer''s Hide Spaulders', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=6, stat_type3=6, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4063;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191120, name='Lancer''s Hide Handwraps', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=6, stat_type3=6, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20101;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191121, name='Lancer''s Hide Boots', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=6, stat_type3=6, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20104;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191122, name='Lancer''s Hide Cord', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=6, stat_type3=6, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14654;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191123, name='Lancer''s Hide Wristwraps', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1715;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191124, name='Lancer''s Chain Hauberk', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=15, stat_type2=7, stat_value2=12, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10330;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191125, name='Lancer''s Chain Legguards', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=15, stat_type2=7, stat_value2=12, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1624;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191126, name='Lancer''s Chain Helm', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=13, stat_type2=7, stat_value2=11, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=9430;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191127, name='Lancer''s Chain Pauldrons', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=11, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=7724;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191128, name='Lancer''s Chain Gauntlets', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=11, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20092;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191129, name='Lancer''s Chain Sabatons', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=11, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6425;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191130, name='Lancer''s Chain Girdle', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=11, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8205;
UPDATE tmp_it SET armor=IF(ItemLevel>42, ROUND(armor*42/ItemLevel), armor), entry=191131, name='Lancer''s Chain Bracers', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12254;
UPDATE tmp_it SET armor=armor, entry=191132, name='Lancer''s Cloak of Fury', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12254;
UPDATE tmp_it SET armor=armor, entry=191133, name='Lancer''s Cloak of Swiftness', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=8, stat_type2=7, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12254;
UPDATE tmp_it SET armor=armor, entry=191134, name='Lancer''s Cloak of Insight', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13095;
UPDATE tmp_it SET armor=armor, entry=191135, name='Lancer''s Band of Fury', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13095;
UPDATE tmp_it SET armor=armor, entry=191136, name='Lancer''s Band of Swiftness', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=8, stat_type2=7, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13095;
UPDATE tmp_it SET armor=armor, entry=191137, name='Lancer''s Band of Insight', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=7722;
UPDATE tmp_it SET armor=armor, entry=191138, name='Lancer''s Pendant of Fury', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=7722;
UPDATE tmp_it SET armor=armor, entry=191139, name='Lancer''s Pendant of Swiftness', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=8, stat_type2=7, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=7722;
UPDATE tmp_it SET armor=armor, entry=191140, name='Lancer''s Pendant of Insight', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=9401;
UPDATE tmp_it SET armor=armor, entry=191141, name='Lancer''s Longsword', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=8, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=9425;
UPDATE tmp_it SET armor=armor, entry=191142, name='Lancer''s Greataxe', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=15, stat_type2=7, stat_value2=12, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10761;
UPDATE tmp_it SET armor=armor, entry=191143, name='Lancer''s Dirk', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=10, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=7721;
UPDATE tmp_it SET armor=armor, entry=191144, name='Lancer''s Scepter', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=8, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=19568;
UPDATE tmp_it SET armor=armor, entry=191145, name='Lancer''s Battle Staff', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=9, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=19560;
UPDATE tmp_it SET armor=armor, entry=191146, name='Lancer''s Recurve Bow', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=7, stat_type2=7, stat_value2=5, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13064;
UPDATE tmp_it SET armor=armor, entry=191147, name='Lancer''s Wand', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=7, stat_type2=6, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=7726;
UPDATE tmp_it SET armor=armor, entry=191148, name='Lancer''s Kite Shield', Quality=3, ItemLevel=42, RequiredLevel=30, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=7, stat_value1=10, stat_type2=4, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14100;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191200, name='Veteran''s Silk Robe', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=15, stat_type2=7, stat_value2=12, stat_type3=6, stat_value3=7, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8251;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191201, name='Veteran''s Silk Pants', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=15, stat_type2=7, stat_value2=12, stat_type3=6, stat_value3=7, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17715;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191202, name='Veteran''s Silk Cowl', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=11, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14452;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191203, name='Veteran''s Silk Mantle', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=9, stat_type3=6, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=11634;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191204, name='Veteran''s Silk Gloves', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=9, stat_type3=6, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=18697;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191205, name='Veteran''s Silk Slippers', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=9, stat_type3=6, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=11662;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191206, name='Veteran''s Silk Sash', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=9, stat_type3=6, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12546;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191207, name='Veteran''s Silk Cuffs', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14664;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191208, name='Veteran''s Leather Jerkin', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=19, stat_type2=7, stat_value2=15, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10842;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191209, name='Veteran''s Leather Pants', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=19, stat_type2=7, stat_value2=15, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8261;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191210, name='Veteran''s Leather Cap', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=17, stat_type2=7, stat_value2=14, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=15061;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191211, name='Veteran''s Leather Shoulderpads', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=14, stat_type2=7, stat_value2=12, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=11665;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191212, name='Veteran''s Leather Gloves', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=14, stat_type2=7, stat_value2=12, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13111;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191213, name='Veteran''s Leather Boots', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=14, stat_type2=7, stat_value2=12, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=11686;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191214, name='Veteran''s Leather Belt', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=14, stat_type2=7, stat_value2=12, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13120;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191215, name='Veteran''s Leather Bracers', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=9, stat_type2=7, stat_value2=8, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14664;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191216, name='Veteran''s Hide Vest', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=15, stat_type2=7, stat_value2=10, stat_type3=6, stat_value3=9, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10842;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191217, name='Veteran''s Hide Leggings', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=15, stat_type2=7, stat_value2=10, stat_type3=6, stat_value3=9, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8261;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191218, name='Veteran''s Hide Headband', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=9, stat_type3=6, stat_value3=8, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=15061;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191219, name='Veteran''s Hide Spaulders', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=8, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=11665;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191220, name='Veteran''s Hide Handwraps', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=8, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13111;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191221, name='Veteran''s Hide Boots', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=8, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=11686;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191222, name='Veteran''s Hide Cord', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=8, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13120;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191223, name='Veteran''s Hide Wristwraps', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=8, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12624;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191224, name='Veteran''s Chain Hauberk', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=17, stat_type2=7, stat_value2=12, stat_type3=5, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=15046;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191225, name='Veteran''s Chain Legguards', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=17, stat_type2=7, stat_value2=12, stat_type3=5, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8270;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191226, name='Veteran''s Chain Helm', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=16, stat_type2=7, stat_value2=11, stat_type3=5, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8272;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191227, name='Veteran''s Chain Pauldrons', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=13, stat_type2=7, stat_value2=9, stat_type3=5, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8267;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191228, name='Veteran''s Chain Gauntlets', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=13, stat_type2=7, stat_value2=9, stat_type3=5, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10846;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191229, name='Veteran''s Chain Sabatons', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=13, stat_type2=7, stat_value2=9, stat_type3=5, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8268;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191230, name='Veteran''s Chain Girdle', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=13, stat_type2=7, stat_value2=9, stat_type3=5, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17714;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191231, name='Veteran''s Chain Bracers', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=5, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12624;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191232, name='Veteran''s Mail Vestment', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=15, stat_type2=7, stat_value2=10, stat_type3=6, stat_value3=9, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=15046;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191233, name='Veteran''s Mail Kilt', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=15, stat_type2=7, stat_value2=10, stat_type3=6, stat_value3=9, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8270;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191234, name='Veteran''s Mail Coif', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=9, stat_type3=6, stat_value3=8, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8272;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191235, name='Veteran''s Mail Epaulets', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=8, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8267;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191236, name='Veteran''s Mail Grips', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=8, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10846;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191237, name='Veteran''s Mail Greaves', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=8, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8268;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191238, name='Veteran''s Mail Waistband', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=8, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17714;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191239, name='Veteran''s Mail Bindings', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=8, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10845;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191240, name='Veteran''s Plate Breastplate', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=19, stat_type2=7, stat_value2=15, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17711;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191241, name='Veteran''s Plate Legplates', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=19, stat_type2=7, stat_value2=15, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8317;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191242, name='Veteran''s Plate Greathelm', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=17, stat_type2=7, stat_value2=14, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8319;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191243, name='Veteran''s Plate Spaulders', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=14, stat_type2=7, stat_value2=12, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8314;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191244, name='Veteran''s Plate Handguards', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=14, stat_type2=7, stat_value2=12, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14857;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191245, name='Veteran''s Plate Warboots', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=14, stat_type2=7, stat_value2=12, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14856;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191246, name='Veteran''s Plate Waistguard', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=14, stat_type2=7, stat_value2=12, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12425;
UPDATE tmp_it SET armor=IF(ItemLevel>52, ROUND(armor*52/ItemLevel), armor), entry=191247, name='Veteran''s Plate Vambraces', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=9, stat_type2=7, stat_value2=8, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10843;
UPDATE tmp_it SET armor=armor, entry=191248, name='Veteran''s Cloak of Fury', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=10, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10843;
UPDATE tmp_it SET armor=armor, entry=191249, name='Veteran''s Cloak of Swiftness', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=10, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10843;
UPDATE tmp_it SET armor=armor, entry=191250, name='Veteran''s Cloak of Insight', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=11, stat_type2=7, stat_value2=8, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=11824;
UPDATE tmp_it SET armor=armor, entry=191251, name='Veteran''s Band of Fury', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=10, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=11824;
UPDATE tmp_it SET armor=armor, entry=191252, name='Veteran''s Band of Swiftness', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=10, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=11824;
UPDATE tmp_it SET armor=armor, entry=191253, name='Veteran''s Band of Insight', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=11, stat_type2=7, stat_value2=8, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17707;
UPDATE tmp_it SET armor=armor, entry=191254, name='Veteran''s Pendant of Fury', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=10, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17707;
UPDATE tmp_it SET armor=armor, entry=191255, name='Veteran''s Pendant of Swiftness', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=10, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=17707;
UPDATE tmp_it SET armor=armor, entry=191256, name='Veteran''s Pendant of Insight', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=11, stat_type2=7, stat_value2=8, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12535;
UPDATE tmp_it SET armor=armor, entry=191257, name='Veteran''s Longsword', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=10, stat_type2=7, stat_value2=10, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12769;
UPDATE tmp_it SET armor=armor, entry=191258, name='Veteran''s Greataxe', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=19, stat_type2=7, stat_value2=15, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=11635;
UPDATE tmp_it SET armor=armor, entry=191259, name='Veteran''s Dirk', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=12, stat_type2=7, stat_value2=8, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1721;
UPDATE tmp_it SET armor=armor, entry=191260, name='Veteran''s Scepter', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=10, stat_type2=7, stat_value2=6, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1607;
UPDATE tmp_it SET armor=armor, entry=191261, name='Veteran''s Battle Staff', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=15, stat_type2=7, stat_value2=12, stat_type3=6, stat_value3=7, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=11628;
UPDATE tmp_it SET armor=armor, entry=191262, name='Veteran''s Recurve Bow', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=9, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=11748;
UPDATE tmp_it SET armor=armor, entry=191263, name='Veteran''s Wand', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=8, stat_type2=6, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1203;
UPDATE tmp_it SET armor=armor, entry=191264, name='Veteran''s Kite Shield', Quality=3, ItemLevel=52, RequiredLevel=40, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=7, stat_value1=12, stat_type2=4, stat_value2=8, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14456;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191300, name='Vanguard''s Silk Robe', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=19, stat_type2=7, stat_value2=15, stat_type3=6, stat_value3=8, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12965;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191301, name='Vanguard''s Silk Pants', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=19, stat_type2=7, stat_value2=15, stat_type3=6, stat_value3=8, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=16416;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191302, name='Vanguard''s Silk Cowl', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=17, stat_type2=7, stat_value2=13, stat_type3=6, stat_value3=8, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=19050;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191303, name='Vanguard''s Silk Mantle', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=11, stat_type3=6, stat_value3=7, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=16391;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191304, name='Vanguard''s Silk Gloves', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=11, stat_type3=6, stat_value3=7, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13369;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191305, name='Vanguard''s Silk Slippers', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=11, stat_type3=6, stat_value3=7, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20047;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191306, name='Vanguard''s Silk Sash', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=11, stat_type3=6, stat_value3=7, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=16486;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191307, name='Vanguard''s Silk Cuffs', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=7, stat_type3=6, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14680;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191308, name='Vanguard''s Leather Jerkin', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=23, stat_type2=7, stat_value2=19, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12963;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191309, name='Vanguard''s Leather Pants', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=23, stat_type2=7, stat_value2=19, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12587;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191310, name='Vanguard''s Leather Cap', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=21, stat_type2=7, stat_value2=17, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=19058;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191311, name='Vanguard''s Leather Shoulderpads', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=18, stat_type2=7, stat_value2=14, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=19049;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191312, name='Vanguard''s Leather Gloves', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=18, stat_type2=7, stat_value2=14, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=16392;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191313, name='Vanguard''s Leather Boots', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=18, stat_type2=7, stat_value2=14, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20045;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191314, name='Vanguard''s Leather Belt', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=18, stat_type2=7, stat_value2=14, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12966;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191315, name='Vanguard''s Leather Bracers', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=12, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14680;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191316, name='Vanguard''s Hide Vest', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=19, stat_type2=7, stat_value2=13, stat_type3=6, stat_value3=10, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12963;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191317, name='Vanguard''s Hide Leggings', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=19, stat_type2=7, stat_value2=13, stat_type3=6, stat_value3=10, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12587;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191318, name='Vanguard''s Hide Headband', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=17, stat_type2=7, stat_value2=11, stat_type3=6, stat_value3=10, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=19058;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191319, name='Vanguard''s Hide Spaulders', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=10, stat_type3=6, stat_value3=8, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=19049;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191320, name='Vanguard''s Hide Handwraps', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=10, stat_type3=6, stat_value3=8, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=16392;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191321, name='Vanguard''s Hide Boots', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=10, stat_type3=6, stat_value3=8, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=20045;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191322, name='Vanguard''s Hide Cord', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=10, stat_type3=6, stat_value3=8, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12966;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191323, name='Vanguard''s Hide Wristwraps', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=6, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14811;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191324, name='Vanguard''s Chain Hauberk', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=21, stat_type2=7, stat_value2=15, stat_type3=5, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12964;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191325, name='Vanguard''s Chain Legguards', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=21, stat_type2=7, stat_value2=15, stat_type3=5, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13359;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191326, name='Vanguard''s Chain Helm', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=19, stat_type2=7, stat_value2=13, stat_type3=5, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12588;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191327, name='Vanguard''s Chain Pauldrons', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=16, stat_type2=7, stat_value2=11, stat_type3=5, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13344;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191328, name='Vanguard''s Chain Gauntlets', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=16, stat_type2=7, stat_value2=11, stat_type3=5, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=19048;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191329, name='Vanguard''s Chain Sabatons', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=16, stat_type2=7, stat_value2=11, stat_type3=5, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=18104;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191330, name='Vanguard''s Chain Girdle', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=16, stat_type2=7, stat_value2=11, stat_type3=5, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=16532;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191331, name='Vanguard''s Chain Bracers', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=10, stat_type2=7, stat_value2=7, stat_type3=5, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14811;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191332, name='Vanguard''s Mail Vestment', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=19, stat_type2=7, stat_value2=13, stat_type3=6, stat_value3=10, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12964;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191333, name='Vanguard''s Mail Kilt', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=19, stat_type2=7, stat_value2=13, stat_type3=6, stat_value3=10, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13359;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191334, name='Vanguard''s Mail Coif', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=17, stat_type2=7, stat_value2=11, stat_type3=6, stat_value3=10, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12588;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191335, name='Vanguard''s Mail Epaulets', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=10, stat_type3=6, stat_value3=8, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13344;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191336, name='Vanguard''s Mail Grips', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=10, stat_type3=6, stat_value3=8, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=19048;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191337, name='Vanguard''s Mail Greaves', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=10, stat_type3=6, stat_value3=8, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=18104;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191338, name='Vanguard''s Mail Waistband', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=10, stat_type3=6, stat_value3=8, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=16532;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191339, name='Vanguard''s Mail Bindings', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=9, stat_type2=7, stat_value2=6, stat_type3=6, stat_value3=6, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12618;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191340, name='Vanguard''s Plate Breastplate', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=23, stat_type2=7, stat_value2=19, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12619;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191341, name='Vanguard''s Plate Legplates', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=23, stat_type2=7, stat_value2=19, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=16429;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191342, name='Vanguard''s Plate Greathelm', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=21, stat_type2=7, stat_value2=17, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=16432;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191343, name='Vanguard''s Plate Spaulders', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=18, stat_type2=7, stat_value2=14, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=19057;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191344, name='Vanguard''s Plate Handguards', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=18, stat_type2=7, stat_value2=14, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=16405;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191345, name='Vanguard''s Plate Warboots', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=18, stat_type2=7, stat_value2=14, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13142;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191346, name='Vanguard''s Plate Waistguard', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=18, stat_type2=7, stat_value2=14, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12936;
UPDATE tmp_it SET armor=IF(ItemLevel>62, ROUND(armor*62/ItemLevel), armor), entry=191347, name='Vanguard''s Plate Vambraces', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=12, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12967;
UPDATE tmp_it SET armor=armor, entry=191348, name='Vanguard''s Cloak of Fury', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=12, stat_type2=7, stat_value2=11, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12967;
UPDATE tmp_it SET armor=armor, entry=191349, name='Vanguard''s Cloak of Swiftness', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=12, stat_type2=7, stat_value2=11, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12967;
UPDATE tmp_it SET armor=armor, entry=191350, name='Vanguard''s Cloak of Insight', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12058;
UPDATE tmp_it SET armor=armor, entry=191351, name='Vanguard''s Band of Fury', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=12, stat_type2=7, stat_value2=11, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12058;
UPDATE tmp_it SET armor=armor, entry=191352, name='Vanguard''s Band of Swiftness', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=12, stat_type2=7, stat_value2=11, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12058;
UPDATE tmp_it SET armor=armor, entry=191353, name='Vanguard''s Band of Insight', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12103;
UPDATE tmp_it SET armor=armor, entry=191354, name='Vanguard''s Pendant of Fury', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=12, stat_type2=7, stat_value2=11, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12103;
UPDATE tmp_it SET armor=armor, entry=191355, name='Vanguard''s Pendant of Swiftness', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=12, stat_type2=7, stat_value2=11, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12103;
UPDATE tmp_it SET armor=armor, entry=191356, name='Vanguard''s Pendant of Insight', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=14, stat_type2=7, stat_value2=9, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6622;
UPDATE tmp_it SET armor=armor, entry=191357, name='Vanguard''s Longsword', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=12, stat_type2=7, stat_value2=13, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12784;
UPDATE tmp_it SET armor=armor, entry=191358, name='Vanguard''s Greataxe', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=23, stat_type2=7, stat_value2=19, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=5267;
UPDATE tmp_it SET armor=armor, entry=191359, name='Vanguard''s Dirk', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=15, stat_type2=7, stat_value2=10, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13349;
UPDATE tmp_it SET armor=armor, entry=191360, name='Vanguard''s Scepter', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=12, stat_type2=7, stat_value2=8, stat_type3=6, stat_value3=5, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=18534;
UPDATE tmp_it SET armor=armor, entry=191361, name='Vanguard''s Battle Staff', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=19, stat_type2=7, stat_value2=15, stat_type3=6, stat_value3=8, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=13023;
UPDATE tmp_it SET armor=armor, entry=191362, name='Vanguard''s Recurve Bow', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=11, stat_type2=7, stat_value2=8, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=19967;
UPDATE tmp_it SET armor=armor, entry=191363, name='Vanguard''s Wand', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=10, stat_type2=6, stat_value2=7, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14812;
UPDATE tmp_it SET armor=armor, entry=191364, name='Vanguard''s Kite Shield', Quality=3, ItemLevel=62, RequiredLevel=50, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=7, stat_value1=15, stat_type2=4, stat_value2=10, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;

-- Reward stock. Quartermasters (190100/190101) carry levels 1-39, Renown Armorers (190108/190109) 40-60, Warmasters (190110/190111) the level 60 tiers 7-9:
-- a vendor holds at most 255 items. Every item is shown only to players of its level band who own its insignia.
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59150,15,20,1,0,0,0,'Renown: level >= 20' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=20 AND value2=1 AND value3=0 AND value4=0 AND flags=0);
SET @rc59150 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=20 AND value2=1 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59151,15,29,2,0,0,0,'Renown: level <= 29' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=29 AND value2=2 AND value3=0 AND value4=0 AND flags=0);
SET @rc59151 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=29 AND value2=2 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59152,-1,@rc59150,@rc59151,0,0,0,'Renown: level 20-29' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59150 AND value2=@rc59151 AND value3=0 AND value4=0 AND flags=0);
SET @rc59152 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59150 AND value2=@rc59151 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59153,-1,@rc59152,59102,0,0,0,'Renown: level 20-29, tier 2' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59152 AND value2=59102 AND value3=0 AND value4=0 AND flags=0);
SET @rc59153 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59152 AND value2=59102 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59154,15,30,1,0,0,0,'Renown: level >= 30' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=30 AND value2=1 AND value3=0 AND value4=0 AND flags=0);
SET @rc59154 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=30 AND value2=1 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59155,15,39,2,0,0,0,'Renown: level <= 39' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=39 AND value2=2 AND value3=0 AND value4=0 AND flags=0);
SET @rc59155 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=39 AND value2=2 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59156,-1,@rc59154,@rc59155,0,0,0,'Renown: level 30-39' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59154 AND value2=@rc59155 AND value3=0 AND value4=0 AND flags=0);
SET @rc59156 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59154 AND value2=@rc59155 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59157,-1,@rc59156,59103,0,0,0,'Renown: level 30-39, tier 3' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59156 AND value2=59103 AND value3=0 AND value4=0 AND flags=0);
SET @rc59157 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59156 AND value2=59103 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59158,15,40,1,0,0,0,'Renown: level >= 40' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=40 AND value2=1 AND value3=0 AND value4=0 AND flags=0);
SET @rc59158 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=40 AND value2=1 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59159,15,49,2,0,0,0,'Renown: level <= 49' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=49 AND value2=2 AND value3=0 AND value4=0 AND flags=0);
SET @rc59159 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=49 AND value2=2 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59160,-1,@rc59158,@rc59159,0,0,0,'Renown: level 40-49' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59158 AND value2=@rc59159 AND value3=0 AND value4=0 AND flags=0);
SET @rc59160 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59158 AND value2=@rc59159 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59161,-1,@rc59160,59104,0,0,0,'Renown: level 40-49, tier 4' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59160 AND value2=59104 AND value3=0 AND value4=0 AND flags=0);
SET @rc59161 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59160 AND value2=59104 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59162,15,50,1,0,0,0,'Renown: level >= 50' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=50 AND value2=1 AND value3=0 AND value4=0 AND flags=0);
SET @rc59162 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=50 AND value2=1 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59163,15,59,2,0,0,0,'Renown: level <= 59' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=59 AND value2=2 AND value3=0 AND value4=0 AND flags=0);
SET @rc59163 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=59 AND value2=2 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59164,-1,@rc59162,@rc59163,0,0,0,'Renown: level 50-59' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59162 AND value2=@rc59163 AND value3=0 AND value4=0 AND flags=0);
SET @rc59164 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59162 AND value2=@rc59163 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59165,-1,@rc59164,59105,0,0,0,'Renown: level 50-59, tier 5' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59164 AND value2=59105 AND value3=0 AND value4=0 AND flags=0);
SET @rc59165 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59164 AND value2=59105 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59166,15,21,1,0,0,0,'Renown: level >= 21' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=21 AND value2=1 AND value3=0 AND value4=0 AND flags=0);
SET @rc59166 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=21 AND value2=1 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59167,15,48,2,0,0,0,'Renown: level <= 48' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=48 AND value2=2 AND value3=0 AND value4=0 AND flags=0);
SET @rc59167 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=48 AND value2=2 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59168,-1,@rc59166,@rc59167,0,0,0,'Renown: level 21-48' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59166 AND value2=@rc59167 AND value3=0 AND value4=0 AND flags=0);
SET @rc59168 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59166 AND value2=@rc59167 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59169,-1,@rc59168,59103,0,0,0,'Renown: level 21-48, tier 3' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59168 AND value2=59103 AND value3=0 AND value4=0 AND flags=0);
SET @rc59169 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59168 AND value2=59103 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59170,15,10,1,0,0,0,'Renown: level >= 10' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=10 AND value2=1 AND value3=0 AND value4=0 AND flags=0);
SET @rc59170 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=10 AND value2=1 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59171,-1,@rc59170,@rc59151,0,0,0,'Renown: level 10-29' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59170 AND value2=@rc59151 AND value3=0 AND value4=0 AND flags=0);
SET @rc59171 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59170 AND value2=@rc59151 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59172,-1,@rc59171,59101,0,0,0,'Renown: level 10-29, tier 1' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59171 AND value2=59101 AND value3=0 AND value4=0 AND flags=0);
SET @rc59172 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59171 AND value2=59101 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59173,15,12,1,0,0,0,'Renown: level >= 12' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=12 AND value2=1 AND value3=0 AND value4=0 AND flags=0);
SET @rc59173 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=12 AND value2=1 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59174,15,38,2,0,0,0,'Renown: level <= 38' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=38 AND value2=2 AND value3=0 AND value4=0 AND flags=0);
SET @rc59174 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=38 AND value2=2 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59175,-1,@rc59173,@rc59174,0,0,0,'Renown: level 12-38' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59173 AND value2=@rc59174 AND value3=0 AND value4=0 AND flags=0);
SET @rc59175 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59173 AND value2=@rc59174 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59176,-1,@rc59175,59102,0,0,0,'Renown: level 12-38, tier 2' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59175 AND value2=59102 AND value3=0 AND value4=0 AND flags=0);
SET @rc59176 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59175 AND value2=59102 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59177,15,31,1,0,0,0,'Renown: level >= 31' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=31 AND value2=1 AND value3=0 AND value4=0 AND flags=0);
SET @rc59177 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=31 AND value2=1 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59178,15,58,2,0,0,0,'Renown: level <= 58' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=58 AND value2=2 AND value3=0 AND value4=0 AND flags=0);
SET @rc59178 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=58 AND value2=2 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59179,-1,@rc59177,@rc59178,0,0,0,'Renown: level 31-58' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59177 AND value2=@rc59178 AND value3=0 AND value4=0 AND flags=0);
SET @rc59179 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59177 AND value2=@rc59178 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59180,-1,@rc59179,59104,0,0,0,'Renown: level 31-58, tier 4' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59179 AND value2=59104 AND value3=0 AND value4=0 AND flags=0);
SET @rc59180 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59179 AND value2=59104 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59181,15,41,1,0,0,0,'Renown: level >= 41' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=41 AND value2=1 AND value3=0 AND value4=0 AND flags=0);
SET @rc59181 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=41 AND value2=1 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59182,-1,@rc59181,59105,0,0,0,'Renown: level 41-60, tier 5' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59181 AND value2=59105 AND value3=0 AND value4=0 AND flags=0);
SET @rc59182 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59181 AND value2=59105 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59183,-1,@rc59162,59106,0,0,0,'Renown: level 50-60, tier 6' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59162 AND value2=59106 AND value3=0 AND value4=0 AND flags=0);
SET @rc59183 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59162 AND value2=59106 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59184,15,55,1,0,0,0,'Renown: level >= 55' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=15 AND value1=55 AND value2=1 AND value3=0 AND value4=0 AND flags=0);
SET @rc59184 := (SELECT condition_entry FROM conditions WHERE type=15 AND value1=55 AND value2=1 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59185,-1,@rc59184,59107,0,0,0,'Renown: level 55-60, tier 7' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59184 AND value2=59107 AND value3=0 AND value4=0 AND flags=0);
SET @rc59185 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59184 AND value2=59107 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59186,-1,@rc59184,59108,0,0,0,'Renown: level 55-60, tier 8' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59184 AND value2=59108 AND value3=0 AND value4=0 AND flags=0);
SET @rc59186 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59184 AND value2=59108 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) SELECT 59187,-1,@rc59184,59109,0,0,0,'Renown: level 55-60, tier 9' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM conditions WHERE type=-1 AND value1=@rc59184 AND value2=59109 AND value3=0 AND value4=0 AND flags=0);
SET @rc59187 := (SELECT condition_entry FROM conditions WHERE type=-1 AND value1=@rc59184 AND value2=59109 AND value3=0 AND value4=0 AND flags=0 ORDER BY condition_entry LIMIT 1);
-- Rewards bought with Renown need no reputation or PvP rank
UPDATE item_template SET RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0 WHERE entry IN (16437,16440,16441,16442,16443,16444,16446,16448,16449,16450,16451,16452,16453,16454,16455,16456,16457,16459,16462,16463,16465,16466,16467,16468,16471,16472,16473,16474,16475,16476,16477,16478,16479,16480,16483,16484,16533,16534,16535,16536,16539,16540,16541,16542,16543,16544,16545,16548,16549,16550,16551,16552,16554,16555,16558,16560,16561,16562,16563,16564,16565,16566,16567,16568,16569,16571,16573,16574,16577,16578,16579,16580,17578,17579,17580,17581,17583,17584,17586,17588,17590,17591,17592,17593,17602,17603,17604,17605,17607,17608,17618,17620,17622,17623,17624,17625,19083,19084,19085,19086,19087,19088,19089,19090,19091,19092,19093,19094,19095,19096,19097,19098,19099,19100,19102,19103,19104,19105,19106,19107,19108,19308,19309,19310,19311,19312,19315,19319,19320,19321,19323,19324,19325,20041,20042,20043,20044,20045,20046,20047,20048,20049,20050,20051,20052,20053,20054,20055,20056,20057,20058,20059,20060,20061,20068,20069,20070,20071,20072,20073,20088,20089,20090,20091,20092,20093,20094,20095,20096,20097,20098,20099,20100,20101,20102,20103,20104,20105,20106,20107,20108,20109,20110,20111,20112,20113,20114,20115,20116,20117,20118,20119,20120,20121,20122,20123,20124,20125,20126,20127,20128,20129,20150,20151,20152,20153,20154,20155,20156,20157,20158,20159,20160,20161,20162,20163,20164,20165,20166,20167,20168,20169,20170,20171,20172,20173,20174,20175,20176,20186,20187,20188,20189,20190,20191,20192,20193,20194,20195,20196,20197,20198,20199,20200,20201,20202,20203,20204,20205,20206,20207,20208,20209,20210,20211,20212,20214,20220,20648,21115,21116,21117,21118,21119,21120,22843,22852,22855,22856,22857,22858,22859,22860,22862,22863,22864,22865,22867,22868,22869,22870,22872,22873,22874,22875,22876,22877,22878,22879,22880,22881,22882,22883,22884,22885,22886,22887,23243,23244,23251,23252,23253,23254,23255,23256,23257,23258,23259,23260,23261,23262,23263,23264,23272,23273,23274,23275,23276,23277,23278,23279,23280,23281,23282,23283,23284,23285,23286,23287,23288,23289,23290,23291,23292,23293,23294,23295,23296,23297,23298,23299,23300,23301,23302,23303,23304,23305,23306,23307,23308,23309,23310,23311,23312,23313,23314,23315,23316,23317,23318,23319);
INSERT INTO npc_vendor (entry,item,maxcount,incrtime,slot,condition_id,comments) VALUES
(190100,190600,0,0,0,59110,'Renown Recruit''s, levels 1-9'),
(190100,190601,0,0,1,59110,'Renown Recruit''s, levels 1-9'),
(190100,190700,0,0,2,59110,'Renown Recruit''s, levels 1-9'),
(190100,190701,0,0,3,59110,'Renown Recruit''s, levels 1-9'),
(190100,190602,0,0,4,59110,'Renown Recruit''s, levels 1-9'),
(190100,190603,0,0,5,59110,'Renown Recruit''s, levels 1-9'),
(190100,190604,0,0,6,59110,'Renown Recruit''s, levels 1-9'),
(190100,190702,0,0,7,59110,'Renown Recruit''s, levels 1-9'),
(190100,190605,0,0,8,59110,'Renown Recruit''s, levels 1-9'),
(190100,190606,0,0,9,59110,'Renown Recruit''s, levels 1-9'),
(190100,190703,0,0,10,59110,'Renown Recruit''s, levels 1-9'),
(190100,190704,0,0,11,59110,'Renown Recruit''s, levels 1-9'),
(190100,190607,0,0,12,59110,'Renown Recruit''s, levels 1-9'),
(190100,190608,0,0,13,59110,'Renown Recruit''s, levels 1-9'),
(190100,190609,0,0,14,59110,'Renown Recruit''s, levels 1-9'),
(190100,190705,0,0,15,59110,'Renown Recruit''s, levels 1-9'),
(190100,190610,0,0,16,59110,'Renown Recruit''s, levels 1-9'),
(190100,190611,0,0,17,59110,'Renown Recruit''s, levels 1-9'),
(190100,190706,0,0,18,59110,'Renown Recruit''s, levels 1-9'),
(190100,190707,0,0,19,59110,'Renown Recruit''s, levels 1-9'),
(190100,190612,0,0,20,59110,'Renown Recruit''s, levels 1-9'),
(190100,190613,0,0,21,59110,'Renown Recruit''s, levels 1-9'),
(190100,190614,0,0,22,59110,'Renown Recruit''s, levels 1-9'),
(190100,190708,0,0,23,59110,'Renown Recruit''s, levels 1-9'),
(190100,190615,0,0,24,59110,'Renown Recruit''s, levels 1-9'),
(190100,190616,0,0,25,59110,'Renown Recruit''s, levels 1-9'),
(190100,190709,0,0,26,59110,'Renown Recruit''s, levels 1-9'),
(190100,190710,0,0,27,59110,'Renown Recruit''s, levels 1-9'),
(190100,190617,0,0,28,59110,'Renown Recruit''s, levels 1-9'),
(190100,190618,0,0,29,59110,'Renown Recruit''s, levels 1-9'),
(190100,190619,0,0,30,59110,'Renown Recruit''s, levels 1-9'),
(190100,190711,0,0,31,59110,'Renown Recruit''s, levels 1-9'),
(190100,190620,0,0,32,59110,'Renown Recruit''s, levels 1-9'),
(190100,190621,0,0,33,59110,'Renown Recruit''s, levels 1-9'),
(190100,190622,0,0,34,59110,'Renown Recruit''s, levels 1-9'),
(190100,190623,0,0,35,59110,'Renown Recruit''s, levels 1-9'),
(190100,190624,0,0,36,59110,'Renown Recruit''s, levels 1-9'),
(190100,190625,0,0,37,59110,'Renown Recruit''s, levels 1-9'),
(190100,190712,0,0,38,59110,'Renown Recruit''s, levels 1-9'),
(190100,190713,0,0,39,59110,'Renown Recruit''s, levels 1-9'),
(190100,190714,0,0,40,59110,'Renown Recruit''s, levels 1-9'),
(190100,190626,0,0,41,59110,'Renown Recruit''s, levels 1-9'),
(190100,190627,0,0,42,59110,'Renown Recruit''s, levels 1-9'),
(190100,190628,0,0,43,59110,'Renown Recruit''s, levels 1-9'),
(190100,190629,0,0,44,59110,'Renown Recruit''s, levels 1-9'),
(190100,190630,0,0,45,59110,'Renown Recruit''s, levels 1-9'),
(190100,190631,0,0,46,59110,'Renown Recruit''s, levels 1-9'),
(190100,190632,0,0,47,59110,'Renown Recruit''s, levels 1-9'),
(190100,190633,0,0,48,59110,'Renown Recruit''s, levels 1-9'),
(190100,190634,0,0,49,59112,'Renown set, levels 10-19, tier 1'),
(190100,190635,0,0,50,59112,'Renown set, levels 10-19, tier 1'),
(190100,190715,0,0,51,59112,'Renown set, levels 10-19, tier 1'),
(190100,190716,0,0,52,59112,'Renown set, levels 10-19, tier 1'),
(190100,190636,0,0,53,59112,'Renown set, levels 10-19, tier 1'),
(190100,190637,0,0,54,59112,'Renown set, levels 10-19, tier 1'),
(190100,190638,0,0,55,59112,'Renown set, levels 10-19, tier 1'),
(190100,190717,0,0,56,59112,'Renown set, levels 10-19, tier 1'),
(190100,190639,0,0,57,59112,'Renown set, levels 10-19, tier 1'),
(190100,190640,0,0,58,59112,'Renown set, levels 10-19, tier 1'),
(190100,190718,0,0,59,59112,'Renown set, levels 10-19, tier 1'),
(190100,190719,0,0,60,59112,'Renown set, levels 10-19, tier 1'),
(190100,190641,0,0,61,59112,'Renown set, levels 10-19, tier 1'),
(190100,190642,0,0,62,59112,'Renown set, levels 10-19, tier 1'),
(190100,190643,0,0,63,59112,'Renown set, levels 10-19, tier 1'),
(190100,190720,0,0,64,59112,'Renown set, levels 10-19, tier 1'),
(190100,190644,0,0,65,59112,'Renown set, levels 10-19, tier 1'),
(190100,190645,0,0,66,59112,'Renown set, levels 10-19, tier 1'),
(190100,190721,0,0,67,59112,'Renown set, levels 10-19, tier 1'),
(190100,190722,0,0,68,59112,'Renown set, levels 10-19, tier 1'),
(190100,190646,0,0,69,59112,'Renown set, levels 10-19, tier 1'),
(190100,190647,0,0,70,59112,'Renown set, levels 10-19, tier 1'),
(190100,190648,0,0,71,59112,'Renown set, levels 10-19, tier 1'),
(190100,190723,0,0,72,59112,'Renown set, levels 10-19, tier 1'),
(190100,190649,0,0,73,59112,'Renown set, levels 10-19, tier 1'),
(190100,190650,0,0,74,59112,'Renown set, levels 10-19, tier 1'),
(190100,190724,0,0,75,59112,'Renown set, levels 10-19, tier 1'),
(190100,190725,0,0,76,59112,'Renown set, levels 10-19, tier 1'),
(190100,190651,0,0,77,59112,'Renown set, levels 10-19, tier 1'),
(190100,190652,0,0,78,59112,'Renown set, levels 10-19, tier 1'),
(190100,190653,0,0,79,59112,'Renown set, levels 10-19, tier 1'),
(190100,190726,0,0,80,59112,'Renown set, levels 10-19, tier 1'),
(190100,190654,0,0,81,59112,'Renown set, levels 10-19, tier 1'),
(190100,190655,0,0,82,59112,'Renown set, levels 10-19, tier 1'),
(190100,190656,0,0,83,59112,'Renown set, levels 10-19, tier 1'),
(190100,190657,0,0,84,59112,'Renown set, levels 10-19, tier 1'),
(190100,190658,0,0,85,59112,'Renown set, levels 10-19, tier 1'),
(190100,190659,0,0,86,59112,'Renown set, levels 10-19, tier 1'),
(190100,190727,0,0,87,59112,'Renown set, levels 10-19, tier 1'),
(190100,190728,0,0,88,59112,'Renown set, levels 10-19, tier 1'),
(190100,190729,0,0,89,59112,'Renown set, levels 10-19, tier 1'),
(190100,190660,0,0,90,59112,'Renown set, levels 10-19, tier 1'),
(190100,190661,0,0,91,59112,'Renown set, levels 10-19, tier 1'),
(190100,190662,0,0,92,59112,'Renown set, levels 10-19, tier 1'),
(190100,190663,0,0,93,59112,'Renown set, levels 10-19, tier 1'),
(190100,190664,0,0,94,59112,'Renown set, levels 10-19, tier 1'),
(190100,190665,0,0,95,59112,'Renown set, levels 10-19, tier 1'),
(190100,190666,0,0,96,59112,'Renown set, levels 10-19, tier 1'),
(190100,190667,0,0,97,59112,'Renown set, levels 10-19, tier 1'),
(190100,191000,0,0,98,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191001,0,0,99,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191002,0,0,100,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191003,0,0,101,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191004,0,0,102,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191005,0,0,103,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191006,0,0,104,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191007,0,0,105,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191008,0,0,106,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191009,0,0,107,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191010,0,0,108,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191011,0,0,109,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191012,0,0,110,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191013,0,0,111,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191014,0,0,112,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191015,0,0,113,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191016,0,0,114,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191017,0,0,115,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191018,0,0,116,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191019,0,0,117,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191020,0,0,118,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191021,0,0,119,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191022,0,0,120,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191023,0,0,121,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191024,0,0,122,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191025,0,0,123,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191026,0,0,124,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191027,0,0,125,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191028,0,0,126,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191029,0,0,127,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191030,0,0,128,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191031,0,0,129,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191032,0,0,130,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191033,0,0,131,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191034,0,0,132,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191035,0,0,133,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191036,0,0,134,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191037,0,0,135,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191038,0,0,136,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191039,0,0,137,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191040,0,0,138,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191041,0,0,139,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191042,0,0,140,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191043,0,0,141,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191044,0,0,142,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191045,0,0,143,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191046,0,0,144,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191047,0,0,145,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191048,0,0,146,@rc59153,'Renown set, levels 20-29, tier 2'),
(190100,191100,0,0,147,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191101,0,0,148,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191102,0,0,149,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191103,0,0,150,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191104,0,0,151,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191105,0,0,152,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191106,0,0,153,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191107,0,0,154,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191108,0,0,155,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191109,0,0,156,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191110,0,0,157,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191111,0,0,158,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191112,0,0,159,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191113,0,0,160,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191114,0,0,161,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191115,0,0,162,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191116,0,0,163,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191117,0,0,164,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191118,0,0,165,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191119,0,0,166,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191120,0,0,167,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191121,0,0,168,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191122,0,0,169,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191123,0,0,170,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191124,0,0,171,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191125,0,0,172,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191126,0,0,173,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191127,0,0,174,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191128,0,0,175,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191129,0,0,176,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191130,0,0,177,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191131,0,0,178,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191132,0,0,179,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191133,0,0,180,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191134,0,0,181,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191135,0,0,182,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191136,0,0,183,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191137,0,0,184,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191138,0,0,185,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191139,0,0,186,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191140,0,0,187,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191141,0,0,188,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191142,0,0,189,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191143,0,0,190,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191144,0,0,191,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191145,0,0,192,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191146,0,0,193,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191147,0,0,194,@rc59157,'Renown set, levels 30-39, tier 3'),
(190100,191148,0,0,195,@rc59157,'Renown set, levels 30-39, tier 3'),
(190108,191200,0,0,0,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191201,0,0,1,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191202,0,0,2,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191203,0,0,3,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191204,0,0,4,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191205,0,0,5,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191206,0,0,6,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191207,0,0,7,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191208,0,0,8,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191209,0,0,9,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191210,0,0,10,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191211,0,0,11,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191212,0,0,12,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191213,0,0,13,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191214,0,0,14,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191215,0,0,15,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191216,0,0,16,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191217,0,0,17,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191218,0,0,18,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191219,0,0,19,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191220,0,0,20,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191221,0,0,21,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191222,0,0,22,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191223,0,0,23,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191224,0,0,24,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191225,0,0,25,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191226,0,0,26,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191227,0,0,27,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191228,0,0,28,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191229,0,0,29,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191230,0,0,30,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191231,0,0,31,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191232,0,0,32,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191233,0,0,33,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191234,0,0,34,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191235,0,0,35,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191236,0,0,36,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191237,0,0,37,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191238,0,0,38,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191239,0,0,39,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191240,0,0,40,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191241,0,0,41,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191242,0,0,42,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191243,0,0,43,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191244,0,0,44,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191245,0,0,45,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191246,0,0,46,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191247,0,0,47,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191248,0,0,48,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191249,0,0,49,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191250,0,0,50,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191251,0,0,51,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191252,0,0,52,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191253,0,0,53,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191254,0,0,54,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191255,0,0,55,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191256,0,0,56,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191257,0,0,57,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191258,0,0,58,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191259,0,0,59,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191260,0,0,60,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191261,0,0,61,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191262,0,0,62,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191263,0,0,63,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191264,0,0,64,@rc59161,'Renown set, levels 40-49, tier 4'),
(190108,191300,0,0,65,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191301,0,0,66,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191302,0,0,67,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191303,0,0,68,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191304,0,0,69,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191305,0,0,70,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191306,0,0,71,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191307,0,0,72,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191308,0,0,73,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191309,0,0,74,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191310,0,0,75,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191311,0,0,76,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191312,0,0,77,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191313,0,0,78,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191314,0,0,79,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191315,0,0,80,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191316,0,0,81,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191317,0,0,82,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191318,0,0,83,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191319,0,0,84,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191320,0,0,85,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191321,0,0,86,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191322,0,0,87,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191323,0,0,88,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191324,0,0,89,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191325,0,0,90,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191326,0,0,91,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191327,0,0,92,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191328,0,0,93,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191329,0,0,94,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191330,0,0,95,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191331,0,0,96,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191332,0,0,97,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191333,0,0,98,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191334,0,0,99,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191335,0,0,100,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191336,0,0,101,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191337,0,0,102,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191338,0,0,103,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191339,0,0,104,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191340,0,0,105,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191341,0,0,106,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191342,0,0,107,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191343,0,0,108,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191344,0,0,109,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191345,0,0,110,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191346,0,0,111,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191347,0,0,112,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191348,0,0,113,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191349,0,0,114,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191350,0,0,115,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191351,0,0,116,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191352,0,0,117,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191353,0,0,118,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191354,0,0,119,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191355,0,0,120,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191356,0,0,121,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191357,0,0,122,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191358,0,0,123,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191359,0,0,124,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191360,0,0,125,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191361,0,0,126,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191362,0,0,127,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191363,0,0,128,@rc59165,'Renown set, levels 50-59, tier 5'),
(190108,191364,0,0,129,@rc59165,'Renown set, levels 50-59, tier 5'),
(190100,19506,0,0,196,@rc59169,'WSG reward, tier 3'),
(190100,20428,0,0,197,@rc59172,'WSG reward, tier 1'),
(190100,20431,0,0,198,@rc59172,'WSG reward, tier 1'),
(190100,20434,0,0,199,@rc59172,'WSG reward, tier 1'),
(190100,20438,0,0,200,@rc59172,'WSG reward, tier 1'),
(190100,20439,0,0,201,@rc59172,'WSG reward, tier 1'),
(190100,20440,0,0,202,@rc59172,'WSG reward, tier 1'),
(190100,20443,0,0,203,@rc59172,'WSG reward, tier 1'),
(190100,20444,0,0,204,@rc59172,'WSG reward, tier 1'),
(190100,21566,0,0,205,@rc59172,'WSG reward, tier 1'),
(190100,21568,0,0,206,@rc59172,'WSG reward, tier 1'),
(190100,19062,0,0,207,59102,'WSG consumable, tier 2'),
(190100,19068,0,0,208,59102,'WSG consumable, tier 2'),
(190100,19517,0,0,209,@rc59176,'WSG reward, tier 2'),
(190100,19525,0,0,210,@rc59176,'WSG reward, tier 2'),
(190100,19533,0,0,211,@rc59176,'WSG reward, tier 2'),
(190100,19541,0,0,212,@rc59176,'WSG reward, tier 2'),
(190100,19549,0,0,213,@rc59176,'WSG reward, tier 2'),
(190100,19557,0,0,214,@rc59176,'WSG reward, tier 2'),
(190100,19565,0,0,215,@rc59176,'WSG reward, tier 2'),
(190100,19573,0,0,216,@rc59176,'WSG reward, tier 2'),
(190100,17349,0,0,217,59103,'WSG consumable, tier 3'),
(190100,17352,0,0,218,59103,'WSG consumable, tier 3'),
(190100,19061,0,0,219,59103,'WSG consumable, tier 3'),
(190100,19067,0,0,220,59103,'WSG consumable, tier 3'),
(190100,19515,0,0,221,@rc59169,'WSG reward, tier 3'),
(190100,19524,0,0,222,@rc59169,'WSG reward, tier 3'),
(190100,19532,0,0,223,@rc59169,'WSG reward, tier 3'),
(190100,19540,0,0,224,@rc59169,'WSG reward, tier 3'),
(190100,19548,0,0,225,@rc59169,'WSG reward, tier 3'),
(190100,19556,0,0,226,@rc59169,'WSG reward, tier 3'),
(190100,19564,0,0,227,@rc59169,'WSG reward, tier 3'),
(190100,19572,0,0,228,@rc59169,'WSG reward, tier 3'),
(190108,19581,0,0,130,@rc59180,'WSG reward, tier 4'),
(190108,19584,0,0,131,@rc59180,'WSG reward, tier 4'),
(190108,19590,0,0,132,@rc59180,'WSG reward, tier 4'),
(190108,19597,0,0,133,@rc59180,'WSG reward, tier 4'),
(190108,21565,0,0,134,@rc59180,'WSG reward, tier 4'),
(190108,21567,0,0,135,@rc59180,'WSG reward, tier 4'),
(190100,17348,0,0,229,59104,'WSG consumable, tier 4'),
(190100,17351,0,0,230,59104,'WSG consumable, tier 4'),
(190100,19060,0,0,231,59104,'WSG consumable, tier 4'),
(190100,19066,0,0,232,59104,'WSG consumable, tier 4'),
(190108,19516,0,0,136,@rc59180,'WSG reward, tier 4'),
(190108,19523,0,0,137,@rc59180,'WSG reward, tier 4'),
(190108,19531,0,0,138,@rc59180,'WSG reward, tier 4'),
(190108,19539,0,0,139,@rc59180,'WSG reward, tier 4'),
(190108,19547,0,0,140,@rc59180,'WSG reward, tier 4'),
(190108,19555,0,0,141,@rc59180,'WSG reward, tier 4'),
(190108,19563,0,0,142,@rc59180,'WSG reward, tier 4'),
(190108,19571,0,0,143,@rc59180,'WSG reward, tier 4'),
(190108,19580,0,0,144,@rc59182,'WSG reward, tier 5'),
(190108,19583,0,0,145,@rc59182,'WSG reward, tier 5'),
(190108,19589,0,0,146,@rc59182,'WSG reward, tier 5'),
(190108,19596,0,0,147,@rc59182,'WSG reward, tier 5'),
(190108,19514,0,0,148,@rc59182,'WSG reward, tier 5'),
(190108,19522,0,0,149,@rc59182,'WSG reward, tier 5'),
(190108,19530,0,0,150,@rc59182,'WSG reward, tier 5'),
(190108,19538,0,0,151,@rc59182,'WSG reward, tier 5'),
(190108,19546,0,0,152,@rc59182,'WSG reward, tier 5'),
(190108,19554,0,0,153,@rc59182,'WSG reward, tier 5'),
(190108,19562,0,0,154,@rc59182,'WSG reward, tier 5'),
(190108,19570,0,0,155,@rc59182,'WSG reward, tier 5'),
(190108,19578,0,0,156,@rc59183,'WSG reward, tier 6'),
(190108,19582,0,0,157,@rc59183,'WSG reward, tier 6'),
(190108,19587,0,0,158,@rc59183,'WSG reward, tier 6'),
(190108,19595,0,0,159,@rc59183,'WSG reward, tier 6'),
(190108,22672,0,0,160,@rc59183,'WSG reward, tier 6'),
(190108,22748,0,0,161,@rc59183,'WSG reward, tier 6'),
(190108,22749,0,0,162,@rc59183,'WSG reward, tier 6'),
(190108,22750,0,0,163,@rc59183,'WSG reward, tier 6'),
(190108,22752,0,0,164,@rc59183,'WSG reward, tier 6'),
(190108,22753,0,0,165,@rc59183,'WSG reward, tier 6'),
(190100,20090,0,0,233,@rc59176,'AB reward, tier 2'),
(190100,20093,0,0,234,@rc59176,'AB reward, tier 2'),
(190100,20096,0,0,235,@rc59176,'AB reward, tier 2'),
(190100,20099,0,0,236,@rc59176,'AB reward, tier 2'),
(190100,20102,0,0,237,@rc59176,'AB reward, tier 2'),
(190100,20105,0,0,238,@rc59176,'AB reward, tier 2'),
(190100,20108,0,0,239,@rc59176,'AB reward, tier 2'),
(190100,20111,0,0,240,@rc59176,'AB reward, tier 2'),
(190100,20114,0,0,241,@rc59176,'AB reward, tier 2'),
(190100,20117,0,0,242,@rc59176,'AB reward, tier 2'),
(190100,20120,0,0,243,@rc59176,'AB reward, tier 2'),
(190100,20123,0,0,244,@rc59176,'AB reward, tier 2'),
(190100,20126,0,0,245,@rc59176,'AB reward, tier 2'),
(190100,20129,0,0,246,@rc59176,'AB reward, tier 2'),
(190100,21119,0,0,247,@rc59176,'AB reward, tier 2'),
(190100,20095,0,0,248,@rc59169,'AB reward, tier 3'),
(190100,20098,0,0,249,@rc59169,'AB reward, tier 3'),
(190100,20101,0,0,250,@rc59169,'AB reward, tier 3'),
(190100,20104,0,0,251,@rc59169,'AB reward, tier 3'),
(190100,20113,0,0,252,@rc59169,'AB reward, tier 3'),
(190100,20116,0,0,253,@rc59169,'AB reward, tier 3'),
(190100,21118,0,0,254,@rc59169,'AB reward, tier 3'),
(190108,20089,0,0,166,@rc59180,'AB reward, tier 4'),
(190108,20092,0,0,167,@rc59180,'AB reward, tier 4'),
(190108,20107,0,0,168,@rc59180,'AB reward, tier 4'),
(190108,20110,0,0,169,@rc59180,'AB reward, tier 4'),
(190108,20119,0,0,170,@rc59180,'AB reward, tier 4'),
(190108,20122,0,0,171,@rc59180,'AB reward, tier 4'),
(190108,20125,0,0,172,@rc59180,'AB reward, tier 4'),
(190108,20128,0,0,173,@rc59180,'AB reward, tier 4'),
(190108,20088,0,0,174,@rc59180,'AB reward, tier 4'),
(190108,20091,0,0,175,@rc59180,'AB reward, tier 4'),
(190108,20094,0,0,176,@rc59180,'AB reward, tier 4'),
(190108,20097,0,0,177,@rc59180,'AB reward, tier 4'),
(190108,20100,0,0,178,@rc59180,'AB reward, tier 4'),
(190108,20103,0,0,179,@rc59180,'AB reward, tier 4'),
(190108,20106,0,0,180,@rc59180,'AB reward, tier 4'),
(190108,20109,0,0,181,@rc59180,'AB reward, tier 4'),
(190108,20112,0,0,182,@rc59180,'AB reward, tier 4'),
(190108,20115,0,0,183,@rc59180,'AB reward, tier 4'),
(190108,20118,0,0,184,@rc59180,'AB reward, tier 4'),
(190108,20121,0,0,185,@rc59180,'AB reward, tier 4'),
(190108,20124,0,0,186,@rc59180,'AB reward, tier 4'),
(190108,20127,0,0,187,@rc59180,'AB reward, tier 4'),
(190108,21117,0,0,188,@rc59180,'AB reward, tier 4'),
(190110,20041,0,0,0,@rc59185,'AB reward, tier 7'),
(190110,20042,0,0,1,@rc59185,'AB reward, tier 7'),
(190110,20043,0,0,2,@rc59185,'AB reward, tier 7'),
(190110,20044,0,0,3,@rc59185,'AB reward, tier 7'),
(190110,20045,0,0,4,@rc59185,'AB reward, tier 7'),
(190110,20046,0,0,5,@rc59185,'AB reward, tier 7'),
(190110,20047,0,0,6,@rc59185,'AB reward, tier 7'),
(190110,20048,0,0,7,@rc59185,'AB reward, tier 7'),
(190110,20049,0,0,8,@rc59185,'AB reward, tier 7'),
(190110,20050,0,0,9,@rc59185,'AB reward, tier 7'),
(190110,20051,0,0,10,@rc59185,'AB reward, tier 7'),
(190110,20052,0,0,11,@rc59185,'AB reward, tier 7'),
(190110,20053,0,0,12,@rc59185,'AB reward, tier 7'),
(190110,20054,0,0,13,@rc59185,'AB reward, tier 7'),
(190110,20071,0,0,14,@rc59185,'AB reward, tier 7'),
(190110,20055,0,0,15,@rc59185,'AB reward, tier 7'),
(190110,20056,0,0,16,@rc59185,'AB reward, tier 7'),
(190110,20057,0,0,17,@rc59185,'AB reward, tier 7'),
(190110,20058,0,0,18,@rc59185,'AB reward, tier 7'),
(190110,20059,0,0,19,@rc59185,'AB reward, tier 7'),
(190110,20060,0,0,20,@rc59185,'AB reward, tier 7'),
(190110,20061,0,0,21,@rc59185,'AB reward, tier 7'),
(190110,20069,0,0,22,@rc59185,'AB reward, tier 7'),
(190110,20070,0,0,23,@rc59185,'AB reward, tier 7'),
(190110,20073,0,0,24,@rc59185,'AB reward, tier 7'),
(190110,19099,0,0,25,@rc59186,'AV reward, tier 8'),
(190110,19100,0,0,26,@rc59186,'AV reward, tier 8'),
(190110,19102,0,0,27,@rc59186,'AV reward, tier 8'),
(190110,19103,0,0,28,@rc59186,'AV reward, tier 8'),
(190110,19104,0,0,29,@rc59186,'AV reward, tier 8'),
(190110,19106,0,0,30,@rc59186,'AV reward, tier 8'),
(190110,19107,0,0,31,@rc59186,'AV reward, tier 8'),
(190110,19108,0,0,32,@rc59186,'AV reward, tier 8'),
(190110,20648,0,0,33,@rc59186,'AV reward, tier 8'),
(190110,19105,0,0,34,@rc59186,'AV reward, tier 8'),
(190110,19325,0,0,35,@rc59186,'AV reward, tier 8'),
(190110,19308,0,0,36,@rc59186,'AV reward, tier 8'),
(190110,19309,0,0,37,@rc59186,'AV reward, tier 8'),
(190110,19310,0,0,38,@rc59186,'AV reward, tier 8'),
(190110,19311,0,0,39,@rc59186,'AV reward, tier 8'),
(190110,19312,0,0,40,@rc59186,'AV reward, tier 8'),
(190110,19315,0,0,41,@rc59186,'AV reward, tier 8'),
(190110,19323,0,0,42,@rc59186,'AV reward, tier 8'),
(190110,19321,0,0,43,@rc59186,'AV reward, tier 8'),
(190110,19324,0,0,44,@rc59186,'AV reward, tier 8'),
(190110,19319,0,0,45,@rc59186,'AV reward, tier 8'),
(190110,19320,0,0,46,@rc59186,'AV reward, tier 8'),
(190110,19084,0,0,47,@rc59186,'AV reward, tier 8'),
(190110,19086,0,0,48,@rc59186,'AV reward, tier 8'),
(190110,19091,0,0,49,@rc59186,'AV reward, tier 8'),
(190110,19092,0,0,50,@rc59186,'AV reward, tier 8'),
(190110,19093,0,0,51,@rc59186,'AV reward, tier 8'),
(190110,19094,0,0,52,@rc59186,'AV reward, tier 8'),
(190110,19097,0,0,53,@rc59186,'AV reward, tier 8'),
(190110,19098,0,0,54,@rc59186,'AV reward, tier 8'),
(190110,23274,0,0,55,@rc59186,'PvP rank set, tier 8'),
(190110,23275,0,0,56,@rc59186,'PvP rank set, tier 8'),
(190110,23278,0,0,57,@rc59186,'PvP rank set, tier 8'),
(190110,23279,0,0,58,@rc59186,'PvP rank set, tier 8'),
(190110,23280,0,0,59,@rc59186,'PvP rank set, tier 8'),
(190110,23281,0,0,60,@rc59186,'PvP rank set, tier 8'),
(190110,23282,0,0,61,@rc59186,'PvP rank set, tier 8'),
(190110,23283,0,0,62,@rc59186,'PvP rank set, tier 8'),
(190110,23284,0,0,63,@rc59186,'PvP rank set, tier 8'),
(190110,23285,0,0,64,@rc59186,'PvP rank set, tier 8'),
(190110,23286,0,0,65,@rc59186,'PvP rank set, tier 8'),
(190110,23287,0,0,66,@rc59186,'PvP rank set, tier 8'),
(190110,23288,0,0,67,@rc59186,'PvP rank set, tier 8'),
(190110,23289,0,0,68,@rc59186,'PvP rank set, tier 8'),
(190110,23290,0,0,69,@rc59186,'PvP rank set, tier 8'),
(190110,23291,0,0,70,@rc59186,'PvP rank set, tier 8'),
(190110,23272,0,0,71,@rc59186,'PvP rank set, tier 8'),
(190110,23273,0,0,72,@rc59186,'PvP rank set, tier 8'),
(190110,23292,0,0,73,@rc59186,'PvP rank set, tier 8'),
(190110,23293,0,0,74,@rc59186,'PvP rank set, tier 8'),
(190110,23294,0,0,75,@rc59186,'PvP rank set, tier 8'),
(190110,23295,0,0,76,@rc59186,'PvP rank set, tier 8'),
(190110,23296,0,0,77,@rc59186,'PvP rank set, tier 8'),
(190110,23297,0,0,78,@rc59186,'PvP rank set, tier 8'),
(190110,23298,0,0,79,@rc59186,'PvP rank set, tier 8'),
(190110,23299,0,0,80,@rc59186,'PvP rank set, tier 8'),
(190110,23300,0,0,81,@rc59186,'PvP rank set, tier 8'),
(190110,23301,0,0,82,@rc59186,'PvP rank set, tier 8'),
(190110,23302,0,0,83,@rc59186,'PvP rank set, tier 8'),
(190110,23303,0,0,84,@rc59186,'PvP rank set, tier 8'),
(190110,23304,0,0,85,@rc59186,'PvP rank set, tier 8'),
(190110,23305,0,0,86,@rc59186,'PvP rank set, tier 8'),
(190110,23276,0,0,87,@rc59186,'PvP rank set, tier 8'),
(190110,23277,0,0,88,@rc59186,'PvP rank set, tier 8'),
(190110,23306,0,0,89,@rc59186,'PvP rank set, tier 8'),
(190110,23307,0,0,90,@rc59186,'PvP rank set, tier 8'),
(190110,23308,0,0,91,@rc59186,'PvP rank set, tier 8'),
(190110,23309,0,0,92,@rc59186,'PvP rank set, tier 8'),
(190110,23310,0,0,93,@rc59186,'PvP rank set, tier 8'),
(190110,23311,0,0,94,@rc59186,'PvP rank set, tier 8'),
(190110,23312,0,0,95,@rc59186,'PvP rank set, tier 8'),
(190110,23313,0,0,96,@rc59186,'PvP rank set, tier 8'),
(190110,23314,0,0,97,@rc59186,'PvP rank set, tier 8'),
(190110,23315,0,0,98,@rc59186,'PvP rank set, tier 8'),
(190110,23316,0,0,99,@rc59186,'PvP rank set, tier 8'),
(190110,23317,0,0,100,@rc59186,'PvP rank set, tier 8'),
(190110,23318,0,0,101,@rc59186,'PvP rank set, tier 8'),
(190110,23319,0,0,102,@rc59186,'PvP rank set, tier 8'),
(190110,16437,0,0,103,@rc59187,'PvP rank set, tier 9'),
(190110,16440,0,0,104,@rc59187,'PvP rank set, tier 9'),
(190110,16442,0,0,105,@rc59187,'PvP rank set, tier 9'),
(190110,16446,0,0,106,@rc59187,'PvP rank set, tier 9'),
(190110,16448,0,0,107,@rc59187,'PvP rank set, tier 9'),
(190110,16450,0,0,108,@rc59187,'PvP rank set, tier 9'),
(190110,16454,0,0,109,@rc59187,'PvP rank set, tier 9'),
(190110,16456,0,0,110,@rc59187,'PvP rank set, tier 9'),
(190110,16459,0,0,111,@rc59187,'PvP rank set, tier 9'),
(190110,16462,0,0,112,@rc59187,'PvP rank set, tier 9'),
(190110,16463,0,0,113,@rc59187,'PvP rank set, tier 9'),
(190110,16467,0,0,114,@rc59187,'PvP rank set, tier 9'),
(190110,16471,0,0,115,@rc59187,'PvP rank set, tier 9'),
(190110,16472,0,0,116,@rc59187,'PvP rank set, tier 9'),
(190110,16475,0,0,117,@rc59187,'PvP rank set, tier 9'),
(190110,16479,0,0,118,@rc59187,'PvP rank set, tier 9'),
(190110,16483,0,0,119,@rc59187,'PvP rank set, tier 9'),
(190110,16484,0,0,120,@rc59187,'PvP rank set, tier 9'),
(190110,17579,0,0,121,@rc59187,'PvP rank set, tier 9'),
(190110,17583,0,0,122,@rc59187,'PvP rank set, tier 9'),
(190110,17584,0,0,123,@rc59187,'PvP rank set, tier 9'),
(190110,17603,0,0,124,@rc59187,'PvP rank set, tier 9'),
(190110,17607,0,0,125,@rc59187,'PvP rank set, tier 9'),
(190110,17608,0,0,126,@rc59187,'PvP rank set, tier 9'),
(190110,16441,0,0,127,@rc59187,'PvP rank set, tier 9'),
(190110,16443,0,0,128,@rc59187,'PvP rank set, tier 9'),
(190110,16444,0,0,129,@rc59187,'PvP rank set, tier 9'),
(190110,16449,0,0,130,@rc59187,'PvP rank set, tier 9'),
(190110,16451,0,0,131,@rc59187,'PvP rank set, tier 9'),
(190110,16452,0,0,132,@rc59187,'PvP rank set, tier 9'),
(190110,16453,0,0,133,@rc59187,'PvP rank set, tier 9'),
(190110,16455,0,0,134,@rc59187,'PvP rank set, tier 9'),
(190110,16457,0,0,135,@rc59187,'PvP rank set, tier 9'),
(190110,16465,0,0,136,@rc59187,'PvP rank set, tier 9'),
(190110,16466,0,0,137,@rc59187,'PvP rank set, tier 9'),
(190110,16468,0,0,138,@rc59187,'PvP rank set, tier 9'),
(190110,16473,0,0,139,@rc59187,'PvP rank set, tier 9'),
(190110,16474,0,0,140,@rc59187,'PvP rank set, tier 9'),
(190110,16476,0,0,141,@rc59187,'PvP rank set, tier 9'),
(190110,16477,0,0,142,@rc59187,'PvP rank set, tier 9'),
(190110,16478,0,0,143,@rc59187,'PvP rank set, tier 9'),
(190110,16480,0,0,144,@rc59187,'PvP rank set, tier 9'),
(190110,17578,0,0,145,@rc59187,'PvP rank set, tier 9'),
(190110,17580,0,0,146,@rc59187,'PvP rank set, tier 9'),
(190110,17581,0,0,147,@rc59187,'PvP rank set, tier 9'),
(190110,17602,0,0,148,@rc59187,'PvP rank set, tier 9'),
(190110,17604,0,0,149,@rc59187,'PvP rank set, tier 9'),
(190110,17605,0,0,150,@rc59187,'PvP rank set, tier 9'),
(190101,190600,0,0,0,59110,'Renown Recruit''s, levels 1-9'),
(190101,190601,0,0,1,59110,'Renown Recruit''s, levels 1-9'),
(190101,190700,0,0,2,59110,'Renown Recruit''s, levels 1-9'),
(190101,190701,0,0,3,59110,'Renown Recruit''s, levels 1-9'),
(190101,190602,0,0,4,59110,'Renown Recruit''s, levels 1-9'),
(190101,190603,0,0,5,59110,'Renown Recruit''s, levels 1-9'),
(190101,190604,0,0,6,59110,'Renown Recruit''s, levels 1-9'),
(190101,190702,0,0,7,59110,'Renown Recruit''s, levels 1-9'),
(190101,190605,0,0,8,59110,'Renown Recruit''s, levels 1-9'),
(190101,190606,0,0,9,59110,'Renown Recruit''s, levels 1-9'),
(190101,190703,0,0,10,59110,'Renown Recruit''s, levels 1-9'),
(190101,190704,0,0,11,59110,'Renown Recruit''s, levels 1-9'),
(190101,190607,0,0,12,59110,'Renown Recruit''s, levels 1-9'),
(190101,190608,0,0,13,59110,'Renown Recruit''s, levels 1-9'),
(190101,190609,0,0,14,59110,'Renown Recruit''s, levels 1-9'),
(190101,190705,0,0,15,59110,'Renown Recruit''s, levels 1-9'),
(190101,190610,0,0,16,59110,'Renown Recruit''s, levels 1-9'),
(190101,190611,0,0,17,59110,'Renown Recruit''s, levels 1-9'),
(190101,190706,0,0,18,59110,'Renown Recruit''s, levels 1-9'),
(190101,190707,0,0,19,59110,'Renown Recruit''s, levels 1-9'),
(190101,190612,0,0,20,59110,'Renown Recruit''s, levels 1-9'),
(190101,190613,0,0,21,59110,'Renown Recruit''s, levels 1-9'),
(190101,190614,0,0,22,59110,'Renown Recruit''s, levels 1-9'),
(190101,190708,0,0,23,59110,'Renown Recruit''s, levels 1-9'),
(190101,190615,0,0,24,59110,'Renown Recruit''s, levels 1-9'),
(190101,190616,0,0,25,59110,'Renown Recruit''s, levels 1-9'),
(190101,190709,0,0,26,59110,'Renown Recruit''s, levels 1-9'),
(190101,190710,0,0,27,59110,'Renown Recruit''s, levels 1-9'),
(190101,190617,0,0,28,59110,'Renown Recruit''s, levels 1-9'),
(190101,190618,0,0,29,59110,'Renown Recruit''s, levels 1-9'),
(190101,190619,0,0,30,59110,'Renown Recruit''s, levels 1-9'),
(190101,190711,0,0,31,59110,'Renown Recruit''s, levels 1-9'),
(190101,190620,0,0,32,59110,'Renown Recruit''s, levels 1-9'),
(190101,190621,0,0,33,59110,'Renown Recruit''s, levels 1-9'),
(190101,190622,0,0,34,59110,'Renown Recruit''s, levels 1-9'),
(190101,190623,0,0,35,59110,'Renown Recruit''s, levels 1-9'),
(190101,190624,0,0,36,59110,'Renown Recruit''s, levels 1-9'),
(190101,190625,0,0,37,59110,'Renown Recruit''s, levels 1-9'),
(190101,190712,0,0,38,59110,'Renown Recruit''s, levels 1-9'),
(190101,190713,0,0,39,59110,'Renown Recruit''s, levels 1-9'),
(190101,190714,0,0,40,59110,'Renown Recruit''s, levels 1-9'),
(190101,190626,0,0,41,59110,'Renown Recruit''s, levels 1-9'),
(190101,190627,0,0,42,59110,'Renown Recruit''s, levels 1-9'),
(190101,190628,0,0,43,59110,'Renown Recruit''s, levels 1-9'),
(190101,190629,0,0,44,59110,'Renown Recruit''s, levels 1-9'),
(190101,190630,0,0,45,59110,'Renown Recruit''s, levels 1-9'),
(190101,190631,0,0,46,59110,'Renown Recruit''s, levels 1-9'),
(190101,190632,0,0,47,59110,'Renown Recruit''s, levels 1-9'),
(190101,190633,0,0,48,59110,'Renown Recruit''s, levels 1-9'),
(190101,190634,0,0,49,59112,'Renown set, levels 10-19, tier 1'),
(190101,190635,0,0,50,59112,'Renown set, levels 10-19, tier 1'),
(190101,190715,0,0,51,59112,'Renown set, levels 10-19, tier 1'),
(190101,190716,0,0,52,59112,'Renown set, levels 10-19, tier 1'),
(190101,190636,0,0,53,59112,'Renown set, levels 10-19, tier 1'),
(190101,190637,0,0,54,59112,'Renown set, levels 10-19, tier 1'),
(190101,190638,0,0,55,59112,'Renown set, levels 10-19, tier 1'),
(190101,190717,0,0,56,59112,'Renown set, levels 10-19, tier 1'),
(190101,190639,0,0,57,59112,'Renown set, levels 10-19, tier 1'),
(190101,190640,0,0,58,59112,'Renown set, levels 10-19, tier 1'),
(190101,190718,0,0,59,59112,'Renown set, levels 10-19, tier 1'),
(190101,190719,0,0,60,59112,'Renown set, levels 10-19, tier 1'),
(190101,190641,0,0,61,59112,'Renown set, levels 10-19, tier 1'),
(190101,190642,0,0,62,59112,'Renown set, levels 10-19, tier 1'),
(190101,190643,0,0,63,59112,'Renown set, levels 10-19, tier 1'),
(190101,190720,0,0,64,59112,'Renown set, levels 10-19, tier 1'),
(190101,190644,0,0,65,59112,'Renown set, levels 10-19, tier 1'),
(190101,190645,0,0,66,59112,'Renown set, levels 10-19, tier 1'),
(190101,190721,0,0,67,59112,'Renown set, levels 10-19, tier 1'),
(190101,190722,0,0,68,59112,'Renown set, levels 10-19, tier 1'),
(190101,190646,0,0,69,59112,'Renown set, levels 10-19, tier 1'),
(190101,190647,0,0,70,59112,'Renown set, levels 10-19, tier 1'),
(190101,190648,0,0,71,59112,'Renown set, levels 10-19, tier 1'),
(190101,190723,0,0,72,59112,'Renown set, levels 10-19, tier 1'),
(190101,190649,0,0,73,59112,'Renown set, levels 10-19, tier 1'),
(190101,190650,0,0,74,59112,'Renown set, levels 10-19, tier 1'),
(190101,190724,0,0,75,59112,'Renown set, levels 10-19, tier 1'),
(190101,190725,0,0,76,59112,'Renown set, levels 10-19, tier 1'),
(190101,190651,0,0,77,59112,'Renown set, levels 10-19, tier 1'),
(190101,190652,0,0,78,59112,'Renown set, levels 10-19, tier 1'),
(190101,190653,0,0,79,59112,'Renown set, levels 10-19, tier 1'),
(190101,190726,0,0,80,59112,'Renown set, levels 10-19, tier 1'),
(190101,190654,0,0,81,59112,'Renown set, levels 10-19, tier 1'),
(190101,190655,0,0,82,59112,'Renown set, levels 10-19, tier 1'),
(190101,190656,0,0,83,59112,'Renown set, levels 10-19, tier 1'),
(190101,190657,0,0,84,59112,'Renown set, levels 10-19, tier 1'),
(190101,190658,0,0,85,59112,'Renown set, levels 10-19, tier 1'),
(190101,190659,0,0,86,59112,'Renown set, levels 10-19, tier 1'),
(190101,190727,0,0,87,59112,'Renown set, levels 10-19, tier 1'),
(190101,190728,0,0,88,59112,'Renown set, levels 10-19, tier 1'),
(190101,190729,0,0,89,59112,'Renown set, levels 10-19, tier 1'),
(190101,190660,0,0,90,59112,'Renown set, levels 10-19, tier 1'),
(190101,190661,0,0,91,59112,'Renown set, levels 10-19, tier 1'),
(190101,190662,0,0,92,59112,'Renown set, levels 10-19, tier 1'),
(190101,190663,0,0,93,59112,'Renown set, levels 10-19, tier 1'),
(190101,190664,0,0,94,59112,'Renown set, levels 10-19, tier 1'),
(190101,190665,0,0,95,59112,'Renown set, levels 10-19, tier 1'),
(190101,190666,0,0,96,59112,'Renown set, levels 10-19, tier 1'),
(190101,190667,0,0,97,59112,'Renown set, levels 10-19, tier 1'),
(190101,191000,0,0,98,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191001,0,0,99,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191002,0,0,100,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191003,0,0,101,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191004,0,0,102,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191005,0,0,103,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191006,0,0,104,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191007,0,0,105,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191008,0,0,106,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191009,0,0,107,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191010,0,0,108,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191011,0,0,109,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191012,0,0,110,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191013,0,0,111,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191014,0,0,112,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191015,0,0,113,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191016,0,0,114,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191017,0,0,115,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191018,0,0,116,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191019,0,0,117,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191020,0,0,118,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191021,0,0,119,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191022,0,0,120,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191023,0,0,121,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191024,0,0,122,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191025,0,0,123,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191026,0,0,124,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191027,0,0,125,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191028,0,0,126,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191029,0,0,127,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191030,0,0,128,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191031,0,0,129,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191032,0,0,130,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191033,0,0,131,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191034,0,0,132,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191035,0,0,133,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191036,0,0,134,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191037,0,0,135,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191038,0,0,136,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191039,0,0,137,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191040,0,0,138,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191041,0,0,139,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191042,0,0,140,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191043,0,0,141,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191044,0,0,142,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191045,0,0,143,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191046,0,0,144,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191047,0,0,145,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191048,0,0,146,@rc59153,'Renown set, levels 20-29, tier 2'),
(190101,191100,0,0,147,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191101,0,0,148,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191102,0,0,149,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191103,0,0,150,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191104,0,0,151,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191105,0,0,152,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191106,0,0,153,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191107,0,0,154,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191108,0,0,155,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191109,0,0,156,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191110,0,0,157,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191111,0,0,158,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191112,0,0,159,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191113,0,0,160,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191114,0,0,161,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191115,0,0,162,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191116,0,0,163,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191117,0,0,164,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191118,0,0,165,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191119,0,0,166,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191120,0,0,167,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191121,0,0,168,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191122,0,0,169,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191123,0,0,170,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191124,0,0,171,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191125,0,0,172,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191126,0,0,173,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191127,0,0,174,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191128,0,0,175,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191129,0,0,176,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191130,0,0,177,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191131,0,0,178,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191132,0,0,179,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191133,0,0,180,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191134,0,0,181,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191135,0,0,182,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191136,0,0,183,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191137,0,0,184,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191138,0,0,185,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191139,0,0,186,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191140,0,0,187,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191141,0,0,188,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191142,0,0,189,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191143,0,0,190,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191144,0,0,191,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191145,0,0,192,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191146,0,0,193,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191147,0,0,194,@rc59157,'Renown set, levels 30-39, tier 3'),
(190101,191148,0,0,195,@rc59157,'Renown set, levels 30-39, tier 3'),
(190109,191200,0,0,0,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191201,0,0,1,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191202,0,0,2,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191203,0,0,3,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191204,0,0,4,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191205,0,0,5,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191206,0,0,6,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191207,0,0,7,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191208,0,0,8,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191209,0,0,9,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191210,0,0,10,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191211,0,0,11,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191212,0,0,12,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191213,0,0,13,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191214,0,0,14,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191215,0,0,15,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191216,0,0,16,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191217,0,0,17,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191218,0,0,18,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191219,0,0,19,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191220,0,0,20,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191221,0,0,21,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191222,0,0,22,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191223,0,0,23,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191224,0,0,24,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191225,0,0,25,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191226,0,0,26,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191227,0,0,27,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191228,0,0,28,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191229,0,0,29,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191230,0,0,30,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191231,0,0,31,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191232,0,0,32,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191233,0,0,33,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191234,0,0,34,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191235,0,0,35,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191236,0,0,36,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191237,0,0,37,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191238,0,0,38,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191239,0,0,39,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191240,0,0,40,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191241,0,0,41,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191242,0,0,42,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191243,0,0,43,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191244,0,0,44,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191245,0,0,45,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191246,0,0,46,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191247,0,0,47,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191248,0,0,48,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191249,0,0,49,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191250,0,0,50,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191251,0,0,51,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191252,0,0,52,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191253,0,0,53,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191254,0,0,54,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191255,0,0,55,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191256,0,0,56,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191257,0,0,57,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191258,0,0,58,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191259,0,0,59,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191260,0,0,60,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191261,0,0,61,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191262,0,0,62,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191263,0,0,63,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191264,0,0,64,@rc59161,'Renown set, levels 40-49, tier 4'),
(190109,191300,0,0,65,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191301,0,0,66,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191302,0,0,67,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191303,0,0,68,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191304,0,0,69,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191305,0,0,70,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191306,0,0,71,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191307,0,0,72,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191308,0,0,73,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191309,0,0,74,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191310,0,0,75,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191311,0,0,76,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191312,0,0,77,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191313,0,0,78,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191314,0,0,79,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191315,0,0,80,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191316,0,0,81,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191317,0,0,82,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191318,0,0,83,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191319,0,0,84,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191320,0,0,85,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191321,0,0,86,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191322,0,0,87,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191323,0,0,88,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191324,0,0,89,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191325,0,0,90,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191326,0,0,91,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191327,0,0,92,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191328,0,0,93,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191329,0,0,94,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191330,0,0,95,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191331,0,0,96,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191332,0,0,97,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191333,0,0,98,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191334,0,0,99,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191335,0,0,100,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191336,0,0,101,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191337,0,0,102,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191338,0,0,103,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191339,0,0,104,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191340,0,0,105,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191341,0,0,106,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191342,0,0,107,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191343,0,0,108,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191344,0,0,109,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191345,0,0,110,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191346,0,0,111,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191347,0,0,112,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191348,0,0,113,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191349,0,0,114,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191350,0,0,115,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191351,0,0,116,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191352,0,0,117,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191353,0,0,118,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191354,0,0,119,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191355,0,0,120,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191356,0,0,121,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191357,0,0,122,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191358,0,0,123,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191359,0,0,124,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191360,0,0,125,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191361,0,0,126,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191362,0,0,127,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191363,0,0,128,@rc59165,'Renown set, levels 50-59, tier 5'),
(190109,191364,0,0,129,@rc59165,'Renown set, levels 50-59, tier 5'),
(190101,19505,0,0,196,@rc59169,'WSG reward, tier 3'),
(190101,20425,0,0,197,@rc59172,'WSG reward, tier 1'),
(190101,20426,0,0,198,@rc59172,'WSG reward, tier 1'),
(190101,20427,0,0,199,@rc59172,'WSG reward, tier 1'),
(190101,20429,0,0,200,@rc59172,'WSG reward, tier 1'),
(190101,20430,0,0,201,@rc59172,'WSG reward, tier 1'),
(190101,20437,0,0,202,@rc59172,'WSG reward, tier 1'),
(190101,20441,0,0,203,@rc59172,'WSG reward, tier 1'),
(190101,20442,0,0,204,@rc59172,'WSG reward, tier 1'),
(190101,21566,0,0,205,@rc59172,'WSG reward, tier 1'),
(190101,21568,0,0,206,@rc59172,'WSG reward, tier 1'),
(190101,19062,0,0,207,59102,'WSG consumable, tier 2'),
(190101,19068,0,0,208,59102,'WSG consumable, tier 2'),
(190101,19513,0,0,209,@rc59176,'WSG reward, tier 2'),
(190101,19521,0,0,210,@rc59176,'WSG reward, tier 2'),
(190101,19529,0,0,211,@rc59176,'WSG reward, tier 2'),
(190101,19537,0,0,212,@rc59176,'WSG reward, tier 2'),
(190101,19545,0,0,213,@rc59176,'WSG reward, tier 2'),
(190101,19553,0,0,214,@rc59176,'WSG reward, tier 2'),
(190101,19561,0,0,215,@rc59176,'WSG reward, tier 2'),
(190101,19569,0,0,216,@rc59176,'WSG reward, tier 2'),
(190101,17349,0,0,217,59103,'WSG consumable, tier 3'),
(190101,17352,0,0,218,59103,'WSG consumable, tier 3'),
(190101,19061,0,0,219,59103,'WSG consumable, tier 3'),
(190101,19067,0,0,220,59103,'WSG consumable, tier 3'),
(190101,19512,0,0,221,@rc59169,'WSG reward, tier 3'),
(190101,19520,0,0,222,@rc59169,'WSG reward, tier 3'),
(190101,19528,0,0,223,@rc59169,'WSG reward, tier 3'),
(190101,19536,0,0,224,@rc59169,'WSG reward, tier 3'),
(190101,19544,0,0,225,@rc59169,'WSG reward, tier 3'),
(190101,19552,0,0,226,@rc59169,'WSG reward, tier 3'),
(190101,19560,0,0,227,@rc59169,'WSG reward, tier 3'),
(190101,19568,0,0,228,@rc59169,'WSG reward, tier 3'),
(190109,19581,0,0,130,@rc59180,'WSG reward, tier 4'),
(190109,19584,0,0,131,@rc59180,'WSG reward, tier 4'),
(190109,19590,0,0,132,@rc59180,'WSG reward, tier 4'),
(190109,19597,0,0,133,@rc59180,'WSG reward, tier 4'),
(190109,21565,0,0,134,@rc59180,'WSG reward, tier 4'),
(190109,21567,0,0,135,@rc59180,'WSG reward, tier 4'),
(190101,17348,0,0,229,59104,'WSG consumable, tier 4'),
(190101,17351,0,0,230,59104,'WSG consumable, tier 4'),
(190101,19060,0,0,231,59104,'WSG consumable, tier 4'),
(190101,19066,0,0,232,59104,'WSG consumable, tier 4'),
(190109,19511,0,0,136,@rc59180,'WSG reward, tier 4'),
(190109,19519,0,0,137,@rc59180,'WSG reward, tier 4'),
(190109,19527,0,0,138,@rc59180,'WSG reward, tier 4'),
(190109,19535,0,0,139,@rc59180,'WSG reward, tier 4'),
(190109,19543,0,0,140,@rc59180,'WSG reward, tier 4'),
(190109,19551,0,0,141,@rc59180,'WSG reward, tier 4'),
(190109,19559,0,0,142,@rc59180,'WSG reward, tier 4'),
(190109,19567,0,0,143,@rc59180,'WSG reward, tier 4'),
(190109,19580,0,0,144,@rc59182,'WSG reward, tier 5'),
(190109,19583,0,0,145,@rc59182,'WSG reward, tier 5'),
(190109,19589,0,0,146,@rc59182,'WSG reward, tier 5'),
(190109,19596,0,0,147,@rc59182,'WSG reward, tier 5'),
(190109,19510,0,0,148,@rc59182,'WSG reward, tier 5'),
(190109,19518,0,0,149,@rc59182,'WSG reward, tier 5'),
(190109,19526,0,0,150,@rc59182,'WSG reward, tier 5'),
(190109,19534,0,0,151,@rc59182,'WSG reward, tier 5'),
(190109,19542,0,0,152,@rc59182,'WSG reward, tier 5'),
(190109,19550,0,0,153,@rc59182,'WSG reward, tier 5'),
(190109,19558,0,0,154,@rc59182,'WSG reward, tier 5'),
(190109,19566,0,0,155,@rc59182,'WSG reward, tier 5'),
(190109,19578,0,0,156,@rc59183,'WSG reward, tier 6'),
(190109,19582,0,0,157,@rc59183,'WSG reward, tier 6'),
(190109,19587,0,0,158,@rc59183,'WSG reward, tier 6'),
(190109,19595,0,0,159,@rc59183,'WSG reward, tier 6'),
(190109,22651,0,0,160,@rc59183,'WSG reward, tier 6'),
(190109,22673,0,0,161,@rc59183,'WSG reward, tier 6'),
(190109,22676,0,0,162,@rc59183,'WSG reward, tier 6'),
(190109,22740,0,0,163,@rc59183,'WSG reward, tier 6'),
(190109,22741,0,0,164,@rc59183,'WSG reward, tier 6'),
(190109,22747,0,0,165,@rc59183,'WSG reward, tier 6'),
(190101,20152,0,0,233,@rc59176,'AB reward, tier 2'),
(190101,20157,0,0,234,@rc59176,'AB reward, tier 2'),
(190101,20162,0,0,235,@rc59176,'AB reward, tier 2'),
(190101,20164,0,0,236,@rc59176,'AB reward, tier 2'),
(190101,20169,0,0,237,@rc59176,'AB reward, tier 2'),
(190101,20172,0,0,238,@rc59176,'AB reward, tier 2'),
(190101,20188,0,0,239,@rc59176,'AB reward, tier 2'),
(190101,20191,0,0,240,@rc59176,'AB reward, tier 2'),
(190101,20197,0,0,241,@rc59176,'AB reward, tier 2'),
(190101,20201,0,0,242,@rc59176,'AB reward, tier 2'),
(190101,20207,0,0,243,@rc59176,'AB reward, tier 2'),
(190101,20210,0,0,244,@rc59176,'AB reward, tier 2'),
(190101,21120,0,0,245,@rc59176,'AB reward, tier 2'),
(190101,20161,0,0,246,@rc59169,'AB reward, tier 3'),
(190101,20166,0,0,247,@rc59169,'AB reward, tier 3'),
(190101,20168,0,0,248,@rc59169,'AB reward, tier 3'),
(190101,20173,0,0,249,@rc59169,'AB reward, tier 3'),
(190101,20187,0,0,250,@rc59169,'AB reward, tier 3'),
(190101,20192,0,0,251,@rc59169,'AB reward, tier 3'),
(190101,21116,0,0,252,@rc59169,'AB reward, tier 3'),
(190109,20153,0,0,166,@rc59180,'AB reward, tier 4'),
(190109,20156,0,0,167,@rc59180,'AB reward, tier 4'),
(190109,20198,0,0,168,@rc59180,'AB reward, tier 4'),
(190109,20200,0,0,169,@rc59180,'AB reward, tier 4'),
(190109,20206,0,0,170,@rc59180,'AB reward, tier 4'),
(190109,20209,0,0,171,@rc59180,'AB reward, tier 4'),
(190109,20151,0,0,172,@rc59180,'AB reward, tier 4'),
(190109,20155,0,0,173,@rc59180,'AB reward, tier 4'),
(190109,20160,0,0,174,@rc59180,'AB reward, tier 4'),
(190109,20165,0,0,175,@rc59180,'AB reward, tier 4'),
(190109,20170,0,0,176,@rc59180,'AB reward, tier 4'),
(190109,20174,0,0,177,@rc59180,'AB reward, tier 4'),
(190109,20189,0,0,178,@rc59180,'AB reward, tier 4'),
(190109,20193,0,0,179,@rc59180,'AB reward, tier 4'),
(190109,20196,0,0,180,@rc59180,'AB reward, tier 4'),
(190109,20202,0,0,181,@rc59180,'AB reward, tier 4'),
(190109,20205,0,0,182,@rc59180,'AB reward, tier 4'),
(190109,20211,0,0,183,@rc59180,'AB reward, tier 4'),
(190109,21115,0,0,184,@rc59180,'AB reward, tier 4'),
(190111,20072,0,0,0,@rc59185,'AB reward, tier 7'),
(190111,20150,0,0,1,@rc59185,'AB reward, tier 7'),
(190111,20154,0,0,2,@rc59185,'AB reward, tier 7'),
(190111,20159,0,0,3,@rc59185,'AB reward, tier 7'),
(190111,20163,0,0,4,@rc59185,'AB reward, tier 7'),
(190111,20167,0,0,5,@rc59185,'AB reward, tier 7'),
(190111,20171,0,0,6,@rc59185,'AB reward, tier 7'),
(190111,20186,0,0,7,@rc59185,'AB reward, tier 7'),
(190111,20190,0,0,8,@rc59185,'AB reward, tier 7'),
(190111,20195,0,0,9,@rc59185,'AB reward, tier 7'),
(190111,20199,0,0,10,@rc59185,'AB reward, tier 7'),
(190111,20204,0,0,11,@rc59185,'AB reward, tier 7'),
(190111,20208,0,0,12,@rc59185,'AB reward, tier 7'),
(190111,20068,0,0,13,@rc59185,'AB reward, tier 7'),
(190111,20158,0,0,14,@rc59185,'AB reward, tier 7'),
(190111,20175,0,0,15,@rc59185,'AB reward, tier 7'),
(190111,20176,0,0,16,@rc59185,'AB reward, tier 7'),
(190111,20194,0,0,17,@rc59185,'AB reward, tier 7'),
(190111,20203,0,0,18,@rc59185,'AB reward, tier 7'),
(190111,20212,0,0,19,@rc59185,'AB reward, tier 7'),
(190111,20214,0,0,20,@rc59185,'AB reward, tier 7'),
(190111,20220,0,0,21,@rc59185,'AB reward, tier 7'),
(190111,19099,0,0,22,@rc59186,'AV reward, tier 8'),
(190111,19100,0,0,23,@rc59186,'AV reward, tier 8'),
(190111,19102,0,0,24,@rc59186,'AV reward, tier 8'),
(190111,19103,0,0,25,@rc59186,'AV reward, tier 8'),
(190111,19104,0,0,26,@rc59186,'AV reward, tier 8'),
(190111,19106,0,0,27,@rc59186,'AV reward, tier 8'),
(190111,19107,0,0,28,@rc59186,'AV reward, tier 8'),
(190111,19108,0,0,29,@rc59186,'AV reward, tier 8'),
(190111,20648,0,0,30,@rc59186,'AV reward, tier 8'),
(190111,19105,0,0,31,@rc59186,'AV reward, tier 8'),
(190111,19325,0,0,32,@rc59186,'AV reward, tier 8'),
(190111,19308,0,0,33,@rc59186,'AV reward, tier 8'),
(190111,19309,0,0,34,@rc59186,'AV reward, tier 8'),
(190111,19310,0,0,35,@rc59186,'AV reward, tier 8'),
(190111,19311,0,0,36,@rc59186,'AV reward, tier 8'),
(190111,19312,0,0,37,@rc59186,'AV reward, tier 8'),
(190111,19315,0,0,38,@rc59186,'AV reward, tier 8'),
(190111,19323,0,0,39,@rc59186,'AV reward, tier 8'),
(190111,19321,0,0,40,@rc59186,'AV reward, tier 8'),
(190111,19324,0,0,41,@rc59186,'AV reward, tier 8'),
(190111,19319,0,0,42,@rc59186,'AV reward, tier 8'),
(190111,19320,0,0,43,@rc59186,'AV reward, tier 8'),
(190111,19083,0,0,44,@rc59186,'AV reward, tier 8'),
(190111,19085,0,0,45,@rc59186,'AV reward, tier 8'),
(190111,19087,0,0,46,@rc59186,'AV reward, tier 8'),
(190111,19088,0,0,47,@rc59186,'AV reward, tier 8'),
(190111,19089,0,0,48,@rc59186,'AV reward, tier 8'),
(190111,19090,0,0,49,@rc59186,'AV reward, tier 8'),
(190111,19095,0,0,50,@rc59186,'AV reward, tier 8'),
(190111,19096,0,0,51,@rc59186,'AV reward, tier 8'),
(190111,22843,0,0,52,@rc59186,'PvP rank set, tier 8'),
(190111,22852,0,0,53,@rc59186,'PvP rank set, tier 8'),
(190111,22855,0,0,54,@rc59186,'PvP rank set, tier 8'),
(190111,22856,0,0,55,@rc59186,'PvP rank set, tier 8'),
(190111,22857,0,0,56,@rc59186,'PvP rank set, tier 8'),
(190111,22858,0,0,57,@rc59186,'PvP rank set, tier 8'),
(190111,22859,0,0,58,@rc59186,'PvP rank set, tier 8'),
(190111,22860,0,0,59,@rc59186,'PvP rank set, tier 8'),
(190111,22862,0,0,60,@rc59186,'PvP rank set, tier 8'),
(190111,22863,0,0,61,@rc59186,'PvP rank set, tier 8'),
(190111,22864,0,0,62,@rc59186,'PvP rank set, tier 8'),
(190111,22865,0,0,63,@rc59186,'PvP rank set, tier 8'),
(190111,22867,0,0,64,@rc59186,'PvP rank set, tier 8'),
(190111,22868,0,0,65,@rc59186,'PvP rank set, tier 8'),
(190111,22869,0,0,66,@rc59186,'PvP rank set, tier 8'),
(190111,22870,0,0,67,@rc59186,'PvP rank set, tier 8'),
(190111,22872,0,0,68,@rc59186,'PvP rank set, tier 8'),
(190111,22873,0,0,69,@rc59186,'PvP rank set, tier 8'),
(190111,22874,0,0,70,@rc59186,'PvP rank set, tier 8'),
(190111,22875,0,0,71,@rc59186,'PvP rank set, tier 8'),
(190111,22876,0,0,72,@rc59186,'PvP rank set, tier 8'),
(190111,22877,0,0,73,@rc59186,'PvP rank set, tier 8'),
(190111,22878,0,0,74,@rc59186,'PvP rank set, tier 8'),
(190111,22879,0,0,75,@rc59186,'PvP rank set, tier 8'),
(190111,22880,0,0,76,@rc59186,'PvP rank set, tier 8'),
(190111,22881,0,0,77,@rc59186,'PvP rank set, tier 8'),
(190111,22882,0,0,78,@rc59186,'PvP rank set, tier 8'),
(190111,22883,0,0,79,@rc59186,'PvP rank set, tier 8'),
(190111,22884,0,0,80,@rc59186,'PvP rank set, tier 8'),
(190111,22885,0,0,81,@rc59186,'PvP rank set, tier 8'),
(190111,22886,0,0,82,@rc59186,'PvP rank set, tier 8'),
(190111,22887,0,0,83,@rc59186,'PvP rank set, tier 8'),
(190111,23243,0,0,84,@rc59186,'PvP rank set, tier 8'),
(190111,23244,0,0,85,@rc59186,'PvP rank set, tier 8'),
(190111,23251,0,0,86,@rc59186,'PvP rank set, tier 8'),
(190111,23252,0,0,87,@rc59186,'PvP rank set, tier 8'),
(190111,23253,0,0,88,@rc59186,'PvP rank set, tier 8'),
(190111,23254,0,0,89,@rc59186,'PvP rank set, tier 8'),
(190111,23255,0,0,90,@rc59186,'PvP rank set, tier 8'),
(190111,23256,0,0,91,@rc59186,'PvP rank set, tier 8'),
(190111,23257,0,0,92,@rc59186,'PvP rank set, tier 8'),
(190111,23258,0,0,93,@rc59186,'PvP rank set, tier 8'),
(190111,23259,0,0,94,@rc59186,'PvP rank set, tier 8'),
(190111,23260,0,0,95,@rc59186,'PvP rank set, tier 8'),
(190111,23261,0,0,96,@rc59186,'PvP rank set, tier 8'),
(190111,23262,0,0,97,@rc59186,'PvP rank set, tier 8'),
(190111,23263,0,0,98,@rc59186,'PvP rank set, tier 8'),
(190111,23264,0,0,99,@rc59186,'PvP rank set, tier 8'),
(190111,16534,0,0,100,@rc59187,'PvP rank set, tier 9'),
(190111,16539,0,0,101,@rc59187,'PvP rank set, tier 9'),
(190111,16540,0,0,102,@rc59187,'PvP rank set, tier 9'),
(190111,16543,0,0,103,@rc59187,'PvP rank set, tier 9'),
(190111,16545,0,0,104,@rc59187,'PvP rank set, tier 9'),
(190111,16548,0,0,105,@rc59187,'PvP rank set, tier 9'),
(190111,16552,0,0,106,@rc59187,'PvP rank set, tier 9'),
(190111,16554,0,0,107,@rc59187,'PvP rank set, tier 9'),
(190111,16555,0,0,108,@rc59187,'PvP rank set, tier 9'),
(190111,16558,0,0,109,@rc59187,'PvP rank set, tier 9'),
(190111,16560,0,0,110,@rc59187,'PvP rank set, tier 9'),
(190111,16564,0,0,111,@rc59187,'PvP rank set, tier 9'),
(190111,16567,0,0,112,@rc59187,'PvP rank set, tier 9'),
(190111,16569,0,0,113,@rc59187,'PvP rank set, tier 9'),
(190111,16571,0,0,114,@rc59187,'PvP rank set, tier 9'),
(190111,16573,0,0,115,@rc59187,'PvP rank set, tier 9'),
(190111,16574,0,0,116,@rc59187,'PvP rank set, tier 9'),
(190111,16579,0,0,117,@rc59187,'PvP rank set, tier 9'),
(190111,17586,0,0,118,@rc59187,'PvP rank set, tier 9'),
(190111,17588,0,0,119,@rc59187,'PvP rank set, tier 9'),
(190111,17593,0,0,120,@rc59187,'PvP rank set, tier 9'),
(190111,17618,0,0,121,@rc59187,'PvP rank set, tier 9'),
(190111,17620,0,0,122,@rc59187,'PvP rank set, tier 9'),
(190111,17625,0,0,123,@rc59187,'PvP rank set, tier 9'),
(190111,16533,0,0,124,@rc59187,'PvP rank set, tier 9'),
(190111,16535,0,0,125,@rc59187,'PvP rank set, tier 9'),
(190111,16536,0,0,126,@rc59187,'PvP rank set, tier 9'),
(190111,16541,0,0,127,@rc59187,'PvP rank set, tier 9'),
(190111,16542,0,0,128,@rc59187,'PvP rank set, tier 9'),
(190111,16544,0,0,129,@rc59187,'PvP rank set, tier 9'),
(190111,16549,0,0,130,@rc59187,'PvP rank set, tier 9'),
(190111,16550,0,0,131,@rc59187,'PvP rank set, tier 9'),
(190111,16551,0,0,132,@rc59187,'PvP rank set, tier 9'),
(190111,16561,0,0,133,@rc59187,'PvP rank set, tier 9'),
(190111,16562,0,0,134,@rc59187,'PvP rank set, tier 9'),
(190111,16563,0,0,135,@rc59187,'PvP rank set, tier 9'),
(190111,16565,0,0,136,@rc59187,'PvP rank set, tier 9'),
(190111,16566,0,0,137,@rc59187,'PvP rank set, tier 9'),
(190111,16568,0,0,138,@rc59187,'PvP rank set, tier 9'),
(190111,16577,0,0,139,@rc59187,'PvP rank set, tier 9'),
(190111,16578,0,0,140,@rc59187,'PvP rank set, tier 9'),
(190111,16580,0,0,141,@rc59187,'PvP rank set, tier 9'),
(190111,17590,0,0,142,@rc59187,'PvP rank set, tier 9'),
(190111,17591,0,0,143,@rc59187,'PvP rank set, tier 9'),
(190111,17592,0,0,144,@rc59187,'PvP rank set, tier 9'),
(190111,17622,0,0,145,@rc59187,'PvP rank set, tier 9'),
(190111,17623,0,0,146,@rc59187,'PvP rank set, tier 9'),
(190111,17624,0,0,147,@rc59187,'PvP rank set, tier 9');

-- Renown prices: read by the Renown server module (paid with spendable Renown points, not gold).
-- Gold price is 0 so the client never blocks the purchase for lack of money; the RenownBar addon shows the Renown cost.
-- tier: Renown reward tier that unlocks the item (0 = no insignia needed); also used for battleground loot bags
DROP TABLE IF EXISTS custom_renown_vendor;
CREATE TABLE custom_renown_vendor (item MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY, cost INT UNSIGNED NOT NULL DEFAULT 0, tier TINYINT UNSIGNED NOT NULL DEFAULT 0) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Renown vendor prices';
INSERT INTO custom_renown_vendor (item,cost,tier) VALUES
(16437,4500,9),
(16440,4500,9),
(16441,5400,9),
(16442,6000,9),
(16443,6000,9),
(16444,5400,9),
(16446,4500,9),
(16448,4500,9),
(16449,5400,9),
(16450,6000,9),
(16451,5400,9),
(16452,6000,9),
(16453,6000,9),
(16454,4500,9),
(16455,5400,9),
(16456,6000,9),
(16457,5400,9),
(16459,4500,9),
(16462,4500,9),
(16463,4500,9),
(16465,5400,9),
(16466,6000,9),
(16467,6000,9),
(16468,5400,9),
(16471,4500,9),
(16472,4500,9),
(16473,6000,9),
(16474,5400,9),
(16475,6000,9),
(16476,5400,9),
(16477,6000,9),
(16478,5400,9),
(16479,6000,9),
(16480,5400,9),
(16483,4500,9),
(16484,4500,9),
(16533,5400,9),
(16534,6000,9),
(16535,6000,9),
(16536,5400,9),
(16539,4500,9),
(16540,4500,9),
(16541,6000,9),
(16542,5400,9),
(16543,6000,9),
(16544,5400,9),
(16545,4500,9),
(16548,4500,9),
(16549,6000,9),
(16550,5400,9),
(16551,5400,9),
(16552,6000,9),
(16554,4500,9),
(16555,4500,9),
(16558,4500,9),
(16560,4500,9),
(16561,5400,9),
(16562,5400,9),
(16563,6000,9),
(16564,6000,9),
(16565,6000,9),
(16566,5400,9),
(16567,6000,9),
(16568,5400,9),
(16569,4500,9),
(16571,4500,9),
(16573,4500,9),
(16574,4500,9),
(16577,6000,9),
(16578,5400,9),
(16579,6000,9),
(16580,5400,9),
(17578,5400,9),
(17579,6000,9),
(17580,5400,9),
(17581,6000,9),
(17583,4500,9),
(17584,4500,9),
(17586,4500,9),
(17588,4500,9),
(17590,5400,9),
(17591,5400,9),
(17592,6000,9),
(17593,6000,9),
(17602,5400,9),
(17603,6000,9),
(17604,5400,9),
(17605,6000,9),
(17607,4500,9),
(17608,4500,9),
(17618,4500,9),
(17620,4500,9),
(17622,5400,9),
(17623,5400,9),
(17624,6000,9),
(17625,6000,9),
(19083,2100,8),
(19084,2100,8),
(19085,2100,8),
(19086,2100,8),
(19087,2625,8),
(19088,2625,8),
(19089,2625,8),
(19090,2625,8),
(19091,2625,8),
(19092,2625,8),
(19093,2625,8),
(19094,2625,8),
(19095,2100,8),
(19096,2100,8),
(19097,2100,8),
(19098,2100,8),
(19099,2800,8),
(19100,2800,8),
(19102,3500,8),
(19103,2800,8),
(19104,2800,8),
(19105,3150,8),
(19106,3500,8),
(19107,2100,8),
(19108,2100,8),
(19308,2100,8),
(19309,2100,8),
(19310,2100,8),
(19311,2100,8),
(19312,2100,8),
(19315,2100,8),
(19319,2450,8),
(19320,2450,8),
(19321,2100,8),
(19323,3500,8),
(19324,2800,8),
(19325,2100,8),
(19505,500,3),
(19506,500,3),
(19510,1080,5),
(19511,840,4),
(19512,600,3),
(19513,450,2),
(19514,1080,5),
(19515,600,3),
(19516,840,4),
(19517,450,2),
(19518,1080,5),
(19519,840,4),
(19520,600,3),
(19521,450,2),
(19522,1080,5),
(19523,840,4),
(19524,600,3),
(19525,450,2),
(19526,1080,5),
(19527,840,4),
(19528,600,3),
(19529,450,2),
(19530,1080,5),
(19531,840,4),
(19532,600,3),
(19533,450,2),
(19534,1080,5),
(19535,840,4),
(19536,600,3),
(19537,450,2),
(19538,1080,5),
(19539,840,4),
(19540,600,3),
(19541,450,2),
(19542,1440,5),
(19543,1120,4),
(19544,800,3),
(19545,600,2),
(19546,1440,5),
(19547,1120,4),
(19548,800,3),
(19549,600,2),
(19550,1440,5),
(19551,1120,4),
(19552,800,3),
(19553,600,2),
(19554,1440,5),
(19555,1120,4),
(19556,800,3),
(19557,600,2),
(19558,1080,5),
(19559,840,4),
(19560,600,3),
(19561,450,2),
(19562,1080,5),
(19563,840,4),
(19564,600,3),
(19565,450,2),
(19566,1800,5),
(19567,1400,4),
(19568,1000,3),
(19569,750,2),
(19570,1800,5),
(19571,1400,4),
(19572,1000,3),
(19573,750,2),
(19578,1250,6),
(19580,900,5),
(19581,700,4),
(19582,1250,6),
(19583,900,5),
(19584,700,4),
(19587,1250,6),
(19589,900,5),
(19590,700,4),
(19595,1250,6),
(19596,900,5),
(19597,700,4),
(20041,2250,7),
(20042,2250,7),
(20043,2250,7),
(20044,2250,7),
(20045,2250,7),
(20046,2250,7),
(20047,2250,7),
(20048,2250,7),
(20049,2250,7),
(20050,2250,7),
(20051,2250,7),
(20052,2250,7),
(20053,2250,7),
(20054,2250,7),
(20055,2700,7),
(20056,2700,7),
(20057,2700,7),
(20058,2700,7),
(20059,2700,7),
(20060,2700,7),
(20061,2700,7),
(20068,1800,7),
(20069,3000,7),
(20070,2400,7),
(20071,1800,7),
(20072,1800,7),
(20073,1800,7),
(20088,1050,4),
(20089,1050,4),
(20090,560,2),
(20091,1050,4),
(20092,1050,4),
(20093,560,2),
(20094,1050,4),
(20095,750,3),
(20096,560,2),
(20097,1050,4),
(20098,750,3),
(20099,560,2),
(20100,1050,4),
(20101,750,3),
(20102,560,2),
(20103,1050,4),
(20104,750,3),
(20105,560,2),
(20106,1050,4),
(20107,1050,4),
(20108,560,2),
(20109,1050,4),
(20110,1050,4),
(20111,560,2),
(20112,1050,4),
(20113,750,3),
(20114,560,2),
(20115,1050,4),
(20116,750,3),
(20117,560,2),
(20118,1050,4),
(20119,1050,4),
(20120,560,2),
(20121,1050,4),
(20122,1050,4),
(20123,560,2),
(20124,1050,4),
(20125,1050,4),
(20126,560,2),
(20127,1050,4),
(20128,1050,4),
(20129,560,2),
(20150,2250,7),
(20151,1050,4),
(20152,560,2),
(20153,1050,4),
(20154,2250,7),
(20155,1050,4),
(20156,1050,4),
(20157,560,2),
(20158,2700,7),
(20159,2250,7),
(20160,1050,4),
(20161,750,3),
(20162,560,2),
(20163,2250,7),
(20164,560,2),
(20165,1050,4),
(20166,750,3),
(20167,2250,7),
(20168,750,3),
(20169,560,2),
(20170,1050,4),
(20171,2250,7),
(20172,560,2),
(20173,750,3),
(20174,1050,4),
(20175,2700,7),
(20176,2700,7),
(20186,2250,7),
(20187,750,3),
(20188,560,2),
(20189,1050,4),
(20190,2250,7),
(20191,560,2),
(20192,750,3),
(20193,1050,4),
(20194,2700,7),
(20195,2250,7),
(20196,1050,4),
(20197,560,2),
(20198,1050,4),
(20199,2250,7),
(20200,1050,4),
(20201,560,2),
(20202,1050,4),
(20203,2700,7),
(20204,2250,7),
(20205,1050,4),
(20206,1050,4),
(20207,560,2),
(20208,2250,7),
(20209,1050,4),
(20210,560,2),
(20211,1050,4),
(20212,2700,7),
(20214,2400,7),
(20220,3000,7),
(20425,500,1),
(20426,300,1),
(20427,300,1),
(20428,300,1),
(20429,300,1),
(20430,400,1),
(20431,300,1),
(20434,500,1),
(20437,300,1),
(20438,300,1),
(20439,300,1),
(20440,400,1),
(20441,400,1),
(20442,300,1),
(20443,400,1),
(20444,300,1),
(20648,2800,8),
(21115,840,4),
(21116,600,3),
(21117,840,4),
(21118,600,3),
(21119,450,2),
(21120,450,2),
(21565,840,4),
(21566,300,1),
(21567,840,4),
(21568,300,1),
(22651,2500,6),
(22672,2500,6),
(22673,2500,6),
(22676,2500,6),
(22740,2500,6),
(22741,2500,6),
(22747,2500,6),
(22748,2500,6),
(22749,2500,6),
(22750,2500,6),
(22752,2500,6),
(22753,2500,6),
(22843,2625,8),
(22852,2625,8),
(22855,2625,8),
(22856,2625,8),
(22857,2625,8),
(22858,2625,8),
(22859,2625,8),
(22860,2625,8),
(22862,2625,8),
(22863,2625,8),
(22864,2625,8),
(22865,2625,8),
(22867,2625,8),
(22868,2625,8),
(22869,2625,8),
(22870,2625,8),
(22872,3500,8),
(22873,3500,8),
(22874,3500,8),
(22875,3500,8),
(22876,3500,8),
(22877,3500,8),
(22878,3500,8),
(22879,3500,8),
(22880,3500,8),
(22881,3500,8),
(22882,3500,8),
(22883,3500,8),
(22884,3500,8),
(22885,3500,8),
(22886,3500,8),
(22887,3500,8),
(23243,3150,8),
(23244,3150,8),
(23251,3150,8),
(23252,3150,8),
(23253,3150,8),
(23254,3150,8),
(23255,3150,8),
(23256,3150,8),
(23257,3150,8),
(23258,3150,8),
(23259,3150,8),
(23260,3150,8),
(23261,3150,8),
(23262,3150,8),
(23263,3150,8),
(23264,3150,8),
(23272,3500,8),
(23273,3500,8),
(23274,2625,8),
(23275,2625,8),
(23276,3150,8),
(23277,3150,8),
(23278,2625,8),
(23279,2625,8),
(23280,2625,8),
(23281,2625,8),
(23282,2625,8),
(23283,2625,8),
(23284,2625,8),
(23285,2625,8),
(23286,2625,8),
(23287,2625,8),
(23288,2625,8),
(23289,2625,8),
(23290,2625,8),
(23291,2625,8),
(23292,3500,8),
(23293,3500,8),
(23294,3500,8),
(23295,3500,8),
(23296,3500,8),
(23297,3500,8),
(23298,3500,8),
(23299,3500,8),
(23300,3500,8),
(23301,3500,8),
(23302,3500,8),
(23303,3500,8),
(23304,3500,8),
(23305,3500,8),
(23306,3150,8),
(23307,3150,8),
(23308,3150,8),
(23309,3150,8),
(23310,3150,8),
(23311,3150,8),
(23312,3150,8),
(23313,3150,8),
(23314,3150,8),
(23315,3150,8),
(23316,3150,8),
(23317,3150,8),
(23318,3150,8),
(23319,3150,8),
(190600,300,0),
(190601,300,0),
(190602,225,0),
(190603,225,0),
(190604,225,0),
(190605,300,0),
(190606,300,0),
(190607,225,0),
(190608,225,0),
(190609,225,0),
(190610,300,0),
(190611,300,0),
(190612,225,0),
(190613,225,0),
(190614,225,0),
(190615,300,0),
(190616,300,0),
(190617,225,0),
(190618,225,0),
(190619,225,0),
(190620,180,0),
(190621,180,0),
(190622,180,0),
(190623,180,0),
(190624,180,0),
(190625,180,0),
(190626,240,0),
(190627,300,0),
(190628,240,0),
(190629,240,0),
(190630,300,0),
(190631,180,0),
(190632,180,0),
(190633,180,0),
(190634,500,1),
(190635,500,1),
(190636,375,1),
(190637,375,1),
(190638,375,1),
(190639,500,1),
(190640,500,1),
(190641,375,1),
(190642,375,1),
(190643,375,1),
(190644,500,1),
(190645,500,1),
(190646,375,1),
(190647,375,1),
(190648,375,1),
(190649,500,1),
(190650,500,1),
(190651,375,1),
(190652,375,1),
(190653,375,1),
(190654,300,1),
(190655,300,1),
(190656,300,1),
(190657,300,1),
(190658,300,1),
(190659,300,1),
(190660,400,1),
(190661,500,1),
(190662,400,1),
(190663,400,1),
(190664,500,1),
(190665,300,1),
(190666,300,1),
(190667,300,1),
(190700,270,0),
(190701,270,0),
(190702,150,0),
(190703,270,0),
(190704,270,0),
(190705,150,0),
(190706,270,0),
(190707,270,0),
(190708,150,0),
(190709,270,0),
(190710,270,0),
(190711,150,0),
(190712,180,0),
(190713,180,0),
(190714,180,0),
(190715,450,1),
(190716,450,1),
(190717,250,1),
(190718,450,1),
(190719,450,1),
(190720,250,1),
(190721,450,1),
(190722,450,1),
(190723,250,1),
(190724,450,1),
(190725,450,1),
(190726,250,1),
(190727,300,1),
(190728,300,1),
(190729,300,1),
(191000,750,2),
(191001,750,2),
(191002,675,2),
(191003,675,2),
(191004,560,2),
(191005,560,2),
(191006,560,2),
(191007,375,2),
(191008,750,2),
(191009,750,2),
(191010,675,2),
(191011,675,2),
(191012,560,2),
(191013,560,2),
(191014,560,2),
(191015,375,2),
(191016,750,2),
(191017,750,2),
(191018,675,2),
(191019,675,2),
(191020,560,2),
(191021,560,2),
(191022,560,2),
(191023,375,2),
(191024,750,2),
(191025,750,2),
(191026,675,2),
(191027,675,2),
(191028,560,2),
(191029,560,2),
(191030,560,2),
(191031,375,2),
(191032,450,2),
(191033,450,2),
(191034,450,2),
(191035,450,2),
(191036,450,2),
(191037,450,2),
(191038,450,2),
(191039,450,2),
(191040,450,2),
(191041,600,2),
(191042,750,2),
(191043,600,2),
(191044,600,2),
(191045,750,2),
(191046,450,2),
(191047,450,2),
(191048,450,2),
(191100,1000,3),
(191101,1000,3),
(191102,900,3),
(191103,900,3),
(191104,750,3),
(191105,750,3),
(191106,750,3),
(191107,500,3),
(191108,1000,3),
(191109,1000,3),
(191110,900,3),
(191111,900,3),
(191112,750,3),
(191113,750,3),
(191114,750,3),
(191115,500,3),
(191116,1000,3),
(191117,1000,3),
(191118,900,3),
(191119,900,3),
(191120,750,3),
(191121,750,3),
(191122,750,3),
(191123,500,3),
(191124,1000,3),
(191125,1000,3),
(191126,900,3),
(191127,900,3),
(191128,750,3),
(191129,750,3),
(191130,750,3),
(191131,500,3),
(191132,600,3),
(191133,600,3),
(191134,600,3),
(191135,600,3),
(191136,600,3),
(191137,600,3),
(191138,600,3),
(191139,600,3),
(191140,600,3),
(191141,800,3),
(191142,1000,3),
(191143,800,3),
(191144,800,3),
(191145,1000,3),
(191146,600,3),
(191147,600,3),
(191148,600,3),
(191200,1400,4),
(191201,1400,4),
(191202,1260,4),
(191203,1260,4),
(191204,1050,4),
(191205,1050,4),
(191206,1050,4),
(191207,700,4),
(191208,1400,4),
(191209,1400,4),
(191210,1260,4),
(191211,1260,4),
(191212,1050,4),
(191213,1050,4),
(191214,1050,4),
(191215,700,4),
(191216,1400,4),
(191217,1400,4),
(191218,1260,4),
(191219,1260,4),
(191220,1050,4),
(191221,1050,4),
(191222,1050,4),
(191223,700,4),
(191224,1400,4),
(191225,1400,4),
(191226,1260,4),
(191227,1260,4),
(191228,1050,4),
(191229,1050,4),
(191230,1050,4),
(191231,700,4),
(191232,1400,4),
(191233,1400,4),
(191234,1260,4),
(191235,1260,4),
(191236,1050,4),
(191237,1050,4),
(191238,1050,4),
(191239,700,4),
(191240,1400,4),
(191241,1400,4),
(191242,1260,4),
(191243,1260,4),
(191244,1050,4),
(191245,1050,4),
(191246,1050,4),
(191247,700,4),
(191248,840,4),
(191249,840,4),
(191250,840,4),
(191251,840,4),
(191252,840,4),
(191253,840,4),
(191254,840,4),
(191255,840,4),
(191256,840,4),
(191257,1120,4),
(191258,1400,4),
(191259,1120,4),
(191260,1120,4),
(191261,1400,4),
(191262,840,4),
(191263,840,4),
(191264,840,4),
(191300,1800,5),
(191301,1800,5),
(191302,1620,5),
(191303,1620,5),
(191304,1350,5),
(191305,1350,5),
(191306,1350,5),
(191307,900,5),
(191308,1800,5),
(191309,1800,5),
(191310,1620,5),
(191311,1620,5),
(191312,1350,5),
(191313,1350,5),
(191314,1350,5),
(191315,900,5),
(191316,1800,5),
(191317,1800,5),
(191318,1620,5),
(191319,1620,5),
(191320,1350,5),
(191321,1350,5),
(191322,1350,5),
(191323,900,5),
(191324,1800,5),
(191325,1800,5),
(191326,1620,5),
(191327,1620,5),
(191328,1350,5),
(191329,1350,5),
(191330,1350,5),
(191331,900,5),
(191332,1800,5),
(191333,1800,5),
(191334,1620,5),
(191335,1620,5),
(191336,1350,5),
(191337,1350,5),
(191338,1350,5),
(191339,900,5),
(191340,1800,5),
(191341,1800,5),
(191342,1620,5),
(191343,1620,5),
(191344,1350,5),
(191345,1350,5),
(191346,1350,5),
(191347,900,5),
(191348,1080,5),
(191349,1080,5),
(191350,1080,5),
(191351,1080,5),
(191352,1080,5),
(191353,1080,5),
(191354,1080,5),
(191355,1080,5),
(191356,1080,5),
(191357,1440,5),
(191358,1800,5),
(191359,1440,5),
(191360,1440,5),
(191361,1800,5),
(191362,1080,5),
(191363,1080,5),
(191364,1080,5);
UPDATE item_template i JOIN custom_renown_vendor c ON c.item=i.entry SET i.BuyPrice=0, i.SellPrice=0;

-- Loot bag gear from on-level dungeons: everything the elites and bosses of the 5-player dungeons can drop
-- (uncommon to epic weapons and armor), built from this server's own loot tables. Read by the Renown module.
DROP TABLE IF EXISTS custom_renown_dungeon_loot;
CREATE TABLE custom_renown_dungeon_loot (item MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY, map SMALLINT UNSIGNED NOT NULL, reqlevel TINYINT UNSIGNED NOT NULL, quality TINYINT UNSIGNED NOT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Renown loot bags: dungeon loot';
INSERT IGNORE INTO custom_renown_dungeon_loot (item,map,reqlevel,quality) SELECT i.entry, MIN(c.map), i.RequiredLevel, i.Quality FROM creature c JOIN creature_template t ON t.Entry=c.id AND t.`Rank`>=1 AND t.LootId>0 JOIN creature_loot_template l ON l.entry=t.LootId JOIN item_template i ON i.entry=l.item WHERE c.map IN (389,36,43,33,48,34,90,47,189,129,70,209,349,109,230,229,429,289,329) AND l.mincountOrRef>0 AND i.Quality BETWEEN 2 AND 4 AND i.class IN (2,4) AND i.InventoryType>0 AND i.InventoryType<>19 AND i.RequiredLevel>0 AND i.startquest=0 AND i.entry<190000 GROUP BY i.entry;
INSERT IGNORE INTO custom_renown_dungeon_loot (item,map,reqlevel,quality) SELECT i.entry, MIN(c.map), i.RequiredLevel, i.Quality FROM creature c JOIN creature_template t ON t.Entry=c.id AND t.`Rank`>=1 AND t.LootId>0 JOIN creature_loot_template l ON l.entry=t.LootId JOIN reference_loot_template r ON r.entry=-l.mincountOrRef JOIN item_template i ON i.entry=r.item WHERE c.map IN (389,36,43,33,48,34,90,47,189,129,70,209,349,109,230,229,429,289,329) AND l.mincountOrRef<0 AND r.mincountOrRef>0 AND i.Quality BETWEEN 2 AND 4 AND i.class IN (2,4) AND i.InventoryType>0 AND i.InventoryType<>19 AND i.RequiredLevel>0 AND i.startquest=0 AND i.entry<190000 GROUP BY i.entry;
INSERT IGNORE INTO custom_renown_dungeon_loot (item,map,reqlevel,quality) SELECT i.entry, MIN(c.map), i.RequiredLevel, i.Quality FROM creature c JOIN creature_template t ON t.Entry=c.id AND t.`Rank`>=1 AND t.LootId>0 JOIN creature_loot_template l ON l.entry=t.LootId JOIN reference_loot_template r ON r.entry=-l.mincountOrRef JOIN reference_loot_template r2 ON r2.entry=-r.mincountOrRef JOIN item_template i ON i.entry=r2.item WHERE c.map IN (389,36,43,33,48,34,90,47,189,129,70,209,349,109,230,229,429,289,329) AND l.mincountOrRef<0 AND r.mincountOrRef<0 AND r2.mincountOrRef>0 AND i.Quality BETWEEN 2 AND 4 AND i.class IN (2,4) AND i.InventoryType>0 AND i.InventoryType<>19 AND i.RequiredLevel>0 AND i.startquest=0 AND i.entry<190000 GROUP BY i.entry;
SELECT 'dungeon_loot', COUNT(*) FROM custom_renown_dungeon_loot;

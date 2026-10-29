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
-- Level filters for the low-level sets (a vendor shows at most 128 items, so each player only sees gear for their level):
-- 59110 level <= 9 (Recruit's), 59111 level 10-19 (uses existing 107 'level >= 10' and 326 'level <= 19'), 59112 = 59111 AND tier 1 insignia (Skirmisher's)
DELETE FROM conditions WHERE condition_entry BETWEEN 59110 AND 59112;
INSERT INTO conditions (condition_entry,type,value1,value2,value3,value4,flags,comments) VALUES
(59110,15,9,2,0,0,0,'Renown: player level <= 9'),
(59111,-1,107,326,0,0,0,'Renown: player level 10-19'),
(59112,-1,59111,59101,0,0,0,'Renown: level 10-19 and Renown tier 1');

-- Quartermasters become vendors too
UPDATE creature_template SET NpcFlags = (NpcFlags & ~128) | 4 WHERE Entry IN (190100,190101); -- 4 = vendor in 1.12 (128 is innkeeper)
INSERT INTO gossip_menu_option (menu_id,id,option_icon,option_text,option_broadcast_text,option_id,npc_option_npcflag,action_menu_id,action_poi_id,action_script_id,box_coded,box_money,box_text,box_broadcast_text,condition_id) VALUES
(59000,10,1,'Show me the Renown rewards.',0,3,4,0,0,0,0,0,'',0,0);

-- Low-level PvP gear: Recruit's (shown to levels 1-9) and Skirmisher's (shown to levels 10-19 with Renown tier 1)
DELETE FROM item_template WHERE entry BETWEEN 190600 AND 190799;
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

-- Reward stock: low-level sets first, then the Warsong Gulch reward lists, unlocked by renown tier instead of reputation
INSERT INTO npc_vendor (entry,item,maxcount,incrtime,slot,condition_id,comments) VALUES
(190100,190600,0,0,0,59110,'Renown levels 1-9'),
(190100,190601,0,0,1,59110,'Renown levels 1-9'),
(190100,190700,0,0,2,59110,'Renown levels 1-9'),
(190100,190701,0,0,3,59110,'Renown levels 1-9'),
(190100,190602,0,0,4,59110,'Renown levels 1-9'),
(190100,190603,0,0,5,59110,'Renown levels 1-9'),
(190100,190604,0,0,6,59110,'Renown levels 1-9'),
(190100,190702,0,0,7,59110,'Renown levels 1-9'),
(190100,190605,0,0,8,59110,'Renown levels 1-9'),
(190100,190606,0,0,9,59110,'Renown levels 1-9'),
(190100,190703,0,0,10,59110,'Renown levels 1-9'),
(190100,190704,0,0,11,59110,'Renown levels 1-9'),
(190100,190607,0,0,12,59110,'Renown levels 1-9'),
(190100,190608,0,0,13,59110,'Renown levels 1-9'),
(190100,190609,0,0,14,59110,'Renown levels 1-9'),
(190100,190705,0,0,15,59110,'Renown levels 1-9'),
(190100,190610,0,0,16,59110,'Renown levels 1-9'),
(190100,190611,0,0,17,59110,'Renown levels 1-9'),
(190100,190706,0,0,18,59110,'Renown levels 1-9'),
(190100,190707,0,0,19,59110,'Renown levels 1-9'),
(190100,190612,0,0,20,59110,'Renown levels 1-9'),
(190100,190613,0,0,21,59110,'Renown levels 1-9'),
(190100,190614,0,0,22,59110,'Renown levels 1-9'),
(190100,190708,0,0,23,59110,'Renown levels 1-9'),
(190100,190615,0,0,24,59110,'Renown levels 1-9'),
(190100,190616,0,0,25,59110,'Renown levels 1-9'),
(190100,190709,0,0,26,59110,'Renown levels 1-9'),
(190100,190710,0,0,27,59110,'Renown levels 1-9'),
(190100,190617,0,0,28,59110,'Renown levels 1-9'),
(190100,190618,0,0,29,59110,'Renown levels 1-9'),
(190100,190619,0,0,30,59110,'Renown levels 1-9'),
(190100,190711,0,0,31,59110,'Renown levels 1-9'),
(190100,190620,0,0,32,59110,'Renown levels 1-9'),
(190100,190621,0,0,33,59110,'Renown levels 1-9'),
(190100,190622,0,0,34,59110,'Renown levels 1-9'),
(190100,190623,0,0,35,59110,'Renown levels 1-9'),
(190100,190624,0,0,36,59110,'Renown levels 1-9'),
(190100,190625,0,0,37,59110,'Renown levels 1-9'),
(190100,190712,0,0,38,59110,'Renown levels 1-9'),
(190100,190713,0,0,39,59110,'Renown levels 1-9'),
(190100,190714,0,0,40,59110,'Renown levels 1-9'),
(190100,190626,0,0,41,59110,'Renown levels 1-9'),
(190100,190627,0,0,42,59110,'Renown levels 1-9'),
(190100,190628,0,0,43,59110,'Renown levels 1-9'),
(190100,190629,0,0,44,59110,'Renown levels 1-9'),
(190100,190630,0,0,45,59110,'Renown levels 1-9'),
(190100,190631,0,0,46,59110,'Renown levels 1-9'),
(190100,190632,0,0,47,59110,'Renown levels 1-9'),
(190100,190633,0,0,48,59110,'Renown levels 1-9'),
(190100,190634,0,0,49,59112,'Renown levels 10-19, tier 1'),
(190100,190635,0,0,50,59112,'Renown levels 10-19, tier 1'),
(190100,190715,0,0,51,59112,'Renown levels 10-19, tier 1'),
(190100,190716,0,0,52,59112,'Renown levels 10-19, tier 1'),
(190100,190636,0,0,53,59112,'Renown levels 10-19, tier 1'),
(190100,190637,0,0,54,59112,'Renown levels 10-19, tier 1'),
(190100,190638,0,0,55,59112,'Renown levels 10-19, tier 1'),
(190100,190717,0,0,56,59112,'Renown levels 10-19, tier 1'),
(190100,190639,0,0,57,59112,'Renown levels 10-19, tier 1'),
(190100,190640,0,0,58,59112,'Renown levels 10-19, tier 1'),
(190100,190718,0,0,59,59112,'Renown levels 10-19, tier 1'),
(190100,190719,0,0,60,59112,'Renown levels 10-19, tier 1'),
(190100,190641,0,0,61,59112,'Renown levels 10-19, tier 1'),
(190100,190642,0,0,62,59112,'Renown levels 10-19, tier 1'),
(190100,190643,0,0,63,59112,'Renown levels 10-19, tier 1'),
(190100,190720,0,0,64,59112,'Renown levels 10-19, tier 1'),
(190100,190644,0,0,65,59112,'Renown levels 10-19, tier 1'),
(190100,190645,0,0,66,59112,'Renown levels 10-19, tier 1'),
(190100,190721,0,0,67,59112,'Renown levels 10-19, tier 1'),
(190100,190722,0,0,68,59112,'Renown levels 10-19, tier 1'),
(190100,190646,0,0,69,59112,'Renown levels 10-19, tier 1'),
(190100,190647,0,0,70,59112,'Renown levels 10-19, tier 1'),
(190100,190648,0,0,71,59112,'Renown levels 10-19, tier 1'),
(190100,190723,0,0,72,59112,'Renown levels 10-19, tier 1'),
(190100,190649,0,0,73,59112,'Renown levels 10-19, tier 1'),
(190100,190650,0,0,74,59112,'Renown levels 10-19, tier 1'),
(190100,190724,0,0,75,59112,'Renown levels 10-19, tier 1'),
(190100,190725,0,0,76,59112,'Renown levels 10-19, tier 1'),
(190100,190651,0,0,77,59112,'Renown levels 10-19, tier 1'),
(190100,190652,0,0,78,59112,'Renown levels 10-19, tier 1'),
(190100,190653,0,0,79,59112,'Renown levels 10-19, tier 1'),
(190100,190726,0,0,80,59112,'Renown levels 10-19, tier 1'),
(190100,190654,0,0,81,59112,'Renown levels 10-19, tier 1'),
(190100,190655,0,0,82,59112,'Renown levels 10-19, tier 1'),
(190100,190656,0,0,83,59112,'Renown levels 10-19, tier 1'),
(190100,190657,0,0,84,59112,'Renown levels 10-19, tier 1'),
(190100,190658,0,0,85,59112,'Renown levels 10-19, tier 1'),
(190100,190659,0,0,86,59112,'Renown levels 10-19, tier 1'),
(190100,190727,0,0,87,59112,'Renown levels 10-19, tier 1'),
(190100,190728,0,0,88,59112,'Renown levels 10-19, tier 1'),
(190100,190729,0,0,89,59112,'Renown levels 10-19, tier 1'),
(190100,190660,0,0,90,59112,'Renown levels 10-19, tier 1'),
(190100,190661,0,0,91,59112,'Renown levels 10-19, tier 1'),
(190100,190662,0,0,92,59112,'Renown levels 10-19, tier 1'),
(190100,190663,0,0,93,59112,'Renown levels 10-19, tier 1'),
(190100,190664,0,0,94,59112,'Renown levels 10-19, tier 1'),
(190100,190665,0,0,95,59112,'Renown levels 10-19, tier 1'),
(190100,190666,0,0,96,59112,'Renown levels 10-19, tier 1'),
(190100,190667,0,0,97,59112,'Renown levels 10-19, tier 1'),
(190100,19506,0,0,98,59103,'Renown tier 3'),
(190100,20428,0,0,99,59101,'Renown tier 1'),
(190100,20431,0,0,100,59101,'Renown tier 1'),
(190100,20434,0,0,101,59101,'Renown tier 1'),
(190100,20438,0,0,102,59101,'Renown tier 1'),
(190100,20439,0,0,103,59101,'Renown tier 1'),
(190100,20440,0,0,104,59101,'Renown tier 1'),
(190100,20443,0,0,105,59101,'Renown tier 1'),
(190100,20444,0,0,106,59101,'Renown tier 1'),
(190100,21566,0,0,107,59101,'Renown tier 1'),
(190100,21568,0,0,108,59101,'Renown tier 1'),
(190100,19062,0,0,109,59102,'Renown tier 2'),
(190100,19068,0,0,110,59102,'Renown tier 2'),
(190100,19517,0,0,111,59102,'Renown tier 2'),
(190100,19525,0,0,112,59102,'Renown tier 2'),
(190100,19533,0,0,113,59102,'Renown tier 2'),
(190100,19541,0,0,114,59102,'Renown tier 2'),
(190100,19549,0,0,115,59102,'Renown tier 2'),
(190100,19557,0,0,116,59102,'Renown tier 2'),
(190100,19565,0,0,117,59102,'Renown tier 2'),
(190100,19573,0,0,118,59102,'Renown tier 2'),
(190100,17349,0,0,119,59103,'Renown tier 3'),
(190100,17352,0,0,120,59103,'Renown tier 3'),
(190100,19061,0,0,121,59103,'Renown tier 3'),
(190100,19067,0,0,122,59103,'Renown tier 3'),
(190100,19515,0,0,123,59103,'Renown tier 3'),
(190100,19524,0,0,124,59103,'Renown tier 3'),
(190100,19532,0,0,125,59103,'Renown tier 3'),
(190100,19540,0,0,126,59103,'Renown tier 3'),
(190100,19548,0,0,127,59103,'Renown tier 3'),
(190100,19556,0,0,128,59103,'Renown tier 3'),
(190100,19564,0,0,129,59103,'Renown tier 3'),
(190100,19572,0,0,130,59103,'Renown tier 3'),
(190100,19581,0,0,131,59104,'Renown tier 4'),
(190100,19584,0,0,132,59104,'Renown tier 4'),
(190100,19590,0,0,133,59104,'Renown tier 4'),
(190100,19597,0,0,134,59104,'Renown tier 4'),
(190100,21565,0,0,135,59104,'Renown tier 4'),
(190100,21567,0,0,136,59104,'Renown tier 4'),
(190100,17348,0,0,137,59104,'Renown tier 4'),
(190100,17351,0,0,138,59104,'Renown tier 4'),
(190100,19060,0,0,139,59104,'Renown tier 4'),
(190100,19066,0,0,140,59104,'Renown tier 4'),
(190100,19516,0,0,141,59104,'Renown tier 4'),
(190100,19523,0,0,142,59104,'Renown tier 4'),
(190100,19531,0,0,143,59104,'Renown tier 4'),
(190100,19539,0,0,144,59104,'Renown tier 4'),
(190100,19547,0,0,145,59104,'Renown tier 4'),
(190100,19555,0,0,146,59104,'Renown tier 4'),
(190100,19563,0,0,147,59104,'Renown tier 4'),
(190100,19571,0,0,148,59104,'Renown tier 4'),
(190100,19580,0,0,149,59105,'Renown tier 5'),
(190100,19583,0,0,150,59105,'Renown tier 5'),
(190100,19589,0,0,151,59105,'Renown tier 5'),
(190100,19596,0,0,152,59105,'Renown tier 5'),
(190100,19514,0,0,153,59105,'Renown tier 5'),
(190100,19522,0,0,154,59105,'Renown tier 5'),
(190100,19530,0,0,155,59105,'Renown tier 5'),
(190100,19538,0,0,156,59105,'Renown tier 5'),
(190100,19546,0,0,157,59105,'Renown tier 5'),
(190100,19554,0,0,158,59105,'Renown tier 5'),
(190100,19562,0,0,159,59105,'Renown tier 5'),
(190100,19570,0,0,160,59105,'Renown tier 5'),
(190100,19578,0,0,161,59106,'Renown tier 6'),
(190100,19582,0,0,162,59106,'Renown tier 6'),
(190100,19587,0,0,163,59106,'Renown tier 6'),
(190100,19595,0,0,164,59106,'Renown tier 6'),
(190100,22672,0,0,165,59106,'Renown tier 6'),
(190100,22748,0,0,166,59106,'Renown tier 6'),
(190100,22749,0,0,167,59106,'Renown tier 6'),
(190100,22750,0,0,168,59106,'Renown tier 6'),
(190100,22752,0,0,169,59106,'Renown tier 6'),
(190100,22753,0,0,170,59106,'Renown tier 6'),
(190101,190600,0,0,0,59110,'Renown levels 1-9'),
(190101,190601,0,0,1,59110,'Renown levels 1-9'),
(190101,190700,0,0,2,59110,'Renown levels 1-9'),
(190101,190701,0,0,3,59110,'Renown levels 1-9'),
(190101,190602,0,0,4,59110,'Renown levels 1-9'),
(190101,190603,0,0,5,59110,'Renown levels 1-9'),
(190101,190604,0,0,6,59110,'Renown levels 1-9'),
(190101,190702,0,0,7,59110,'Renown levels 1-9'),
(190101,190605,0,0,8,59110,'Renown levels 1-9'),
(190101,190606,0,0,9,59110,'Renown levels 1-9'),
(190101,190703,0,0,10,59110,'Renown levels 1-9'),
(190101,190704,0,0,11,59110,'Renown levels 1-9'),
(190101,190607,0,0,12,59110,'Renown levels 1-9'),
(190101,190608,0,0,13,59110,'Renown levels 1-9'),
(190101,190609,0,0,14,59110,'Renown levels 1-9'),
(190101,190705,0,0,15,59110,'Renown levels 1-9'),
(190101,190610,0,0,16,59110,'Renown levels 1-9'),
(190101,190611,0,0,17,59110,'Renown levels 1-9'),
(190101,190706,0,0,18,59110,'Renown levels 1-9'),
(190101,190707,0,0,19,59110,'Renown levels 1-9'),
(190101,190612,0,0,20,59110,'Renown levels 1-9'),
(190101,190613,0,0,21,59110,'Renown levels 1-9'),
(190101,190614,0,0,22,59110,'Renown levels 1-9'),
(190101,190708,0,0,23,59110,'Renown levels 1-9'),
(190101,190615,0,0,24,59110,'Renown levels 1-9'),
(190101,190616,0,0,25,59110,'Renown levels 1-9'),
(190101,190709,0,0,26,59110,'Renown levels 1-9'),
(190101,190710,0,0,27,59110,'Renown levels 1-9'),
(190101,190617,0,0,28,59110,'Renown levels 1-9'),
(190101,190618,0,0,29,59110,'Renown levels 1-9'),
(190101,190619,0,0,30,59110,'Renown levels 1-9'),
(190101,190711,0,0,31,59110,'Renown levels 1-9'),
(190101,190620,0,0,32,59110,'Renown levels 1-9'),
(190101,190621,0,0,33,59110,'Renown levels 1-9'),
(190101,190622,0,0,34,59110,'Renown levels 1-9'),
(190101,190623,0,0,35,59110,'Renown levels 1-9'),
(190101,190624,0,0,36,59110,'Renown levels 1-9'),
(190101,190625,0,0,37,59110,'Renown levels 1-9'),
(190101,190712,0,0,38,59110,'Renown levels 1-9'),
(190101,190713,0,0,39,59110,'Renown levels 1-9'),
(190101,190714,0,0,40,59110,'Renown levels 1-9'),
(190101,190626,0,0,41,59110,'Renown levels 1-9'),
(190101,190627,0,0,42,59110,'Renown levels 1-9'),
(190101,190628,0,0,43,59110,'Renown levels 1-9'),
(190101,190629,0,0,44,59110,'Renown levels 1-9'),
(190101,190630,0,0,45,59110,'Renown levels 1-9'),
(190101,190631,0,0,46,59110,'Renown levels 1-9'),
(190101,190632,0,0,47,59110,'Renown levels 1-9'),
(190101,190633,0,0,48,59110,'Renown levels 1-9'),
(190101,190634,0,0,49,59112,'Renown levels 10-19, tier 1'),
(190101,190635,0,0,50,59112,'Renown levels 10-19, tier 1'),
(190101,190715,0,0,51,59112,'Renown levels 10-19, tier 1'),
(190101,190716,0,0,52,59112,'Renown levels 10-19, tier 1'),
(190101,190636,0,0,53,59112,'Renown levels 10-19, tier 1'),
(190101,190637,0,0,54,59112,'Renown levels 10-19, tier 1'),
(190101,190638,0,0,55,59112,'Renown levels 10-19, tier 1'),
(190101,190717,0,0,56,59112,'Renown levels 10-19, tier 1'),
(190101,190639,0,0,57,59112,'Renown levels 10-19, tier 1'),
(190101,190640,0,0,58,59112,'Renown levels 10-19, tier 1'),
(190101,190718,0,0,59,59112,'Renown levels 10-19, tier 1'),
(190101,190719,0,0,60,59112,'Renown levels 10-19, tier 1'),
(190101,190641,0,0,61,59112,'Renown levels 10-19, tier 1'),
(190101,190642,0,0,62,59112,'Renown levels 10-19, tier 1'),
(190101,190643,0,0,63,59112,'Renown levels 10-19, tier 1'),
(190101,190720,0,0,64,59112,'Renown levels 10-19, tier 1'),
(190101,190644,0,0,65,59112,'Renown levels 10-19, tier 1'),
(190101,190645,0,0,66,59112,'Renown levels 10-19, tier 1'),
(190101,190721,0,0,67,59112,'Renown levels 10-19, tier 1'),
(190101,190722,0,0,68,59112,'Renown levels 10-19, tier 1'),
(190101,190646,0,0,69,59112,'Renown levels 10-19, tier 1'),
(190101,190647,0,0,70,59112,'Renown levels 10-19, tier 1'),
(190101,190648,0,0,71,59112,'Renown levels 10-19, tier 1'),
(190101,190723,0,0,72,59112,'Renown levels 10-19, tier 1'),
(190101,190649,0,0,73,59112,'Renown levels 10-19, tier 1'),
(190101,190650,0,0,74,59112,'Renown levels 10-19, tier 1'),
(190101,190724,0,0,75,59112,'Renown levels 10-19, tier 1'),
(190101,190725,0,0,76,59112,'Renown levels 10-19, tier 1'),
(190101,190651,0,0,77,59112,'Renown levels 10-19, tier 1'),
(190101,190652,0,0,78,59112,'Renown levels 10-19, tier 1'),
(190101,190653,0,0,79,59112,'Renown levels 10-19, tier 1'),
(190101,190726,0,0,80,59112,'Renown levels 10-19, tier 1'),
(190101,190654,0,0,81,59112,'Renown levels 10-19, tier 1'),
(190101,190655,0,0,82,59112,'Renown levels 10-19, tier 1'),
(190101,190656,0,0,83,59112,'Renown levels 10-19, tier 1'),
(190101,190657,0,0,84,59112,'Renown levels 10-19, tier 1'),
(190101,190658,0,0,85,59112,'Renown levels 10-19, tier 1'),
(190101,190659,0,0,86,59112,'Renown levels 10-19, tier 1'),
(190101,190727,0,0,87,59112,'Renown levels 10-19, tier 1'),
(190101,190728,0,0,88,59112,'Renown levels 10-19, tier 1'),
(190101,190729,0,0,89,59112,'Renown levels 10-19, tier 1'),
(190101,190660,0,0,90,59112,'Renown levels 10-19, tier 1'),
(190101,190661,0,0,91,59112,'Renown levels 10-19, tier 1'),
(190101,190662,0,0,92,59112,'Renown levels 10-19, tier 1'),
(190101,190663,0,0,93,59112,'Renown levels 10-19, tier 1'),
(190101,190664,0,0,94,59112,'Renown levels 10-19, tier 1'),
(190101,190665,0,0,95,59112,'Renown levels 10-19, tier 1'),
(190101,190666,0,0,96,59112,'Renown levels 10-19, tier 1'),
(190101,190667,0,0,97,59112,'Renown levels 10-19, tier 1'),
(190101,19505,0,0,98,59103,'Renown tier 3'),
(190101,20425,0,0,99,59101,'Renown tier 1'),
(190101,20426,0,0,100,59101,'Renown tier 1'),
(190101,20427,0,0,101,59101,'Renown tier 1'),
(190101,20429,0,0,102,59101,'Renown tier 1'),
(190101,20430,0,0,103,59101,'Renown tier 1'),
(190101,20437,0,0,104,59101,'Renown tier 1'),
(190101,20441,0,0,105,59101,'Renown tier 1'),
(190101,20442,0,0,106,59101,'Renown tier 1'),
(190101,21566,0,0,107,59101,'Renown tier 1'),
(190101,21568,0,0,108,59101,'Renown tier 1'),
(190101,19062,0,0,109,59102,'Renown tier 2'),
(190101,19068,0,0,110,59102,'Renown tier 2'),
(190101,19513,0,0,111,59102,'Renown tier 2'),
(190101,19521,0,0,112,59102,'Renown tier 2'),
(190101,19529,0,0,113,59102,'Renown tier 2'),
(190101,19537,0,0,114,59102,'Renown tier 2'),
(190101,19545,0,0,115,59102,'Renown tier 2'),
(190101,19553,0,0,116,59102,'Renown tier 2'),
(190101,19561,0,0,117,59102,'Renown tier 2'),
(190101,19569,0,0,118,59102,'Renown tier 2'),
(190101,17349,0,0,119,59103,'Renown tier 3'),
(190101,17352,0,0,120,59103,'Renown tier 3'),
(190101,19061,0,0,121,59103,'Renown tier 3'),
(190101,19067,0,0,122,59103,'Renown tier 3'),
(190101,19512,0,0,123,59103,'Renown tier 3'),
(190101,19520,0,0,124,59103,'Renown tier 3'),
(190101,19528,0,0,125,59103,'Renown tier 3'),
(190101,19536,0,0,126,59103,'Renown tier 3'),
(190101,19544,0,0,127,59103,'Renown tier 3'),
(190101,19552,0,0,128,59103,'Renown tier 3'),
(190101,19560,0,0,129,59103,'Renown tier 3'),
(190101,19568,0,0,130,59103,'Renown tier 3'),
(190101,19581,0,0,131,59104,'Renown tier 4'),
(190101,19584,0,0,132,59104,'Renown tier 4'),
(190101,19590,0,0,133,59104,'Renown tier 4'),
(190101,19597,0,0,134,59104,'Renown tier 4'),
(190101,21565,0,0,135,59104,'Renown tier 4'),
(190101,21567,0,0,136,59104,'Renown tier 4'),
(190101,17348,0,0,137,59104,'Renown tier 4'),
(190101,17351,0,0,138,59104,'Renown tier 4'),
(190101,19060,0,0,139,59104,'Renown tier 4'),
(190101,19066,0,0,140,59104,'Renown tier 4'),
(190101,19511,0,0,141,59104,'Renown tier 4'),
(190101,19519,0,0,142,59104,'Renown tier 4'),
(190101,19527,0,0,143,59104,'Renown tier 4'),
(190101,19535,0,0,144,59104,'Renown tier 4'),
(190101,19543,0,0,145,59104,'Renown tier 4'),
(190101,19551,0,0,146,59104,'Renown tier 4'),
(190101,19559,0,0,147,59104,'Renown tier 4'),
(190101,19567,0,0,148,59104,'Renown tier 4'),
(190101,19580,0,0,149,59105,'Renown tier 5'),
(190101,19583,0,0,150,59105,'Renown tier 5'),
(190101,19589,0,0,151,59105,'Renown tier 5'),
(190101,19596,0,0,152,59105,'Renown tier 5'),
(190101,19510,0,0,153,59105,'Renown tier 5'),
(190101,19518,0,0,154,59105,'Renown tier 5'),
(190101,19526,0,0,155,59105,'Renown tier 5'),
(190101,19534,0,0,156,59105,'Renown tier 5'),
(190101,19542,0,0,157,59105,'Renown tier 5'),
(190101,19550,0,0,158,59105,'Renown tier 5'),
(190101,19558,0,0,159,59105,'Renown tier 5'),
(190101,19566,0,0,160,59105,'Renown tier 5'),
(190101,19578,0,0,161,59106,'Renown tier 6'),
(190101,19582,0,0,162,59106,'Renown tier 6'),
(190101,19587,0,0,163,59106,'Renown tier 6'),
(190101,19595,0,0,164,59106,'Renown tier 6'),
(190101,22651,0,0,165,59106,'Renown tier 6'),
(190101,22673,0,0,166,59106,'Renown tier 6'),
(190101,22676,0,0,167,59106,'Renown tier 6'),
(190101,22740,0,0,168,59106,'Renown tier 6'),
(190101,22741,0,0,169,59106,'Renown tier 6'),
(190101,22747,0,0,170,59106,'Renown tier 6');

-- Renown prices: read by the Renown server module (paid with spendable Renown points, not gold).
-- Gold price is 0 so the client never blocks the purchase for lack of money; the RenownBar addon shows the Renown cost.
-- tier: Renown reward tier that unlocks the item (0 = no insignia needed); also used for battleground loot bags
DROP TABLE IF EXISTS custom_renown_vendor;
CREATE TABLE custom_renown_vendor (item MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY, cost INT UNSIGNED NOT NULL DEFAULT 0, tier TINYINT UNSIGNED NOT NULL DEFAULT 0) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Renown vendor prices';
INSERT INTO custom_renown_vendor (item,cost,tier) VALUES
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
(190729,300,1);
UPDATE item_template i JOIN custom_renown_vendor c ON c.item=i.entry SET i.BuyPrice=0, i.SellPrice=0;

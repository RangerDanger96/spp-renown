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

-- Low-level PvP gear: Recruit's (levels 1-9, open to all) and Skirmisher's (levels 10-19, Renown tier 1)
DELETE FROM item_template WHERE entry BETWEEN 190600 AND 190699;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2578;
UPDATE tmp_it SET entry=190600, name='Recruit''s Silk Robe', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4309;
UPDATE tmp_it SET entry=190601, name='Recruit''s Silk Pants', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3308;
UPDATE tmp_it SET entry=190602, name='Recruit''s Silk Gloves', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3307;
UPDATE tmp_it SET entry=190603, name='Recruit''s Silk Slippers', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2283;
UPDATE tmp_it SET entry=190604, name='Recruit''s Silk Sash', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=821;
UPDATE tmp_it SET entry=190605, name='Recruit''s Leather Jerkin', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4242;
UPDATE tmp_it SET entry=190606, name='Recruit''s Leather Pants', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2312;
UPDATE tmp_it SET entry=190607, name='Recruit''s Leather Gloves', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=3, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2309;
UPDATE tmp_it SET entry=190608, name='Recruit''s Leather Boots', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=3, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2899;
UPDATE tmp_it SET entry=190609, name='Recruit''s Leather Belt', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=3, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=821;
UPDATE tmp_it SET entry=190610, name='Recruit''s Hide Vest', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4242;
UPDATE tmp_it SET entry=190611, name='Recruit''s Hide Leggings', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2312;
UPDATE tmp_it SET entry=190612, name='Recruit''s Hide Handwraps', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2309;
UPDATE tmp_it SET entry=190613, name='Recruit''s Hide Boots', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2899;
UPDATE tmp_it SET entry=190614, name='Recruit''s Hide Cord', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2273;
UPDATE tmp_it SET entry=190615, name='Recruit''s Chain Hauberk', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2978;
UPDATE tmp_it SET entry=190616, name='Recruit''s Chain Legguards', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14703;
UPDATE tmp_it SET entry=190617, name='Recruit''s Chain Gauntlets', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=3, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3302;
UPDATE tmp_it SET entry=190618, name='Recruit''s Chain Sabatons', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=3, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=832;
UPDATE tmp_it SET entry=190619, name='Recruit''s Chain Girdle', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=3, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1355;
UPDATE tmp_it SET entry=190620, name='Recruit''s Cloak of Fury', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1355;
UPDATE tmp_it SET entry=190621, name='Recruit''s Cloak of Swiftness', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1355;
UPDATE tmp_it SET entry=190622, name='Recruit''s Cloak of Insight', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8350;
UPDATE tmp_it SET entry=190623, name='Recruit''s Band of Fury', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8350;
UPDATE tmp_it SET entry=190624, name='Recruit''s Band of Swiftness', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=8350;
UPDATE tmp_it SET entry=190625, name='Recruit''s Band of Insight', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4765;
UPDATE tmp_it SET entry=190626, name='Recruit''s Longsword', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=2, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3488;
UPDATE tmp_it SET entry=190627, name='Recruit''s Greataxe', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1287;
UPDATE tmp_it SET entry=190628, name='Recruit''s Dirk', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=3, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1394;
UPDATE tmp_it SET entry=190629, name='Recruit''s Scepter', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1933;
UPDATE tmp_it SET entry=190630, name='Recruit''s Battle Staff', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=6, stat_value3=1, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3036;
UPDATE tmp_it SET entry=190631, name='Recruit''s Recurve Bow', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=2, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=5071;
UPDATE tmp_it SET entry=190632, name='Recruit''s Wand', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=2, stat_type2=6, stat_value2=1, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3652;
UPDATE tmp_it SET entry=190633, name='Recruit''s Kite Shield', Quality=3, ItemLevel=12, RequiredLevel=1, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=7, stat_value1=3, stat_type2=4, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1486;
UPDATE tmp_it SET entry=190634, name='Skirmisher''s Silk Robe', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=23173;
UPDATE tmp_it SET entry=190635, name='Skirmisher''s Silk Pants', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3066;
UPDATE tmp_it SET entry=190636, name='Skirmisher''s Silk Gloves', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14374;
UPDATE tmp_it SET entry=190637, name='Skirmisher''s Silk Slippers', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4708;
UPDATE tmp_it SET entry=190638, name='Skirmisher''s Silk Sash', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10399;
UPDATE tmp_it SET entry=190639, name='Skirmisher''s Leather Jerkin', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10410;
UPDATE tmp_it SET entry=190640, name='Skirmisher''s Leather Pants', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=7284;
UPDATE tmp_it SET entry=190641, name='Skirmisher''s Leather Gloves', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1121;
UPDATE tmp_it SET entry=190642, name='Skirmisher''s Leather Boots', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3429;
UPDATE tmp_it SET entry=190643, name='Skirmisher''s Leather Belt', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10399;
UPDATE tmp_it SET entry=190644, name='Skirmisher''s Hide Vest', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=10410;
UPDATE tmp_it SET entry=190645, name='Skirmisher''s Hide Leggings', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=6, stat_value3=4, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=7284;
UPDATE tmp_it SET entry=190646, name='Skirmisher''s Hide Handwraps', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1121;
UPDATE tmp_it SET entry=190647, name='Skirmisher''s Hide Boots', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=3429;
UPDATE tmp_it SET entry=190648, name='Skirmisher''s Hide Cord', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=3, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6642;
UPDATE tmp_it SET entry=190649, name='Skirmisher''s Chain Hauberk', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4816;
UPDATE tmp_it SET entry=190650, name='Skirmisher''s Chain Legguards', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12994;
UPDATE tmp_it SET entry=190651, name='Skirmisher''s Chain Gauntlets', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=14742;
UPDATE tmp_it SET entry=190652, name='Skirmisher''s Chain Sabatons', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6460;
UPDATE tmp_it SET entry=190653, name='Skirmisher''s Chain Girdle', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=6, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2059;
UPDATE tmp_it SET entry=190654, name='Skirmisher''s Cloak of Fury', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2059;
UPDATE tmp_it SET entry=190655, name='Skirmisher''s Cloak of Swiftness', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2059;
UPDATE tmp_it SET entry=190656, name='Skirmisher''s Cloak of Insight', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=5, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4998;
UPDATE tmp_it SET entry=190657, name='Skirmisher''s Band of Fury', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4998;
UPDATE tmp_it SET entry=190658, name='Skirmisher''s Band of Swiftness', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=4998;
UPDATE tmp_it SET entry=190659, name='Skirmisher''s Band of Insight', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=5, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1482;
UPDATE tmp_it SET entry=190660, name='Skirmisher''s Longsword', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=4, stat_type2=7, stat_value2=4, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1455;
UPDATE tmp_it SET entry=190661, name='Skirmisher''s Greataxe', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=4, stat_value1=8, stat_type2=7, stat_value2=6, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=1935;
UPDATE tmp_it SET entry=190662, name='Skirmisher''s Dirk', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=5, stat_type2=7, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=2256;
UPDATE tmp_it SET entry=190663, name='Skirmisher''s Scepter', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=7, stat_value2=2, stat_type3=6, stat_value3=2, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=890;
UPDATE tmp_it SET entry=190664, name='Skirmisher''s Battle Staff', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=6, stat_type2=7, stat_value2=5, stat_type3=6, stat_value3=3, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=6469;
UPDATE tmp_it SET entry=190665, name='Skirmisher''s Recurve Bow', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=3, stat_value1=4, stat_type2=7, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=5198;
UPDATE tmp_it SET entry=190666, name='Skirmisher''s Wand', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=5, stat_value1=4, stat_type2=6, stat_value2=2, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;
CREATE TEMPORARY TABLE tmp_it SELECT * FROM item_template WHERE entry=12997;
UPDATE tmp_it SET entry=190667, name='Skirmisher''s Kite Shield', Quality=3, ItemLevel=22, RequiredLevel=10, BuyCount=1, SellPrice=0, bonding=1, AllowableClass=-1, AllowableRace=-1, RandomProperty=0, itemset=0, description='Renown reward', Flags=0, RequiredReputationFaction=0, RequiredReputationRank=0, requiredhonorrank=0, startquest=0, minMoneyLoot=0, maxMoneyLoot=0, stat_type1=7, stat_value1=5, stat_type2=4, stat_value2=3, stat_type3=0, stat_value3=0, stat_type4=0, stat_value4=0, stat_type5=0, stat_value5=0, stat_type6=0, stat_value6=0, stat_type7=0, stat_value7=0, stat_type8=0, stat_value8=0, stat_type9=0, stat_value9=0, stat_type10=0, stat_value10=0, spellid_1=0, spelltrigger_1=0, spellcharges_1=0, spellcooldown_1=-1, spellcategory_1=0, spellcategorycooldown_1=-1, spellid_2=0, spelltrigger_2=0, spellcharges_2=0, spellcooldown_2=-1, spellcategory_2=0, spellcategorycooldown_2=-1, spellid_3=0, spelltrigger_3=0, spellcharges_3=0, spellcooldown_3=-1, spellcategory_3=0, spellcategorycooldown_3=-1, spellid_4=0, spelltrigger_4=0, spellcharges_4=0, spellcooldown_4=-1, spellcategory_4=0, spellcategorycooldown_4=-1, spellid_5=0, spelltrigger_5=0, spellcharges_5=0, spellcooldown_5=-1, spellcategory_5=0, spellcategorycooldown_5=-1;
INSERT INTO item_template SELECT * FROM tmp_it;
DROP TEMPORARY TABLE IF EXISTS tmp_it;

-- Reward stock: low-level sets first, then the Warsong Gulch reward lists, unlocked by renown tier instead of reputation
INSERT INTO npc_vendor (entry,item,maxcount,incrtime,slot,condition_id,comments) VALUES
(190100,190600,0,0,0,0,'Renown open'),
(190100,190601,0,0,1,0,'Renown open'),
(190100,190602,0,0,2,0,'Renown open'),
(190100,190603,0,0,3,0,'Renown open'),
(190100,190604,0,0,4,0,'Renown open'),
(190100,190605,0,0,5,0,'Renown open'),
(190100,190606,0,0,6,0,'Renown open'),
(190100,190607,0,0,7,0,'Renown open'),
(190100,190608,0,0,8,0,'Renown open'),
(190100,190609,0,0,9,0,'Renown open'),
(190100,190610,0,0,10,0,'Renown open'),
(190100,190611,0,0,11,0,'Renown open'),
(190100,190612,0,0,12,0,'Renown open'),
(190100,190613,0,0,13,0,'Renown open'),
(190100,190614,0,0,14,0,'Renown open'),
(190100,190615,0,0,15,0,'Renown open'),
(190100,190616,0,0,16,0,'Renown open'),
(190100,190617,0,0,17,0,'Renown open'),
(190100,190618,0,0,18,0,'Renown open'),
(190100,190619,0,0,19,0,'Renown open'),
(190100,190620,0,0,20,0,'Renown open'),
(190100,190621,0,0,21,0,'Renown open'),
(190100,190622,0,0,22,0,'Renown open'),
(190100,190623,0,0,23,0,'Renown open'),
(190100,190624,0,0,24,0,'Renown open'),
(190100,190625,0,0,25,0,'Renown open'),
(190100,190626,0,0,26,0,'Renown open'),
(190100,190627,0,0,27,0,'Renown open'),
(190100,190628,0,0,28,0,'Renown open'),
(190100,190629,0,0,29,0,'Renown open'),
(190100,190630,0,0,30,0,'Renown open'),
(190100,190631,0,0,31,0,'Renown open'),
(190100,190632,0,0,32,0,'Renown open'),
(190100,190633,0,0,33,0,'Renown open'),
(190100,190634,0,0,34,59101,'Renown tier 1'),
(190100,190635,0,0,35,59101,'Renown tier 1'),
(190100,190636,0,0,36,59101,'Renown tier 1'),
(190100,190637,0,0,37,59101,'Renown tier 1'),
(190100,190638,0,0,38,59101,'Renown tier 1'),
(190100,190639,0,0,39,59101,'Renown tier 1'),
(190100,190640,0,0,40,59101,'Renown tier 1'),
(190100,190641,0,0,41,59101,'Renown tier 1'),
(190100,190642,0,0,42,59101,'Renown tier 1'),
(190100,190643,0,0,43,59101,'Renown tier 1'),
(190100,190644,0,0,44,59101,'Renown tier 1'),
(190100,190645,0,0,45,59101,'Renown tier 1'),
(190100,190646,0,0,46,59101,'Renown tier 1'),
(190100,190647,0,0,47,59101,'Renown tier 1'),
(190100,190648,0,0,48,59101,'Renown tier 1'),
(190100,190649,0,0,49,59101,'Renown tier 1'),
(190100,190650,0,0,50,59101,'Renown tier 1'),
(190100,190651,0,0,51,59101,'Renown tier 1'),
(190100,190652,0,0,52,59101,'Renown tier 1'),
(190100,190653,0,0,53,59101,'Renown tier 1'),
(190100,190654,0,0,54,59101,'Renown tier 1'),
(190100,190655,0,0,55,59101,'Renown tier 1'),
(190100,190656,0,0,56,59101,'Renown tier 1'),
(190100,190657,0,0,57,59101,'Renown tier 1'),
(190100,190658,0,0,58,59101,'Renown tier 1'),
(190100,190659,0,0,59,59101,'Renown tier 1'),
(190100,190660,0,0,60,59101,'Renown tier 1'),
(190100,190661,0,0,61,59101,'Renown tier 1'),
(190100,190662,0,0,62,59101,'Renown tier 1'),
(190100,190663,0,0,63,59101,'Renown tier 1'),
(190100,190664,0,0,64,59101,'Renown tier 1'),
(190100,190665,0,0,65,59101,'Renown tier 1'),
(190100,190666,0,0,66,59101,'Renown tier 1'),
(190100,190667,0,0,67,59101,'Renown tier 1'),
(190100,19506,0,0,68,59103,'Renown tier 3'),
(190100,20428,0,0,69,59101,'Renown tier 1'),
(190100,20431,0,0,70,59101,'Renown tier 1'),
(190100,20434,0,0,71,59101,'Renown tier 1'),
(190100,20438,0,0,72,59101,'Renown tier 1'),
(190100,20439,0,0,73,59101,'Renown tier 1'),
(190100,20440,0,0,74,59101,'Renown tier 1'),
(190100,20443,0,0,75,59101,'Renown tier 1'),
(190100,20444,0,0,76,59101,'Renown tier 1'),
(190100,21566,0,0,77,59101,'Renown tier 1'),
(190100,21568,0,0,78,59101,'Renown tier 1'),
(190100,19062,0,0,79,59102,'Renown tier 2'),
(190100,19068,0,0,80,59102,'Renown tier 2'),
(190100,19517,0,0,81,59102,'Renown tier 2'),
(190100,19525,0,0,82,59102,'Renown tier 2'),
(190100,19533,0,0,83,59102,'Renown tier 2'),
(190100,19541,0,0,84,59102,'Renown tier 2'),
(190100,19549,0,0,85,59102,'Renown tier 2'),
(190100,19557,0,0,86,59102,'Renown tier 2'),
(190100,19565,0,0,87,59102,'Renown tier 2'),
(190100,19573,0,0,88,59102,'Renown tier 2'),
(190100,17349,0,0,89,59103,'Renown tier 3'),
(190100,17352,0,0,90,59103,'Renown tier 3'),
(190100,19061,0,0,91,59103,'Renown tier 3'),
(190100,19067,0,0,92,59103,'Renown tier 3'),
(190100,19515,0,0,93,59103,'Renown tier 3'),
(190100,19524,0,0,94,59103,'Renown tier 3'),
(190100,19532,0,0,95,59103,'Renown tier 3'),
(190100,19540,0,0,96,59103,'Renown tier 3'),
(190100,19548,0,0,97,59103,'Renown tier 3'),
(190100,19556,0,0,98,59103,'Renown tier 3'),
(190100,19564,0,0,99,59103,'Renown tier 3'),
(190100,19572,0,0,100,59103,'Renown tier 3'),
(190100,19581,0,0,101,59104,'Renown tier 4'),
(190100,19584,0,0,102,59104,'Renown tier 4'),
(190100,19590,0,0,103,59104,'Renown tier 4'),
(190100,19597,0,0,104,59104,'Renown tier 4'),
(190100,21565,0,0,105,59104,'Renown tier 4'),
(190100,21567,0,0,106,59104,'Renown tier 4'),
(190100,17348,0,0,107,59104,'Renown tier 4'),
(190100,17351,0,0,108,59104,'Renown tier 4'),
(190100,19060,0,0,109,59104,'Renown tier 4'),
(190100,19066,0,0,110,59104,'Renown tier 4'),
(190100,19516,0,0,111,59104,'Renown tier 4'),
(190100,19523,0,0,112,59104,'Renown tier 4'),
(190100,19531,0,0,113,59104,'Renown tier 4'),
(190100,19539,0,0,114,59104,'Renown tier 4'),
(190100,19547,0,0,115,59104,'Renown tier 4'),
(190100,19555,0,0,116,59104,'Renown tier 4'),
(190100,19563,0,0,117,59104,'Renown tier 4'),
(190100,19571,0,0,118,59104,'Renown tier 4'),
(190100,19580,0,0,119,59105,'Renown tier 5'),
(190100,19583,0,0,120,59105,'Renown tier 5'),
(190100,19589,0,0,121,59105,'Renown tier 5'),
(190100,19596,0,0,122,59105,'Renown tier 5'),
(190100,19514,0,0,123,59105,'Renown tier 5'),
(190100,19522,0,0,124,59105,'Renown tier 5'),
(190100,19530,0,0,125,59105,'Renown tier 5'),
(190100,19538,0,0,126,59105,'Renown tier 5'),
(190100,19546,0,0,127,59105,'Renown tier 5'),
(190100,19554,0,0,128,59105,'Renown tier 5'),
(190100,19562,0,0,129,59105,'Renown tier 5'),
(190100,19570,0,0,130,59105,'Renown tier 5'),
(190100,19578,0,0,131,59106,'Renown tier 6'),
(190100,19582,0,0,132,59106,'Renown tier 6'),
(190100,19587,0,0,133,59106,'Renown tier 6'),
(190100,19595,0,0,134,59106,'Renown tier 6'),
(190100,22672,0,0,135,59106,'Renown tier 6'),
(190100,22748,0,0,136,59106,'Renown tier 6'),
(190100,22749,0,0,137,59106,'Renown tier 6'),
(190100,22750,0,0,138,59106,'Renown tier 6'),
(190100,22752,0,0,139,59106,'Renown tier 6'),
(190100,22753,0,0,140,59106,'Renown tier 6'),
(190101,190600,0,0,0,0,'Renown open'),
(190101,190601,0,0,1,0,'Renown open'),
(190101,190602,0,0,2,0,'Renown open'),
(190101,190603,0,0,3,0,'Renown open'),
(190101,190604,0,0,4,0,'Renown open'),
(190101,190605,0,0,5,0,'Renown open'),
(190101,190606,0,0,6,0,'Renown open'),
(190101,190607,0,0,7,0,'Renown open'),
(190101,190608,0,0,8,0,'Renown open'),
(190101,190609,0,0,9,0,'Renown open'),
(190101,190610,0,0,10,0,'Renown open'),
(190101,190611,0,0,11,0,'Renown open'),
(190101,190612,0,0,12,0,'Renown open'),
(190101,190613,0,0,13,0,'Renown open'),
(190101,190614,0,0,14,0,'Renown open'),
(190101,190615,0,0,15,0,'Renown open'),
(190101,190616,0,0,16,0,'Renown open'),
(190101,190617,0,0,17,0,'Renown open'),
(190101,190618,0,0,18,0,'Renown open'),
(190101,190619,0,0,19,0,'Renown open'),
(190101,190620,0,0,20,0,'Renown open'),
(190101,190621,0,0,21,0,'Renown open'),
(190101,190622,0,0,22,0,'Renown open'),
(190101,190623,0,0,23,0,'Renown open'),
(190101,190624,0,0,24,0,'Renown open'),
(190101,190625,0,0,25,0,'Renown open'),
(190101,190626,0,0,26,0,'Renown open'),
(190101,190627,0,0,27,0,'Renown open'),
(190101,190628,0,0,28,0,'Renown open'),
(190101,190629,0,0,29,0,'Renown open'),
(190101,190630,0,0,30,0,'Renown open'),
(190101,190631,0,0,31,0,'Renown open'),
(190101,190632,0,0,32,0,'Renown open'),
(190101,190633,0,0,33,0,'Renown open'),
(190101,190634,0,0,34,59101,'Renown tier 1'),
(190101,190635,0,0,35,59101,'Renown tier 1'),
(190101,190636,0,0,36,59101,'Renown tier 1'),
(190101,190637,0,0,37,59101,'Renown tier 1'),
(190101,190638,0,0,38,59101,'Renown tier 1'),
(190101,190639,0,0,39,59101,'Renown tier 1'),
(190101,190640,0,0,40,59101,'Renown tier 1'),
(190101,190641,0,0,41,59101,'Renown tier 1'),
(190101,190642,0,0,42,59101,'Renown tier 1'),
(190101,190643,0,0,43,59101,'Renown tier 1'),
(190101,190644,0,0,44,59101,'Renown tier 1'),
(190101,190645,0,0,45,59101,'Renown tier 1'),
(190101,190646,0,0,46,59101,'Renown tier 1'),
(190101,190647,0,0,47,59101,'Renown tier 1'),
(190101,190648,0,0,48,59101,'Renown tier 1'),
(190101,190649,0,0,49,59101,'Renown tier 1'),
(190101,190650,0,0,50,59101,'Renown tier 1'),
(190101,190651,0,0,51,59101,'Renown tier 1'),
(190101,190652,0,0,52,59101,'Renown tier 1'),
(190101,190653,0,0,53,59101,'Renown tier 1'),
(190101,190654,0,0,54,59101,'Renown tier 1'),
(190101,190655,0,0,55,59101,'Renown tier 1'),
(190101,190656,0,0,56,59101,'Renown tier 1'),
(190101,190657,0,0,57,59101,'Renown tier 1'),
(190101,190658,0,0,58,59101,'Renown tier 1'),
(190101,190659,0,0,59,59101,'Renown tier 1'),
(190101,190660,0,0,60,59101,'Renown tier 1'),
(190101,190661,0,0,61,59101,'Renown tier 1'),
(190101,190662,0,0,62,59101,'Renown tier 1'),
(190101,190663,0,0,63,59101,'Renown tier 1'),
(190101,190664,0,0,64,59101,'Renown tier 1'),
(190101,190665,0,0,65,59101,'Renown tier 1'),
(190101,190666,0,0,66,59101,'Renown tier 1'),
(190101,190667,0,0,67,59101,'Renown tier 1'),
(190101,19505,0,0,68,59103,'Renown tier 3'),
(190101,20425,0,0,69,59101,'Renown tier 1'),
(190101,20426,0,0,70,59101,'Renown tier 1'),
(190101,20427,0,0,71,59101,'Renown tier 1'),
(190101,20429,0,0,72,59101,'Renown tier 1'),
(190101,20430,0,0,73,59101,'Renown tier 1'),
(190101,20437,0,0,74,59101,'Renown tier 1'),
(190101,20441,0,0,75,59101,'Renown tier 1'),
(190101,20442,0,0,76,59101,'Renown tier 1'),
(190101,21566,0,0,77,59101,'Renown tier 1'),
(190101,21568,0,0,78,59101,'Renown tier 1'),
(190101,19062,0,0,79,59102,'Renown tier 2'),
(190101,19068,0,0,80,59102,'Renown tier 2'),
(190101,19513,0,0,81,59102,'Renown tier 2'),
(190101,19521,0,0,82,59102,'Renown tier 2'),
(190101,19529,0,0,83,59102,'Renown tier 2'),
(190101,19537,0,0,84,59102,'Renown tier 2'),
(190101,19545,0,0,85,59102,'Renown tier 2'),
(190101,19553,0,0,86,59102,'Renown tier 2'),
(190101,19561,0,0,87,59102,'Renown tier 2'),
(190101,19569,0,0,88,59102,'Renown tier 2'),
(190101,17349,0,0,89,59103,'Renown tier 3'),
(190101,17352,0,0,90,59103,'Renown tier 3'),
(190101,19061,0,0,91,59103,'Renown tier 3'),
(190101,19067,0,0,92,59103,'Renown tier 3'),
(190101,19512,0,0,93,59103,'Renown tier 3'),
(190101,19520,0,0,94,59103,'Renown tier 3'),
(190101,19528,0,0,95,59103,'Renown tier 3'),
(190101,19536,0,0,96,59103,'Renown tier 3'),
(190101,19544,0,0,97,59103,'Renown tier 3'),
(190101,19552,0,0,98,59103,'Renown tier 3'),
(190101,19560,0,0,99,59103,'Renown tier 3'),
(190101,19568,0,0,100,59103,'Renown tier 3'),
(190101,19581,0,0,101,59104,'Renown tier 4'),
(190101,19584,0,0,102,59104,'Renown tier 4'),
(190101,19590,0,0,103,59104,'Renown tier 4'),
(190101,19597,0,0,104,59104,'Renown tier 4'),
(190101,21565,0,0,105,59104,'Renown tier 4'),
(190101,21567,0,0,106,59104,'Renown tier 4'),
(190101,17348,0,0,107,59104,'Renown tier 4'),
(190101,17351,0,0,108,59104,'Renown tier 4'),
(190101,19060,0,0,109,59104,'Renown tier 4'),
(190101,19066,0,0,110,59104,'Renown tier 4'),
(190101,19511,0,0,111,59104,'Renown tier 4'),
(190101,19519,0,0,112,59104,'Renown tier 4'),
(190101,19527,0,0,113,59104,'Renown tier 4'),
(190101,19535,0,0,114,59104,'Renown tier 4'),
(190101,19543,0,0,115,59104,'Renown tier 4'),
(190101,19551,0,0,116,59104,'Renown tier 4'),
(190101,19559,0,0,117,59104,'Renown tier 4'),
(190101,19567,0,0,118,59104,'Renown tier 4'),
(190101,19580,0,0,119,59105,'Renown tier 5'),
(190101,19583,0,0,120,59105,'Renown tier 5'),
(190101,19589,0,0,121,59105,'Renown tier 5'),
(190101,19596,0,0,122,59105,'Renown tier 5'),
(190101,19510,0,0,123,59105,'Renown tier 5'),
(190101,19518,0,0,124,59105,'Renown tier 5'),
(190101,19526,0,0,125,59105,'Renown tier 5'),
(190101,19534,0,0,126,59105,'Renown tier 5'),
(190101,19542,0,0,127,59105,'Renown tier 5'),
(190101,19550,0,0,128,59105,'Renown tier 5'),
(190101,19558,0,0,129,59105,'Renown tier 5'),
(190101,19566,0,0,130,59105,'Renown tier 5'),
(190101,19578,0,0,131,59106,'Renown tier 6'),
(190101,19582,0,0,132,59106,'Renown tier 6'),
(190101,19587,0,0,133,59106,'Renown tier 6'),
(190101,19595,0,0,134,59106,'Renown tier 6'),
(190101,22651,0,0,135,59106,'Renown tier 6'),
(190101,22673,0,0,136,59106,'Renown tier 6'),
(190101,22676,0,0,137,59106,'Renown tier 6'),
(190101,22740,0,0,138,59106,'Renown tier 6'),
(190101,22741,0,0,139,59106,'Renown tier 6'),
(190101,22747,0,0,140,59106,'Renown tier 6');

-- Renown prices: read by the Renown server module (paid with spendable Renown points, not gold).
-- Gold price is 0 so the client never blocks the purchase for lack of money; the RenownBar addon shows the Renown cost.
CREATE TABLE IF NOT EXISTS custom_renown_vendor (item MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY, cost INT UNSIGNED NOT NULL DEFAULT 0) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Renown vendor prices';
DELETE FROM custom_renown_vendor;
INSERT INTO custom_renown_vendor (item,cost) VALUES
(19505,125),
(19506,125),
(19510,360),
(19511,240),
(19512,150),
(19513,90),
(19514,360),
(19515,150),
(19516,240),
(19517,90),
(19518,360),
(19519,240),
(19520,150),
(19521,90),
(19522,360),
(19523,240),
(19524,150),
(19525,90),
(19526,360),
(19527,240),
(19528,150),
(19529,90),
(19530,360),
(19531,240),
(19532,150),
(19533,90),
(19534,360),
(19535,240),
(19536,150),
(19537,90),
(19538,360),
(19539,240),
(19540,150),
(19541,90),
(19542,480),
(19543,320),
(19544,200),
(19545,120),
(19546,480),
(19547,320),
(19548,200),
(19549,120),
(19550,480),
(19551,320),
(19552,200),
(19553,120),
(19554,480),
(19555,320),
(19556,200),
(19557,120),
(19558,360),
(19559,240),
(19560,150),
(19561,90),
(19562,360),
(19563,240),
(19564,150),
(19565,90),
(19566,600),
(19567,400),
(19568,250),
(19569,150),
(19570,600),
(19571,400),
(19572,250),
(19573,150),
(19578,450),
(19580,300),
(19581,200),
(19582,450),
(19583,300),
(19584,200),
(19587,450),
(19589,300),
(19590,200),
(19595,450),
(19596,300),
(19597,200),
(20425,80),
(20426,50),
(20427,50),
(20428,50),
(20429,50),
(20430,65),
(20431,50),
(20434,80),
(20437,50),
(20438,50),
(20439,50),
(20440,65),
(20441,65),
(20442,50),
(20443,65),
(20444,50),
(21565,240),
(21566,50),
(21567,240),
(21568,50),
(22651,900),
(22672,900),
(22673,900),
(22676,900),
(22740,900),
(22741,900),
(22747,900),
(22748,900),
(22749,900),
(22750,900),
(22752,900),
(22753,900),
(190600,30),
(190601,30),
(190602,20),
(190603,20),
(190604,20),
(190605,30),
(190606,30),
(190607,20),
(190608,20),
(190609,20),
(190610,30),
(190611,30),
(190612,20),
(190613,20),
(190614,20),
(190615,30),
(190616,30),
(190617,20),
(190618,20),
(190619,20),
(190620,20),
(190621,20),
(190622,20),
(190623,20),
(190624,20),
(190625,20),
(190626,25),
(190627,30),
(190628,25),
(190629,25),
(190630,30),
(190631,20),
(190632,20),
(190633,20),
(190634,80),
(190635,80),
(190636,60),
(190637,60),
(190638,60),
(190639,80),
(190640,80),
(190641,60),
(190642,60),
(190643,60),
(190644,80),
(190645,80),
(190646,60),
(190647,60),
(190648,60),
(190649,80),
(190650,80),
(190651,60),
(190652,60),
(190653,60),
(190654,50),
(190655,50),
(190656,50),
(190657,50),
(190658,50),
(190659,50),
(190660,65),
(190661,80),
(190662,65),
(190663,65),
(190664,80),
(190665,50),
(190666,50),
(190667,50);
UPDATE item_template i JOIN custom_renown_vendor c ON c.item=i.entry SET i.BuyPrice=0, i.SellPrice=0;

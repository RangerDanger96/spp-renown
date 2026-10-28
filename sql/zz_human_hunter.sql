-- ============================================================
-- Human Hunters (needs the client patch Data\patch-3.MPQ to pick the class at character creation)
-- Starting gear comes from CharStartOutfit.dbc (server and client copies updated with the patch).
-- Re-runnable. Trainers 190830 (hunter) and 190831 (pet), spawns 9100200-9100202.
-- ============================================================
DELETE FROM playercreateinfo WHERE race=1 AND class=3;
DELETE FROM playercreateinfo_spell WHERE race=1 AND class=3;
DELETE FROM playercreateinfo_action WHERE race=1 AND class=3;
DELETE FROM playercreateinfo_skills WHERE raceMask=1 AND classMask=4;
DELETE FROM player_levelstats WHERE race=1 AND class=3;
DELETE FROM creature WHERE guid BETWEEN 9100200 AND 9100202;
DELETE FROM creature_template WHERE Entry IN (190830,190831);
DELETE FROM npc_trainer WHERE entry IN (190830,190831);

-- Start in Northshire like every human
INSERT INTO playercreateinfo (race,class,map,zone,position_x,position_y,position_z,orientation) VALUES (1,3,0,12,-8949.95,-132.493,83.5312,0);

-- Hunter spells (from the Dwarf Hunter) without dwarf racials, axes and guns; plus human racials, bows and daggers
INSERT INTO playercreateinfo_spell (race,class,Spell,Note)
SELECT 1,3,Spell,Note FROM playercreateinfo_spell WHERE race=3 AND class=3 AND Spell NOT IN (672,2481,20594,20595,20596,196,266);
INSERT INTO playercreateinfo_spell (race,class,Spell,Note) VALUES
(1,3,264,'Bows'),(1,3,1180,'Daggers'),(1,3,20597,'Sword Specialization'),(1,3,20598,'The Human Spirit'),
(1,3,20599,'Diplomacy'),(1,3,20600,'Perception'),(1,3,20864,'Mace Specialization');

INSERT INTO playercreateinfo_action (race,class,button,action,type) VALUES
(1,3,0,6603,0),(1,3,1,2973,0),(1,3,2,75,0),(1,3,10,159,128),(1,3,11,117,128);

INSERT INTO playercreateinfo_skills (raceMask,classMask,skill,step,note) VALUES
(1,4,45,0,'Weapon: Bows (Human Hunter)'),(1,4,173,0,'Weapon: Daggers (Human Hunter)');

-- Base stats: Dwarf Hunter adjusted from dwarf (22/16/23/19/19) to human (20/20/20/20/21) racial stats
INSERT INTO player_levelstats (race,class,level,str,agi,sta,inte,spi)
SELECT 1,3,level,str-2,agi+4,sta-3,inte+1,spi+2 FROM player_levelstats WHERE race=3 AND class=3;

-- Trainers: a hunter trainer (also teaches Tame Beast and Beast Training at 10, the taming quests are race locked)
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=1231;
UPDATE tmp_ct SET Entry=190830, Name='Huntsman Aldric Vale', SubName='Hunter Trainer', Faction=12, TrainerRace=0, TrainerTemplateId=0;
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;
CREATE TEMPORARY TABLE tmp_ct SELECT * FROM creature_template WHERE Entry=2878;
UPDATE tmp_ct SET Entry=190831, Name='Mara Thornfield', SubName='Pet Trainer', Faction=12, TrainerRace=0, TrainerTemplateId=0;
INSERT INTO creature_template SELECT * FROM tmp_ct;
DROP TEMPORARY TABLE IF EXISTS tmp_ct;

INSERT INTO npc_trainer (entry,spell,spellcost,reqskill,reqskillvalue,reqlevel,ReqAbility1,ReqAbility2,ReqAbility3,condition_id)
SELECT 190830,spell,spellcost,reqskill,reqskillvalue,reqlevel,ReqAbility1,ReqAbility2,ReqAbility3,condition_id FROM npc_trainer WHERE entry=1231;
INSERT INTO npc_trainer (entry,spell,spellcost,reqskill,reqskillvalue,reqlevel,condition_id) VALUES
(190830,1579,0,0,0,10,0),   -- Tame Beast (+ Call Pet, Dismiss Pet)
(190830,5300,0,0,0,10,0);   -- Beast Training (+ Feed Pet, Revive Pet)
INSERT INTO npc_trainer (entry,spell,spellcost,reqskill,reqskillvalue,reqlevel,ReqAbility1,ReqAbility2,ReqAbility3,condition_id)
SELECT 190831,spell,spellcost,reqskill,reqskillvalue,reqlevel,ReqAbility1,ReqAbility2,ReqAbility3,condition_id FROM npc_trainer WHERE entry=2878;

-- Northshire Abbey next to the warrior trainer, Goldshire next to the warrior trainer and the stable master
INSERT INTO creature (guid,id,map,spawnMask,position_x,position_y,position_z,orientation,spawntimesecsmin,spawntimesecsmax,spawndist,MovementType) VALUES
(9100200,190830,0,1,-8921.20,-212.40,82.31,0.90,300,300,0,0),
(9100201,190830,0,1,-9464.60,111.80,57.88,5.20,300,300,0,0),
(9100202,190831,0,1,-9469.20,46.20,56.97,1.47,300,300,0,0);

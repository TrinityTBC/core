-- Remove the npc Quel'Delar summond by a spell
DELETE FROM `creature` WHERE `guid` IN (123721);
DELETE FROM `creature_addon` WHERE `guid` IN (123721);

-- Update size for gobs used by the quest Guardians of the Altar
UPDATE `gameobject_template`  SET `size`=8 WHERE `entry` IN (177414);
UPDATE `gameobject_template`  SET `size`=2 WHERE `entry` IN (177415);

-- Remove wrong Herald spawn used in  Alterac Valley from Exodar
DELETE FROM `creature` WHERE `id` IN (14848);

-- Update Marksman Bova & Korim position
UPDATE `creature` SET `position_x`=-1721.397217, `position_y`=5637.887695, `position_z`=128.023605, `orientation`=2.859651 WHERE `guid`= 85406; 
UPDATE `creature` SET `position_x`=-1712.549561, `position_y`=5646.225098, `position_z`=128.024399, `orientation`=3.322971 WHERE `guid`= 88265; 

-- Remove Captured Rageclaw DB spawns as summoned by a script
DELETE FROM `creature` WHERE `id`=29686;
DELETE FROM `spawn_group` WHERE `spawnId` IN (119104, 119105, 119106, 119107, 119108, 119109, 119110, 119111, 119114, 119115, 119116, 119117, 119118, 119119, 119120, 119121, 119143) AND `spawnType`=0;


-- Migrate the entire creature system from TC
-- Tables to migrate:
--   creature
--   creature_addon
--   creature_classlevelstats
--   creature_default_trainer
--   creature_equip_template
--   creature_formations
--   creature_model_info
--   creature_movement_override
--   creature_onkill_reputation
--   creature_summon_groups
--   creature_template
--   creature_template_addon
--   creature_template_locale
--   creature_template_movement
--   creature_template_resistance
--   creature_template_spell
--   creature_text
--   creature_text_locale
--   linked_respawn
--   waypoints
--   waypoint_data
--   game_event
--   game_event_arena_seasons
--   game_event_creature
--   game_event_creature_quest
--   game_event_model_equip
--   game_event_npc_vendor
--   game_event_npcflag
--   game_event_pool
--   game_event_prerequisite
--   game_event_quest_condition
--   game_event_seasonal_questrelation
--   game_event_battleground_holiday
--   pool_template
--   pool_members
--   quest_pool_members
--   quest_pool_template



-- Migrate the entire gameobject system from TC
-- Tables to migrate:
--   gameobject
--   gameobject_template
--   gameobject_template_locale
--   game_event_gameobject
--   game_event_gameobject_quest


-- Migrate the entire smart_scripts from TC

DROP TABLE IF EXISTS `creature_entry`;
DROP TABLE IF EXISTS `creature_battleground`;
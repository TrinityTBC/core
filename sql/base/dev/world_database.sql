-- MySQL dump 10.13  Distrib 5.7.23, for Win64 (x86_64)
--
-- Host: localhost    Database: world
-- ------------------------------------------------------
-- Server version	5.7.23-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `access_requirement`
--

DROP TABLE IF EXISTS `access_requirement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `access_requirement` (
  `id` int(11) unsigned NOT NULL COMMENT 'Identifier',
  `level_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `level_max` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `item` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `item2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `heroic_key` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `heroic_key2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `quest_done` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `quest_failed_text` int(11) unsigned NOT NULL DEFAULT '0',
  `heroic_quest_done` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `heroic_quest_failed_text` int(11) unsigned NOT NULL DEFAULT '0',
  `comment` text CHARACTER SET latin1,
  `disabled` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'disable requirement',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ai_playerbot_speech`
--

DROP TABLE IF EXISTS `ai_playerbot_speech`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ai_playerbot_speech` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `text` varchar(1024) NOT NULL,
  `type` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ai_playerbot_speech_probability`
--

DROP TABLE IF EXISTS `ai_playerbot_speech_probability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ai_playerbot_speech_probability` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `probability` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `areatrigger_involvedrelation`
--

DROP TABLE IF EXISTS `areatrigger_involvedrelation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `areatrigger_involvedrelation` (
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Identifier',
  `quest` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Quest Identifier',
  PRIMARY KEY (`id`),
  KEY `quest` (`quest`),
  CONSTRAINT `areatrigger_involvedrelation_ibfk_2` FOREIGN KEY (`quest`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `areatrigger_scripts`
--

DROP TABLE IF EXISTS `areatrigger_scripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `areatrigger_scripts` (
  `entry` mediumint(8) NOT NULL,
  `ScriptName` char(64) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `areatrigger_tavern`
--

DROP TABLE IF EXISTS `areatrigger_tavern`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `areatrigger_tavern` (
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Identifier',
  `name` text CHARACTER SET latin1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `areatrigger_teleport`
--

DROP TABLE IF EXISTS `areatrigger_teleport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `areatrigger_teleport` (
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Identifier',
  `patch` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `name` text CHARACTER SET latin1,
  `access_id` int(11) unsigned NOT NULL DEFAULT '0',
  `target_map` smallint(5) unsigned NOT NULL DEFAULT '0',
  `target_position_x` float NOT NULL DEFAULT '0',
  `target_position_y` float NOT NULL DEFAULT '0',
  `target_position_z` float NOT NULL DEFAULT '0',
  `target_orientation` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`,`patch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auto_ann_by_time`
--

DROP TABLE IF EXISTS `auto_ann_by_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auto_ann_by_time` (
  `id` int(11) NOT NULL,
  `message` text CHARACTER SET latin1 NOT NULL,
  `hour` int(11) NOT NULL DEFAULT '0',
  `minute` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `battleground_events`
--

DROP TABLE IF EXISTS `battleground_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `battleground_events` (
  `map` smallint(5) NOT NULL,
  `event1` tinyint(3) unsigned NOT NULL,
  `event2` tinyint(3) unsigned NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`map`,`event1`,`event2`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `battleground_template`
--

DROP TABLE IF EXISTS `battleground_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `battleground_template` (
  `id` mediumint(8) unsigned NOT NULL,
  `patch` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MinPlayersPerTeam` smallint(5) unsigned NOT NULL DEFAULT '0',
  `MaxPlayersPerTeam` smallint(5) unsigned NOT NULL DEFAULT '0',
  `MinLvl` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MaxLvl` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `AllianceStartLoc` mediumint(8) unsigned NOT NULL,
  `AllianceStartO` float NOT NULL,
  `HordeStartLoc` mediumint(8) unsigned NOT NULL,
  `HordeStartO` float NOT NULL,
  `StartMaxDist` float NOT NULL DEFAULT '0',
  `ScriptName` char(64) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `Comment` char(32) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`,`patch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `battlemaster_entry`
--

DROP TABLE IF EXISTS `battlemaster_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `battlemaster_entry` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Entry of a creature',
  `bg_template` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Battleground template id',
  PRIMARY KEY (`entry`),
  KEY `bg_template` (`bg_template`),
  CONSTRAINT `battlemaster_entry_ibfk_2` FOREIGN KEY (`entry`) REFERENCES `creature_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `battlemaster_entry_ibfk_3` FOREIGN KEY (`bg_template`) REFERENCES `battleground_template` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boost_pack`
--

DROP TABLE IF EXISTS `boost_pack`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boost_pack` (
  `level` smallint(5) unsigned NOT NULL,
  `class` smallint(5) unsigned NOT NULL,
  `type` smallint(5) unsigned NOT NULL,
  `item` mediumint(8) unsigned NOT NULL COMMENT 'item id',
  `count` mediumint(8) NOT NULL DEFAULT '1',
  PRIMARY KEY (`level`,`class`,`type`,`item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `broadcast_text`
--

DROP TABLE IF EXISTS `broadcast_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `broadcast_text` (
  `ID` int(11) unsigned NOT NULL,
  `Language` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `MaleText` longtext,
  `FemaleText` longtext,
  `EmoteID0` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `EmoteID1` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `EmoteID2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `EmoteDelay0` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `EmoteDelay1` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `EmoteDelay2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `SoundId` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Unk1` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Unk2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `VerifiedBuild` smallint(5) DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `broadcast_text_locale`
--

DROP TABLE IF EXISTS `broadcast_text_locale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `broadcast_text_locale` (
  `ID` int(11) unsigned NOT NULL DEFAULT '0',
  `locale` varchar(4) NOT NULL,
  `MaleText` text,
  `FemaleText` text,
  `VerifiedBuild` smallint(5) DEFAULT '0',
  PRIMARY KEY (`ID`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `command`
--

DROP TABLE IF EXISTS `command`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `command` (
  `name` varchar(50) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `security` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `help` longtext CHARACTER SET latin1,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `conditions`
--

DROP TABLE IF EXISTS `conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `conditions` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `SourceTypeOrReferenceId` mediumint(8) NOT NULL DEFAULT '0',
  `SourceGroup` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `SourceEntry` mediumint(8) NOT NULL DEFAULT '0',
  `SourceId` int(11) NOT NULL DEFAULT '0',
  `ElseGroup` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ConditionTypeOrReference` mediumint(8) NOT NULL DEFAULT '0',
  `ConditionTarget` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `ConditionValue1` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ConditionValue2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ConditionValue3` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `NegativeCondition` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `ErrorType` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ErrorTextId` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ScriptName` char(64) NOT NULL DEFAULT '',
  `Comment` varchar(255) DEFAULT NULL,
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`)
) ENGINE=InnoDB AUTO_INCREMENT=5612 DEFAULT CHARSET=utf8 COMMENT='Condition System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature`
--

DROP TABLE IF EXISTS `creature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature` (
  `spawnID` int(10) unsigned NOT NULL,
  `map` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Map Identifier',
  `spawnMask` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `modelid` mediumint(8) unsigned DEFAULT NULL,
  `equipment_id` tinyint(1) NOT NULL DEFAULT '0',
  `position_x` float NOT NULL DEFAULT '0',
  `position_y` float NOT NULL DEFAULT '0',
  `position_z` float NOT NULL DEFAULT '0',
  `orientation` float NOT NULL DEFAULT '0',
  `spawntimesecs` int(10) unsigned NOT NULL DEFAULT '300',
  `spawntimesecs_max` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'If specified, rand between spawntimesecs and spawntimesecs_max',
  `spawndist` float NOT NULL DEFAULT '5',
  `currentwaypoint` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `curhealth` int(10) unsigned NOT NULL DEFAULT '1',
  `curmana` int(10) unsigned NOT NULL DEFAULT '0',
  `MovementType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `unit_flags` int(10) unsigned NOT NULL DEFAULT '0',
  `pool_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ScriptName` char(64) COLLATE utf8_bin DEFAULT '',
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`spawnID`,`patch_min`),
  KEY `idx_map` (`map`),
  KEY `creature_ibfk_2` (`modelid`),
  CONSTRAINT `creature_ibfk_2` FOREIGN KEY (`modelid`) REFERENCES `creature_model_info` (`modelid`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_addon`
--

DROP TABLE IF EXISTS `creature_addon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_addon` (
  `spawnID` int(10) unsigned NOT NULL DEFAULT '0',
  `patch` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `path_id` int(10) unsigned DEFAULT NULL,
  `mount` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `bytes0` int(10) unsigned NOT NULL DEFAULT '0',
  `bytes1` int(10) unsigned NOT NULL DEFAULT '0',
  `bytes2` int(10) unsigned NOT NULL DEFAULT '0',
  `emote` int(10) unsigned NOT NULL DEFAULT '0',
  `moveflags` int(10) unsigned NOT NULL DEFAULT '0',
  `visibilityDistanceType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `auras` text CHARACTER SET latin1,
  PRIMARY KEY (`spawnID`,`patch`),
  KEY `path_id` (`path_id`),
  CONSTRAINT `creature_addon_ibfk_1` FOREIGN KEY (`spawnID`) REFERENCES `creature` (`spawnID`) ON UPDATE CASCADE,
  CONSTRAINT `creature_addon_ibfk_2` FOREIGN KEY (`path_id`) REFERENCES `waypoint_data` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_battleground`
--

DROP TABLE IF EXISTS `creature_battleground`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_battleground` (
  `spawnID` int(10) unsigned NOT NULL COMMENT 'Creature''s spawnID',
  `event1` tinyint(3) unsigned NOT NULL COMMENT 'main event',
  `event2` tinyint(3) unsigned NOT NULL COMMENT 'sub event',
  PRIMARY KEY (`spawnID`,`event1`),
  CONSTRAINT `creature_battleground_ibfk_1` FOREIGN KEY (`spawnID`) REFERENCES `creature` (`spawnID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Creature battleground indexing system';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_classlevelstats`
--

DROP TABLE IF EXISTS `creature_classlevelstats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_classlevelstats` (
  `level` tinyint(3) unsigned NOT NULL,
  `class` tinyint(3) unsigned NOT NULL,
  `basehp0` smallint(5) unsigned NOT NULL DEFAULT '1',
  `basehp1` smallint(5) unsigned NOT NULL DEFAULT '1',
  `basehp2` smallint(5) unsigned NOT NULL DEFAULT '1',
  `basemana` smallint(5) unsigned NOT NULL DEFAULT '0',
  `basearmor` smallint(5) unsigned NOT NULL DEFAULT '1',
  `attackpower` smallint(5) unsigned NOT NULL DEFAULT '0',
  `rangedattackpower` smallint(5) unsigned NOT NULL DEFAULT '0',
  `damage_base` float NOT NULL DEFAULT '0',
  `damage_exp1` float NOT NULL DEFAULT '0',
  `damage_exp2` float NOT NULL DEFAULT '0',
  `comment` text CHARACTER SET latin1,
  PRIMARY KEY (`level`,`class`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_default_trainer`
--

DROP TABLE IF EXISTS `creature_default_trainer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_default_trainer` (
  `CreatureId` mediumint(8) unsigned NOT NULL,
  `TrainerId` int(10) unsigned NOT NULL,
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`CreatureId`,`patch_min`,`patch_max`),
  CONSTRAINT `creature_default_trainer_ibfk_1` FOREIGN KEY (`CreatureId`) REFERENCES `creature_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_difficulty_flags`
--

DROP TABLE IF EXISTS `creature_difficulty_flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_difficulty_flags` (
  `CreatureId` int(11) unsigned NOT NULL DEFAULT '0',
  `FactionTemplateId` int(11) NOT NULL DEFAULT '0',
  `Expansion` int(11) NOT NULL DEFAULT '0',
  `MinLevel` int(11) NOT NULL DEFAULT '0',
  `MaxLevel` int(11) NOT NULL DEFAULT '0',
  `Flags1` int(10) unsigned NOT NULL DEFAULT '0',
  `Flags2` int(10) unsigned NOT NULL DEFAULT '0',
  `Flags3` int(10) unsigned NOT NULL DEFAULT '0',
  `Flags4` int(10) unsigned NOT NULL DEFAULT '0',
  `Flags5` int(10) unsigned NOT NULL DEFAULT '0',
  KEY `idx` (`CreatureId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Export of CreatureDifficulty.adb\r\n\r\nhttps://github.com/TrinityCore/TrinityCore/pull/22892#issuecomment-450499868';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_entry`
--

DROP TABLE IF EXISTS `creature_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_entry` (
  `spawnID` int(10) unsigned NOT NULL,
  `entry` mediumint(8) unsigned NOT NULL,
  `equipment_id` tinyint(1) NOT NULL DEFAULT '-1' COMMENT '-1: random, 0: no equipment, >0 equipment id',
  PRIMARY KEY (`spawnID`,`entry`),
  KEY `entry` (`entry`),
  CONSTRAINT `creature_entry_ibfk_1` FOREIGN KEY (`entry`) REFERENCES `creature_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `creature_entry_ibfk_2` FOREIGN KEY (`spawnID`) REFERENCES `creature` (`spawnID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_equip_template`
--

DROP TABLE IF EXISTS `creature_equip_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_equip_template` (
  `creatureID` mediumint(8) unsigned NOT NULL,
  `id` tinyint(1) NOT NULL DEFAULT '1',
  `patch` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `equipmodel1` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `equipmodel2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `equipmodel3` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `equipinfo1` int(10) unsigned NOT NULL DEFAULT '0',
  `equipinfo2` int(10) unsigned NOT NULL DEFAULT '0',
  `equipinfo3` int(10) unsigned NOT NULL DEFAULT '0',
  `equipslot1` int(11) NOT NULL DEFAULT '0',
  `equipslot2` int(11) NOT NULL DEFAULT '0',
  `equipslot3` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`creatureID`,`id`,`patch`),
  CONSTRAINT `creature_equip_template_ibfk_1` FOREIGN KEY (`creatureID`) REFERENCES `creature_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_formations`
--

DROP TABLE IF EXISTS `creature_formations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_formations` (
  `leaderGUID` int(10) unsigned DEFAULT '0',
  `memberGUID` int(10) unsigned NOT NULL DEFAULT '0',
  `dist` float unsigned NOT NULL DEFAULT '0',
  `angle` float DEFAULT NULL,
  `groupAI` int(11) unsigned NOT NULL,
  `respawn` tinyint(1) DEFAULT '0' COMMENT 'respawn when group is ooc',
  `linkedloot` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`memberGUID`),
  KEY `leaderGUID` (`leaderGUID`),
  CONSTRAINT `creature_formations_ibfk_1` FOREIGN KEY (`leaderGUID`) REFERENCES `creature` (`spawnID`) ON UPDATE CASCADE,
  CONSTRAINT `creature_formations_ibfk_3` FOREIGN KEY (`memberGUID`) REFERENCES `creature` (`spawnID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_loot_template`
--

DROP TABLE IF EXISTS `creature_loot_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_loot_template` (
  `Entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Reference` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Chance` float NOT NULL DEFAULT '100',
  `QuestRequired` tinyint(1) NOT NULL DEFAULT '0',
  `LootMode` smallint(5) unsigned NOT NULL DEFAULT '1',
  `GroupId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MinCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `MaxCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Comment` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`Entry`,`Item`,`patch_min`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_model_info`
--

DROP TABLE IF EXISTS `creature_model_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_model_info` (
  `modelid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `patch` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `bounding_radius` float NOT NULL DEFAULT '0',
  `combat_reach` float NOT NULL DEFAULT '0',
  `gender` tinyint(3) unsigned NOT NULL DEFAULT '2',
  `modelid_other_gender` mediumint(8) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`modelid`,`patch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_movement_override`
--

DROP TABLE IF EXISTS `creature_movement_override`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_movement_override` (
  `SpawnId` int(10) unsigned NOT NULL DEFAULT '0',
  `Ground` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Swim` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Flight` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Rooted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`SpawnId`),
  CONSTRAINT `creature_movement_override_ibfk_1` FOREIGN KEY (`SpawnId`) REFERENCES `creature` (`spawnID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_onkill_reputation`
--

DROP TABLE IF EXISTS `creature_onkill_reputation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_onkill_reputation` (
  `creature_id` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Creature Identifier',
  `RewOnKillRepFaction1` int(11) unsigned NOT NULL DEFAULT '0',
  `RewOnKillRepFaction2` int(11) unsigned NOT NULL DEFAULT '0',
  `MaxStanding1` tinyint(4) NOT NULL DEFAULT '0',
  `IsTeamAward1` tinyint(4) NOT NULL DEFAULT '0',
  `RewOnKillRepValue1` int(11) NOT NULL DEFAULT '0',
  `MaxStanding2` tinyint(4) NOT NULL DEFAULT '0',
  `IsTeamAward2` tinyint(4) NOT NULL DEFAULT '0',
  `RewOnKillRepValue2` int(11) NOT NULL DEFAULT '0',
  `TeamDependent` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`creature_id`),
  CONSTRAINT `creature_onkill_reputation_ibfk_1` FOREIGN KEY (`creature_id`) REFERENCES `creature_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_questender`
--

DROP TABLE IF EXISTS `creature_questender`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_questender` (
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Identifier',
  `quest` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Quest Identifier',
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`id`,`quest`),
  KEY `quest` (`quest`),
  CONSTRAINT `creature_questender_ibfk_4` FOREIGN KEY (`id`) REFERENCES `creature_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `creature_questender_ibfk_5` FOREIGN KEY (`quest`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_queststarter`
--

DROP TABLE IF EXISTS `creature_queststarter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_queststarter` (
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Identifier',
  `quest` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Quest Identifier',
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`id`,`quest`),
  KEY `quest` (`quest`),
  CONSTRAINT `creature_queststarter_ibfk_3` FOREIGN KEY (`id`) REFERENCES `creature_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `creature_queststarter_ibfk_4` FOREIGN KEY (`quest`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_summon_groups`
--

DROP TABLE IF EXISTS `creature_summon_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_summon_groups` (
  `summonerId` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `summonerType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `groupId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `position_x` float NOT NULL DEFAULT '0',
  `position_y` float NOT NULL DEFAULT '0',
  `position_z` float NOT NULL DEFAULT '0',
  `orientation` float NOT NULL DEFAULT '0',
  `summonType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `summonTime` int(10) unsigned NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_template`
--

DROP TABLE IF EXISTS `creature_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_template` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `patch` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `difficulty_entry_1` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `modelid1` mediumint(8) unsigned DEFAULT NULL,
  `modelid2` mediumint(8) unsigned DEFAULT NULL,
  `modelid3` mediumint(8) unsigned DEFAULT NULL,
  `modelid4` mediumint(8) unsigned DEFAULT NULL,
  `name` char(100) NOT NULL DEFAULT '0',
  `subname` char(100) DEFAULT NULL,
  `IconName` char(100) DEFAULT NULL,
  `gossip_menu_id` smallint(5) unsigned DEFAULT NULL,
  `minlevel` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `maxlevel` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `exp` smallint(6) NOT NULL DEFAULT '0',
  `faction` smallint(5) unsigned NOT NULL DEFAULT '35',
  `npcflag` int(10) unsigned NOT NULL DEFAULT '0',
  `speed_walk` float NOT NULL DEFAULT '1' COMMENT 'Result of 2.5/2.5, most common value',
  `speed_run` float NOT NULL DEFAULT '1.14286' COMMENT 'Result of 8.0/7.0, most common value',
  `scale` float NOT NULL DEFAULT '1',
  `rank` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dmgschool` tinyint(4) NOT NULL DEFAULT '0',
  `BaseAttackTime` int(10) unsigned NOT NULL DEFAULT '2000',
  `RangeAttackTime` int(10) unsigned NOT NULL DEFAULT '0',
  `BaseVariance` float NOT NULL DEFAULT '1',
  `RangeVariance` float NOT NULL DEFAULT '1',
  `unit_class` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `unit_flags` int(10) unsigned NOT NULL DEFAULT '0',
  `unit_flags2` int(10) unsigned NOT NULL DEFAULT '0',
  `dynamicflags` int(10) unsigned NOT NULL DEFAULT '0',
  `family` tinyint(4) NOT NULL DEFAULT '0',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `type_flags` int(10) unsigned NOT NULL DEFAULT '0',
  `lootid` mediumint(8) unsigned DEFAULT NULL,
  `pickpocketloot` mediumint(8) unsigned DEFAULT NULL,
  `skinloot` mediumint(8) unsigned DEFAULT NULL,
  `resistance1` smallint(5) NOT NULL DEFAULT '0',
  `resistance2` smallint(5) NOT NULL DEFAULT '0',
  `resistance3` smallint(5) NOT NULL DEFAULT '0',
  `resistance4` smallint(5) NOT NULL DEFAULT '0',
  `resistance5` smallint(5) NOT NULL DEFAULT '0',
  `resistance6` smallint(5) NOT NULL DEFAULT '0',
  `spell1` int(10) unsigned DEFAULT NULL,
  `spell2` int(10) unsigned DEFAULT NULL,
  `spell3` int(10) unsigned DEFAULT NULL,
  `spell4` int(10) unsigned DEFAULT NULL,
  `spell5` int(10) unsigned DEFAULT NULL,
  `spell6` int(10) unsigned DEFAULT NULL,
  `spell7` int(10) unsigned DEFAULT NULL,
  `spell8` int(10) unsigned DEFAULT NULL,
  `PetSpellDataId` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `mingold` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `maxgold` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `AIName` char(64) NOT NULL DEFAULT '',
  `MovementType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `HealthModifier` float NOT NULL DEFAULT '1',
  `ManaModifier` float NOT NULL DEFAULT '1',
  `ArmorModifier` float NOT NULL DEFAULT '1',
  `DamageModifier` float NOT NULL DEFAULT '1',
  `ExperienceModifier` float NOT NULL DEFAULT '1',
  `RacialLeader` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `RegenHealth` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `mechanic_immune_mask` int(10) unsigned NOT NULL DEFAULT '0',
  `spell_school_immune_mask` int(3) unsigned NOT NULL DEFAULT '0',
  `flags_extra` int(10) unsigned NOT NULL DEFAULT '0',
  `ScriptName` char(64) NOT NULL DEFAULT '',
  `pool_id` mediumint(2) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entry`,`patch`),
  KEY `idx_name` (`name`),
  KEY `lootid` (`lootid`),
  KEY `pickpocketloot` (`pickpocketloot`),
  KEY `skinloot` (`skinloot`),
  KEY `gossip_menu_id` (`gossip_menu_id`),
  KEY `spell1` (`spell1`),
  KEY `spell2` (`spell2`),
  KEY `spell3` (`spell3`),
  KEY `spell4` (`spell4`),
  KEY `spell5` (`spell5`),
  KEY `spell6` (`spell6`),
  KEY `spell7` (`spell7`),
  KEY `spell8` (`spell8`),
  KEY `modelid1` (`modelid1`),
  KEY `modelid2` (`modelid2`),
  KEY `modelid3` (`modelid3`),
  KEY `modelid4` (`modelid4`),
  CONSTRAINT `creature_template_ibfk_1` FOREIGN KEY (`lootid`) REFERENCES `creature_loot_template` (`Entry`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_10` FOREIGN KEY (`spell6`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_11` FOREIGN KEY (`spell7`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_12` FOREIGN KEY (`spell8`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_13` FOREIGN KEY (`modelid1`) REFERENCES `creature_model_info` (`modelid`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_14` FOREIGN KEY (`modelid2`) REFERENCES `creature_model_info` (`modelid`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_15` FOREIGN KEY (`modelid3`) REFERENCES `creature_model_info` (`modelid`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_16` FOREIGN KEY (`modelid4`) REFERENCES `creature_model_info` (`modelid`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_2` FOREIGN KEY (`pickpocketloot`) REFERENCES `pickpocketing_loot_template` (`Entry`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_3` FOREIGN KEY (`skinloot`) REFERENCES `skinning_loot_template` (`Entry`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_4` FOREIGN KEY (`gossip_menu_id`) REFERENCES `gossip_menu` (`MenuID`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_5` FOREIGN KEY (`spell1`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_6` FOREIGN KEY (`spell2`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_7` FOREIGN KEY (`spell3`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_8` FOREIGN KEY (`spell4`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_ibfk_9` FOREIGN KEY (`spell5`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_template_addon`
--

DROP TABLE IF EXISTS `creature_template_addon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_template_addon` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `patch` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `path_id` int(10) unsigned DEFAULT NULL,
  `mount` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `bytes0` int(10) unsigned NOT NULL DEFAULT '0',
  `bytes1` int(10) unsigned NOT NULL DEFAULT '0',
  `bytes2` int(10) unsigned NOT NULL DEFAULT '0',
  `emote` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `moveflags` int(10) unsigned NOT NULL DEFAULT '0',
  `visibilityDistanceType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `auras` text CHARACTER SET latin1,
  PRIMARY KEY (`entry`,`patch`),
  KEY `path_id` (`path_id`),
  CONSTRAINT `creature_template_addon_ibfk_2` FOREIGN KEY (`entry`) REFERENCES `creature_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `creature_template_addon_ibfk_3` FOREIGN KEY (`path_id`) REFERENCES `waypoint_data` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_template_locale`
--

DROP TABLE IF EXISTS `creature_template_locale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_template_locale` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `locale` varchar(4) NOT NULL,
  `Name` text,
  `Title` text,
  `VerifiedBuild` smallint(5) DEFAULT '0',
  PRIMARY KEY (`entry`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_template_movement`
--

DROP TABLE IF EXISTS `creature_template_movement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_template_movement` (
  `CreatureId` mediumint(8) unsigned NOT NULL,
  `Ground` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Swim` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Flight` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Rooted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`CreatureId`),
  CONSTRAINT `creature_template_movement_ibfk_1` FOREIGN KEY (`CreatureId`) REFERENCES `creature_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_text`
--

DROP TABLE IF EXISTS `creature_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_text` (
  `CreatureID` mediumint(8) unsigned NOT NULL,
  `groupid` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `text` longtext CHARACTER SET latin1 NOT NULL,
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `language` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `probability` float NOT NULL DEFAULT '100',
  `emote` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `duration` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `sound` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `comment` varchar(255) CHARACTER SET latin1 DEFAULT '',
  `BroadcastTextId` mediumint(6) NOT NULL DEFAULT '0',
  `TextRange` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`CreatureID`,`groupid`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creature_text_locale`
--

DROP TABLE IF EXISTS `creature_text_locale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_text_locale` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `groupid` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `text_loc1` text,
  `text_loc2` text,
  `text_loc3` text,
  `text_loc4` text,
  `text_loc5` text,
  `text_loc6` text,
  `text_loc7` text,
  `text_loc8` text,
  PRIMARY KEY (`entry`,`groupid`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_script_string`
--

DROP TABLE IF EXISTS `db_script_string`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `db_script_string` (
  `entry` int(11) unsigned NOT NULL DEFAULT '0',
  `content_default` text CHARACTER SET latin1 NOT NULL,
  `content_loc1` text CHARACTER SET latin1,
  `content_loc2` text CHARACTER SET latin1,
  `content_loc3` text CHARACTER SET latin1,
  `content_loc4` text CHARACTER SET latin1,
  `content_loc5` text CHARACTER SET latin1,
  `content_loc6` text CHARACTER SET latin1,
  `content_loc7` text CHARACTER SET latin1,
  `content_loc8` text CHARACTER SET latin1,
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `disenchant_loot_template`
--

DROP TABLE IF EXISTS `disenchant_loot_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `disenchant_loot_template` (
  `Entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Reference` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Chance` float NOT NULL DEFAULT '100',
  `QuestRequired` tinyint(1) NOT NULL DEFAULT '0',
  `LootMode` smallint(5) unsigned NOT NULL DEFAULT '1',
  `GroupId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MinCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `MaxCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Comment` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`Entry`,`Item`),
  KEY `item` (`Item`),
  CONSTRAINT `disenchant_loot_template_ibfk_2` FOREIGN KEY (`Item`) REFERENCES `item_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_scripts`
--

DROP TABLE IF EXISTS `event_scripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_scripts` (
  `-id` int(20) NOT NULL AUTO_INCREMENT,
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `delay` int(10) unsigned NOT NULL DEFAULT '0',
  `command` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `datalong` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `datalong2` int(10) unsigned NOT NULL DEFAULT '0',
  `dataint` int(11) NOT NULL DEFAULT '0',
  `x` float NOT NULL DEFAULT '0',
  `y` float NOT NULL DEFAULT '0',
  `z` float NOT NULL DEFAULT '0',
  `o` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`-id`)
) ENGINE=InnoDB AUTO_INCREMENT=13510 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exploration_basexp`
--

DROP TABLE IF EXISTS `exploration_basexp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exploration_basexp` (
  `level` tinyint(4) NOT NULL DEFAULT '0',
  `basexp` mediumint(9) NOT NULL DEFAULT '0',
  PRIMARY KEY (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fishing_loot_template`
--

DROP TABLE IF EXISTS `fishing_loot_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fishing_loot_template` (
  `Entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Reference` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Chance` float NOT NULL DEFAULT '100',
  `QuestRequired` tinyint(1) NOT NULL DEFAULT '0',
  `LootMode` smallint(5) unsigned NOT NULL DEFAULT '1',
  `ChanceOrQuestChance` float NOT NULL DEFAULT '100',
  `GroupId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MinCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `mincountOrRef` mediumint(9) NOT NULL DEFAULT '1',
  `MaxCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `lootcondition` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `condition_value1` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `condition_value2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Comment` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`Entry`,`Item`),
  KEY `item` (`Item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event`
--

DROP TABLE IF EXISTS `game_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event` (
  `entry` int(11) unsigned NOT NULL COMMENT 'Entry of the game event',
  `start_time` timestamp NULL DEFAULT NULL COMMENT 'Absolute start date, the event will never start before',
  `end_time` timestamp NULL DEFAULT NULL COMMENT 'Absolute end date, the event will never start after',
  `occurence` bigint(20) unsigned NOT NULL DEFAULT '5184000' COMMENT 'Delay in minutes between occurences of the event',
  `length` bigint(20) unsigned NOT NULL DEFAULT '2592000' COMMENT 'Length in minutes of the event',
  `description` varchar(255) CHARACTER SET latin1 DEFAULT NULL COMMENT 'Description of the event displayed in console',
  `world_event` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '0 if normal event, 1 if world event',
  `disabled` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event_battleground_holiday`
--

DROP TABLE IF EXISTS `game_event_battleground_holiday`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event_battleground_holiday` (
  `event` int(10) unsigned NOT NULL,
  `bgflag` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`event`),
  CONSTRAINT `game_event_battleground_holiday_ibfk_2` FOREIGN KEY (`event`) REFERENCES `game_event` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event_condition`
--

DROP TABLE IF EXISTS `game_event_condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event_condition` (
  `event_id` int(11) unsigned NOT NULL DEFAULT '0',
  `condition_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `req_num` float DEFAULT '0',
  `max_world_state_field` smallint(5) unsigned NOT NULL DEFAULT '0',
  `done_world_state_field` smallint(5) unsigned NOT NULL DEFAULT '0',
  `description` varchar(25) CHARACTER SET latin1 NOT NULL DEFAULT '',
  PRIMARY KEY (`event_id`,`condition_id`),
  CONSTRAINT `game_event_condition_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `game_event` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event_creature`
--

DROP TABLE IF EXISTS `game_event_creature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event_creature` (
  `guid` int(10) unsigned NOT NULL,
  `event` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`event`),
  CONSTRAINT `game_event_creature_ibfk_1` FOREIGN KEY (`guid`) REFERENCES `creature` (`spawnID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event_creature_quest`
--

DROP TABLE IF EXISTS `game_event_creature_quest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event_creature_quest` (
  `id` mediumint(8) unsigned NOT NULL,
  `quest` mediumint(8) unsigned NOT NULL,
  `event` int(11) unsigned NOT NULL,
  PRIMARY KEY (`quest`,`event`,`id`),
  KEY `id` (`id`),
  KEY `event` (`event`),
  CONSTRAINT `game_event_creature_quest_ibfk_1` FOREIGN KEY (`id`) REFERENCES `creature_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `game_event_creature_quest_ibfk_2` FOREIGN KEY (`quest`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `game_event_creature_quest_ibfk_3` FOREIGN KEY (`event`) REFERENCES `game_event` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event_fireworks`
--

DROP TABLE IF EXISTS `game_event_fireworks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event_fireworks` (
  `groupid` smallint(5) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  `spellorgob` int(11) unsigned NOT NULL DEFAULT '0',
  `size` float unsigned NOT NULL DEFAULT '1',
  `posX` smallint(6) NOT NULL DEFAULT '0',
  `posY` smallint(6) NOT NULL DEFAULT '0',
  `ori` float unsigned NOT NULL DEFAULT '0',
  `morphX` float unsigned NOT NULL DEFAULT '0',
  `morphY` float unsigned NOT NULL DEFAULT '0',
  `osef` int(10) NOT NULL,
  PRIMARY KEY (`groupid`,`time`,`spellorgob`,`posX`,`posY`,`osef`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event_gameobject`
--

DROP TABLE IF EXISTS `game_event_gameobject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event_gameobject` (
  `guid` int(10) unsigned NOT NULL,
  `event` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Put negatives values to remove during event',
  PRIMARY KEY (`guid`,`event`),
  CONSTRAINT `game_event_gameobject_ibfk_1` FOREIGN KEY (`guid`) REFERENCES `gameobject` (`guid`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event_gameobject_quest`
--

DROP TABLE IF EXISTS `game_event_gameobject_quest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event_gameobject_quest` (
  `id` mediumint(8) unsigned NOT NULL,
  `quest` mediumint(8) unsigned NOT NULL,
  `event` int(11) unsigned NOT NULL,
  KEY `id` (`id`),
  KEY `quest` (`quest`),
  KEY `event` (`event`),
  CONSTRAINT `game_event_gameobject_quest_ibfk_1` FOREIGN KEY (`id`) REFERENCES `gameobject_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `game_event_gameobject_quest_ibfk_2` FOREIGN KEY (`quest`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `game_event_gameobject_quest_ibfk_3` FOREIGN KEY (`event`) REFERENCES `game_event` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event_model_equip`
--

DROP TABLE IF EXISTS `game_event_model_equip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event_model_equip` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `modelid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `equipment_id` tinyint(1) NOT NULL DEFAULT '0',
  `event` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`),
  KEY `event` (`event`),
  CONSTRAINT `game_event_model_equip_ibfk_1` FOREIGN KEY (`guid`) REFERENCES `creature` (`spawnID`) ON UPDATE CASCADE,
  CONSTRAINT `game_event_model_equip_ibfk_2` FOREIGN KEY (`event`) REFERENCES `game_event` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event_npc_vendor`
--

DROP TABLE IF EXISTS `game_event_npc_vendor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event_npc_vendor` (
  `event` int(11) unsigned NOT NULL,
  `guid` int(10) unsigned NOT NULL,
  `item` mediumint(8) unsigned NOT NULL,
  `maxcount` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `incrtime` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ExtendedCost` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`guid`,`item`,`ExtendedCost`,`event`),
  KEY `event` (`event`),
  KEY `item` (`item`),
  CONSTRAINT `game_event_npc_vendor_ibfk_1` FOREIGN KEY (`event`) REFERENCES `game_event` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `game_event_npc_vendor_ibfk_2` FOREIGN KEY (`guid`) REFERENCES `creature` (`spawnID`) ON UPDATE CASCADE,
  CONSTRAINT `game_event_npc_vendor_ibfk_3` FOREIGN KEY (`item`) REFERENCES `item_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event_npcflag`
--

DROP TABLE IF EXISTS `game_event_npcflag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event_npcflag` (
  `guid` int(10) unsigned NOT NULL,
  `event_id` int(11) unsigned NOT NULL,
  `npcflag` int(10) unsigned NOT NULL,
  PRIMARY KEY (`guid`,`event_id`),
  KEY `event_id` (`event_id`),
  CONSTRAINT `game_event_npcflag_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `game_event` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `game_event_npcflag_ibfk_2` FOREIGN KEY (`guid`) REFERENCES `creature` (`spawnID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event_pool`
--

DROP TABLE IF EXISTS `game_event_pool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event_pool` (
  `eventEntry` tinyint(4) NOT NULL COMMENT 'Entry of the game event. Put negative entry to remove during event.',
  `pool_entry` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Id of the pool',
  PRIMARY KEY (`pool_entry`),
  KEY `eventEntry` (`eventEntry`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event_prerequisite`
--

DROP TABLE IF EXISTS `game_event_prerequisite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event_prerequisite` (
  `event_id` int(11) unsigned NOT NULL,
  `prerequisite_event` int(11) unsigned NOT NULL,
  PRIMARY KEY (`event_id`,`prerequisite_event`),
  KEY `prerequisite_event` (`prerequisite_event`),
  CONSTRAINT `game_event_prerequisite_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `game_event` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `game_event_prerequisite_ibfk_2` FOREIGN KEY (`prerequisite_event`) REFERENCES `game_event` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event_quest_condition`
--

DROP TABLE IF EXISTS `game_event_quest_condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event_quest_condition` (
  `quest` mediumint(8) unsigned NOT NULL,
  `event_id` int(11) unsigned NOT NULL,
  `condition_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `num` float DEFAULT '0',
  PRIMARY KEY (`quest`),
  KEY `event_id` (`event_id`),
  CONSTRAINT `game_event_quest_condition_ibfk_1` FOREIGN KEY (`quest`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `game_event_quest_condition_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `game_event` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_event_seasonal_questrelation`
--

DROP TABLE IF EXISTS `game_event_seasonal_questrelation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event_seasonal_questrelation` (
  `questId` mediumint(8) unsigned NOT NULL COMMENT 'Quest Identifier',
  `eventEntry` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Entry of the game event',
  PRIMARY KEY (`questId`,`eventEntry`),
  KEY `idx_quest` (`questId`),
  KEY `event_fk` (`eventEntry`),
  CONSTRAINT `event_fk` FOREIGN KEY (`eventEntry`) REFERENCES `game_event` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `quest_fk` FOREIGN KEY (`questId`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_graveyard_zone`
--

DROP TABLE IF EXISTS `game_graveyard_zone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_graveyard_zone` (
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ghost_zone` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `faction` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`,`ghost_zone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_tele`
--

DROP TABLE IF EXISTS `game_tele`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_tele` (
  `id` mediumint(8) unsigned NOT NULL,
  `position_x` float NOT NULL DEFAULT '0',
  `position_y` float NOT NULL DEFAULT '0',
  `position_z` float NOT NULL DEFAULT '0',
  `orientation` float NOT NULL DEFAULT '0',
  `map` smallint(5) unsigned NOT NULL DEFAULT '0',
  `name` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_weather`
--

DROP TABLE IF EXISTS `game_weather`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_weather` (
  `zone` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `spring_rain_chance` tinyint(3) unsigned NOT NULL DEFAULT '25',
  `spring_snow_chance` tinyint(3) unsigned NOT NULL DEFAULT '25',
  `spring_storm_chance` tinyint(3) unsigned NOT NULL DEFAULT '25',
  `summer_rain_chance` tinyint(3) unsigned NOT NULL DEFAULT '25',
  `summer_snow_chance` tinyint(3) unsigned NOT NULL DEFAULT '25',
  `summer_storm_chance` tinyint(3) unsigned NOT NULL DEFAULT '25',
  `fall_rain_chance` tinyint(3) unsigned NOT NULL DEFAULT '25',
  `fall_snow_chance` tinyint(3) unsigned NOT NULL DEFAULT '25',
  `fall_storm_chance` tinyint(3) unsigned NOT NULL DEFAULT '25',
  `winter_rain_chance` tinyint(3) unsigned NOT NULL DEFAULT '25',
  `winter_snow_chance` tinyint(3) unsigned NOT NULL DEFAULT '25',
  `winter_storm_chance` tinyint(3) unsigned NOT NULL DEFAULT '25',
  PRIMARY KEY (`zone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gameobject`
--

DROP TABLE IF EXISTS `gameobject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gameobject` (
  `guid` int(10) unsigned NOT NULL COMMENT 'Global Unique Identifier',
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Gameobject Identifier',
  `map` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Map Identifier',
  `spawnMask` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `position_x` float NOT NULL DEFAULT '0',
  `position_y` float NOT NULL DEFAULT '0',
  `position_z` float NOT NULL DEFAULT '0',
  `orientation` float NOT NULL DEFAULT '0',
  `rotation0` float NOT NULL DEFAULT '0',
  `rotation1` float NOT NULL DEFAULT '0',
  `rotation2` float NOT NULL DEFAULT '0',
  `rotation3` float NOT NULL DEFAULT '0',
  `spawntimesecs` int(11) NOT NULL DEFAULT '0',
  `animprogress` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `state` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `ScriptName` char(64) CHARACTER SET latin1 DEFAULT '',
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`guid`),
  KEY `gameobject_ibfk_1` (`id`),
  CONSTRAINT `gameobject_ibfk_2` FOREIGN KEY (`id`) REFERENCES `gameobject_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gameobject_battleground`
--

DROP TABLE IF EXISTS `gameobject_battleground`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gameobject_battleground` (
  `spawnID` int(10) unsigned NOT NULL COMMENT 'GameObject''s spawnID',
  `event1` tinyint(3) unsigned NOT NULL COMMENT 'main event',
  `event2` tinyint(3) unsigned NOT NULL COMMENT 'sub event',
  PRIMARY KEY (`spawnID`,`event1`,`event2`),
  CONSTRAINT `gameobject_battleground_ibfk_1` FOREIGN KEY (`spawnID`) REFERENCES `gameobject` (`guid`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='GameObject battleground indexing system';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gameobject_loot_template`
--

DROP TABLE IF EXISTS `gameobject_loot_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gameobject_loot_template` (
  `Entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Reference` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Chance` float NOT NULL DEFAULT '100',
  `QuestRequired` tinyint(1) NOT NULL DEFAULT '0',
  `LootMode` smallint(5) unsigned NOT NULL DEFAULT '1',
  `GroupId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MinCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `MaxCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Comment` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`Entry`,`Item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gameobject_questender`
--

DROP TABLE IF EXISTS `gameobject_questender`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gameobject_questender` (
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `quest` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Quest Identifier',
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`id`,`quest`),
  KEY `quest` (`quest`),
  CONSTRAINT `gameobject_questender_ibfk_1` FOREIGN KEY (`id`) REFERENCES `gameobject_template` (`entry`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `gameobject_questender_ibfk_2` FOREIGN KEY (`quest`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gameobject_queststarter`
--

DROP TABLE IF EXISTS `gameobject_queststarter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gameobject_queststarter` (
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `quest` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Quest Identifier',
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`id`,`quest`),
  KEY `quest` (`quest`),
  CONSTRAINT `gameobject_queststarter_ibfk_1` FOREIGN KEY (`id`) REFERENCES `gameobject_template` (`entry`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `gameobject_queststarter_ibfk_2` FOREIGN KEY (`quest`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gameobject_scripts`
--

DROP TABLE IF EXISTS `gameobject_scripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gameobject_scripts` (
  `id` int(10) unsigned NOT NULL,
  `delay` int(10) unsigned NOT NULL DEFAULT '0',
  `command` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `datalong` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `datalong2` int(10) unsigned NOT NULL DEFAULT '0',
  `dataint` int(11) NOT NULL DEFAULT '0',
  `x` float NOT NULL DEFAULT '0',
  `y` float NOT NULL DEFAULT '0',
  `z` float NOT NULL DEFAULT '0',
  `o` float NOT NULL DEFAULT '0',
  KEY `id` (`id`),
  CONSTRAINT `gameobject_scripts_ibfk_1` FOREIGN KEY (`id`) REFERENCES `gameobject` (`guid`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gameobject_template`
--

DROP TABLE IF EXISTS `gameobject_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gameobject_template` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `patch` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `displayId` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `name` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `castBarCaption` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `faction` smallint(5) unsigned NOT NULL DEFAULT '0',
  `flags` int(10) unsigned NOT NULL DEFAULT '0',
  `size` float NOT NULL DEFAULT '1',
  `data0` int(10) unsigned NOT NULL DEFAULT '0',
  `data1` int(10) NOT NULL DEFAULT '0',
  `data2` int(10) unsigned NOT NULL DEFAULT '0',
  `data3` int(10) unsigned NOT NULL DEFAULT '0',
  `data4` int(10) unsigned NOT NULL DEFAULT '0',
  `data5` int(10) unsigned NOT NULL DEFAULT '0',
  `data6` int(10) NOT NULL DEFAULT '0',
  `data7` int(10) unsigned NOT NULL DEFAULT '0',
  `data8` int(10) unsigned NOT NULL DEFAULT '0',
  `data9` int(10) unsigned NOT NULL DEFAULT '0',
  `data10` int(10) unsigned NOT NULL DEFAULT '0',
  `data11` int(10) unsigned NOT NULL DEFAULT '0',
  `data12` int(10) unsigned NOT NULL DEFAULT '0',
  `data13` int(10) unsigned NOT NULL DEFAULT '0',
  `data14` int(10) unsigned NOT NULL DEFAULT '0',
  `data15` int(10) unsigned NOT NULL DEFAULT '0',
  `data16` int(10) unsigned NOT NULL DEFAULT '0',
  `data17` int(10) unsigned NOT NULL DEFAULT '0',
  `data18` int(10) unsigned NOT NULL DEFAULT '0',
  `data19` int(10) unsigned NOT NULL DEFAULT '0',
  `data20` int(10) unsigned NOT NULL DEFAULT '0',
  `data21` int(10) unsigned NOT NULL DEFAULT '0',
  `data22` int(10) unsigned NOT NULL DEFAULT '0',
  `data23` int(10) unsigned NOT NULL DEFAULT '0',
  `AIName` char(64) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `ScriptName` varchar(64) CHARACTER SET latin1 NOT NULL DEFAULT '',
  PRIMARY KEY (`entry`,`patch`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gameobject_template_locale`
--

DROP TABLE IF EXISTS `gameobject_template_locale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gameobject_template_locale` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `locale` varchar(4) NOT NULL,
  `name` text,
  `castBarCaption` text,
  `VerifiedBuild` smallint(5) DEFAULT '0',
  PRIMARY KEY (`entry`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gmgroups`
--

DROP TABLE IF EXISTS `gmgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gmgroups` (
  `id` int(11) NOT NULL,
  `name` text CHARACTER SET latin1 NOT NULL,
  `policy` int(11) NOT NULL,
  `commands` text CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gossip_menu`
--

DROP TABLE IF EXISTS `gossip_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gossip_menu` (
  `MenuID` smallint(5) unsigned NOT NULL DEFAULT '0',
  `TextID` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  UNIQUE KEY `entry_text_id` (`MenuID`,`TextID`),
  KEY `text_id` (`TextID`),
  CONSTRAINT `gossip_menu_ibfk_1` FOREIGN KEY (`TextID`) REFERENCES `gossip_text` (`ID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gossip_menu_option`
--

DROP TABLE IF EXISTS `gossip_menu_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gossip_menu_option` (
  `MenuID` smallint(5) unsigned NOT NULL DEFAULT '0',
  `OptionID` smallint(5) unsigned NOT NULL DEFAULT '0',
  `OptionIcon` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `OptionText` text,
  `OptionBroadcastTextID` int(11) unsigned DEFAULT NULL,
  `OptionType` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT 'action type (such as gossip, trainer, ...)',
  `OptionNpcFlag` int(10) unsigned NOT NULL DEFAULT '1',
  `ActionMenuID` smallint(5) unsigned DEFAULT NULL,
  `ActionPoiID` mediumint(8) unsigned DEFAULT NULL,
  `BoxCoded` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `BoxMoney` int(10) unsigned NOT NULL DEFAULT '0',
  `BoxText` text,
  `BoxBroadcastTextID` int(11) unsigned DEFAULT NULL,
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`MenuID`,`OptionID`),
  KEY `menu_id` (`MenuID`),
  KEY `action_menu_id` (`ActionMenuID`),
  KEY `pk_broadcast1` (`OptionBroadcastTextID`),
  KEY `pk_broadcast2` (`BoxBroadcastTextID`),
  KEY `pk_poi` (`ActionPoiID`),
  CONSTRAINT `pk_action_menuId` FOREIGN KEY (`ActionMenuID`) REFERENCES `gossip_menu` (`MenuID`) ON UPDATE CASCADE,
  CONSTRAINT `pk_broadcast1` FOREIGN KEY (`OptionBroadcastTextID`) REFERENCES `broadcast_text` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `pk_broadcast2` FOREIGN KEY (`BoxBroadcastTextID`) REFERENCES `broadcast_text` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `pk_menuId` FOREIGN KEY (`MenuID`) REFERENCES `gossip_menu` (`MenuID`) ON UPDATE CASCADE,
  CONSTRAINT `pk_poi` FOREIGN KEY (`ActionPoiID`) REFERENCES `points_of_interest` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gossip_menu_option_generic`
--

DROP TABLE IF EXISTS `gossip_menu_option_generic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gossip_menu_option_generic` (
  `MenuID` smallint(5) unsigned NOT NULL DEFAULT '0',
  `OptionIcon` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `OptionText` text,
  `OptionType` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `OptionNpcFlag` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`MenuID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gossip_text`
--

DROP TABLE IF EXISTS `gossip_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gossip_text` (
  `ID` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `comment` varchar(500) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `text0_0` longtext CHARACTER SET latin1,
  `text0_1` longtext CHARACTER SET latin1,
  `BroadcastTextID0` int(11) unsigned DEFAULT NULL,
  `lang0` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Probability0` float NOT NULL DEFAULT '0',
  `em0_0` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em0_1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em0_2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em0_3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em0_4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em0_5` smallint(5) unsigned NOT NULL DEFAULT '0',
  `text1_0` longtext CHARACTER SET latin1,
  `text1_1` longtext CHARACTER SET latin1,
  `BroadcastTextID1` int(11) unsigned DEFAULT NULL,
  `lang1` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Probability1` float NOT NULL DEFAULT '0',
  `em1_0` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em1_1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em1_2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em1_3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em1_4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em1_5` smallint(5) unsigned NOT NULL DEFAULT '0',
  `text2_0` longtext CHARACTER SET latin1,
  `text2_1` longtext CHARACTER SET latin1,
  `BroadcastTextID2` int(11) unsigned DEFAULT NULL,
  `lang2` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Probability2` float NOT NULL DEFAULT '0',
  `em2_0` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em2_1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em2_2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em2_3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em2_4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em2_5` smallint(5) unsigned NOT NULL DEFAULT '0',
  `text3_0` longtext CHARACTER SET latin1,
  `text3_1` longtext CHARACTER SET latin1,
  `BroadcastTextID3` int(11) unsigned DEFAULT NULL,
  `lang3` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Probability3` float NOT NULL DEFAULT '0',
  `em3_0` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em3_1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em3_2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em3_3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em3_4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em3_5` smallint(5) unsigned NOT NULL DEFAULT '0',
  `text4_0` longtext CHARACTER SET latin1,
  `text4_1` longtext CHARACTER SET latin1,
  `BroadcastTextID4` int(11) unsigned DEFAULT NULL,
  `lang4` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Probability4` float NOT NULL DEFAULT '0',
  `em4_0` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em4_1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em4_2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em4_3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em4_4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em4_5` smallint(5) unsigned NOT NULL DEFAULT '0',
  `text5_0` longtext CHARACTER SET latin1,
  `text5_1` longtext CHARACTER SET latin1,
  `BroadcastTextID5` int(11) unsigned DEFAULT NULL,
  `lang5` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Probability5` float NOT NULL DEFAULT '0',
  `em5_0` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em5_1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em5_2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em5_3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em5_4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em5_5` smallint(5) unsigned NOT NULL DEFAULT '0',
  `text6_0` longtext CHARACTER SET latin1,
  `text6_1` longtext CHARACTER SET latin1,
  `BroadcastTextID6` int(11) unsigned DEFAULT NULL,
  `lang6` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Probability6` float NOT NULL DEFAULT '0',
  `em6_0` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em6_1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em6_2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em6_3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em6_4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em6_5` smallint(5) unsigned NOT NULL DEFAULT '0',
  `text7_0` longtext CHARACTER SET latin1,
  `text7_1` longtext CHARACTER SET latin1,
  `BroadcastTextID7` int(11) unsigned DEFAULT NULL,
  `lang7` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Probability7` float NOT NULL DEFAULT '0',
  `em7_0` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em7_1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em7_2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em7_3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em7_4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `em7_5` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `broadcast0` (`BroadcastTextID0`),
  KEY `broadcast1` (`BroadcastTextID1`),
  KEY `broadcast2` (`BroadcastTextID2`),
  KEY `broadcast3` (`BroadcastTextID3`),
  KEY `broadcast4` (`BroadcastTextID4`),
  KEY `broadcast5` (`BroadcastTextID5`),
  KEY `broadcast6` (`BroadcastTextID6`),
  KEY `broadcast7` (`BroadcastTextID7`),
  CONSTRAINT `broadcast0` FOREIGN KEY (`BroadcastTextID0`) REFERENCES `broadcast_text` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `broadcast1` FOREIGN KEY (`BroadcastTextID1`) REFERENCES `broadcast_text` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `broadcast2` FOREIGN KEY (`BroadcastTextID2`) REFERENCES `broadcast_text` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `broadcast3` FOREIGN KEY (`BroadcastTextID3`) REFERENCES `broadcast_text` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `broadcast4` FOREIGN KEY (`BroadcastTextID4`) REFERENCES `broadcast_text` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `broadcast5` FOREIGN KEY (`BroadcastTextID5`) REFERENCES `broadcast_text` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `broadcast6` FOREIGN KEY (`BroadcastTextID6`) REFERENCES `broadcast_text` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `broadcast7` FOREIGN KEY (`BroadcastTextID7`) REFERENCES `broadcast_text` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance_encounter`
--

DROP TABLE IF EXISTS `instance_encounter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instance_encounter` (
  `mapid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `eventid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `comment` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  PRIMARY KEY (`mapid`,`eventid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance_spawn_groups`
--

DROP TABLE IF EXISTS `instance_spawn_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instance_spawn_groups` (
  `instanceMapId` smallint(5) unsigned NOT NULL,
  `bossStateId` tinyint(3) unsigned NOT NULL,
  `bossStates` tinyint(3) unsigned NOT NULL,
  `spawnGroupId` int(10) unsigned NOT NULL,
  `flags` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`instanceMapId`,`bossStateId`,`spawnGroupId`,`bossStates`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance_template`
--

DROP TABLE IF EXISTS `instance_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instance_template` (
  `map` smallint(5) unsigned NOT NULL,
  `patch` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `parent` int(10) unsigned NOT NULL,
  `maxPlayers` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `reset_delay` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'in days',
  `access_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `startLocX` float DEFAULT NULL,
  `startLocY` float DEFAULT NULL,
  `startLocZ` float DEFAULT NULL,
  `startLocO` float DEFAULT NULL,
  `script` varchar(128) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `forceHeroicEnabled` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`map`,`patch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_enchantment_template`
--

DROP TABLE IF EXISTS `item_enchantment_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item_enchantment_template` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ench` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `chance` float unsigned NOT NULL DEFAULT '0',
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`entry`,`ench`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_extended_cost`
--

DROP TABLE IF EXISTS `item_extended_cost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item_extended_cost` (
  `id` int(10) unsigned NOT NULL,
  `reqhonorpoints` int(10) unsigned NOT NULL,
  `reqarenapoints` int(10) unsigned NOT NULL,
  `reqitem0` int(10) unsigned NOT NULL,
  `reqitem1` int(10) unsigned NOT NULL,
  `reqitem2` int(10) unsigned NOT NULL,
  `reqitem3` int(10) unsigned NOT NULL,
  `reqitem4` int(10) unsigned NOT NULL,
  `reqitemcount0` int(10) unsigned NOT NULL,
  `reqitemcount1` int(10) unsigned NOT NULL,
  `reqitemcount2` int(10) unsigned NOT NULL,
  `reqitemcount3` int(10) unsigned NOT NULL,
  `reqitemcount4` int(10) unsigned NOT NULL,
  `reqpersonalarenarating` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_loot_template`
--

DROP TABLE IF EXISTS `item_loot_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item_loot_template` (
  `Entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Reference` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Chance` float NOT NULL DEFAULT '100',
  `QuestRequired` tinyint(1) NOT NULL DEFAULT '0',
  `LootMode` smallint(5) unsigned NOT NULL DEFAULT '1',
  `GroupId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MinCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `MaxCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Comment` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`Entry`,`Item`),
  KEY `item` (`Item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_template`
--

DROP TABLE IF EXISTS `item_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item_template` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `patch` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `class` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `subclass` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `SoundOverrideSubclass` int(11) NOT NULL DEFAULT '-1',
  `name` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `displayid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Quality` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Flags` int(10) unsigned NOT NULL DEFAULT '0',
  `BuyCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `BuyPrice` int(10) unsigned NOT NULL DEFAULT '0',
  `SellPrice` int(10) unsigned NOT NULL DEFAULT '0',
  `InventoryType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `AllowableClass` mediumint(9) NOT NULL DEFAULT '-1',
  `AllowableRace` mediumint(9) NOT NULL DEFAULT '-1',
  `ItemLevel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `RequiredLevel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `RequiredSkill` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RequiredSkillRank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `requiredspell` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `requiredhonorrank` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `RequiredCityRank` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `RequiredReputationFaction` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RequiredReputationRank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `maxcount` smallint(5) unsigned NOT NULL DEFAULT '0',
  `stackable` smallint(5) unsigned NOT NULL DEFAULT '1',
  `ContainerSlots` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `stat_type1` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `stat_value1` smallint(6) NOT NULL DEFAULT '0',
  `stat_type2` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `stat_value2` smallint(6) NOT NULL DEFAULT '0',
  `stat_type3` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `stat_value3` smallint(6) NOT NULL DEFAULT '0',
  `stat_type4` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `stat_value4` smallint(6) NOT NULL DEFAULT '0',
  `stat_type5` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `stat_value5` smallint(6) NOT NULL DEFAULT '0',
  `stat_type6` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `stat_value6` smallint(6) NOT NULL DEFAULT '0',
  `stat_type7` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `stat_value7` smallint(6) NOT NULL DEFAULT '0',
  `stat_type8` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `stat_value8` smallint(6) NOT NULL DEFAULT '0',
  `stat_type9` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `stat_value9` smallint(6) NOT NULL DEFAULT '0',
  `stat_type10` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `stat_value10` smallint(6) NOT NULL DEFAULT '0',
  `dmg_min1` float NOT NULL DEFAULT '0',
  `dmg_max1` float NOT NULL DEFAULT '0',
  `dmg_type1` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dmg_min2` float NOT NULL DEFAULT '0',
  `dmg_max2` float NOT NULL DEFAULT '0',
  `dmg_type2` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dmg_min3` float NOT NULL DEFAULT '0',
  `dmg_max3` float NOT NULL DEFAULT '0',
  `dmg_type3` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dmg_min4` float NOT NULL DEFAULT '0',
  `dmg_max4` float NOT NULL DEFAULT '0',
  `dmg_type4` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dmg_min5` float NOT NULL DEFAULT '0',
  `dmg_max5` float NOT NULL DEFAULT '0',
  `dmg_type5` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `armor` smallint(5) unsigned NOT NULL DEFAULT '0',
  `holy_res` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `fire_res` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `nature_res` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `frost_res` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `shadow_res` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `arcane_res` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `delay` smallint(5) unsigned NOT NULL DEFAULT '1000',
  `ammo_type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `RangedModRange` float NOT NULL DEFAULT '0',
  `spellid_1` int(10) unsigned DEFAULT NULL,
  `spelltrigger_1` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `spellcharges_1` tinyint(4) NOT NULL DEFAULT '0',
  `spellppmRate_1` float NOT NULL DEFAULT '0',
  `spellcooldown_1` int(11) NOT NULL DEFAULT '-1',
  `spellcategory_1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `spellcategorycooldown_1` int(11) NOT NULL DEFAULT '-1',
  `spellid_2` int(10) unsigned DEFAULT NULL,
  `spelltrigger_2` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `spellcharges_2` tinyint(4) NOT NULL DEFAULT '0',
  `spellppmRate_2` float NOT NULL DEFAULT '0',
  `spellcooldown_2` int(11) NOT NULL DEFAULT '-1',
  `spellcategory_2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `spellcategorycooldown_2` int(11) NOT NULL DEFAULT '-1',
  `spellid_3` int(10) unsigned DEFAULT NULL,
  `spelltrigger_3` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `spellcharges_3` tinyint(4) NOT NULL DEFAULT '0',
  `spellppmRate_3` float NOT NULL DEFAULT '0',
  `spellcooldown_3` int(11) NOT NULL DEFAULT '-1',
  `spellcategory_3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `spellcategorycooldown_3` int(11) NOT NULL DEFAULT '-1',
  `spellid_4` int(10) unsigned DEFAULT NULL,
  `spelltrigger_4` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `spellcharges_4` tinyint(4) NOT NULL DEFAULT '0',
  `spellppmRate_4` float NOT NULL DEFAULT '0',
  `spellcooldown_4` int(11) NOT NULL DEFAULT '-1',
  `spellcategory_4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `spellcategorycooldown_4` int(11) NOT NULL DEFAULT '-1',
  `spellid_5` int(10) unsigned DEFAULT NULL,
  `spelltrigger_5` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `spellcharges_5` tinyint(4) NOT NULL DEFAULT '0',
  `spellppmRate_5` float NOT NULL DEFAULT '0',
  `spellcooldown_5` int(11) NOT NULL DEFAULT '-1',
  `spellcategory_5` smallint(5) unsigned NOT NULL DEFAULT '0',
  `spellcategorycooldown_5` int(11) NOT NULL DEFAULT '-1',
  `bonding` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `description` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `PageText` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `LanguageID` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `PageMaterial` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `startquest` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `lockid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Material` tinyint(4) NOT NULL DEFAULT '0',
  `sheath` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `RandomProperty` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `RandomSuffix` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `block` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `itemset` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `MaxDurability` smallint(5) unsigned NOT NULL DEFAULT '0',
  `zone` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Map` smallint(6) NOT NULL DEFAULT '0',
  `BagFamily` mediumint(9) NOT NULL DEFAULT '0',
  `TotemCategory` tinyint(4) NOT NULL DEFAULT '0',
  `socketColor_1` tinyint(4) NOT NULL DEFAULT '0',
  `socketContent_1` mediumint(9) NOT NULL DEFAULT '0',
  `socketColor_2` tinyint(4) NOT NULL DEFAULT '0',
  `socketContent_2` mediumint(9) NOT NULL DEFAULT '0',
  `socketColor_3` tinyint(4) NOT NULL DEFAULT '0',
  `socketContent_3` mediumint(9) NOT NULL DEFAULT '0',
  `socketBonus` mediumint(9) NOT NULL DEFAULT '0',
  `GemProperties` mediumint(9) NOT NULL DEFAULT '0',
  `RequiredDisenchantSkill` smallint(6) NOT NULL DEFAULT '-1',
  `ArmorDamageModifier` float NOT NULL DEFAULT '0',
  `ScriptName` varchar(64) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `DisenchantID` mediumint(8) unsigned DEFAULT NULL,
  `FoodType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `minMoneyLoot` int(10) unsigned NOT NULL DEFAULT '0',
  `maxMoneyLoot` int(10) unsigned NOT NULL DEFAULT '0',
  `Duration` int(11) NOT NULL DEFAULT '0' COMMENT 'Duration in seconds. Negative value means realtime, postive value ingame time',
  PRIMARY KEY (`entry`,`patch`),
  KEY `idx_name` (`name`),
  KEY `items_index` (`class`),
  KEY `spellid_1` (`spellid_1`),
  KEY `spellid_2` (`spellid_2`),
  KEY `spellid_3` (`spellid_3`),
  KEY `spellid_4` (`spellid_4`),
  KEY `spellid_5` (`spellid_5`),
  KEY `DisenchantID` (`DisenchantID`),
  CONSTRAINT `item_template_ibfk_1` FOREIGN KEY (`spellid_1`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `item_template_ibfk_2` FOREIGN KEY (`spellid_2`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `item_template_ibfk_3` FOREIGN KEY (`spellid_3`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `item_template_ibfk_4` FOREIGN KEY (`spellid_4`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `item_template_ibfk_5` FOREIGN KEY (`spellid_5`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `item_template_ibfk_6` FOREIGN KEY (`DisenchantID`) REFERENCES `disenchant_loot_template` (`Entry`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_template_locale`
--

DROP TABLE IF EXISTS `item_template_locale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item_template_locale` (
  `ID` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `locale` varchar(4) NOT NULL,
  `Name` text,
  `Description` text,
  `VerifiedBuild` smallint(5) DEFAULT '0',
  PRIMARY KEY (`ID`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `locales_gossip_menu_option`
--

DROP TABLE IF EXISTS `locales_gossip_menu_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locales_gossip_menu_option` (
  `menu_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `option_text_loc1` text COLLATE utf8_unicode_ci,
  `option_text_loc2` text COLLATE utf8_unicode_ci,
  `option_text_loc3` text COLLATE utf8_unicode_ci,
  `option_text_loc4` text COLLATE utf8_unicode_ci,
  `option_text_loc5` text COLLATE utf8_unicode_ci,
  `option_text_loc6` text COLLATE utf8_unicode_ci,
  `option_text_loc7` text COLLATE utf8_unicode_ci,
  `option_text_loc8` text COLLATE utf8_unicode_ci,
  `box_text_loc1` text COLLATE utf8_unicode_ci,
  `box_text_loc2` text COLLATE utf8_unicode_ci,
  `box_text_loc3` text COLLATE utf8_unicode_ci,
  `box_text_loc4` text COLLATE utf8_unicode_ci,
  `box_text_loc5` text COLLATE utf8_unicode_ci,
  `box_text_loc6` text COLLATE utf8_unicode_ci,
  `box_text_loc7` text COLLATE utf8_unicode_ci,
  `box_text_loc8` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`menu_id`,`id`),
  CONSTRAINT `locales_gossip_menu_option_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `gossip_menu_option` (`MenuID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `locales_gossip_text`
--

DROP TABLE IF EXISTS `locales_gossip_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locales_gossip_text` (
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Text0_0_loc1` longtext COLLATE utf8_unicode_ci,
  `Text0_0_loc2` longtext COLLATE utf8_unicode_ci,
  `Text0_0_loc3` longtext COLLATE utf8_unicode_ci,
  `Text0_0_loc4` longtext COLLATE utf8_unicode_ci,
  `Text0_0_loc5` longtext COLLATE utf8_unicode_ci,
  `Text0_0_loc6` longtext COLLATE utf8_unicode_ci,
  `Text0_0_loc7` longtext COLLATE utf8_unicode_ci,
  `Text0_0_loc8` longtext COLLATE utf8_unicode_ci,
  `Text0_1_loc1` longtext COLLATE utf8_unicode_ci,
  `Text0_1_loc2` longtext COLLATE utf8_unicode_ci,
  `Text0_1_loc3` longtext COLLATE utf8_unicode_ci,
  `Text0_1_loc4` longtext COLLATE utf8_unicode_ci,
  `Text0_1_loc5` longtext COLLATE utf8_unicode_ci,
  `Text0_1_loc6` longtext COLLATE utf8_unicode_ci,
  `Text0_1_loc7` longtext COLLATE utf8_unicode_ci,
  `Text0_1_loc8` longtext COLLATE utf8_unicode_ci,
  `Text1_0_loc1` longtext COLLATE utf8_unicode_ci,
  `Text1_0_loc2` longtext COLLATE utf8_unicode_ci,
  `Text1_0_loc3` longtext COLLATE utf8_unicode_ci,
  `Text1_0_loc4` longtext COLLATE utf8_unicode_ci,
  `Text1_0_loc5` longtext COLLATE utf8_unicode_ci,
  `Text1_0_loc6` longtext COLLATE utf8_unicode_ci,
  `Text1_0_loc7` longtext COLLATE utf8_unicode_ci,
  `Text1_0_loc8` longtext COLLATE utf8_unicode_ci,
  `Text1_1_loc1` longtext COLLATE utf8_unicode_ci,
  `Text1_1_loc2` longtext COLLATE utf8_unicode_ci,
  `Text1_1_loc3` longtext COLLATE utf8_unicode_ci,
  `Text1_1_loc4` longtext COLLATE utf8_unicode_ci,
  `Text1_1_loc5` longtext COLLATE utf8_unicode_ci,
  `Text1_1_loc6` longtext COLLATE utf8_unicode_ci,
  `Text1_1_loc7` longtext COLLATE utf8_unicode_ci,
  `Text1_1_loc8` longtext COLLATE utf8_unicode_ci,
  `Text2_0_loc1` longtext COLLATE utf8_unicode_ci,
  `Text2_0_loc2` longtext COLLATE utf8_unicode_ci,
  `Text2_0_loc3` longtext COLLATE utf8_unicode_ci,
  `Text2_0_loc4` longtext COLLATE utf8_unicode_ci,
  `Text2_0_loc5` longtext COLLATE utf8_unicode_ci,
  `Text2_0_loc6` longtext COLLATE utf8_unicode_ci,
  `Text2_0_loc7` longtext COLLATE utf8_unicode_ci,
  `Text2_0_loc8` longtext COLLATE utf8_unicode_ci,
  `Text2_1_loc1` longtext COLLATE utf8_unicode_ci,
  `Text2_1_loc2` longtext COLLATE utf8_unicode_ci,
  `Text2_1_loc3` longtext COLLATE utf8_unicode_ci,
  `Text2_1_loc4` longtext COLLATE utf8_unicode_ci,
  `Text2_1_loc5` longtext COLLATE utf8_unicode_ci,
  `Text2_1_loc6` longtext COLLATE utf8_unicode_ci,
  `Text2_1_loc7` longtext COLLATE utf8_unicode_ci,
  `Text2_1_loc8` longtext COLLATE utf8_unicode_ci,
  `Text3_0_loc1` longtext COLLATE utf8_unicode_ci,
  `Text3_0_loc2` longtext COLLATE utf8_unicode_ci,
  `Text3_0_loc3` longtext COLLATE utf8_unicode_ci,
  `Text3_0_loc4` longtext COLLATE utf8_unicode_ci,
  `Text3_0_loc5` longtext COLLATE utf8_unicode_ci,
  `Text3_0_loc6` longtext COLLATE utf8_unicode_ci,
  `Text3_0_loc7` longtext COLLATE utf8_unicode_ci,
  `Text3_0_loc8` longtext COLLATE utf8_unicode_ci,
  `Text3_1_loc1` longtext COLLATE utf8_unicode_ci,
  `Text3_1_loc2` longtext COLLATE utf8_unicode_ci,
  `Text3_1_loc3` longtext COLLATE utf8_unicode_ci,
  `Text3_1_loc4` longtext COLLATE utf8_unicode_ci,
  `Text3_1_loc5` longtext COLLATE utf8_unicode_ci,
  `Text3_1_loc6` longtext COLLATE utf8_unicode_ci,
  `Text3_1_loc7` longtext COLLATE utf8_unicode_ci,
  `Text3_1_loc8` longtext COLLATE utf8_unicode_ci,
  `Text4_0_loc1` longtext COLLATE utf8_unicode_ci,
  `Text4_0_loc2` longtext COLLATE utf8_unicode_ci,
  `Text4_0_loc3` longtext COLLATE utf8_unicode_ci,
  `Text4_0_loc4` longtext COLLATE utf8_unicode_ci,
  `Text4_0_loc5` longtext COLLATE utf8_unicode_ci,
  `Text4_0_loc6` longtext COLLATE utf8_unicode_ci,
  `Text4_0_loc7` longtext COLLATE utf8_unicode_ci,
  `Text4_0_loc8` longtext COLLATE utf8_unicode_ci,
  `Text4_1_loc1` longtext COLLATE utf8_unicode_ci,
  `Text4_1_loc2` longtext COLLATE utf8_unicode_ci,
  `Text4_1_loc3` longtext COLLATE utf8_unicode_ci,
  `Text4_1_loc4` longtext COLLATE utf8_unicode_ci,
  `Text4_1_loc5` longtext COLLATE utf8_unicode_ci,
  `Text4_1_loc6` longtext COLLATE utf8_unicode_ci,
  `Text4_1_loc7` longtext COLLATE utf8_unicode_ci,
  `Text4_1_loc8` longtext COLLATE utf8_unicode_ci,
  `Text5_0_loc1` longtext COLLATE utf8_unicode_ci,
  `Text5_0_loc2` longtext COLLATE utf8_unicode_ci,
  `Text5_0_loc3` longtext COLLATE utf8_unicode_ci,
  `Text5_0_loc4` longtext COLLATE utf8_unicode_ci,
  `Text5_0_loc5` longtext COLLATE utf8_unicode_ci,
  `Text5_0_loc6` longtext COLLATE utf8_unicode_ci,
  `Text5_0_loc7` longtext COLLATE utf8_unicode_ci,
  `Text5_0_loc8` longtext COLLATE utf8_unicode_ci,
  `Text5_1_loc1` longtext COLLATE utf8_unicode_ci,
  `Text5_1_loc2` longtext COLLATE utf8_unicode_ci,
  `Text5_1_loc3` longtext COLLATE utf8_unicode_ci,
  `Text5_1_loc4` longtext COLLATE utf8_unicode_ci,
  `Text5_1_loc5` longtext COLLATE utf8_unicode_ci,
  `Text5_1_loc6` longtext COLLATE utf8_unicode_ci,
  `Text5_1_loc7` longtext COLLATE utf8_unicode_ci,
  `Text5_1_loc8` longtext COLLATE utf8_unicode_ci,
  `Text6_0_loc1` longtext COLLATE utf8_unicode_ci,
  `Text6_0_loc2` longtext COLLATE utf8_unicode_ci,
  `Text6_0_loc3` longtext COLLATE utf8_unicode_ci,
  `Text6_0_loc4` longtext COLLATE utf8_unicode_ci,
  `Text6_0_loc5` longtext COLLATE utf8_unicode_ci,
  `Text6_0_loc6` longtext COLLATE utf8_unicode_ci,
  `Text6_0_loc7` longtext COLLATE utf8_unicode_ci,
  `Text6_0_loc8` longtext COLLATE utf8_unicode_ci,
  `Text6_1_loc1` longtext COLLATE utf8_unicode_ci,
  `Text6_1_loc2` longtext COLLATE utf8_unicode_ci,
  `Text6_1_loc3` longtext COLLATE utf8_unicode_ci,
  `Text6_1_loc4` longtext COLLATE utf8_unicode_ci,
  `Text6_1_loc5` longtext COLLATE utf8_unicode_ci,
  `Text6_1_loc6` longtext COLLATE utf8_unicode_ci,
  `Text6_1_loc7` longtext COLLATE utf8_unicode_ci,
  `Text6_1_loc8` longtext COLLATE utf8_unicode_ci,
  `Text7_0_loc1` longtext COLLATE utf8_unicode_ci,
  `Text7_0_loc2` longtext COLLATE utf8_unicode_ci,
  `Text7_0_loc3` longtext COLLATE utf8_unicode_ci,
  `Text7_0_loc4` longtext COLLATE utf8_unicode_ci,
  `Text7_0_loc5` longtext COLLATE utf8_unicode_ci,
  `Text7_0_loc6` longtext COLLATE utf8_unicode_ci,
  `Text7_0_loc7` longtext COLLATE utf8_unicode_ci,
  `Text7_0_loc8` longtext COLLATE utf8_unicode_ci,
  `Text7_1_loc1` longtext COLLATE utf8_unicode_ci,
  `Text7_1_loc2` longtext COLLATE utf8_unicode_ci,
  `Text7_1_loc3` longtext COLLATE utf8_unicode_ci,
  `Text7_1_loc4` longtext COLLATE utf8_unicode_ci,
  `Text7_1_loc5` longtext COLLATE utf8_unicode_ci,
  `Text7_1_loc6` longtext COLLATE utf8_unicode_ci,
  `Text7_1_loc7` longtext COLLATE utf8_unicode_ci,
  `Text7_1_loc8` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  CONSTRAINT `locales_gossip_text_ibfk_1` FOREIGN KEY (`id`) REFERENCES `gossip_text` (`ID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `locales_page_text`
--

DROP TABLE IF EXISTS `locales_page_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locales_page_text` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Text_loc1` longtext COLLATE utf8_unicode_ci,
  `Text_loc2` longtext COLLATE utf8_unicode_ci,
  `Text_loc3` longtext COLLATE utf8_unicode_ci,
  `Text_loc4` longtext COLLATE utf8_unicode_ci,
  `Text_loc5` longtext COLLATE utf8_unicode_ci,
  `Text_loc6` longtext COLLATE utf8_unicode_ci,
  `Text_loc7` longtext COLLATE utf8_unicode_ci,
  `Text_loc8` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`entry`),
  CONSTRAINT `locales_page_text_ibfk_1` FOREIGN KEY (`entry`) REFERENCES `page_text` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `locales_quest`
--

DROP TABLE IF EXISTS `locales_quest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locales_quest` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Title_loc1` text COLLATE utf8_unicode_ci,
  `Title_loc2` text COLLATE utf8_unicode_ci,
  `Title_loc3` text COLLATE utf8_unicode_ci,
  `Title_loc4` text COLLATE utf8_unicode_ci,
  `Title_loc5` text COLLATE utf8_unicode_ci,
  `Title_loc6` text COLLATE utf8_unicode_ci,
  `Title_loc7` text COLLATE utf8_unicode_ci,
  `Title_loc8` text COLLATE utf8_unicode_ci,
  `Details_loc1` text COLLATE utf8_unicode_ci,
  `Details_loc2` text COLLATE utf8_unicode_ci,
  `Details_loc3` text COLLATE utf8_unicode_ci,
  `Details_loc4` text COLLATE utf8_unicode_ci,
  `Details_loc5` text COLLATE utf8_unicode_ci,
  `Details_loc6` text COLLATE utf8_unicode_ci,
  `Details_loc7` text COLLATE utf8_unicode_ci,
  `Details_loc8` text COLLATE utf8_unicode_ci,
  `Objectives_loc1` text COLLATE utf8_unicode_ci,
  `Objectives_loc2` text COLLATE utf8_unicode_ci,
  `Objectives_loc3` text COLLATE utf8_unicode_ci,
  `Objectives_loc4` text COLLATE utf8_unicode_ci,
  `Objectives_loc5` text COLLATE utf8_unicode_ci,
  `Objectives_loc6` text COLLATE utf8_unicode_ci,
  `Objectives_loc7` text COLLATE utf8_unicode_ci,
  `Objectives_loc8` text COLLATE utf8_unicode_ci,
  `OfferRewardText_loc1` text COLLATE utf8_unicode_ci,
  `OfferRewardText_loc2` text COLLATE utf8_unicode_ci,
  `OfferRewardText_loc3` text COLLATE utf8_unicode_ci,
  `OfferRewardText_loc4` text COLLATE utf8_unicode_ci,
  `OfferRewardText_loc5` text COLLATE utf8_unicode_ci,
  `OfferRewardText_loc6` text COLLATE utf8_unicode_ci,
  `OfferRewardText_loc7` text COLLATE utf8_unicode_ci,
  `OfferRewardText_loc8` text COLLATE utf8_unicode_ci,
  `RequestItemsText_loc1` text COLLATE utf8_unicode_ci,
  `RequestItemsText_loc2` text COLLATE utf8_unicode_ci,
  `RequestItemsText_loc3` text COLLATE utf8_unicode_ci,
  `RequestItemsText_loc4` text COLLATE utf8_unicode_ci,
  `RequestItemsText_loc5` text COLLATE utf8_unicode_ci,
  `RequestItemsText_loc6` text COLLATE utf8_unicode_ci,
  `RequestItemsText_loc7` text COLLATE utf8_unicode_ci,
  `RequestItemsText_loc8` text COLLATE utf8_unicode_ci,
  `EndText_loc1` text COLLATE utf8_unicode_ci,
  `EndText_loc2` text COLLATE utf8_unicode_ci,
  `EndText_loc3` text COLLATE utf8_unicode_ci,
  `EndText_loc4` text COLLATE utf8_unicode_ci,
  `EndText_loc5` text COLLATE utf8_unicode_ci,
  `EndText_loc6` text COLLATE utf8_unicode_ci,
  `EndText_loc7` text COLLATE utf8_unicode_ci,
  `EndText_loc8` text COLLATE utf8_unicode_ci,
  `ObjectiveText1_loc1` text COLLATE utf8_unicode_ci,
  `ObjectiveText1_loc2` text COLLATE utf8_unicode_ci,
  `ObjectiveText1_loc3` text COLLATE utf8_unicode_ci,
  `ObjectiveText1_loc4` text COLLATE utf8_unicode_ci,
  `ObjectiveText1_loc5` text COLLATE utf8_unicode_ci,
  `ObjectiveText1_loc6` text COLLATE utf8_unicode_ci,
  `ObjectiveText1_loc7` text COLLATE utf8_unicode_ci,
  `ObjectiveText1_loc8` text COLLATE utf8_unicode_ci,
  `ObjectiveText2_loc1` text COLLATE utf8_unicode_ci,
  `ObjectiveText2_loc2` text COLLATE utf8_unicode_ci,
  `ObjectiveText2_loc3` text COLLATE utf8_unicode_ci,
  `ObjectiveText2_loc4` text COLLATE utf8_unicode_ci,
  `ObjectiveText2_loc5` text COLLATE utf8_unicode_ci,
  `ObjectiveText2_loc6` text COLLATE utf8_unicode_ci,
  `ObjectiveText2_loc7` text COLLATE utf8_unicode_ci,
  `ObjectiveText2_loc8` text COLLATE utf8_unicode_ci,
  `ObjectiveText3_loc1` text COLLATE utf8_unicode_ci,
  `ObjectiveText3_loc2` text COLLATE utf8_unicode_ci,
  `ObjectiveText3_loc3` text COLLATE utf8_unicode_ci,
  `ObjectiveText3_loc4` text COLLATE utf8_unicode_ci,
  `ObjectiveText3_loc5` text COLLATE utf8_unicode_ci,
  `ObjectiveText3_loc6` text COLLATE utf8_unicode_ci,
  `ObjectiveText3_loc7` text COLLATE utf8_unicode_ci,
  `ObjectiveText3_loc8` text COLLATE utf8_unicode_ci,
  `ObjectiveText4_loc1` text COLLATE utf8_unicode_ci,
  `ObjectiveText4_loc2` text COLLATE utf8_unicode_ci,
  `ObjectiveText4_loc3` text COLLATE utf8_unicode_ci,
  `ObjectiveText4_loc4` text COLLATE utf8_unicode_ci,
  `ObjectiveText4_loc5` text COLLATE utf8_unicode_ci,
  `ObjectiveText4_loc6` text COLLATE utf8_unicode_ci,
  `ObjectiveText4_loc7` text COLLATE utf8_unicode_ci,
  `ObjectiveText4_loc8` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`entry`),
  CONSTRAINT `locales_quest_ibfk_1` FOREIGN KEY (`entry`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mail_loot_template`
--

DROP TABLE IF EXISTS `mail_loot_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_loot_template` (
  `Entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Reference` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Chance` float NOT NULL DEFAULT '100',
  `QuestRequired` tinyint(1) NOT NULL DEFAULT '0',
  `LootMode` smallint(5) unsigned NOT NULL DEFAULT '1',
  `GroupId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MinCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `MaxCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Comment` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`Entry`,`Item`),
  KEY `item` (`Item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `npc_vendor`
--

DROP TABLE IF EXISTS `npc_vendor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `npc_vendor` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `item` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `maxcount` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `incrtime` int(10) unsigned NOT NULL DEFAULT '0',
  `ExtendedCost` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`entry`,`item`,`ExtendedCost`),
  KEY `item` (`item`),
  CONSTRAINT `npc_vendor_ibfk_1` FOREIGN KEY (`entry`) REFERENCES `creature_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `npc_vendor_ibfk_2` FOREIGN KEY (`item`) REFERENCES `item_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `outdoorpvp_template`
--

DROP TABLE IF EXISTS `outdoorpvp_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outdoorpvp_template` (
  `TypeId` tinyint(3) unsigned NOT NULL,
  `ScriptName` char(64) NOT NULL DEFAULT '',
  `comment` text,
  PRIMARY KEY (`TypeId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='OutdoorPvP Templates';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `page_text`
--

DROP TABLE IF EXISTS `page_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page_text` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `text` longtext CHARACTER SET latin1 NOT NULL,
  `next_page` mediumint(8) unsigned DEFAULT NULL,
  PRIMARY KEY (`entry`),
  KEY `next_page` (`next_page`),
  CONSTRAINT `page_text_ibfk_1` FOREIGN KEY (`next_page`) REFERENCES `page_text` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pet_levelstats`
--

DROP TABLE IF EXISTS `pet_levelstats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pet_levelstats` (
  `creature_entry` mediumint(8) unsigned NOT NULL,
  `patch` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `level` tinyint(3) unsigned NOT NULL,
  `hp` smallint(5) unsigned NOT NULL,
  `mana` smallint(5) unsigned NOT NULL,
  `armor` int(10) unsigned NOT NULL DEFAULT '0',
  `str` smallint(5) unsigned NOT NULL,
  `agi` smallint(5) unsigned NOT NULL,
  `sta` smallint(5) unsigned NOT NULL,
  `inte` smallint(5) unsigned NOT NULL,
  `spi` smallint(5) unsigned NOT NULL,
  `min_dmg` smallint(5) unsigned NOT NULL DEFAULT '0',
  `max_dmg` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`creature_entry`,`patch`,`level`),
  CONSTRAINT `pet_levelstats_ibfk_2` FOREIGN KEY (`creature_entry`) REFERENCES `creature_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pet_name_generation`
--

DROP TABLE IF EXISTS `pet_name_generation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pet_name_generation` (
  `id` mediumint(8) unsigned NOT NULL,
  `word` tinytext CHARACTER SET latin1 NOT NULL,
  `entry` mediumint(8) unsigned DEFAULT NULL,
  `half` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entry` (`entry`),
  CONSTRAINT `pet_name_generation_ibfk_1` FOREIGN KEY (`entry`) REFERENCES `creature_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `petcreateinfo_spell`
--

DROP TABLE IF EXISTS `petcreateinfo_spell`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `petcreateinfo_spell` (
  `entry` mediumint(8) unsigned NOT NULL,
  `Spell1` int(10) unsigned DEFAULT NULL,
  `Spell2` int(10) unsigned DEFAULT NULL,
  `Spell3` int(10) unsigned DEFAULT NULL,
  `Spell4` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`entry`),
  KEY `Spell1` (`Spell1`),
  KEY `Spell2` (`Spell2`),
  KEY `Spell3` (`Spell3`),
  KEY `Spell4` (`Spell4`),
  CONSTRAINT `petcreateinfo_spell_ibfk_1` FOREIGN KEY (`entry`) REFERENCES `creature_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `petcreateinfo_spell_ibfk_2` FOREIGN KEY (`Spell1`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `petcreateinfo_spell_ibfk_3` FOREIGN KEY (`Spell2`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `petcreateinfo_spell_ibfk_4` FOREIGN KEY (`Spell3`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `petcreateinfo_spell_ibfk_5` FOREIGN KEY (`Spell4`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pickpocketing_loot_template`
--

DROP TABLE IF EXISTS `pickpocketing_loot_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pickpocketing_loot_template` (
  `Entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Reference` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Chance` float NOT NULL DEFAULT '100',
  `QuestRequired` tinyint(1) NOT NULL DEFAULT '0',
  `LootMode` smallint(5) unsigned NOT NULL DEFAULT '1',
  `GroupId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MinCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `MaxCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Comment` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`Entry`,`Item`),
  KEY `item` (`Item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_classlevelstats`
--

DROP TABLE IF EXISTS `player_classlevelstats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_classlevelstats` (
  `class` tinyint(3) unsigned NOT NULL,
  `level` tinyint(3) unsigned NOT NULL,
  `basehp` smallint(5) unsigned NOT NULL,
  `basemana` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`class`,`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_factionchange_items`
--

DROP TABLE IF EXISTS `player_factionchange_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_factionchange_items` (
  `alliance_id` mediumint(8) unsigned DEFAULT NULL,
  `alliance_comment` text CHARACTER SET latin1,
  `horde_id` mediumint(8) unsigned DEFAULT NULL,
  `horde_comment` text CHARACTER SET latin1,
  KEY `alliance_id` (`alliance_id`),
  KEY `horde_id` (`horde_id`),
  CONSTRAINT `player_factionchange_items_ibfk_1` FOREIGN KEY (`alliance_id`) REFERENCES `item_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `player_factionchange_items_ibfk_2` FOREIGN KEY (`horde_id`) REFERENCES `item_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_factionchange_items_race_specific`
--

DROP TABLE IF EXISTS `player_factionchange_items_race_specific`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_factionchange_items_race_specific` (
  `race1` int(8) NOT NULL,
  `item1` mediumint(8) unsigned NOT NULL,
  `race2` int(11) NOT NULL,
  `item2` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`race1`,`item1`,`race2`,`item2`),
  KEY `item1` (`item1`),
  KEY `item2` (`item2`),
  CONSTRAINT `player_factionchange_items_race_specific_ibfk_1` FOREIGN KEY (`item1`) REFERENCES `item_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `player_factionchange_items_race_specific_ibfk_2` FOREIGN KEY (`item2`) REFERENCES `item_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_factionchange_quests`
--

DROP TABLE IF EXISTS `player_factionchange_quests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_factionchange_quests` (
  `alliance_id` mediumint(8) unsigned DEFAULT NULL,
  `alliance_comment` varchar(100) DEFAULT NULL,
  `horde_id` mediumint(8) unsigned DEFAULT NULL,
  `horde_comment` varchar(100) DEFAULT NULL,
  KEY `alliance_id` (`alliance_id`),
  KEY `horde_id` (`horde_id`),
  CONSTRAINT `player_factionchange_quests_ibfk_1` FOREIGN KEY (`alliance_id`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `player_factionchange_quests_ibfk_2` FOREIGN KEY (`horde_id`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_factionchange_quests_race_specific`
--

DROP TABLE IF EXISTS `player_factionchange_quests_race_specific`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_factionchange_quests_race_specific` (
  `race1` int(11) NOT NULL,
  `quest1` mediumint(8) unsigned DEFAULT NULL,
  `race2` int(11) NOT NULL,
  `quest2` mediumint(8) unsigned DEFAULT NULL,
  KEY `quest1` (`quest1`),
  KEY `quest2` (`quest2`),
  CONSTRAINT `player_factionchange_quests_race_specific_ibfk_1` FOREIGN KEY (`quest1`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `player_factionchange_quests_race_specific_ibfk_2` FOREIGN KEY (`quest2`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_factionchange_reputations`
--

DROP TABLE IF EXISTS `player_factionchange_reputations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_factionchange_reputations` (
  `race_from` int(10) unsigned NOT NULL,
  `race_to` int(10) unsigned NOT NULL,
  `faction_from` int(10) unsigned NOT NULL,
  `faction_from_comment` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `faction_to` int(10) unsigned NOT NULL,
  `faction_to_comment` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  PRIMARY KEY (`race_from`,`race_to`,`faction_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_factionchange_reputations_generic`
--

DROP TABLE IF EXISTS `player_factionchange_reputations_generic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_factionchange_reputations_generic` (
  `alliance_id` int(11) NOT NULL,
  `alliance_comment` varchar(50) NOT NULL,
  `horde_id` int(11) NOT NULL,
  `horde_comment` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_factionchange_spells`
--

DROP TABLE IF EXISTS `player_factionchange_spells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_factionchange_spells` (
  `alliance_id` int(10) unsigned NOT NULL,
  `alliance_comment` text CHARACTER SET latin1,
  `horde_id` int(10) unsigned NOT NULL,
  `horde_comment` text CHARACTER SET latin1,
  PRIMARY KEY (`alliance_id`,`horde_id`),
  KEY `horde_id` (`horde_id`),
  CONSTRAINT `player_factionchange_spells_ibfk_1` FOREIGN KEY (`alliance_id`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `player_factionchange_spells_ibfk_2` FOREIGN KEY (`horde_id`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_factionchange_spells_priest_specific`
--

DROP TABLE IF EXISTS `player_factionchange_spells_priest_specific`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_factionchange_spells_priest_specific` (
  `race1` tinyint(3) NOT NULL,
  `spell1` int(10) unsigned DEFAULT NULL,
  `race2` tinyint(3) NOT NULL,
  `spell2` int(10) unsigned DEFAULT NULL,
  `comment` varchar(100) NOT NULL,
  KEY `spell1` (`spell1`),
  KEY `spell2` (`spell2`),
  CONSTRAINT `player_factionchange_spells_priest_specific_ibfk_1` FOREIGN KEY (`spell1`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `player_factionchange_spells_priest_specific_ibfk_2` FOREIGN KEY (`spell2`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_factionchange_spells_specific`
--

DROP TABLE IF EXISTS `player_factionchange_spells_specific`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_factionchange_spells_specific` (
  `race1` int(11) NOT NULL,
  `spell1` int(10) unsigned DEFAULT NULL,
  `race2` int(11) NOT NULL,
  `spell2` int(10) unsigned DEFAULT NULL,
  `comment` varchar(100) NOT NULL,
  KEY `spell1` (`spell1`),
  KEY `spell2` (`spell2`),
  CONSTRAINT `player_factionchange_spells_specific_ibfk_1` FOREIGN KEY (`spell1`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `player_factionchange_spells_specific_ibfk_2` FOREIGN KEY (`spell2`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_factionchange_titles`
--

DROP TABLE IF EXISTS `player_factionchange_titles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_factionchange_titles` (
  `alliance_id` int(8) NOT NULL,
  `alliance_comment` text CHARACTER SET latin1,
  `horde_id` int(8) NOT NULL,
  `horde_comment` text CHARACTER SET latin1,
  PRIMARY KEY (`alliance_id`,`horde_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_levelstats`
--

DROP TABLE IF EXISTS `player_levelstats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_levelstats` (
  `race` tinyint(3) unsigned NOT NULL,
  `class` tinyint(3) unsigned NOT NULL,
  `level` tinyint(3) unsigned NOT NULL,
  `str` tinyint(3) unsigned NOT NULL,
  `agi` tinyint(3) unsigned NOT NULL,
  `sta` tinyint(3) unsigned NOT NULL,
  `inte` tinyint(3) unsigned NOT NULL,
  `spi` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`race`,`class`,`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `playercreateinfo`
--

DROP TABLE IF EXISTS `playercreateinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playercreateinfo` (
  `race` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `class` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `map` smallint(5) unsigned NOT NULL DEFAULT '0',
  `zone` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `position_x` float NOT NULL DEFAULT '0',
  `position_y` float NOT NULL DEFAULT '0',
  `position_z` float NOT NULL DEFAULT '0',
  `position_o` float NOT NULL,
  PRIMARY KEY (`race`,`class`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `playercreateinfo_action`
--

DROP TABLE IF EXISTS `playercreateinfo_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playercreateinfo_action` (
  `race` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `class` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `button` smallint(5) unsigned NOT NULL DEFAULT '0',
  `action` smallint(5) unsigned NOT NULL DEFAULT '0',
  `type` smallint(5) unsigned NOT NULL DEFAULT '0',
  `misc` smallint(5) unsigned NOT NULL DEFAULT '0',
  KEY `playercreateinfo_race_class_index` (`race`,`class`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `playercreateinfo_item`
--

DROP TABLE IF EXISTS `playercreateinfo_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playercreateinfo_item` (
  `race` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `class` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `itemid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `amount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  KEY `playercreateinfo_race_class_index` (`race`,`class`),
  KEY `itemid` (`itemid`),
  CONSTRAINT `playercreateinfo_item_ibfk_1` FOREIGN KEY (`itemid`) REFERENCES `item_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `playercreateinfo_skills`
--

DROP TABLE IF EXISTS `playercreateinfo_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playercreateinfo_skills` (
  `raceMask` int(10) unsigned NOT NULL,
  `classMask` int(10) unsigned NOT NULL,
  `skill` smallint(5) unsigned NOT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`raceMask`,`classMask`,`skill`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `playercreateinfo_spell`
--

DROP TABLE IF EXISTS `playercreateinfo_spell`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playercreateinfo_spell` (
  `race` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `class` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Spell` int(10) unsigned NOT NULL,
  `Note` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `Active` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`race`,`class`,`Spell`),
  KEY `Spell` (`Spell`),
  CONSTRAINT `playercreateinfo_spell_ibfk_1` FOREIGN KEY (`Spell`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `points_of_interest`
--

DROP TABLE IF EXISTS `points_of_interest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `points_of_interest` (
  `ID` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `patch` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `PositionX` float NOT NULL DEFAULT '0',
  `PositionY` float NOT NULL DEFAULT '0',
  `Icon` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Flags` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Importance` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Name` text NOT NULL,
  `VerifiedBuild` smallint(5) DEFAULT '0',
  PRIMARY KEY (`ID`,`patch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pool_creature`
--

DROP TABLE IF EXISTS `pool_creature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pool_creature` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `pool_entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `chance` float unsigned NOT NULL DEFAULT '0',
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`guid`),
  KEY `pool_entry` (`pool_entry`),
  CONSTRAINT `pool_creature_ibfk_1` FOREIGN KEY (`guid`) REFERENCES `creature` (`spawnID`) ON UPDATE CASCADE,
  CONSTRAINT `pool_creature_ibfk_2` FOREIGN KEY (`pool_entry`) REFERENCES `pool_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pool_gameobject`
--

DROP TABLE IF EXISTS `pool_gameobject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pool_gameobject` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `pool_entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `chance` float unsigned NOT NULL DEFAULT '0',
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`guid`),
  KEY `idx_guid` (`guid`),
  KEY `pool_entry` (`pool_entry`),
  CONSTRAINT `pool_gameobject_ibfk_1` FOREIGN KEY (`guid`) REFERENCES `gameobject` (`guid`) ON UPDATE CASCADE,
  CONSTRAINT `pool_gameobject_ibfk_2` FOREIGN KEY (`pool_entry`) REFERENCES `pool_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pool_pool`
--

DROP TABLE IF EXISTS `pool_pool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pool_pool` (
  `pool_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `mother_pool` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `chance` float NOT NULL DEFAULT '0',
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pool_id`),
  KEY `mother_pool` (`mother_pool`),
  CONSTRAINT `pool_pool_ibfk_1` FOREIGN KEY (`pool_id`) REFERENCES `pool_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `pool_pool_ibfk_2` FOREIGN KEY (`mother_pool`) REFERENCES `pool_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pool_quest`
--

DROP TABLE IF EXISTS `pool_quest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pool_quest` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `pool_entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`entry`),
  KEY `idx_guid` (`entry`),
  KEY `fk_pooltemplate` (`pool_entry`),
  CONSTRAINT `fk_pooltemplate` FOREIGN KEY (`pool_entry`) REFERENCES `pool_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `fk_quest` FOREIGN KEY (`entry`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pool_template`
--

DROP TABLE IF EXISTS `pool_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pool_template` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Pool entry',
  `max_limit` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Max number of objects (0) is no limit',
  `max_limit_percent` float NOT NULL DEFAULT '0' COMMENT 'Max number of objects in percent, relative to object count in pool. (0) is no limit',
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prospecting_loot_template`
--

DROP TABLE IF EXISTS `prospecting_loot_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prospecting_loot_template` (
  `Entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Reference` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Chance` float NOT NULL DEFAULT '100',
  `QuestRequired` tinyint(1) NOT NULL DEFAULT '0',
  `LootMode` smallint(5) unsigned NOT NULL DEFAULT '1',
  `GroupId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MinCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `MaxCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Comment` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`Entry`,`Item`),
  KEY `item` (`Item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quest_details`
--

DROP TABLE IF EXISTS `quest_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quest_details` (
  `ID` mediumint(8) unsigned NOT NULL,
  `Emote1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Emote2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Emote3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Emote4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `EmoteDelay1` int(10) unsigned NOT NULL DEFAULT '0',
  `EmoteDelay2` int(10) unsigned NOT NULL DEFAULT '0',
  `EmoteDelay3` int(10) unsigned NOT NULL DEFAULT '0',
  `EmoteDelay4` int(10) unsigned NOT NULL DEFAULT '0',
  `VerifiedBuild` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `quest_details_ibfk_1` FOREIGN KEY (`ID`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quest_end_scripts`
--

DROP TABLE IF EXISTS `quest_end_scripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quest_end_scripts` (
  `_id` int(10) NOT NULL,
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `delay` int(10) unsigned NOT NULL DEFAULT '0',
  `command` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `datalong` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `datalong2` int(10) unsigned NOT NULL DEFAULT '0',
  `dataint` int(11) NOT NULL DEFAULT '0',
  `x` float NOT NULL DEFAULT '0',
  `y` float NOT NULL DEFAULT '0',
  `z` float NOT NULL DEFAULT '0',
  `o` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`_id`),
  KEY `id` (`id`),
  CONSTRAINT `quest_end_scripts_ibfk_1` FOREIGN KEY (`id`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quest_greeting`
--

DROP TABLE IF EXISTS `quest_greeting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quest_greeting` (
  `ID` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `GreetEmoteType` smallint(5) unsigned NOT NULL DEFAULT '0',
  `GreetEmoteDelay` int(10) unsigned NOT NULL DEFAULT '0',
  `Greeting` text,
  PRIMARY KEY (`ID`,`Type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quest_greeting_locale`
--

DROP TABLE IF EXISTS `quest_greeting_locale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quest_greeting_locale` (
  `ID` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `locale` varchar(4) NOT NULL,
  `Greeting` text,
  PRIMARY KEY (`ID`,`Type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quest_mail_sender`
--

DROP TABLE IF EXISTS `quest_mail_sender`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quest_mail_sender` (
  `QuestId` mediumint(8) unsigned NOT NULL,
  `RewardMailSenderEntry` int(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`QuestId`),
  CONSTRAINT `quest_mail_sender_ibfk_1` FOREIGN KEY (`QuestId`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quest_offer_reward`
--

DROP TABLE IF EXISTS `quest_offer_reward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quest_offer_reward` (
  `ID` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Emote1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Emote2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Emote3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Emote4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `EmoteDelay1` int(10) unsigned NOT NULL DEFAULT '0',
  `EmoteDelay2` int(10) unsigned NOT NULL DEFAULT '0',
  `EmoteDelay3` int(10) unsigned NOT NULL DEFAULT '0',
  `EmoteDelay4` int(10) unsigned NOT NULL DEFAULT '0',
  `RewardText` text,
  PRIMARY KEY (`ID`),
  CONSTRAINT `quest_offer_reward_ibfk_1` FOREIGN KEY (`ID`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quest_request_items`
--

DROP TABLE IF EXISTS `quest_request_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quest_request_items` (
  `ID` mediumint(8) unsigned NOT NULL,
  `EmoteOnComplete` smallint(5) unsigned NOT NULL DEFAULT '0',
  `EmoteOnIncomplete` smallint(5) unsigned NOT NULL DEFAULT '0',
  `CompletionText` text,
  PRIMARY KEY (`ID`),
  CONSTRAINT `quest_request_items_ibfk_1` FOREIGN KEY (`ID`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quest_start_scripts`
--

DROP TABLE IF EXISTS `quest_start_scripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quest_start_scripts` (
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `delay` int(10) unsigned NOT NULL DEFAULT '0',
  `command` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `datalong` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `datalong2` int(10) unsigned NOT NULL DEFAULT '0',
  `dataint` int(11) NOT NULL DEFAULT '0',
  `x` float NOT NULL DEFAULT '0',
  `y` float NOT NULL DEFAULT '0',
  `z` float NOT NULL DEFAULT '0',
  `o` float NOT NULL DEFAULT '0',
  KEY `id` (`id`),
  CONSTRAINT `quest_start_scripts_ibfk_1` FOREIGN KEY (`id`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quest_template`
--

DROP TABLE IF EXISTS `quest_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quest_template` (
  `entry` mediumint(8) unsigned NOT NULL,
  `patch` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Method` tinyint(3) unsigned NOT NULL DEFAULT '2',
  `ZoneOrSort` smallint(6) NOT NULL DEFAULT '0',
  `MinLevel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `QuestLevel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Type` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RequiredRaces` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RepObjectiveFaction` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RepObjectiveValue` mediumint(9) NOT NULL DEFAULT '0',
  `SuggestedPlayers` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `LimitTime` int(10) unsigned NOT NULL DEFAULT '0',
  `QuestFlags` smallint(5) unsigned NOT NULL DEFAULT '0',
  `CharTitleId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `NextQuestId` mediumint(9) NOT NULL DEFAULT '0',
  `SrcItemId` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Title` text CHARACTER SET latin1,
  `Details` text CHARACTER SET latin1,
  `Objectives` text CHARACTER SET latin1,
  `EndText` text CHARACTER SET latin1,
  `ObjectiveText1` text CHARACTER SET latin1,
  `ObjectiveText2` text CHARACTER SET latin1,
  `ObjectiveText3` text CHARACTER SET latin1,
  `ObjectiveText4` text CHARACTER SET latin1,
  `ReqItemId1` mediumint(8) unsigned DEFAULT NULL,
  `ReqItemId2` mediumint(8) unsigned DEFAULT NULL,
  `ReqItemId3` mediumint(8) unsigned DEFAULT NULL,
  `ReqItemId4` mediumint(8) unsigned DEFAULT NULL,
  `ReqItemCount1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ReqItemCount2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ReqItemCount3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ReqItemCount4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ReqSourceId1` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ReqSourceId2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ReqSourceId3` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ReqSourceId4` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ReqSourceCount1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ReqSourceCount2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ReqSourceCount3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ReqSourceCount4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ReqSourceRef1` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `ReqSourceRef2` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `ReqSourceRef3` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `ReqSourceRef4` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `ReqCreatureOrGOId1` mediumint(9) NOT NULL DEFAULT '0',
  `ReqCreatureOrGOId2` mediumint(9) NOT NULL DEFAULT '0',
  `ReqCreatureOrGOId3` mediumint(9) NOT NULL DEFAULT '0',
  `ReqCreatureOrGOId4` mediumint(9) NOT NULL DEFAULT '0',
  `ReqCreatureOrGOCount1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ReqCreatureOrGOCount2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ReqCreatureOrGOCount3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ReqCreatureOrGOCount4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ReqSpellCast1` int(10) unsigned DEFAULT NULL,
  `ReqSpellCast2` int(10) unsigned DEFAULT NULL,
  `ReqSpellCast3` int(10) unsigned DEFAULT NULL,
  `ReqSpellCast4` int(10) unsigned DEFAULT NULL,
  `RewChoiceItemId1` mediumint(8) unsigned DEFAULT NULL,
  `RewChoiceItemId2` mediumint(8) unsigned DEFAULT NULL,
  `RewChoiceItemId3` mediumint(8) unsigned DEFAULT NULL,
  `RewChoiceItemId4` mediumint(8) unsigned DEFAULT NULL,
  `RewChoiceItemId5` mediumint(8) unsigned DEFAULT NULL,
  `RewChoiceItemId6` mediumint(8) unsigned DEFAULT NULL,
  `RewChoiceItemCount1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RewChoiceItemCount2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RewChoiceItemCount3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RewChoiceItemCount4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RewChoiceItemCount5` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RewChoiceItemCount6` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RewItemId1` mediumint(8) unsigned DEFAULT NULL,
  `RewItemId2` mediumint(8) unsigned DEFAULT NULL,
  `RewItemId3` mediumint(8) unsigned DEFAULT NULL,
  `RewItemId4` mediumint(8) unsigned DEFAULT NULL,
  `RewItemCount1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RewItemCount2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RewItemCount3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RewItemCount4` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RewRepFaction1` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'faction id from Faction.dbc in this case',
  `RewRepFaction2` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'faction id from Faction.dbc in this case',
  `RewRepFaction3` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'faction id from Faction.dbc in this case',
  `RewRepFaction4` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'faction id from Faction.dbc in this case',
  `RewRepFaction5` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'faction id from Faction.dbc in this case',
  `RewRepValue1` mediumint(9) NOT NULL DEFAULT '0',
  `RewRepValue2` mediumint(9) NOT NULL DEFAULT '0',
  `RewRepValue3` mediumint(9) NOT NULL DEFAULT '0',
  `RewRepValue4` mediumint(9) NOT NULL DEFAULT '0',
  `RewRepValue5` mediumint(9) NOT NULL DEFAULT '0',
  `RewHonorableKills` mediumint(9) unsigned NOT NULL DEFAULT '0',
  `RewOrReqMoney` int(11) NOT NULL DEFAULT '0',
  `RewMoneyMaxLevel` int(10) unsigned NOT NULL DEFAULT '0',
  `RewSpell` int(10) unsigned DEFAULT NULL,
  `RewSpellCast` int(10) unsigned DEFAULT NULL,
  `PointMapId` smallint(5) unsigned NOT NULL DEFAULT '0',
  `PointX` float NOT NULL DEFAULT '0',
  `PointY` float NOT NULL DEFAULT '0',
  `PointOpt` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `StartScript` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `CompleteScript` mediumint(8) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entry`,`patch`),
  KEY `ReqItemId1` (`ReqItemId1`),
  KEY `ReqItemId2` (`ReqItemId2`),
  KEY `ReqItemId3` (`ReqItemId3`),
  KEY `ReqItemId4` (`ReqItemId4`),
  KEY `RewChoiceItemId1` (`RewChoiceItemId1`),
  KEY `RewChoiceItemId2` (`RewChoiceItemId2`),
  KEY `RewChoiceItemId3` (`RewChoiceItemId3`),
  KEY `RewChoiceItemId4` (`RewChoiceItemId4`),
  KEY `RewChoiceItemId5` (`RewChoiceItemId5`),
  KEY `RewChoiceItemId6` (`RewChoiceItemId6`),
  KEY `RewItemId1` (`RewItemId1`),
  KEY `RewItemId2` (`RewItemId2`),
  KEY `RewItemId3` (`RewItemId3`),
  KEY `RewItemId4` (`RewItemId4`),
  KEY `ReqSpellCast1` (`ReqSpellCast1`),
  KEY `ReqSpellCast2` (`ReqSpellCast2`),
  KEY `ReqSpellCast3` (`ReqSpellCast3`),
  KEY `ReqSpellCast4` (`ReqSpellCast4`),
  KEY `RewSpell` (`RewSpell`),
  KEY `RewSpellCast` (`RewSpellCast`),
  CONSTRAINT `quest_template_ibfk_1` FOREIGN KEY (`ReqItemId1`) REFERENCES `item_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_10` FOREIGN KEY (`RewChoiceItemId6`) REFERENCES `item_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_11` FOREIGN KEY (`RewItemId1`) REFERENCES `item_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_12` FOREIGN KEY (`RewItemId2`) REFERENCES `item_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_13` FOREIGN KEY (`RewItemId3`) REFERENCES `item_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_14` FOREIGN KEY (`RewItemId4`) REFERENCES `item_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_15` FOREIGN KEY (`ReqSpellCast1`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_16` FOREIGN KEY (`ReqSpellCast2`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_17` FOREIGN KEY (`ReqSpellCast3`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_18` FOREIGN KEY (`ReqSpellCast4`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_19` FOREIGN KEY (`RewSpell`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_2` FOREIGN KEY (`ReqItemId2`) REFERENCES `item_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_20` FOREIGN KEY (`RewSpellCast`) REFERENCES `spell_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_3` FOREIGN KEY (`ReqItemId3`) REFERENCES `item_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_4` FOREIGN KEY (`ReqItemId4`) REFERENCES `item_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_5` FOREIGN KEY (`RewChoiceItemId1`) REFERENCES `item_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_6` FOREIGN KEY (`RewChoiceItemId2`) REFERENCES `item_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_7` FOREIGN KEY (`RewChoiceItemId3`) REFERENCES `item_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_8` FOREIGN KEY (`RewChoiceItemId4`) REFERENCES `item_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `quest_template_ibfk_9` FOREIGN KEY (`RewChoiceItemId5`) REFERENCES `item_template` (`entry`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quest_template_addon`
--

DROP TABLE IF EXISTS `quest_template_addon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quest_template_addon` (
  `ID` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `MaxLevel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `AllowableClasses` int(10) unsigned NOT NULL DEFAULT '0',
  `SourceSpellID` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `PrevQuestID` mediumint(8) NOT NULL DEFAULT '0',
  `NextQuestID` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ExclusiveGroup` mediumint(8) NOT NULL DEFAULT '0',
  `RewardMailTemplateID` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `RewardMailDelay` int(10) unsigned NOT NULL DEFAULT '0',
  `RequiredSkillID` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RequiredSkillPoints` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RequiredMinRepFaction` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RequiredMaxRepFaction` smallint(5) unsigned NOT NULL DEFAULT '0',
  `RequiredMinRepValue` mediumint(8) NOT NULL DEFAULT '0',
  `RequiredMaxRepValue` mediumint(8) NOT NULL DEFAULT '0',
  `ProvidedItemCount` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `SpecialFlags` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recovery_item`
--

DROP TABLE IF EXISTS `recovery_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recovery_item` (
  `id` int(10) unsigned NOT NULL,
  `item_id` mediumint(8) unsigned NOT NULL,
  `quantity` smallint(4) unsigned NOT NULL DEFAULT '1',
  `race` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `class` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `set_type` tinyint(1) NOT NULL DEFAULT '0',
  `level_interval` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `equip` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `order` tinyint(2) unsigned NOT NULL DEFAULT '99',
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `recovery_item_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `item_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recovery_skill`
--

DROP TABLE IF EXISTS `recovery_skill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recovery_skill` (
  `id` int(10) unsigned NOT NULL,
  `skill_id` int(11) unsigned NOT NULL DEFAULT '0',
  `spell_id` int(11) unsigned NOT NULL DEFAULT '0',
  `level` int(11) unsigned NOT NULL DEFAULT '0',
  `order` tinyint(1) unsigned NOT NULL DEFAULT '9',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recovery_spell`
--

DROP TABLE IF EXISTS `recovery_spell`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recovery_spell` (
  `id` int(11) unsigned NOT NULL,
  `spell_id` int(10) unsigned NOT NULL,
  `class` tinyint(2) NOT NULL,
  `level` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `spell_id` (`spell_id`),
  CONSTRAINT `recovery_spell_ibfk_1` FOREIGN KEY (`spell_id`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recups_data`
--

DROP TABLE IF EXISTS `recups_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recups_data` (
  `classe` tinyint(3) NOT NULL,
  `faction` tinyint(3) NOT NULL,
  `phase` tinyint(3) NOT NULL,
  `command` text CHARACTER SET latin1,
  `metier` tinyint(3) NOT NULL,
  `stuff` tinyint(3) NOT NULL,
  `tier` tinyint(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reference_loot_template`
--

DROP TABLE IF EXISTS `reference_loot_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reference_loot_template` (
  `Entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Reference` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Chance` float NOT NULL DEFAULT '100',
  `QuestRequired` tinyint(1) NOT NULL DEFAULT '0',
  `LootMode` smallint(5) unsigned NOT NULL DEFAULT '1',
  `GroupId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MinCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `MaxCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Comment` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`Entry`,`Item`),
  KEY `item` (`Item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reserved_name`
--

DROP TABLE IF EXISTS `reserved_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reserved_name` (
  `name` varchar(12) CHARACTER SET latin1 NOT NULL DEFAULT '',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `script_spline_chain_meta`
--

DROP TABLE IF EXISTS `script_spline_chain_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `script_spline_chain_meta` (
  `entry` int(10) unsigned NOT NULL,
  `chainId` smallint(5) unsigned NOT NULL,
  `splineId` tinyint(3) unsigned NOT NULL,
  `expectedDuration` int(10) unsigned NOT NULL,
  `msUntilNext` int(10) unsigned NOT NULL,
  `velocity` float unsigned DEFAULT '0',
  PRIMARY KEY (`entry`,`chainId`,`splineId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `script_spline_chain_waypoints`
--

DROP TABLE IF EXISTS `script_spline_chain_waypoints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `script_spline_chain_waypoints` (
  `entry` int(10) unsigned NOT NULL,
  `chainId` smallint(5) unsigned NOT NULL,
  `splineId` tinyint(3) unsigned NOT NULL,
  `wpId` tinyint(3) unsigned NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  PRIMARY KEY (`entry`,`chainId`,`splineId`,`wpId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `script_texts`
--

DROP TABLE IF EXISTS `script_texts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `script_texts` (
  `entry` mediumint(8) NOT NULL,
  `content_default` text CHARACTER SET latin1 NOT NULL,
  `content_loc1` text CHARACTER SET latin1,
  `content_loc2` text CHARACTER SET latin1,
  `content_loc3` text CHARACTER SET latin1,
  `content_loc4` text CHARACTER SET latin1,
  `content_loc5` text CHARACTER SET latin1,
  `content_loc6` text CHARACTER SET latin1,
  `content_loc7` text CHARACTER SET latin1,
  `content_loc8` text CHARACTER SET latin1,
  `sound` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `language` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `emote` smallint(5) unsigned NOT NULL DEFAULT '0',
  `comment` text CHARACTER SET latin1,
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `script_waypoint`
--

DROP TABLE IF EXISTS `script_waypoint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `script_waypoint` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'creature_template entry',
  `pointid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `location_x` float NOT NULL DEFAULT '0',
  `location_y` float NOT NULL DEFAULT '0',
  `location_z` float NOT NULL DEFAULT '0',
  `waittime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'in milliseconds',
  `point_comment` text CHARACTER SET latin1,
  PRIMARY KEY (`entry`,`pointid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shop_items_random`
--

DROP TABLE IF EXISTS `shop_items_random`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop_items_random` (
  `id` int(11) NOT NULL,
  `category` tinyint(4) NOT NULL,
  `item_id` mediumint(8) unsigned NOT NULL,
  `count` tinyint(2) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `shop_items_random_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `item_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shop_orders`
--

DROP TABLE IF EXISTS `shop_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop_orders` (
  `id` int(11) unsigned NOT NULL,
  `name` text CHARACTER SET latin1 NOT NULL,
  `actions` text CHARACTER SET latin1 NOT NULL,
  `cost` int(11) unsigned NOT NULL DEFAULT '0',
  `class` int(11) unsigned NOT NULL DEFAULT '0',
  `level_min` int(11) unsigned NOT NULL DEFAULT '0',
  `level_max` int(11) NOT NULL DEFAULT '0',
  `race` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `skill_discovery_template`
--

DROP TABLE IF EXISTS `skill_discovery_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `skill_discovery_template` (
  `spellId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'SpellId of the discoverable spell',
  `reqSpell` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'spell requirement',
  `chance` float NOT NULL DEFAULT '0' COMMENT 'chance to discover',
  PRIMARY KEY (`spellId`),
  CONSTRAINT `skill_discovery_template_ibfk_2` FOREIGN KEY (`spellId`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `skill_extra_item_template`
--

DROP TABLE IF EXISTS `skill_extra_item_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `skill_extra_item_template` (
  `spellId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'SpellId of the item creation spell',
  `requiredSpecialization` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Specialization spell id',
  `additionalCreateChance` float NOT NULL DEFAULT '0' COMMENT 'chance to create add',
  `additionalMaxNum` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'max num of adds',
  PRIMARY KEY (`spellId`),
  CONSTRAINT `skill_extra_item_template_ibfk_2` FOREIGN KEY (`spellId`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `skill_fishing_base_level`
--

DROP TABLE IF EXISTS `skill_fishing_base_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `skill_fishing_base_level` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Area identifier',
  `skill` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Base skill level requirement',
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `skinning_loot_template`
--

DROP TABLE IF EXISTS `skinning_loot_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `skinning_loot_template` (
  `Entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Reference` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Chance` float NOT NULL DEFAULT '100',
  `QuestRequired` tinyint(1) NOT NULL DEFAULT '0',
  `LootMode` smallint(5) unsigned NOT NULL DEFAULT '1',
  `ChanceOrQuestChance` float NOT NULL DEFAULT '100',
  `GroupId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MinCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `mincountOrRef` mediumint(9) NOT NULL DEFAULT '1',
  `MaxCount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `lootcondition` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `condition_value1` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `condition_value2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Comment` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`Entry`,`Item`),
  KEY `item` (`Item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `smart_scripts`
--

DROP TABLE IF EXISTS `smart_scripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smart_scripts` (
  `entryorguid` int(11) NOT NULL,
  `source_type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `link` smallint(5) unsigned NOT NULL DEFAULT '0',
  `event_type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `event_phase_mask` smallint(5) unsigned NOT NULL DEFAULT '0',
  `event_chance` tinyint(3) unsigned NOT NULL DEFAULT '100',
  `event_flags` smallint(3) unsigned NOT NULL DEFAULT '0',
  `event_param1` int(10) NOT NULL DEFAULT '0',
  `event_param2` int(10) unsigned NOT NULL DEFAULT '0',
  `event_param3` int(10) unsigned NOT NULL DEFAULT '0',
  `event_param4` int(10) unsigned NOT NULL DEFAULT '0',
  `event_param5` int(10) unsigned NOT NULL DEFAULT '0',
  `action_type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `action_param1` int(10) unsigned NOT NULL DEFAULT '0',
  `action_param2` int(10) unsigned NOT NULL DEFAULT '0',
  `action_param3` int(10) unsigned NOT NULL DEFAULT '0',
  `action_param4` int(10) unsigned NOT NULL DEFAULT '0',
  `action_param5` int(10) unsigned NOT NULL DEFAULT '0',
  `action_param6` int(10) unsigned NOT NULL DEFAULT '0',
  `target_type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `target_flags` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `target_param1` int(10) unsigned NOT NULL DEFAULT '0',
  `target_param2` int(10) unsigned NOT NULL DEFAULT '0',
  `target_param3` int(10) unsigned NOT NULL DEFAULT '0',
  `target_param4` int(10) unsigned NOT NULL DEFAULT '0',
  `target_x` float NOT NULL DEFAULT '0',
  `target_y` float NOT NULL DEFAULT '0',
  `target_z` float NOT NULL DEFAULT '0',
  `target_o` float NOT NULL DEFAULT '0',
  `comment` text CHARACTER SET latin1 NOT NULL COMMENT 'Event Comment',
  `patch_min` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(2) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`entryorguid`,`source_type`,`id`,`link`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spawn_group`
--

DROP TABLE IF EXISTS `spawn_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spawn_group` (
  `groupId` int(10) unsigned NOT NULL,
  `spawnType` tinyint(10) unsigned NOT NULL,
  `spawnId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`groupId`,`spawnType`,`spawnId`),
  KEY `spawnId` (`spawnId`),
  CONSTRAINT `spawn_group_ibfk_2` FOREIGN KEY (`groupId`) REFERENCES `spawn_group_template` (`groupId`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spawn_group_template`
--

DROP TABLE IF EXISTS `spawn_group_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spawn_group_template` (
  `groupId` int(10) unsigned NOT NULL,
  `groupName` varchar(100) NOT NULL,
  `groupFlags` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`groupId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_affect`
--

DROP TABLE IF EXISTS `spell_affect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_affect` (
  `entry` int(10) unsigned NOT NULL,
  `effectId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `SpellFamilyMask` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entry`,`effectId`),
  CONSTRAINT `spell_affect_ibfk_1` FOREIGN KEY (`entry`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='You may add only first rank of spell and omit next ranks';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_area`
--

DROP TABLE IF EXISTS `spell_area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_area` (
  `spell` int(10) unsigned NOT NULL,
  `area` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `quest_start` mediumint(8) unsigned DEFAULT NULL,
  `quest_end` mediumint(8) unsigned DEFAULT NULL,
  `aura_spell` mediumint(8) NOT NULL DEFAULT '0',
  `racemask` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `gender` tinyint(3) unsigned NOT NULL DEFAULT '2',
  `autocast` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `quest_start_status` int(11) NOT NULL DEFAULT '64',
  `quest_end_status` int(11) NOT NULL DEFAULT '11',
  KEY `spell` (`spell`),
  KEY `quest_start` (`quest_start`),
  KEY `quest_end` (`quest_end`),
  CONSTRAINT `spell_area_ibfk_1` FOREIGN KEY (`spell`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `spell_area_ibfk_2` FOREIGN KEY (`quest_start`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `spell_area_ibfk_3` FOREIGN KEY (`quest_end`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_bonus_data`
--

DROP TABLE IF EXISTS `spell_bonus_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_bonus_data` (
  `entry` int(10) unsigned NOT NULL,
  `direct_bonus` float NOT NULL DEFAULT '0',
  `dot_bonus` float NOT NULL DEFAULT '0',
  `ap_bonus` float NOT NULL DEFAULT '0',
  `ap_dot_bonus` float NOT NULL DEFAULT '0',
  `comments` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`entry`),
  CONSTRAINT `spell_bonus_data_ibfk_1` FOREIGN KEY (`entry`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_custom_attr`
--

DROP TABLE IF EXISTS `spell_custom_attr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_custom_attr` (
  `entry` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'spell id',
  `attributes` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'SpellCustomAttributes',
  PRIMARY KEY (`entry`),
  CONSTRAINT `spell_custom_attr_ibfk_2` FOREIGN KEY (`entry`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_disabled`
--

DROP TABLE IF EXISTS `spell_disabled`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_disabled` (
  `entry` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Spell entry',
  `disable_mask` int(8) unsigned NOT NULL DEFAULT '0',
  `comment` varchar(64) CHARACTER SET latin1 NOT NULL DEFAULT '',
  PRIMARY KEY (`entry`),
  CONSTRAINT `spell_disabled_ibfk_2` FOREIGN KEY (`entry`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_elixir`
--

DROP TABLE IF EXISTS `spell_elixir`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_elixir` (
  `entry` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'SpellId of potion',
  `mask` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Mask 0x1 battle 0x2 guardian 0x3 flask 0x7 unstable flasks 0xB shattrath flasks',
  PRIMARY KEY (`entry`),
  CONSTRAINT `spell_elixir_ibfk_2` FOREIGN KEY (`entry`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_enchant_proc_data`
--

DROP TABLE IF EXISTS `spell_enchant_proc_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_enchant_proc_data` (
  `EnchantID` int(10) unsigned NOT NULL,
  `Chance` float NOT NULL DEFAULT '0',
  `ProcsPerMinute` float NOT NULL DEFAULT '0',
  `HitMask` int(10) unsigned NOT NULL DEFAULT '0',
  `AttributesMask` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`EnchantID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Spell enchant proc data';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_group`
--

DROP TABLE IF EXISTS `spell_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_group` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `spell_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`,`spell_id`),
  CONSTRAINT `fk_group` FOREIGN KEY (`id`) REFERENCES `spell_group_stack_rules` (`group_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Spell System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_group_stack_rules`
--

DROP TABLE IF EXISTS `spell_group_stack_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_group_stack_rules` (
  `group_id` int(10) unsigned NOT NULL,
  `stack_rule` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_learn_spell`
--

DROP TABLE IF EXISTS `spell_learn_spell`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_learn_spell` (
  `entry` int(10) unsigned NOT NULL DEFAULT '0',
  `SpellID` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entry`,`SpellID`),
  KEY `SpellID` (`SpellID`),
  CONSTRAINT `spell_learn_spell_ibfk_3` FOREIGN KEY (`entry`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `spell_learn_spell_ibfk_4` FOREIGN KEY (`SpellID`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_linked_spell`
--

DROP TABLE IF EXISTS `spell_linked_spell`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_linked_spell` (
  `spell_trigger` int(10) NOT NULL,
  `spell_effect` int(10) NOT NULL DEFAULT '0',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `comment` text CHARACTER SET latin1 NOT NULL,
  UNIQUE KEY `trigger_effect_type` (`spell_trigger`,`spell_effect`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_pet_auras`
--

DROP TABLE IF EXISTS `spell_pet_auras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_pet_auras` (
  `spell` int(10) unsigned NOT NULL COMMENT 'dummy spell id',
  `pet` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'pet id; 0 = all',
  `aura` int(10) unsigned NOT NULL COMMENT 'pet aura id',
  PRIMARY KEY (`spell`,`pet`),
  KEY `aura` (`aura`),
  CONSTRAINT `spell_pet_auras_ibfk_3` FOREIGN KEY (`spell`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `spell_pet_auras_ibfk_4` FOREIGN KEY (`aura`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_proc`
--

DROP TABLE IF EXISTS `spell_proc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_proc` (
  `SpellId` int(11) NOT NULL DEFAULT '0',
  `SchoolMask` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `SpellFamilyName` smallint(5) unsigned NOT NULL DEFAULT '0',
  `SpellFamilyMask` bigint(21) unsigned NOT NULL DEFAULT '0',
  `ProcFlags` int(10) unsigned NOT NULL DEFAULT '0',
  `SpellTypeMask` int(10) unsigned NOT NULL DEFAULT '0',
  `SpellPhaseMask` int(10) unsigned NOT NULL DEFAULT '0',
  `HitMask` int(10) unsigned NOT NULL DEFAULT '0',
  `AttributesMask` int(10) unsigned NOT NULL DEFAULT '0',
  `ProcsPerMinute` float NOT NULL DEFAULT '0',
  `Chance` float NOT NULL DEFAULT '0',
  `Cooldown` int(10) unsigned NOT NULL DEFAULT '0',
  `Charges` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`SpellId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_proc_event`
--

DROP TABLE IF EXISTS `spell_proc_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_proc_event` (
  `entry` int(10) unsigned NOT NULL DEFAULT '0',
  `SchoolMask` tinyint(4) NOT NULL DEFAULT '0',
  `SpellFamilyName` smallint(6) unsigned NOT NULL DEFAULT '0',
  `SpellFamilyMask` bigint(40) unsigned NOT NULL DEFAULT '0',
  `procFlags` int(10) unsigned NOT NULL DEFAULT '0',
  `procEx` int(10) unsigned NOT NULL DEFAULT '0',
  `ppmRate` float NOT NULL DEFAULT '0',
  `CustomChance` float NOT NULL DEFAULT '0',
  `Cooldown` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entry`),
  CONSTRAINT `spell_proc_event_ibfk_2` FOREIGN KEY (`entry`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_ranks`
--

DROP TABLE IF EXISTS `spell_ranks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_ranks` (
  `first_spell_id` int(10) unsigned NOT NULL DEFAULT '0',
  `spell_id` int(10) unsigned NOT NULL DEFAULT '0',
  `rank` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`spell_id`),
  KEY `first_spell_id` (`first_spell_id`),
  CONSTRAINT `spell_ranks_ibfk_1` FOREIGN KEY (`first_spell_id`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `spell_ranks_ibfk_2` FOREIGN KEY (`spell_id`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Spell Additinal Data';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_required`
--

DROP TABLE IF EXISTS `spell_required`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_required` (
  `spell_id` int(10) unsigned NOT NULL DEFAULT '0',
  `req_spell` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`spell_id`),
  KEY `req_spell` (`req_spell`),
  CONSTRAINT `spell_required_ibfk_1` FOREIGN KEY (`spell_id`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE,
  CONSTRAINT `spell_required_ibfk_2` FOREIGN KEY (`req_spell`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_script_names`
--

DROP TABLE IF EXISTS `spell_script_names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_script_names` (
  `spell_id` int(11) NOT NULL,
  `ScriptName` char(64) NOT NULL,
  UNIQUE KEY `spell_id` (`spell_id`,`ScriptName`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_scripts`
--

DROP TABLE IF EXISTS `spell_scripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_scripts` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `delay` int(10) unsigned NOT NULL DEFAULT '0',
  `command` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `datalong` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `datalong2` int(10) unsigned NOT NULL DEFAULT '0',
  `dataint` int(11) NOT NULL DEFAULT '0',
  `x` float NOT NULL DEFAULT '0',
  `y` float NOT NULL DEFAULT '0',
  `z` float NOT NULL DEFAULT '0',
  `o` float NOT NULL DEFAULT '0',
  KEY `id` (`id`),
  CONSTRAINT `spell_scripts_ibfk_2` FOREIGN KEY (`id`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_target_position`
--

DROP TABLE IF EXISTS `spell_target_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_target_position` (
  `id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Identifier',
  `target_map` smallint(5) unsigned NOT NULL DEFAULT '0',
  `target_position_x` float NOT NULL DEFAULT '0',
  `target_position_y` float NOT NULL DEFAULT '0',
  `target_position_z` float NOT NULL DEFAULT '0',
  `target_orientation` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  CONSTRAINT `spell_target_position_ibfk_1` FOREIGN KEY (`id`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_template`
--

DROP TABLE IF EXISTS `spell_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_template` (
  `entry` int(10) unsigned NOT NULL DEFAULT '0',
  `category` int(9) unsigned NOT NULL DEFAULT '0',
  `dispel` int(9) unsigned NOT NULL DEFAULT '0',
  `mechanic` int(9) unsigned NOT NULL DEFAULT '0',
  `attributes` int(9) unsigned NOT NULL DEFAULT '0',
  `attributesEx` int(9) unsigned NOT NULL DEFAULT '0',
  `attributesEx2` int(9) unsigned NOT NULL DEFAULT '0',
  `attributesEx3` int(9) unsigned NOT NULL DEFAULT '0',
  `attributesEx4` int(9) unsigned NOT NULL DEFAULT '0',
  `attributesEx5` int(9) unsigned NOT NULL DEFAULT '0',
  `attributesEx6` int(9) unsigned NOT NULL DEFAULT '0',
  `stances` int(9) unsigned NOT NULL DEFAULT '0',
  `stancesNot` int(9) unsigned NOT NULL DEFAULT '0',
  `targets` int(9) unsigned NOT NULL DEFAULT '0',
  `targetCreatureType` int(9) unsigned NOT NULL DEFAULT '0',
  `requiresSpellFocus` int(9) unsigned NOT NULL DEFAULT '0',
  `facingCasterFlags` int(9) unsigned NOT NULL DEFAULT '0',
  `casterAuraState` int(9) unsigned NOT NULL DEFAULT '0',
  `targetAuraState` int(9) unsigned NOT NULL DEFAULT '0',
  `casterAuraStateNot` int(9) unsigned NOT NULL DEFAULT '0',
  `targetAuraStateNot` int(9) unsigned NOT NULL DEFAULT '0',
  `castingTimeIndex` int(9) unsigned NOT NULL DEFAULT '0',
  `recoveryTime` int(9) unsigned NOT NULL DEFAULT '0',
  `categoryRecoveryTime` int(9) unsigned NOT NULL DEFAULT '0',
  `interruptFlags` int(9) unsigned NOT NULL DEFAULT '0',
  `auraInterruptFlags` int(9) unsigned NOT NULL DEFAULT '0',
  `channelInterruptFlags` int(9) unsigned NOT NULL DEFAULT '0',
  `procFlags` int(9) unsigned NOT NULL DEFAULT '0',
  `procChance` int(9) unsigned NOT NULL DEFAULT '0',
  `procCharges` int(9) unsigned NOT NULL DEFAULT '0',
  `maxLevel` int(9) unsigned NOT NULL DEFAULT '0',
  `baseLevel` int(9) unsigned NOT NULL DEFAULT '0',
  `spellLevel` int(9) unsigned NOT NULL DEFAULT '0',
  `durationIndex` int(9) unsigned NOT NULL DEFAULT '0',
  `powerType` int(9) NOT NULL DEFAULT '0',
  `manaCost` int(9) unsigned NOT NULL DEFAULT '0',
  `manaCostPerlevel` int(9) unsigned NOT NULL DEFAULT '0',
  `manaPerSecond` int(9) unsigned NOT NULL DEFAULT '0',
  `manaPerSecondPerLevel` int(9) unsigned NOT NULL DEFAULT '0',
  `rangeIndex` int(9) unsigned NOT NULL DEFAULT '0',
  `speed` float NOT NULL DEFAULT '0',
  `stackAmount` int(9) unsigned NOT NULL DEFAULT '0',
  `totem1` int(9) unsigned NOT NULL DEFAULT '0',
  `totem2` int(9) unsigned NOT NULL DEFAULT '0',
  `reagent1` int(9) NOT NULL DEFAULT '0',
  `reagent2` int(9) NOT NULL DEFAULT '0',
  `reagent3` int(9) NOT NULL DEFAULT '0',
  `reagent4` int(9) NOT NULL DEFAULT '0',
  `reagent5` int(9) NOT NULL DEFAULT '0',
  `reagent6` int(9) NOT NULL DEFAULT '0',
  `reagent7` int(9) NOT NULL DEFAULT '0',
  `reagent8` int(9) NOT NULL DEFAULT '0',
  `reagentCount1` int(9) unsigned NOT NULL DEFAULT '0',
  `reagentCount2` int(9) unsigned NOT NULL DEFAULT '0',
  `reagentCount3` int(9) unsigned NOT NULL DEFAULT '0',
  `reagentCount4` int(9) unsigned NOT NULL DEFAULT '0',
  `reagentCount5` int(9) unsigned NOT NULL DEFAULT '0',
  `reagentCount6` int(9) unsigned NOT NULL DEFAULT '0',
  `reagentCount7` int(9) unsigned NOT NULL DEFAULT '0',
  `reagentCount8` int(9) unsigned NOT NULL DEFAULT '0',
  `equippedItemClass` int(9) NOT NULL DEFAULT '0',
  `equippedItemSubClassMask` int(9) NOT NULL DEFAULT '0',
  `equippedItemInventoryTypeMask` int(9) NOT NULL DEFAULT '0',
  `effect1` int(9) unsigned NOT NULL DEFAULT '0',
  `effect2` int(9) unsigned NOT NULL DEFAULT '0',
  `effect3` int(9) unsigned NOT NULL DEFAULT '0',
  `effectDieSides1` int(9) NOT NULL DEFAULT '0',
  `effectDieSides2` int(9) NOT NULL DEFAULT '0',
  `effectDieSides3` int(9) NOT NULL DEFAULT '0',
  `effectBaseDice1` int(9) NOT NULL DEFAULT '0',
  `effectBaseDice2` int(9) NOT NULL DEFAULT '0',
  `effectBaseDice3` int(9) NOT NULL DEFAULT '0',
  `effectDicePerLevel1` float NOT NULL DEFAULT '0',
  `effectDicePerLevel2` float NOT NULL DEFAULT '0',
  `effectDicePerLevel3` float NOT NULL DEFAULT '0',
  `effectRealPointsPerLevel1` float NOT NULL DEFAULT '0',
  `effectRealPointsPerLevel2` float NOT NULL DEFAULT '0',
  `effectRealPointsPerLevel3` float NOT NULL DEFAULT '0',
  `effectBasePoints1` int(9) NOT NULL DEFAULT '0',
  `effectBasePoints2` int(9) NOT NULL DEFAULT '0',
  `effectBasePoints3` int(9) NOT NULL DEFAULT '0',
  `effectMechanic1` int(9) unsigned NOT NULL DEFAULT '0',
  `effectMechanic2` int(9) unsigned NOT NULL DEFAULT '0',
  `effectMechanic3` int(9) unsigned NOT NULL DEFAULT '0',
  `effectImplicitTargetA1` int(9) unsigned NOT NULL DEFAULT '0',
  `effectImplicitTargetA2` int(9) unsigned NOT NULL DEFAULT '0',
  `effectImplicitTargetA3` int(9) unsigned NOT NULL DEFAULT '0',
  `effectImplicitTargetB1` int(9) unsigned NOT NULL DEFAULT '0',
  `effectImplicitTargetB2` int(9) unsigned NOT NULL DEFAULT '0',
  `effectImplicitTargetB3` int(9) unsigned NOT NULL DEFAULT '0',
  `effectRadiusIndex1` int(9) unsigned NOT NULL DEFAULT '0',
  `effectRadiusIndex2` int(9) unsigned NOT NULL DEFAULT '0',
  `effectRadiusIndex3` int(9) unsigned NOT NULL DEFAULT '0',
  `effectApplyAuraName1` int(9) unsigned NOT NULL DEFAULT '0',
  `effectApplyAuraName2` int(9) unsigned NOT NULL DEFAULT '0',
  `effectApplyAuraName3` int(9) unsigned NOT NULL DEFAULT '0',
  `effectAmplitude1` int(9) unsigned NOT NULL DEFAULT '0',
  `effectAmplitude2` int(9) unsigned NOT NULL DEFAULT '0',
  `effectAmplitude3` int(9) unsigned NOT NULL DEFAULT '0',
  `effectMultipleValue1` float NOT NULL DEFAULT '0',
  `effectMultipleValue2` float NOT NULL DEFAULT '0',
  `effectMultipleValue3` float NOT NULL DEFAULT '0',
  `effectChainTarget1` int(9) unsigned NOT NULL DEFAULT '0',
  `effectChainTarget2` int(9) unsigned NOT NULL DEFAULT '0',
  `effectChainTarget3` int(9) unsigned NOT NULL DEFAULT '0',
  `effectItemType1` int(9) unsigned NOT NULL DEFAULT '0',
  `effectItemType2` int(9) unsigned NOT NULL DEFAULT '0',
  `effectItemType3` int(9) unsigned NOT NULL DEFAULT '0',
  `effectMiscValue1` int(9) NOT NULL DEFAULT '0',
  `effectMiscValue2` int(9) NOT NULL DEFAULT '0',
  `effectMiscValue3` int(9) NOT NULL DEFAULT '0',
  `effectMiscValueB1` int(9) NOT NULL DEFAULT '0',
  `effectMiscValueB2` int(9) NOT NULL DEFAULT '0',
  `effectMiscValueB3` int(9) NOT NULL DEFAULT '0',
  `effectTriggerSpell1` int(9) unsigned NOT NULL DEFAULT '0',
  `effectTriggerSpell2` int(9) unsigned NOT NULL DEFAULT '0',
  `effectTriggerSpell3` int(9) unsigned NOT NULL DEFAULT '0',
  `effectPointsPerComboPoint1` float NOT NULL DEFAULT '0',
  `effectPointsPerComboPoint2` float NOT NULL DEFAULT '0',
  `effectPointsPerComboPoint3` float NOT NULL DEFAULT '0',
  `spellVisual` int(9) unsigned NOT NULL DEFAULT '0',
  `spellIconID` int(9) unsigned NOT NULL DEFAULT '0',
  `activeIconID` int(9) unsigned NOT NULL DEFAULT '0',
  `priority` int(9) unsigned NOT NULL DEFAULT '0',
  `spellName1` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName2` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName3` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName4` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName5` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName6` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName7` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName8` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName9` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName10` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName11` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName12` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName13` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName14` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName15` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `spellName16` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank1` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank2` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank3` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank4` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank5` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank6` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank7` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank8` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank9` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank10` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank11` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank12` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank13` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank14` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank15` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `rank16` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `description1` text CHARACTER SET latin1,
  `manaCostPercentage` int(9) unsigned NOT NULL DEFAULT '0',
  `startRecoveryCategory` int(9) unsigned NOT NULL DEFAULT '0',
  `startRecoveryTime` int(9) unsigned NOT NULL DEFAULT '0',
  `maxTargetLevel` int(9) unsigned NOT NULL DEFAULT '0',
  `spellFamilyName` int(9) unsigned NOT NULL DEFAULT '0',
  `spellFamilyFlags` bigint(20) unsigned NOT NULL DEFAULT '0',
  `maxAffectedTargets` int(9) unsigned NOT NULL DEFAULT '0',
  `dmgClass` int(9) unsigned NOT NULL DEFAULT '0',
  `preventionType` int(9) unsigned NOT NULL DEFAULT '0',
  `dmgMultiplier1` float NOT NULL DEFAULT '0',
  `dmgMultiplier2` float NOT NULL DEFAULT '0',
  `dmgMultiplier3` float NOT NULL DEFAULT '0',
  `totemCategory1` int(9) unsigned NOT NULL DEFAULT '0',
  `totemCategory2` int(9) unsigned NOT NULL DEFAULT '0',
  `areaId` int(9) unsigned NOT NULL DEFAULT '0',
  `schoolMask` int(9) unsigned NOT NULL DEFAULT '0',
  `serverSide` tinyint(1) NOT NULL DEFAULT '0',
  `customAttributesFlags` int(11) DEFAULT NULL,
  `comment` text CHARACTER SET latin1,
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_template_override`
--

DROP TABLE IF EXISTS `spell_template_override`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_template_override` (
  `entry` int(10) unsigned NOT NULL,
  `category` int(9) unsigned DEFAULT NULL,
  `dispel` int(9) unsigned DEFAULT NULL,
  `mechanic` int(9) unsigned DEFAULT NULL,
  `attributes` int(9) unsigned DEFAULT NULL,
  `attributesEx` int(9) unsigned DEFAULT NULL,
  `attributesEx2` int(9) unsigned DEFAULT NULL,
  `attributesEx3` int(9) unsigned DEFAULT NULL,
  `attributesEx4` int(9) unsigned DEFAULT NULL,
  `attributesEx5` int(9) unsigned DEFAULT NULL,
  `attributesEx6` int(9) unsigned DEFAULT NULL,
  `stances` int(9) unsigned DEFAULT NULL,
  `stancesNot` int(9) unsigned DEFAULT NULL,
  `targets` int(9) unsigned DEFAULT NULL,
  `targetCreatureType` int(9) unsigned DEFAULT NULL,
  `requiresSpellFocus` int(9) unsigned DEFAULT NULL,
  `facingCasterFlags` int(9) unsigned DEFAULT NULL,
  `casterAuraState` int(9) unsigned DEFAULT NULL,
  `targetAuraState` int(9) unsigned DEFAULT NULL,
  `casterAuraStateNot` int(9) unsigned DEFAULT NULL,
  `targetAuraStateNot` int(9) unsigned DEFAULT NULL,
  `castingTimeIndex` int(9) unsigned DEFAULT NULL,
  `recoveryTime` int(9) unsigned DEFAULT NULL,
  `categoryRecoveryTime` int(9) unsigned DEFAULT NULL,
  `interruptFlags` int(9) unsigned DEFAULT NULL,
  `auraInterruptFlags` int(9) unsigned DEFAULT NULL,
  `channelInterruptFlags` int(9) unsigned DEFAULT NULL,
  `procFlags` int(9) unsigned DEFAULT NULL,
  `procChance` int(9) unsigned DEFAULT NULL,
  `procCharges` int(9) unsigned DEFAULT NULL,
  `maxLevel` int(9) unsigned DEFAULT NULL,
  `baseLevel` int(9) unsigned DEFAULT NULL,
  `spellLevel` int(9) unsigned DEFAULT NULL,
  `durationIndex` int(9) unsigned DEFAULT NULL,
  `powerType` int(9) DEFAULT NULL,
  `manaCost` int(9) unsigned DEFAULT NULL,
  `manaCostPerlevel` int(9) unsigned DEFAULT NULL,
  `manaPerSecond` int(9) unsigned DEFAULT NULL,
  `manaPerSecondPerLevel` int(9) unsigned DEFAULT NULL,
  `rangeIndex` int(9) unsigned DEFAULT NULL,
  `speed` float DEFAULT NULL,
  `stackAmount` int(9) unsigned DEFAULT NULL,
  `totem1` int(9) unsigned DEFAULT NULL,
  `totem2` int(9) unsigned DEFAULT NULL,
  `reagent1` int(9) DEFAULT NULL,
  `reagent2` int(9) DEFAULT NULL,
  `reagent3` int(9) DEFAULT NULL,
  `reagent4` int(9) DEFAULT NULL,
  `reagent5` int(9) DEFAULT NULL,
  `reagent6` int(9) DEFAULT NULL,
  `reagent7` int(9) DEFAULT NULL,
  `reagent8` int(9) DEFAULT NULL,
  `reagentCount1` int(9) unsigned DEFAULT NULL,
  `reagentCount2` int(9) unsigned DEFAULT NULL,
  `reagentCount3` int(9) unsigned DEFAULT NULL,
  `reagentCount4` int(9) unsigned DEFAULT NULL,
  `reagentCount5` int(9) unsigned DEFAULT NULL,
  `reagentCount6` int(9) unsigned DEFAULT NULL,
  `reagentCount7` int(9) unsigned DEFAULT NULL,
  `reagentCount8` int(9) unsigned DEFAULT NULL,
  `equippedItemClass` int(9) DEFAULT NULL,
  `equippedItemSubClassMask` int(9) DEFAULT NULL,
  `equippedItemInventoryTypeMask` int(9) DEFAULT NULL,
  `effect1` int(9) unsigned DEFAULT NULL,
  `effect2` int(9) unsigned DEFAULT NULL,
  `effect3` int(9) unsigned DEFAULT NULL,
  `effectDieSides1` int(9) DEFAULT NULL,
  `effectDieSides2` int(9) DEFAULT NULL,
  `effectDieSides3` int(9) DEFAULT NULL,
  `effectBaseDice1` int(9) DEFAULT NULL,
  `effectBaseDice2` int(9) DEFAULT NULL,
  `effectBaseDice3` int(9) DEFAULT NULL,
  `effectDicePerLevel1` float DEFAULT NULL,
  `effectDicePerLevel2` float DEFAULT NULL,
  `effectDicePerLevel3` float DEFAULT NULL,
  `effectRealPointsPerLevel1` float DEFAULT NULL,
  `effectRealPointsPerLevel2` float DEFAULT NULL,
  `effectRealPointsPerLevel3` float DEFAULT NULL,
  `effectBasePoints1` int(9) DEFAULT NULL,
  `effectBasePoints2` int(9) DEFAULT NULL,
  `effectBasePoints3` int(9) DEFAULT NULL,
  `effectMechanic1` int(9) unsigned DEFAULT NULL,
  `effectMechanic2` int(9) unsigned DEFAULT NULL,
  `effectMechanic3` int(9) unsigned DEFAULT NULL,
  `effectImplicitTargetA1` int(9) unsigned DEFAULT NULL,
  `effectImplicitTargetA2` int(9) unsigned DEFAULT NULL,
  `effectImplicitTargetA3` int(9) unsigned DEFAULT NULL,
  `effectImplicitTargetB1` int(9) unsigned DEFAULT NULL,
  `effectImplicitTargetB2` int(9) unsigned DEFAULT NULL,
  `effectImplicitTargetB3` int(9) unsigned DEFAULT NULL,
  `effectRadiusIndex1` int(9) unsigned DEFAULT NULL,
  `effectRadiusIndex2` int(9) unsigned DEFAULT NULL,
  `effectRadiusIndex3` int(9) unsigned DEFAULT NULL,
  `effectApplyAuraName1` int(9) unsigned DEFAULT NULL,
  `effectApplyAuraName2` int(9) unsigned DEFAULT NULL,
  `effectApplyAuraName3` int(9) unsigned DEFAULT NULL,
  `effectAmplitude1` int(9) unsigned DEFAULT NULL,
  `effectAmplitude2` int(9) unsigned DEFAULT NULL,
  `effectAmplitude3` int(9) unsigned DEFAULT NULL,
  `effectMultipleValue1` float DEFAULT NULL,
  `effectMultipleValue2` float DEFAULT NULL,
  `effectMultipleValue3` float DEFAULT NULL,
  `effectChainTarget1` int(9) unsigned DEFAULT NULL,
  `effectChainTarget2` int(9) unsigned DEFAULT NULL,
  `effectChainTarget3` int(9) unsigned DEFAULT NULL,
  `effectItemType1` int(9) unsigned DEFAULT NULL,
  `effectItemType2` int(9) unsigned DEFAULT NULL,
  `effectItemType3` int(9) unsigned DEFAULT NULL,
  `effectMiscValue1` int(9) DEFAULT NULL,
  `effectMiscValue2` int(9) DEFAULT NULL,
  `effectMiscValue3` int(9) DEFAULT NULL,
  `effectMiscValueB1` int(9) DEFAULT NULL,
  `effectMiscValueB2` int(9) DEFAULT NULL,
  `effectMiscValueB3` int(9) DEFAULT NULL,
  `effectTriggerSpell1` int(9) unsigned DEFAULT NULL,
  `effectTriggerSpell2` int(9) unsigned DEFAULT NULL,
  `effectTriggerSpell3` int(9) unsigned DEFAULT NULL,
  `effectPointsPerComboPoint1` float DEFAULT NULL,
  `effectPointsPerComboPoint2` float DEFAULT NULL,
  `effectPointsPerComboPoint3` float DEFAULT NULL,
  `spellVisual` int(9) unsigned DEFAULT NULL,
  `spellIconID` int(9) unsigned DEFAULT NULL,
  `activeIconID` int(9) unsigned DEFAULT NULL,
  `priority` int(9) unsigned DEFAULT NULL,
  `spellName1` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName2` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName3` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName4` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName5` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName6` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName7` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName8` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName9` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName10` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName11` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName12` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName13` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName14` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName15` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `spellName16` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank1` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank2` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank3` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank4` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank5` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank6` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank7` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank8` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank9` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank10` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank11` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank12` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank13` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank14` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank15` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `rank16` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `description1` text CHARACTER SET latin1,
  `manaCostPercentage` int(9) unsigned DEFAULT NULL,
  `startRecoveryCategory` int(9) unsigned DEFAULT NULL,
  `startRecoveryTime` int(9) unsigned DEFAULT NULL,
  `maxTargetLevel` int(9) unsigned DEFAULT NULL,
  `spellFamilyName` int(9) unsigned DEFAULT NULL,
  `spellFamilyFlags` bigint(20) unsigned DEFAULT NULL,
  `maxAffectedTargets` int(9) unsigned DEFAULT NULL,
  `dmgClass` int(9) unsigned DEFAULT NULL,
  `preventionType` int(9) unsigned DEFAULT NULL,
  `dmgMultiplier1` float DEFAULT NULL,
  `dmgMultiplier2` float DEFAULT NULL,
  `dmgMultiplier3` float DEFAULT NULL,
  `totemCategory1` int(9) unsigned DEFAULT NULL,
  `totemCategory2` int(9) unsigned DEFAULT NULL,
  `areaId` int(9) unsigned DEFAULT NULL,
  `schoolMask` int(9) unsigned DEFAULT NULL,
  `serverSide` tinyint(1) NOT NULL DEFAULT '0',
  `customAttributesFlags` int(11) unsigned DEFAULT NULL,
  `comment` text CHARACTER SET latin1,
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Use this table to override values from spell_template table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spell_threat`
--

DROP TABLE IF EXISTS `spell_threat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_threat` (
  `entry` int(10) unsigned NOT NULL,
  `flatMod` int(11) DEFAULT NULL,
  `pctMod` float NOT NULL DEFAULT '1' COMMENT 'threat multiplier for damage/healing',
  PRIMARY KEY (`entry`),
  CONSTRAINT `spell_threat_ibfk_2` FOREIGN KEY (`entry`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trainer`
--

DROP TABLE IF EXISTS `trainer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trainer` (
  `Id` int(10) unsigned NOT NULL DEFAULT '0',
  `Type` tinyint(2) unsigned NOT NULL DEFAULT '2',
  `Requirement` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Greeting` text,
  `VerifiedBuild` smallint(5) DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trainer_locale`
--

DROP TABLE IF EXISTS `trainer_locale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trainer_locale` (
  `Id` int(10) unsigned NOT NULL DEFAULT '0',
  `locale` varchar(4) NOT NULL,
  `Greeting_lang` text,
  `VerifiedBuild` smallint(5) DEFAULT '0',
  PRIMARY KEY (`Id`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trainer_spell`
--

DROP TABLE IF EXISTS `trainer_spell`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trainer_spell` (
  `TrainerId` int(10) unsigned NOT NULL DEFAULT '0',
  `SpellId` int(10) unsigned NOT NULL,
  `MoneyCost` int(10) unsigned NOT NULL DEFAULT '0',
  `ReqSkillLine` int(10) unsigned NOT NULL DEFAULT '0',
  `ReqSkillRank` int(10) unsigned NOT NULL DEFAULT '0',
  `ReqAbility1` int(10) unsigned NOT NULL DEFAULT '0',
  `ReqAbility2` int(10) unsigned NOT NULL DEFAULT '0',
  `ReqAbility3` int(10) unsigned NOT NULL DEFAULT '0',
  `ReqLevel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_min` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `patch_max` tinyint(3) unsigned NOT NULL DEFAULT '10',
  `VerifiedBuild` smallint(5) DEFAULT '0',
  PRIMARY KEY (`TrainerId`,`SpellId`),
  KEY `trainer_spell_ibfk_1` (`SpellId`),
  CONSTRAINT `trainer_spell_ibfk_1` FOREIGN KEY (`SpellId`) REFERENCES `spell_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transport_events`
--

DROP TABLE IF EXISTS `transport_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transport_events` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `waypoint_id` int(11) unsigned NOT NULL DEFAULT '0',
  `event_id` int(11) unsigned NOT NULL DEFAULT '0',
  KEY `entry` (`entry`),
  CONSTRAINT `transport_events_ibfk_2` FOREIGN KEY (`entry`) REFERENCES `transports` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transports`
--

DROP TABLE IF EXISTS `transports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transports` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `name` text,
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trinity_string`
--

DROP TABLE IF EXISTS `trinity_string`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trinity_string` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `content_default` text CHARACTER SET latin1 NOT NULL,
  `content_loc1` text CHARACTER SET latin1,
  `content_loc2` text CHARACTER SET latin1,
  `content_loc3` text CHARACTER SET latin1,
  `content_loc4` text CHARACTER SET latin1,
  `content_loc5` text CHARACTER SET latin1,
  `content_loc6` text CHARACTER SET latin1,
  `content_loc7` text CHARACTER SET latin1,
  `content_loc8` text CHARACTER SET latin1,
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `updates`
--

DROP TABLE IF EXISTS `updates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `updates` (
  `name` varchar(200) NOT NULL COMMENT 'filename with extension of the update.',
  `hash` char(40) DEFAULT '' COMMENT 'sha1 hash of the sql file.',
  `state` enum('RELEASED','ARCHIVED') NOT NULL DEFAULT 'RELEASED' COMMENT 'defines if an update is released or archived.',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'timestamp when the query was applied.',
  `speed` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'time the query takes to apply in ms.',
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='List of all applied updates in this database.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `updates_include`
--

DROP TABLE IF EXISTS `updates_include`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `updates_include` (
  `path` varchar(200) NOT NULL COMMENT 'directory to include. $ means relative to the source directory.',
  `state` enum('RELEASED','ARCHIVED') NOT NULL DEFAULT 'RELEASED' COMMENT 'defines if the directory contains released or archived updates.',
  PRIMARY KEY (`path`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='List of directories where we want to include sql updates.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uptime`
--

DROP TABLE IF EXISTS `uptime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uptime` (
  `starttime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `startstring` varchar(64) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `uptime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `maxplayers` smallint(5) unsigned NOT NULL DEFAULT '1',
  `revision` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT 'Trinitycore',
  PRIMARY KEY (`starttime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `version`
--

DROP TABLE IF EXISTS `version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `version` (
  `core_version` varchar(120) CHARACTER SET latin1 DEFAULT NULL COMMENT 'Core revision dumped at startup.',
  `core_revision` varchar(120) CHARACTER SET latin1 DEFAULT NULL,
  `db_version` varchar(120) CHARACTER SET latin1 DEFAULT NULL COMMENT 'Version of world DB.',
  `cache_id` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `war_effort`
--

DROP TABLE IF EXISTS `war_effort`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `war_effort` (
  `quest_id` mediumint(8) unsigned NOT NULL COMMENT 'Quest ID, one row each',
  `count` int(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Counter of completed quests',
  PRIMARY KEY (`quest_id`),
  CONSTRAINT `war_effort_ibfk_1` FOREIGN KEY (`quest_id`) REFERENCES `quest_template` (`entry`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `warden_data_result`
--

DROP TABLE IF EXISTS `warden_data_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `warden_data_result` (
  `id` int(4) NOT NULL,
  `check` int(3) DEFAULT NULL,
  `data` tinytext CHARACTER SET latin1,
  `str` tinytext CHARACTER SET latin1,
  `address` int(8) DEFAULT NULL,
  `length` int(2) DEFAULT NULL,
  `result` tinytext CHARACTER SET latin1,
  `action` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `comment` text CHARACTER SET latin1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `waypoint_data`
--

DROP TABLE IF EXISTS `waypoint_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `waypoint_data` (
  `id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'path id',
  `point` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `position_x` float NOT NULL DEFAULT '0',
  `position_y` float NOT NULL DEFAULT '0',
  `position_z` float NOT NULL DEFAULT '0',
  `orientation` float NOT NULL DEFAULT '0',
  `delay` int(10) unsigned NOT NULL DEFAULT '0',
  `move_type` int(11) NOT NULL DEFAULT '0',
  `action` int(11) unsigned DEFAULT NULL,
  `action_chance` tinyint(3) unsigned NOT NULL DEFAULT '100',
  `wpguid` int(11) NOT NULL DEFAULT '0',
  `comment` text CHARACTER SET latin1,
  UNIQUE KEY `id` (`id`,`point`),
  KEY `action` (`action`),
  CONSTRAINT `waypoint_data_ibfk_2` FOREIGN KEY (`action`) REFERENCES `waypoint_scripts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `waypoint_info`
--

DROP TABLE IF EXISTS `waypoint_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `waypoint_info` (
  `id` int(10) unsigned NOT NULL,
  `pathType` smallint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'see enum PathType',
  `pathDirection` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'see enum PathDirection',
  PRIMARY KEY (`id`),
  CONSTRAINT `waypoint_info_ibfk_1` FOREIGN KEY (`id`) REFERENCES `waypoint_data` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `waypoint_scripts`
--

DROP TABLE IF EXISTS `waypoint_scripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `waypoint_scripts` (
  `id` int(11) unsigned NOT NULL DEFAULT '0',
  `delay` int(11) unsigned NOT NULL DEFAULT '0',
  `command` int(11) unsigned NOT NULL DEFAULT '0',
  `datalong` int(11) unsigned NOT NULL DEFAULT '0',
  `datalong2` int(11) unsigned NOT NULL DEFAULT '0',
  `dataint` int(11) unsigned NOT NULL DEFAULT '0',
  `x` float NOT NULL DEFAULT '0',
  `y` float NOT NULL DEFAULT '0',
  `z` float NOT NULL DEFAULT '0',
  `o` float NOT NULL DEFAULT '0',
  `guid` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`guid`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50235 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `waypoints`
--

DROP TABLE IF EXISTS `waypoints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `waypoints` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `pointid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `position_x` float NOT NULL DEFAULT '0',
  `position_y` float NOT NULL DEFAULT '0',
  `position_z` float NOT NULL DEFAULT '0',
  `point_comment` text CHARACTER SET latin1,
  PRIMARY KEY (`entry`,`pointid`),
  UNIQUE KEY `entry-point_unique` (`entry`,`pointid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-12-13 20:58:30

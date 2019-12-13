--
-- Migrate locales_creature to creature_template_locale

DROP TABLE IF EXISTS `locales_creature`;

DROP TABLE IF EXISTS `creature_template_locale`;
CREATE TABLE `creature_template_locale` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `locale` varchar(4) NOT NULL,
  `Name` text,
  `Title` text,
  `VerifiedBuild` smallint(5) DEFAULT '0',
  PRIMARY KEY (`entry`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Migrate locales_gameobject to gameobject_template_locale

DROP TABLE IF EXISTS `locales_gameobject`;

DROP TABLE IF EXISTS `gameobject_template_locale`;
CREATE TABLE `gameobject_template_locale` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `locale` varchar(4) NOT NULL,
  `name` text,
  `castBarCaption` text,
  `VerifiedBuild` smallint(5) DEFAULT '0',
  PRIMARY KEY (`entry`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Migrate locales_item to item_template_locale

DROP TABLE IF EXISTS `locales_item`;

DROP TABLE IF EXISTS `item_template_locale`;
CREATE TABLE `item_template_locale` (
  `ID` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `locale` varchar(4) NOT NULL,
  `Name` text,
  `Description` text,
  `VerifiedBuild` smallint(5) DEFAULT '0',
  PRIMARY KEY (`ID`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
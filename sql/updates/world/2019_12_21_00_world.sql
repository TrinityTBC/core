DROP TABLE IF EXISTS `gossip_menu_option_generic`;
DROP TABLE IF EXISTS `locales_gossip_menu_option`;

ALTER TABLE gossip_menu_option drop FOREIGN KEY pk_action_menuId;
ALTER TABLE gossip_menu_option drop FOREIGN KEY pk_broadcast1;
ALTER TABLE gossip_menu_option drop FOREIGN KEY pk_broadcast2;
ALTER TABLE gossip_menu_option drop FOREIGN KEY pk_menuId;
ALTER TABLE gossip_menu_option drop FOREIGN KEY pk_poi;

ALTER TABLE gossip_menu_option DROP INDEX menu_id;
ALTER TABLE gossip_menu_option DROP INDEX action_menu_id;
ALTER TABLE gossip_menu_option DROP INDEX pk_broadcast1;
ALTER TABLE gossip_menu_option DROP INDEX pk_broadcast2;
ALTER TABLE gossip_menu_option DROP INDEX pk_poi;

ALTER TABLE gossip_menu_option ENGINE = MyISAM;
    
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 0, 0, 'GOSSIP_OPTION_QUESTGIVER', 0, 2, 2, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 1, 1, 'I want to browse your goods', 3370, 3, 128, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 2, 2, 'I want to travel fast', 0, 4, 8192, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 3, 3, 'Train me!', 3266, 5, 16, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 4, 4, 'Bring me back to life', 0, 6, 16384, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 5, 4, 'Bring me back to life', 0, 7, 32768, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 6, 5, 'Make this inn my home', 2822, 8, 65536, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 7, 6, 'Show me my bank', 0, 9, 131072, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 8, 7, 'How do I form a guild?', 3413, 10, 262144, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 9, 8, 'I want to create a guild crest', 3415, 11, 524288, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 10, 9, 'I want to join the Battle Ground', 0, 12, 1048576, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 11, 6, 'Auction!', 0, 13, 2097152, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 12, 0, 'I\'d like to stable my pet here', 8912, 14, 4194304, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 13, 1, 'I want to browse your goods', 3370, 15, 4096, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 14, 2, 'I wish to unlearn my talents', 8271, 16, 16, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 15, 2, 'I wish to unlearn my pet\'s skills', 0, 17, 16, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 16, 0, 'GOSSIP_OPTION_OUTDOORPVP', 0, 18, 536870912, 0, 0, 0, 0, '', 0);
INSERT INTO `gossip_menu_option`(`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`) VALUES (0, 17, 0, 'Trick or Treat!', 10693, 19, 65536, 0, 0, 0, 0, '', 0);

DROP TABLE IF EXISTS `locales_page_text`;
DROP TABLE IF EXISTS `page_text_locale`;
CREATE TABLE `page_text_locale` (
  `ID` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `locale` varchar(4) NOT NULL,
  `Text` text,
  `VerifiedBuild` smallint(5) DEFAULT '0',
  PRIMARY KEY (`ID`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
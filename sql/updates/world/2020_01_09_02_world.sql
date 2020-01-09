--
DELETE FROM `gossip_menu_option` WHERE `MenuID`=435 AND `OptionID`=2;
DELETE FROM `gossip_menu_option` WHERE `OptionBroadcastTextID` IN (31340,45376);
DELETE FROM `gossip_menu_option` WHERE `OptionText`='Lexicon of Power';


UPDATE `gossip_menu_option` SET `OptionBroadcastTextID`=2870 WHERE `OptionText`='The guild master';
UPDATE `gossip_menu_option` SET `OptionBroadcastTextID`=5316 WHERE `OptionText`='The auction house';
UPDATE `gossip_menu_option` SET `OptionBroadcastTextID`=9749 WHERE `OptionText`='The officers\' lounge';
UPDATE `gossip_menu_option` SET `OptionBroadcastTextID`=10359 WHERE `OptionText`='The battlemaster';

UPDATE `gossip_menu_option` SET `OptionBroadcastTextID`=4895 WHERE `OptionText`='The mailbox';
UPDATE `gossip_menu_option` SET `OptionBroadcastTextID`=7253 WHERE `OptionText`='The weapon master';
UPDATE `gossip_menu_option` SET `OptionBroadcastTextID`=5518 WHERE `OptionText`='The zeppelin master';

--
-- Migrate locales_quest to quest_template_locale

DROP TABLE IF EXISTS `locales_quest`;

DROP TABLE IF EXISTS `quest_template_locale`;
CREATE TABLE `quest_template_locale`  (
  `ID` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `locale` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `Title` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `Details` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `Objectives` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `EndText` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `CompletedText` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `ObjectiveText1` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `ObjectiveText2` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `ObjectiveText3` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `ObjectiveText4` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `VerifiedBuild` smallint(5) NULL DEFAULT 0,
  PRIMARY KEY (`ID`, `locale`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `quest_offer_reward_locale`;
CREATE TABLE `quest_offer_reward_locale`  (
  `ID` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `locale` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `RewardText` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `VerifiedBuild` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`, `locale`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `quest_request_items_locale`;
CREATE TABLE `quest_request_items_locale`  (
  `ID` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `locale` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `CompletionText` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `VerifiedBuild` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`, `locale`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

ALTER TABLE gossip_text drop FOREIGN KEY broadcast0;
ALTER TABLE gossip_text drop FOREIGN KEY broadcast1;
ALTER TABLE gossip_text drop FOREIGN KEY broadcast2;
ALTER TABLE gossip_text drop FOREIGN KEY broadcast3;
ALTER TABLE gossip_text drop FOREIGN KEY broadcast4;
ALTER TABLE gossip_text drop FOREIGN KEY broadcast5;
ALTER TABLE gossip_text drop FOREIGN KEY broadcast6;
ALTER TABLE gossip_text drop FOREIGN KEY broadcast7;

ALTER TABLE gossip_text DROP INDEX broadcast0;
ALTER TABLE gossip_text DROP INDEX broadcast1;
ALTER TABLE gossip_text DROP INDEX broadcast2;
ALTER TABLE gossip_text DROP INDEX broadcast3;
ALTER TABLE gossip_text DROP INDEX broadcast4;
ALTER TABLE gossip_text DROP INDEX broadcast5;
ALTER TABLE gossip_text DROP INDEX broadcast6;
ALTER TABLE gossip_text DROP INDEX broadcast7;

ALTER TABLE gossip_menu drop FOREIGN KEY gossip_menu_ibfk_1;
ALTER TABLE locales_gossip_text drop FOREIGN KEY locales_gossip_text_ibfk_1;

ALTER TABLE gossip_text ENGINE = MyISAM;
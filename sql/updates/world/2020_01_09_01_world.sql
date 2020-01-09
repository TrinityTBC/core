--
ALTER TABLE `trinity_string` ENGINE = MyISAM;
ALTER TABLE `trinity_string` MODIFY `content_default` text CHARACTER SET utf8;
ALTER TABLE `trinity_string` MODIFY `content_loc1` text CHARACTER SET utf8;
ALTER TABLE `trinity_string` MODIFY `content_loc2` text CHARACTER SET utf8;
ALTER TABLE `trinity_string` MODIFY `content_loc3` text CHARACTER SET utf8;
ALTER TABLE `trinity_string` MODIFY `content_loc4` text CHARACTER SET utf8;
ALTER TABLE `trinity_string` MODIFY `content_loc5` text CHARACTER SET utf8;
ALTER TABLE `trinity_string` MODIFY `content_loc6` text CHARACTER SET utf8;
ALTER TABLE `trinity_string` MODIFY `content_loc7` text CHARACTER SET utf8;
ALTER TABLE `trinity_string` MODIFY `content_loc8` text CHARACTER SET utf8;
UPDATE `trinity_string` SET `content_loc4`='你好！准备好接受一些训练了吗？', `content_loc5`='你好！ 準備好接受一些訓練了嗎？' WHERE `entry`=51;

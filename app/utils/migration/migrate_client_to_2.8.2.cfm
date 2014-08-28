ALTER TABLE `dp_hcs`.`hcs_files` 
ADD COLUMN `anti_virus_check` TINYINT UNSIGNED NULL AFTER `publication_scope_id`,
ADD COLUMN `anti_virus_check_result` VARCHAR(255) NULL AFTER `anti_virus_check`;


CREATE TABLE `hcs_virus_logs` (
  `virus_log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `file_id` int(11) NULL,
  `file_type_id` int(10) unsigned NULL,
  `file_name` varchar(255) COLLATE utf8_unicode_ci NULL,
  `anti_virus_result` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`virus_log_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

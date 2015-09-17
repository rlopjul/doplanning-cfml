INSERT INTO `dp_hcs`.`hcs_tables_fields_types` (`field_type_id`, `field_type_group`, `input_type`, `name`, `max_length`, `mysql_type`, `cf_sql_type`, `enabled`, `position`) VALUES ('18', 'file', 'file', 'Archivo adjunto', '', 'VARCHAR(255)', 'cf_sql_integer', '1', '18');

ALTER TABLE `dp_hcs`.`hcs_virus_logs`
CHANGE COLUMN `user_id` `user_id` INT(11) NULL ;

ALTER TABLE `dp_hcs`.`hcs_files`
DROP FOREIGN KEY `hcs_files_ibfk_1`;
ALTER TABLE `dp_hcs`.`hcs_files`
CHANGE COLUMN `user_in_charge` `user_in_charge` INT(11) NULL ;
ALTER TABLE `dp_hcs`.`hcs_files`
ADD CONSTRAINT `hcs_files_ibfk_1`
  FOREIGN KEY (`user_in_charge`)
  REFERENCES `dp_hcs`.`hcs_users` (`id`);



ALTER TABLE `dp_hcs`.`hcs_lists`
ADD COLUMN `last_update_type` VARCHAR(45) NULL AFTER `last_update_user_id`;

ALTER TABLE `dp_hcs`.`hcs_forms`
ADD COLUMN `last_update_type` VARCHAR(45) NULL AFTER `last_update_user_id`;

ALTER TABLE `dp_hcs`.`hcs_typologies`
ADD COLUMN `last_update_type` VARCHAR(45) NULL AFTER `last_update_user_id`;

ALTER TABLE `dp_hcs`.`hcs_users_typologies`
ADD COLUMN `last_update_type` VARCHAR(45) NULL AFTER `last_update_user_id`;

ALTER TABLE `dp_hcs`.`hcs_users`
ADD COLUMN `last_update_date` DATETIME NULL AFTER `typology_row_id`,
ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `last_update_date`,
ADD COLUMN `last_update_type` VARCHAR(45) NULL AFTER `last_update_user_id`,
ADD INDEX `hcs_users_ibfk_3_idx` (`last_update_user_id` ASC);
ALTER TABLE `dp_hcs`.`hcs_users`
ADD CONSTRAINT `hcs_users_ibfk_3`
  FOREIGN KEY (`last_update_user_id`)
  REFERENCES `dp_hcs`.`hcs_users` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `dp_hcs`.`hcs_users`
ADD COLUMN `start_page` VARCHAR(45) NULL AFTER `information`;


ALTER TABLE `dp_hcs`.`hcs_users`
ADD COLUMN `start_page_locked` TINYINT(1) NOT NULL DEFAULT 0 AFTER `start_page`;


ALTER TABLE `dp_web4bio7`.`web4bio7_users`
CHANGE COLUMN `space_used` `space_used` BIGINT(20) NULL DEFAULT '0' ;




CREATE TABLE `hcs_mailings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `user_in_charge` int(11) NOT NULL,
  `area_id` int(11) NOT NULL,
  `creation_date` datetime NOT NULL,
  `parent_id` int(11) NOT NULL,
  `parent_kind` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attached_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attached_file_id` int(11) DEFAULT NULL,
  `attached_image_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attached_image_id` int(11) DEFAULT NULL,
  `status` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `link` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_target` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_update_date` datetime DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT '0',
  `structure_available` tinyint(1) NOT NULL DEFAULT '0',
  `general` tinyint(1) NOT NULL DEFAULT '0',
  `publication_scope_id` int(10) unsigned DEFAULT NULL,
  `publication_date` datetime DEFAULT NULL,
  `publication_validated` tinyint(1) DEFAULT NULL,
  `publication_validated_user` int(11) DEFAULT NULL,
  `publication_validated_date` datetime DEFAULT NULL,
  `last_update_user_id` int(11) DEFAULT NULL,
  `last_update_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `email_addresses` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `template_id` int(11) DEFAULT NULL,
  `head_content` text COLLATE utf8_unicode_ci NOT NULL,
  `foot_content` text COLLATE utf8_unicode_ci NOT NULL,
  `content_styles` varchar(1000) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_hcs_mailings_1` (`user_in_charge`),
  KEY `FK_hcs_mailings_2` (`area_id`),
  KEY `FK_hcs_mailings_3` (`attached_file_id`),
  KEY `FK_hcs_mailings_4` (`attached_image_id`),
  KEY `FK_hcs_mailings_5` (`publication_scope_id`),
  KEY `FK_hcs_mailings_7_idx` (`last_update_user_id`),
  KEY `FK_hcs_mailings_7_idx1` (`template_id`),
  CONSTRAINT `FK_hcs_mailings_1` FOREIGN KEY (`user_in_charge`) REFERENCES `hcs_users` (`id`),
  CONSTRAINT `FK_hcs_mailings_2` FOREIGN KEY (`area_id`) REFERENCES `hcs_areas` (`id`),
  CONSTRAINT `FK_hcs_mailings_3` FOREIGN KEY (`attached_file_id`) REFERENCES `hcs_files` (`id`),
  CONSTRAINT `FK_hcs_mailings_4` FOREIGN KEY (`attached_image_id`) REFERENCES `hcs_files` (`id`),
  CONSTRAINT `FK_hcs_mailings_5` FOREIGN KEY (`publication_scope_id`) REFERENCES `hcs_scopes` (`scope_id`),
  CONSTRAINT `FK_hcs_mailings_6` FOREIGN KEY (`last_update_user_id`) REFERENCES `hcs_users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `FK_hcs_mailings_7` FOREIGN KEY (`template_id`) REFERENCES `hcs_mailings_templates` (`template_id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;





ALTER TABLE `dp_hcs`.`hcs_areas`
ADD COLUMN `item_type_17_enabled` TINYINT(4) NOT NULL DEFAULT 0 AFTER `item_type_16_enabled`;


CREATE TABLE `hcs_mailings_templates` (
  `template_id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET latin1 NOT NULL,
  `head_content` text CHARACTER SET latin1 NOT NULL,
  `foot_content` text CHARACTER SET latin1 NOT NULL,
  `content_styles` varchar(1000) COLLATE utf8_unicode_ci NOT NULL,
  `creation_user_id` int(11) DEFAULT NULL,
  `last_update_user_id` int(11) DEFAULT NULL,
  `creation_date` datetime NOT NULL,
  `last_update_date` datetime DEFAULT NULL,
  `position` int(11) NOT NULL,
  PRIMARY KEY (`template_id`),
  KEY `FK_hcs_mailings_1_idx` (`creation_user_id`),
  KEY `FK_hcs_mailings_2_idx` (`last_update_user_id`),
  CONSTRAINT `FK_hcs_mailings_templates_1` FOREIGN KEY (`creation_user_id`) REFERENCES `hcs_users` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `FK_hcs_mailings_templates_2` FOREIGN KEY (`last_update_user_id`) REFERENCES `hcs_users` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

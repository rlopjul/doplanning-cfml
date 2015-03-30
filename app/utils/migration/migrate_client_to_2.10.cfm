
CREATE TABLE `hcs_items_deleted` (
  `item_id` int(11) NOT NULL,
  `item_type_id` int(10) unsigned NOT NULL,
  `delete_area_id` int(11) NOT NULL,
  `delete_user_id` int(11) NOT NULL,
  `delete_date` datetime NOT NULL,
  `in_bin` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `final_delete_date` datetime DEFAULT NULL,
  `final_delete_status` varchar(45) DEFAULT NULL,
  `final_delete_error_message` text,
  `final_delete_error_detail` text,
  PRIMARY KEY (`item_id`,`item_type_id`),
  KEY `FK_hcs_items_deleted_1` (`delete_area_id`),
  KEY `FK_hcs_items_deleted_2_idx` (`delete_user_id`),
  CONSTRAINT `FK_hcs_items_deleted_1` FOREIGN KEY (`delete_area_id`) REFERENCES `hcs_areas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_hcs_items_deleted_2` FOREIGN KEY (`delete_user_id`) REFERENCES `hcs_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



ALTER TABLE `doplanning_app`.`app_clients` 
ADD COLUMN `bin_enabled` TINYINT(1) NULL DEFAULT 0 AFTER `tasks_reminder_days`,
ADD COLUMN `bin_days` INT(10) NULL DEFAULT '30' AFTER `bin_enabled`;




ALTER TABLE `dp_hcs`.`hcs_users` 
ADD COLUMN `delete` TINYINT(1) NOT NULL DEFAULT 0 AFTER `information`,
ADD COLUMN `delete_date` DATETIME NULL AFTER `delete`,
ADD COLUMN `delete_user_id` INT(11) NULL AFTER `delete_date`,
ADD COLUMN `final_delete_date` DATETIME NULL AFTER `delete_user_id`,
ADD COLUMN `final_delete_status` VARCHAR(45) NULL AFTER `final_delete_date`,
ADD COLUMN `final_delete_error_detail` TEXT NULL AFTER `final_delete_status`;



UPDATE `dp_ptsgranada`.`ptsgranada_tables_fields_types` SET `mysql_type`='TEXT', `cf_sql_type`='cf_sql_longvarchar' WHERE `field_type_id`='16';
UPDATE `dp_ptsgranada`.`ptsgranada_tables_fields_types` SET `mysql_type`='TEXT', `cf_sql_type`='cf_sql_longvarchar' WHERE `field_type_id`='15';



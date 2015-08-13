
ALTER TABLE `hcs_items_deleted` 
DROP PRIMARY KEY,
ADD PRIMARY KEY (`item_id`, `item_type_id`, `delete_date`);

CREATE TABLE `hcs_files_downloads` (
  `file_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `download_date` datetime NOT NULL,
  `area_id` int(11) DEFAULT NULL,
  `file_size` int(11) NOT NULL,
  PRIMARY KEY (`file_id`,`download_date`),
  KEY `FK_hcs_files_downloads_2_idx` (`user_id`),
  KEY `FK_hcs_files_downloads_3_idx` (`area_id`),
  CONSTRAINT `FK_hcs_files_downloads_1` FOREIGN KEY (`file_id`) REFERENCES `hcs_files` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_hcs_files_downloads_2` FOREIGN KEY (`user_id`) REFERENCES `hcs_users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `FK_hcs_files_downloads_3` FOREIGN KEY (`area_id`) REFERENCES `hcs_areas` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `dp_ceseand`.`ceseand_files` 
ADD COLUMN `item_id` INT(11) NULL DEFAULT NULL AFTER `file_public_id`,
ADD COLUMN `item_type_id` INT(11) NULL DEFAULT NULL AFTER `item_id`;



<!---
/* Nuevo campo para valor relacionado (POR AHORA NO SE VA A USAR) */
ALTER TABLE `dp_hcs`.`hcs_typologies_fields` 
ADD COLUMN `related_field_id` INT(10) UNSIGNED NULL AFTER `mask_type_id`;

/*Nuevos tipos de campos (AL FINAL NO SE USA ESTE TIPO PORQUE NO ES NECESARIO)*/
INSERT INTO `dp_hcs`.`hcs_tables_fields_types` (`field_type_id`, `field_type_group`, `input_type`, `name`, `max_length`, `mysql_type`, `cf_sql_type`, `enabled`, `position`) VALUES ('18', 'doplanning_item', 'hidden', 'Elemento de DoPlanning de un área determinada', '11', 'INT(11)', 'cf_sql_integer', '1', '18');
--->

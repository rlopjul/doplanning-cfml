INSERT INTO `dp_hcs`.`hcs_tables_fields_types` (`field_type_id`, `field_type_group`, `input_type`, `name`, `max_length`, `mysql_type`, `cf_sql_type`, `enabled`, `position`) VALUES ('14', 'url', 'url', 'URL para petición', '2000', 'VARCHAR(2000)', 'cf_sql_varchar', '1', '14');



UPDATE `dp_hcs`.`hcs_tables_fields_types` SET `name`='Lista de opciones con selección simple a partir de área' WHERE `field_type_id`='9';
UPDATE `dp_hcs`.`hcs_tables_fields_types` SET `name`='Lista de opciones con selección múltiple a partir de área' WHERE `field_type_id`='10';
INSERT INTO `dp_hcs`.`hcs_tables_fields_types` (`field_type_id`, `field_type_group`, `input_type`, `name`, `max_length`, `mysql_type`, `cf_sql_type`, `enabled`, `position`) VALUES ('15', 'list', 'select', 'Lista de opciones con selección simple', '255', 'VARCHAR(255)', 'cf_sql_varchar', '1', '15');
INSERT INTO `dp_hcs`.`hcs_tables_fields_types` (`field_type_id`, `field_type_group`, `input_type`, `name`, `max_length`, `mysql_type`, `cf_sql_type`, `enabled`, `position`) VALUES ('16', 'list', 'select', 'Lista de opciones con selección múltiple', '255', 'VARCHAR(255)', 'cf_sql_varchar', '1', '16');


UPDATE `dp_hcs`.`hcs_tables_fields_types` SET `position`='10' WHERE `field_type_id`='15';
UPDATE `dp_hcs`.`hcs_tables_fields_types` SET `position`='11' WHERE `field_type_id`='16';
UPDATE `dp_hcs`.`hcs_tables_fields_types` SET `position`='12' WHERE `field_type_id`='9';
UPDATE `dp_hcs`.`hcs_tables_fields_types` SET `position`='13' WHERE `field_type_id`='10';
UPDATE `dp_hcs`.`hcs_tables_fields_types` SET `position`='14' WHERE `field_type_id`='12';
UPDATE `dp_hcs`.`hcs_tables_fields_types` SET `position`='15' WHERE `field_type_id`='13';
/*UPDATE `dp_hcs`.`hcs_tables_fields_types` SET `position`='16' WHERE `field_type_id`='14';*/



ALTER TABLE `dp_hcs`.`hcs_lists_fields` 
ADD COLUMN `list_values` TEXT NULL DEFAULT NULL AFTER `mask_type_id`;

ALTER TABLE `dp_hcs`.`hcs_forms_fields` 
ADD COLUMN `list_values` TEXT NULL DEFAULT NULL AFTER `mask_type_id`;

ALTER TABLE `dp_hcs`.`hcs_typologies_fields` 
ADD COLUMN `list_values` TEXT NULL DEFAULT NULL AFTER `mask_type_id`;


ALTER TABLE `dp_hcs`.`hcs_areas` 
ADD COLUMN `item_type_1_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `version_tree`,
ADD COLUMN `item_type_2_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_1_enabled`,
ADD COLUMN `item_type_3_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_2_enabled`,
ADD COLUMN `item_type_4_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_3_enabled`,
ADD COLUMN `item_type_5_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_4_enabled`,
ADD COLUMN `item_type_6_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_5_enabled`,
ADD COLUMN `item_type_7_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_6_enabled`,
ADD COLUMN `item_type_8_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_7_enabled`,
ADD COLUMN `item_type_9_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_8_enabled`,
ADD COLUMN `item_type_10_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_9_enabled`,
ADD COLUMN `item_type_11_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_10_enabled`,
ADD COLUMN `item_type_12_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_11_enabled`,
ADD COLUMN `item_type_13_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_12_enabled`,
ADD COLUMN `item_type_14_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_13_enabled`,
ADD COLUMN `item_type_15_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_14_enabled`,
ADD COLUMN `item_type_20_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_15_enabled`;






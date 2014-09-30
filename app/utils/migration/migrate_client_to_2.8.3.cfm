UPDATE hcs_tables_fields_types
SET field_type_group = 'user',
name = 'Usuario de DoPlanning',
enabled = 1
WHERE field_type_id = 12;


ALTER TABLE `dp_hcs`.`hcs_lists_fields` 
ADD COLUMN `item_type_id` INT(11) UNSIGNED NULL AFTER `field_input_type`;

ALTER TABLE `dp_hcs`.`hcs_typologies_fields` 
ADD COLUMN `item_type_id` INT(11) UNSIGNED NULL AFTER `field_input_type`;

ALTER TABLE `dp_hcs`.`hcs_forms_fields` 
ADD COLUMN `item_type_id` INT(11) UNSIGNED NULL AFTER `field_input_type`;

INSERT INTO `hcs_tables_fields_types` VALUES 
(13,'doplanning_item','hidden','Elemento de DoPlanning',11,'INT(11)','cf_sql_integer',1,13);

ALTER TABLE `dp_hcs`.`hcs_lists_fields` 
ADD COLUMN `mask_type_id` INT(10) UNSIGNED NULL AFTER `item_type_id`;

ALTER TABLE `dp_hcs`.`hcs_forms_fields` 
ADD COLUMN `mask_type_id` INT(10) UNSIGNED NULL AFTER `item_type_id`;

ALTER TABLE `dp_hcs`.`hcs_typologies_fields` 
ADD COLUMN `mask_type_id` INT(10) UNSIGNED NULL AFTER `item_type_id`;


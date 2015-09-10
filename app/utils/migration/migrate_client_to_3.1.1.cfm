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
ADD COLUMN `start_page_type_id` INT(11) NULL AFTER `information`;

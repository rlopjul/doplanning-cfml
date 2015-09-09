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

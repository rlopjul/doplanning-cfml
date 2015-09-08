INSERT INTO `dp_hcs`.`hcs_tables_fields_types` (`field_type_id`, `field_type_group`, `input_type`, `name`, `max_length`, `mysql_type`, `cf_sql_type`, `enabled`, `position`) VALUES ('18', 'file', 'file', 'Archivo adjunto', '', 'VARCHAR(255)', 'cf_sql_varchar', '1', '18');

ALTER TABLE `dp_hcs`.`hcs_virus_logs`
CHANGE COLUMN `user_id` `user_id` INT(11) NULL ;

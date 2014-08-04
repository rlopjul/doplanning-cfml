CREATE TABLE `hcs_webs` (
  `web_id` int(11) NOT NULL,
  `area_id` int(11) DEFAULT NULL,
  `area_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `path` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `path_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `language` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`web_id`),
  UNIQUE KEY `UNIQUE_AREA` (`area_id`),
  UNIQUE KEY `UNIQUE_PATH` (`path`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



ALTER TABLE `dp_hcs`.`hcs_forms_fields` 
ADD COLUMN `field_input_type` VARCHAR(45) NULL AFTER `list_area_id`;

ALTER TABLE `dp_hcs`.`hcs_lists_fields` 
ADD COLUMN `field_input_type` VARCHAR(45) NULL AFTER `list_area_id`;

ALTER TABLE `dp_hcs`.`hcs_typologies_fields` 
ADD COLUMN `field_input_type` VARCHAR(45) NULL AFTER `list_area_id`;

ALTER TABLE `dp_hcs`.`hcs_forms_fields` 
CHANGE COLUMN `label` `label` VARCHAR(500) NOT NULL ;

ALTER TABLE `dp_hcs`.`hcs_lists_fields` 
CHANGE COLUMN `label` `label` VARCHAR(500) NOT NULL ;

<!---A partir de aquí no está hecho en el HCS--->
<!---Nuevas modificaciones para añadir nuevos campos a eventos y publicaciones--->
ALTER TABLE `dp_hcs`.`hcs_events` 
ADD COLUMN `price` DECIMAL(12,2) UNSIGNED NULL AFTER `publication_validated_date`;


ALTER TABLE `dp_hcs`.`hcs_pubmeds` 
ADD COLUMN `price` DECIMAL(12,2) UNSIGNED NULL AFTER `publication_validated_date`;


<!---Nuevas modificaciones campos de usuarios--->
ALTER TABLE `dp_hcs`.`hcs_users` 
ADD COLUMN `linkedin_url` VARCHAR(1000) NULL AFTER `mobile_phone_ccode`,
ADD COLUMN `twitter_url` VARCHAR(1000) NULL AFTER `linkedin_url`;

<!---Campos versiones de archivos--->

ALTER TABLE `dp_hcs`.`hcs_files_versions` 
ADD COLUMN `revision_result_reason` TEXT NULL AFTER `revision_result`,
ADD COLUMN `approval_result_reason` TEXT NULL AFTER `approval_date`;

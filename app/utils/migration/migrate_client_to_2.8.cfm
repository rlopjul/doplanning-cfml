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
<!---Modificaciones de la base de datos--->
<cftransaction>

	 
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE `dp_#client_abb#`.`#client_abb#_webs` (
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

	</cfquery>
	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_forms_fields` 
			ADD COLUMN `field_input_type` VARCHAR(45) NULL AFTER `list_area_id`;
	</cfquery>

	<!---
	Esto era necesario para el DP de ngsbio porque por algún motivo no tenía este campo en la tabla
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_lists_fields` ADD COLUMN `list_area_id` INTEGER AFTER `default_value`,
		 	ADD CONSTRAINT `FK_#client_abb#_lists_fields_3` FOREIGN KEY `FK_#client_abb#_lists_fields_3` (`list_area_id`)
			REFERENCES `#client_abb#_areas` (`id`)
			ON DELETE SET NULL
			ON UPDATE RESTRICT;
	</cfquery>--->			

	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_lists_fields` 
			ADD COLUMN `field_input_type` VARCHAR(45) NULL AFTER `list_area_id`;
	</cfquery>

	<!---
	Esto era necesario para el DP de ngsbio porque por algún motivo no tenía este campo en la tabla
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_typologies_fields` ADD COLUMN `list_area_id` INTEGER AFTER `default_value`,
		 	ADD CONSTRAINT `FK_#client_abb#_typologies_fields_3` FOREIGN KEY `FK_#client_abb#_typologies_fields_3` (`list_area_id`)
			REFERENCES `#client_abb#_areas` (`id`)
			ON DELETE SET NULL
			ON UPDATE RESTRICT;
	</cfquery>--->	

	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_typologies_fields` 
			ADD COLUMN `field_input_type` VARCHAR(45) NULL AFTER `list_area_id`;
	</cfquery>		

	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_forms_fields` 
			CHANGE COLUMN `label` `label` VARCHAR(500) NOT NULL ;
	</cfquery>		

	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_lists_fields` 
			CHANGE COLUMN `label` `label` VARCHAR(500) NOT NULL ;
	</cfquery>


	<!---Modificaciones para añadir nuevos campos a eventos y publicaciones--->
	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_events` 
		ADD COLUMN `price` DECIMAL(12,2) UNSIGNED NULL AFTER `publication_validated_date`;
	</cfquery>
	
	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_pubmeds` 
		ADD COLUMN `price` DECIMAL(12,2) UNSIGNED NULL AFTER `publication_validated_date`;
	</cfquery>


	<!---Modificaciones nuevos campos de usuarios--->
	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_users` 
		ADD COLUMN `linkedin_url` VARCHAR(1000) NULL AFTER `mobile_phone_ccode`,
		ADD COLUMN `twitter_url` VARCHAR(1000) NULL AFTER `linkedin_url`;
	</cfquery>

	<!---Modificaciones nuevos campos versiones de archivos--->
	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_files_versions` 
		ADD COLUMN `revision_result_reason` TEXT NULL AFTER `revision_result`,
		ADD COLUMN `approval_result_reason` TEXT NULL AFTER `approval_date`;
	</cfquery>

		
</cftransaction>

	


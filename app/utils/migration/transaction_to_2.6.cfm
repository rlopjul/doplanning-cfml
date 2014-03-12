<!---Modificaciones de la base de datos--->
<cftransaction>

	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `dp_#client_abb#`.`#client_abb#_scopes` (
		  `scope_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
		  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
		  `position` int(10) unsigned NOT NULL,
		  PRIMARY KEY (`scope_id`),
		  KEY `UNIQUE` (`name`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>
	
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `dp_#client_abb#`.`#client_abb#_scopes_areas` (
		  `scope_id` int(10) unsigned NOT NULL,
		  `area_id` int(11) NOT NULL,
		  PRIMARY KEY (`scope_id`,`area_id`),
		  KEY `FK_#client_abb#_scopes_areas_2` (`area_id`),
		  CONSTRAINT `FK_#client_abb#_scopes_areas_1` FOREIGN KEY (`scope_id`) REFERENCES `#client_abb#_scopes` (`scope_id`) ON DELETE CASCADE,
		  CONSTRAINT `FK_#client_abb#_scopes_areas_2` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`) ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>		

	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_files` ADD COLUMN `publication_scope_id` INTEGER UNSIGNED DEFAULT NULL AFTER `in_approval`;
	</cfquery>
	
	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_lists` ADD COLUMN `publication_scope_id` INTEGER UNSIGNED DEFAULT NULL AFTER `general`;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_forms` ADD COLUMN `publication_scope_id` INTEGER UNSIGNED DEFAULT NULL AFTER `general`;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_files` ADD CONSTRAINT `FK_#client_abb#_files_5` FOREIGN KEY `FK_#client_abb#_files_5` (`publication_scope_id`)
		    REFERENCES `#client_abb#_scopes` (`scope_id`)
		    ON DELETE RESTRICT
		    ON UPDATE RESTRICT;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_lists` ADD CONSTRAINT `FK_#client_abb#_lists_5` FOREIGN KEY `FK_#client_abb#_lists_5` (`publication_scope_id`)
		    REFERENCES `#client_abb#_scopes` (`scope_id`)
		    ON DELETE RESTRICT
		    ON UPDATE RESTRICT;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_forms` ADD CONSTRAINT `FK_#client_abb#_forms_5` FOREIGN KEY `FK_#client_abb#_forms_5` (`publication_scope_id`)
		    REFERENCES `#client_abb#_scopes` (`scope_id`)
		    ON DELETE RESTRICT
		    ON UPDATE RESTRICT;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_events` ADD COLUMN `publication_date` DATE AFTER `iframe_display_type_id`,
		 ADD COLUMN `publication_validated` BOOLEAN AFTER `publication_date`,
		 ADD COLUMN `publication_validated_user` INTEGER AFTER `publication_validated`,
		 ADD COLUMN `publication_validated_date` DATETIME AFTER `publication_validated_user`;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		 ALTER TABLE `dp_#client_abb#`.`#client_abb#_news` ADD COLUMN `publication_date` DATE AFTER `iframe_display_type_id`,
		 ADD COLUMN `publication_validated` BOOLEAN AFTER `publication_date`,
		 ADD COLUMN `publication_validated_user` INTEGER AFTER `publication_validated`,
		 ADD COLUMN `publication_validated_date` DATETIME AFTER `publication_validated_user`;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		 ALTER TABLE `dp_#client_abb#`.`#client_abb#_entries` ADD COLUMN `publication_date` DATE AFTER `iframe_display_type_id`,
		 ADD COLUMN `publication_validated` BOOLEAN AFTER `publication_date`,
		 ADD COLUMN `publication_validated_user` INTEGER AFTER `publication_validated`,
		 ADD COLUMN `publication_validated_date` DATETIME AFTER `publication_validated_user`;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		 ALTER TABLE `dp_#client_abb#`.`#client_abb#_images` ADD COLUMN `publication_date` DATE AFTER `display_type_id`,
		 ADD COLUMN `publication_validated` BOOLEAN AFTER `publication_date`,
		 ADD COLUMN `publication_validated_user` INTEGER AFTER `publication_validated`,
		 ADD COLUMN `publication_validated_date` DATETIME AFTER `publication_validated_user`;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		 ALTER TABLE `dp_#client_abb#`.`#client_abb#_pubmeds` ADD COLUMN `publication_date` DATE AFTER `display_type_id`,
		 ADD COLUMN `publication_validated` BOOLEAN AFTER `publication_date`,
		 ADD COLUMN `publication_validated_user` INTEGER AFTER `publication_validated`,
		 ADD COLUMN `publication_validated_date` DATETIME AFTER `publication_validated_user`;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		 ALTER TABLE `dp_#client_abb#`.`#client_abb#_lists` ADD COLUMN `publication_date` DATE AFTER `publication_scope_id`,
		 ADD COLUMN `publication_validated` BOOLEAN AFTER `publication_date`,
		 ADD COLUMN `publication_validated_user` INTEGER AFTER `publication_validated`,
		 ADD COLUMN `publication_validated_date` DATETIME AFTER `publication_validated_user`;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		 ALTER TABLE `dp_#client_abb#`.`#client_abb#_lists_views` ADD COLUMN `publication_date` DATE AFTER `update_user_position`,
		 ADD COLUMN `publication_validated` BOOLEAN AFTER `publication_date`,
		 ADD COLUMN `publication_validated_user` INTEGER AFTER `publication_validated`,
		 ADD COLUMN `publication_validated_date` DATETIME AFTER `publication_validated_user`;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		 ALTER TABLE `dp_#client_abb#`.`#client_abb#_forms` ADD COLUMN `publication_date` DATE AFTER `publication_scope_id`,
		 ADD COLUMN `publication_validated` BOOLEAN AFTER `publication_date`,
		 ADD COLUMN `publication_validated_user` INTEGER AFTER `publication_validated`,
		 ADD COLUMN `publication_validated_date` DATETIME AFTER `publication_validated_user`;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		 ALTER TABLE `dp_#client_abb#`.`#client_abb#_forms_views` ADD COLUMN `publication_date` DATE AFTER `update_user_position`,
		 ADD COLUMN `publication_validated` BOOLEAN AFTER `publication_date`,
		 ADD COLUMN `publication_validated_user` INTEGER AFTER `publication_validated`,
		 ADD COLUMN `publication_validated_date` DATETIME AFTER `publication_validated_user`;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		 ALTER TABLE `dp_#client_abb#`.`#client_abb#_areas_files` ADD COLUMN `publication_date` DATE AFTER `association_date`,
		 ADD COLUMN `publication_validated` BOOLEAN AFTER `publication_date`,
		 ADD COLUMN `publication_validated_user` INTEGER AFTER `publication_validated`,
		 ADD COLUMN `publication_validated_date` DATETIME AFTER `publication_validated_user`;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_users` ADD COLUMN `enabled` BOOLEAN NOT NULL DEFAULT 1 AFTER `validated`;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_users` ADD COLUMN `information` TEXT AFTER `image_type`;
	</cfquery>


	<!--- Últimas modificacións no ejecutada en clientes --->
	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_files` ADD COLUMN `replacement_user` INTEGER AFTER `replacement_date`,
	 ADD CONSTRAINT `FK_#client_abb#_files_6` FOREIGN KEY `FK_#client_abb#_files_6` (`replacement_user`)
	    REFERENCES `#client_abb#_users` (`id`)
	    ON DELETE SET NULL
	    ON UPDATE RESTRICT;
	</cfquery>


	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_#client_abb#`.`#client_abb#_users` ADD COLUMN `hide_not_allowed_areas` BOOLEAN NOT NULL DEFAULT 0 AFTER `language`;
	</cfquery>

	<cfquery datasource="#client_dsn#">
		ALTER TABLE `dp_software7`.`software7_lists_fields` ADD COLUMN `sort_by_this_field` BOOLEAN NOT NULL AFTER `required`;
		ALTER TABLE `dp_software7`.`software7_typologies_fields` ADD COLUMN `sort_by_this_field` BOOLEAN NOT NULL AFTER `required`;
		ALTER TABLE `dp_software7`.`software7_forms_fields` ADD COLUMN `sort_by_this_field` BOOLEAN NOT NULL AFTER `required`;
	</cfquery>

			
</cftransaction>

	


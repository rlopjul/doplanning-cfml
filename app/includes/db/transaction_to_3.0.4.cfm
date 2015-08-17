<cfset version_id = "3.0.4">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp304">
		SELECT * 
		FROM information_schema.COLUMNS 
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#' 
		AND TABLE_NAME = '#new_client_abb#_users_typologies_rows_areas';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp304.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_users_typologies` (
			  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
			  `title` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
			  `description` text COLLATE utf8_unicode_ci,
			  `user_in_charge` int(11) NOT NULL,
			  `area_id` int(11) DEFAULT NULL,
			  `creation_date` datetime NOT NULL,
			  `parent_id` int(11) NOT NULL,
			  `parent_kind` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
			  `attached_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
			  `attached_file_id` int(11) DEFAULT NULL,
			  `attached_image_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
			  `attached_image_id` int(11) DEFAULT NULL,
			  `status` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
			  `link` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
			  `link_target` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
			  `last_update_date` datetime DEFAULT NULL,
			  `enabled` tinyint(1) DEFAULT '0',
			  `structure_available` tinyint(1) NOT NULL DEFAULT '0',
			  `general` tinyint(1) NOT NULL DEFAULT '0',
			  `last_update_user_id` int(11) DEFAULT NULL,
			  PRIMARY KEY (`id`) USING BTREE,
			  KEY `FK_#new_client_abb#_users_typologies_1` (`user_in_charge`),
			  KEY `FK_#new_client_abb#_users_typologies_2` (`area_id`),
			  KEY `FK_#new_client_abb#_users_typologies_3` (`attached_file_id`),
			  KEY `FK_#new_client_abb#_users_typologies_4` (`attached_image_id`),
			  KEY `FK_#new_client_abb#_users_typologies_7_idx` (`last_update_user_id`),
			  CONSTRAINT `FK_#new_client_abb#_users_typologies_2` FOREIGN KEY (`area_id`) REFERENCES `#new_client_abb#_areas` (`id`),
			  CONSTRAINT `FK_#new_client_abb#_users_typologies_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#new_client_abb#_users` (`id`),
			  CONSTRAINT `FK_#new_client_abb#_users_typologies_3` FOREIGN KEY (`attached_file_id`) REFERENCES `#new_client_abb#_files` (`id`),
			  CONSTRAINT `FK_#new_client_abb#_users_typologies_4` FOREIGN KEY (`attached_image_id`) REFERENCES `#new_client_abb#_files` (`id`),
			  CONSTRAINT `FK_#new_client_abb#_users_typologies_5` FOREIGN KEY (`last_update_user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_users_typologies_fields` (
			  `field_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
			  `field_type_id` int(10) unsigned NOT NULL,
			  `table_id` int(10) unsigned NOT NULL,
			  `label` varchar(100) NOT NULL,
			  `description` varchar(1000) NOT NULL,
			  `required` tinyint(1) NOT NULL DEFAULT '0',
			  `sort_by_this` varchar(4) NOT NULL,
			  `position` int(10) unsigned NOT NULL,
			  `default_value` varchar(1000) DEFAULT NULL,
			  `list_area_id` int(11) DEFAULT NULL,
			  `field_input_type` varchar(45) DEFAULT NULL,
			  `item_type_id` int(11) unsigned DEFAULT NULL,
			  `mask_type_id` int(10) unsigned DEFAULT NULL,
			  `related_field_id` int(10) unsigned DEFAULT NULL,
			  `list_values` text,
			  PRIMARY KEY (`field_id`),
			  KEY `FK_#new_client_abb#_users_typologies_fields_1` (`field_type_id`),
			  KEY `FK_#new_client_abb#_users_typologies_fields_2` (`table_id`),
			  KEY `FK_#new_client_abb#_users_typologies_fields_3` (`list_area_id`),
			  CONSTRAINT `FK_#new_client_abb#_users_typologies_fields_1` FOREIGN KEY (`field_type_id`) REFERENCES `#new_client_abb#_tables_fields_types` (`field_type_id`),
			  CONSTRAINT `FK_#new_client_abb#_users_typologies_fields_2` FOREIGN KEY (`table_id`) REFERENCES `#new_client_abb#_users_typologies` (`id`),
			  CONSTRAINT `FK_#new_client_abb#_users_typologies_fields_3` FOREIGN KEY (`list_area_id`) REFERENCES `#new_client_abb#_areas` (`id`) ON DELETE SET NULL
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_users_typologies_rows_areas` (
			  `user_typology_id` int(10) unsigned NOT NULL,
			  `row_id` int(10) unsigned NOT NULL,
			  `field_id` int(10) unsigned NOT NULL,
			  `area_id` int(11) NOT NULL,
			  PRIMARY KEY (`user_typology_id`,`row_id`,`area_id`,`field_id`) USING BTREE,
			  KEY `FK_#new_client_abb#_users_typologies_rows_areas_2` (`field_id`),
			  KEY `FK_#new_client_abb#_users_typologies_rows_areas_3` (`area_id`),
			  CONSTRAINT `FK_#new_client_abb#_users_typologies_rows_areas_1` FOREIGN KEY (`user_typology_id`) REFERENCES `#new_client_abb#_users_typologies` (`id`) ON DELETE CASCADE,
			  CONSTRAINT `FK_#new_client_abb#_users_typologies_rows_areas_2` FOREIGN KEY (`field_id`) REFERENCES `#new_client_abb#_users_typologies_fields` (`field_id`) ON DELETE CASCADE,
			  CONSTRAINT `FK_#new_client_abb#_users_typologies_rows_areas_3` FOREIGN KEY (`area_id`) REFERENCES `#new_client_abb#_areas` (`id`) ON DELETE CASCADE
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users` 
			ADD COLUMN `typology_id` INT(11) UNSIGNED NULL AFTER `information`,
			ADD COLUMN `typology_row_id` INT(11) UNSIGNED NULL AFTER `typology_id`,
			ADD INDEX `#new_client_abb#_users_ibfk_2_idx` (`typology_id` ASC);
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_areas` 
			ADD COLUMN `item_type_16_enabled` TINYINT(4) NOT NULL DEFAULT '1' AFTER `item_type_15_enabled`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users` 
			ADD CONSTRAINT `#new_client_abb#_users_ibfk_2`
			  FOREIGN KEY (`typology_id`)
			  REFERENCES `dp_#new_client_abb#`.`#new_client_abb#_users_typologies` (`id`)
			  ON DELETE NO ACTION
			  ON UPDATE NO ACTION;
		</cfquery>

		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput> 
		</cfcatch>

	</cftry>


</cfif>
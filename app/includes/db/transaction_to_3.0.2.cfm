<cfset version_id = "3.0.2">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp302">
		SELECT * 
		FROM information_schema.COLUMNS 
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#' 
		AND TABLE_NAME = '#new_client_abb#_lists_actions_fields';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp302.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_items_deleted` 
			DROP FOREIGN KEY `FK_#new_client_abb#_items_deleted_1`,
			DROP FOREIGN KEY `FK_#new_client_abb#_items_deleted_2`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_items_deleted` 
			CHANGE COLUMN `delete_area_id` `delete_area_id` INT(11) NULL ;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_items_deleted` 
			ADD CONSTRAINT `FK_#new_client_abb#_items_deleted_1`
			  FOREIGN KEY (`delete_area_id`)
			  REFERENCES `#new_client_abb#_areas` (`id`)
			  ON DELETE SET NULL
			  ON UPDATE NO ACTION,
			ADD CONSTRAINT `FK_#new_client_abb#_items_deleted_2`
			  FOREIGN KEY (`delete_user_id`)
			  REFERENCES `#new_client_abb#_users` (`id`)
			  ON DELETE CASCADE
			  ON UPDATE NO ACTION;
		</cfquery>


		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_forms_actions` (
			  `action_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
			  `table_id` int(11) unsigned NOT NULL,
			  `action_type_id` int(10) unsigned NOT NULL,
			  `action_event_type_id` int(10) unsigned NOT NULL,
			  `action_subject` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
			  `action_content` mediumtext CHARACTER SET latin1,
			  `action_content_with_row` tinyint(1) DEFAULT '0',
			  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
			  `creation_date` datetime NOT NULL,
			  `last_update_date` datetime DEFAULT NULL,
			  `insert_user_id` int(11) DEFAULT NULL,
			  `last_update_user_id` int(11) DEFAULT NULL,
			  `last_success_execution_date` datetime DEFAULT NULL,
			  `last_success_execution_row_id` int(20) unsigned DEFAULT NULL,
			  PRIMARY KEY (`action_id`),
			  KEY `FK_#new_client_abb#_forms_actions_1_idx` (`table_id`),
			  KEY `FK_#new_client_abb#_forms_actions_2_idx` (`insert_user_id`),
			  KEY `FK_#new_client_abb#_forms_actions_3_idx` (`last_update_user_id`),
			  CONSTRAINT `FK_#new_client_abb#_forms_actions_3` FOREIGN KEY (`last_update_user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
			  CONSTRAINT `FK_#new_client_abb#_forms_actions_1` FOREIGN KEY (`table_id`) REFERENCES `#new_client_abb#_forms` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
			  CONSTRAINT `FK_#new_client_abb#_forms_actions_2` FOREIGN KEY (`insert_user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>


		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_forms_actions_fields` (
			  `action_id` int(11) unsigned NOT NULL,
			  `field_id` int(10) unsigned NOT NULL,
			  PRIMARY KEY (`action_id`,`field_id`),
			  KEY `FK_#new_client_abb#_forms_actions_fields_2_idx` (`field_id`),
			  CONSTRAINT `FK_#new_client_abb#_forms_actions_fields_2` FOREIGN KEY (`field_id`) REFERENCES `#new_client_abb#_forms_fields` (`field_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
			  CONSTRAINT `FK_#new_client_abb#_forms_actions_fields_1` FOREIGN KEY (`action_id`) REFERENCES `#new_client_abb#_forms_actions` (`action_id`) ON DELETE CASCADE ON UPDATE NO ACTION
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_lists_actions` (
			  `action_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
			  `table_id` int(11) unsigned NOT NULL,
			  `action_type_id` int(10) unsigned NOT NULL,
			  `action_event_type_id` int(10) unsigned NOT NULL,
			  `action_subject` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
			  `action_content` mediumtext CHARACTER SET latin1,
			  `action_content_with_row` tinyint(1) DEFAULT '0',
			  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
			  `creation_date` datetime NOT NULL,
			  `last_update_date` datetime DEFAULT NULL,
			  `insert_user_id` int(11) DEFAULT NULL,
			  `last_update_user_id` int(11) DEFAULT NULL,
			  `last_success_execution_date` datetime DEFAULT NULL,
			  `last_success_execution_row_id` int(20) unsigned DEFAULT NULL,
			  PRIMARY KEY (`action_id`),
			  KEY `FK_#new_client_abb#_lists_actions_1_idx` (`table_id`),
			  KEY `FK_#new_client_abb#_lists_actions_2_idx` (`insert_user_id`),
			  KEY `FK_#new_client_abb#_lists_actions_3_idx` (`last_update_user_id`),
			  CONSTRAINT `FK_#new_client_abb#_lists_actions_3` FOREIGN KEY (`last_update_user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
			  CONSTRAINT `FK_#new_client_abb#_lists_actions_1` FOREIGN KEY (`table_id`) REFERENCES `#new_client_abb#_lists` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
			  CONSTRAINT `FK_#new_client_abb#_lists_actions_2` FOREIGN KEY (`insert_user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_lists_actions_fields` (
			  `action_id` int(11) unsigned NOT NULL,
			  `field_id` int(10) unsigned NOT NULL,
			  PRIMARY KEY (`action_id`,`field_id`),
			  KEY `FK_#new_client_abb#_lists_actions_fields_2_idx` (`field_id`),
			  CONSTRAINT `FK_#new_client_abb#_lists_actions_fields_2` FOREIGN KEY (`field_id`) REFERENCES `#new_client_abb#_lists_fields` (`field_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
			  CONSTRAINT `FK_#new_client_abb#_lists_actions_fields_1` FOREIGN KEY (`action_id`) REFERENCES `#new_client_abb#_lists_actions` (`action_id`) ON DELETE CASCADE ON UPDATE NO ACTION
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			INSERT INTO `dp_#new_client_abb#`.`#new_client_abb#_tables_fields_types` (`field_type_id`, `field_type_group`, `input_type`, `name`, `max_length`, `mysql_type`, `cf_sql_type`, `enabled`, `position`) VALUES ('17', 'short_text', 'email', 'Email', '255', 'VARCHAR(255)', 'cf_sql_varchar', '1', '9');
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `dp_#new_client_abb#`.`#new_client_abb#_tables_fields_types` SET `position`='10' WHERE `field_type_id`='8';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `dp_#new_client_abb#`.`#new_client_abb#_tables_fields_types` SET `position`='11' WHERE `field_type_id`='15';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `dp_#new_client_abb#`.`#new_client_abb#_tables_fields_types` SET `position`='12' WHERE `field_type_id`='16';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `dp_#new_client_abb#`.`#new_client_abb#_tables_fields_types` SET `position`='13' WHERE `field_type_id`='9';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `dp_#new_client_abb#`.`#new_client_abb#_tables_fields_types` SET `position`='14' WHERE `field_type_id`='10';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `dp_#new_client_abb#`.`#new_client_abb#_tables_fields_types` SET `position`='15' WHERE `field_type_id`='12';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `dp_#new_client_abb#`.`#new_client_abb#_tables_fields_types` SET `position`='16' WHERE `field_type_id`='13';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `dp_#new_client_abb#`.`#new_client_abb#_tables_fields_types` SET `position`='17' WHERE `field_type_id`='14';
		</cfquery>

		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput> 
		</cfcatch>

	</cftry>


</cfif>
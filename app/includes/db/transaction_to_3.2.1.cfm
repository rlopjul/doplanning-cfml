<cfset version_id = "3.2.1">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp321">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_users'
		AND COLUMN_NAME = 'user_administrator';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp321.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<!---Fix bug--->
		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_files_downloads`
			ADD INDEX `FK_#new_client_abb#_files_downloads_1_idx` (`file_id` ASC),
			DROP PRIMARY KEY;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			INSERT INTO `#new_client_abb#_tables_fields_types` (`field_type_id`, `field_type_group`, `input_type`, `name`, `max_length`, `mysql_type`, `enabled`, `position`) VALUES ('20', 'separator', 'none', 'Separador de campos', NULL, NULL, '1', '19');
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_lists_fields`
			ADD COLUMN `import_name` VARCHAR(100) NULL AFTER `list_values`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_forms_fields`
			ADD COLUMN `import_name` VARCHAR(100) NULL AFTER `list_values`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_typologies_fields`
			ADD COLUMN `import_name` VARCHAR(100) NULL AFTER `list_values`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users_typologies_fields`
			ADD COLUMN `import_name` VARCHAR(100) NULL AFTER `list_values`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users`
			DROP FOREIGN KEY `#new_client_abb#_users_ibfk_3`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users`
			ADD CONSTRAINT `#new_client_abb#_users_ibfk_3`
			  FOREIGN KEY (`last_update_user_id`)
			  REFERENCES `#new_client_abb#_users` (`id`)
			  ON DELETE SET NULL
			  ON UPDATE SET NULL;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_lists_fields`
			ADD COLUMN `include_in_list` TINYINT(1) NOT NULL DEFAULT 1 AFTER `import_name`,
			ADD COLUMN `include_in_row_content` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_list`,
			ADD COLUMN `include_in_new_row` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_row_content`,
			ADD COLUMN `include_in_update_row` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_new_row`,
			ADD COLUMN `include_in_all_users` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_update_row`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_forms_fields`
			ADD COLUMN `include_in_list` TINYINT(1) NOT NULL DEFAULT 1 AFTER `import_name`,
			ADD COLUMN `include_in_row_content` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_list`,
			ADD COLUMN `include_in_new_row` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_row_content`,
			ADD COLUMN `include_in_update_row` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_new_row`,
			ADD COLUMN `include_in_all_users` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_update_row`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_typologies_fields`
			ADD COLUMN `include_in_list` TINYINT(1) NOT NULL DEFAULT 1 AFTER `import_name`,
			ADD COLUMN `include_in_row_content` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_list`,
			ADD COLUMN `include_in_new_row` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_row_content`,
			ADD COLUMN `include_in_update_row` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_new_row`,
			ADD COLUMN `include_in_all_users` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_update_row`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users_typologies_fields`
			ADD COLUMN `include_in_list` TINYINT(1) NOT NULL DEFAULT 1 AFTER `import_name`,
			ADD COLUMN `include_in_row_content` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_list`,
			ADD COLUMN `include_in_new_row` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_row_content`,
			ADD COLUMN `include_in_update_row` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_new_row`,
			ADD COLUMN `include_in_all_users` TINYINT(1) NOT NULL DEFAULT 1 AFTER `include_in_update_row`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users`
			ADD COLUMN `verified` TINYINT(1) NOT NULL DEFAULT 0 AFTER `enabled`,
			ADD COLUMN `verification_code` VARCHAR(100) NOT NULL AFTER `verified`,
			ADD COLUMN `verification_date` DATETIME NULL AFTER `verification_code`,
			ADD COLUMN `user_administrator` TINYINT(1) NOT NULL DEFAULT 0 AFTER `internal_user`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			INSERT INTO `#new_client_abb#_tables_fields_types` (`field_type_id`, `field_type_group`, `input_type`, `name`, `max_length`, `mysql_type`, `cf_sql_type`, `enabled`, `position`) VALUES ('21', 'hidden', 'hidden', 'Campo oculto (sólo para uso avanzado)', '255', 'VARCHAR(255)', 'cf_sql_varchar', '0', '20');
		</cfquery>


		<!---
		MODIFICACIÓN MANUAL DE ESTA VERSIÓN:
		ALTER TABLE `doplanning_app`.`app_clients`
		ADD COLUMN `public_user_registration` TINYINT(1) NOT NULL DEFAULT 0 AFTER `bin_days`;
		--->

		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput>
		</cfcatch>

	</cftry>


</cfif>

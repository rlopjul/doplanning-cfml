<cfset version_id = "2.9.2">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp292">
		SELECT * 
		FROM information_schema.COLUMNS 
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#' 
		AND TABLE_NAME = '#new_client_abb#_areas' 
		AND COLUMN_NAME = 'item_type_20_enabled';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp292.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<cfquery datasource="#client_datasource#">
			UPDATE `#new_client_abb#_tables_fields_types` SET `name`='Lista de opciones con selección simple a partir de área' WHERE `field_type_id`='9';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `#new_client_abb#_tables_fields_types` SET `name`='Lista de opciones con selección múltiple a partir de área' WHERE `field_type_id`='10';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			INSERT INTO `#new_client_abb#_tables_fields_types` (`field_type_id`, `field_type_group`, `input_type`, `name`, `max_length`, `mysql_type`, `cf_sql_type`, `enabled`, `position`) VALUES ('15', 'list', 'select', 'Lista de opciones con selección simple', '255', 'VARCHAR(255)', 'cf_sql_varchar', '1', '15');
		</cfquery>

		<cfquery datasource="#client_datasource#">
			INSERT INTO `#new_client_abb#_tables_fields_types` (`field_type_id`, `field_type_group`, `input_type`, `name`, `max_length`, `mysql_type`, `cf_sql_type`, `enabled`, `position`) VALUES ('16', 'list', 'select', 'Lista de opciones con selección múltiple', '255', 'VARCHAR(255)', 'cf_sql_varchar', '1', '16');
		</cfquery>


		<cfquery datasource="#client_datasource#">
			UPDATE `#new_client_abb#_tables_fields_types` SET `position`='10' WHERE `field_type_id`='15';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `#new_client_abb#_tables_fields_types` SET `position`='11' WHERE `field_type_id`='16';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `#new_client_abb#_tables_fields_types` SET `position`='12' WHERE `field_type_id`='9';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `#new_client_abb#_tables_fields_types` SET `position`='13' WHERE `field_type_id`='10';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `#new_client_abb#_tables_fields_types` SET `position`='14' WHERE `field_type_id`='12';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `#new_client_abb#_tables_fields_types` SET `position`='15' WHERE `field_type_id`='13';
		</cfquery>

		<!--- Solo para bioinformatics7 --->
		<cfif new_client_abb EQ "bioinformatics7">
			<cfquery datasource="#client_datasource#">
				UPDATE `#new_client_abb#_tables_fields_types` SET `position`='16' WHERE `field_type_id`='14';
			</cfquery>
		</cfif>
		
		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_lists_fields` 
			ADD COLUMN `list_values` TEXT NULL DEFAULT NULL AFTER `mask_type_id`;
		</cfquery>

		<cfquery datasource="#client_datasource#">		
			ALTER TABLE `#new_client_abb#_forms_fields` 
			ADD COLUMN `list_values` TEXT NULL DEFAULT NULL AFTER `mask_type_id`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_typologies_fields` 
			ADD COLUMN `list_values` TEXT NULL DEFAULT NULL AFTER `mask_type_id`;
		</cfquery>


		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_areas` 
			ADD COLUMN `item_type_1_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `version_tree`,
			ADD COLUMN `item_type_2_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_1_enabled`,
			ADD COLUMN `item_type_3_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_2_enabled`,
			ADD COLUMN `item_type_4_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_3_enabled`,
			ADD COLUMN `item_type_5_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_4_enabled`,
			ADD COLUMN `item_type_6_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_5_enabled`,
			ADD COLUMN `item_type_7_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_6_enabled`,
			ADD COLUMN `item_type_8_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_7_enabled`,
			ADD COLUMN `item_type_9_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_8_enabled`,
			ADD COLUMN `item_type_10_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_9_enabled`,
			ADD COLUMN `item_type_11_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_10_enabled`,
			ADD COLUMN `item_type_12_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_11_enabled`,
			ADD COLUMN `item_type_13_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_12_enabled`,
			ADD COLUMN `item_type_14_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_13_enabled`,
			ADD COLUMN `item_type_15_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_14_enabled`,
			ADD COLUMN `item_type_20_enabled` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_15_enabled`;
		</cfquery>

		<cfoutput>
			#new_client_abb# migrado a versión #version_id#<br/><br/>
		</cfoutput>

		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput> 
		</cfcatch>

	</cftry>


</cfif>
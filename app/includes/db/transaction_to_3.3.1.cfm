<cfset version_id = "3.3.1">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp331">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_lists_fields'
		AND COLUMN_NAME = 'referenced_table_id';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp331.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<!--- related rows --->

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `hcs_lists_fields`
			ADD COLUMN `referenced_table_id` INT(11) UNSIGNED NULL AFTER `item_type_id`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			INSERT INTO `hcs_tables_fields_types` (`field_type_id`, `field_type_group`, `input_type`, `name`, `max_length`, `mysql_type`, `cf_sql_type`, `enabled`, `position`) VALUES ('19', 'table_row', 'hidden', 'Registro de tabla', '11', 'INT(11)', 'cf_sql_integer', '1', '19');
			UPDATE `dp_hcs`.`hcs_tables_fields_types` SET `position`='20' WHERE `field_type_id`='20';
			UPDATE `dp_hcs`.`hcs_tables_fields_types` SET `position`='21' WHERE `field_type_id`='21';
		</cfquery>

		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput>
		</cfcatch>

	</cftry>


</cfif>

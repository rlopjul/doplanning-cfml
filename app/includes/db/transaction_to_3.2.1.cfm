<cfset version_id = "3.2.1">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp321">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_mailings';
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


		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_files_downloads`
			ADD INDEX `FK_#new_client_abb#_files_downloads_1_idx` (`file_id` ASC),
			DROP PRIMARY KEY;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			INSERT INTO `#new_client_abb#_tables_fields_types` (`field_type_id`, `field_type_group`, `input_type`, `name`, `max_length`, `mysql_type`, `enabled`, `position`) VALUES ('20', 'separator', 'none', 'Separador de campos', NULL, NULL, '1', '19');
		</cfquery>


		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput>
		</cfcatch>

	</cftry>


</cfif>

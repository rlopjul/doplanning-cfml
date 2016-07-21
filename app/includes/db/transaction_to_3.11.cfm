<cfset version_id = "3.11">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp311">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_users_typologies_fields'
		AND COLUMN_NAME = 'filter_by_select';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp311.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<!--- filter_by_select column --->

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `dp_#new_client_abb#`.`#new_client_abb#_lists_fields`
				ADD COLUMN `filter_by_select` TINYINT(1) NOT NULL DEFAULT 0 AFTER `unique`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `dp_#new_client_abb#`.`#new_client_abb#_forms_fields`
				ADD COLUMN `filter_by_select` TINYINT(1) NOT NULL DEFAULT 0 AFTER `unique`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `dp_#new_client_abb#`.`#new_client_abb#_typologies_fields`
				ADD COLUMN `filter_by_select` TINYINT(1) NOT NULL DEFAULT 0 AFTER `unique`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `dp_#new_client_abb#`.`#new_client_abb#_users_typologies_fields`
				ADD COLUMN `filter_by_select` TINYINT(1) NOT NULL DEFAULT 0 AFTER `unique`;
		</cfquery>


		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput>
		</cfcatch>

	</cftry>


</cfif>

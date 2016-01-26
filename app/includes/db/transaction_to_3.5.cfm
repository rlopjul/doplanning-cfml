
<cfset version_id = "3.5">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp35">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_areas'
		AND COLUMN_NAME = 'list_mode';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp35.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<!--- list_mode column --->

		<cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_areas`
      ADD COLUMN `list_mode` VARCHAR(45) NULL AFTER `version_tree`;
		</cfquery>

		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput>
		</cfcatch>

	</cftry>


</cfif>

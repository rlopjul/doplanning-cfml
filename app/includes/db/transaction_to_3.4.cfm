<cfset version_id = "3.4">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp34">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_entries'
		AND COLUMN_NAME = 'publication_restricted';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp34.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<!--- publication_restricted_column --->

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `dp_hcs`.`hcs_entries`
			ADD COLUMN `publication_restricted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '' AFTER `publication_validated_date`;
		</cfquery>


		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput>
		</cfcatch>

	</cftry>


</cfif>

<cfset version_id = "2.9.1">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp291">
		SELECT * 
		FROM information_schema.COLUMNS 
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#' 
		AND TABLE_NAME = '#new_client_abb#_files_versions' 
		AND COLUMN_NAME = 'version_index';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp291.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_files_versions` 
			ADD COLUMN `version_index` VARCHAR(45) NULL AFTER `publication_area_id`;
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
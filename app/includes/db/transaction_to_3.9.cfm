<cfset version_id = "3.9">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp39">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_typologies'
		AND COLUMN_NAME = 'url_id'
    AND COLUMN_TYPE = 'varchar(255)';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp39.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<!--- url_id colum in typologies --->

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_typologies`
			ADD COLUMN `url_id` VARCHAR(255) NULL AFTER `form_display_type`,
			ADD UNIQUE INDEX `url_id_UNIQUE` (`url_id` ASC);
		</cfquery>


		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput>
		</cfcatch>

	</cftry>


</cfif>

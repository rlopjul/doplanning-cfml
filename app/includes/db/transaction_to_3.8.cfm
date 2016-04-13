<cfset version_id = "3.8">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp38">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_files'
		AND COLUMN_NAME = 'url_id'
    AND COLUMN_TYPE = 'varchar(255)';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp38.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<!--- change url_id colum length --->

    <cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_areas`
				CHANGE COLUMN `url_id` `url_id` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL DEFAULT NULL ;
    </cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_entries`
				CHANGE COLUMN `url_id` `url_id` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL DEFAULT NULL ;
    </cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_news`
				CHANGE COLUMN `url_id` `url_id` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL DEFAULT NULL ;
    </cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_events`
				CHANGE COLUMN `url_id` `url_id` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL DEFAULT NULL ;
    </cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_pubmeds`
				CHANGE COLUMN `url_id` `url_id` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL DEFAULT NULL ;
    </cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_images`
				CHANGE COLUMN `url_id` `url_id` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL DEFAULT NULL ;
    </cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_lists`
				CHANGE COLUMN `url_id` `url_id` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL DEFAULT NULL ;
    </cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_forms`
				CHANGE COLUMN `url_id` `url_id` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL DEFAULT NULL ;
    </cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_lists_views`
				CHANGE COLUMN `url_id` `url_id` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL DEFAULT NULL ;
    </cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_forms_views`
				CHANGE COLUMN `url_id` `url_id` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL DEFAULT NULL ;
    </cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_mailings`
				CHANGE COLUMN `url_id` `url_id` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL DEFAULT NULL ;
    </cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_files`
				CHANGE COLUMN `url_id` `url_id` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL DEFAULT NULL ;
    </cfquery>


		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput>
		</cfcatch>

	</cftry>


</cfif>

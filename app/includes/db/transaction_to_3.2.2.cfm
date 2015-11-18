<cfset version_id = "3.2.2">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp322">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_users'
		AND COLUMN_NAME = 'user_administrator';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp322.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<!--- list_rows_by_default field --->

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_lists`
			ADD COLUMN `list_rows_by_default` TINYINT(1) NOT NULL DEFAULT 1 AFTER `last_update_type`;
		</cfif>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_forms`
			ADD COLUMN `list_rows_by_default` TINYINT(1) NOT NULL DEFAULT 1 AFTER `last_update_type`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_typologies`
			ADD COLUMN `list_rows_by_default` TINYINT(1) NOT NULL DEFAULT 1 AFTER `last_update_type`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users_typologies`
			ADD COLUMN `list_rows_by_default` TINYINT(1) NOT NULL DEFAULT 1 AFTER `last_update_type`;
		</cfquery>


		<!--- unique field --->

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_lists_fields`
			ADD COLUMN `unique` TINYINT(1) NOT NULL DEFAULT 0 AFTER `include_in_all_users`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_forms_fields`
			ADD COLUMN `unique` TINYINT(1) NOT NULL DEFAULT 0 AFTER `include_in_all_users`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_typologies_fields`
			ADD COLUMN `unique` TINYINT(1) NOT NULL DEFAULT 0 AFTER `include_in_all_users`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users_typologies_fields`
			ADD COLUMN `unique` TINYINT(1) NOT NULL DEFAULT 0 AFTER `include_in_all_users`;
		</cfquery>


		<!--- publication_date field type DATETIME --->
		
		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_events`
			CHANGE COLUMN `publication_date` `publication_date` DATETIME NULL DEFAULT NULL;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_news`
			CHANGE COLUMN `publication_date` `publication_date` DATETIME NULL DEFAULT NULL;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_entries`
			CHANGE COLUMN `publication_date` `publication_date` DATETIME NULL DEFAULT NULL;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_images`
			CHANGE COLUMN `publication_date` `publication_date` DATETIME NULL DEFAULT NULL;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_pubmeds`
			CHANGE COLUMN `publication_date` `publication_date` DATETIME NULL DEFAULT NULL;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_lists`
			CHANGE COLUMN `publication_date` `publication_date` DATETIME NULL DEFAULT NULL;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_lists_views`
			CHANGE COLUMN `publication_date` `publication_date` DATETIME NULL DEFAULT NULL;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_forms`
			CHANGE COLUMN `publication_date` `publication_date` DATETIME NULL DEFAULT NULL;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_forms_views`
			CHANGE COLUMN `publication_date` `publication_date` DATETIME NULL DEFAULT NULL;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_areas_files`
			CHANGE COLUMN `publication_date` `publication_date` DATETIME NULL DEFAULT NULL;
		</cfquery>


		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput>
		</cfcatch>

	</cftry>


</cfif>

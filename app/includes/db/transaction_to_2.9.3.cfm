<cfset version_id = "2.9.3">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp293">
		SELECT * 
		FROM information_schema.COLUMNS 
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#' 
		AND TABLE_NAME = '#new_client_abb#_users' 
		AND COLUMN_NAME = 'notify_app_features';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp293.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_areas` 
			ADD COLUMN `users_visible` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_20_enabled`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_areas` 
			ADD COLUMN `read_only` TINYINT(1) NOT NULL DEFAULT 0 AFTER `users_visible`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users` 
			ADD COLUMN `notify_been_associated_to_area` TINYINT(1) NOT NULL DEFAULT 1 AFTER `notify_lock_file`,
			ADD COLUMN `notify_new_user_in_area` TINYINT(1) NOT NULL DEFAULT 1 AFTER `notify_been_associated_to_area`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users` 
			ADD COLUMN `notify_app_news` TINYINT(1) NOT NULL DEFAULT 1 AFTER `notify_new_user_in_area`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users` 
			ADD COLUMN `notify_app_features` TINYINT(1) NOT NULL DEFAULT 1 AFTER `notify_app_news`;
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
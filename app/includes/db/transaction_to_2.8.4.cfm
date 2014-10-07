<cfset version_id = "2.8.4">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp284">
		SELECT * 
		FROM information_schema.COLUMNS 
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#' 
		AND TABLE_NAME = '#new_client_abb#_lists_fields' 
		AND COLUMN_NAME = 'mask_type_id';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp284.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>
		
		<!---Modificaciones de la base de datos--->
		<cftransaction>
			
			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_lists_fields` 
				ADD COLUMN `mask_type_id` INT(10) UNSIGNED NULL AFTER `item_type_id`;
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_forms_fields` 
				ADD COLUMN `mask_type_id` INT(10) UNSIGNED NULL AFTER `item_type_id`;
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_typologies_fields` 
				ADD COLUMN `mask_type_id` INT(10) UNSIGNED NULL AFTER `item_type_id`;
			</cfquery>

		</cftransaction>

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
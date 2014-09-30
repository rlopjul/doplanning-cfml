<cfset version_id = "2.8.3">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp283">
		SELECT * 
		FROM `#new_client_abb#_tables_fields_types`
		WHERE field_type_id = 13;
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp283.recordCount GT 0>

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
				UPDATE `#new_client_abb#_tables_fields_types`
				SET field_type_group = 'user',
				name = 'Usuario de DoPlanning',
				enabled = 1
				WHERE field_type_id = 12;
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_lists_fields` 
				ADD COLUMN `item_type_id` INT(11) UNSIGNED NULL AFTER `field_input_type`;
	 		</cfquery>

	 		<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_typologies_fields` 
				ADD COLUMN `item_type_id` INT(11) UNSIGNED NULL AFTER `field_input_type`;
	 		</cfquery>

	 		<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_forms_fields` 
				ADD COLUMN `item_type_id` INT(11) UNSIGNED NULL AFTER `field_input_type`;
	 		</cfquery>

	 		<cfquery datasource="#client_datasource#">
				INSERT INTO `#new_client_abb#_tables_fields_types` 
				VALUES (13,'doplanning_item','hidden','Elemento de DoPlanning',11,'INT(11)','cf_sql_integer',1,13);
	 		</cfquery>
				
		</cftransaction>

		<cfoutput>
			#new_client_abb# migrado a versión #version_id#<br/><br/>
		</cfoutput>

		<cfcatch>
			<cfoutput>
				<!--- csalud NO MIGRADO CORRECTAMENTE, falta la columna field_type_group--->
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/><br/>
			</cfoutput> 
		</cfcatch>

	</cftry>


</cfif>
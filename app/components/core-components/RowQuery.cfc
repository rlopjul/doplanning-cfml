<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">

	<cfset component = "RowQuery">	

	<cfset dateFormat = "%d-%m-%Y"><!---%H:%i:%s---><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset datetimeFormat = "%d-%m-%Y %H:%i:%s">

	<!---<cfset fieldsTypesTable = "tables_fields_types">--->


	<!---getTableRow--->
		
	<!---<cffunction name="getTableRow" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getTableRow">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">		
			
			<cfquery name="getTableRowQuery" datasource="#client_dsn#">
				SELECT *
				FROM #client_abb#_#tableTypeTable#_row_#arguments.table_id#
				ORDER BY insert_date DESC;
			</cfquery>
		
		<cfreturn getTableRowQuery>
		
	</cffunction>--->


	<!---getTableRows--->
		
	<cffunction name="getTableRows" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="false">
		<!---<cfargument name="parse_dates" type="boolean" required="false" default="false">--->

		<cfargument name="with_types" type="boolean" required="false" default="false">
		<cfargument name="with_table" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getTableRow">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfquery name="getTableRow" datasource="#client_dsn#">
				SELECT table_row.*,
				<!---<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(table_row.creation_date, '#datetimeFormat#') AS creation_date 
				</cfif>--->
				CONCAT_WS(' ', insert_users.family_name, insert_users.name) AS insert_user_full_name, insert_users.image_type AS insert_user_image_type,
				CONCAT_WS(' ', update_users.family_name, update_users.name) AS update_user_full_name, update_users.image_type AS update_user_image_type
				<!---<cfif arguments.with_types IS true>
				, fields_types.*
				</cfif>
				<cfif arguments.with_table IS true>
				, tables.area_id
				</cfif>--->
				FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` AS table_row
				<!---<cfif arguments.with_types IS true>
					INNER JOIN #client_abb#_#fieldsTypesTable# AS fields_types ON table_row.field_type_id = fields_types.field_type_id
				</cfif>
				<cfif arguments.with_table IS true>
					INNER JOIN #client_abb#_#tableTypeTable# AS tables ON table_row.table_id = tables.id
				</cfif>--->
				INNER JOIN #client_abb#_users AS insert_users ON table_row.insert_user_id = insert_users.id
				LEFT JOIN #client_abb#_users AS update_users ON table_row.last_update_user_id = update_users.id
				<cfif isDefined("arguments.row_id")>
					WHERE table_row.row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">
				<cfelse>
					ORDER BY position ASC
				</cfif>;
			</cfquery>
		
		<cfreturn getTableRow>
		
	</cffunction>


	<!---getRowLastPosition--->
	
	<cffunction name="getRowLastPosition" output="false" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
		
		<cfset var method = "getRowLastPosition">
		<cfset var position = 0>
					
			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
						
				<cfquery name="rowPositionQuery" datasource="#client_dsn#">
					SELECT MAX(position) AS max_position					
					FROM #client_abb#_#tableTypeTable#_fields AS tables_fields
					WHERE tables_fields.table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
				
				<cfset position = rowPositionQuery.max_position>
		
		<cfreturn {position=position}>
		
	</cffunction>
	

</cfcomponent>
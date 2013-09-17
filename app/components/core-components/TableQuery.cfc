<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">

	<cfset component = "AreaItemQuery">	
	
	<cfset date_format = "%d-%m-%Y"><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset datetime_format = "%d-%m-%Y %H:%i:%s">

	<cfset fields_types_table = "tables_fields_types">

	<!---getFieldTypes--->
		
	<cffunction name="getFieldTypes" output="false" returntype="query" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getFieldTypes">
			
			<cfquery name="getFieldTypesQuery" datasource="#client_dsn#">
				SELECT field_type_id, input_type, name
				FROM #client_abb#_#fields_types_table#;
			</cfquery>
		
		<cfreturn getFieldTypesQuery>
		
	</cffunction>


	<!---getTableFields--->
		
	<cffunction name="getTableFields" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_types" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getTableFields">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">		
							
			<cfquery name="getTableFieldsQuery" datasource="#client_dsn#">
				SELECT table_fields.*
				<cfif arguments.with_types IS true>
				, fields_types.*
				</cfif>
				FROM #client_abb#_#tableTypeTable#_fields AS table_fields
				<cfif arguments.with_types IS true>
				INNER JOIN #client_abb#_#fields_types_table# AS fields_types ON table_fields.field_type_id = fields_types.field_type_id
				</cfif>
				WHERE table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
				
		<cfreturn getTableFieldsQuery>
		
	</cffunction>


	<!---getTableData--->
		
	<cffunction name="getTableData" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getTableData">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">		
			
			<cfquery name="getTableDataQuery" datasource="#client_dsn#">
				SELECT *
				FROM #client_abb#_#tableTypeTable#_data_#arguments.table_id#;
			</cfquery>
		
		<cfreturn getTableDataQuery>
		
	</cffunction>

</cfcomponent>	

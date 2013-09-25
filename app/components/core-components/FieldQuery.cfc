<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">

	<cfset component = "FieldQuery">	

	<cfset fieldsTypesTable = "tables_fields_types">


	<!---getFieldTypes--->
		
	<cffunction name="getFieldTypes" output="false" returntype="query" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getFieldTypes">
			
			<cfquery name="getFieldTypesQuery" datasource="#client_dsn#">
				SELECT field_type_id, input_type, name, mysql_type
				FROM `#client_abb#_#fieldsTypesTable#`
				WHERE enabled = true;
			</cfquery>
		
		<cfreturn getFieldTypesQuery>
		
	</cffunction>


	<!---getFieldType--->
		
	<cffunction name="getFieldType" output="false" returntype="query" access="public">
		<cfargument name="field_type_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getFieldType">
			
			<cfquery name="getFieldTypeQuery" datasource="#client_dsn#">
				SELECT field_type_id, input_type, name, mysql_type
				FROM `#client_abb#_#fieldsTypesTable#`
				WHERE field_type_id = <cfqueryparam value="#arguments.field_type_id#" cfsqltype="cf_sql_integer">
				AND enabled = true;
			</cfquery>
		
		<cfreturn getFieldTypeQuery>
		
	</cffunction>


	<!---getField--->
		
	<cffunction name="getField" output="false" returntype="query" access="public">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_type" type="boolean" required="false" default="false">
		<cfargument name="with_table" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getField">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfquery name="getField" datasource="#client_dsn#">
				SELECT table_fields.*
				<cfif arguments.with_type IS true>
				, fields_types.*
				</cfif>
				<cfif arguments.with_table IS true>
				, tables.area_id
				</cfif>
				FROM `#client_abb#_#tableTypeTable#_fields` AS table_fields
				<cfif arguments.with_type IS true>
					INNER JOIN `#client_abb#_#fieldsTypesTable#` AS fields_types ON table_fields.field_type_id = fields_types.field_type_id
				</cfif>
				<cfif arguments.with_table IS true>
					INNER JOIN `#client_abb#_#tableTypeTable#` AS tables ON table_fields.table_id = tables.id
				</cfif>
				WHERE field_id = <cfqueryparam value="#arguments.field_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
		
		<cfreturn getField>
		
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
				FROM `#client_abb#_#tableTypeTable#_fields` AS table_fields
				<cfif arguments.with_types IS true>
				INNER JOIN `#client_abb#_#fieldsTypesTable#` AS fields_types ON table_fields.field_type_id = fields_types.field_type_id
				</cfif>
				WHERE table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
				ORDER BY position ASC;
			</cfquery>
				
		<cfreturn getTableFieldsQuery>
		
	</cffunction>


	<!---getFieldsLastPosition--->
	
	<cffunction name="getFieldsLastPosition" output="false" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
		
		<cfset var method = "getFieldsLastPosition">
		<cfset var position = 0>
					
			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
						
				<cfquery name="fieldsPositionQuery" datasource="#client_dsn#">
					SELECT MAX(position) AS max_position					
					FROM `#client_abb#_#tableTypeTable#_fields` AS tables_fields
					WHERE tables_fields.table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
				
				<cfset position = fieldsPositionQuery.max_position>
		
		<cfreturn {position=position}>
		
	</cffunction>
	

</cfcomponent>
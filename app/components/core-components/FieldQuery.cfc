<!--- Copyright Era7 Information Technologies 2007-2015 --->

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
				SELECT field_type_id, field_type_group, input_type, name, max_length, mysql_type, cf_sql_type
				FROM `#client_abb#_#fieldsTypesTable#`
				WHERE enabled = true
				ORDER BY position ASC;
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
				SELECT field_type_id, field_type_group, input_type, name, mysql_type
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
		<cfargument name="with_table" type="boolean" required="false" default="false">
		<cfargument name="view_id" type="numeric" required="false">
		<cfargument name="only_view_fields" type="boolean" required="false" default="true">
		<cfargument name="with_separators" type="boolean" required="false" default="false">
		<cfargument name="include_in_list" type="boolean" required="false">
		<cfargument name="include_in_row_content" type="boolean" required="false">
		<cfargument name="include_in_new_row" type="boolean" required="false">
		<cfargument name="include_in_update_row" type="boolean" required="false">
		<cfargument name="include_in_all_users" type="boolean" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getTableFields">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfquery name="getTableFieldsQuery" datasource="#client_dsn#">
				SELECT table_fields.*
				<cfif arguments.with_types IS true>
				, fields_types.*
				</cfif>
				<cfif arguments.with_table IS true>
				, tables.area_id, tables.structure_available, tables.general
				</cfif>
				<cfif isDefined("arguments.view_id")>
				, view_fields.view_id, view_fields.position AS view_position
				</cfif>
				FROM `#client_abb#_#tableTypeTable#_fields` AS table_fields
				<cfif arguments.with_types IS true>
				INNER JOIN `#client_abb#_#fieldsTypesTable#` AS fields_types ON table_fields.field_type_id = fields_types.field_type_id
				</cfif>
				<cfif arguments.with_table IS true>
					INNER JOIN `#client_abb#_#tableTypeTable#` AS tables ON table_fields.table_id = tables.id
				</cfif>
				<cfif isDefined("arguments.view_id")>
					<cfif arguments.only_view_fields IS true>INNER<cfelse>LEFT</cfif>
					JOIN `#client_abb#_#tableTypeTable#_views_fields` AS view_fields ON table_fields.field_id = view_fields.field_id AND view_fields.view_id = <cfqueryparam value="#arguments.view_id#" cfsqltype="cf_sql_integer">
				</cfif>
				WHERE table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
				<cfif isDefined("arguments.include_in_list")>
					AND table_fields.include_in_list = <cfqueryparam value="#arguments.include_in_list#" cfsqltype="cf_sql_bit">
				</cfif>
				<cfif isDefined("arguments.include_in_row_content")>
					AND table_fields.include_in_row_content = <cfqueryparam value="#arguments.include_in_row_content#" cfsqltype="cf_sql_bit">
				</cfif>
				<cfif isDefined("arguments.include_in_new_row")>
					AND table_fields.include_in_new_row = <cfqueryparam value="#arguments.include_in_new_row#" cfsqltype="cf_sql_bit">
				</cfif>
				<cfif isDefined("arguments.include_in_update_row")>
					AND table_fields.include_in_update_row = <cfqueryparam value="#arguments.include_in_update_row#" cfsqltype="cf_sql_bit">
				</cfif>
				<cfif isDefined("arguments.include_in_all_users")>
					AND table_fields.include_in_all_users = <cfqueryparam value="#arguments.include_in_all_users#" cfsqltype="cf_sql_bit">
				</cfif>
				<cfif arguments.with_separators IS false>
					AND table_fields.field_type_id != 20
				</cfif>
				<cfif isDefined("arguments.view_id")>
				ORDER BY ISNULL(view_fields.position) ASC, view_fields.position ASC, table_fields.position ASC
				<cfelse>
				ORDER BY table_fields.position ASC
				</cfif>;
			</cfquery>

		<cfreturn getTableFieldsQuery>

	</cffunction>


	<!---getViewFields--->

	<cffunction name="getViewFields" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_types" type="boolean" required="false" default="false">
		<cfargument name="with_table" type="boolean" required="false" default="false">
		<cfargument name="view_id" type="numeric" required="false">
		<cfargument name="with_view_extra_fields" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getTableFields">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getTableFields" returnvariable="getTableFieldsQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="with_types" value="#arguments.with_types#">
				<cfinvokeargument name="with_table" value="#arguments.with_table#">
				<cfinvokeargument name="view_id" value="#arguments.view_id#">
				<cfinvokeargument name="only_view_fields" value="true">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif isDefined("arguments.view_id") AND arguments.with_view_extra_fields IS true>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/ViewQuery" method="getView" returnvariable="getViewQuery">
					<cfinvokeargument name="view_id" value="#arguments.view_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="with_table" value="false"/>
					<cfinvokeargument name="parse_dates" value="false"/>

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif getViewQuery.recordCount GT 0>

					<!--- creation_date --->
					<cfif getViewQuery.include_creation_date IS true>
						<cfset queryAddRow(getTableFieldsQuery, 1)>
						<cfset querySetCell(getTableFieldsQuery, "field_id", "creation_date")>
						<cfset querySetCell(getTableFieldsQuery, "label", "Fecha de creación")>
						<cfset querySetCell(getTableFieldsQuery, "view_position", getViewQuery.creation_date_position)>
					</cfif>

					<!--- last_update_date --->
					<cfif getViewQuery.include_last_update_date IS true>
						<cfset queryAddRow(getTableFieldsQuery, 1)>
						<cfset querySetCell(getTableFieldsQuery, "field_id", "last_update_date")>
						<cfset querySetCell(getTableFieldsQuery, "label", "Fecha de última modificación")>
						<cfset querySetCell(getTableFieldsQuery, "view_position", getViewQuery.last_update_date_position)>
					</cfif>

					<!--- insert_user --->
					<cfif getViewQuery.include_insert_user IS true>
						<cfset queryAddRow(getTableFieldsQuery, 1)>
						<cfset querySetCell(getTableFieldsQuery, "field_id", "insert_user")>
						<cfset querySetCell(getTableFieldsQuery, "label", "Usuario creación")>
						<cfset querySetCell(getTableFieldsQuery, "view_position", getViewQuery.insert_user_position)>
					</cfif>

					<!--- update_user --->
					<cfif getViewQuery.include_update_user IS true>
						<cfset queryAddRow(getTableFieldsQuery, 1)>
						<cfset querySetCell(getTableFieldsQuery, "field_id", "update_user")>
						<cfset querySetCell(getTableFieldsQuery, "label", "Usuario última modificación")>
						<cfset querySetCell(getTableFieldsQuery, "view_position", getViewQuery.update_user_position)>
					</cfif>

					<!--- Order all fields by view_position --->
					<cfquery dbtype="query" name="getTableFieldsQuery">
						SELECT *
						FROM getTableFieldsQuery
						ORDER BY view_position ASC;
					</cfquery>

				</cfif>

			</cfif>

		<cfreturn getTableFieldsQuery>

	</cffunction>



	<!---getFieldsLastPosition--->

	<cffunction name="getFieldLastPosition" output="false" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getFielsLastPosition">
		<cfset var position = 0>

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

				<cfquery name="fieldPositionQuery" datasource="#client_dsn#">
					SELECT MAX(position) AS max_position
					FROM `#client_abb#_#tableTypeTable#_fields` AS tables_fields
					WHERE tables_fields.table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfset position = fieldPositionQuery.max_position>

		<cfreturn {position=position}>

	</cffunction>



	<!--- ------------------------------------ deleteTableFields -----------------------------------  --->

	<cffunction name="deleteTableFields" output="false" access="package" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteTableFields">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getTableFields" returnvariable="fields">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="with_types" value="false">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfloop query="fields">

				<cfquery name="deleteField" datasource="#client_dsn#">
					DELETE FROM `#client_abb#_#tableTypeTable#_fields`
					WHERE field_id = <cfqueryparam value="#fields.field_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfif fields.field_type_id NEQ 9 AND fields.field_type_id NEQ 10><!--- IS NOT SELECT --->

					<cfquery name="deleteFieldFromTable" datasource="#client_dsn#">
						ALTER TABLE `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`
						DROP COLUMN `field_#fields.field_id#`;
					</cfquery>

				</cfif>

			</cfloop>

	</cffunction>


</cfcomponent>

<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "ActionQuery">


	<!---getTableActions--->

	<cffunction name="getTableActions" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="action_event_type_id" type="numeric" required="false">
		<cfargument name="with_table" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getTableActions">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfquery name="getTableActionsQuery" datasource="#client_dsn#">
				SELECT table_actions.*,
				CONCAT_WS(' ', insert_users.family_name, insert_users.name) AS insert_user_full_name, insert_users.image_type AS insert_user_image_type,
				CONCAT_WS(' ', update_users.family_name, update_users.name) AS update_user_full_name, update_users.image_type AS update_user_image_type
				<cfif arguments.with_table IS true>
				, tables.area_id
				</cfif>
				FROM `#client_abb#_#tableTypeTable#_actions` AS table_actions
				LEFT JOIN #client_abb#_users AS insert_users ON table_actions.insert_user_id = insert_users.id
				LEFT JOIN #client_abb#_users AS update_users ON table_actions.last_update_user_id = update_users.id
				<cfif arguments.with_table IS true>
					INNER JOIN `#client_abb#_#tableTypeTable#` AS tables ON table_actions.table_id = tables.id
				</cfif>
				WHERE table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
				<cfif isDefined("arguments.action_event_type_id")>
					AND action_event_type_id = <cfqueryparam value="#arguments.action_event_type_id#" cfsqltype="cf_sql_integer">
				</cfif>
				;
			</cfquery>

		<cfreturn getTableActionsQuery>

	</cffunction>


	<!---setActionLastSuccessExecution--->

	<cffunction name="setActionLastSuccessExecution" output="false" returntype="void" access="public">
		<cfargument name="action_id" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "setActionLastSuccessExecution">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfquery name="setActionLastExecution" datasource="#client_dsn#">
				UPDATE `#client_abb#_#tableTypeTable#_actions`
				SET
				last_success_execution_row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">,
				last_success_execution_date = NOW()
				WHERE action_id = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">
				;
			</cfquery>

	</cffunction>


	<!---getAction--->

	<cffunction name="getAction" output="false" returntype="query" access="public">
		<cfargument name="action_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_table" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getAction">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfquery name="getActionQuery" datasource="#client_dsn#">
				SELECT table_actions.*
				<cfif arguments.with_table IS true>
				, tables.area_id
				</cfif>
				FROM `#client_abb#_#tableTypeTable#_actions` AS table_actions
				<cfif arguments.with_table IS true>
					INNER JOIN `#client_abb#_#tableTypeTable#` AS tables ON table_actions.table_id = tables.id
				</cfif>
				WHERE action_id = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">
				;
			</cfquery>

		<cfreturn getActionQuery>

	</cffunction>


	<!---getActionFields--->

	<cffunction name="getActionFields" output="false" returntype="query" access="public">
		<cfargument name="action_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getActionFields">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfquery name="getActionFieldsQuery" datasource="#client_dsn#">
				SELECT table_actions_fields.*, fields.field_type_id
				FROM `#client_abb#_#tableTypeTable#_actions_fields` AS table_actions_fields
				INNER JOIN `#client_abb#_#tableTypeTable#_fields` AS fields
				ON fields.field_id = table_actions_fields.field_id
				WHERE action_id = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

		<cfreturn getActionFieldsQuery>

	</cffunction>


	<!--- ------------------------------------ deleteTableActions -----------------------------------  --->

	<cffunction name="deleteTableActions" output="false" access="package" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteTableActions">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/ActionQuery" method="getTableActions" returnvariable="actions">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfloop query="actions">

				<cfquery name="deleteAction" datasource="#client_dsn#">
					DELETE FROM `#client_abb#_#tableTypeTable#_actions`
					WHERE action_id = <cfqueryparam value="#actions.action_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

			</cfloop>

	</cffunction>

</cfcomponent>

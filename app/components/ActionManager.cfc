<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">
	
	<cfset component = "ActionManager">


	<!--- ------------------------------------- createAction -------------------------------------  --->
	
	<cffunction name="createAction" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="action_type_id" type="numeric" required="true">
		<cfargument name="action_event_type_id" type="numeric" required="true">
		<cfargument name="action_subject" type="string" required="true">
		<cfargument name="action_content" type="string" required="true">
		<cfargument name="action_content_with_row" type="boolean" required="false" default="false">
		<cfargument name="title" type="string" required="true">
		<cfargument name="action_field_id" type="numeric" required="true">

		<cfset var method = "createAction">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var action_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="TableManager" method="getTable" returnvariable="getTableResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>
			
			<cfif getTableResponse.result IS false>
				<cfreturn getTableResponse>
			</cfif>

			<cfset table = getTableResponse.table>

			<cfset area_id = table.area_id>

			<!---checkAreaResponsibleAccess--->
			<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>

			<cfset arguments.title = trim(arguments.title)>

			<cftransaction>

				<cfquery name="createAction" datasource="#client_dsn#">
					INSERT INTO `#client_abb#_#tableTypeTable#_actions`
					SET table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">,
					action_type_id = <cfqueryparam value="#arguments.action_type_id#" cfsqltype="cf_sql_integer">,
					action_event_type_id = <cfqueryparam value="#arguments.action_event_type_id#" cfsqltype="cf_sql_integer">,
					title = <cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
					action_subject = <cfqueryparam value="#arguments.action_subject#" cfsqltype="cf_sql_varchar">,
					action_content = <cfqueryparam value="#arguments.action_content#" cfsqltype="cf_sql_longvarchar">,
					action_content_with_row = <cfqueryparam value="#arguments.action_content_with_row#" cfsqltype="cf_sql_bit">,
					insert_user_id = <cfqueryparam value="#SESSION.user_id#" cfsqltype="cf_sql_integer">,
					creation_date = NOW()
					;
				</cfquery>

				<cfquery name="getLastInsertId" datasource="#client_dsn#">
					SELECT LAST_INSERT_ID() AS last_insert_id FROM `#client_abb#_#tableTypeTable#_actions`;
				</cfquery>

				<cfset action_id = getLastInsertId.last_insert_id>

				<cfquery name="insertActionField" datasource="#client_dsn#">
					INSERT INTO `#client_abb#_#tableTypeTable#_actions_fields`
					SET action_id = <cfqueryparam value="#action_id#" cfsqltype="cf_sql_integer">,
					field_id = <cfqueryparam value="#arguments.action_field_id#" cfsqltype="cf_sql_integer">
					;
				</cfquery>

			</cftransaction>

			<cfinclude template="includes/logRecord.cfm">
			
			<cfset response = {result=true, action_id=#action_id#, table_id=#arguments.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- updateAction -------------------------------------  --->
	
	<cffunction name="updateAction" output="false" access="public" returntype="struct">
		<cfargument name="action_id" type="numeric" required="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="action_type_id" type="numeric" required="true">
		<cfargument name="action_event_type_id" type="numeric" required="true">
		<cfargument name="action_subject" type="string" required="true">
		<cfargument name="action_content" type="string" required="true">
		<cfargument name="action_content_with_row" type="boolean" required="false" default="false">
		<cfargument name="title" type="string" required="true">
		<cfargument name="action_field_id" type="numeric" required="true">

		<cfset var method = "updateAction">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="TableManager" method="getTable" returnvariable="getTableResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>
			
			<cfif getTableResponse.result IS false>
				<cfreturn getTableResponse>
			</cfif>

			<cfset table = getTableResponse.table>

			<cfset area_id = table.area_id>

			<!---checkAreaResponsibleAccess--->
			<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>

			<cfset arguments.title = trim(arguments.title)>

			<cftransaction>

				<cfquery name="createAction" datasource="#client_dsn#">
					UPDATE `#client_abb#_#tableTypeTable#_actions`
					SET 
					action_type_id = <cfqueryparam value="#arguments.action_type_id#" cfsqltype="cf_sql_integer">,
					action_event_type_id = <cfqueryparam value="#arguments.action_event_type_id#" cfsqltype="cf_sql_integer">,
					title = <cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
					action_subject = <cfqueryparam value="#arguments.action_subject#" cfsqltype="cf_sql_varchar">,
					action_content = <cfqueryparam value="#arguments.action_content#" cfsqltype="cf_sql_longvarchar">,
					action_content_with_row = <cfqueryparam value="#arguments.action_content_with_row#" cfsqltype="cf_sql_bit">,
					last_update_user_id = <cfqueryparam value="#SESSION.user_id#" cfsqltype="cf_sql_integer">,
					last_update_date = NOW()
					WHERE action_id = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">
					;
				</cfquery>

				<cfquery name="deleteActionField" datasource="#client_dsn#">
					DELETE 
					FROM `#client_abb#_#tableTypeTable#_actions_fields`
					WHERE action_id = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfquery name="insertActionField" datasource="#client_dsn#">
					INSERT INTO `#client_abb#_#tableTypeTable#_actions_fields`
					SET action_id = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">,
					field_id = <cfqueryparam value="#arguments.action_field_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

			</cftransaction>

			<cfinclude template="includes/logRecord.cfm">
		
			<cfset response = {result=true, action_id=#arguments.action_id#, table_id=#arguments.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- copyTableActions -------------------------------------  --->
	
	<!---<cffunction name="copyTableActions" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="copy_from_table_id" type="numeric" required="true">
		<cfargument name="actions_ids" type="array" required="true">

		<cfset var method = "copyTableActions">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var actions = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<!---Table--->
			<cfinvoke component="TableManager" method="getTable" returnvariable="getTableResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>
			
			<cfif getTableResponse.result IS false>
				<cfreturn getTableResponse>
			</cfif>

			<cfset area_id = getTableResponse.table.area_id>

			<!---checkAreaResponsibleAccess--->
			<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>

			<!---Table actions to copy--->
			<cfinvoke component="TableManager" method="getTableActions" returnvariable="getActionsResponse">
				<cfinvokeargument name="table_id" value="#arguments.copy_from_table_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="with_types" value="true">
			</cfinvoke>

			<cfif getActionsResponse.result IS false>
				<cfreturn getActionsResponse>
			</cfif>

			<cfset actions = getActionsResponse.tableActions>

			<cftransaction>

				<cfloop query="actions">

					<cfif arrayFind(arguments.actions_ids, actions.action_id)>
						
						<cfinvoke component="ActionManager" method="createActionInDatabase" returnvariable="action_id">
							<cfinvokeargument name="table_id" value="#arguments.table_id#">
							<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
							<cfinvokeargument name="action_type_id" value="#actions.action_type_id#">
							<cfinvokeargument name="label" value="#actions.label#">
							<cfinvokeargument name="description" value="#actions.description#">
							<cfinvokeargument name="required" value="#actions.required#">
							<cfinvokeargument name="sort_by_this" value="#actions.sort_by_this#">
							<cfinvokeargument name="default_value" value="#actions.default_value#">
							<cfinvokeargument name="mysql_type" value="#actions.mysql_type#">
							<cfif isNumeric(actions.list_area_id)>
								<cfinvokeargument name="list_area_id" value="#actions.list_area_id#"/>
							</cfif>
							<cfinvokeargument name="action_input_type" value="#actions.action_input_type#">
							<cfif isNumeric(actions.item_type_id)>
								<cfinvokeargument name="item_type_id" value="#actions.item_type_id#">
							</cfif>
							<cfif len(actions.list_values) GT 0>
								<cfinvokeargument name="list_values" value="#actions.list_values#">
							</cfif>
						</cfinvoke>

					</cfif>
					
				</cfloop>

			</cftransaction>
			
			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, table_id=#arguments.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>--->


	<!--- ------------------------------------- deleteAction -------------------------------------  --->
	
	<cffunction name="deleteAction" output="false" access="public" returntype="struct">
		<cfargument name="action_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "deleteAction">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="ActionManager" method="getAction" returnvariable="getActionResponse">
				<cfinvokeargument name="action_id" value="#arguments.action_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="with_table" value="true"/>
			</cfinvoke>

			<cfif getActionResponse.result IS false>
				<cfreturn getActionResponse>
			</cfif>

			<cfset action = getActionResponse.action>

			<cfset area_id = action.area_id>

			<!---checkAreaResponsibleAccess--->
			<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>

			<cftransaction>

				<cfquery name="deleteAction" datasource="#client_dsn#">
					DELETE FROM `#client_abb#_#tableTypeTable#_actions`
					WHERE action_id = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

			</cftransaction>
			
			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, action_id=#arguments.action_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>



	<!--- ------------------------------------ deleteTableActions -----------------------------------  --->
		
	<cffunction name="deleteTableActions" output="false" access="package" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "deleteTableActions">
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/ActionQuery" method="deleteTableActions">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
	</cffunction>



	<!--- ------------------------------------- getAction -------------------------------------  --->
	
	<cffunction name="getAction" output="false" access="public" returntype="struct">
		<cfargument name="action_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_type" type="boolean" required="false">

		<cfset var method = "getAction">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ActionQuery" method="getAction" returnvariable="getActionQuery">
				<cfinvokeargument name="action_id" value="#arguments.action_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="with_table" value="true"/>
				<cfif isDefined("arguments.with_type")>
					<cfinvokeargument name="with_type" value="#arguments.with_type#"/>		
				</cfif>
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfif getActionQuery.recordCount GT 0>

				<cfset area_id = getActionQuery.area_id>

				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

				<cfset response = {result=true, action=#getActionQuery#}>

			<cfelse><!---Item does not exist--->
			
				<cfset error_code = 501>
			
				<cfthrow errorcode="#error_code#">

			</cfif>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- getEmptyAction -------------------------------------  --->
	
	<cffunction name="getEmptyAction" output="false" access="public" returntype="struct">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getEmptyAction">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfquery name="getActionQuery" datasource="#client_dsn#">
				SELECT *
				FROM #client_abb#_#tableTypeTable#_actions
				WHERE action_id = -1;
			</cfquery>

			<cfset response = {result=true, action=#getActionQuery#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>




	<!--- ------------------------------------- getActionTypes -------------------------------------  --->
	
	<cffunction name="getActionTypes" output="false" access="public" returntype="struct">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getActionTypes">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ActionManager" method="getActionTypesStruct" returnvariable="getActionTypesStruct">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<!---<cfinvokeargument name="client_dsn" value="#client_dsn#">--->
			</cfinvoke>

			<cfset response = {result=true, actionTypes=getActionTypesStruct}>
								
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>



	<!--- ------------------------------------- getActionType -------------------------------------  --->
	
	<cffunction name="getActionType" output="false" access="public" returntype="struct">
		<cfargument name="action_type_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getActionType">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ActionQuery" method="getActionType" returnvariable="getActionTypeQuery">
				<cfinvokeargument name="action_type_id" value="#arguments.action_type_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfif getActionTypeQuery.recordCount GT 0>

				<cfset response = {result=true, actionType=#getActionTypeQuery#}>

			<cfelse><!---Item does not exist--->
			
				<cfset error_code = 501>
			
				<cfthrow errorcode="#error_code#">

			</cfif>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- getActionFields -------------------------------------  --->
	
	<cffunction name="getActionFields" output="false" access="public" returntype="struct">
		<cfargument name="action_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getActionFields">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ActionQuery" method="getActionFields" returnvariable="getActionFieldsQuery">
				<cfinvokeargument name="action_id" value="#arguments.action_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, actionFields=#getActionFieldsQuery#}>
			
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


</cfcomponent>
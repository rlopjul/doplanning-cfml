<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">
	
	<cfset component = "ViewManager">

	<!--- <cfset timeZoneTo = "+1:00"> --->
	<cfset timeZoneTo = "Europe/Madrid">


	<!--- ------------------------------------- createView -------------------------------------  --->
	
	<cffunction name="createView" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="fields_ids" type="array" required="true">
		<cfargument name="include_creation_date" type="boolean" required="false" default="false">
		<cfargument name="include_last_update_date" type="boolean" required="false" default="false">
		<cfargument name="include_insert_user" type="boolean" required="false" default="false">
		<cfargument name="include_update_user" type="boolean" required="false" default="false">
		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_hour" type="numeric" required="false">
		<cfargument name="publication_minute" type="numeric" required="false">
		<cfargument name="publication_validated" type="boolean" required="false" default="false">

		<cfset var method = "createView">

		<cfset var response = structNew()>

		<cfset var table_area_id = "">
		<cfset var view_id = "">
		<cfset var isUserPublicationAreaResponsible = false>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<!--- getTable --->
			<cfinvoke component="TableManager" method="getTable" returnvariable="getTableResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			</cfinvoke>
			
			<cfif getTableResponse.result IS false>
				<cfreturn getTableResponse>
			</cfif>

			<cfset table = getTableResponse.table>

			<cfset table_area_id = table.area_id>

			<!---checkAreaResponsibleAccess--->
			<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
				<cfinvokeargument name="area_id" value="#table_area_id#">
			</cfinvoke>

			<!---checkAreaAccess--->
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAreaAccess">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>

			<!--- checkScope --->
			<cfif APPLICATION.publicationScope IS true AND isNumeric(table.publication_scope_id)>
				
				<cfinvoke component="ScopeManager" method="isAreaInScope" returnvariable="isInScopeResult">
					<cfinvokeargument name="scope_id" value="#table.publication_scope_id#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

				<cfif isInScopeResult.result IS false>

					<cfset response = {result=false, view_id=#view_id#, table_id=#arguments.table_id#, message="El ámbito definido no permite publicar esta vista en esta área"}>
					
					<cfreturn response>
					
				</cfif>

			</cfif>	

			<cfif APPLICATION.publicationValidation IS true AND arguments.publication_validated IS true>

				<!--- isUserPublicationAreaResponsible --->
				<cfinvoke component="AreaManager" method="isUserAreaResponsible" returnvariable="isUserPublicationAreaResponsible">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

			</cfif>	

			<cfset arguments.title = trim(arguments.title)>

			<cftransaction>

				<!---<cfinvoke component="ViewManager" method="createViewInDatabase" returnvariable="view_id">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="title" value="#arguments.title#">
					<cfinvokeargument name="description" value="#arguments.description#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>--->

				<cfquery name="createView" datasource="#client_dsn#">
					INSERT INTO `#client_abb#_#itemTypeTable#`
					SET table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">,
					user_in_charge = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
					area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">,
					title = <cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
					description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">, 
					<cfif isDefined("arguments.publication_date") AND len(arguments.publication_date) GT 0>
						 publication_date = CONVERT_TZ(STR_TO_DATE(<cfqueryparam value="#arguments.publication_date# #arguments.publication_hour#:#arguments.publication_minute#" cfsqltype="cf_sql_varchar">,'%d-%m-%Y %H:%i'), '#timeZoneTo#', 'SYSTEM'),
					</cfif>
					<!--- publicationValidation --->
					<cfif APPLICATION.publicationValidation IS true>
						<cfif arguments.publication_validated IS true AND isUserPublicationAreaResponsible IS true>
							publication_validated = <cfqueryparam value="true" cfsqltype="cf_sql_bit">,
							publication_validated_user = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
							publication_validated_date = NOW(), 						
						<cfelse>
							publication_validated = <cfqueryparam value="false" cfsqltype="cf_sql_bit">,
						</cfif>												
					</cfif>
					<cfloop list="creation_date,last_update_date,insert_user,update_user" index="field_name">
						include_#field_name# = <cfqueryparam value="#arguments["include_#field_name#"]#" cfsqltype="cf_sql_bit">,
						#field_name#_position = <cfqueryparam value="#arguments["#field_name#_position"]#" cfsqltype="cf_sql_integer">, 
						<!--- <cfif field_name NEQ "update_user">,</cfif> --->
					</cfloop>
					creation_date = NOW();
				</cfquery>

				<cfquery name="getLastInsertId" datasource="#client_dsn#">
					SELECT LAST_INSERT_ID() AS last_insert_id FROM `#client_abb#_#itemTypeTable#`;
				</cfquery>

				<cfset view_id = getLastInsertId.last_insert_id>

				<!---getItemLastPosition--->
				<cfinvoke component="AreaItemManager" method="getAreaItemsLastPosition" returnvariable="viewLastPosition">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>
				
				<cfset viewPostion = viewLastPosition+1>

				<cfinvoke component="AreaItemManager" method="insertAreaItemPosition">
					<cfinvokeargument name="item_id" value="#view_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="position" value="#viewPostion#">
				</cfinvoke>

				<cfinvoke component="ViewManager" method="addFieldsToView" argumentcollection="#arguments#">
					<cfinvokeargument name="view_id" value="#view_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<!---<cfinvokeargument name="fields_ids" value="#arguments.fields_ids#">--->
				</cfinvoke>

			</cftransaction>

			<cfinclude template="includes/logRecord.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/ViewQuery" method="getView" returnvariable="getViewQuery">
				<cfinvokeargument name="view_id" value="#view_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="with_table" value="false"/>
				<cfinvokeargument name="parse_dates" value="true"/>
				<cfinvokeargument name="published" value="false">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif getViewQuery.recordCount GT 0>

				<!--- Alert --->
				<cfinvoke component="AlertManager" method="newAreaItem">
					<cfinvokeargument name="objectItem" value="#getViewQuery#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="action" value="new">
				</cfinvoke>

			<cfelse><!---Item does not exist--->
			
				<cfset error_code = 501>
			
				<cfthrow errorcode="#error_code#">

			</cfif>
			
			<cfset response = {result=true, view_id=#view_id#, table_id=#arguments.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- addFieldsToView -------------------------------------  --->

	<!---IMPORTANTE: La llamada a esta función tiene que hacerse dentro de una transacción <cftransaction>--->
	
	<cffunction name="addFieldsToView" output="false" access="package" returntype="void">
		<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="fields_ids" type="array" required="true">

		<cfset var method = "addFieldsToView">

		<cfset var field_id = "">
		<cfset var field_position = 0>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfloop array="#arguments.fields_ids#" index="field_id">

				<cfset field_position = arguments["field_#field_id#_position"]>

				<cfquery name="addFieldsToView" datasource="#client_dsn#">
					INSERT INTO `#client_abb#_#tableTypeTable#_views_fields`
					SET view_id = <cfqueryparam value="#arguments.view_id#" cfsqltype="cf_sql_integer">,
					field_id = <cfqueryparam value="#field_id#" cfsqltype="cf_sql_integer">,
					position = <cfqueryparam value="#field_position#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<!---<cfset field_position = field_position+1>--->

			</cfloop>

			
	</cffunction>


	<!--- ------------------------------------- updateView -------------------------------------  --->
	
	<cffunction name="updateView" output="false" access="public" returntype="struct">
		<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="fields_ids" type="array" required="true">
		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_hour" type="numeric" required="false">
		<cfargument name="publication_minute" type="numeric" required="false">
		<cfargument name="publication_validated" type="boolean" required="false" default="false">

		<cfset var method = "updateView">

		<cfset var response = structNew()>

		<cfset var table_area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<!--- getView --->
			<cfinvoke component="ViewManager" method="getView" returnvariable="getViewResponse">
				<cfinvokeargument name="view_id" value="#arguments.view_id#"/>
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#"/>
				<cfinvokeargument name="with_table" value="true"/>
				<cfinvokeargument name="parse_dates" value="true"/>
			</cfinvoke>

			<cfif getViewResponse.result IS false>
				<cfreturn getViewResponse>
			</cfif>

			<cfset view = getViewResponse.view>

			<cfset table_area_id = view.table_area_id>

			<!---checkAreaResponsibleAccess--->
			<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
				<cfinvokeargument name="area_id" value="#table_area_id#">
			</cfinvoke>

			<!---checkAreaAccess--->
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAreaAccess">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>

			<!--- checkScope --->
			<cfif APPLICATION.publicationScope IS true AND isNumeric(view.table_publication_scope_id)>
				
				<cfinvoke component="ScopeManager" method="isAreaInScope" returnvariable="isInScopeResult">
					<cfinvokeargument name="scope_id" value="#view.table_publication_scope_id#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

				<cfif isInScopeResult.result IS false>

					<cfset response = {result=false, view_id=#arguments.view_id#, table_id=#view.table_id#, message="El ámbito definido no permite publicar esta vista en esta área"}>
					
					<cfreturn response>
					
				</cfif>

			</cfif>	

			<cfif APPLICATION.publicationValidation IS true>

				<!--- isUserPublicationAreaResponsible --->
				<cfinvoke component="AreaManager" method="isUserAreaResponsible" returnvariable="isUserPublicationAreaResponsible">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

			</cfif>		

			<cfset arguments.title = trim(arguments.title)>

			<cftransaction>

				<cfquery name="updateView" datasource="#client_dsn#">
					UPDATE `#client_abb#_#itemTypeTable#`
					SET	area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">,
					title = <cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
					description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">,
					last_update_date = NOW()
					<cfif isDefined("arguments.publication_date") AND len(arguments.publication_date) GT 0>
						, publication_date = CONVERT_TZ(STR_TO_DATE(<cfqueryparam value="#arguments.publication_date# #arguments.publication_hour#:#arguments.publication_minute#" cfsqltype="cf_sql_varchar">,'%d-%m-%Y %H:%i'), '#timeZoneTo#', 'SYSTEM')
					</cfif>
					<!--- publicationValidation --->
					<cfif APPLICATION.publicationValidation IS true AND isUserPublicationAreaResponsible IS true>
						, publication_validated = <cfqueryparam value="#arguments.publication_validated#" cfsqltype="cf_sql_bit">
						<cfif arguments.publication_validated IS true AND view.publication_validated IS false>
							, publication_validated_user = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
							, publication_validated_date = NOW()						
						</cfif>
					</cfif>
					<cfloop list="creation_date,last_update_date,insert_user,update_user" index="field_name">
						, include_#field_name# = <cfqueryparam value="#arguments["include_#field_name#"]#" cfsqltype="cf_sql_bit">,
						#field_name#_position = <cfqueryparam value="#arguments["#field_name#_position"]#" cfsqltype="cf_sql_integer">
					</cfloop>
					WHERE id = <cfqueryparam value="#arguments.view_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<!--- Delete old selected values --->
				<cfquery name="deleteRowAreas" datasource="#client_dsn#">
					DELETE FROM `#client_abb#_#itemTypeTable#_fields`
					WHERE view_id = <cfqueryparam value="#arguments.view_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfinvoke component="ViewManager" method="addFieldsToView" argumentcollection="#arguments#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<!---<cfinvokeargument name="view_id" value="#arguments.view_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="fields_ids" value="#arguments.fields_ids#">--->
				</cfinvoke>

			</cftransaction>

			<cfinclude template="includes/logRecord.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/ViewQuery" method="getView" returnvariable="getViewQuery">
				<cfinvokeargument name="view_id" value="#view_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="with_table" value="false"/>
				<cfinvokeargument name="parse_dates" value="true"/>
				<cfinvokeargument name="published" value="false">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif getViewQuery.recordCount GT 0>

				<cfif view.area_id NEQ arguments.area_id><!--- Area changed --->

					<!--- Alert --->
					<cfinvoke component="AlertManager" method="newAreaItem">
						<cfinvokeargument name="objectItem" value="#view#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="action" value="delete">
					</cfinvoke>
					
					<!--- Alert --->
					<cfinvoke component="AlertManager" method="newAreaItem">
						<cfinvokeargument name="objectItem" value="#getViewQuery#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="action" value="new">
					</cfinvoke>

				<cfelse>

					<!--- Alert --->
					<cfinvoke component="AlertManager" method="newAreaItem">
						<cfinvokeargument name="objectItem" value="#getViewQuery#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="action" value="update">
					</cfinvoke>

				</cfif>

			<cfelse><!---Item does not exist--->
			
				<cfset error_code = 501>
			
				<cfthrow errorcode="#error_code#">

			</cfif>
		
			<cfset response = {result=true, view_id=#arguments.view_id#, table_id=#view.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	
	<!--- ------------------------------------- deleteView -------------------------------------  --->
	
	<cffunction name="deleteView" output="false" access="public" returntype="struct">
		<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="with_transaction" type="boolean" required="false" default="true">

		<cfset var method = "deleteView">

		<cfset var response = structNew()>

		<cfset var table_area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<!--- checkAreaAccess in getView --->
			<cfinvoke component="ViewManager" method="getView" returnvariable="getViewResponse">
				<cfinvokeargument name="view_id" value="#arguments.view_id#"/>
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#"/>
				<cfinvokeargument name="with_table" value="true"/>
				<cfinvokeargument name="parse_dates" value="true">
			</cfinvoke>

			<cfif getViewResponse.result IS false>
				<cfreturn getViewResponse>
			</cfif>

			<cfset view = getViewResponse.view>

			<cfset table_area_id = view.table_area_id>

			<!---checkAreaResponsibleAccess--->
			<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
				<cfinvokeargument name="area_id" value="#table_area_id#">
			</cfinvoke>

			<!--- deleteView --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ViewManager" method="deleteView" returnvariable="response">
				<cfinvokeargument name="view_id" value="#arguments.view_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="with_transaction" value="#arguments.with_transaction#">

				<cfinvokeargument name="viewQuery" value="#view#">
				<cfinvokeargument name="user_id" value="#SESSION.user_id#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<!---
			<cftry>
				
				<cfif arguments.with_transaction IS true>
					
					<!--- <cftransaction> --->
					<cfquery datasource="#client_dsn#" name="startTransaction">
						START TRANSACTION;
					</cfquery>

				</cfif>
			
				<!---DELETE ITEM POSITION--->
				<cfinvoke component="AreaItemManager" method="deleteItemPosition">
					<cfinvokeargument name="item_id" value="#arguments.view_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				</cfinvoke>

				<cfquery name="deleteView" datasource="#client_dsn#">
					DELETE FROM `#client_abb#_#itemTypeTable#`
					WHERE id = <cfqueryparam value="#arguments.view_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfif arguments.with_transaction IS true>
					<!--- </cftransaction> --->
					<cfquery datasource="#client_dsn#" name="endTransaction">
						COMMIT;
					</cfquery>
				</cfif>

				<cfcatch>

					<cfif arguments.with_transaction IS true>
						<cfquery datasource="#client_dsn#" name="rollbackTransaction">
							ROLLBACK;
						</cfquery>
					</cfif>

					<cfrethrow/>

				</cfcatch>

			</cftry>
			
			<cfinclude template="includes/logRecord.cfm">

			<!--- Alert --->
			<cfinvoke component="AlertManager" method="newAreaItem">
				<cfinvokeargument name="objectItem" value="#view#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="action" value="delete">
			</cfinvoke>

			<cfset response = {result=true, view_id=#arguments.view_id#}>--->

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>

		
	<!---

	<cffunction name="deleteTableViews" output="false" access="package" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "deleteTableViews">
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/ViewQuery" method="getTableViews" returnvariable="getTableViewsQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="with_table" value="true">
				<cfinvokeargument name="parse_dates" value="true">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif getTableViewsQuery.recordCount GT 0>

				<cfloop query="getTableViewsQuery">
					
					<cfinvoke component="ViewManager" method="deleteView" returnvariable="deleteViewResponse">
						<cfinvokeargument name="view_id" value="#getTableViewsQuery.view_id#">
						<cfinvokeargument name="itemTypeId" value="#viewTypeId#">
						<cfinvokeargument name="with_transaction" value="false">
					</cfinvoke>

					<cfif deleteViewResponse.result IS false>
						
						<cfthrow message="#deleteViewResponse.message#">

					</cfif>

				</cfloop>

			</cfif>
			<!---<cfquery name="deleteViews" datasource="#client_dsn#">
				DELETE FROM `#client_abb#_#tableTypeTable#_views`
				WHERE table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">;
			</cfquery>--->

	</cffunction>

	--->



	<!--- ------------------------------------- getView -------------------------------------  --->
	
	<cffunction name="getView" output="false" access="public" returntype="struct">
		<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_table" type="boolean" required="false" default="false">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">

		<cfset var method = "getView">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ViewQuery" method="getView" returnvariable="getViewQuery">
				<cfinvokeargument name="view_id" value="#arguments.view_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="with_table" value="#arguments.with_table#"/>
				<cfinvokeargument name="parse_dates" value="#arguments.parse_dates#"/>
				<cfinvokeargument name="published" value="false">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfif getViewQuery.recordCount GT 0>

				<cfset area_id = getViewQuery.area_id>

				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

				<cfset response = {result=true, view=#getViewQuery#}>

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


	<!--- ------------------------------------- getEmptyView -------------------------------------  --->
	
	<cffunction name="getEmptyView" output="false" access="public" returntype="struct">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getEmptyView">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfquery name="getViewQuery" datasource="#client_dsn#">
				SELECT *
				FROM #client_abb#_#tableTypeTable#_views
				WHERE id = -1;
			</cfquery>

			<cfset queryAddRow(getViewQuery, 1)>
			<cfset querySetCell(getViewQuery, "publication_date", DateFormat(now(), "DD-MM-YYYY")&" "&TimeFormat(now(), "HH:mm:ss"))>
			<cfset querySetCell(getViewQuery, "publication_validated", true)>

			<cfset response = {result=true, view=#getViewQuery#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- getViewFields -------------------------------------  --->
	
	<cffunction name="getViewFields" output="false" access="public" returntype="struct">
		<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_types" type="boolean" required="false" default="false">
		<cfargument name="with_view_extra_fields" type="boolean" required="false" default="false">

		<cfset var method = "getViewFields">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!--- checkAreaAccess in getView --->
			<cfinvoke component="ViewManager" method="getView" returnvariable="getViewResponse">
				<cfinvokeargument name="view_id" value="#arguments.view_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="with_table" value="true"/>
			</cfinvoke>

			<cfif getViewResponse.result IS false>
				<cfreturn getViewResponse>
			</cfif>

			<cfset view = getViewResponse.view>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getViewFields" returnvariable="getTableFieldsQuery">
				<cfinvokeargument name="table_id" value="#view.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="with_types" value="#arguments.with_types#">
				<cfinvokeargument name="with_table" value="true">
				<cfinvokeargument name="view_id" value="#arguments.view_id#">
				<cfinvokeargument name="with_view_extra_fields" value="#arguments.with_view_extra_fields#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, tableFields=getTableFieldsQuery}>
								
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>
	

</cfcomponent>
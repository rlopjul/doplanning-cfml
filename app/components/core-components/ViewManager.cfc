<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">
	
	<cfset component = "ViewManager">


	<!--- ------------------------------------- deleteView -------------------------------------  --->
	
	<cffunction name="deleteView" output="false" access="public" returntype="struct">
		<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="with_transaction" type="boolean" required="false" default="true">

		<cfargument name="viewQuery" type="query" required="false">
		<cfargument name="user_id" type="numeric" required="false">

		<cfargument name="send_alert" type="boolean" required="false" default="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteView">

		<cfset var response = structNew()>

		<cfset var table_area_id = "">

		<cftry>
			
			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfif NOT isDefined("arguments.viewQuery")>
				
				<cfinvoke component="#APPLICATION.coreComponentsPath#/ViewQuery" method="getView" returnvariable="viewQuery">
					<cfinvokeargument name="view_id" value="#arguments.view_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="with_table" value="false"/>
					<cfinvokeargument name="parse_dates" value="true"/>
					<cfinvokeargument name="published" value="false">
					
					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>
				
				<cfif viewQuery.recordCount IS 0><!---Item does not exist--->
			
					<cfset error_code = 501>
				
					<cfthrow errorcode="#error_code#">

				</cfif>

			</cfif>

			<!--- checkAreaAccess in getView --->
			<!---<cfinvoke component="ViewManager" method="getView" returnvariable="getViewResponse">
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

			--->

			<cftry>
				
				<cfif arguments.with_transaction IS true>
					
					<!--- <cftransaction> --->
					<cfquery datasource="#client_dsn#" name="startTransaction">
						START TRANSACTION;
					</cfquery>

				</cfif>
			
				<!---DELETE ITEM POSITION--->
				<!---<cfinvoke component="AreaItemManager" method="deleteItemPosition">
					<cfinvokeargument name="item_id" value="#arguments.view_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				</cfinvoke>--->

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="deleteItemPosition">
					<cfinvokeargument name="item_id" value="#arguments.view_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
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

			<cfif arguments.send_alert IS true>

				<!--- Alert --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newAreaItem">
					<cfinvokeargument name="objectItem" value="#viewQuery#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="action" value="delete">
					
					<cfinvokeargument name="user_id" value="#arguments.user_id#">
					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

			</cfif>

			<cfset response = {result=true, view_id=#arguments.view_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>



	<!--- ------------------------------------ sendAlertDeleteTableViews -----------------------------------  --->
		
	<cffunction name="sendAlertDeleteTableViews" output="false" access="public" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="user_id" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "sendAlertDeleteTableViews">
			
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

					<cfinvoke component="#APPLICATION.coreComponentsPath#/ViewQuery" method="getView" returnvariable="viewQuery">
						<cfinvokeargument name="view_id" value="#getTableViewsQuery.view_id#">
						<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
						<cfinvokeargument name="with_table" value="false"/>
						<cfinvokeargument name="parse_dates" value="true"/>
						<cfinvokeargument name="published" value="false">
						
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>
					
					<!--- Alert --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newAreaItem">
						<cfinvokeargument name="objectItem" value="#viewQuery#">
						<cfinvokeargument name="itemTypeId" value="#viewTypeId#">
						<cfinvokeargument name="action" value="delete">
						<cfinvokeargument name="user_id" value="#arguments.user_id#">
						
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

				</cfloop>

			</cfif>

	</cffunction>


	<!--- ------------------------------------ deleteTableViews -----------------------------------  --->
		
	<cffunction name="deleteTableViews" output="false" access="public" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="user_id" type="numeric" required="false">

		<cfargument name="send_alert" type="boolean" required="false" default="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteTableViews">
			
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
					
					<cfinvoke component="#APPLICATION.coreComponentsPath#/ViewManager" method="deleteView" returnvariable="deleteViewResponse">
						<cfinvokeargument name="view_id" value="#getTableViewsQuery.view_id#">
						<cfinvokeargument name="itemTypeId" value="#viewTypeId#">
						<cfinvokeargument name="with_transaction" value="false">

						<cfinvokeargument name="user_id" value="#arguments.user_id#">

						<cfinvokeargument name="send_alert" value="#arguments.send_alert#">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfif deleteViewResponse.result IS false>
						
						<cfthrow message="#deleteViewResponse.message#">

					</cfif>

				</cfloop>

			</cfif>

	</cffunction>




</cfcomponent>
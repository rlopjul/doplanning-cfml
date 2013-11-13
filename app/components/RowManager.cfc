<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">
	
	<cfset component = "RowManager">

	<cfset dateFormat = "%d-%m-%Y">

	<!--- ------------------------------------- saveRow -------------------------------------  --->
	
	<cffunction name="saveRow" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="false">
		<cfargument name="position" type="numeric" required="false">

		<cfargument name="action" type="string" required="true"><!---create/modify--->

		<cfset var method = "saveRow">

		<cfset var response = structNew()>

		<cfset var row_id = "">

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

			<!---canUserModifyRow--->
			<cfinvoke component="RowManager" method="canUserModifyRow" returnvariable="canUserModifyRow">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="table" value="#table#">
			</cfinvoke>
			<cfif canUserModifyRow IS false>
				<cfthrow message="No tiene permiso para acceder a editar esta #tableTypeNameEs#">
			</cfif>			

			<!---Table fields--->
			<cfinvoke component="TableManager" method="getTableFields" returnvariable="fieldsResult">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="with_types" value="true"/>
			</cfinvoke>
			<cfset fields = fieldsResult.tableFields>

			<!--- saveRow --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="saveRow" argumentcollection="#arguments#" returnvariable="row_id">

				<cfinvokeargument name="fields" value="#fields#">
				<cfinvokeargument name="user_id" value="#user_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, row_id=#row_id#, table_id=#arguments.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>
	

	<!--- --------------------------------- canUserModifyRow ---------------------------------  --->
	
	<cffunction name="canUserModifyRow" output="false" access="private" returntype="boolean">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="table" type="query" required="true">

		<cfset var method = "canUserModifyRow">

		<cfset var area_id = "">

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfif arguments.tableTypeId NEQ 3 OR arguments.table.general IS NOT true><!---IS NOT typology OR IS NOT general typology--->

			<cfset area_id = table.area_id>

			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">

		</cfif>

		<!---checkListPermissions--->
		<cfif tableTypeId IS 1 AND APPLICATION.moduleListsWithPermissions IS true><!---IS List and list permissions is enabled--->
			
			<cfinvoke component="TableManager" method="isUserInTable" returnvariable="isUserInTableResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="check_user_id" value="#user_id#">
			</cfinvoke>	
			<cfif isUserInTableResponse.result IS false>
				<cfreturn isUserInTableResponse>
			</cfif>

			<cfif isUserInTableResponse.isUserInTable IS false><!--- The user is not in the table  --->

				<!---checkAreaResponsibleAccess--->
				<cfinvoke component="AreaManager" method="isUserAreaResponsible" returnvariable="isAreaResponsible">
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>
				<cfif isAreaResponsible IS false>
					<cfreturn false>
				</cfif>
				
			</cfif>

		</cfif>

		<cfreturn true>

	</cffunction>

	<!---  ---------------------- getRowLastPosition -------------------------------- --->
	
	<!---<cffunction name="getRowLastPosition" returntype="numeric" access="public">
		<cfargument name="table_id" type="numeric" required="yes">
		<cfargument name="tableTypeId" type="numeric" required="yes">
		
		<cfset var method = "getRowLastPosition">
		
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getRowLastPosition" returnvariable="getLastPositionResult">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
		
		<cfif isNumeric(getLastPositionResult.position)>
			<cfreturn getLastPositionResult.position>
		<cfelse>
			<cfreturn 0>
		</cfif>
		
	</cffunction>--->
	<!---  ------------------------------------------------------------------------ --->



	<!--- ------------------------------------- deleteRow -------------------------------------  --->
	
	<cffunction name="deleteRow" output="false" access="public" returntype="struct">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "deleteRow">

		<cfset var response = structNew()>

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

			<!---canUserModifyRow--->
			<cfinvoke component="RowManager" method="canUserModifyRow" returnvariable="canUserModifyRow">
				<cfinvokeargument name="table_id" value="#table_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="table" value="#table#">
			</cfinvoke>
			<cfif canUserModifyRow IS false>
				<cfthrow message="No tiene permiso para acceder a editar esta #tableTypeNameEs#">
			</cfif>

			<!--- getRow --->
			<cfinvoke component="RowManager" method="getRow" returnvariable="getRowResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="row_id" value="#arguments.row_id#">
			</cfinvoke>

			<cfif getRowResponse.result IS false>
				<cfreturn getRowResponse>
			</cfif>

			<cfset row = getRowResponse.row>

			<cftransaction>
				
				<!---Delete row--->
				<cfquery name="deleteRow" datasource="#client_dsn#">
					DELETE FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`
					WHERE row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<!---Delete selected areas--->
				<cfquery name="deleteSelectedAreasQuery" datasource="#client_dsn#">
					DELETE FROM `#client_abb#_#tableTypeTable#_rows_areas`
					WHERE #tableTypeName#_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
					AND row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

			</cftransaction>

			<cfinclude template="includes/logRecord.cfm">
			
			<cfset response = {result=true, row_id=#arguments.row_id#, table_id=#arguments.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------ deleteTableRowsInDatabase -----------------------------------  --->
	
	<cffunction name="deleteTableRowsInDatabase" output="false" access="package" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "deleteTableRowsInDatabase">

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<!---Delete rows--->
			<cfquery name="deleteRows" datasource="#client_dsn#">
				DELETE FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`;
			</cfquery>
			
			<!---Delete selected areas--->
			<cfquery name="deleteSelectedAreasQuery" datasource="#client_dsn#">
				DELETE FROM `#client_abb#_#tableTypeTable#_rows_areas`
				WHERE #tableTypeName#_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

	</cffunction>


	<!--- ------------------------------------- getTableRows -------------------------------------  --->
	
	<cffunction name="getTableRows" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="false">

		<cfset var method = "getRow">

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

			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="getRowsQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfif isDefined("arguments.row_id")>
				<cfinvokeargument name="row_id" value="#arguments.row_id#">
				</cfif>
				<!---<cfinvokeargument name="parse_dates" value="true"/>--->
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfif getRowsQuery.recordCount GT 0>

				<cfset response = {result=true, rows=#getRowsQuery#, table=#table#}>

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


	<!--- ------------------------------------- getRow -------------------------------------  --->
	
	<cffunction name="getRow" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="true">

		<cfset var method = "getRow">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinvoke component="RowManager" method="getTableRows" returnvariable="getTableRowsResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="row_id" value="#arguments.row_id#">
			</cfinvoke>
			
			<cfif getTableRowsResponse.result IS true>
				<cfset response = {result=true, row=#getTableRowsResponse.rows#, table=#getTableRowsResponse.table#}>
			<cfelse>
				<cfreturn getTableRowsResponse>
			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- getRowSelectedAreas -------------------------------------  --->
	
	<cffunction name="getRowSelectedAreas" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="field_id" type="numeric" required="false">
		<cfargument name="row_id" type="numeric" required="false">

		<cfset var method = "getRowSelectedAreas">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getRowSelectedAreas" returnvariable="getRowAreasQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="field_id" value="#arguments.field_id#">
				<cfinvokeargument name="row_id" value="#arguments.row_id#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfset response = {result=true, areas=#getRowAreasQuery#}>
			
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- getEmptyRow -------------------------------------  --->
	
	<cffunction name="getEmptyRow" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getEmptyRow">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getEmptyRow" returnvariable="getEmptyRowQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, row=#getEmptyRowQuery#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------ fillEmptyRow -------------------------------------  --->
	
	<cffunction name="fillEmptyRow" output="false" access="public" returntype="struct">
		<cfargument name="emptyRow" type="query" required="true">
		<cfargument name="fields" type="query" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "fillEmptyRow">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="fillEmptyRow" returnvariable="emptyRow">
				<cfinvokeargument name="emptyRow" value="#arguments.emptyRow#">
				<cfinvokeargument name="fields" value="#arguments.fields#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>

			<cfset response = {result=true, row=#emptyRow#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


</cfcomponent>
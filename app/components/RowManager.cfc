<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">
	
	<cfset component = "RowManager">


	<!--- ------------------------------------- getTableRow -------------------------------------  --->
	
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
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
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


</cfcomponent>
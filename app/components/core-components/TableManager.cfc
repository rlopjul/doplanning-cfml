<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "TableManager">


	<!--- getTableTypesStruct --->

	<cffunction name="getTableTypesStruct" returntype="struct" access="public">

		<cfset var tableTypesStruct = structNew()>

		<cfinclude template="includes/tableTypeStruct.cfm">

		<cfreturn tableTypesStruct>

	</cffunction>


	<!--- getTableTypeStruct --->

	<cffunction name="getTableTypeStruct" returntype="struct" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var tableTypesStruct = structNew()>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/TableManager" method="getTableTypesStruct" returnvariable="tableTypesStruct">
		</cfinvoke>

		<cfreturn tableTypesStruct[arguments.tableTypeId]>

	</cffunction>


	<!------------------------ HAS TABLE ROWS IN THIS AREA-------------------------------------->

	<cffunction name="hasTableRowsInThisArea" returntype="struct" output="false" access="public">
		<cfargument name="table_id" type="numeric" required="true"/>
		<cfargument name="tableTypeId" type="numeric" required="true"/>
		<cfargument name="area_id" type="numeric" required="true"/>

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "hasTableRowsInThisArea">

		<cfset var response = structNew()>

		<cfset var rowsInThisArea = false>

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<!---Table fields--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getTableFields" returnvariable="allFields">
				<cfinvokeargument name="table_id" value="#table_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="with_types" value="true">
				<cfinvokeargument name="with_table" value="true">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif allFields.general IS true><!--- General table --->

				<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="tableRows">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="fields" value="#allFields#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif tableRows.recordCount GT 0>

					<cfquery dbtype="query" name="rowsInThisAreaQuery">
						SELECT *
						FROM tableRows
						WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<cfif rowsInThisAreaQuery.recordCount GT 0>
						<cfset rowsInThisArea = true>
					</cfif>

				</cfif>

			</cfif>

			<cfset response = {result=true, rowsInThisArea=rowsInThisArea}>

		<cfreturn response>

	</cffunction>


	<!------------------------ GET TABLE ROWS IN AREAS-------------------------------------->

	<cffunction name="getTableRowsInAreas" returntype="struct" output="false" access="public">
		<cfargument name="table_id" type="numeric" required="true"/>
		<cfargument name="tableTypeId" type="numeric" required="true"/>
		<cfargument name="areas_ids" type="string" required="true"/>

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getTableRowsInAreas">

		<cfset var response = {result=false, message=""}>

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfif len(arguments.areas_ids) GT 0>

				<!---Table fields--->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getTableFields" returnvariable="allFields">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="with_types" value="true">
					<cfinvokeargument name="with_table" value="true">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif allFields.general IS true><!--- General table --->

					<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="tableRows">
						<cfinvokeargument name="table_id" value="#table_id#">
						<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
						<cfinvokeargument name="fields" value="#allFields#">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfif tableRows.recordCount GT 0>

						<cfquery dbtype="query" name="rowsInAreasQuery">
							SELECT *
							FROM tableRows
							WHERE area_id IN (<cfqueryparam value="#arguments.areas_ids#" cfsqltype="cf_sql_integer" list="true">);
						</cfquery>

						<cfset response = {result=true, query=rowsInAreasQuery}>

					</cfif>

				</cfif>

			</cfif>

		<cfreturn response>

	</cffunction>


</cfcomponent>

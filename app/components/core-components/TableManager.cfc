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



</cfcomponent>
<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "StartPageManager">


	<!--- getStartPageTypesStruct --->

	<cffunction name="getStartPageTypesStruct" returntype="struct" access="public">

		<cfset var startPageTypesStruct = structNew()>

		<cfinclude template="includes/startPageTypeStruct.cfm">

		<cfreturn startPageTypesStruct>

	</cffunction>


	<!--- getTableTypeStruct --->

	<cffunction name="getTableTypeStruct" returntype="struct" access="public">
		<cfargument name="startPageTypeId" type="numeric" required="true">

		<cfset var startPageTypesStruct = structNew()>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/TableManager" method="getTableTypesStruct" returnvariable="startPageTypesStruct">
		</cfinvoke>

		<cfreturn startPageTypesStruct[arguments.startPageTypeId]>

	</cffunction>

</cfcomponent>

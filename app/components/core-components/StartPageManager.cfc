<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "StartPageManager">


	<!--- getStartPageTypesStruct --->

	<cffunction name="getStartPageTypesStruct" returntype="struct" access="public">
		<cfargument name="client_abb" type="string" required="true">

		<cfset var startPageTypesStruct = structNew()>

		<cfinclude template="includes/startPageTypeStruct.cfm">

		<cfreturn startPageTypesStruct>

	</cffunction>


</cfcomponent>

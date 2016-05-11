<!--- Copyright Era7 Information Technologies 2007-2015 --->
<cfcomponent output="false">

	<cfset component = "Web">

	<!--- ----------------------- GET WEB -------------------------------- --->

	<cffunction name="getWeb" returntype="struct" access="public">
		<cfargument name="path" type="string" required="true">

		<cfset var method = "getWeb">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/WebManager" method="getWeb" returnvariable="response">
				<cfinvokeargument name="path" value="#arguments.path#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ----------------------- GET WEBS -------------------------------- --->

	<cffunction name="getWebs" returntype="struct" access="public">
		<cfargument name="area_type" type="string" required="false">

		<cfset var method = "getWeb">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/WebManager" method="getWebs" returnvariable="response">
				<cfinvokeargument name="area_type" value="#arguments.area_type#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


</cfcomponent>

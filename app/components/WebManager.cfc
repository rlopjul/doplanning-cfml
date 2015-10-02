<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "WebManager">


	<!--- --------------------------- GET WEB ---------------------------------------   --->

	<cffunction name="getWeb" output="false" returntype="struct" access="public">
		<cfargument name="path" type="string" required="true">

		<cfset var method = "getWeb">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/WebQuery" method="getWeb" returnvariable="webQuery">
				<cfinvokeargument name="path" value="#arguments.path#"/>

				<cfinvokeargument name="client_abb" value="#client_abb#"/>
				<cfinvokeargument name="client_dsn" value="#client_dsn#"/>
			</cfinvoke>

			<cfset response = {result=true, query=#webQuery#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!--- ------------------------------------------------------------------------------  --->


</cfcomponent>

<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "MailingTemplateManager">


	<!--- ------------------------------------- getTemplates -------------------------------------  --->

	<cffunction name="getTemplates" output="false" access="public" returntype="struct">

		<cfset var method = "getTemplates">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/MailingTemplateQuery" method="getTemplates" returnvariable="getTemplatesQuery">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, templates=#getTemplatesQuery#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>


</cfcomponent>

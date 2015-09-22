<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "ItemTemplateManager">


	<!--- ------------------------------------- getTemplate -------------------------------------  --->

	<cffunction name="getTemplate" output="false" access="public" returntype="struct">
		<cfargument name="template_id" type="numeric" required="true">

		<cfset var method = "getTemplate">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/ItemTemplateQuery" method="getTemplate" returnvariable="getTemplateQuery">
				<cfinvokeargument name="template_id" value="#arguments.template_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, template=#getTemplateQuery#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ------------------------------------- getTemplates -------------------------------------  --->

	<cffunction name="getTemplates" output="false" access="public" returntype="struct">

		<cfset var method = "getTemplates">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/ItemTemplateQuery" method="getTemplates" returnvariable="getTemplatesQuery">
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

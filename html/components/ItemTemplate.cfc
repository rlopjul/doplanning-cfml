<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="true">

	<cfset component = "ItemTemplate">


		<!--- ----------------------------------- getTemplate -------------------------------------- --->

		<cffunction name="getTemplate" output="false" returntype="struct" access="public">
			<cfargument name="template_id" type="numeric" required="true">

			<cfset var method = "getTemplate">

			<cfset var response = structNew()>

			<cftry>

				<cfinvoke component="#APPLICATION.componentsPath#/ItemTemplateManager" method="getTemplate" returnvariable="response">
				</cfinvoke>

				<cfinclude template="includes/responseHandlerStruct.cfm">

				<cfcatch>
					<cfinclude template="includes/errorHandlerStruct.cfm">
				</cfcatch>

			</cftry>

			<cfreturn response>

	</cffunction>


	<!--- ----------------------------------- getTemplates -------------------------------------- --->

	<cffunction name="getTemplates" output="false" returntype="struct" access="public">

		<cfset var method = "getTemplates">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/ItemTemplateManager" method="getTemplates" returnvariable="response">
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


</cfcomponent>

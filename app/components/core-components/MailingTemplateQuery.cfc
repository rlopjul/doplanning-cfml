<!---Copyright Era7 Information Technologies 2007-2015--->

<cfcomponent output="false">

	<cfset component = "MailingTemplateQuery">
		

	<!---getTemplate--->

	<cffunction name="getTemplate" output="false" returntype="query" access="public">
		<cfargument name="template_id" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getTemplate">

			<cfquery name="getTemplateQuery" datasource="#arguments.client_dsn#">
				SELECT *
				FROM `#client_abb#_mailings_templates` AS templates
				WHERE templates.template_id = <cfqueryparam value="#arguments.template_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

		<cfreturn getTemplateQuery>

	</cffunction>


	<!---getTemplates--->

	<cffunction name="getTemplates" output="false" returntype="query" access="public">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getTemplates">

			<cfquery name="getTemplatesQuery" datasource="#arguments.client_dsn#">
				SELECT *
				FROM `#client_abb#_mailings_templates` AS templates
				ORDER BY position ASC;
			</cfquery>

		<cfreturn getTemplatesQuery>

	</cffunction>

</cfcomponent>

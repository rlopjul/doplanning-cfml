<cfinclude template="#APPLICATION.componentsPath#/includes/errorHandler.cfm">
<cfif NOT isDefined("error_code")>
	<cfset error_code = 10000>
</cfif>
<cflocation url="#APPLICATION.resourcesPath#/error.cfm?error_code=#error_code#" addtoken="no">

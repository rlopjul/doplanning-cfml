<!---
AQUÍ OBTIENE SI SE ESTÁ EN LA VERSIÓN standard o móvil
app_version almacena si es la versión móvil o la estandar--->
<cfif find("iframes2",CGI.SCRIPT_NAME) GT 0>
	<cfset app_version = "html2">
<cfelseif find("iframes",CGI.SCRIPT_NAME) GT 0>
	<cfset app_version = "standard">
<cfelse>
	<cfset app_version = "mobile">
</cfif>
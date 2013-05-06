<cfif isDefined("URL.user")>
	<cfset user_id = URL.user>
<cfelse>
	<cflocation url="index.cfm" addtoken="no">
</cfif>

<cfif isDefined("app_version") AND app_version NEQ "html2">
<div class="div_head_subtitle"><span lang="es">Usuario</span></div>
</cfif>
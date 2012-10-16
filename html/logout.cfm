<cfif isDefined("SESSION.client_abb")>
	<cfset client_abb = SESSION.client_abb>
</cfif>

<cfinvoke component="login/Login" method="logOutUser">
</cfinvoke>

<cfif isDefined("client_abb")>
	<cflocation url="#APPLICATION.htmlPath#/login/?client_abb=#client_abb#" addtoken="no">
<cfelse>
	<cflocation url="#APPPLICATION.mainUrl#" addtoken="no">
</cfif>
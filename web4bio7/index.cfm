<cfset debug_mode = false>
<cfset client_abb = "web4bio7">
<cfif getAuthUser() EQ "" OR NOT isDefined("SESSION.client_abb") OR SESSION.client_abb NEQ client_abb>
	<!---<cflocation url="login.cfm" addtoken="no">--->
	<cflocation url="../html/login/?client_abb=#client_abb#" addtoken="no">
<cfelse>
	<cfinclude template="../app/includes/client_app.cfm">
</cfif>
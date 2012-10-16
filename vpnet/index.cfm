<cfset debug_mode = true>
<cfset client_abb = "vpnet">
<cfif getAuthUser() EQ "" OR NOT isDefined("SESSION.client_abb") OR SESSION.client_abb NEQ client_abb>
	<cflocation url="login.cfm" addtoken="no">
<cfelse>
	<cfinclude template="../app/includes/client_app_asnc.cfm">
</cfif>
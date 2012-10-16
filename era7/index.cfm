<cfset debug_mode = false>
<cfset client_abb = "era7">
<cfif getAuthUser() EQ "" OR NOT isDefined("SESSION.client_abb") OR SESSION.client_abb NEQ client_abb>
	<cflocation url="login.cfm" addtoken="no">
<cfelse>
	<cfinclude template="../app/includes/client_app.cfm">
</cfif>
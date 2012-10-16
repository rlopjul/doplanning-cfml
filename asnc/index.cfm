<cfset debug_mode = false>
<cfset client_abb = "asnc">
<cfif getAuthUser() EQ "" OR NOT isDefined("SESSION.client_abb") OR SESSION.client_abb NEQ client_abb>
	<!---<cflocation url="login.cfm" addtoken="no">--->
	<cflocation url="../html/login/?client_abb=asnc" addtoken="no">
<cfelse>
	<cfinclude template="../app/includes/client_app_asnc.cfm">
</cfif>
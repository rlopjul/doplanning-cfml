<cfset client_abb = "software7">
<cfif getAuthUser() EQ "" OR NOT isDefined("SESSION.client_abb") OR SESSION.client_abb NEQ client_abb>
	<cflocation url="../../html/login/?client_abb=#client_abb#" addtoken="no">
<cfelse>
	<cflocation url="../../html" addtoken="no">
</cfif>

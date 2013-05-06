<cfif isDefined("URL.lan")>
	<cfif URL.lan EQ "es">
		<cfset SESSION.user_language = "es">
	<cfelse>
		<cfset SESSION.user_language = "en">
	</cfif>
</cfif>
<cfif isDefined("URL.rpage")>
	<cflocation url="#URL.rpage#" addtoken="no">
<cfelse>
	<cflocation url="main.cfm" addtoken="no">
</cfif>
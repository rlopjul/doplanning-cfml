<cfif isDefined("URL.abb")>
	
	<cflocation url="#APPLICATION.path#/html/?#CGI.QUERY_STRING#" addtoken="no">
	
<cfelse>

	<cflocation url="/web/es/" addtoken="no">

</cfif>
<cfif isDefined("URL.abb")>

	<cfif isDefined("URL.file_public")>
		<cflocation url="#APPLICATION.htmlPath#/public/file_public_download.cfm?#CGI.QUERY_STRING#" addtoken="no">
	<cfelse>
		<cflocation url="#APPLICATION.path#/html/?#CGI.QUERY_STRING#" addtoken="no">
	</cfif>
	
<cfelse>
	<cflocation url="/es/" addtoken="no" statuscode="301">
</cfif>
<cfif isDefined("URL.fileDownload") AND isNumeric(URL.fileDownload)>
	<cfoutput>
	<iframe style="display:none" src="file_download.cfm?#CGI.QUERY_STRING#"></iframe>
	</cfoutput>
	<!---<cflocation url="file_download.cfm?id=#URL.fileDownload#" addtoken="no">--->
	<!---<cfoutput>
		window.location.href = "file_download.cfm?id=#URL.fileDownload#";
	</cfoutput>--->
</cfif>

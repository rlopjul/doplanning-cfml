<cftry>
	
	<cfinclude template="includes/download_file.cfm">

	<cfcatch>
	
		<cfinclude template="includes/errorHandler.cfm">
		
		<!---<cfif isDefined("error_code") AND error_code IS 601>
			<cflocation url="fileNotFound.cfm" addtoken="no">
		<cfelse>
			<cfheader statuscode="500" statustext="Internal Server Error" />
		</cfif>--->
		
	</cfcatch>
</cftry>
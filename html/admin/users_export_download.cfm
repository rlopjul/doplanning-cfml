<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="exportUsers" argumentCollection="#URL#" returnvariable="exportUsersResponse">
</cfinvoke>

<cfif exportUsersResponse.result IS true><!---The export is success--->

	<cfif isDefined("URL.delimiter") AND URL.delimiter EQ "tab">
		<cfset contentDisposition = "attachment; filename=doplanning_#SESSION.client_abb#_users.txt;">
		<cfset contentType = "text/plain; charset=Windows-1252">
	<cfelse>
		<cfset contentDisposition = "attachment; filename=doplanning_#SESSION.client_abb#_users.csv;">
		<cfset contentType = "text/csv; charset=Windows-1252">
	</cfif>

	<cfheader name="Content-Disposition" value="#contentDisposition#" charset="Windows-1252"><!---iso-8859-1--->
	<cfcontent type="#contentType#"><cfoutput>#exportUsersResponse.content#</cfoutput></cfcontent>

<cfelse>
	<!---There is an error in the export--->
	<cfoutput>
		Error: #exportUsersResponse.message#
	</cfoutput>
</cfif>

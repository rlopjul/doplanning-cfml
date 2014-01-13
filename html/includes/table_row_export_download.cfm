<cfif isDefined("FORM.tableTypeId") AND isNumeric(FORM.tableTypeID)>

	<cfset tableTypeId = FORM.tableTypeId>

	<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="exportRows" returnvariable="actionResponse" argumentcollection="#FORM#">
	</cfinvoke>		
		
	<cfif actionResponse.result IS true><!---The export is success--->
		<cfif FORM.delimiter EQ "tab">
			<cfset contentDisposition = "attachment; filename=#tableTypeName#_#table_id#.txt;">
			<cfset contentType = "text/plain; charset=iso-8859-1">
		<cfelse>
			<cfset contentDisposition = "attachment; filename=#tableTypeName#_#table_id#.csv;">
			<cfset contentType = "text/csv; charset=iso-8859-1">
		</cfif>

		<cfheader name="Content-Disposition" value="#contentDisposition#" charset="iso-8859-1">
		<cfcontent type="#contentType#"><cfoutput>#actionResponse.content#</cfoutput></cfcontent>
		
	<cfelse><!---There is an error in the export--->
		
		<cfoutput>
			Error: #actionResponse.message#
		</cfoutput>

	</cfif>

</cfif>
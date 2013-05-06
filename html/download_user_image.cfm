<cfif isDefined("URL.id") AND isNumeric(URL.id) AND isDefined("URL.type")>
	
	<cfset files_directory = '#APPLICATION.filesPath#/#SESSION.client_abb#/users_images/'>
	
	<cfif isDefined("URL.small")>
		<cfset source = files_directory&URL.id&"_small">
	<cfelseif isDefined("URL.medium")>
		<cfset source = files_directory&URL.id&"_medium">
	<cfelse>
		<cfset source = files_directory&URL.id>
	</cfif>
	
	<cfset fileInfo = GetFileInfo(source)>
	
	<cfset file_type = URL.type>
	
	<cfswitch expression="#file_type#">
		<cfcase value=".jpg">
			<cfset filetype="image/jpeg">
		</cfcase>
		<cfcase value=".png">
			<cfset filetype="image/png">
		</cfcase>
		<cfcase value=".gif">
			<cfset filetype="image/gif">
		</cfcase>
		<cfdefaultcase>
			<cfset filetype="application/x-unknown; charset=UTF-8">
		</cfdefaultcase>
	</cfswitch>
	
	<cfset filename = URL.id&URL.type>
	
	<cfheader name="Content-Disposition" value="inline;filename=""#filename#""" charset="UTF-8">
	
	<cfheader name="Content-Length" value="#fileInfo.size#">
	
	<!---<cfheader name="Content-Encoding" value="gzip">
	<cfheader name="Transfer-Encoding" value="chunked">--->
	
	<cfcontent file="#source#" deletefile="no" type="#filetype#" />

</cfif>
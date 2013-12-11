<cfif isDefined("URL.file") AND isNumeric(URL.file) AND isDefined("URL.area") AND isNumeric(URL.area)>
	<cfset file_id = URL.file>
	<cfset area_id = URL.area>
	<cfset fileTypeId = URL.fileTypeid>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no"> 
</cfif>

<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

<cfif isDefined("FORM.file_id") AND isDefined("FORM.area_id") AND isDefined("FORM.Filedata")>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="replaceFile" returnvariable="replaceFileResponse">
		<cfinvokeargument name="file_id" value="#FORM.file_id#"/>
		<cfinvokeargument name="fileTypeId" value="#fileTypeId#"/>
		<cfinvokeargument name="Filedata" value="#FORM.Filedata#"/>
		<cfif isDefined("FORM.unlock")>
			<cfinvokeargument name="unlock" value="#FORM.unlock#"/>
		</cfif>
	</cfinvoke>	

	<!--- <cfset fail_page = "area_file_replace.cfm?file=#FORM.file_id#&area=#FORM.area_id#"> --->

	<cfif replaceFileResponse.result IS true>
		
		<cfset response_page = "#fileTypeName#.cfm?#fileTypeName#=#FORM.file_id#&area=#FORM.area_id#">
		<!---<cfset upload_file_id = replaceFileResponse.file_id>--->

		<cfset message = URLEncodedFormat(replaceFileResponse.message)>
		<cflocation url="#response_page#&res=1&msg=#message#" addtoken="no">
		
	<cfelse>
		
		<cfset URL.res = 0>
		<cfset URL.msg = replaceFileResponse.message>

	</cfif>

</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="file">
	<cfinvokeargument name="file_id" value="#file_id#">
	<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
</cfinvoke>
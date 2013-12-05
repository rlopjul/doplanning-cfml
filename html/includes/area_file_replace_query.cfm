<cfif isDefined("URL.file") AND isNumeric(URL.file) AND isDefined("URL.area") AND isNumeric(URL.area)>
	<cfset file_id = URL.file>
	<cfset area_id = URL.area>
	<cfset fileTypeId = URL.fileTypeid>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no"> 
</cfif>

<cfif isDefined("FORM.file_id") AND isDefined("FORM.area_id") AND isDefined("FORM.Filedata")>
	
	<cftry>

		<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="replaceFile" returnvariable="replaceFileResponse">
			<cfinvokeargument name="file_id" value="#FORM.file_id#"/>
			<cfinvokeargument name="Filedata" value="#FORM.Filedata#"/>
		</cfinvoke>	
	
		<!--- <cfset fail_page = "area_file_replace.cfm?file=#FORM.file_id#&area=#FORM.area_id#"> --->
	
		<cfif replaceFileResponse.result IS true>
			
			<cfset response_page = "file.cfm?file=#FORM.file_id#&area=#FORM.area_id#">
			<!---<cfset upload_file_name = xmlResponseXml.response.result.file.name.xmlText>--->
			<cfset upload_file_id = replaceFileResponse.file_id>

			<cfset message = "Archivo reemplazado correctamente.">
			<cfset message = URLEncodedFormat(message)>
			<cflocation url="#response_page#&res=1&msg=#message#" addtoken="no">
			
		<cfelse>
			
			<!---<cfset message = replaceFileResponse.message>
			<cfset message = URLEncodedFormat(message)>
			<cflocation url="#fail_page#&res=0&msg=#message#" addtoken="no">--->

			<cfset URL.res = 0>
			<cfset URL.msg = replaceFileResponse.message>

		</cfif>


		<cfcatch>
			<cfinclude template="#APPLICATION.htmlPath#components/includes/errorHandler.cfm">
		</cfcatch>										
		
	</cftry>

</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="file">
	<cfinvokeargument name="file_id" value="#file_id#">
	<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
</cfinvoke>
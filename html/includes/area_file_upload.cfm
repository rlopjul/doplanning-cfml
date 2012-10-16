<cftry>

	<cfif isDefined("FORM.name") AND isDefined("FORM.description") AND isDefined("FORM.Filedata") AND isDefined("FORM.area_id")>
		
		<cfinclude template="#APPLICATION.path#/app/uploadFiles/myFilesUploadFile.cfm">
	
		<cfif isDefined("xmlResponse") AND xmlResponse.response.xmlAttributes.status EQ "ok">
			<cfset response_page = "files.cfm">
			<cfset upload_file_name = xmlResponse.response.result.file.name.xmlText>
			<cfset file_id = xmlResponse.response.result.file.xmlAttributes.id>
			<!---<cfset message = "Archivo "&upload_file_name&" subido correctamente.">
			<cfset message = URLEncodedFormat(message)>--->
			
			<cfset areas_ids = arrayNew(1)>
			<cfset arrayAppend(areas_ids, area_id)>
			
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="associateFileToAreas" returnvariable="resultAddFile">
				<cfinvokeargument name="file_id" value="#file_id#">
				<cfinvokeargument name="areas_ids" value="#areas_ids#">
			</cfinvoke>
			
			<cfset msg = URLEncodedFormat(resultAddFile.message)>
			<cfset res = resultAddFile.result>
			
			<cflocation url="#response_page#?res=#res#&msg=#msg#&area=#area_id#" addtoken="no">	
		<cfelse>
			<cfset fail_page = "file_new.cfm">
			<cfset message = "Ha ocurrido un error al subir el archivo.">
			<cfset message = URLEncodedFormat(message)>
			<cflocation url="#APPLICATION.htmlPath#/#fail_page#?message=#message#&parent=#URL.folder_id#" addtoken="no">				
		</cfif>
	
	<cfelse><!---No value given for one or more required parameters--->
	
		<cfset error_code = 610>
		
		<cfthrow errorcode="#error_code#">
	
	</cfif>
	
	
	<cfcatch>
		<cfinclude template="#APPLICATION.htmlPath#/components/includes/errorHandler.cfm">
	</cfcatch>										
	
</cftry>
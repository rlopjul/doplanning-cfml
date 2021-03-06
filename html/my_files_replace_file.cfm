<cftry>

	<cfif isDefined("FORM.file_id") AND isDefined("FORM.folder_id") AND isDefined("FORM.Filedata")>
		
		<cfinclude template="#APPLICATION.path#/app/uploadFiles/myFilesReplaceFile.cfm">
	
		<cfset fail_page = "my_files_file_replace.cfm?file=#FORM.file_id#&folder=#FORM.folder_id#">
	
		<cfif isDefined("xmlResponse")>
			
			<cfxml variable="xmlResponseXml">
				<cfoutput>
				#xmlResponse#
				</cfoutput>
			</cfxml>
			
		</cfif>
		<cfif isDefined("xmlResponseXml") AND xmlResponseXml.response.xmlAttributes.status EQ "ok">
				<cfset response_page = "my_files_file.cfm?file=#FORM.file_id#&folder=#FORM.folder_id#">
				<cfset upload_file_name = xmlResponseXml.response.result.file.name.xmlText>
				<cfset upload_file_id = xmlResponseXml.response.result.file.xmlAttributes.id>
				
				<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Alert" method="notifyReplaceFile">
						<cfinvokeargument name="xmlFile" value='<file id="#upload_file_id#"/>'>
				</cfinvoke>--->
				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Request" method="doRequest" returnvariable="xmlGetFileResponse">
                    <cfinvokeargument name="request_component" value="FileManager">
                    <cfinvokeargument name="request_method" value="getReplaceFileStatus">
                    <cfinvokeargument name="request_parameters" value='<file id="#upload_file_id#"/>'>
                </cfinvoke>
					
				<cfif xmlGetFileResponse.response.result.file.xmlAttributes.status EQ "ok">
				
					<cfset message = "Archivo "&upload_file_name&" reemplazado correctamente.">
					<cfset message = URLEncodedFormat(message)>
					<cflocation url="#APPLICATION.htmlPath#/#response_page#&message=#message#" addtoken="no">
				
				<cfelse>
					
					<cfset message = "Ha ocurrido un error al subir el archivo.">
					<cfset message = URLEncodedFormat(message)>
					<cflocation url="#APPLICATION.htmlPath#/#fail_page#&message=#message#" addtoken="no">	
					
				</cfif>
				
		<cfelse>
			
			<cfset message = "Ha ocurrido un error al subir el archivo.">
			<cfset message = URLEncodedFormat(message)>
			<cflocation url="#APPLICATION.htmlPath#/#fail_page#&message=#message#" addtoken="no">				
		</cfif>
			
	<cfelse><!---No value given for one or more required parameters--->
	
		<cfset error_code = 610>
		
		<cfthrow errorcode="#error_code#">
	
	</cfif>
	
	
	<cfcatch>
		<cfinclude template="components/includes/errorHandler.cfm">
	</cfcatch>										
	
</cftry>
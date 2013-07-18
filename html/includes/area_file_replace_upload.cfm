<cftry>

	<cfif isDefined("FORM.file_id") AND isDefined("FORM.area_id") AND isDefined("FORM.Filedata")>
		
		<!--- <cfinclude template="#APPLICATION.path#/app/uploadFiles/myFilesReplaceFile.cfm"> --->

		<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="replaceFile" returnvariable="replaceFileResponse">
			<cfinvokeargument name="file_id" value="#FORM.file_id#"/>
			<cfinvokeargument name="Filedata" value="#FORM.Filedata#"/>
		</cfinvoke>	
	
		<cfset fail_page = "area_file_replace.cfm?file=#FORM.file_id#&area=#FORM.area_id#">
	
		<cfif replaceFileResponse.result IS true>
				<cfset response_page = "file.cfm?file=#FORM.file_id#&area=#FORM.area_id#">
				<!---<cfset upload_file_name = xmlResponseXml.response.result.file.name.xmlText>--->
				<cfset upload_file_id = replaceFileResponse.file_id>
				
				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Request" method="doRequest" returnvariable="xmlGetFileResponse">
                    <cfinvokeargument name="request_component" value="FileManager">
                    <cfinvokeargument name="request_method" value="getReplaceFileStatus">
                    <cfinvokeargument name="request_parameters" value='<file id="#upload_file_id#"/>'>
                </cfinvoke>
					
				<cfif xmlGetFileResponse.response.result.file.xmlAttributes.status EQ "ok">
				
					<!---<cfset message = "Archivo "&upload_file_name&" reemplazado correctamente.">--->
					<cfset message = "Archivo reemplazado correctamente.">
					<cfset message = URLEncodedFormat(message)>
					<cflocation url="#response_page#&res=1&msg=#message#" addtoken="no">
				
				<cfelse>
					
					<cfset message = "Ha ocurrido un error al subir el archivo.">
					<cfset message = URLEncodedFormat(message)>
					<cflocation url="#fail_page#&res=0&msg=#message#" addtoken="no">	
					
				</cfif>
				
		<cfelse>
			
			<cfset message = "Ha ocurrido un error al subir el archivo.">
			<cfset message = URLEncodedFormat(message)>
			<cflocation url="#fail_page#&res=0&msg=#message#" addtoken="no">				
		</cfif>
			
	<cfelse><!---No value given for one or more required parameters--->
	
		<cfset error_code = 610>
		
		<cfthrow errorcode="#error_code#">
	
	</cfif>
	
	
	<cfcatch>
		<cfinclude template="#APPLICATION.htmlPath#components/includes/errorHandler.cfm">
	</cfcatch>										
	
</cftry>
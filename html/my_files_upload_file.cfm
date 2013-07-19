<!--- 
Esta página ya no se debe usar, se mantiene por si es requerida esta funcionalidad de nuevo para ciertos clientes
 --->

<cftry>

	<cfif isDefined("FORM.name") AND isDefined("FORM.description") AND isDefined("FORM.Filedata")>
		
		<cfinclude template="#APPLICATION.path#/app/uploadFiles/myFilesUploadFile.cfm">
	
		<cfif isDefined("xmlResponse") AND xmlResponse.response.xmlAttributes.status EQ "ok">
			<cfset response_page = "my_files.cfm">
			<cfset upload_file_name = xmlResponse.response.result.file.name.xmlText>
			<cfset message = "Archivo "&upload_file_name&" subido correctamente.">
			<cfset message = URLEncodedFormat(message)>
			<cflocation url="#APPLICATION.htmlPath#/#response_page#?message=#message#&folder=#URL.folder_id#" addtoken="no">	
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
		<cfinclude template="components/includes/errorHandler.cfm">
	</cfcatch>										
	
</cftry>
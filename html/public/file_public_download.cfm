<cfif isDefined("URL.file_public") AND isDefined("URL.abb")>
	
	<cfset file_id = URL.file_public>

	<cfset downloadFilePermission = false>

	<cfset clientAbb = URL.abb>
	<cfset clientDsn = APPLICATION.identifier&"_"&clientAbb>
	
	<!---File--->
	<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
		<cfinvokeargument name="file_public_id" value="#file_id#">
		
		<cfinvokeargument name="client_abb" value="#clientAbb#">
		<cfinvokeargument name="client_dsn" value="#clientDsn#">
	</cfinvoke>
	
	<cfif fileQuery.recordCount GT 0>

		<cfset downloadFilePermission = true>

		<cfif downloadFilePermission IS true>
			
			<cfset files_directory = "files">
			<cfset source = '#APPLICATION.filesPath#/#clientAbb#/#files_directory#/#fileQuery.physical_name#'>

			<cfif FileExists(source)>
				
				<cfsetting requesttimeout="#APPLICATION.filesTimeout#">
				
				<cfset file_name = fileQuery.file_name>
				<cfset file_type = fileQuery.file_type>
				
				<cfinclude template="#APPLICATION.corePath#/includes/get_file_content.cfm">
			
			<cfelse>
			
				El archivo físico no existe.
			
			</cfif>
			
		<cfelse>

			Archivo no disponible o sin permiso de acceso.

		</cfif>

	
	<cfelse>
	
		Archivo no encontrado.
	
	</cfif>

<cfelse>

Parámetros incorrectos.
	
</cfif>
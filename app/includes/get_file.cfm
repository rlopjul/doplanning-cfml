<!---
Required variables:
objectFile
files_directory
--->
<cfsetting requesttimeout="#APPLICATION.filesTimeout#">
<cfset source = '#APPLICATION.filesPath#/#client_abb#/#files_directory#/#objectFile.physical_name#'>		

<cfif FileExists(source)>
	<cfset file_size = objectFile.file_size>
	
	<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="updateUserDownloadedSpace">
		<cfinvokeargument name="add_space" value="#file_size#">
	</cfinvoke>
	<!---Hay que guardar tambien el espacio total descargado por todos los usuarios por si se borra un usuario--->

	<cfset file_name = objectFile.file_name>
	<cfset file_type = objectFile.file_type>
	
	<cfinclude template="#APPLICATION.resourcesPath#/includes/get_file_content.cfm">
	
<cfelse><!---The physical file does not exist--->
			
	<cfset error_code = 608>
	
	<cfthrow errorcode="#error_code#" detail="#source#">

</cfif>
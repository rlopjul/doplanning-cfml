<!---
Required variables:
objectFile
files_directory
--->
<cfsetting requesttimeout="#APPLICATION.filesTimeout#">
<cfset source = '#APPLICATION.filesPath#/#client_abb#/#files_directory#/#objectFile.physical_name#'>

<cfif FileExists(source)>
	<cfset file_size = objectFile.file_size>


	<cfif fileTypeId NEQ 4><!--- Si no es imagen de área --->

		<!--- Esto antes se guardaba también en las imágenes de área --->
		<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="updateUserDownloadedSpace">
			<cfinvokeargument name="add_space" value="#file_size#">
		</cfinvoke>
		<!---Hay que guardar tambien el espacio total descargado por todos los usuarios por si se borra un usuario--->

		<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="addFileDownload">
			<cfif isDefined("objectFile.id")>
				<cfinvokeargument name="file_id" value="#objectFile.id#">
			<cfelse>
				<cfinvokeargument name="file_id" value="#objectFile.file_id#">
			</cfif>
			<cfinvokeargument name="user_id" value="#user_id#">
			<cfinvokeargument name="file_size" value="#file_size#">
			<cfif isDefined("URL.area") AND isNumeric(URL.area)>
				<cfinvokeargument name="area_id" value="#URL.area#">
			</cfif>
			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

	</cfif>

	<cfset file_name = objectFile.file_name>
	<cfset file_type = objectFile.file_type>

	<cfinclude template="#APPLICATION.resourcesPath#/includes/get_file_content.cfm">

<cfelse><!---The physical file does not exist--->

	<cfset error_code = 608>

	<cfthrow errorcode="#error_code#" detail="#source#">

</cfif>

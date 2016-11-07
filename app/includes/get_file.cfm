<!---
Required variables:
objectFile
files_directory
--->
<cfsetting requesttimeout="#APPLICATION.filesTimeout#">

<!--- Thumbnail --->
<cfif APPLICATION.moduleThumbnails IS true AND isDefined("URL.thumbnail") AND URL.thumbnail IS true>

	<cfset thumb = true>

	<cfif len(objectFile.thumbnail_format) IS 0>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="generateThumbnail" returnvariable="thumb">
			<cfinvokeargument name="file_id" value="#objectFile.id#">
			<cfinvokeargument name="fileTypeId" value="#objectFile.file_type_id#">

			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<cfif thumb IS false>
			<cfthrow message="Miniatura no disponible">
		</cfif>

	</cfif>

	<!--- The name of the thumbnail is always the id of the file --->
	<cfset files_directory = "files_thumbnails">
	<cfset source = '#APPLICATION.filesPath#/#client_abb#/#files_directory#/#objectFile.id#'>

<cfelse>
	<cfset thumb = false>

	<cfset source = '#APPLICATION.filesPath#/#client_abb#/#files_directory#/#objectFile.physical_name#'>
</cfif>


<cfif FileExists(source)>

	<cfif thumb IS false>

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


	<cfelse><!--- Thumbnail --->

		<cfset file_name = listFirst(objectFile.file_name,".")&"_thumb"&objectFile.thumbnail_format>
		<cfset file_type = objectFile.thumbnail_format>

	</cfif>


	<cfinclude template="#APPLICATION.resourcesPath#/includes/get_file_content.cfm">

<cfelse><!---The physical file does not exist--->

	<cfset error_code = 608>

	<cfthrow errorcode="#error_code#" detail="#source#">

</cfif>

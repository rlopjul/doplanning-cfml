<!---
Required URL variables:
id / image
--->
<cfheader name="expires" value="#now()#"> 
<cfheader name="pragma" value="no-cache"> 
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
<cfif isDefined("SESSION.client_abb")>

	<cfinclude template="#APPLICATION.componentsPath#/includes/sessionVars.cfm">

	<cfif isDefined("URL.id") AND isValid("integer",URL.id)>
		<cfset component = "downloadAreaImage">
		<cfset method = "downloadAreaImage">
		
		<cfset area_id = URL.id>
		
		<!---Un usuario puede acceder a la imagen de un área superior a la que no tiene acceso--->
		
		<!---<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaImageId" returnvariable="image_id">
			<cfinvokeargument name="area_id" value="#area_id#"> 
		</cfinvoke>--->

		<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getAreaImageId" returnvariable="image_id">
			<cfinvokeargument name="area_id" value="#area_id#">
			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

	<!--- <cfelseif isDefined("image") AND isNumeric(URL.image)>
			
			<cfset image_id = URL.image> --->
	
	<cfelse>

		<cfset image_id = -1>

	</cfif>


	<cfif image_id IS NOT -1>
		
		<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getImage" returnvariable="objectFile">
			<cfinvokeargument name="image_id" value="#image_id#">
			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>
		
		<cfset fileTypeId = 4><!--- Areas images --->
		<cfset files_directory = "areas_images">
		
		<cfinclude template="get_file.cfm">	

	<cfelse>

		<!---<cfheader name="content-disposition" value="attachment; filename=DoPlanning_Banner" charset="UTF-8">
		<cfcontent file="#ExpandPath('dp_banner.png')#" deletefile="no" />
		Al intentar cargar un swf con el cfcontent da error en flash
		--->
		<cflocation url="#APPLICATION.resourcesPath#/#APPLICATION.identifier#_banner.png" addtoken="no">
		
	</cfif>

</cfif>

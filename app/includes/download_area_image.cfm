<!---
Required URL variables:
id
--->
<cfheader name="expires" value="#now()#"> 
<cfheader name="pragma" value="no-cache"> 
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
<cfif isDefined("URL.id") AND isValid("integer",URL.id)>
	<cfset component = "downloadAreaImage">
	<cfset method = "downloadAreaImage">
	
	<cfinclude template="#APPLICATION.componentsPath#/includes/sessionVars.cfm">
	
	<cfset area_id = URL.id>
	
	<!---¿Un usuario puede acceder a la imagen de un área superior a la que no tiene acceso?--->
	<!---<cfinclude template="#APPLICATION.componentsPath#/includes/checkAreaAccess.cfm">--->
	
	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaImageId" returnvariable="image_id">
		<cfinvokeargument name="area_id" value="#area_id#"> 
	</cfinvoke>
	
	<cfif image_id IS NOT -1>
		
		<cfquery name="objectFile" datasource="#client_dsn#">
			SELECT *, file_size AS file_size_full
			FROM #client_abb#_areas_images
			WHERE id = #image_id#;
		</cfquery>		
		
		<cfset files_directory = "areas_images">
		
		<cfinclude template="get_file.cfm">	
	
	<cfelse>
	
		<!---<cfheader name="content-disposition" value="attachment; filename=DoPlanning_Banner" charset="UTF-8">
		<cfcontent file="#ExpandPath('dp_banner.png')#" deletefile="no" />
		Al intentar cargar un swf con el cfcontent da error en flash
		--->
		<!---<cflocation url="#APPLICATION.resourcesPath#/dp_banner.swf" addtoken="no">--->
		<cflocation url="#APPLICATION.resourcesPath#/#APPLICATION.identifier#_banner.png" addtoken="no">
		
	</cfif>
</cfif>
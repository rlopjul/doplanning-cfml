<!---
Required URL variables:
id
--->
<!---<cfheader name="expires" value="#now()#"> 
<cfheader name="pragma" value="no-cache"> 
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">--->
<cfif isDefined("URL.id") AND isValid("integer",URL.id)>
	<cfset component = "downloadAreaImageWeb">
	<cfset method = "downloadAreaImageWeb">
	
	<cfset area_id = URL.id>
	
	
	<!---getAreaType--->
	<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getAreaTypeWeb" returnvariable="areaTypeResult">
		<cfinvokeargument name="area_id" value="#area_id#">
		
		<cfinvokeargument name="client_abb" value="#clientAbb#">
		<cfinvokeargument name="client_dsn" value="#clientDsn#">
	</cfinvoke>
			
	<cfif areaTypeResult.areaType EQ areaTypeRequired><!---Solo se pueden descargar desde aquí archivos que estén en áreas web--->
	
		<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getAreaImageId" returnvariable="image_id">
			<cfinvokeargument name="area_id" value="#area_id#">
			<cfinvokeargument name="client_abb" value="#clientAbb#"> 
			<cfinvokeargument name="client_dsn" value="#clientDsn#">
		</cfinvoke>
		
		<cfif image_id IS NOT -1>
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getImage" returnvariable="fileQuery">
				<cfinvokeargument name="image_id" value="#image_id#">
				<cfinvokeargument name="client_abb" value="#clientAbb#">
				<cfinvokeargument name="client_dsn" value="#clientDsn#">
			</cfinvoke>
			
			<cfset files_directory = "areas_images">
			
			<cfset source = '#APPLICATION.filesPath#/#clientAbb#/#files_directory#/#fileQuery.physical_name#'>		
	
			<cfif FileExists(source)>
				
				<!---
				PARA LAS IMÁGENES DE ÁREA ESTO NO DEBE SER NECESARIO (no pesan mucho)
				<cfsetting requesttimeout="#APPLICATION.filesTimeout#">--->
				
				<cfset file_name = fileQuery.file_name>
				<cfset file_type = fileQuery.file_type>
				
				<cfinclude template="#APPLICATION.resourcesPath#/includes/get_file_content.cfm">
			
			<cfelse>
				
				<!---The physical file does not exist--->
				<cfthrow errorcode="608">
			
			</cfif>	
		
		<cfelse>
		
			<cflocation url="#APPLICATION.resourcesPath#/#APPLICATION.identifier#_banner.png" addtoken="no">
			
		</cfif>
		
		
	<cfelse>
		
		<!---Not allowed access--->
		<cfthrow errorcode="103">
	
	</cfif>
</cfif>
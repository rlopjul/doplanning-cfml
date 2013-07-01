<cfif isDefined("URL.abb") AND len(URL.abb) GT 0>
	<cfset component = "downloadLoginImage">
	<cfset method = "downloadLoginImage">
	
	<cfset clientAbb = URL.abb>
	<cfset clientDsn = APPLICATION.identifier&"_"&clientAbb>
	
	<!---Get root area id--->
	<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getRootArea" returnvariable="rootAreaQuery">
		<cfinvokeargument name="onlyId" value="true">
		<cfinvokeargument name="client_abb" value="#clientAbb#">
		<cfinvokeargument name="client_dsn" value="#clientDsn#">
	</cfinvoke>
	<cfset area_id = rootAreaQuery.id>
			
	<cfif area_id GT 0>
	
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
				<!---<cfthrow errorcode="608">--->
			
			</cfif>	
		
		<cfelse>
		
			<cflocation url="#APPLICATION.resourcesPath#/#APPLICATION.identifier#_banner.png" addtoken="no">
			
		</cfif>
		
		
	<cfelse>
		
		<!---Not allowed access--->
		<!---<cfthrow errorcode="103">--->
	
	</cfif>
</cfif>
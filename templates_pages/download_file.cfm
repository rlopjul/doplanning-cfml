<cfif isDefined("URL.file") AND isNumeric(URL.file)>
	
	<cfset file_id = URL.file>
	
	<cfif isDefined("URL.area") AND isNumeric(URL.area)>
		<cfset area_id = URL.area>
	<cfelseif isDefined("URL.entry") AND isNumeric(URL.entry)>
		<cfset item_id = URL.entry>
		<cfset itemTypeId = 2>
	<cfelseif isDefined("URL.link") AND isNumeric(URL.link)>
		<cfset item_id = URL.link>
		<cfset itemTypeId = 3>
	<cfelseif isDefined("URL.news") AND isNumeric(URL.news)>
		<cfset item_id = URL.news>
		<cfset itemTypeId = 4>
	<cfelseif isDefined("URL.event") AND isNumeric(URL.event)>
		<cfset item_id = URL.event>
		<cfset itemTypeId = 5>
	</cfif>
	
	<!---File--->
	<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
		<cfinvokeargument name="file_id" value="#file_id#">
		<cfif isDefined("area_id")>
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfif>
		<cfinvokeargument name="client_abb" value="#clientAbb#">
		<cfinvokeargument name="client_dsn" value="#clientDsn#">
	</cfinvoke>
	
	<cfif fileQuery.recordCount GT 0>
	
		<cfif NOT isDefined("area_id") AND isDefined("item_id")>
			<!---getAreaItem--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="getItemQuery">
				<cfinvokeargument name="item_id" value="#item_id#">
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
				
				<cfinvokeargument name="client_abb" value="#clientAbb#">
				<cfinvokeargument name="client_dsn" value="#clientDsn#">
			</cfinvoke>
			
			<cfif getItemQuery.attached_file_id EQ file_id OR getItemQuery.attached_image_id IS file_id>
			
				<cfset area_id = getItemQuery.area_id>
			
			</cfif>
		</cfif>
		
		<cfif isDefined("area_id")>
		
			<!---getAreaType--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getAreaTypeWeb" returnvariable="areaTypeResult">
				<cfinvokeargument name="area_id" value="#area_id#">
				
				<cfinvokeargument name="client_abb" value="#clientAbb#">
				<cfinvokeargument name="client_dsn" value="#clientDsn#">
			</cfinvoke>
			
			<cfif areaTypeResult.areaType EQ areaTypeRequired><!---Solo se pueden descargar desde aquí archivos que estén en áreas web--->
				<cfset files_directory = "files">
				<cfset source = '#APPLICATION.filesPath#/#clientAbb#/#files_directory#/#fileQuery.physical_name#'>		
	
				<cfif FileExists(source)>
					
					<cfsetting requesttimeout="#APPLICATION.filesTimeout#">
					
					<cfset file_name = fileQuery.file_name>
					<cfset file_type = fileQuery.file_type>
					
					<cfinclude template="#APPLICATION.resourcesPath#/includes/get_file_content.cfm">
				
				<cfelse>
				
					El archivo físico ha sido borrado.
				
				</cfif>
				
			<cfelse>
	
				Archivo no disponible.
			
			</cfif>
			
		</cfif>
	
	<cfelse>
	
		Archivo no encontrado.
	
	</cfif>
<cfelse>

Parámetros incorrectos.
	
</cfif>
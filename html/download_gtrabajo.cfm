<!--- Archivos trabajo en grupo OMARS --->
<cfif isDefined("URL.file") AND len(URL.file) GT 0 AND isDefined("URL.area") AND len(URL.area) GT 0>

	<cftry>

		<cfset component = "downloadSpecialFile">
		<cfset method = "downloadSpecialFile">

		<cfinclude template="#APPLICATION.componentsPath#/includes/sessionVars.cfm">

		<cfset files_directory = "grupotrabajo">

		<cfsetting requesttimeout="#APPLICATION.filesTimeout#">

		<cfset area_id = URL.area>

		<cfquery datasource="#client_dsn#" name="getGrupoTrabajo">
			SELECT grupo_trabajo_id
			FROM `#client_abb#_areas`
			WHERE id = <cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>

		<!--- checkAreaAccess --->
		<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAreaAccess">
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfinvoke>

		<cfif getGrupoTrabajo.recordCount GT 0>
			<cfset source = '#APPLICATION.filesPath#/#client_abb#/#files_directory#/#getGrupoTrabajo.grupo_trabajo_id#/#URL.file#'>
		<cfelse>
			<cfthrow message="Error">
		</cfif>

		<cfif FileExists(source)>

			<cfset fileInfo = getFileInfo(source)>
			<cfset filename = fileInfo.name>
			<cfset filetype = fileGetMimeType(filename,false)>

			<!---
			Esto no funciona en Railo con Tomcat
			<cfset mimeType = getPageContext().getServletContext().getMimeType(source)>--->

			<!---
			Esto quitado porque por ahora no se puede usar gzip para esta aplicación
			<cfif CGI.HTTP_ACCEPT_ENCODING CONTAINS "gzip">
				<cfheader name="Content-Encoding" value="gzip">
			</cfif>--->


			<cfif NOT isDefined("URL.open") OR URL.open EQ 0>
				<cfheader name="Content-Disposition" value="attachment; filename=""#filename#""" charset="UTF-8">
			<cfelse>
				<cfheader name="Content-Disposition" value="filename=""#filename#""" charset="UTF-8">
			</cfif>

			<!---<cfheader name="Accept-Ranges" value="bytes">--->
			<cfheader name="Content-Length" value="#fileInfo.size#">

			<cfcontent file="#source#" deletefile="no" type="#filetype#" /><!---if the file attribute is specified, ColdFusion attempts to get the content type from the file, but it fail with many extensions (like .pdf)--->



		<cfelse><!---The physical file does not exist--->

			<cfset error_code = 608>

			<cfthrow errorcode="#error_code#" detail="#source#">

		</cfif>


		<cfcatch>
			<cfinclude template="components/includes/errorHandler.cfm">
		</cfcatch>

	</cftry>

</cfif>

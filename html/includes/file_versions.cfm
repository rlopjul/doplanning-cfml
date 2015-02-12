<cfset fileTypeId = 3>

<cfif isDefined("URL.file") AND isNumeric(URL.file)>
	<cfset file_id = URL.file>
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>

<!--- File --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="file">
	<cfinvokeargument name="file_id" value="#file_id#">
	<cfinvokeargument name="fileTypeId" value="#fileTypeId#"/>
</cfinvoke>

<!--- File versions --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFileVersions" returnvariable="versionsResult">
	<cfinvokeargument name="file_id" value="#file_id#">
	<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
</cfinvoke>
<cfset versions = versionsResult.fileVersions>

<cfset area_id = file.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>
<div class="div_message_page_title">#file.name#</div>
<div class="div_separator"><!-- --></div>

<div class="div_head_subtitle_area">

	<div class="btn-toolbar" style="padding-right:5px;">

		<!---
		Para habilitar esta funcionalidad aquí habría que cambiar la página de resultado a la que se va tras la subida de una nueva versión
		<cfif file.locked IS true AND file.lock_user_id IS SESSION.user_id>
			<a href="area_file_replace.cfm?file=#file_id#&fileTypeId=#fileTypeId#&area=#area_id#" onclick="openUrl('area_file_replace.cfm?file=#file_id#&fileTypeId=#fileTypeId#&area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm"><i class="icon-upload-alt"></i> <span lang="es">Nueva versión</span></a>

			<span class="divider">&nbsp;</span>
		</cfif>--->

		<!---<a href="area_items.cfm?area=#area_id#&file=#file_id#" class="btn btn-default btn-sm" title="Archivo" lang="es"> <img style="height:22px;" src="/html/assets/icons/file_edited.png">&nbsp;&nbsp;<span lang="es">Archivo</span></a>--->

		<div class="btn-group">
			<a href="area_items.cfm?area=#area_id#&file=#file_id#" class="btn btn-default btn-sm" title="Área" lang="es"> <img src="/html/assets/icons_dp/area_small.png" style="height:17px;" alt="Área" lang="es">&nbsp;<span lang="es">Área</span></a>
		</div>

		<!---<span class="divider">&nbsp;</span>--->

		<cfif app_version NEQ "mobile">
			<div class="btn-group pull-right">
				<a href="#APPLICATION.htmlPath#/file_versions.cfm?file=#file_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px;"></i></a>
			</div>
		</cfif>

	</div>

</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_items">

	<cfif versions.recordCount GT 0>

		<cfinclude template="#APPLICATION.htmlPath#/includes/file_versions_list.cfm">
		<!---<cfset full_content = false>
		<cfinclude template="#APPLICATION.htmlPath#/includes/file_list_content.cfm">--->		

	</cfif>

</div>

</cfoutput>

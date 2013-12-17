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

	<a href="area_items.cfm?area=#area_id#&file=#file_id#" class="btn btn-default btn-sm" title="Archivo" lang="es"> <img style="height:22px;" src="/html/assets/icons/file_edited.png">&nbsp;&nbsp;<span lang="es">Archivo</span></a>

	<span class="divider">&nbsp;</span>

	<cfif app_version NEQ "mobile">
		<a href="#APPLICATION.htmlPath#/file_versions.cfm?file=#file_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
	</cfif>

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

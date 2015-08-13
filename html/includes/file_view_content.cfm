<!--- 
<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>
 --->

<div class="div_head_subtitle">
<span lang="es">Visualizar archivo</span></div>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
	<cfinvokeargument name="file_id" value="#file_id#">
</cfinvoke>

<cfoutput>

<cfif app_version NEQ "mobile">
<div class="div_elements_menu">
	<cfif isDefined("area_id")>
	<a href="#APPLICATION.htmlPath#/area_file_view.cfm?file=#file_id#&area=#area_id#" title="Abrir en nueva ventana" target="_blank" class="btn btn-default btn-sm"><i class="icon-external-link"></i> <span lang="es">Ampliar</span></a>
	</cfif>
</div>
</cfif>
<div style="clear:both; height:5px;"><!-- --></div>

<cfif listFind(".gif,.jpg,.png",objectFile.file_type) GT 0>
	<cfif isDefined("area_id")>
		<img src="#APPLICATION.htmlPath#/file_download.cfm?id=#objectFile.id#&area=#area_id#" />
	<cfelse>
		<img src="#APPLICATION.htmlPath#/file_download.cfm?id=#objectFile.id#" />
	</cfif>
</cfif>
<div style="clear:both; height:10px;"><!-- --></div>
</cfoutput>
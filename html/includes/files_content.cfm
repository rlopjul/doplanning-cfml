<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_items_content_en.js" charset="utf-8" type="text/javascript"></script>

<script type="text/javascript" src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.extras-0.1.22.min.js"></script>
<link href="#APPLICATION.path#/jquery/tablesorter/css/style.css" rel="stylesheet" type="text/css" media="all" />
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getAreaFiles" returnvariable="xmlResponse">
	<cfinvokeargument name="area_id" value="#area_id#">
</cfinvoke>

<cfxml variable="xmlFiles">
	<cfoutput>
	#xmlResponse.response.result.files#
	</cfoutput>
</cfxml>

<cfoutput>
<div class="div_head_subtitle_area">
	
	<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->
		
		<cfif APPLICATION.identifier NEQ "vpnet">
		<a href="area_file_new.cfm?area=#area_id#" onclick="openUrl('area_file_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-small btn-info" title="Subir nuevo archivo" lang="es"><i class="icon-plus icon-white"></i> <span lang="es">Nuevo Archivo</span></a>
		</cfif>
		
		<a href="file_associate.cfm?area=#area_id#" onclick="openUrl('file_associate.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-small" title="Asociar archivo existente" lang="es"><i class="icon-plus-sign"></i> <span lang="es">Asociar Archivo</span></a>
		
		<a href="files.cfm?area=#area_id#" class="btn btn-small" title="Actualizar" lang="es"><i class="icon-refresh"></i> <span lang="es">Actualizar</span></a>	
	
	<cfelse>
	
		<cfinclude template="#APPLICATION.htmlPath#/includes/area_files_menu_vpnet.cfm">
	
	</cfif>
	
</div>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfset full_content = false>
<cfinclude template="#APPLICATION.htmlPath#/includes/file_list_content.cfm">
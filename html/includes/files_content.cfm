<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8" type="text/javascript"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getAreaFiles" returnvariable="getAreaFilesResponse">
	<cfinvokeargument name="area_id" value="#area_id#">
</cfinvoke>

<cfset files = getAreaFilesResponse.files>

<cfoutput>
<div class="div_head_subtitle_area">
	
	<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->

		<div class="btn-toolbar" style="padding-right:5px;" role="toolbar">
			
			<!---Botón antiguo<a href="area_file_new.cfm?area=#area_id#" onclick="openUrl('area_file_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-sm btn-info" title="Subir nuevo archivo" lang="es"><i class="icon-plus icon-white"></i> <span lang="es">Nuevo Archivo</span></a> --->

			<div class="btn-group">
				<a href="area_file_new.cfm?area=#area_id#&fileTypeId=1" onclick="openUrl('area_file_new.cfm?area=#area_id#&fileTypeId=1', 'itemIframe', event)" class="btn btn-default btn-sm" title="Nuevo Archivo" lang="es"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <img src="#APPLICATION.htmlPath#/assets/icons/file.png" style="height:22px;"/></a>
			</div>

			<div class="btn-group">
				<cfif APPLICATION.moduleAreaFilesLite IS true AND len(area_type) IS 0>
				<a href="area_file_new.cfm?area=#area_id#&fileTypeId=2" onclick="openUrl('area_file_new.cfm?area=#area_id#&fileTypeId=2', 'itemIframe', event)" class="btn btn-default btn-sm" title="Nuevo Archivo de área" lang="es"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <img src="#APPLICATION.htmlPath#/assets/icons/file_area.png" style="height:22px;"/></a>
				</cfif>
			</div>
		
			
			<!---Opción deshabilitada definitivamente<a href="file_associate.cfm?area=#area_id#" onclick="openUrl('file_associate.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm" title="Asociar archivo existente" lang="es"><i class="icon-plus-sign"></i> <span lang="es">Asociar Archivo</span></a>--->
			
			<div class="btn-group">
				<cfif APPLICATION.modulefilesWithTables AND is_user_area_responsible>
					<a href="typologies.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Tipologías de documentos" lang="es"><i class="icon-file-text" style="font-size:19px; line-height:23px; color:##7A7A7A"></i> <span lang="es">Tipologías de documentos</span></a>
				</cfif>
			</div>

			<!---<span class="divider">&nbsp;</span>--->

			<cfif app_version NEQ "mobile">
				<div class="btn-group pull-right">
					<a href="#APPLICATION.htmlPath#/files.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" target="_blank" lang="es"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
				</div>
			</cfif>

			<div class="btn-group pull-right">
				<a href="files.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>
			</div>

		</div>
	
	<cfelse>
	
		<cfinclude template="#APPLICATION.htmlPath#/includes/area_files_menu_vpnet.cfm">
	
	</cfif>
	
</div>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">


<script>
	
	$(document).ready(function() { 

		<!--- https://code.google.com/p/tablesorter-extras/wiki/TablesorterSelect --->
		$('#listTable').bind('select.tablesorter.select', function(event, ts){
		    var itemUrl= $(ts.elem).data("item-url");
		    openUrlLite(itemUrl,'itemIframe');
		});

	});

</script>

<cfset full_content = false>
<cfinclude template="#APPLICATION.htmlPath#/includes/file_list_content.cfm">
<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_items_content_en.js" charset="utf-8" type="text/javascript"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<div class="div_head_subtitle_area">
	<cfoutput>

	<!---
	<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->
	
		<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu.cfm">
		
	<cfelse><!---VPNET--->

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu_vpnet.cfm">
		
	</cfif>--->
	
	<cfif len(area_type) IS 0>
	<a href="message_new.cfm?area=#area_id#" onclick="openUrl('message_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-small" title="Nuevo Mensaje" lang="es"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <img src="#APPLICATION.htmlPath#/assets/icons/message.png" style="height:22px;"/></a>
	</cfif>

	<a href="area_file_new.cfm?area=#area_id#" onclick="openUrl('area_file_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-small" title="Nuevo Archivo" lang="es"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <img src="#APPLICATION.htmlPath#/assets/icons/file.png" style="height:22px;"/></a>
	
	<cfif len(area_type) IS NOT 0><!---WEB--->
	<a href="entry_new.cfm?area=#area_id#" onclick="openUrl('entry_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-small" title="Nuevo elemento de contenido" lang="es"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <img src="#APPLICATION.htmlPath#/assets/icons/entry.png" style="height:22px;"/></a>	
	<a href="news_new.cfm?area=#area_id#" onclick="openUrl('news_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-small" title="Nueva Noticia" lang="es"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <img src="#APPLICATION.htmlPath#/assets/icons/news.png" style="height:22px;"/></a>	
	</cfif>
	
	<a href="event_new.cfm?area=#area_id#" onclick="openUrl('event_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-small" title="Nuevo Evento" lang="es"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <img src="#APPLICATION.htmlPath#/assets/icons/event.png" style="height:22px;"/></a>
	
	<cfif len(area_type) IS 0>
	<a href="task_new.cfm?area=#area_id#" onclick="openUrl('task_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-small" title="Nueva Tarea" lang="es"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <img src="#APPLICATION.htmlPath#/assets/icons/task.png" style="height:22px;"/></a>
	</cfif>
	
	<!---<a href="event_new.cfm?area=#area_id#" onclick="openUrl('event_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-small btn-info"><i class="icon-plus icon-white"></i> Evento</a>
	<a href="task_new.cfm?area=#area_id#" onclick="openUrl('task_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-small btn-info"><i class="icon-plus icon-white"></i> Tarea</a>--->
	
	<cfif APPLICATION.moduleConsultations IS true AND len(area_type) IS 0>
	<a href="consultation_new.cfm?area=#area_id#" onclick="openUrl('consultation_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-small" title="Nueva Interconsulta" lang="es"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>&nbsp;<i class="icon-exchange" style="font-size:18px; color:##0088CC"></i></a>
	</cfif>
	
	<span class="divider">&nbsp;</span>

	<cfif app_version NEQ "mobile">
	<a href="#APPLICATION.htmlPath#/area_items.cfm?area=#area_id#" class="btn btn-small" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
	</cfif>

	<!--- QUITADO EL ENLACE HASTA QUE SE TERMINE EL DESARROLLO, esta página debe mostrar el contenido de los elementos <a href="#APPLICATION.htmlPath#/area_items_full.cfm?area=#area_id#" class="btn btn-small" title="Expandir contenido" lang="es" target="_blank"><i class="icon-external-link-sign" style="font-size:14px; line-height:23px;"></i></a> --->

	<a href="area_items.cfm?area=#area_id#" class="btn btn-small" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>
	
	</cfoutput>
</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllAreaItems" returnvariable="getAllAreaItemsResult">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="area_type" value="#area_type#">
	<!---<cfif isDefined("limit_to") AND isNumeric(limit_to)>
	<cfinvokeargument name="limit" value="#limit_to#">
	</cfif>--->
</cfinvoke>

<cfset areaItemsQuery = getAllAreaItemsResult.query>

<!---<cfdump var="#areaItemsQuery#">--->

<cfset numItems = areaItemsQuery.recordCount>
<div class="div_items">
<cfif numItems GT 0>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsList">
		<cfinvokeargument name="itemsQuery" value="#areaItemsQuery#">
		<cfinvokeargument name="area_type" value="#area_type#">
		<cfinvokeargument name="return_page" value="area_items.cfm?area=#area_id#">
		<cfinvokeargument name="app_version" value="#app_version#">
	</cfinvoke>

<cfelse>
	
	<script type="text/javascript">
		openUrlHtml2('empty.cfm','itemIframe');
	</script>				

	<cfoutput>
	<div class="div_text_result"><span lang="es">No hay elementos en esta área.</span></div>
	</cfoutput>
</cfif>
</div>

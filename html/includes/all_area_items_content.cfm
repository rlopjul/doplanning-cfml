<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8"></script>

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
	
	<div class="btn-toolbar" style="padding-right:5px;" role="toolbar">

		<div class="btn-group" style="margin:0">

			<a class="btn btn-link btn-sm" style="cursor:default;"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:20px;line-height:22px;"></i></a>

		</div>

		<div class="btn-group" style="margin-left:0">

			<!---<a class="btn btn-default btn-sm"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:20px;line-height:22px;"></i></a>--->

			<cfif len(area_type) IS 0>
			<a href="message_new.cfm?area=#area_id#" onclick="openUrl('message_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="Nuevo Mensaje" lang="es"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>---> <img src="#APPLICATION.htmlPath#/assets/icons/message.png" alt="Nuevo Mensaje" lang="es"/></a>
			</cfif>

		</div>
		<div class="btn-group" style="margin-left:0">

			<cfif len(area_type) IS NOT 0><!---WEB--->
			<a href="entry_new.cfm?area=#area_id#" onclick="openUrl('entry_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="Nuevo elemento de contenido" lang="es"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>---> <img src="#APPLICATION.htmlPath#/assets/icons/entry.png"/></a>	

		</div>
		<div class="btn-group">

			<a href="news_new.cfm?area=#area_id#" onclick="openUrl('news_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="Nueva Noticia" lang="es"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>---> <img src="#APPLICATION.htmlPath#/assets/icons/news.png"/></a>

		</div>
		<div class="btn-group">

			<a href="image_new.cfm?area=#area_id#" onclick="openUrl('image_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="Nueva Imagen" lang="es"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>&nbsp;---><img src="#APPLICATION.htmlPath#/assets/icons/image.png"/></a>
			</cfif>

		</div>
		
		<div class="btn-group">

			<a href="area_file_new.cfm?area=#area_id#&fileTypeId=1" onclick="openUrl('area_file_new.cfm?area=#area_id#&fileTypeId=1', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="Nuevo Archivo" lang="es"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>---> <img src="#APPLICATION.htmlPath#/assets/icons/file.png" /></a>

		</div>
		
		<div class="btn-group">

			<cfif APPLICATION.moduleAreaFilesLite IS true AND len(area_type) IS 0>
			<a href="area_file_new.cfm?area=#area_id#&fileTypeId=2" onclick="openUrl('area_file_new.cfm?area=#area_id#&fileTypeId=2', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="Nuevo Archivo de área" lang="es"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>---> <img src="#APPLICATION.htmlPath#/assets/icons/file_area.png" /></a>
			</cfif>

		</div>
		<div class="btn-group">

			<cfif APPLICATION.moduleDPDocuments IS true AND len(area_type) IS 0>
				<a href="dp_document_new.cfm?area=#area_id#" onclick="openUrl('dp_document_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="Nuevo Documento DoPlanning" lang="es"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>---> <img src="#APPLICATION.htmlPath#/assets/icons/dp_document.png" /></a>	
			</cfif>
		
		</div>
		<div class="btn-group">

			<a href="event_new.cfm?area=#area_id#" onclick="openUrl('event_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="Nuevo Evento" lang="es"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>---> <img src="#APPLICATION.htmlPath#/assets/icons/event.png" /></a>
		
		</div>
		<div class="btn-group">

			<cfif len(area_type) IS 0>
			<a href="task_new.cfm?area=#area_id#" onclick="openUrl('task_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="Nueva Tarea" lang="es"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>---> <img src="#APPLICATION.htmlPath#/assets/icons/task.png" /></a>
			</cfif>	
		
		</div>
		<div class="btn-group">

			<cfif is_user_area_responsible>

				<cfif APPLICATION.moduleLists IS true>
				<a href="list_new.cfm?area=#area_id#" onclick="openUrl('list_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="Nueva Lista" lang="es"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>&nbsp;---><img src="#APPLICATION.htmlPath#/assets/icons/list.png" alt="Nueva Lista" lang="es"/></a>
				</cfif>
		</div>
		<div class="btn-group">

				<cfif APPLICATION.moduleForms IS true>
				<a href="form_new.cfm?area=#area_id#" onclick="openUrl('form_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="Nuevo Formulario" lang="es"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>&nbsp;---><img src="#APPLICATION.htmlPath#/assets/icons/form.png" alt="Nuevo Formulario" lang="es"/></i></a>
				</cfif>

			</cfif>

		</div>
		<div class="btn-group">


			<cfif APPLICATION.moduleConsultations IS true AND len(area_type) IS 0>
			<a href="consultation_new.cfm?area=#area_id#" onclick="openUrl('consultation_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="Nueva Interconsulta" lang="es"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>&nbsp;---><i class="icon-exchange" style="font-size:19px;line-height:22px;color:##0088CC"></i></a>
			</cfif>

		</div>
		<div class="btn-group">

			<cfif APPLICATION.modulePubMedComments IS true>
			<a href="pubmed_new.cfm?area=#area_id#" onclick="openUrl('pubmed_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="Nueva Publicación" lang="es"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;">---></i>&nbsp;<img src="#APPLICATION.htmlPath#/assets/icons/pubmed.png" /></a> <!--- <i class="icon-book" style="font-size:19px; color:##0088CC"></i> --->
			</cfif>

		</div>
		
		<!---<span class="divider">&nbsp;</span>--->

		<div class="btn-group pull-right">

			<button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false" title="Exportar contenido" lang="es">
				<i class="icon-circle-arrow-down" style="font-size:14px; line-height:23px;"></i> <span class="caret"></span>
			</button>
			<ul class="dropdown-menu" role="menu">
				<li><a href="#APPLICATION.htmlPath#/area_items_pdf.cfm?area=#area_id#" target="blank" title="PDF" lang="es">PDF</a></li>
				<li><a href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=exportAreaItemsDownload&area_id=#area_id#" onclick="return downloadFileLinked(this,event)" title="CSV" lang="es">CSV</a></li>
			</ul>

		</div>

		<div class="btn-group pull-right">

			<cfif app_version NEQ "mobile">
			<a href="#APPLICATION.htmlPath#/area_items.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
			</cfif>

			<a href="#APPLICATION.htmlPath#/area_items_full.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Expandir contenido" lang="es" target="_blank"><i class="icon-external-link-sign" style="font-size:14px; line-height:23px;"></i></a>

		</div>

		<div class="btn-group pull-right">
			<a href="area_items.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>
		</div>



	<cfif APPLICATION.moduleWeb EQ true AND ( area_type EQ "web" OR area_type EQ "intranet" ) AND isDefined("webPathUrl")>

		<!---areaWebUrl--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaWebPageFullUrl" returnvariable="areaPageFullUrl">
			<cfinvokeargument name="area_id" value="#area_id#">
			<cfinvokeargument name="name" value="#objectArea.name#">
			<cfinvokeargument name="remove_order" value="true">
			<cfinvokeargument name="path_url" value="#webPathUrl#">
			<cfinvokeargument name="path" value="#webPath#">
		</cfinvoke>

		<!---<span class="divider">&nbsp;</span>--->

		<div class="btn-group pull-right">

			<a href="#areaPageFullUrl#" class="btn btn-default btn-sm" title="Ver en #area_type#" lang="es" target="_blank"><i class="icon-globe" style="font-size:14px; line-height:23px;"></i></a>

			<cfif SESSION.client_abb EQ "hcs"><!--- Sólo disponible para el HCS porque requiere login en la web --->
				
				<!---areaWebUrl preview--->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaWebPageFullUrl" returnvariable="areaPageFullUrlPreview">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="name" value="#objectArea.name#">
					<cfinvokeargument name="remove_order" value="true">
					<cfinvokeargument name="path_url" value="#webPathUrl#">
					<cfinvokeargument name="path" value="#webPath#">
					<cfinvokeargument name="preview" value="true">
				</cfinvoke>

				<a href="#areaPageFullUrlPreview#" class="btn btn-default btn-sm" title="Vista previa en #area_type# (incluye elementos no publicados)" lang="es" target="_blank"><i class="icon-eye-open" style="font-size:14px; line-height:23px;"></i></a>	

			</cfif>

		</div>

	</cfif>

	</div>
	
	</cfoutput>
</div>

<div style="margin-left:2px; margin-right:2px;">
<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">
</div>

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

<cfif isDefined("URL.file") AND isDefined("URL.download") AND URL.download IS true>
	<cfoutput>
	<iframe style="display:none" src="#APPLICATION.htmlPath#/file_download.cfm?id=#URL.file#"></iframe>
	</cfoutput>
</cfif>


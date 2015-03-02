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

		<cfif objectArea.read_only IS false>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
			</cfinvoke>

			<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

			<cfif len(area_type) GT 0>
				<cfset areaTypeWeb = true>
			<cfelse>
				<cfset areaTypeWeb = false>
			</cfif>

			<cfset previousLoopCurButton = 0>

			<cfloop array="#itemTypesArray#" index="itemTypeId">

				<cfif itemTypeId NEQ 13 AND itemTypeId NEQ 14 AND itemTypeId NEQ 15>
					<cfif ( ( areaTypeWeb AND itemTypesStruct[itemTypeId].web ) OR ( areaTypeWeb IS false AND itemTypesStruct[itemTypeId].noWeb ) ) AND objectArea["item_type_#itemTypeId#_enabled"] IS true>

						<cfset previousLoopCurButton = previousLoopCurButton+1>

					</cfif>

				</cfif>

			</cfloop>


			<cfif previousLoopCurButton GT 0>
				
				<div class="btn-group" style="margin:0">

					<a class="btn btn-link btn-sm" style="cursor:default;"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:20px;line-height:22px;"></i></a>

				</div>

				<cfset loopCurButton = 0>

				<cfloop array="#itemTypesArray#" index="itemTypeId">

					<cfif itemTypeId NEQ 13 AND itemTypeId NEQ 14 AND itemTypeId NEQ 15>
						<cfif objectArea["item_type_#itemTypeId#_enabled"] IS true AND ( ( areaTypeWeb AND itemTypesStruct[itemTypeId].web ) OR ( areaTypeWeb IS false AND itemTypesStruct[itemTypeId].noWeb ) ) AND ( (itemTypeId NEQ 11 AND itemTypeId NEQ 12) OR is_user_area_responsible )>

							<cfset loopCurButton = loopCurButton+1>

							<cfif itemTypesStruct[itemTypeId].gender EQ "male">
								<cfset newItemTitle = "Nuevo">
							<cfelse>
								<cfset newItemTitle = "Nueva">
							</cfif>
							
							<div class="btn-group" <cfif loopCurButton IS 1>style="margin-left:0"</cfif>>
								
								<cfif itemTypeId IS 10><!---File--->
									<a href="area_file_new.cfm?area=#area_id#&fileTypeId=1" onclick="openUrl('area_file_new.cfm?area=#area_id#&fileTypeId=1', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="#newItemTitle# #itemTypesStruct[itemTypeId].label#" lang="es">
								<cfelse>
									<a href="#itemTypesStruct[itemTypeId].name#_new.cfm?area=#area_id#" onclick="openUrl('#itemTypesStruct[itemTypeId].name#_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="#newItemTitle# #itemTypesStruct[itemTypeId].label#" lang="es">
								</cfif>
								
								<cfif itemTypeId IS 7><!---Consultations--->
									<i class="icon-exchange" style="font-size:19px;line-height:22px;color:##0088CC"></i>
								<cfelseif itemTypeId IS 13><!---Typologies--->
									<i class="icon-file-text" style="font-size:19px; line-height:23px; color:##7A7A7A"></i>
								<cfelse>
									<img src="#APPLICATION.htmlPath#/assets/icons/#itemTypesStruct[itemTypeId].name#.png" alt="#newItemTitle# #itemTypesStruct[itemTypeId].label#" lang="es"/>
								</cfif>
								</a>
								
							</div>

							<cfif itemTypeId IS 10>
								
								<div class="btn-group">

									<cfif APPLICATION.moduleAreaFilesLite IS true AND len(area_type) IS 0>
									<a href="area_file_new.cfm?area=#area_id#&fileTypeId=2" onclick="openUrl('area_file_new.cfm?area=#area_id#&fileTypeId=2', 'itemIframe', event)" class="btn btn-default btn-sm btn-new-item-dp" title="Nuevo Archivo de área" lang="es"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>---> <img src="#APPLICATION.htmlPath#/assets/icons/file_area.png" /></a>
									</cfif>

								</div>

							</cfif>

							<cfif loopCurButton EQ previousLoopCurButton>
								<cfbreak>
							</cfif>
									
						</cfif>
					</cfif>

				</cfloop>

			<cfelse>

				<!---<div class="btn-group" style="margin-left:0">
					<button class="btn btn-link disabled" lang="es">Está deshabilitada la creación de nuevos elementos en esta área</button>
				</div>--->

			</cfif>


		</cfif>


		<div class="btn-group pull-right">

			<button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false" title="Exportar contenido" lang="es">
				<i class="icon-circle-arrow-down" style="font-size:14px; line-height:23px;"></i> <span class="caret"></span>
			</button>
			<ul class="dropdown-menu" role="menu">
				<li><a href="#APPLICATION.htmlPath#/area_items_pdf.cfm?area=#area_id#" target="_blank" title="PDF" lang="es">PDF</a></li>
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


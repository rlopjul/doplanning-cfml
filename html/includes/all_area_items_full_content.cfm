<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8" type="text/javascript"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<script src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js?v=4.4.4.4"></script>

</cfoutput>

<div class="container-fluid">

	<div class="row">
		<div class="col-sm-12">
		<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">
			<cfoutput>
			<div class="btn-toolbar" style="margin-bottom:10px;">
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
					<a href="area_items_full.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>
				</div>
			</div>
			</cfoutput>
		</div>
	</div>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllAreaItems" returnvariable="getAllAreaItemsResult">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="area_type" value="#area_type#">
	<cfinvokeargument name="full_content" value="true">
	<!---<cfif isDefined("limit_to") AND isNumeric(limit_to)>
	<cfinvokeargument name="limit" value="#limit_to#">
	</cfif>--->
</cfinvoke>

<cfset areaItemsQuery = getAllAreaItemsResult.query>
<cfset numItems = areaItemsQuery.recordCount>

	<div class="row">
		<div class="col-sm-12">

		<cfif numItems GT 0>
			
			<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsList">
				<cfinvokeargument name="itemsQuery" value="#areaItemsQuery#">
				<cfinvokeargument name="area_type" value="#area_type#">
				<cfinvokeargument name="return_page" value="area_items.cfm?area=#area_id#">
				<cfinvokeargument name="app_version" value="#app_version#">
			</cfinvoke>--->


					<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsFullList">
						<cfinvokeargument name="itemsQuery" value="#areaItemsQuery#">
						<cfinvokeargument name="return_path" value="#APPLICATION.htmlPath#/">
						<cfinvokeargument name="area_id" value="#area_id#"/>
					</cfinvoke>
				</div>
			</div>

		<cfelse>
			
			<!---<script type="text/javascript">
				openUrlHtml2('empty.cfm','itemIframe');
			</script>--->				

			<cfoutput>
			<!---<div class="div_text_result"><span lang="es">No hay elementos en esta área.</span></div>--->
			<div class="alert alert-info" role="alert" style="margin:10px;"><i class="icon-info-sign"></i> <span lang="es">Aún nadie ha puesto información aquí, ¿por qué no ser el primero?</span></div>
			</cfoutput>
		</cfif>

		</div>
	</div>

</div>
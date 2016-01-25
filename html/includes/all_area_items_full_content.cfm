<cfoutput>
<!---
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8"></script>
 --->

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<!---<script src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js?v=4.4.4.4"></script>--->
<!---<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.6.4/summernote.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.6.4/summernote.min.js"></script>--->

</cfoutput>

<!---<div class="container-fluid">--->

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
		<div><!---col-sm-12--->

			<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu.cfm">

		</div>
	</div>

	<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

	<!---
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
	--->

	<div class="row">
		<div class="col-sm-12">

		<cfif numItems GT 0>

			<cfinclude template="#APPLICATION.htmlPath#/includes/isotope_scripts.cfm">

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsFullList">
				<cfinvokeargument name="itemsQuery" value="#areaItemsQuery#">
				<cfinvokeargument name="return_path" value="#APPLICATION.htmlPath#/">
				<cfinvokeargument name="area_id" value="#area_id#"/>
				<cfinvokeargument name="area_read_only" value="#objectArea.read_only#">
				<cfinvokeargument name="area_type" value="#area_type#">
				<cfinvokeargument name="app_version" value="#app_version#">
			</cfinvoke>

			<!---</div>
		</div>--->

		<cfelseif objectArea.read_only IS false>

			<!---<script type="text/javascript">
				openUrlHtml2('empty.cfm','itemIframe');
			</script>--->

			<cfoutput>
			<!---<div class="div_text_result"><span lang="es">No hay elementos en esta área.</span></div>--->
			<div class="alert alert-info" role="alert" style="margin:10px;"><i class="icon-info-sign"></i> <span lang="es">Aún nadie ha puesto información aquí, ¿por qué no ser el primero?</span><button type="button" class="close" data-dismiss="alert" aria-label="Cerrar alerta">
			  <span aria-hidden="true">&times;</span>
			</button>
			</div>
			</cfoutput>

		</cfif>

		</div>
	</div>

<!---</div>--->

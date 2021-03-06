<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfif isDefined("URL.#tableTypeName#")>
	<cfset table_id = URL[#tableTypeName#]>
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getItem" returnvariable="objectItem">
	<cfinvokeargument name="item_id" value="#table_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>

<cfif objectItem.general IS true><!---General List OR Form --->

	<cfif isDefined("URL.area") AND isNumeric(URL.area)>
		<cfset area_id = URL.area>
	<cfelse>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableRowsInUserAreas" returnvariable="getTableRowsInUserAreasResponse">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<cfif getTableRowsInUserAreasResponse.result IS true AND getTableRowsInUserAreasResponse.query.recordCount GT 0>

			<cfset area_id = getTableRowsInUserAreasResponse.query.area_id>

		<cfelse>

			<cflocation url="#APPLICATION.htmlPath#/error.cfm?error_code=104" addtoken="false">

		</cfif>

	</cfif>

<cfelse>
	<cfset area_id = objectItem.area_id>
</cfif>

<!---Table fields--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	<cfinvokeargument name="with_types" value="true">
	<cfif isDefined("URL.search_id") AND isNumeric(URL.search_id)>
		<cfinvokeargument name="search_id" value="#URL.search_id#">
	</cfif>
</cfinvoke>
<cfset allFields = fieldsResult.tableFields>

<cfquery dbtype="query" name="fields">
	SELECT *
	FROM allFields
	WHERE include_in_list = <cfqueryparam value="true" cfsqltype="cf_sql_bit">;
</cfquery>

<!---Table rows--->

<cfif isDefined("URL.search")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableRowsSearch" argumentCollection="#URL#" returnvariable="tableRowsResult">
		<cfinvokeargument name="table_id" value="#table_id#">
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		<cfinvokeargument name="fields" value="#fields#">
	</cfinvoke>

<cfelse>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableRows" returnvariable="tableRowsResult">
		<cfinvokeargument name="table_id" value="#table_id#">
		<cfif objectItem.general IS true>
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfif>
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		<cfinvokeargument name="fields" value="#fields#">
	</cfinvoke>

</cfif>

<cfset tableRows = tableRowsResult.rows>

<cfif objectItem.list_rows_by_default IS true OR isDefined("URL.search")>

	<!--- creation_date --->
	<!---<cfset queryAddRow(fields, 1)>
	<cfset querySetCell(fields, "field_id", "creation_date")>
	<cfset querySetCell(fields, "label", "Fecha de creación")>
	<cfset querySetCell(fields, "position", 0)>--->

	<!--- last_update_date --->
	<cfset queryAddRow(fields, 1)>
	<cfset querySetCell(fields, "field_id", "last_update_date")>
	<cfset querySetCell(fields, "label", "Fecha de última modificación")>
	<cfset querySetCell(fields, "position", 0)>

	<cfif tableTypeId IS 2><!--- Forms --->
		<!--- insert_user --->
		<cfset queryAddRow(fields, 1)>
		<cfset querySetCell(fields, "field_id", "insert_user")>
		<cfset querySetCell(fields, "label", "Usuario ")>
		<cfset querySetCell(fields, "position", 0)>
	</cfif>

	<!--- update_user --->
	<!---<cfset queryAddRow(fields, 1)>
	<cfset querySetCell(fields, "field_id", "update_user")>
	<cfset querySetCell(fields, "label", "Usuario última modificación")>
	<cfset querySetCell(fields, "position", 0)>--->

</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>

<!---<div class="div_message_page_title">#objectItem.title#</div>
<div class="div_separator"><!-- --></div>--->

<!---<cfinclude template="#APPLICATION.htmlPath#/includes/area_path.cfm">--->

<div class="row">

	<div class="col-sm-12">


		<div class="div_elements_menu">

			<!---checkListPermissions--->
			<cfset table_edit_permission = true>

			<cfif is_user_area_responsible IS false>

				<cfif tableTypeId IS 1 AND objectItem.general IS false AND APPLICATION.moduleListsWithPermissions IS true><!---IS List and list permissions is enabled--->

					<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="isUserInTable" returnvariable="isUserInTable">
						<cfinvokeargument name="table_id" value="#table_id#">
						<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					</cfinvoke>

					<cfif isUserInTable IS false>
						<cfset table_edit_permission = false>
					</cfif>

				</cfif>

			</cfif>


			<div class="btn-toolbar" style="padding-right:5px;">

				<!---<a href="area_items.cfm?area=#area_id#&#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="#tableTypeNameEs#" lang="es"> <img style="height:20px;" src="/html/assets/icons/#itemTypeName#.png" alt="#tableTypeNameEs#">&nbsp;&nbsp;<span lang="es">#tableTypeNameEs#</span></a>--->

				<!---<div class="btn-group">
					<a href="area_items.cfm?area=#area_id#&#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Área" lang="es"> <img src="/html/assets/icons_dp/area_small.png" style="height:17px;" alt="Área">&nbsp;<span lang="es">Área</span></a>
				</div>--->


				<cfif ( is_user_area_responsible OR table_edit_permission IS true ) AND objectArea.read_only IS false>
					<div class="btn-group">
						<a href="#tableTypeName#_row_new.cfm?#tableTypeName#=#table_id#&area=#area_id#" onclick="openUrl('#tableTypeName#_row_new.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-primary btn-sm" title="Nuevo registro" lang="es"><i class="icon-plus" style="font-size:14px;"></i> <span lang="es">Nuevo registro</span></a><!---color:##5BB75B;--->
					</div>

					<div class="btn-group">

						<a href="#tableTypeName#_row_import.cfm?#tableTypeName#=#table_id#&area=#area_id#" class="btn btn-default btn-sm" title="Importar registros" lang="es"><i class="icon-arrow-up" style="color:##5BB75B;font-size:15px;"></i> <span lang="es">Importar</span></a><!--- onclick="openUrl('#tableTypeName#_row_import.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)"--->

						<cfif tableTypeId IS 1 AND SESSION.client_abb EQ "ceseand" AND objectItem.area_id EQ area_id AND ListFind("1,2,3", table_id) GT 0><!--- Lists --->
							<a href="#tableTypeName#_row_import_xml.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Importar registros a partir de XML" lang="es"><i class="icon-arrow-up" style="color:##5BB75B;font-size:15px;"></i> <span lang="es">Importar XML</span></a>
						</cfif>

				<cfelse>
					<div class="btn-group">
				</cfif>

					<a href="#tableTypeName#_row_export.cfm?#tableTypeName#=#table_id#&area=#area_id#" class="btn btn-default btn-sm" title="Exportar registros" lang="es"><i class="icon-arrow-down" style="font-size:15px;"></i> <span lang="es">Exportar</span></a>

				</div>

				<!---<span class="divider">&nbsp;</span>--->


				<cfif objectItem.area_id EQ area_id AND is_user_area_responsible AND objectArea.read_only IS false>

					<div class="btn-group">
						<a href="#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Campos" lang="es"><i class="icon-wrench"></i> <span lang="es">Campos</span></a>
					</div>

					<cfif tableTypeId IS NOT 3>
						<div class="btn-group">
							<a href="#tableTypeName#_actions.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Acciones" lang="es"><i class="fa fa-cogs"></i> <span lang="es">Acciones</span></a>
						</div>
					</cfif>


					<cfif APPLICATION.moduleListsWithPermissions IS true AND itemTypeId IS 11><!---List with permissions--->
						<div class="btn-group">
							<a href="#itemTypeName#_users.cfm?#itemTypeName#=#table_id#" class="btn btn-default btn-sm" title="Editores" lang="es"><i class="icon-group"></i> <span lang="es">Editores</span></a>
						</div>
					</cfif>

				</cfif>

				<cfif objectItem.list_rows_by_default IS true>
					<div class="btn-group">
						<!---<button id="dataTablePopover#tableTypeId#_#table_id#" type="button" class="btn btn-default btn-sm" data-trigger="focus" title="Filtrado de columnas">--->

						<button id="dataTablePopover#tableTypeId#_#table_id#" type="button" class="btn btn-default btn-sm" data-toggle="collapse" data-target="##columnSelectorCollapse" aria-expanded="false" aria-controls="columnSelectorCollapse">
						  <i class="fa fa-eye-slash"></i> <span lang="es">Mostrar/ocultar columnas</span>
						</button>

					</div>
				</cfif>

				<!---<script>

					$(document).ready(function() {

						$('##dataTablePopover#tableTypeId#_#table_id#').popover({
						      placement: 'bottom',
						      html: true, // required if content has HTML
						      content: '<ul class="list-unstyled" id="popoverTarget#tableTypeId#_#table_id#"></ul>'
						    })
						    // bootstrap popover event triggered when the popover opens
						    .on('shown.bs.popover', function () {
						      // call this function to copy the column selection code into the popover
						      $.tablesorter.columnSelector.attachTo( $("##dataTable#tableTypeId#_#table_id#"), '##popoverTarget#tableTypeId#_#table_id#');
						});

					});

				</script>--->


				<cfif objectItem.area_id EQ area_id AND ( is_user_area_responsible OR objectItem.user_in_charge EQ SESSION.user_id )>

					<cfif itemTypeId IS 11 OR itemTypeId IS 12>

						<cfif is_user_area_responsible>

							<div class="btn-group">
								<a href="#itemTypeName#_views.cfm?#itemTypeName#=#table_id#&area=#objectItem.area_id#" class="btn btn-default btn-sm" title="Vistas" lang="es"><i class="icon-screenshot"></i> <span lang="es">Vistas</span></a>
							</div>

						</cfif>

						<cfif objectArea.read_only IS false>

							<div class="btn-group">
								<button class="btn btn-info dropdown-toggle btn-sm" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
									<span lang="es">Más</span>
									<span class="caret"></span>
								</button>
								<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">

									<cfif is_user_area_responsible>

										<!---<cfif isDefined("URL.return_page") AND len(URL.return_page) GT 0>
											<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path##URL.return_page#")>
										<cfelse>
											<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path#area_items.cfm?area=#area_id#")>
										</cfif>

										<cfset url_return_path = "&return_path="&URLEncodedFormat("#return_path#area_items.cfm?area=#area_id#&#itemTypeName#=#table_id#")>--->

										<!---<cfif isDefined("URL.return_page") AND len(URL.return_page) GT 0>
											<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path##URL.return_page#")>
										<cfelse>
											<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path##itemTypeName#_rows.cfm?#itemTypeName#=#table_id#&area=#area_id#")>
										</cfif>--->

										<cfset url_return_page = "&return_page="&URLEncodedFormat("#itemTypeName#_rows.cfm?#itemTypeName#=#table_id#&area=#area_id#")>

										<cfset url_return_path = "&return_path="&URLEncodedFormat("#return_path##itemTypeName#_rows.cfm?#itemTypeName#=#table_id#&area=#area_id#")>
										<cfset url_return_path_delete = "&return_page="&URLEncodedFormat("#return_path#area_items.cfm?area=#area_id#")>

										<li><a href="#tableTypeName#_modify.cfm?#tableTypeName#=#table_id#&area=#area_id##url_return_page#" onclick="openUrl('#tableTypeName#_modify.cfm?#tableTypeName#=#table_id#&area=#area_id##url_return_page#', 'itemIframe', event)"><i class="icon-edit icon-white"></i> <span lang="es">Modificar #itemTypeNameEs#</span></a></li>

										<!--- publication --->
										<cfif objectItem.publication_validated IS false>

											<cfif SESSION.client_abb NEQ "hcs" OR objectItem.publication_scope_id NEQ 1><!---En el DP HCS el ámbito de publicación 1 es DoPlanning, que no requiere aprobación de publicación--->
												 <li><a href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=changeItemPublicationValidation&item_id=#table_id#&itemTypeId=#itemTypeId#&validate=true#url_return_path#" onclick="return confirmReversibleAction('Permitir la publicación en web');" title="Permitir la publicación en web"><i class="icon-check"></i> <span lang="es">Aprobar publicación</span></a></li>
											</cfif>

										<cfelse>
											<li><a href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=changeItemPublicationValidation&item_id=#table_id#&itemTypeId=#itemTypeId#&validate=false#url_return_path#" onclick="return confirmReversibleAction('Impedir la publicación en web');" title="Impedir la publicación en web"><i class="icon-remove-sign"></i> <span lang="es">Desaprobar publicación</span></a></li>
										</cfif>

										<!--- getClient --->
										<cfinvoke component="#APPLICATION.htmlPath#/components/Client" method="getClient" returnvariable="clientQuery">
											<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
										</cfinvoke>

										<cfif clientQuery.bin_enabled IS true><!--- BIN Enabled --->

											<li><a href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteItem&item_id=#table_id#&area_id=#area_id#&itemTypeId=#itemTypeId##url_return_path_delete#" onclick="return confirmReversibleAction('eliminar');" title="Eliminar"><i class="icon-trash"></i> <span lang="es">Eliminar</span></a></li>

										<cfelse>

											<li><a href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteItem&item_id=#table_id#&area_id=#area_id#&itemTypeId=#itemTypeId##url_return_path_delete#" onclick="return confirmAction('eliminar');" title="Eliminar"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a></li>

										</cfif>


									</cfif>

									<cfif objectItem.user_in_charge EQ SESSION.user_id OR is_user_area_responsible>

										<li><a href="item_change_user.cfm?item=#table_id#&itemTypeId=#itemTypeId#&area=#area_id#" onclick="openUrl('item_change_user.cfm?item=#table_id#&itemTypeId=#itemTypeId#&area=#area_id#', 'itemIframe', event)"><i class="icon-user"></i> <span lang="es">Cambiar propietario</span></a></li>

										<cfif tableTypeId IS NOT 3 AND APPLICATION.changeElementsArea IS true>
											<li><a href="item_change_area.cfm?item=#table_id#&itemTypeId=#itemTypeId#&area=#area_id#" onclick="openUrl('item_change_area.cfm?item=#table_id#&itemTypeId=#itemTypeId#&area=#area_id#', 'itemIframe', event)"><i class="icon-cut"></i> <span lang="es">Mover a otra área</span></a></li>
										</cfif>

									</cfif>

								</ul>
							</div>


						</cfif><!--- END objectArea.read_only IS false --->


					</cfif>

				</cfif>

				<!---<span class="divider">&nbsp;</span>--->


				<!---<a href="#itemTypeNameP#.cfm?area=#area_id#" class="btn btn-default btn-sm" title="#itemTypeNameEsP# del área" lang="es"> <span lang="es">#itemTypeNameEsP# del área</span></a>

				<span class="divider">&nbsp;</span>--->

				<cfif app_version NEQ "mobile">
					<div class="btn-group pull-right">
						<a href="#APPLICATION.htmlPath#/#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px;"></i></a>
					</div>

					<div class="btn-group pull-right">
						<a href="#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px;"></i></a>
					</div>
				</cfif>

			</div><!--- END btn-toolbar --->

			<div class="collapse" id="columnSelectorCollapse">
				<div class="well">
					<p lang="es">Selecciona las columnas que quieres ver</p>
				  	<ul class="list-inline" id="columnSelector#tableTypeId#_#table_id#">

				  	</ul>
				</div>
			</div>


		</div><!--- END div_elements_menu --->

		<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">


	</div><!--- END col-sm-12 --->

</div><!--- END row --->


<cfif allFields.recordCount GT 0>

		<cfif objectItem.list_rows_by_default IS false OR tableRows.recordCount GT 2000 OR isDefined("URL.search")>


			<cfif tableTypeId IS 1><!---Lists--->

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableSearchs" returnvariable="tableSearchsResponse">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				</cfinvoke>

				<cfset tableSearchs = tableSearchsResponse.query>

				<cfif tableSearchs.recordCount GT 0>

					<form action="#CGI.SCRIPT_NAME#" method="get" name="searchs_form">
						<input type="hidden" name="#tableTypeName#" value="#table_id#"/>
						<input type="hidden" name="area" value="#area_id#"/>

						<label class="control-label" for="search_id" lang="es">Búsqueda predefinida</label>
						<select name="search_id" id="search_id" class="form-control" onchange="submitForm('searchs_form')">
							<option value=""></option>
							<cfloop query="tableSearchs">
								<option value="#tableSearchs.id#" <cfif isDefined("URL.search_id") AND URL.search_id EQ tableSearchs.id>selected</cfif>>#tableSearchs.title#</option>
							</cfloop>
						</select>
					</form>

				</cfif>

			</cfif>

			<cfif isDefined("URL.search")><!---isDefined("URL.name") AND --->

				<cfset row = URL>

			<cfelseif isDefined("URL.search_id") AND isNumeric(URL.search_id)><!---isDefined("URL.search_id")--->

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getEmptyRow" returnvariable="emptyRow">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="fields" value="#allFields#">
				</cfinvoke>

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="fillEmptyRow" returnvariable="row">
					<cfinvokeargument name="emptyRow" value="#emptyRow#">
					<cfinvokeargument name="fields" value="#allFields#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="withDefaultValues" value="false">
					<cfinvokeargument name="withSearchValues" value="true">
				</cfinvoke>

			<cfelse>

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getEmptyRow" returnvariable="emptyRow">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="fields" value="#allFields#">
				</cfinvoke>

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="fillEmptyRow" returnvariable="row">
					<cfinvokeargument name="emptyRow" value="#emptyRow#">
					<cfinvokeargument name="fields" value="#allFields#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="withDefaultValues" value="false">
				</cfinvoke>

			</cfif>


			<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
			<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
			<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>
			<script src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js?v=2"></script>

			<script src="#APPLICATION.htmlPath#/scripts/tablesFunctions.js?v=2.2"></script>

			<script>

				function openUserSelectorWithField(fieldName){

					return openPopUp('#APPLICATION.mainUrl##APPLICATION.htmlPath#/iframes/users_select.cfm?field='+fieldName);

				}

				function openItemSelectorWithField(itemTypeId,fieldName){

					return openPopUp('#APPLICATION.mainUrl##APPLICATION.htmlPath#/iframes/all_items_select.cfm?itemTypeId='+itemTypeId+'&field='+fieldName);

				}

			</script>

			<h4 lang="es">Búsqueda de registros</h4>

			<cfform method="get" name="search_form" action="#CGI.SCRIPT_NAME#" class="form-horizontal" onsubmit="return onSubmitForm();">

				<script>
					var railo_custom_form;

					if( typeof LuceeForms !== 'undefined' && $.isFunction(LuceeForms) )
						railo_custom_form = new LuceeForms('search_form');
					else
						railo_custom_form = new RailoForms('search_form');
				</script>

				<input type="hidden" name="#tableTypeName#" value="#table_id#"/>
				<input type="hidden" name="area" value="#area_id#"/>

				<!--- outputRowFormInputs --->
				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="outputRowFormInputs">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="row" value="#row#">
					<cfinvokeargument name="fields" value="#allFields#">
					<cfinvokeargument name="search_inputs" value="true">
					<cfinvokeargument name="displayType" value="horizontal">
				</cfinvoke>

				<div class="row">
					<div class="col-xs-offset-0 col-xs-12 col-sm-offset-3 col-sm-7 col-md-offset-3 col-md-4 col-lg-3">

						<button type="submit" name="search" class="btn btn-success btn-lg btn-block" style="margin-top:30px;text-align:left;"><i class="icon-search"></i> <span lang="es">Buscar</span></button>

					</div>
				</div>

			</cfform>

	</cfif>

	<div class="row">
		<div class="col-sm-12">
			<span class="label label-primary">#tableRows.recordCount# <span lang="es">Registros</span></span>
		</div>
	</div>

	<cfif ( objectItem.list_rows_by_default IS true AND tableRows.recordCount LT 2000 ) OR isDefined("URL.search")>

			<cfif tableRows.recordCount GT 0>

				<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

				<div class="container-fluid" style="position:absolute;width:100%;left:0;">

					<div class="row">

						<div class="col-sm-12">

							<!--- outputRowList --->
							<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="outputRowList">
								<cfinvokeargument name="table_id" value="#table_id#">
								<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
								<cfinvokeargument name="tableRows" value="#tableRows#">
								<cfinvokeargument name="fields" value="#fields#">
								<cfinvokeargument name="openRowOnSelect" value="true">
								<cfinvokeargument name="app_version" value="#app_version#">
								<cfinvokeargument name="columnSelectorContainer" value="columnSelector#tableTypeId#_#table_id#">
								<cfinvokeargument name="tablesorterEnabled" value="true">
								<cfinvokeargument name="stickyHeadersEnabled" value="true">
								<cfinvokeargument name="includeLinkButton" value="true">
								<cfif tableTypeId IS 1 AND ( is_user_area_responsible OR table_edit_permission IS true ) AND objectArea.read_only IS false>
									<cfinvokeargument name="includeEditButton" value="true">
								</cfif>
								<cfinvokeargument name="mathEnabled" value="#objectItem.math_enabled#">
								<cfinvokeargument name="table_general" value="#objectItem.general#">
								<cfinvokeargument name="area_id" value="#area_id#">
								<cfif objectItem.general IS true>
									<cfinvokeargument name="includeFromAreaColumn" value="true">
								</cfif>
								<cfinvokeargument name="fileUrlPath" value="file_download.cfm">
							</cfinvoke>

						</div><!--- END col-sm-12 --->

					</div><!--- END row --->

					<cfif objectItem.general IS true>
						<div class="row">
							<div class="col-sm-12">
								<small class="help-block">#itemTypeNameEs# global, se incluyen los registros de esta área y las inferiores</small>
							</div>
						</div>
					</cfif>

				</div><!--- END container-fluid --->

			</cfif>

	</cfif>


<cfelse>

	<div class="alert alert-warning" role="alert"><i class="fa fa-warning"></i> <span lang="es">No hay campos definidos para rellenar.</span></div>

</cfif><!---allFields.recordCount GT 0--->

</cfoutput>

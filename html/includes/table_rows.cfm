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

<!---Table fields--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset fields = fieldsResult.tableFields>

<!---Table rows--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableRows" returnvariable="tableRowsResult">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	<cfinvokeargument name="fields" value="#fields#">
</cfinvoke>
<cfset tableRows = tableRowsResult.rows>

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

<!--- insert_user --->
<!---<cfset queryAddRow(fields, 1)>
<cfset querySetCell(fields, "field_id", "insert_user")>
<cfset querySetCell(fields, "label", "Usuario creación")>
<cfset querySetCell(fields, "position", 0)>--->

<!--- update_user --->
<!---<cfset queryAddRow(fields, 1)>
<cfset querySetCell(fields, "field_id", "update_user")>
<cfset querySetCell(fields, "label", "Usuario última modificación")>
<cfset querySetCell(fields, "position", 0)>--->

<cfset area_id = objectItem.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>

<div class="div_message_page_title">#objectItem.title#</div>
<div class="div_separator"><!-- --></div>

<div class="div_head_subtitle_area">

	<!---checkListPermissions--->
	<cfset table_edit_permission = true>

	<cfif is_user_area_responsible IS false>
		
		<cfif tableTypeId IS 1 AND APPLICATION.moduleListsWithPermissions IS true><!---IS List and list permissions is enabled--->

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

		<div class="btn-group">
			<a href="area_items.cfm?area=#area_id#&#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Área" lang="es"> <img src="/html/assets/icons_dp/area_small.png" style="height:17px;" alt="Área">&nbsp;<span lang="es">Área</span></a>
		</div>
		

		<cfif ( is_user_area_responsible OR table_edit_permission IS true ) AND objectArea.read_only IS false>
			<div class="btn-group">
				<a href="#tableTypeName#_row_new.cfm?#tableTypeName#=#table_id#" onclick="openUrl('#tableTypeName#_row_new.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-info btn-sm" title="Nuevo registro" lang="es"><i class="icon-plus" style="font-size:14px;"></i> <span>Nuevo registro</span></a><!---color:##5BB75B;--->
			</div>

			<div class="btn-group">
				<a href="#tableTypeName#_row_import.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Importar registros" lang="es"><i class="icon-arrow-up" style="color:##5BB75B;font-size:15px;"></i> <span>Importar</span></a><!--- onclick="openUrl('#tableTypeName#_row_import.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)"--->

		<cfelse>
			<div class="btn-group">
		</cfif>	
		
			<a href="#tableTypeName#_row_export.cfm?#tableTypeName#=#table_id#" onclick="openUrl('#tableTypeName#_row_export.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-default btn-sm" title="Exportar registros" lang="es"><i class="icon-arrow-down" style="font-size:15px;"></i> <span>Exportar</span></a>

		</div>

		<!---<span class="divider">&nbsp;</span>--->
		


		<cfif is_user_area_responsible  AND objectArea.read_only IS false>
			
			<div class="btn-group">
				<a href="#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Campos" lang="es"><i class="icon-wrench"></i> <span lang="es">Campos</span></a>
			</div>

			<cfif APPLICATION.moduleListsWithPermissions IS true AND itemTypeId IS 11><!---List with permissions--->
				<div class="btn-group">
					<a href="#itemTypeName#_users.cfm?#itemTypeName#=#table_id#" class="btn btn-default btn-sm" title="Editores" lang="es"><i class="icon-group"></i> <span lang="es">Editores</span></a>
				</div>
			</cfif>

		</cfif>

		<cfif is_user_area_responsible OR objectItem.user_in_charge EQ SESSION.user_id>

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
		</cfif>

		<div class="btn-group pull-right">
			<a href="#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px;"></i></a>
		</div>

	</div>

</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_items">

	<cfif tableRows.recordCount GT 0>

		<!---<cfinclude template="#APPLICATION.htmlPath#/includes/table_rows_list.cfm">--->

		<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

		<!--- outputRowList --->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="outputRowList">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			<cfinvokeargument name="tableRows" value="#tableRows#">
			<cfinvokeargument name="fields" value="#fields#">
			<cfinvokeargument name="openRowOnSelect" value="true">
			<cfinvokeargument name="app_version" value="#app_version#">
		</cfinvoke>

	<cfelse>
	
		<script type="text/javascript">
			openUrlHtml2('empty.cfm','itemIframe');
		</script>				

		<div class="div_text_result"><span lang="es">No hay datos introducidos.</span></div>

	</cfif>
	
</div>
</cfoutput>
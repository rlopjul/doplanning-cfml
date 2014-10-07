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
	
	<a href="area_items.cfm?area=#area_id#&#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="#tableTypeNameEs#" lang="es"> <img style="height:20px;" src="/html/assets/icons/#itemTypeName#.png" alt="#tableTypeNameEs#">&nbsp;&nbsp;<span lang="es">#tableTypeNameEs#</span></a>

	<cfif is_user_area_responsible OR table_edit_permission IS true>
		<a href="#tableTypeName#_row_new.cfm?#tableTypeName#=#table_id#" onclick="openUrl('#tableTypeName#_row_new.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-default btn-sm" title="Nuevo registro" lang="es"><i class="icon-plus" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <span>Nuevo registro</span></a>

		<a href="#tableTypeName#_row_import.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Importar registros" lang="es"><i class="icon-arrow-up" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <span>Importar</span></a><!--- onclick="openUrl('#tableTypeName#_row_import.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)"--->
	</cfif>	
	
	<a href="#tableTypeName#_row_export.cfm?#tableTypeName#=#table_id#" onclick="openUrl('#tableTypeName#_row_export.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-default btn-sm" title="Exportar registros" lang="es"><i class="icon-arrow-down" style="font-size:15px;line-height:20px;"></i> <span>Exportar</span></a>

	<span class="divider">&nbsp;</span>
	

	<cfif is_user_area_responsible>
		<a href="#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Campos" lang="es"><i class="icon-list"></i> <span lang="es">Campos</span></a>

		<cfif APPLICATION.moduleListsWithPermissions IS true AND itemTypeId IS 11><!---List with permissions--->
			<a href="#itemTypeName#_users.cfm?#itemTypeName#=#table_id#" class="btn btn-default btn-sm" title="Editores" lang="es"><i class="icon-group"></i> <span lang="es">Editores</span></a>
		</cfif>

		<cfif itemTypeId IS 11 OR itemTypeId IS 12>
			<a href="#itemTypeName#_views.cfm?#itemTypeName#=#table_id#&area=#objectItem.area_id#" class="btn btn-default btn-sm" title="Vistas" lang="es"><i class="icon-screenshot"></i> <span lang="es">Vistas</span></a>
		</cfif>
		
		<span class="divider">&nbsp;</span>
	</cfif>

	<!---<a href="#itemTypeNameP#.cfm?area=#area_id#" class="btn btn-default btn-sm" title="#itemTypeNameEsP# del área" lang="es"> <span lang="es">#itemTypeNameEsP# del área</span></a>

	<span class="divider">&nbsp;</span>--->

	<cfif app_version NEQ "mobile">
		<a href="#APPLICATION.htmlPath#/#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
	</cfif>

	<a href="#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>

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
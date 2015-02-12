<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8"></script>
</cfoutput>

<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfif isDefined("URL.row") AND isNumeric(URL.row) AND isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
	<cfset row_id = URL.row>
	<cfset table_id = URL[tableTypeName]>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>

<!--- getRow --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getRow" returnvariable="getRowResponse">
	<cfinvokeargument name="table_id" value="#table_id#"/>
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#"/>
	<cfinvokeargument name="row_id" value="#row_id#"/>
</cfinvoke>

<cfset row = getRowResponse.row>
<cfset table = getRowResponse.table>
<cfset area_id = table.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<!---<cfif app_version NEQ "html2">
	<div class="div_head_subtitle">
	<cfoutput>
	<span lang="es">Campo</span>
	</cfoutput>
	</div>
</cfif>--->

<cfif isDefined("URL.return_page") AND len(URL.return_page) GT 0>
	<cfset url_return_path = "&return_path="&URLEncodedFormat("#return_path##URL.return_page#")>
<cfelse>
	<cfset url_return_path = "&return_path="&URLEncodedFormat("#return_path##tableTypeNameP#.cfm?area=#area_id#")>
</cfif>

<script type="text/javascript">

	function confirmDeleteRow() {
	
		var message_delete = "Si ELIMINA el registro, se borrarán definitivamente todos los contenidos que almacena. ¿Seguro que desea eliminar el registro?";
		return confirm(message_delete);
	}

</script>


<cfoutput>

<div class="div_message_page_title">Registro #row.row_id#</div>
<div class="div_separator"><!-- --></div>


<!---checkListPermissions--->
<cfset table_edit_permission = false>

<cfif is_user_area_responsible IS false>
	
	<cfif tableTypeId IS 1 AND APPLICATION.moduleListsWithPermissions IS true><!---IS List and list permissions is enabled--->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="isUserInTable" returnvariable="isUserInTable">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>	

		<cfif isUserInTable IS true>
			<cfset table_edit_permission = true>
		</cfif>

	<cfelseif tableTypeId IS NOT 2><!--- IS NOT Form --->
		<cfset table_edit_permission = true>
	</cfif>

</cfif>


<div class="div_elements_menu"><!---div_elements_menu--->
	
	<cfif ( is_user_area_responsible OR table_edit_permission IS true ) AND objectArea.read_only IS false>

		<cfif tableTypeId IS NOT 2><!--- IS NOT Form --->
			<a href="#tableTypeName#_row_modify.cfm?#tableTypeName#=#table_id#&row=#row_id#" class="btn btn-sm btn-info"><i class="icon-edit icon-white"></i> <span lang="es">Modificar</span></a>
		</cfif>
		
		<a href="#APPLICATION.htmlComponentsPath#/Row.cfc?method=deleteRowRemote&table_id=#table_id#&row_id=#row_id#&tableTypeId=#tableTypeId##url_return_path#" onclick="return confirmDeleteRow();" title="Eliminar registro" class="btn btn-danger btn-sm"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>
		
	</cfif>

	<cfif app_version NEQ "mobile">
	<a href="#APPLICATION.htmlPath#/#tableTypeName#_row.cfm?#tableTypeName#=#table_id#&row=#row_id#" title="Abrir en nueva ventana" target="_blank" class="btn btn-default btn-sm" lang="es"><i class="icon-external-link"></i> <span lang="es">Ampliar</span></a>
	</cfif>

</div>


<div class="div_message_page_message">

	<!--- Fields --->
	<!--- <cfinclude template="#APPLICATION.htmlPath#/includes/table_row_content_fields.cfm"> --->

	<!---outputRowContent--->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="outputRowContent">
		<cfinvokeargument name="table_id" value="#table_id#">
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="row" value="#row#">
	</cfinvoke>

	<div style="height:10px;clear:both"></div>

	<!---tableRowUrl--->
	<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getTableRowUrl" returnvariable="tableRowUrl">
		<cfinvokeargument name="table_id" value="#table_id#">
		<cfinvokeargument name="tableTypeName" value="#tableTypeName#">
		<cfinvokeargument name="row_id" value="#row_id#">
		<cfinvokeargument name="area_id" value="#area_id#">

		<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
	</cfinvoke>

	<div class="div_message_page_label"><span lang="es">URL en #APPLICATION.title#:</span></div>
	<input type="text" value="#tableRowUrl#" onClick="this.select();" class="form-control" readonly="readonly" style="cursor:text"/>


</div>

<div style="height:10px;clear:both"></div>

</cfoutput>


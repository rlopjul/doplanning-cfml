<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfif isDefined("URL.row") AND isNumeric(URL.row) AND isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
	<cfset row_id = URL.row>
	<cfset table_id = URL[tableTypeName]>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>

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


<div class="div_elements_menu"><!---div_elements_menu--->
	
	<cfif is_user_area_responsible OR table_edit_permission IS true>
		<a href="#tableTypeName#_row_modify.cfm?#tableTypeName#=#table_id#&row=#row_id#" class="btn btn-small btn-info"><i class="icon-edit icon-white"></i> <span lang="es">Modificar</span></a>
		
		<a href="#APPLICATION.htmlComponentsPath#/Row.cfc?method=deleteRowRemote&table_id=#table_id#&row_id=#row_id#&tableTypeId=#tableTypeId##url_return_path#" onclick="return confirmDeleteRow();" title="Eliminar registro" class="btn btn-danger btn-small"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>
	</cfif>

	<a href="#APPLICATION.htmlPath#/#tableTypeName#_row.cfm?#tableTypeName#=#table_id#&row=#row_id#" title="Abrir en nueva ventana" target="_blank" class="btn btn-small" lang="es"><i class="icon-external-link"></i> <span lang="es">Ampliar</span></a>

</div>


<div class="div_message_page_message">

	<div class="div_message_page_label">Creado por: 
	
		<a href="area_user.cfm?area=#area_id#&user=#row.insert_user_id#"><cfif len(row.insert_user_image_type) GT 0>
			<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#row.insert_user_id#&type=#row.insert_user_image_type#&small=" alt="#row.insert_user_full_name#" class="item_img" style="margin-right:2px;"/>									
		<cfelse>							
			<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#row.insert_user_full_name#" class="item_img_default" style="margin-right:2px;"/>
		</cfif></a>
		
		<a href="area_user.cfm?area=#area_id#&user=#row.insert_user_id#">#row.insert_user_full_name#</a>
	</div>
	<div class="div_message_page_label"><span lang="es">Fecha de creación:</span> <span class="text_message_page">#DateFormat(row.creation_date, APPLICATION.dateFormat)# #TimeFormat(row.creation_date, "HH:mm")#</span></div>

	<cfif isNumeric(row.last_update_user_id)>
		<div class="div_message_page_label">Última modificación por: 
		
			<a href="area_user.cfm?area=#area_id#&user=#row.last_update_user_id#"><cfif len(row.update_user_image_type) GT 0>
				<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#row.last_update_user_id#&type=#row.update_user_image_type#&small=" alt="#row.update_user_full_name#" class="item_img" style="margin-right:2px;"/>									
			<cfelse>							
				<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#row.update_user_full_name#" class="item_img_default" style="margin-right:2px;"/>
			</cfif></a>
			
			<a href="area_user.cfm?area=#area_id#&user=#row.last_update_user_id#">#row.update_user_full_name#</a>
		</div>
		<div class="div_message_page_label"><span lang="es">Fecha de última modificación:</span> <span class="text_message_page">#DateFormat(row.last_update_date, APPLICATION.dateFormat)# #TimeFormat(row.last_update_date, "HH:mm")#</span></div>
	</cfif>

	<div style="height:10px;clear:both"></div>

	<!--- Fields --->
	<cfinclude template="#APPLICATION.htmlPath#/includes/table_row_content_fields.cfm">

</div>

<div style="height:10px;clear:both"></div>

</cfoutput>


<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_content_en.js" charset="utf-8"></script>
</cfoutput>

<!--- <cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm"> --->
<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm"> 

<cfif isDefined("URL.row") AND isNumeric(URL.row) AND isDefined("URL.#itemTypeName#") AND isNumeric(URL[itemTypeName])>
	<cfset row_id = URL.row>
	<cfset view_id = URL[itemTypeName]>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>

<!--- View --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/View" method="getView" returnvariable="view">
	<cfinvokeargument name="view_id" value="#view_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<cfset area_id = view.area_id>
<cfset table_id = view.table_id>

<!--- getViewRow --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getViewRow" returnvariable="getRowResponse">
	<cfinvokeargument name="view_id" value="#view_id#"/>
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#"/>
	<cfinvokeargument name="row_id" value="#row_id#"/>
</cfinvoke>

<cfset row = getRowResponse.row>

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
	<cfset url_return_path = "&return_path="&URLEncodedFormat("#return_path##itemTypeNameP#.cfm?area=#area_id#")>
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


<div class="div_elements_menu"><!---div_elements_menu--->

	<cfif app_version NEQ "mobile">
	<a href="#APPLICATION.htmlPath#/#itemTypeName#_row.cfm?#itemTypeName#=#table_id#&row=#row_id#" title="Abrir en nueva ventana" target="_blank" class="btn btn-default btn-sm" lang="es"><i class="icon-external-link"></i> <span lang="es">Ampliar</span></a>
	</cfif>

</div>


<div class="div_message_page_message">

	<!--- 
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
		</cfif> --->
	

	<!--- Fields --->
	<!--- <cfinclude template="#APPLICATION.htmlPath#/includes/table_row_content_fields.cfm"> --->

	<!---outputRowContent--->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="outputRowContent">
		<cfinvokeargument name="table_id" value="#table_id#">
		<cfinvokeargument name="view_id" value="#view_id#">
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="row" value="#row#">
	</cfinvoke>

	<div style="height:10px;clear:both"></div>

	<!---viewRowUrl--->
	<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getViewRowUrl" returnvariable="viewRowUrl">
		<cfinvokeargument name="view_id" value="#view_id#">
		<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
		<cfinvokeargument name="row_id" value="#row_id#">
		<cfinvokeargument name="area_id" value="#area_id#">

		<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
	</cfinvoke>

	<div class="div_message_page_label"><span lang="es">URL en #APPLICATION.title#:</span></div>
	<input type="text" value="#viewRowUrl#" onClick="this.select();" class="form-control" readonly="readonly" style="cursor:text"/>

</div>

<div style="height:10px;clear:both"></div>

</cfoutput>


<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
	<cfset table_id = URL[#tableTypeName#]>
<cfelse>
	<cflocation url="empty.cfm" addtoken="false">
</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="objectItem">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<cfif tableTypeId IS 3><!--- Typology --->

	<cfif isDefined("URL.area") AND isNumeric(URL.area)>
		<cfset area_id = URL.area>
	<cfelse>
		<cflocation url="empty.cfm" addtoken="false">
	</cfif>

<cfelse>

	<cfset area_id = objectItem.area_id>

</cfif>


<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<script type="text/javascript">
	<!---Esto es para evitar que se abran enlaces en el iframe--->
	$(document).ready( function(){
		$('.dropdown-toggle').dropdown();
		$(".div_message_page_description a").attr('target','_blank');
	}); 
	
	<cfif tableTypeId IS 3><!--- Typology --->
	<cfoutput>
	function confirmSetDefaultTable() {
	
		var message_confirm = "¿Seguro que desea establecer esta #tableTypeNameEs# como #tableTypeNameEs# por defecto del área?";
		return confirm(message_confirm);
	}

	function confirmRemoveDefaultTable() {
	
		var message_confirm = "¿Seguro que desea quitar esta #tableTypeNameEs# como #tableTypeNameEs# por defecto del área?";
		return confirm(message_confirm);
	}
	</cfoutput>
	</cfif>

</script>

<cfif app_version NEQ "html2">
	<div class="div_head_subtitle">
	<cfoutput>
	<span lang="es">#tableTypeNameEs#</span>
	</cfoutput>
	</div>
</cfif>

<cfoutput>

<div class="div_message_page_title">#objectItem.title#</div>
<div class="div_separator"><!-- --></div>

<div class="div_elements_menu"><!---div_elements_menu--->
	
	<cfif isDefined("URL.return_page") AND len(URL.return_page) GT 0>
		<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path##URL.return_page#")>
	<cfelse>
		<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path##tableTypeNameP#.cfm?area=#area_id#")>
	</cfif>
	
	<!---is_user_table_area_responsible--->
	<cfif area_id IS objectItem.area_id>
		
		<cfset is_user_table_area_responsible = is_user_area_responsible>

	<cfelse>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="isUserAreaResponsible" returnvariable="is_user_table_area_responsible">				
			<cfinvokeargument name="area_id" value="#objectItem.area_id#">
		</cfinvoke>

	</cfif>

	<cfif is_user_table_area_responsible><!--- Table Area Responsible --->

		<a href="#tableTypeName#_modify.cfm?#tableTypeName#=#table_id#" class="btn btn-small btn-info"><i class="icon-edit icon-white"></i> <span lang="es">Modificar</span></a>
	
		<a href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteItem&item_id=#table_id#&area_id=#area_id#&itemTypeId=#itemTypeId##url_return_page#" onclick="return confirmAction('eliminar');" title="Eliminar #tableTypeNameEs#" class="btn btn-danger btn-small"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>
		
	</cfif>

	<cfif is_user_table_area_responsible OR objectItem.user_in_charge EQ SESSION.user_id>
		
		<a href="item_change_user.cfm?item=#table_id#&itemTypeId=#itemTypeId#&area=#area_id#" class="btn btn-warning btn-small"><i class="icon-user"></i> <span lang="es">Cambiar propietario</span></a>	

	</cfif>


	<cfif is_user_area_responsible><!--- Area Responsible --->
		
		<cfif tableTypeId IS 3><!--- Typology --->

			<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAreaDefaultTable" returnvariable="getDefaultTableResponse">
				<cfinvokeargument name="area_id" value="#area_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			</cfinvoke>--->
			<cfset default_table_id = objectArea.default_typology_id> 
			<cfif default_table_id IS table_id>

				<a href="#APPLICATION.htmlComponentsPath#/Table.cfc?method=removeAreaDefaultTable&table_id=#table_id#&area_id=#area_id#&tableTypeId=#tableTypeId##url_return_page#" onclick="return confirmRemoveDefaultTable();" title="Definir #tableTypeNameEs# por defecto para este área" class="btn btn-small btn-warning"><i class="icon-pushpin icon-rotate-270"></i> <span lang="es">Quitar #tableTypeNameEs# por defecto</span></a>

			<cfelse>

				<a href="#APPLICATION.htmlComponentsPath#/Table.cfc?method=setAreaDefaultTableRemote&table_id=#table_id#&area_id=#area_id#&tableTypeId=#tableTypeId##url_return_page#" onclick="return confirmSetDefaultTable();" title="Definir #tableTypeNameEs# por defecto para este área" class="btn btn-small btn-info"><i class="icon-pushpin"></i> <span lang="es">Definir #tableTypeNameEs# por defecto</span></a>

			</cfif>

		</cfif>

	</cfif>
		
	<cfif app_version NEQ "mobile">
	<a href="#APPLICATION.htmlPath#/#tableTypeName#.cfm?#tableTypeName#=#table_id#" title="Abrir en nueva ventana" target="_blank" class="btn btn-small" lang="es"><i class="icon-external-link"></i> <span lang="es">Ampliar</span></a>
	</cfif>

	<cfif isNumeric(objectItem.attached_file_id) AND objectItem.attached_file_id GT 0>
		<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#objectItem.attached_file_id#&#tableTypeName#=#objectItem.table_id#" onclick="return downloadFileLinked(this,event)" class="btn btn-small"><i class="icon-download-alt"></i> <span lang="es">Adjunto</span></a>
		<cfif APPLICATION.moduleConvertFiles EQ true>
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
				<cfinvokeargument name="file_id" value="#objectItem.attached_file_id#">
				<cfinvokeargument name="item_id" value="#table_id#">
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
			</cfinvoke>
			<cfif objectFile.file_types_conversion.recordCount GT 0>
				<div class="div_element_menu" style="width:130px;">
	
					<cfset form_action = "#tableTypeName#_file_convert.cfm">
				
					<form name="convert_file" id="convert_file" method="get" action="#form_action#" onsubmit="showHideDiv('convert_file_loading');">
						<input type="hidden" name="file" value="#objectFile.id#" />
						
						<input type="hidden" name="#tableTypeName#" value="#objectItem.id#" />
						
						<div class="div_icon_menus"><input type="image" src="#APPLICATION.htmlPath#/assets/icons/view_file.gif" title="Visualizar el archivo"/></div>
						<!---<div class="div_text_menus"><a href="##" onclick="showHideDiv('convert_file_loading');submitForm('convert_file');" class="text_menus" lang="es">Ver adjunto en </a>
						<select name="file_type" style="width:90px;" onchange="showHideDiv('convert_file_loading');submitForm('convert_file');">
							<cfloop query="objectFile.file_types_conversion">
								<option value="#objectFile.file_types_conversion.file_type#">#objectFile.file_types_conversion.name_es#</option>
							</cfloop>
						</select>
						</div>--->
					</form>
				</div>
			</cfif> 
		</cfif>
	</cfif>


	<cfif itemTypeId IS 11 OR itemTypeId IS 12>
		<a href="#itemTypeName#_rows.cfm?#itemTypeName#=#table_id#" class="btn btn-small" title="Registros" lang="es"><i class="icon-list"></i> <span lang="es">Registros<span></a>
	</cfif>
	<cfif is_user_table_area_responsible IS true>
		<a href="#itemTypeName#_fields.cfm?#itemTypeName#=#table_id#" class="btn btn-small" title="Campos" lang="es"><i class="icon-wrench"></i> <span lang="es">Campos<span></a>

		<cfif APPLICATION.moduleListsWithPermissions IS true AND itemTypeId IS 11><!---List with permissions--->
			<a href="#itemTypeName#_users.cfm?#itemTypeName#=#table_id#" class="btn btn-small" title="Editores" lang="es"><i class="icon-group"></i> <span lang="es">Editores<span></a>
		</cfif>

	</cfif>
	
</div><!---END div_elements_menu--->
</cfoutput>
<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItem">
	<cfinvokeargument name="objectItem" value="#objectItem#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
	<cfinvokeargument name="area_type" value="#area_type#">
</cfinvoke>
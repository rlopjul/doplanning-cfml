<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
	<cfset table_id = URL[#tableTypeName#]>
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>

<!---Table--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<!---Table fields--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	<cfinvokeargument name="with_types" value="true">
</cfinvoke>
<cfset fields = fieldsResult.tableFields>

<cfset area_id = table.area_id>

<cfif tableTypeId IS 4><!--- Users typologies --->

	<cfinclude template="area_id.cfm">

	<cfinclude template="area_checks.cfm">
	
<cfelse>

	<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">
	
</cfif>


<cfoutput>


<cfif app_version NEQ "mobile">
	<div class="div_message_page_title">#table.title#</div>
	<div class="div_separator"><!-- --></div>
</cfif>

<div class="div_head_subtitle_area">

	<div class="btn-toolbar" style="padding-right:5px;">

		<cfif tableTypeId IS 1 OR tableTypeId IS 2>
			<div class="btn-group">
				<a href="#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="#tableTypeNameEs#" lang="es"> <img style="height:17px;" src="/html/assets/v3/icons/#tableTypeName#.png" alt="#tableTypeNameEs#">&nbsp;&nbsp;<span lang="es">#tableTypeNameEs#</span></a>
			</div>
		<cfelse>

			<cfif tableTypeId IS 4><!--- Users typologies --->
				
				<div class="btn-group">
					<a href="#tableTypeName#_modify.cfm?area=#area_id#&#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="#tableTypeNameEs#" lang="es"> <i class="icon-edit icon-white"></i> <span lang="es">Modificar</span></a>
				</div>

			<cfelse>

				<div class="btn-group">
					<a href="typology.cfm?area=#area_id#&#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="#tableTypeNameEs#" lang="es"> <img style="height:17px;" src="/html/assets/v3/icons/#tableTypeName#.png" alt="#tableTypeNameEs#">&nbsp;&nbsp;<span lang="es">#tableTypeNameEs#</span></a>
				</div>

			</cfif>
			
		</cfif>

		<div class="btn-group">
			<a href="#tableTypeName#_field_new.cfm?#tableTypeName#=#table_id#" class="btn btn-primary btn-sm"><i class="icon-plus icon-white" style="font-size:14px;"></i> <span lang="es">Añadir campo</span></a><!---onclick="openUrl('#tableTypeName#_field_new.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)"--->
		</div>

		<div class="btn-group">
			<a href="#tableTypeName#_fields_copy.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Copiar de plantilla" lang="es"><i class="icon-copy "></i> <span lang="es">Copiar de plantilla</span></a>
		</div>

		<cfif tableTypeId IS 4>
				
			<span class="divider">&nbsp;</span>

			<cfset url_return_path_delete = "&return_page="&URLEncodedFormat("#APPLICATION.htmlPath#/admin/iframes/users_typologies.cfm?area=#area_id#")>

			<!--- getClient --->
			<cfinvoke component="#APPLICATION.htmlPath#/components/Client" method="getClient" returnvariable="clientQuery">
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			</cfinvoke>

			<cfif clientQuery.bin_enabled IS true><!--- BIN Enabled --->

				<a class="btn btn-default btn-sm" href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteItem&item_id=#table_id#&area_id=#area_id#&itemTypeId=#itemTypeId##url_return_path_delete#" onclick="return confirmReversibleAction('eliminar');" title="Eliminar"><i class="icon-trash"></i> <span lang="es">Eliminar Tipología</span></a>

			<cfelse>

				<a class="btn btn-default btn-sm" href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteItem&item_id=#table_id#&area_id=#area_id#&itemTypeId=#itemTypeId##url_return_path_delete#" onclick="return confirmAction('eliminar');" title="Eliminar"><i class="icon-remove"></i> <span lang="es">Eliminar Tipología</span></a>

			</cfif>

			<span class="divider">&nbsp;</span>

			<a href="#tableTypeNameP#.cfm" class="btn btn-default btn-sm" title="Tipologías" lang="es"><img style="height:17px;" src="/html/assets/v3/icons/#tableTypeName#.png" alt="#tableTypeNameEs#"> <span lang="es">Tipologías de usuarios</span></a>

		</cfif>

		<!---<cfif tableTypeId IS NOT 3>
			<span class="divider">&nbsp;</span>

			<a href="#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Registros" lang="es"><i class="icon-list"></i> <span lang="es">Registros</span></a>
		</cfif>--->
		
		<!---<a href="#tableTypeNameP#.cfm?area=#area_id#" class="btn btn-default btn-sm" title="#itemTypeNameEsP# del área" lang="es"> <span lang="es">#itemTypeNameEsP# del área</span></a>--->

		<!---<span class="divider">&nbsp;</span>--->

		<cfif app_version NEQ "mobile" AND tableTypeId NEQ 4>
			<div class="btn-group pull-right">
				<a href="#APPLICATION.htmlPath#/#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px;"></i></a>
			</div>
		</cfif>


		<!---<a href="#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>--->

	</div>

</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_items">

	<cfif fields.recordCount GT 0>

		<cfinclude template="#APPLICATION.htmlPath#/includes/table_fields_list.cfm">

	<cfelse>
	
		<script type="text/javascript">
			openUrlHtml2('empty.cfm','itemIframe');
		</script>				

		<div class="div_text_result"><span lang="es">Haga clic en Añadir campo para crear un nuevo campo.</span></div>

	</cfif>

</div>

</cfoutput>

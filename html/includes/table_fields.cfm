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

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>
<div class="div_message_page_title">#table.title#</div>
<div class="div_separator"><!-- --></div>

<div class="div_head_subtitle_area">

	<a href="area_items.cfm?area=#area_id#&#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="#tableTypeNameEs#" lang="es"> <img style="height:20px;" src="/html/assets/icons/#itemTypeName#.png" alt="#tableTypeNameEs#">&nbsp;&nbsp;<span lang="es">#tableTypeNameEs#</span></a>

	<a href="#tableTypeName#_field_new.cfm?#tableTypeName#=#table_id#" onclick="openUrl('#tableTypeName#_field_new.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-default btn-sm"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <span>Añadir campo</span></a>

	<a href="#tableTypeName#_fields_copy.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Copiar de plantilla" lang="es"><i class="icon-copy "></i> <span lang="es">Copiar de plantilla</span></a>

	<cfif tableTypeId IS NOT 3>
		<span class="divider">&nbsp;</span>

		<a href="#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Registros" lang="es"><i class="icon-list"></i> <span lang="es">Registros</span></a>
	</cfif>
	
	<!---<a href="#tableTypeNameP#.cfm?area=#area_id#" class="btn btn-default btn-sm" title="#itemTypeNameEsP# del área" lang="es"> <span lang="es">#itemTypeNameEsP# del área</span></a>--->

	<span class="divider">&nbsp;</span>

	<cfif app_version NEQ "mobile">
		<a href="#APPLICATION.htmlPath#/#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
	</cfif>

	<!---<a href="#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>--->

</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_items">

	<cfif fields.recordCount GT 0>

		<cfinclude template="#APPLICATION.htmlPath#/includes/table_fields_list.cfm">

	<cfelse>
	
		<script type="text/javascript">
			openUrlHtml2('empty.cfm','itemIframe');
		</script>				

		<div class="div_text_result"><span lang="es">Haga clic en Añadir campo parar crear un nuevo campo.</span></div>

	</cfif>

</div>

</cfoutput>

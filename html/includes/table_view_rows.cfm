<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

<cfif isDefined("URL.#itemTypeName#")>
	<cfset view_id = URL[#itemTypeName#]>
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>

<!--- View --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/View" method="getView" returnvariable="view">
	<cfinvokeargument name="view_id" value="#view_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<cfset table_id = view.table_id>

<!---View rows--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/View" method="getViewRows" returnvariable="tableRowsResult">
	<cfinvokeargument name="view_id" value="#view_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset tableRows = tableRowsResult.rows>

<!---View fields--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/View" method="getViewFields" returnvariable="fieldsResult">
	<cfinvokeargument name="view_id" value="#view_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	<cfinvokeargument name="with_view_extra_fields" value="true">
</cfinvoke>
<cfset fields = fieldsResult.tableFields>

<cfset area_id = view.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>

<div class="div_message_page_title">#view.title#</div>
<div class="div_separator"><!-- --></div>

<div class="div_head_subtitle_area">

	<a href="area_items.cfm?area=#area_id#&#itemTypeName#=#view_id#" class="btn btn-default btn-sm" title="#itemTypeNameEs#" lang="es"> <img style="height:20px;" src="/html/assets/icons/#itemTypeName#.png" alt="#itemTypeNameEs#">&nbsp;&nbsp;<span lang="es">#itemTypeNameEs#</span></a>
	
	<!---<a href="#itemTypeName#_row_export.cfm?#itemTypeName#=#table_id#" onclick="openUrl('#itemTypeName#_row_export.cfm?#itemTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-default btn-sm" title="Exportar registros" lang="es"><i class="icon-arrow-down" style="font-size:15px;line-height:20px;"></i> <span>Exportar</span></a>

	<span class="divider">&nbsp;</span>--->
	
	<!---<a href="#itemTypeNameP#.cfm?area=#area_id#" class="btn btn-default btn-sm" title="#itemTypeNameEsP# del área" lang="es"> <span lang="es">#itemTypeNameEsP# del área</span></a>

	<span class="divider">&nbsp;</span>--->

	<cfif app_version NEQ "mobile">
		<a href="#APPLICATION.htmlPath#/#itemTypeName#_rows.cfm?#itemTypeName#=#table_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
	</cfif>

	<a href="#itemTypeName#_rows.cfm?#itemTypeName#=#view_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>

</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_items">

	<cfif tableRows.recordCount GT 0>

		<cfinclude template="#APPLICATION.htmlPath#/includes/table_rows_list.cfm">

	<cfelse>
	
		<script type="text/javascript">
			openUrlHtml2('empty.cfm','itemIframe');
		</script>				

		<div class="div_text_result"><span lang="es">No hay datos introducidos.</span></div>

	</cfif>

</div>

</cfoutput>
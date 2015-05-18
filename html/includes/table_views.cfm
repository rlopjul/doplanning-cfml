<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

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

<!---Table views--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableViews" returnvariable="viewsResult">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset views = viewsResult.tableFields>

<cfset area_id = table.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>
<cfif app_version NEQ "mobile">
	<div class="div_message_page_title">#table.title#</div>
	<div class="div_separator"><!-- --></div>
</cfif>

<div class="div_head_subtitle_area">

	<div class="btn-toolbar" style="padding-right:5px;">

		<cfif tableTypeId NEQ 3>
			<div class="btn-group">
				<a href="#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="#tableTypeNameEs#" lang="es"> <img style="height:17px;" src="/html/assets/icons/#tableTypeName#.png" alt="#tableTypeNameEs#">&nbsp;&nbsp;<span lang="es">#tableTypeNameEs#</span></a><!---area_items.cfm?area=#area_id#&#tableTypeName#=#table_id#--->
			</div>
		</cfif>

		<!---<cfif objectArea.read_only IS false>--->
			<div class="btn-group">
				<a href="#tableTypeName#_view_new.cfm?#tableTypeName#=#table_id#" onclick="openUrl('#tableTypeName#_view_new.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-primary btn-sm"><i class="icon-plus icon-white" style="font-size:14px;"></i> <span>Nueva vista</span></a><!---color:##5BB75B;--->
			</div>
		<!---</cfif>--->
		<!---<a href="#tableTypeName#_views_copy.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Copiar de plantilla" lang="es"><i class="icon-copy "></i> <span lang="es">Copiar de plantilla</span></a>

		<cfif tableTypeId IS NOT 3>
			<span class="divider">&nbsp;</span>

			<a href="#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Registros" lang="es"><i class="icon-list"></i> <span lang="es">Registros</span></a>
		</cfif>--->

		<!---<span class="divider">&nbsp;</span>--->

		<cfif app_version NEQ "mobile">
			<div class="btn-group pull-right">
				<a href="#APPLICATION.htmlPath#/#tableTypeName#_views.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px;"></i></a>
			</div>
		</cfif>

		<!---<a href="#tableTypeName#_views.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>--->


	</div>

</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_items">

	<cfif views.recordCount GT 0>

		<cfinclude template="#APPLICATION.htmlPath#/includes/table_views_list.cfm">

	<cfelse>
	
		<script type="text/javascript">
			openUrlHtml2('empty.cfm','itemIframe');
		</script>				

		<cfoutput>
		<div class="div_text_result"><span lang="es">Haga clic en Nueva vista para crear una nueva vista.</span></div>
		</cfoutput>

	</cfif>

</div>

</cfoutput>

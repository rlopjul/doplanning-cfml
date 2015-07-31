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

<!---Table actions--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableActions" returnvariable="actionsResult">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset actions = actionsResult.tableActions>

<cfset area_id = table.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>


<cfif app_version NEQ "mobile">
	<div class="div_message_page_title">#table.title#</div>
	<div class="div_separator"><!-- --></div>
</cfif>

<div class="div_head_subtitle_area">

	<div class="btn-toolbar" style="padding-right:5px;">

		<cfif tableTypeId IS NOT 3>
			<div class="btn-group">
				<a href="#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="#tableTypeNameEs#" lang="es"> <img style="height:17px;" src="/html/assets/v3/icons/#tableTypeName#.png" alt="#tableTypeNameEs#">&nbsp;&nbsp;<span lang="es">#tableTypeNameEs#</span></a>
			</div>
		<cfelse>
			<div class="btn-group">
				<a href="typology.cfm?area=#area_id#&#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="#tableTypeNameEs#" lang="es"> <img style="height:17px;" src="/html/assets/v3/icons/#tableTypeName#.png" alt="#tableTypeNameEs#">&nbsp;&nbsp;<span lang="es">#tableTypeNameEs#</span></a>
			</div>
		</cfif>

		<div class="btn-group">
			<a href="#tableTypeName#_action_new.cfm?#tableTypeName#=#table_id#" onclick="openUrl('#tableTypeName#_action_new.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-primary btn-sm"><i class="icon-plus icon-white" style="font-size:14px;"></i> <span lang="es">Añadir acción</span></a>
		</div>

		<!---<div class="btn-group">
			<a href="#tableTypeName#_actions_copy.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Copiar de plantilla" lang="es"><i class="icon-copy "></i> <span lang="es">Copiar de plantilla</span></a>
		</div>--->

		<cfif app_version NEQ "mobile">
			<div class="btn-group pull-right">
				<a href="#APPLICATION.htmlPath#/#tableTypeName#_actions.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px;"></i></a>
			</div>
		</cfif>

	</div>

</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_items">

	<cfif actions.recordCount GT 0>

		<cfinclude template="#APPLICATION.htmlPath#/includes/table_actions_list.cfm">

	<cfelse>
	
		<script type="text/javascript">
			openUrlHtml2('empty.cfm','itemIframe');
		</script>				

		<div class="div_text_result"><span lang="es">Haga clic en Añadir acción para crear una nueva acción.</span></div>

	</cfif>

</div>

</cfoutput>

<cfoutput>
<!---
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8"></script>
 --->

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

</cfoutput>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllAreaItems" returnvariable="getAllAreaItemsResult">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="area_type" value="#area_type#">
	<!---<cfif isDefined("limit_to") AND isNumeric(limit_to)>
	<cfinvokeargument name="limit" value="#limit_to#">
	</cfif>--->
</cfinvoke>

<cfset areaItemsQuery = getAllAreaItemsResult.query>

<cfset numItems = areaItemsQuery.recordCount>

<div class="row">

	<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu.cfm">

</div>


<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">


<div class="row">
	<div class="col-sm-12">

<cfif numItems GT 0>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsList">
		<cfinvokeargument name="itemsQuery" value="#areaItemsQuery#">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="area_type" value="#area_type#">
		<cfinvokeargument name="return_page" value="area_items.cfm?area=#area_id#">
		<cfinvokeargument name="app_version" value="#app_version#">
	</cfinvoke>

<cfelseif objectArea.read_only IS false>

	<script type="text/javascript">
		openUrlHtml2('empty.cfm','itemIframe');
	</script>

	<cfoutput>
	<!---<div class="div_text_result"><span lang="es">No hay elementos en esta área.</span></div>--->
	<div class="alert alert-info" role="alert" style="margin:10px;"><i class="icon-info-sign"></i> <span lang="es">Aún nadie ha puesto información aquí, ¿por qué no ser el primero?</span></div>
	</cfoutput>

</cfif>

	</div>
</div>

<cfif isDefined("URL.file") AND isDefined("URL.download") AND URL.download IS true>
	<cfoutput>
	<iframe style="display:none" src="#APPLICATION.htmlPath#/file_download.cfm?id=#URL.file#"></iframe>
	</cfoutput>
</cfif>

<cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

</cfoutput>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllAreaItems" returnvariable="getAllAreaItemsResult">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="area_type" value="#area_type#">
	<cfinvokeargument name="full_content" value="true">
	<!---<cfif isDefined("limit_to") AND isNumeric(limit_to)>
	<cfinvokeargument name="limit" value="#limit_to#">
	</cfif>--->
</cfinvoke>

<cfset areaItemsQuery = getAllAreaItemsResult.query>
<cfset numItems = areaItemsQuery.recordCount>

<div class="row">
	<div><!---col-sm-12--->

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu.cfm">

	</div>
</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="row">
	<div class="col-sm-12">

	<cfif numItems GT 0>

		<cfinclude template="#APPLICATION.htmlPath#/includes/isotope_scripts.cfm">

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsFullList">
			<cfinvokeargument name="itemsQuery" value="#areaItemsQuery#">
			<cfinvokeargument name="return_path" value="#APPLICATION.htmlPath#/">
			<cfinvokeargument name="area_id" value="#area_id#"/>
			<cfinvokeargument name="area_read_only" value="#objectArea.read_only#">
			<cfinvokeargument name="area_type" value="#area_type#">
			<cfinvokeargument name="app_version" value="#app_version#">
		</cfinvoke>

	<cfelseif objectArea.read_only IS false>

		<cfoutput>
		<div class="alert alert-info" role="alert" style="margin:10px;"><i class="icon-info-sign"></i> <span lang="es">Aún nadie ha puesto información aquí, ¿por qué no ser el primero?</span><button type="button" class="close" data-dismiss="alert" aria-label="Cerrar alerta">
		  <span aria-hidden="true">&times;</span>
		</button>
		</div>
		</cfoutput>

	</cfif>

	</div>
</div>

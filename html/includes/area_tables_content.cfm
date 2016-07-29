<cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

</cfoutput>

<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">


<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAreaTables" returnvariable="getAreaTablesResponse">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="area_type" value="#area_type#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	<cfinvokeargument name="with_user" value="true">
</cfinvoke>

<cfset areaTables = getAreaTablesResponse.areaTables>

<cfset numItems = areaTables.recordCount>

<div class="row">
	<cfoutput>

	<!---<cfif APPLICATION.identifier NEQ "vpnet">---><!---DP--->

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu.cfm">

	<!---
	<cfelse><!---VPNET--->

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu_vpnet.cfm">

	</cfif>--->

	</cfoutput>
</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/item_multiple_menu.cfm">

<cfif tableTypeId IS 3><!--- Typologies --->

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAreaDefaultTable" returnvariable="getDefaultTableResponse">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	</cfinvoke>
	<cfset default_table_id = getDefaultTableResponse.table_id>

</cfif>

<div class="div_items">
<cfif numItems GT 0>

	<!---<cfif isDefined("URL.mode") AND URL.mode EQ "list">--->

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="outputTablesList">
			<cfinvokeargument name="itemsQuery" value="#areaTables#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			<cfinvokeargument name="return_page" value="#lCase(itemTypeNameP)#.cfm?area=#area_id#">
			<cfinvokeargument name="app_version" value="#app_version#">
			<cfif isDefined("default_table_id") AND isNumeric(default_table_id)>
				<cfinvokeargument name="default_table_id" value="#default_table_id#"/>
			</cfif>
			<cfinvokeargument name="area_id" value="#area_id#"/>
			<cfinvokeargument name="select_enabled" value="#select_enabled#">
		</cfinvoke>

	<!---<cfelse>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="outputTablesFullList">
			<cfinvokeargument name="itemsQuery" value="#areaTables#">
			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
			<cfinvokeargument name="return_path" value="#APPLICATION.htmlPath#/">
			<cfinvokeargument name="area_id" value="#area_id#"/>
			<cfinvokeargument name="isUserAreaResponsible" value="#is_user_area_responsible#">
			<cfinvokeargument name="app_version" value="#app_version#">
		</cfinvoke>

	</cfif>--->

<cfelse>

	<!---<script type="text/javascript">
		openUrlHtml2('empty.cfm','itemIframe');
	</script>--->

	<cfoutput>
		<div class="alert alert-info" role="alert" style="margin:10px;"><i class="icon-info-sign"></i> <span lang="es">No hay #lCase(itemTypeNameEsP)# en esta área.</span></div>
	</cfoutput>
</cfif>
</div>

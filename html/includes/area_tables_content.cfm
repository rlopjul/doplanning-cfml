<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8" type="text/javascript"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

</cfoutput>

<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">


<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<div class="div_head_subtitle_area">
	<cfoutput>

	<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->
	
		<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu.cfm">
		
	<cfelse><!---VPNET--->

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu_vpnet.cfm">
		
	</cfif>
	
	</cfoutput>
</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfif tableTypeId IS 3><!--- Typologies --->

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAreaDefaultTable" returnvariable="getDefaultTableResponse">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	</cfinvoke>
	<cfset default_table_id = getDefaultTableResponse.table_id> 

</cfif>


<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAreaTables" returnvariable="getAreaTablesResponse">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<cfset areaTables = getAreaTablesResponse.areaTables>

<cfset numItems = areaTables.recordCount>

<div class="div_items">
<cfif numItems GT 0>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="outputTablesList">
		<cfinvokeargument name="itemsQuery" value="#areaTables#">
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		<cfinvokeargument name="return_page" value="#lCase(itemTypeNameP)#.cfm?area=#area_id#">
		<cfinvokeargument name="app_version" value="#app_version#">
		<cfif isDefined("default_table_id") AND isNumeric(default_table_id)>
			<cfinvokeargument name="default_table_id" value="#default_table_id#"/>
		</cfif>
		<cfif tableTypeId IS 3><!--- Typology --->
			<cfinvokeargument name="area_id" value="#area_id#"/>
		</cfif>
	</cfinvoke>

<cfelse>
	
	<script type="text/javascript">
		openUrlHtml2('empty.cfm','itemIframe');
	</script>				

	<cfoutput>
		<!---<div class="div_text_result"><span lang="es">No hay #lCase(itemTypeNameEsP)# en esta área.</span></div>--->
		<div class="alert alert-info" role="alert" style="margin:10px;"><i class="icon-info-sign"></i> <span lang="es">No hay #lCase(itemTypeNameEsP)# en esta área.</span></div>
	</cfoutput>
</cfif>
</div>
<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_items_content_en.js" charset="utf-8" type="text/javascript"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

</cfoutput>

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

<div style="margin-left:2px; margin-right:2px;">
<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">
</div>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAreaItemsList" returnvariable="getAreaItemsListResponse">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>

<cfset areaItems = getAreaItemsListResponse.areaItems>

<cfset numItems = areaItems.recordCount>

<div class="div_items">
<cfif numItems GT 0>

	<cfif itemTypeId IS NOT 7>
	
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItemsList">
			<cfinvokeargument name="itemsQuery" value="#areaItems#">
			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
			<cfinvokeargument name="return_page" value="#lCase(itemTypeNameP)#.cfm?area=#area_id#">
			<cfinvokeargument name="app_version" value="#app_version#">
		</cfinvoke>
	
	<cfelse><!---Consultations--->
	
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputConsultationsList">
			<cfinvokeargument name="itemsQuery" value="#areaItems#">
			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
			<cfinvokeargument name="return_page" value="#lCase(itemTypeNameP)#.cfm?area=#area_id#">
			<cfinvokeargument name="app_version" value="#app_version#">
		</cfinvoke>
		
	</cfif>

<cfelse>
	
	<script type="text/javascript">
		openUrlHtml2('empty.cfm','itemIframe');
	</script>				

	<cfoutput>
	<div class="div_text_result"><span lang="es">No hay #lCase(itemTypeNameEsP)# en esta área.</span></div>
	</cfoutput>
</cfif>
</div>
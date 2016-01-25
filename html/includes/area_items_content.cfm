<cfoutput>
<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">


<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAreaItemsList" returnvariable="getAreaItemsListResponse">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="area_type" value="#area_type#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>

<cfset areaItems = getAreaItemsListResponse.areaItems>

<cfset numItems = areaItems.recordCount>

<div class="row">

	<!---<cfif APPLICATION.identifier NEQ "vpnet">---><!---DP--->

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu.cfm">

	<!---
	<cfelse><!---VPNET--->

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu_vpnet.cfm">

	</cfif>--->

</div>


<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">


<div class="row">
	<div class="col-sm-12">

	<cfif numItems GT 0>


		<!---
		<cfif isDefined("URL.mode") AND URL.mode EQ "list"><!--- TABLE LIST --->
		--->

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


		<!---
		<cfelse><!--- FULL CONTENT --->

			<cfquery dbtype="query" name="itemsQuery">
				SELECT *, #itemTypeId# AS itemTypeId
				FROM areaItems;
			</cfquery>

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsFullList">
				<cfinvokeargument name="itemsQuery" value="#itemsQuery#">
				<cfinvokeargument name="return_path" value="#APPLICATION.htmlPath#/">
				<cfinvokeargument name="area_id" value="#area_id#"/>
			</cfinvoke>

		</cfif>
		--->


	<cfelse>

		<script>
			openUrlHtml2('empty.cfm','itemIframe');
		</script>

		<cfoutput>
		<div class="alert alert-info" role="alert" style="margin:10px;"><i class="icon-info-sign"></i> <span lang="es">No hay #lCase(itemTypeNameEsP)# en esta área.</span></div>
		</cfoutput>

	</cfif>

	</div>
</div>

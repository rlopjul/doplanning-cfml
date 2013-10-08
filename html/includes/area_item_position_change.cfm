<!---required var: action--->
<cfif isDefined("URL.item") AND isNumeric(URL.item) AND isDefined("URL.type") AND isNumeric(URL.type) AND isDefined("URL.area") AND isNumeric(URL.area) AND isDefined("URL.oitem") AND isNumeric(URL.oitem) AND isDefined("URL.otype") AND isNumeric(URL.otype)>

	<cfset item_id = URL.item>
	<cfset itemTypeId = URL.type>
	<cfset area_id = URL.area>

	<cfset other_item_id = URL.oitem>
	<cfset other_itemTypeId = URL.otype>
	
	<!---<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="changeAreaItemPosition" returnvariable="changeAreaItemPositionResult">
		<cfinvokeargument name="item_id" value="#item_id#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		<cfinvokeargument name="action" value="#action#">
	</cfinvoke>--->	

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="changeAreaItemPosition" returnvariable="changeAreaItemPositionResult">
		<cfinvokeargument name="item_id" value="#item_id#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		<cfinvokeargument name="other_item_id" value="#other_item_id#">
		<cfinvokeargument name="other_itemTypeId" value="#other_itemTypeId#">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="action" value="#action#">
	</cfinvoke>
	
	<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
	
	<!---<cfif changeAreaItemPositionResult.result IS true>
		<cflocation url="#itemTypeNameP#.cfm?area=#changeAreaItemPositionResult.area_id#" addtoken="no">
	<cfelse>
		<cflocation url="#itemTypeNameP#.cfm?area=#area_id#&res=0&msg=#URLEncodedFormat('#changeAreaItemPositionResult.message#')#" addtoken="no">
	</cfif>--->

	<cfif changeAreaItemPositionResult.result IS true>
		<cflocation url="area_items.cfm?area=#area_id#&#itemTypeName#=#item_id#" addtoken="no">
	<cfelse>
		<cflocation url="area_items.cfm?area=#area_id#&res=0&msg=#URLEncodedFormat('#changeAreaItemPositionResult.message#')#" addtoken="no">
	</cfif>

</cfif>
<!---required var: new_state--->
<cfif isDefined("URL.item") AND isDefined("URL.type") AND isDefined("URL.area") AND isDefined("URL.return_page")>

	<cfset item_id = URL.item>
	<cfset itemTypeId = URL.type>
	<cfset area_id = URL.area>
	<cfset return_url = URLDecode(URL.return_page)>
	
	<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="changeAreaItemState" returnvariable="changeAreaItemStateResult">
		<cfinvokeargument name="item_id" value="#item_id#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		<cfinvokeargument name="state" value="#new_state#">
	</cfinvoke>	
	
	<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
	
	<cfif changeAreaItemStateResult.result IS true>
		<!---<cflocation url="#itemTypeNameP#.cfm?area=#changeAreaItemStateResult.area_id#&res=1&msg=#URLEncodedFormat('#changeAreaItemStateResult.message#')#" addtoken="no">--->
		<cflocation url="#return_url#&res=1&msg=#URLEncodedFormat('#changeAreaItemStateResult.message#')#" addtoken="no">
	<cfelse>
		<cflocation url="#return_url#&res=0&msg=#URLEncodedFormat('#changeAreaItemStateResult.message#')#" addtoken="no">
	</cfif>

</cfif>
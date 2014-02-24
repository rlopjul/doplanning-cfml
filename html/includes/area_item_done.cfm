<!--- 

ESTA PÁGINA YA NO SE USA (se ha sustituido por el método changeAreaItemDone de AreaItem.cfc)

<cfif isDefined("URL.item") AND isDefined("URL.type") AND isDefined("URL.area") AND isDefined("URL.done") AND isDefined("URL.return_page")>

	<cfset item_id = URL.item>
	<cfset itemTypeId = URL.type>
	<cfset area_id = URL.area>
	<cfset done = URL.done>
	<cfset return_url = URLDecode(URL.return_page)>
	
	<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="changeAreaItemDone" returnvariable="changeAreaItemDoneResult">
		<cfinvokeargument name="item_id" value="#item_id#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		<cfinvokeargument name="done" value="#done#">
	</cfinvoke>	
	
	<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
	
	<cfif changeAreaItemDoneResult.result IS true>
		<!---<cflocation url="#itemTypeNameP#.cfm?area=#changeAreaItemDoneResult.area_id#&res=1&msg=#URLEncodedFormat('#changeAreaItemDoneResult.message#')#" addtoken="no">--->
		<cflocation url="#return_url#&res=1&msg=#URLEncodedFormat('#changeAreaItemDoneResult.message#')#" addtoken="no">
	<cfelse>
		<cflocation url="#return_url#&res=0&msg=#URLEncodedFormat('#changeAreaItemDoneResult.message#')#" addtoken="no">
	</cfif>

</cfif> --->

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfif isDefined("URL.#itemTypeName#")>
	<cfset item_id = URL[itemTypeName]>
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="selectItem" returnvariable="xmlResponse">
	<cfinvokeargument name="item_id" value="#item_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>

<cfxml variable="xmlItem">
	<cfoutput>
	#xmlResponse.response.result[itemTypeName]#
	</cfoutput>
</cfxml>

<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="objectItem" returnvariable="objectItem">
	<cfinvokeargument name="xml" value="#xmlItem.message#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	<cfinvokeargument name="return_type" value="object">
</cfinvoke>

<cfset area_id = objectItem.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">
<cfoutput>
<div class="div_head_subtitle">
#itemTypeNameEs#
</div>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/file_convert.cfm">

<cfset return_page = "#itemTypeName#.cfm?#itemTypeName#=#item_id#">
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>
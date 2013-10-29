<cfif isDefined("URL.area") AND isNumeric(URL.area) AND isDefined("URL.itemTypeId") AND isNumeric(itemTypeId)>
	<cfset area_id = URL.area>
	<cfset itemTypeId = URL.itemTypeId>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>
	
<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfif isDefined("FORM.page")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="changeItemUser" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>	

	<cfif actionResponse.result IS true>

		<cfset item_id = actionResponse.item_id>
		
		<cfset msg = URLEncodedFormat(actionResponse.message)>
		
		<cflocation url="area_items.cfm?area=#area_id#&#itemTypeName#=#item_id#&res=1&msg=#msg#" addtoken="no">
			
	<cfelse>
		
		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset newUser = FORM>

	</cfif>

<cfelse>

	<cfif isDefined("URL.item") AND isNumeric(URL.item)>
		<cfset item_id = URL.item>
	<cfelse>
		<cflocation url="empty.cfm" addtoken="no">
	</cfif>

	<cfset newUser = structNew()>
	<cfset newUser.new_user_in_charge = "">
	<cfset newUser.new_user_full_name = "">

</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getItem" returnvariable="item">
	<cfinvokeargument name="item_id" value="#item_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>
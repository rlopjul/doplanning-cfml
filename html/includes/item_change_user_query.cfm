<cfif isDefined("URL.area") AND isNumeric(URL.area) AND isDefined("URL.itemTypeId") AND isNumeric(itemTypeId)>
	<cfset area_id = URL.area>
	<cfset itemTypeId = URL.itemTypeId>
<cfelse>
	<cflocation url="index.cfm" addtoken="no">
</cfif>

<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

<cfif isDefined("FORM.page")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="changeItemsUser" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>

	<cfif actionResponse.result IS true>

		<cfset msg = URLEncodedFormat(actionResponse.message)>

		<cfif listLen(FORM.items_ids) GT 1><!--- Show warning message: we don't know if all files result are success --->
			<cflocation url="area_items.cfm?area=#area_id#&res=-1&msg=#msg#" addtoken="no">
		<cfelse>
			<cfset item_id = actionResponse.item_id>
			<cflocation url="area_items.cfm?area=#area_id#&#itemTypeName#=#item_id#&res=1&msg=#msg#" addtoken="no">
		</cfif>

	<cfelse>

		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset newUser = FORM>

	</cfif>

<cfelse>

	<cfif isDefined("URL.items")>
		<cfset items_ids = URL.items>
	<cfelseif isDefined("URL.item")>
		<cfset items_ids = URL.item>
	<cfelse>
		<cflocation url="index.cfm" addtoken="no">
	</cfif>

	<cfset newUser = structNew()>
	<cfset newUser.new_user_in_charge = "">
	<cfset newUser.new_user_full_name = "">

</cfif>

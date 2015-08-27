<!---page_types
1 Create new item
2 Modify item
--->

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfif isDefined("FORM.itemTypeId")>
	
	<cfif page_type IS 1>
		<cfset methodAction = "createItem">
	<cfelse>
		<cfset methodAction = "updateItem">
	</cfif>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="#methodAction#" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>

	<cfif actionResponse.result IS true>
		
		<!---
		<cfif itemTypeId IS 11 OR itemTypeId IS 13><!---Lists, Forms, Typologies--->
			<cfset return_page = "#itemTypeName#_fields.cfm?#itemTypeName#=#actionResponse.item_id#">
		<cfelse>--->
			<cfset return_page = "area_items.cfm?area=#FORM.area_id#&#itemTypeName#=#actionResponse.item_id#">
		<!---</cfif>--->	

		<cfset msg = urlEncodedFormat(actionResponse.message)>

		<cflocation url="#return_page#&item=#actionResponse.item_id#&res=#actionResponse.result#&msg=#msg#" addtoken="no">

	<cfelse>
		
		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset objectItem = FORM>

		<cfif page_type IS 1>
			<cfset return_page = "area_items.cfm?area=#objectItem.area_id#">
		<cfelse>
			<cfset return_page = "#itemTypeName#.cfm?#itemTypeName#=#objectItem.item_id#">
		</cfif>

	</cfif> 

<cfelse>

	<cfif page_type IS 1><!--- NEW ITEM --->

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
			<cfinvokeargument name="user_id" value="#SESSION.user_id#">
			<cfinvokeargument name="format_content" value="all">
		</cfinvoke>

		<cfif isDefined("URL.area") AND isValid("integer",URL.area)>
			<cfset parent_id = URL.area>
			<cfset parent_kind = "area">
			
			<cfset area_id = parent_id>
			
			<cfset title_default = "">
			
			<!---<cfset return_page = "#itemTypeNameP#.cfm?area=#parent_id#">--->
			<cfset return_page = "area_items.cfm?area=#parent_id#">
			
		<cfelseif isDefined("URL.#itemTypeName#")>
			<cfset parent_id = URL[#itemTypeName#]>
			<cfset parent_kind = "#itemTypeName#">
			
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getItem" returnvariable="getItemResponse">
				<cfinvokeargument name="item_id" value="#parent_id#">
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
				<cfinvokeargument name="with_categories" value="true"/>
			</cfinvoke>
			
			<cfset getItemObject = getItemResponse.item>
			<cfset area_id = getItemObject.area_id>
			<cfset title_default = "Re: "&getItemObject.title>

			<cfset itemCategories = getItemResponse.categories>
			
			<cfset return_page = "#itemTypeName#.cfm?#itemTypeName#=#parent_id#">
			
		<cfelse>
			<cflocation url="area.cfm" addtoken="no">
		</cfif>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getEmptyItem" returnvariable="objectItem">
			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		</cfinvoke>
		
		<cfset objectItem.title = title_default>

			

	<cfelse><!--- MODIFY ITEM --->

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
			<cfinvokeargument name="user_id" value="#SESSION.user_id#">
			<cfinvokeargument name="format_content" value="all">
		</cfinvoke>
			
		<cfif isDefined("URL.#itemTypeName#")>
			<cfset item_id = URL[#itemTypeName#]>
			
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getItem" returnvariable="getItemResponse">
				<cfinvokeargument name="item_id" value="#item_id#">
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
				<cfinvokeargument name="with_categories" value="true"/>
			</cfinvoke>
			
			<cfset objectItem = getItemResponse.item>
			<cfset area_id = objectItem.area_id>

			<cfset itemCategories = getItemResponse.categories>
			
			<cfset return_page = "#itemTypeName#.cfm?#itemTypeName#=#item_id#">
			
		<cfelse>
			<cflocation url="area.cfm" addtoken="no">
		</cfif>

	</cfif>


</cfif>
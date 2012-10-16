<!---
Requered vars:
itemTypeId
Required URL variables:
link
--->
<cftry>
	
	<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
	
	<cfif isDefined("URL.#itemTypeName#") AND isValid("integer",URL[#itemTypeName#])>
		<cfset component = "goToItemLink">
		<cfset method = "goToItemLink">
				
		<cfset item_id = URL[#itemTypeName#]>
		
		<!---Al obtener el item se comprueba si tiene acceso--->
		<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="getItem" returnvariable="objectLink">
			<cfinvokeargument name="item_id" value="#item_id#">
			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
			<cfinvokeargument name="return_type" value="object">
		</cfinvoke>
		
		<cfif objectLink.link GT 0 AND isValid("url", objectLink.link)>
		
			<cflocation url="#objectLink.link#" addtoken="no">
		
		<cfelse>
		
		Enlace no válido.
		
		</cfif>
		
	</cfif>

	<cfcatch>
	
		<cfinclude template="includes/errorHandler.cfm">
		
	</cfcatch>
</cftry>

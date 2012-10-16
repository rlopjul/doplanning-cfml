<cfif isDefined("xmlRequest.request.parameters.search.xmlAttributes.page") 
AND isValid("integer",xmlRequest.request.parameters.search.xmlAttributes.page) 
AND xmlRequest.request.parameters.search.xmlAttributes.page GT 0>
	<cfset current_page = xmlRequest.request.parameters.search.xmlAttributes.page>
<cfelse>
	<cfset current_page = 1>
</cfif>

<cfif isDefined("xmlRequest.request.parameters.search.xmlAttributes.items_page")
AND isValid("integer",xmlRequest.request.parameters.search.xmlAttributes.items_page) 
AND xmlRequest.request.parameters.search.xmlAttributes.items_page GT 0>
	<cfset items_page = xmlRequest.request.parameters.search.xmlAttributes.items_page>
<cfelse>
	<cfset items_page = 10>
</cfif>

<cfset init_item = (current_page-1)*items_page>

<cfif method NEQ "searchAreas">

	<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="isRootUser" returnvariable="is_root_user">
		<cfinvokeargument name="get_user_id" value="#user_id#"> 
	</cfinvoke>
	
	<cfif is_root_user IS false>
		<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAllUserAreasList" returnvariable="allUserAreasList">
			<cfinvokeargument name="get_user_id" value="#user_id#">
		</cfinvoke>
	</cfif>

</cfif>
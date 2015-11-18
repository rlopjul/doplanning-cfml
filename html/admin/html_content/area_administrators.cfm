<!---checkAdminAccess--->
<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAdminAccess">
</cfinvoke>

<cfif isDefined("URL.area") AND isNumeric(URL.area)>

<cfset area_id = URL.area>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getAllAreaAdministrators" returnvariable="usersResponse">
	<cfinvokeargument name="area_id" value="#area_id#">
</cfinvoke>

<cfset users = usersResponse.users>
<cfset numUsers = ArrayLen(users)>

<div class="div_users">

	<cfif numUsers GT 0>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersList">
			<cfinvokeargument name="users" value="#users#">
			<cfinvokeargument name="area_id" value="#area_id#">
			<!---<cfinvokeargument name="user_in_charge" value="#objectArea.user_in_charge#">--->
			<cfinvokeargument name="show_area_members" value="true">
			<cfinvokeargument name="open_url_target" value="userAreaIframe">
			<cfinvokeargument name="filter_enabled" value="false">
			<cfinvokeargument name="adminUsers" value="true">
		</cfinvoke>

	<cfelse>
		<span lang="es">No hay usuarios.</span>
	</cfif>

</div>

</cfif>

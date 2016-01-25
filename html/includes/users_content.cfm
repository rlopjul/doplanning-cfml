<cfoutput>
<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfif objectArea.users_visible IS true>

	<!---<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->--->

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getAllAreaUsers" returnvariable="usersResponse">
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfinvoke>

	<!---<cfelse>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getAreaMembers" returnvariable="usersResponse">
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfinvoke>

	</cfif>--->

	<cfset users = usersResponse.users>
	<cfset numUsers = ArrayLen(users)>
	<cfset numItems = numUsers>

</cfif>

<div class="row">
	<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu.cfm">
</div>

<div>
	<cfif objectArea.users_visible IS true>

		<cfif numUsers GT 0>

			<cfif isDefined("URL.mode") AND URL.mode EQ "list">

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersList">
					<cfinvokeargument name="users" value="#users#">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="user_in_charge" value="#objectArea.user_in_charge#">
					<cfinvokeargument name="show_area_members" value="true">
					<!---
					<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->
						<cfinvokeargument name="show_area_members" value="true">
					</cfif>--->
				</cfinvoke>

			<cfelse>

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersFullList">
					<cfinvokeargument name="usersArray" value="#users#">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="user_in_charge" value="#objectArea.user_in_charge#">
				</cfinvoke>

			</cfif>



		<cfelse>

			<script>
				openUrlHtml2('empty.cfm','itemIframe');
			</script>

			<span lang="es">No hay usuarios.</span>
		</cfif>

	<cfelse>

		<script>
			openUrlHtml2('empty.cfm','itemIframe');
		</script>

		<div class="alert alert-info" style="margin:10px;"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Los usuarios de esta área no están visibles.</span></div>

	</cfif>
</div>

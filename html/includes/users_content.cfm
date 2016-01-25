<cfoutput>
<!---
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8"></script>
 --->

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
</cfoutput>

<!---<script type="text/javascript">
	function submitUsersForm(){
		var form=document.getElementById("user_form");
		form.submit();
	}
</script>--->

<!---
<cfoutput>
<div class="div_head_subtitle_area">

	<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->

		<div class="btn-toolbar" style="padding-right:5px;" role="toolbar">

			<cfif app_version NEQ "mobile">
				<div class="btn-group pull-right">
					<a href="#APPLICATION.htmlPath#/users.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
				</div>
			</cfif>

			<div class="btn-group pull-right">
				<a href="users.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>
			</div>

		</div>

	<cfelse><!---VPNET--->

		<div class="div_element_menu">
			<div class="div_icon_menus"><a href="users.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/v3/icons/refresh.png" alt="Actualizar" title="Actualizar"/></a></div>
			<div class="div_text_menus"><a href="users.cfm?area=#area_id#" lang="es">Actualizar</a></div>
		</div>

	</cfif>

	<!---
	<cfif APPLICATION.identifier NEQ "dp"><!---Deshabilitado para DoPlanning--->
			<cfif objectUser.sms_allowed IS true>
			<div class="div_element_menu">
				<div class="div_icon_menus"><input type="image" name="sms" src="#APPLICATION.htmlPath#/assets/v3/icons/sms.png" title="Enviar SMS a usuarios seleccionados" /></div>
				<div class="div_text_menus"><span class="span_text_menus">Enviar<br />SMS</span></div>
			</div>
			</cfif>
		</cfif> --->

</div>
</cfoutput>
--->


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

		<!---<div class="div_users">--->

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

		<!---</div>--->

	<cfelse>

		<script>
			openUrlHtml2('empty.cfm','itemIframe');
		</script>

		<div class="alert alert-info" style="margin:10px;"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Los usuarios de esta área no están visibles.</span></div>

	</cfif>
</div>

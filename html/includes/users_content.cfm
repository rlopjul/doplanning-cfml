<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8" type="text/javascript"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<!---<script type="text/javascript">
	function submitUsersForm(){
		var form=document.getElementById("user_form");
		form.submit();
	}
</script>--->

<cfoutput>
<div class="div_head_subtitle_area">
	
	<!---<div class="div_head_subtitle_area_text"><strong>USUARIOS</strong><br/> del área</div>--->
	
	<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->
	
		<!---<form action="#CGI.SCRIPT_NAME#" method="get" id="user_form" class="form-inline">
			<input type="hidden" name="area_id" value="#area_id#"/>
			<!---<label for="users_select">Mostrar</label>--->
			<select name="all" id="users_select" onchange="submitUsersForm()" style="width:250px;">
				<option value="0" <cfif all_users IS false>selected="selected"</cfif>>Usuarios de esta área</option>
				<option value="1" <cfif all_users IS true>selected="selected"</cfif>>Usuarios con acceso a esta área</option>
			</select>
			<button type="submit" class="btn btn-default btn-sm" title="Actualizar"><i class="icon-refresh"></i> Actualizar</button>
		</form>--->
		
		<cfif app_version NEQ "mobile">
		<a href="#APPLICATION.htmlPath#/users.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
		</cfif>

		<a href="users.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>
		
	<cfelse><!---VPNET--->
	
		<div class="div_element_menu">
			<div class="div_icon_menus"><a href="users.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/refresh.png" alt="Actualizar" title="Actualizar"/></a></div>
			<div class="div_text_menus"><a href="users.cfm?area=#area_id#" lang="es">Actualizar</a></div>
		</div>
		
	</cfif>
	
	
	
<!---Las funcionalidades que requerían el form ya no están disponibles en ninguna versión--->
<!---<form action="users.cfm?area=#area_id#" method="post" style="padding:0; margin:0; clear:none;">--->
	<!---<div class="div_element_menu">
		<div class="div_icon_menus"><input type="image" name="notification" src="#APPLICATION.htmlPath#/assets/icons/notifications.gif" title="Enviar email a usuarios seleccionados" /></div>
		<div class="div_text_menus"><span class="span_text_menus">Enviar <br /> email</span></div>	
	</div>--->
	<!--- 
	<cfif APPLICATION.identifier NEQ "dp"><!---Deshabilitado para DoPlanning--->
			<cfif objectUser.sms_allowed IS true>
			<div class="div_element_menu">
				<div class="div_icon_menus"><input type="image" name="sms" src="#APPLICATION.htmlPath#/assets/icons/sms.png" title="Enviar SMS a usuarios seleccionados" /></div>
				<div class="div_text_menus"><span class="span_text_menus">Enviar<br />SMS</span></div>
			</div>
			</cfif>
		</cfif> --->
	
</div>
</cfoutput>

<!---<cfset page_type = 1>
<cfinclude template="#APPLICATION.htmlPath#/includes/users_list.cfm">--->

<!---<cfif all_users IS true>--->
<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getAllAreaUsers" returnvariable="usersResponse">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

<cfelse>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getAreaMembers" returnvariable="usersResponse">	
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>
	
</cfif>

<cfset users = usersResponse.users>
<cfset numUsers = ArrayLen(users)>

<div class="div_users">
	
	<cfif numUsers GT 0>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersList">
			<cfinvokeargument name="users" value="#users#">
			<cfinvokeargument name="area_id" value="#area_id#">
			<cfinvokeargument name="user_in_charge" value="#objectArea.user_in_charge#">
			<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->
				<cfinvokeargument name="show_area_members" value="true">
			</cfif>
		</cfinvoke>	

	<cfelse>
		<span lang="es">No hay usuarios.</span>
	</cfif>
	
</div>

<!---</form>--->
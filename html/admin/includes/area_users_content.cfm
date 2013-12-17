<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_items_content_en.js" charset="utf-8" type="text/javascript"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
</cfoutput>

<!--- <cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm"> --->

<cfinclude template="#APPLICATION.htmlPath#/includes/area_id.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/area_checks.cfm">

<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaPath" returnvariable="area_path">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="separator" value=" / ">
</cfinvoke>
<cfif SESSION.client_id NEQ "hcs">
						
	<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="isInternalUser" returnvariable="internal_user">
		<cfinvokeargument name="get_user_id" value="#SESSION.user_id#">
	</cfinvoke>

</cfif>
<cfoutput>
<div class="div_head_menu">
	<div class="navbar navbar-default navbar-static-top">
		<div class="navbar-header">

			<i class="icon-info-sign more_info_img" id="openAreaImg" onclick="openAreaInfo()" title="Mostrar información del área"></i>
			<i class="icon-info-sign more_info_img" id="closeAreaImg" onclick="openAreaInfo()" title="Ocultar información del área" style="display:none;"></i>

			<p class="navbar_brand">#area_name#<br/>
			<cfif SESSION.client_id EQ "hcs" OR internal_user IS true>
				<span style="font-size:12px; color:##737373">Ruta: #area_path#</span></p>
			</cfif>
		</div>
	</div>
</div>

<div style="clear:both"><!-- --></div>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_menu_info.cfm">

<div>
	<img alt="Imagen del área" src="#APPLICATION.resourcesPath#/downloadAreaImage.cfm?id=#area_id#" style="max-height:50px;">
</div>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfoutput>
<div class="div_head_subtitle_area">
	
	<!---<div class="div_head_subtitle_area_text"><strong>USUARIOS</strong><br/> del área</div>--->

	<a class="btn btn-info btn-sm" onclick="parent.loadModal('html_content/area_modify.cfm?area=#area_id#');"><i class="icon-edit icon-white"></i> <span lang="es">Modificar área</span></a>
	
	<a class="btn btn-info btn-sm disabled"><i class="icon-picture icon-white"></i> <span lang="es">Cambiar imagen</span></a><!---ESTO ESTÁ EMPEZADO PERO NO TERMINADO (falta solucionar lo de la subida de archivos) onclick="parent.loadModal('html_content/area_image_modify.cfm?area=#area_id#');" --->

	<a href="area_users.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh"></i> <span lang="es">Actualizar</span></a>

</div>

</cfoutput>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getAllAreaUsers" returnvariable="usersResponse">
	<cfinvokeargument name="area_id" value="#area_id#">
</cfinvoke>

<!---<cfxml variable="xmlUsers">
	<cfoutput>
	#usersResponse.usersXml#
	</cfoutput>
</cfxml>
<cfset numUsers = ArrayLen(xmlUsers.users.XmlChildren)>--->

<cfset users = usersResponse.users>
<cfset numUsers = ArrayLen(users)>

<div class="div_users">
	
	<cfif numUsers GT 0>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersList">
			<cfinvokeargument name="users" value="#users#">
			<cfinvokeargument name="area_id" value="#area_id#">
			<cfinvokeargument name="user_in_charge" value="#objectArea.user_in_charge#">
			<cfinvokeargument name="show_area_members" value="true">
			<cfinvokeargument name="open_url_target" value="userAreaIframe">
			<cfinvokeargument name="filter_enabled" value="true">
		</cfinvoke>	

	<cfelse>
		<span lang="es">No hay usuarios.</span>
	</cfif>
	
</div>
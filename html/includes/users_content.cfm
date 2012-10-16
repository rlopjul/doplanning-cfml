<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	<cfinvokeargument name="format_content" value="all">
</cfinvoke>

<!---Send FORM to SMS or NOTIFICATION--->
<cfif isDefined("FORM")>
	<cfif isDefined("FORM.notification.x")>
		<cfset email_list = "">
		<cfinclude template="#APPLICATION.htmlPath#/includes/get_selected_emails.cfm">
		<cflocation url="notifications.cfm?sel=#URLEncodedFormat(email_list)#" addtoken="no">
	<cfelseif isDefined("FORM.sms.x")>
		<cfset phone_list = "">
		<cfinclude template="#APPLICATION.htmlPath#/includes/get_selected_phones.cfm">
		<cflocation url="sms.cfm?sel=#URLEncodedFormat(phone_list)#" addtoken="no">
	</cfif>
</cfif>


<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>
<div class="div_head_subtitle_area">
	
	<div class="div_head_subtitle_area_text"><strong>USUARIOS</strong><br/> del área</div>
	<div class="div_element_menu">
		<div class="div_icon_menus"><a href="users.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/refresh.png" alt="Actualizar" title="Actualizar"/></a></div>
			<div class="div_text_menus"><a href="users.cfm?area=#area_id#">Actualizar</a></div>
</div>
	</div>
	<form action="users.cfm?area=#area_id#" method="post" style="padding:0; margin:0; clear:none;">
	<!---<div class="div_element_menu">
		<div class="div_icon_menus"><input type="image" name="notification" src="#APPLICATION.htmlPath#/assets/icons/notifications.gif" title="Enviar email a usuarios seleccionados" /></div>
		<div class="div_text_menus"><span class="span_text_menus">Enviar <br /> email</span></div>	
	</div>--->
	<cfif APPLICATION.identifier NEQ "dp"><!---Deshabilitado para DoPlanning--->
		<cfif objectUser.sms_allowed IS true>
		<div class="div_element_menu">
			<div class="div_icon_menus"><input type="image" name="sms" src="#APPLICATION.htmlPath#/assets/icons/sms.png" title="Enviar SMS a usuarios seleccionados" /></div>
			<div class="div_text_menus"><span class="span_text_menus">Enviar<br />SMS</span></div>
		</div>
		</cfif>
	</cfif>
</div>
</cfoutput>

<cfset page_type = 1>
<cfinclude template="#APPLICATION.htmlPath#/includes/users_list.cfm">

</form>
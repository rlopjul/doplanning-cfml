<cfset current_page = "sms.cfm">
<cfinclude template="#APPLICATION.htmlPath#/includes/sms_head.cfm">
<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<!---Send FORM to select users or select contacts--->
<cfif isDefined("FORM")>
	<cfif isDefined("FORM.submit")>
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/SMS" method="sendSMS" argumentcollection="#FORM#">
		</cfinvoke>
	<cfelse>
		
		<cfif isDefined("FORM.select_users") OR isDefined("FORM.select_users.x")>
			<cfset selected_enc = URLEncodedFormat(FORM.recipients)>
			<cfset content_enc = URLEncodedFormat(FORM.content)>
			<cflocation url="select_users.cfm?page=#current_page#&sel=#selected_enc#&content=#content_enc#" addtoken="no">
		<cfelseif isDefined("FORM.select_contacts") OR isDefined("FORM.select_contacts.x")>
			<cfset selected_enc = URLEncodedFormat(FORM.recipients)>
			<cfset content_enc = URLEncodedFormat(FORM.content)>
			<cflocation url="select_contacts.cfm?page=#current_page#&sel=#selected_enc#&content=#content_enc#" addtoken="no">
		</cfif>
	</cfif>
</cfif>


<cfset phone_list = "">
<cfset content = "">

<cfif isDefined("URL.sel") AND len(URL.sel) GT 0>
	<cfset selected = URLDecode(URL.sel)>
	<cfset phone_list = selected>
</cfif>
<cfinclude template="#APPLICATION.htmlPath#/includes/get_selected_phones.cfm">
<cfif isDefined("URL.content")>
	<cfset content = URLDecode(URL.content)>
</cfif>

<cfset phone_list_enc = URLEncodedFormat(phone_list)>

<div class="contenedor_fondo_blanco">
<div class="div_send_message">
<cfoutput>
<form action="#current_page#" method="post">
	<div class="div_recipients_input">
	<span class="texto_normal">Número de móvil:</span>
	<input type="text" name="recipients" class="input_message_recipients" value="#phone_list#">
	
	<input type="image" name="select_users" src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/users.gif" alt="Agregar usuarios" value="select_users" title="Seleccionar usuarios" />&nbsp;
	<input type="image" name="select_contacts" src="#APPLICATION.htmlPath#/assets/icons/contacts.png" alt="Agregar contactos" value="select_contacts" title="Seleccionar contactos" />
	</div>
	
	    
    <!---cftextarea is not supported by Railo 3.0--->
    <div><textarea name="content" class="input-xxlarge">#content#</textarea></div>
    </cfoutput>
    <!---<div><cfinput type="file" name="Filedata"></div>--->
    
    <div><input type="submit" class="btn btn-primary" name="submit" value="Enviar"></div>
</form>
</div>

</div>

<cfif isDefined("URL.return_page") AND len(URL.return_page) GT 0>
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
		<cfinvokeargument name="return_page" value="#URL.return_page#">
	</cfinvoke>
</cfif>
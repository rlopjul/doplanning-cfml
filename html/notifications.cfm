<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/plantilla_app_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2012 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#</title>
<!-- InstanceEndEditable -->
</cfoutput>
<script type="text/javascript" src="../SpryAssets/includes/xpath.js"></script>
<script type="text/javascript" src="../SpryAssets/includes/SpryData.js"></script>
<script type="text/javascript" src="../SpryAssets/includes/SpryXML.js"></script>
<script type="text/javascript" src="../SpryAssets/includes/SpryDOMUtils.js"></script>
<cfif APPLICATION.moduleMessenger EQ "enabled">
<script type="text/javascript" src="../app/scripts/App.js"></script>
<script type="text/javascript" src="Scripts/MessengerControl.js"></script>
<cfif isDefined("SESSION.user_id")>
<script type="text/javascript">
window.onload = function ()
{
	Messenger.Private.initGetNewConversations();
}
</script>
</cfif>
</cfif>
<script type="text/javascript" src="Scripts/functions.js"></script>
<link href="styles.css" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "vpnet">
<link href="styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<!--using caps S (Screen), Pocket IE ignores it. Windows Mobile 6.1 ignores media="handled"-->  
<link href="styles_screen.css" rel="stylesheet" type="text/css" media="Screen" />
<link href="styles_mobiles.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 800px)" />
<!---<link href="../html/styles_mobiles.css" rel="stylesheet" type="text/css" media="handheld" />
<link href="../html/styles_iphone.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 480px)" />--->
<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
</head>

<body class="body_global">
<cfif APPLICATION.identifier NEQ "dp">
	<div class="div_header">
		<a href="../html/"><div class="div_header_content"><!-- --></div></a>
		<div class="div_separador_header"><!-- --></div>
	</div>
</cfif>

 
<cfoutput>
<cfif APPLICATION.identifier EQ "dp">
<div style="float:left; padding-top:2px;"><a href="index.cfm"><img src="assets/logo_app.gif" alt="Inicio" title="Inicio"/></a></div>
</cfif>
<div style="float:right">
	<div style="float:right; margin-right:5px; padding-top:2px;" class="div_text_user_logged">
		<a href="preferences.cfm" class="text_user_logged" title="Preferencias del usuario">#getAuthUser()#</a>&nbsp;&nbsp;&nbsp;<a href="logout.cfm" class="text_user_logged" title="Salir">Logout</a>
	</div> 
</div>
</cfoutput>

<div class="div_contenedor_contenido">
<!-- InstanceBeginEditable name="contenido" -->
<cfset current_page = "notifications.cfm">
<cfinclude template="includes/notifications_head.cfm">
<cfinclude template="includes/alert_message.cfm">

<!---Send FORM to select users or select contacts--->
<cfif isDefined("FORM")>
	<cfif isDefined("FORM.submit")>
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Email" method="sendNotification" argumentcollection="#FORM#">
		</cfinvoke>
	<cfelse>
		
		<cfif isDefined("FORM.select_users.x")>
			<cfset selected_enc = URLEncodedFormat(FORM.recipients)>
			<cfset content_enc = URLEncodedFormat(FORM.content)>
			<cfset subject_enc = URLEncodedFormat(FORM.subject)>
			<cflocation url="select_users.cfm?page=#current_page#&sel=#selected_enc#&content=#content_enc#&subject=#subject_enc#" addtoken="no">
		<cfelseif isDefined("FORM.select_contacts.x")>
			<cfset selected_enc = URLEncodedFormat(FORM.recipients)>
			<cfset content_enc = URLEncodedFormat(FORM.content)>
			<cfset subject_enc = URLEncodedFormat(FORM.subject)>
			<cflocation url="select_contacts.cfm?page=#current_page#&sel=#selected_enc#&content=#content_enc#&subject=#subject_enc#" addtoken="no">
		</cfif>
	</cfif>
</cfif>

<cfset email_list = "">
<cfset content = "">
<cfset subject = "">

<cfif isDefined("URL.sel") AND len(URL.sel) GT 0>
	<cfset selected = URLDecode(URL.sel)>
	<cfset email_list = selected>
</cfif>

<cfinclude template="includes/get_selected_emails.cfm">

<cfif isDefined("URL.content")>
	<cfset content = URLDecode(URL.content)>
</cfif>
<cfif isDefined("URL.subject")>
	<cfset subject = URLDecode(URL.subject)>
</cfif>


<cfset email_list_enc = URLEncodedFormat(email_list)>

<!---<cfif len(users_ids) GT 0>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUsersEmails" returnvariable="users_emails">
		<cfinvokeargument name="users_ids" value="#users_ids#">
	</cfinvoke>
	
	<cfset email_list = users_emails>

</cfif>--->
<div class="contenedor_fondo_blanco">
<div class="div_send_message">
	<cfoutput>
<form action="#current_page#" method="post">
	
	<div class="div_recipients_input"><span class="texto_normal">Para:</span>&nbsp;<input type="text" name="recipients" class="input_message_recipients" value="#email_list#">&nbsp;<input type="image" name="select_users" src="assets/icons_#APPLICATION.identifier#/users.gif" alt="Agregar usuarios" value="select_users" title="Seleccionar usuarios" />&nbsp;<input type="image" name="select_contacts" src="assets/icons_#APPLICATION.identifier#/contacts.gif" alt="Agregar contactos" value="select_contacts" title="Seleccionar contactos" /></div>
	

	<div class="div_subject_input"><span class="texto_normal">Asunto:</span>&nbsp;<input type="text" name="subject" class="input_message_subject" value="#subject#"></div>
    
    <!---cftextarea is not supported by Railo 3.0--->
    <div class="div_content_textarea"><textarea name="content" class="textarea_content">#content#</textarea></div>
    </cfoutput>
    <!---<div><cfinput type="file" name="Filedata"></div>--->
    
    <div class="input_submit"><input type="submit" name="submit" class="input_message_submit" value="Enviar"></div>
</form>
</div>

</div>
<cfif isDefined("URL.return_page") AND len(URL.return_page) GT 0>
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
		<cfinvokeargument name="return_page" value="#URL.return_page#">
	</cfinvoke>
</cfif>
<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
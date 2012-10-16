<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/plantilla_basica_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2012 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#<cfif isDefined("SESSION.client_name")>-#SESSION.client_name#</cfif></title>
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
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
</head>

<body class="body_global">
<cfif APPLICATION.identifier NEQ "dp">
	<div class="div_header">
		<a href="../html/"><div class="div_header_content"><!-- --></div></a>
		<div class="div_separador_header"><!-- --></div>
	</div>
</cfif>
<!-- InstanceBeginEditable name="header" -->

<!-- InstanceEndEditable -->
<div class="div_contenedor_contenido">
<!-- InstanceBeginEditable name="contenido" -->
<cfset current_page = "mobile.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	<cfinvokeargument name="format_content" value="all">
</cfinvoke>

<cfoutput>
<div>
	<cfif APPLICATION.identifier EQ "vpnet">
		<div style="float:right; height:50px; vertical-align:middle;">
			<div style="float:right; margin-right:5px; padding-top:2px;" class="div_text_user_logged">
				<a href="preferences.cfm" class="text_user_logged">#getAuthUser()#</a>&nbsp;&nbsp;&nbsp;<a href="logout.cfm" class="text_user_logged" title="Salir">Logout</a>
			</div> 
		</div>
	<cfelse>
		<div class="div_inicio_logo">
			<a href="#APPLICATION.mainUrl#" target="_blank"><img src="assets/logo_inicio.gif" /></a>
		</div>
		<div class="div_inicio_derecha">
			<!---<div class="div_inicio_idiomas">
				<div><img src="assets/icons_#APPLICATION.identifier#/english.gif" alt="English" /></div>
				<div><img src="assets/icons_#APPLICATION.identifier#/spanish.gif" alt="Spanish" /></div>
			</div>--->
			<div class="div_inicio_usuario">
				<div class="div_text_user_logged"><a href="preferences.cfm" class="text_user_logged">#getAuthUser()#</a></div>
				<div class="div_text_user_logged"><a href="logout.cfm" class="text_user_logged" title="Salir">Logout</a></div>
			</div>
		</div>
	</cfif>
</div>

<div class="div_menu_inicio">
	
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="area.cfm"><img src="assets/icons_#APPLICATION.identifier#/organization.png" alt="Organización"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="area.cfm"><cfif APPLICATION.identifier EQ "vpnet">Acceso a los grupos de trabajo<cfelse>Organización</cfif></a>
	<!---<div style="margin-top:10px; margin-left:38px;"><a class="a_row_menu_inicio" href="area.cfm" style="font-size:12px;"><cfif APPLICATION.identifier EQ "vpnet">Versión móvil<cfelse>Versión móvil</cfif></a></div>---></div></div>
	
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="my_files.cfm"><img src="assets/icons/my_files.png" alt="Mis documentos" title="Mis documentos"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="my_files.cfm">Mis documentos</a></div></div>
	
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="preferences.cfm"><img src="assets/icons/preferences.png" alt="Preferencias" title="Preferencias"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="preferences.cfm">Preferencias</a></div></div>

	<cfif APPLICATION.identifier NEQ "dp"><!---En DoPlanning se deshabilitan los contactos y los SMS--->
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="contacts.cfm"><img src="assets/icons/contacts.png" alt="Contactos" title="Contactos"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="contacts.cfm">Contactos</a></div></div>
	
	<cfif objectUser.sms_allowed IS true>
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="sms.cfm?return_page=#current_page#"><img src="assets/icons/sms.png" alt="SMS"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="sms.cfm?return_page=#current_page#">SMS</a></div></div>
	</cfif>
	
	</cfif>
	
	<!---<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="notifications.cfm?return_page=#current_page#"><img src="assets/icons_#APPLICATION.identifier#/notifications.gif" alt="Notificaciones" title="Notificaciones"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="notifications.cfm?return_page=#current_page#">Notificaciones</a></div></div>--->
	
	<cfif APPLICATION.moduleMessenger EQ "enabled">
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a onclick="App.openMessenger('messenger_general.cfm')" target="_blank"><img src="assets/icons_#APPLICATION.identifier#/messenger_general.png" alt="Messenger" title="Messenter general"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" onclick="App.openMessenger('messenger_general.cfm')" style="cursor:pointer;">Messenger general</a></div></div>
	
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a onclick="App.openMessenger('messenger_private.cfm')"><img src="assets/icons_#APPLICATION.identifier#/messenger_privado.gif" alt="Messenger" title="Messenger privado"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" onclick="App.openMessenger('messenger_private.cfm')" style="cursor:pointer;">Messenger privado</a></div></div>
	
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="saved_conversations.cfm?return_page=#current_page#"><img src="assets/icons/saved_conversations.png" alt="Conversaciones guardadas" title="Conversaciones guardadas"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="saved_conversations.cfm?return_page=#current_page#">Conversaciones guardadas</a></div></div>
	</cfif>
	
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="search.cfm?return_page=#current_page#"><img src="assets/icons/search.png" alt="Búsquedas" title="Buscar"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="search.cfm?return_page=#current_page#">Buscar</a></div></div>
	
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="incidences.cfm?return_page=#current_page#"><img src="assets/icons/incidence.png" alt="Incidencias" title="Incidencias"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="incidences.cfm?return_page=#current_page#">Incidencias<cfif APPLICATION.identifier EQ "dp"> y sugerencias</cfif></a></div></div>
	
	<!---<cfif SESSION.client_administrator EQ SESSION.user_id>
	Esto quitado porque no tiene mucha utilidad
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="logs.cfm?return_page=#current_page#"><img src="assets/icons_#APPLICATION.identifier#/logs.gif" alt="Logs"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="logs.cfm?return_page=#current_page#">Intentos de login fallidos</a></div></div>
	
	</cfif>--->
	
	<div style="float:right;font-size:12px;">
	<a href="organization.cfm" style="font-size:12px; color:##333333;">Versión estándar</a>
	<span style="font-size:12px; color:##FFFFFF;">&nbsp;|&nbsp;</span>
	<a href="#APPLICATION.path#/#SESSION.client_abb#/index.cfm" style="font-size:12px; color:##333333;">Versión Flash</a>
	</div>
	
</div>
</cfoutput>
<div class="msg_div_error" id="errorMessage"></div>

<!---Download File--->
<cfinclude template="#APPLICATION.htmlPath#/includes/open_download_file.cfm">
<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
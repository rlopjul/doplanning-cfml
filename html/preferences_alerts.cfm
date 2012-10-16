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
<cfinclude template="includes/preferences_head.cfm">
<cfinclude template="includes/alert_message.cfm">

<div class="div_head_subtitle">
Preferencias de notificaciones
</div>



<cfset return_page = "preferences.cfm">

<!---<cfif isDefined("FORM.modify")>
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="updateUserPreferences" returnvariable="xmlResponse">
</cfinvoke>
</cfif>--->

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUserPreferences" returnvariable="xmlResponse">
</cfinvoke>

<cfxml variable="xmlPreferences">
	<cfoutput>
	#xmlResponse.response.result.preferences#
	</cfoutput>
</cfxml>

<cfset notify_new_message = xmlPreferences.preferences.xmlAttributes.notify_new_message>
<cfset notify_new_file = xmlPreferences.preferences.xmlAttributes.notify_new_file>
<cfset notify_replace_file = xmlPreferences.preferences.xmlAttributes.notify_replace_file>
<cfset notify_new_area = xmlPreferences.preferences.xmlAttributes.notify_new_area>

<cfif APPLICATION.moduleWeb EQ "enabled">
	<cfset notify_new_link = xmlPreferences.preferences.xmlAttributes.notify_new_link>
	<cfset notify_new_entry = xmlPreferences.preferences.xmlAttributes.notify_new_entry>
	<cfset notify_new_news = xmlPreferences.preferences.xmlAttributes.notify_new_news>
</cfif>

<cfset notify_new_event = xmlPreferences.preferences.xmlAttributes.notify_new_event>
<cfset notify_new_task = xmlPreferences.preferences.xmlAttributes.notify_new_task>


<div class="div_preferencias_notificaciones_blanco">
<div style="height:100%">Enviar una notificación cuando:</div>

<cfoutput>
<form action="#APPLICATION.htmlComponentsPath#/User.cfc?method=updateUserPreferences" method="post">
</cfoutput>
	
<div class="item_preferencias_notificaciones">
	<div class="checkbox"><input type="checkbox" name="notify_new_message" value="true" <cfif notify_new_message IS true>checked="checked"</cfif> /></div>
	<div class="icon"><img src="assets/icons/message_new.png" alt="Nuevo mensaje" /></div> 
	<div class="item">Un mensaje ha sido creado</div>
</div>


<cfif APPLICATION.moduleWeb EQ "enabled"><!---Web--->

<cfif APPLICATION.identifier EQ "vpnet">
<div class="item_preferencias_notificaciones">
	<div class="checkbox"><input type="checkbox" name="notify_new_link" value="true" <cfif notify_new_link IS true>checked="checked"</cfif> /></div>
	<div class="icon"><img src="assets/icons/link_new.png" alt="Nuevo enlace" /></div> 
	<div class="item">Un enlace ha sido creado</div>
</div>
</cfif>

<div class="item_preferencias_notificaciones">
	<div class="checkbox"><input type="checkbox" name="notify_new_entry" value="true" <cfif notify_new_entry IS true>checked="checked"</cfif> /></div>
	<div class="icon"><img src="assets/icons/entry_new.png" alt="Nueva entrada" /></div> 
	<div class="item">Una entrada ha sido creada</div>
</div>

<div class="item_preferencias_notificaciones">
	<div class="checkbox"><input type="checkbox" name="notify_new_news" value="true" <cfif notify_new_news IS true>checked="checked"</cfif> /></div>
	<div class="icon"><img src="assets/icons/news_new.png" alt="Nueva noticia" /></div> 
	<div class="item">Una noticia ha sido creada</div>
</div>
</cfif>

<div class="item_preferencias_notificaciones">
	<div class="checkbox"><input type="checkbox" name="notify_new_event" value="true" <cfif notify_new_event IS true>checked="checked"</cfif> /></div>
	<div class="icon"><img src="assets/icons/event_new.png" alt="Nuevo evento" /></div> 
	<div class="item">Un evento ha sido creado</div>
</div>

<cfif APPLICATION.identifier EQ "dp">
<div class="item_preferencias_notificaciones">
	<div class="checkbox"><input type="checkbox" name="notify_new_task" value="true" <cfif notify_new_task IS true>checked="checked"</cfif> /></div>
	<div class="icon"><img src="assets/icons/task_new.png" alt="Nueva tarea" /></div> 
	<div class="item">Una tarea ha sido creada</div>
</div>
</cfif>

<div class="item_preferencias_notificaciones">
	<div class="checkbox"><input type="checkbox" name="notify_new_file" value="true" <cfif notify_new_file IS true>checked="checked"</cfif> /></div>
	<div class="icon"><img src="assets/icons/file_new.png" alt="Archivo asociado" /></div> 
	
	<div class="item">Un fichero ha sido asociado a un área</div>
</div>


<div class="item_preferencias_notificaciones">
	<div class="checkbox"><input type="checkbox" name="notify_replace_file" value="true" <cfif notify_replace_file IS true>checked="checked"</cfif> /></div>
	<div class="icon"><img src="assets/icons/file_replace.png" alt="Archivo reemplazado" /></div> 
	<div class="item">Un fichero asociado a un área ha sido reemplazado</div>
</div>

<div class="item_preferencias_notificaciones">
	<div class="checkbox"><input type="checkbox" name="notify_new_area" value="true" <cfif notify_new_area IS true>checked="checked"</cfif> /></div>
	<div class="icon"><img src="assets/icons/area_new.png" alt="Crear area" /></div> 
	<div class="item">Un área nueva ha sido creada</div>
</div>

	
	<div class="input_submit"><input type="submit" name="modify" value="Modificar"/></div>
	
</form></div>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>


<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
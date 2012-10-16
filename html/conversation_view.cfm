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
<!-- InstanceBeginEditable name="head" -->
<link href="../html/styles_messenger.css" rel="stylesheet" type="text/css" media="all" />
<!-- InstanceEndEditable -->
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
<cfinclude template="includes/conversations_head.cfm">
<cfif isDefined("URL.conversation") AND isValid("integer",URL.conversation)>
	<cfset conversation_id = URL.conversation>
<cfelse>
	<cflocation url="index.cfm">
</cfif>

<script type="text/javascript">

function confirmDeleteConversation()
{
	var message_delete = "¿Seguro que desea eliminar la conversación?";
	return confirm(message_delete);
}

</script>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Messenger" method="getConversation" returnvariable="xmlResponse">
	<cfinvokeargument name="conversation_id" value="#conversation_id#">
</cfinvoke>
<cfoutput>

<cfoutput>
<div class="div_head_menu">
	<div class="div_element_menu">
		<div class="div_icon_menus"><a href="conversation_download.cfm?id=#conversation_id#"><img src="assets/icons/file_download.png" title="Descargar conversación" alt="Descargar conversación"/></a></div>
		<div class="div_text_menus"><a href="conversation_download.cfm?id=#conversation_id#" class="text_menus"><br />Descargar</a></div>
	</div>
	<div class="div_element_menu">
		<div class="div_icon_menus"><a href="#APPLICATION.htmlComponentsPath#/Messenger.cfc?method=deleteConversation&conversation_id=#conversation_id#" onclick="return confirmDeleteConversation();"><img src="assets/icons_#APPLICATION.identifier#/delete_conversation.gif" title="Eliminar conversación" alt="Eliminar conversación" /></a></div>
		<div class="div_text_menus"><a href="#APPLICATION.htmlComponentsPath#/Messenger.cfc?method=deleteConversation&conversation_id=#conversation_id#" class="text_menus" onclick="return confirmDeleteConversation();"><br />Eliminar</a></div>
	</div>
	
</div>
</cfoutput>

<div class="div_file_page_name" style="clear:both; margin-top:0px;">
#xmlResponse.response.result.conversation.name.xmlText#
</div>

<div class="msg_conversation_area" id="conversationTextArea" name="conversationTextArea">#xmlResponse.response.result.conversation.text.xmlText#</div>
</cfoutput>

<cfset return_page = "saved_conversations.cfm">
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>
<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
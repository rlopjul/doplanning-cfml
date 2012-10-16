<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/plantilla_app_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2012 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#-Contacto</title>
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
<cfif isDefined("URL.user")>
	<cfset contact_id = URL.user>
<cfelse>
	<cflocation url="contacts.cfm" addtoken="no">
</cfif>

<cfinclude template="includes/contacts_head.cfm">

<cfinclude template="includes/contact_head.cfm">

<cfoutput>
<div style="padding-top:5px;">

	<div class="div_element_menu">
		<div class="div_icon_menus"><a href="contact_modify.cfm?contact=#contact_id#"><img src="assets/icons/contact_modify.png" title="Modificar contacto" alt="Modificar" /></a></div>
		<div class="div_text_menus"><a href="contact_modify.cfm?contact=#contact_id#" class="text_menus">Modificar</a>			</div>
	</div>

	<div class="div_element_menu">
		<div class="div_icon_menus"><a href="#APPLICATION.htmlComponentsPath#/Contact.cfc?method=deleteContact&contact_id=#contact_id#"><img src="assets/icons/contact_delete.png" title="Eliminar contacto" alt="Eliminar contacto"/></a></div><div class="div_text_menus"><a href="#APPLICATION.htmlComponentsPath#/Contact.cfc?method=deleteContact&contact_id=#contact_id#"> <span class="texto_normal">Eliminar</span></a></div>
	</div>

</div>
</cfoutput>

<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Contact" method="selectContact" returnvariable="xmlResponse">
	<cfinvokeargument name="contact_id" value="#contact_id#">
</cfinvoke>

<cfxml variable="xmlContact">
	<cfoutput>
	#xmlResponse.response.result.contact#
	</cfoutput>
</cfxml>

<cfinvoke component="#APPLICATION.componentsPath#/ContactManager" method="objectContact" returnvariable="objectContact">
	<cfinvokeargument name="xml" value="#xmlContact.contact#">
	<cfinvokeargument name="return_type" value="object">
</cfinvoke>--->

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Contact" method="getContact" returnvariable="objectContact">
	<cfinvokeargument name="contact_id" value="#contact_id#">
</cfinvoke>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUser">
	<cfinvokeargument name="objectUser" value="#objectContact#">
</cfinvoke>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
		<cfinvokeargument name="return_page" value="contacts.cfm">
	</cfinvoke>
<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
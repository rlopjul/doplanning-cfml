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


<div class="div_head_subtitle">
Datos Personales
</div>
<cfinclude template="includes/alert_message.cfm">

<cfset return_page = "preferences.cfm">

<cfinvoke component="#APPLICATION.htmlPath#/login/Login" method="getUserLoggedIn" returnvariable="xmlResponse">
</cfinvoke>

<cfxml variable="xmlUser">
	<cfoutput>
	#xmlResponse.response.result.user#
	</cfoutput>
</cfxml>
<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="objectUser">
	<cfinvokeargument name="xml" value="#xmlUser.user#">
	<cfinvokeargument name="return_type" value="object">
</cfinvoke>

<cfset ccode = "34">

<cfoutput>
<form action="#APPLICATION.htmlComponentsPath#/User.cfc?method=updateUser" method="post" class="form_preferences_user_data">
	<input type="hidden" name="id" value="#objectUser.id#" />
	
	<div class="form_fila"><span class="texto_gris_12px">Nombre:</span><br />
	<input type="text" name="family_name" value="#objectUser.family_name#" style="width:100%;"/></div>
	<div class="form_fila"><span class="texto_gris_12px">Apellidos:</span><br /> <input type="text" name="name" value="#objectUser.name#" style="width:100%;"/></div>
	
	<div class="form_fila"><span class="texto_gris_12px">Email:</span><br /> <input type="text" name="email" value="#objectUser.email#" style="width:100%;"/></div>
	
	<div class="form_fila">
		<div class="form_text" style="width:100px;"><span class="texto_gris_12px">Teléfono móvil:</span></div>
		<div class="form_input" style="width:85%;"> 
		<div style="float:left; width:17px;"><input type="text" name="mobile_phone_ccode" value="#ccode#" readonly="true" style="width:17px;"/></div> 		
		<div style="float:left; width:75px;"><input type="text" name="mobile_phone" value="#objectUser.mobile_phone#" style="width:100%;"/></div>
		</div>
	</div>
	
	<div class="form_fila">
	<div class="form_text" style="width:100px;" ><span class="texto_gris_12px">Teléfono:</span></div>
	<div class="form_input" style="width:85%;">
	<div style="float:left; width:17px;"><input type="text" name="telephone_ccode" value="#ccode#" readonly="true" style="width:17px;"/></div>
	<div style="float:left; width:75px;"><input type="text" name="telephone" value="#objectUser.telephone#" style="width:100%" /></div>
	</div>
	</div>
	
	<div class="form_fila"><span class="texto_gris_12px">Dirección:</span><br /> <textarea type="text" name="address"  style="width:100%" rows="2"/>#objectUser.address#</textarea></div>
	
	<div class="form_fila">
	<div class="form_text" style="width:150px;"><span class="texto_gris_12px">Nueva Contraseña:</span> </div>
	<div class="form_input" style="width:77%"><input type="password" name="password" value="" style="width:100%;"/></div>
	</div>
	
	<div class="form_fila">
	<div class="form_text" style="width:150px;"><span class="texto_gris_12px" style="vertical-align:middle">Confirmar contraseña:</span> </div>
	<div class="form_input" style="width:77%"><input type="password" name="password_confirmation" value="" style="width:100%;"/></div>
	</div>
	
	<div class="input_submit"><input type="submit" name="modify" value="Modificar" /></div>
</form>
<br />
</cfoutput>


<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>
<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
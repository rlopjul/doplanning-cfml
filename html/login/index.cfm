<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/plantilla_diseno_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2012 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<cfinclude template="#APPLICATION.htmlPath#/includes/login_query.cfm">

<cfif NOT isDefined("URL.client_abb")>
	<cfif len(APPLICATION.path) GT 0>
		<cflocation url="#APPLICATION.path#" addtoken="no">
	<cfelse>
		<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
	</cfif>
<cfelse>
	<cfset client_abb = URL.client_abb>
</cfif>

<cfquery datasource="#APPLICATION.dsn#" name="getClient">
	SELECT *
	FROM APP_clients
	WHERE abbreviation = <cfqueryparam value="#client_abb#" cfsqltype="cf_sql_varchar">;
</cfquery>

<cfif getClient.recordCount IS 0>
	<cfif len(APPLICATION.path) GT 0>
		<cflocation url="#APPLICATION.path#" addtoken="no">
	<cfelse>
		<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
	</cfif>
</cfif>

<title>#APPLICATION.title# - #getClient.name#</title>
<!-- InstanceEndEditable -->
</cfoutput>
<script type="text/javascript" src="../../SpryAssets/includes/xpath.js"></script>
<script type="text/javascript" src="../../SpryAssets/includes/SpryData.js"></script>
<script type="text/javascript" src="../../SpryAssets/includes/SpryXML.js"></script>
<script type="text/javascript" src="../../SpryAssets/includes/SpryDOMUtils.js"></script>
<cfif APPLICATION.moduleMessenger EQ "enabled">
<script type="text/javascript" src="../../app/scripts/App.js"></script>
<script type="text/javascript" src="../Scripts/MessengerControl.js"></script>
<cfif isDefined("SESSION.user_id")>
<script type="text/javascript">
window.onload = function ()
{
	Messenger.Private.initGetNewConversations();
}
</script>
</cfif>
</cfif>
<script type="text/javascript" src="../Scripts/functions.js"></script>
<link href="../styles.css" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "vpnet">
<link href="../styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="../styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<!--using caps S (Screen), Pocket IE ignores it. Windows Mobile 6.1 ignores media="handled"-->  
<link href="../styles_screen.css" rel="stylesheet" type="text/css" media="Screen" />
<link href="../styles_mobiles.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 800px)" />
<!---<link href="../html/styles_mobiles.css" rel="stylesheet" type="text/css" media="handheld" />
<link href="../html/styles_iphone.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 480px)" />--->
<!-- InstanceBeginEditable name="head" -->
<script src="class.cod.js" type="text/javascript"></script>
<script type="text/javascript">
// JavaScript Document
function codificarForm(form)
{ 
	form.password.readonly = true;
	<cfif APPLICATION.identifier EQ "dp">
		var password = form.password.value;
		form.password.value = "";
		var passwordcod = MD5.hex_md5(password);
		form.password.value = passwordcod;
	</cfif>
	return (true);
}
</script>
<!-- InstanceEndEditable -->
</head>

<body class="body_global">
<cfif APPLICATION.identifier NEQ "dp">
	<div class="div_header">
		<a href="../../html/"><div class="div_header_content"><!-- --></div></a>
		<div class="div_separador_header"><!-- --></div>
	</div>
</cfif>
<!-- InstanceBeginEditable name="header" -->
<!-- InstanceEndEditable -->
<div class="div_contenedor_contenido">
<!-- InstanceBeginEditable name="contenido" -->

<div style="width:300px; margin:auto;">

<cfoutput>
<div class="div_login_logo">
	<cfif APPLICATION.identifier EQ "dp"><a href="#APPLICATION.mainUrl#"><img src="../assets/logo_inicio.gif" alt="Logo" /></a></cfif>
</div>

<cfif APPLICATION.identifier EQ "dp">
<div class="texto_normal" style="padding-top:30px; padding-left:5px;">
Acceso a DoPlanning <strong>#getClient.name#</strong>.
</div>
<cfelseif APPLICATION.identifier EQ "vpnet">
<div class="texto_normal" style="padding-top:30px; padding-left:5px;">
Acceso a Colabora.
</div>
</cfif>
</cfoutput>

<cfif isDefined("URL.dpage")>
	<cfset destination_page = URLDecode(URL.dpage)>
<cfelse>
	<cfset destination_page = "">
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/login_form.cfm">

</div>
<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
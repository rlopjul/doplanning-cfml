<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2013 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<!---<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />--->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#-Modificar formulario</title>
<!-- InstanceEndEditable -->
<link href="assets/favicon.ico" rel="shortcut icon" type="image/x-icon">
<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">
<link href="#APPLICATION.themeCSSPath#" rel="stylesheet">
<!---
	<script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <link href="//netdna.bootstrapcdn.com/respond-proxy.html" id="respond-proxy" rel="respond-proxy" />
    <link href="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.gif" id="respond-redirect" rel="respond-redirect" />
    <script src="//oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <script src="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.js"></script>
--->
<!--[if lt IE 9]>
	<script src="#APPLICATION.htmlPath#/scripts/html5shiv/html5shiv.js"></script>
    <script src="#APPLICATION.htmlPath#/scripts/respond/respond.min.js"></script>
<![endif]-->
<!--[if lt IE 8]>
  	<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-ie7/bootstrap-ie7.css" rel="stylesheet" rel="stylesheet">
<![endif]-->
<!---<link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome-ie7.min.css" rel="stylesheet">--->
<!--[if IE 7]>
	<link href="#APPLICATION.htmlPath#/font-awesome/css/font-awesome-ie7.min.css" rel="stylesheet">
<![endif]-->

<link href="styles/styles.min.css?v=2.1" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "vpnet">
<link href="styles/styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="styles/styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<!---using caps S (Screen), Pocket IE ignores it. Windows Mobile 6.1 ignores media="handled"--->  
<link href="styles/styles_screen.css" rel="stylesheet" type="text/css" media="Screen" />
<link href="styles/styles_mobiles.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 800px)" />
<!---<link href="../html/styles_mobiles.css" rel="stylesheet" type="text/css" media="handheld" />
<link href="../html/styles_iphone.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 480px)" />--->
</cfoutput>

<cfif APPLICATION.identifier EQ "vpnet">
	<!---Esto solo debe mantenerse para la versión vpnet (por el Messenger)--->
	<script src="../SpryAssets/includes/xpath.js"></script>
	<script src="../SpryAssets/includes/SpryData.js"></script>
	<script src="../SpryAssets/includes/SpryXML.js"></script>
	<script src="../SpryAssets/includes/SpryDOMUtils.js"></script>
	<cfif APPLICATION.moduleMessenger EQ true>
		<script src="../app/scripts/App.js"></script>
		<script src="scripts/MessengerControl.js"></script>
		<cfif isDefined("SESSION.user_id")>
		<script type="text/javascript">
		window.onload = function (){
			Messenger.Private.initGetNewConversations();
		}
		</script>
		</cfif>
	</cfif>
</cfif>

<cfoutput>
<script src="#APPLICATION.jqueryJSPath#"></script>
<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang-dp.js" charset="utf-8" ></script>
<script src="#APPLICATION.htmlPath#/language/base_en.js" charset="utf-8"></script>
<script src="scripts/functions.min.js?v=2.1"></script>
</cfoutput>

<script type="text/javascript">
	//Language
	jquery_lang_js.prototype.defaultLang = 'es';
	jquery_lang_js.prototype.currentLang = 'es';
	window.lang = new jquery_lang_js();
	
	$().ready(function () {
		window.lang.run();
	});
</script>


<cfoutput>
<script type="text/javascript" src="#APPLICATION.bootstrapJSPath#"></script>
</cfoutput>
<script type="text/javascript">
	function openUrlLite(url,target){
		window.location.href = url;
	}
	function openUrl(url,target,event){
		window.location.href = url;
	}
	function openUrlHtml2(url,target){
		//En esta versión no se hace nada con las peticiones a este método
	}
</script>
<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
</head>

<body onBeforeUnload="onUnloadPage()" onLoad="onLoadPage()" class="body_global">
<!---divLoading--->
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_page_div.cfm">
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
		<a href="preferences.cfm" class="link_user_logged" title="Preferencias del usuario" lang="es">#getAuthUser()#</a>&nbsp;&nbsp;&nbsp;<a href="logout.cfm" class="text_user_logged" title="Cerrar sesión" lang="es"><i class="icon-signout"></i> <span lang="es">Salir</span></a>
	</div>
</div>
</cfoutput>

<div class="div_contenedor_contenido">
<!-- InstanceBeginEditable name="contenido" -->

<cfset return_path = "#APPLICATION.htmlPath#/">
<cfset tableTypeId = 2>
<cfset page_type = 2>
<cfinclude template="#APPLICATION.htmlPath#/includes/area_table_form.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>
<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
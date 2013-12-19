<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_iframes_estilos.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<!-- InstanceBeginEditable name="doctitle" -->
<title></title>
<!-- InstanceEndEditable -->
<cfoutput>
<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">
<link href="#APPLICATION.themeCSSPath#" rel="stylesheet">

<!--[if lt IE 9]>
	<script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <link href="//netdna.bootstrapcdn.com/respond-proxy.html" id="respond-proxy" rel="respond-proxy" />
    <link href="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.gif" id="respond-redirect" rel="respond-redirect" />
    <script src="//oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <script src="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.js"></script>
<![endif]-->
<!--[if lt IE 8]>
  	<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-ie7/bootstrap-ie7.css" rel="stylesheet" rel="stylesheet">
<![endif]-->
<!--[if IE 7]>
  	<link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome-ie7.min.css" rel="stylesheet" >
<![endif]-->

<link href="../styles/styles.min.css?v=2.1" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "vpnet">
<link href="../styles/styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="../styles/styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<link href="../styles/styles_iframes.css" rel="stylesheet" type="text/css" media="all" />

<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.bootstrapJSPath#"></script>

<script type="text/javascript" src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang-dp.js" charset="utf-8" ></script>

<script type="text/javascript" src="../scripts/functions.min.js?v=2.1"></script>
<script type="text/javascript" src="../scripts/iframesFunctions.min.js?v=2"></script>

<script type="text/javascript">
	//Language
	jquery_lang_js.prototype.defaultLang = 'es';
	jquery_lang_js.prototype.currentLang = 'es';
	
	jquery_lang_js.prototype.lang.en = [{}];
	
	window.lang = new jquery_lang_js();
	
	$().ready(function () {
   		window.lang.run();
	});
</script>

</cfoutput>
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
</head>

<body onBeforeUnload="onUnloadPage()" onLoad="onLoadPage()">
<!---divLoading--->
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_page_div.cfm">

<!-- InstanceBeginEditable name="content" -->

<cfset return_path = "#APPLICATION.htmlPath#/iframes2/">
<cfset itemTypeId = 7>
<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_new_content.cfm">

<!-- InstanceEndEditable -->
</body>
<!-- InstanceEnd --></html>

<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_iframes_estilos.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<meta charset="utf-8"> 
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<!-- InstanceBeginEditable name="doctitle" -->
<title></title>
<!-- InstanceEndEditable -->
<cfoutput>
<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">
<!---<!--[if lt IE 9]>
	<script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <link href="//netdna.bootstrapcdn.com/respond-proxy.html" id="respond-proxy" rel="respond-proxy" />
    <link href="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.gif" id="respond-redirect" rel="respond-redirect" />
    <script src="//oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <script src="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.js"></script>
<![endif]-->
<!--[if IE 7]>
  	<link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome-ie7.min.css" rel="stylesheet" >
<![endif]-->--->

<!--[if lt IE 9]>
	<script src="#APPLICATION.htmlPath#/scripts/html5shiv/html5shiv.js"></script>
    <script src="#APPLICATION.htmlPath#/scripts/respond/respond.min.js"></script>
<![endif]-->
<!--[if lt IE 8]>
  	<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-ie7/bootstrap-ie7.css" rel="stylesheet" rel="stylesheet">
<![endif]-->
<!--[if IE 7]>
	<link href="#APPLICATION.htmlPath#/font-awesome/css/font-awesome-ie7.min.css" rel="stylesheet">
<![endif]-->

<link href="#APPLICATION.dpCSSPath#" rel="stylesheet" type="text/css" media="all" />
<cfif len(APPLICATION.themeCSSPath) GT 0>
<link href="#APPLICATION.themeCSSPath#" rel="stylesheet">
</cfif>
<cfif APPLICATION.identifier EQ "vpnet">
<link href="../styles/styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="../styles/styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<link href="../styles/styles_iframes.css" rel="stylesheet" type="text/css" media="all" />

<script src="#APPLICATION.jqueryJSPath#"></script>
<script src="#APPLICATION.bootstrapJSPath#"></script>

<!---<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang-dp.js" charset="utf-8" ></script>--->
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.min.js" charset="utf-8" ></script>

<script src="../scripts/functions.min.js?v=2.3"></script>
<script src="../scripts/iframesFunctions.min.js?v=2.1"></script>

<script>
	//Language
	<!--- jquery_lang_js.prototype.defaultLang = 'es';
	jquery_lang_js.prototype.currentLang = 'es';
	jquery_lang_js.prototype.lang.en = [{}];
	window.lang = new jquery_lang_js();
	
	$().ready(function () {
   		window.lang.run();
	});--->
	
	Lang.prototype.pack.en = {};
	Lang.prototype.pack.en.token = {};
	
	$().ready(function () {
		window.lang = new Lang('es');
	});
</script>
<script src="#APPLICATION.htmlPath#/language/regex_en.js" charset="utf-8"></script>

</cfoutput>
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
</head>

<body onBeforeUnload="onUnloadPage()" onLoad="onLoadPage()">
<!---divLoading--->
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_page_div.cfm">

<!-- InstanceBeginEditable name="content" -->

<cfinclude template="#APPLICATION.htmlPath#/includes/all_area_items_content.cfm">

<!-- InstanceEndEditable -->
</body>
<!-- InstanceEnd --></html>

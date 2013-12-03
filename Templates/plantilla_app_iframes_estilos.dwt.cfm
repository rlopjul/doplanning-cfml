<!DOCTYPE html>
<html lang="es">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<!-- TemplateBeginEditable name="doctitle" -->
<title></title>
<!-- TemplateEndEditable -->
<cfoutput>
<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">
<link href="#APPLICATION.themeCSSPath#" rel="stylesheet">

<link href="../html/styles/styles.min.css" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "vpnet">
<link href="../html/styles/styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="../html/styles/styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<link href="../html/styles/styles_iframes.css" rel="stylesheet" type="text/css" media="all" />

<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.bootstrapJSPath#"></script>

<script type="text/javascript" src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.js" charset="utf-8" ></script>

<script type="text/javascript" src="../html/scripts/functions.min.js?v=2.1"></script>
<script type="text/javascript" src="../html/scripts/iframesFunctions.min.js?v=2"></script>

<script type="text/javascript">
	//Language
	jquery_lang_js.prototype.defaultLang = 'es';
	jquery_lang_js.prototype.currentLang = 'es';
	
	jquery_lang_js.prototype.lang.en = [{}];
	
	window.lang = new jquery_lang_js();
	
	$().ready(function () {
   		window.lang.run();
		
		<!---<cfif page_language NEQ "es">
			<cfoutput>
			window.lang.change('#page_language#');
			</cfoutput>
		</cfif>--->
	});
	
</script>

</cfoutput>
<!-- TemplateBeginEditable name="head" -->
<!-- TemplateEndEditable -->
</head>

<body onBeforeUnload="onUnloadPage()" onLoad="onLoadPage()">
<!---divLoading--->
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_page_div.cfm">

<!-- TemplateBeginEditable name="content" -->
<!-- TemplateEndEditable -->
</body>
</html>

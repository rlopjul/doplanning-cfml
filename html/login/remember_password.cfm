<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_diseno_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<!--Developed and copyright by Web4Bio 2007-2014 (www.web4bio.com)-->
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<!---<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />--->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<cfinclude template="#APPLICATION.corePath#/includes/remember_password_query.cfm">

<cfif NOT isDefined("URL.client_abb")>
	<cfif len(APPLICATION.path) GT 0>
		<cflocation url="#APPLICATION.path#" addtoken="no">
	<cfelse>
		<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
	</cfif>
<cfelse>
	<cfset client_abb = URL.client_abb>
</cfif>

<!---Aqu� se a�ade COLLATE utf8_bin para que sea case sensitive en la comparaci�n--->
<cfquery datasource="#APPLICATION.dsn#" name="getClient">
	SELECT *
	FROM APP_clients
	WHERE abbreviation LIKE <cfqueryparam value="#client_abb#" cfsqltype="cf_sql_varchar"> COLLATE utf8_bin;
</cfquery>

<cfif getClient.recordCount IS 0>
	<cfif len(APPLICATION.path) GT 0>
		<cflocation url="#APPLICATION.path#" addtoken="no">
	<cfelse>
		<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
	</cfif>
</cfif>

<title>#APPLICATION.title#-#getClient.name#: obtener nueva contrase&ntilde;a</title>
<!-- InstanceEndEditable -->
<link href="../assets/favicon.ico" rel="shortcut icon" type="image/x-icon">
<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">
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

<!---<link href="../html/styles/styles.min.css?v=2.2" rel="stylesheet" type="text/css" media="all" />--->
<link href="#APPLICATION.dpCSSPath#" rel="stylesheet" type="text/css" media="all" />
<cfif len(APPLICATION.themeCSSPath) GT 0>
<link href="#APPLICATION.themeCSSPath#" rel="stylesheet">
</cfif>
<cfif APPLICATION.identifier EQ "vpnet">
<link href="../styles/styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="../styles/styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<!---using caps S (Screen), Pocket IE ignores it. Windows Mobile 6.1 ignores media="handled"--->  
<link href="../styles/styles_screen.css" rel="stylesheet" type="text/css" media="Screen" />
<link href="../styles/styles_mobiles.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 800px)" />
<!---<link href="../html/styles_mobiles.css" rel="stylesheet" type="text/css" media="handheld" />
<link href="../html/styles_iphone.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 480px)" />--->
</cfoutput>

<cfif APPLICATION.identifier EQ "vpnet">
	<!---Esto solo debe mantenerse para la versión vpnet (por el Messenger)--->
	<script src="../../SpryAssets/includes/xpath.js"></script>
	<script src="../../SpryAssets/includes/SpryData.js"></script>
	<script src="../../SpryAssets/includes/SpryXML.js"></script>
	<script src="../../SpryAssets/includes/SpryDOMUtils.js"></script>
	<cfif APPLICATION.moduleMessenger EQ true>
		<script src="../../app/scripts/App.js"></script>
		<script src="../scripts/MessengerControl.js"></script>
		<cfif isDefined("SESSION.user_id")>
		<script>
		window.onload = function (){
			Messenger.Private.initGetNewConversations();
		}
		</script>
		</cfif>
	</cfif>
</cfif>

<cfoutput>
<script src="#APPLICATION.jqueryJSPath#"></script>
<script src="#APPLICATION.bootstrapJSPath#"></script>
<!---<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang-dp.js" charset="utf-8" ></script>--->
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.min.js" charset="utf-8" ></script>
<script src="#APPLICATION.htmlPath#/language/base_en.js" charset="utf-8"></script>
<script src="#APPLICATION.htmlPath#/language/regex_en.js" charset="utf-8"></script>
<script src="../scripts/functions.min.js?v=2.1"></script>
</cfoutput>

<script>
	//Language
	<!---
	jquery_lang_js.prototype.defaultLang = 'es';
	jquery_lang_js.prototype.currentLang = 'es';
	window.lang = new jquery_lang_js();
	
	$().ready(function () {
		window.lang.run();
	});
	--->
	
	window.lang = new Lang('es');
</script>

<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
</head>

<body onBeforeUnload="onUnloadPage()" onLoad="onLoadPage()" class="body_global">
<!---divLoading--->
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_page_div.cfm">
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
<cfoutput>
<div class="container"><!---login_container--->

	<div class="row">
	
		<cfif APPLICATION.identifier EQ "dp">
			<div class="col-md-2">
				<div class="row">
					<div class="col-xs-6">
					<cfif APPLICATION.title EQ "DoPlanning">
						<a href="http://doplanning.net/" target="_blank"><img src="../assets/logo_inicio.gif" alt="DoPlanning" title="DoPlanning" /></a>
					</cfif>
					</div>
					<cfif APPLICATION.title EQ "DoPlanning">
					<div class="col-xs-6" style="text-align:right;">
						<a href="#APPLICATION.helpUrl#" target="_blank" title="Ayuda DoPlanning" class="visible-sm visible-xs" lang="es"><i class="icon-question-sign"></i></a>
					</div>
					</cfif>
				</div>
			</div>
		</cfif>
		
		
		<cfif APPLICATION.identifier EQ "dp">
		<div class="col-md-8" style="text-align:center">
			<img src="download_login_image.cfm?abb=#client_abb#" alt="DoPlanning Banner" />
		</div>
		</cfif>
		
		<cfif APPLICATION.title EQ "DoPlanning" AND APPLICATION.identifier EQ "dp">
		<div class="col-md-2" style="text-align:right;">
			<a href="#APPLICATION.helpUrl#" target="_blank" title="Ayuda DoPlanning" class="hidden-sm hidden-xs" lang="es"><i class="icon-question-sign"></i></a>
		</div>
		</cfif>
		
	</div>
	
	<div class="row">
		<div style="text-align:center;padding-top:30px;">
			<p class="texto_normal">
				<span lang="es">Obtener una nueva contrase&ntilde;a para #APPLICATION.title#</span> <strong>#getClient.name#</strong> 
			</p>
		</div>
	</div>
	
	<div class="row">
		<cfif APPLICATION.identifier EQ "dp">

			<cfinclude template="#APPLICATION.corePath#/includes/remember_password_form.cfm">
			
		</cfif>
	</div>

</div>
</cfoutput>
<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
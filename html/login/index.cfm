<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_diseno_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2013 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<!---<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />--->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<cfinclude template="#APPLICATION.corePath#/includes/login_query.cfm">

<cfif NOT isDefined("URL.client_abb")>
	<cfif len(APPLICATION.path) GT 0>
		<cflocation url="#APPLICATION.path#" addtoken="no">
	<cfelse>
		<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
	</cfif>
<cfelse>
	<cfset client_abb = URL.client_abb>
</cfif>

<!---Aquí se añade COLLATE utf8_bin para que sea case sensitive en la comparación--->
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

<title>#APPLICATION.title# - #getClient.name#</title>
<!-- InstanceEndEditable -->
<link href="../assets/favicon.ico" rel="shortcut icon" type="image/x-icon">
<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">

<link href="../styles/styles.min.css" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "vpnet">
<link href="../styles/styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="../styles/styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<!--using caps S (Screen), Pocket IE ignores it. Windows Mobile 6.1 ignores media="handled"-->  
<link href="../styles/styles_screen.css" rel="stylesheet" type="text/css" media="Screen" />
<link href="../styles/styles_mobiles.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 800px)" />
<!---<link href="../html/styles_mobiles.css" rel="stylesheet" type="text/css" media="handheld" />
<link href="../html/styles_iphone.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 480px)" />--->
</cfoutput>

<cfif APPLICATION.identifier EQ "vpnet">
	<!---Esto solo debe mantenerse para la versión vpnet (por el Messenger)--->
	<script type="text/javascript" src="../../SpryAssets/includes/xpath.js"></script>
	<script type="text/javascript" src="../../SpryAssets/includes/SpryData.js"></script>
	<script type="text/javascript" src="../../SpryAssets/includes/SpryXML.js"></script>
	<script type="text/javascript" src="../../SpryAssets/includes/SpryDOMUtils.js"></script>
	<cfif APPLICATION.moduleMessenger EQ true>
		<script type="text/javascript" src="../../app/scripts/App.js"></script>
		<script type="text/javascript" src="../scripts/MessengerControl.js"></script>
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
<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.js" charset="utf-8" ></script>
<script src="#APPLICATION.htmlPath#/language/base_en.js" charset="utf-8" type="text/javascript"></script>
<script type="text/javascript" src="../scripts/functions.min.js"></script>
</cfoutput>

<script type="text/javascript">
	//Language
	jquery_lang_js.prototype.defaultLang = 'es';
	jquery_lang_js.prototype.currentLang = 'es';
	window.lang = new jquery_lang_js();
	
	$().ready(function () {
		//Language
		window.lang.run();
	});
</script>

<!-- InstanceBeginEditable name="head" -->
<cfoutput>
<script type="text/javascript" src="#APPLICATION.bootstrapJSPath#"></script>
</cfoutput>

<script src="class.cod.min.js" type="text/javascript"></script>

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
<cfoutput>
<div class="container-fluid"><!---login_container--->

	<div class="row-fluid">
	
		<div class="span2"><!---class="div_login_logo"--->
			<cfif APPLICATION.identifier EQ "dp"><a href="http://www.doplanning.net/" target="_blank"><img src="../assets/logo_inicio.gif" alt="DoPlanning" title="DoPlanning" /></a></cfif>
		</div>
		
		<cfif APPLICATION.identifier EQ "dp">
		<div class="span8" style="text-align:center">
			<img src="download_login_image.cfm?abb=#client_abb#" alt="DoPlanning Banner" />
		</div>
		</cfif>
		
		<cfif APPLICATION.identifier EQ "dp">
		<div class="span1 offset1" style="text-align:right;"><!---class="div_login_help"--->
			<a href="#APPLICATION.helpUrl#" target="_blank" title="Ayuda DoPlanning" lang="es"><i class="icon-question-sign"></i></a>
		</div>
		</cfif>
		
	</div>
	
	<div class="row">
		<div style="text-align:center;padding-top:30px;">
			<span class="texto_normal">
			<cfif APPLICATION.identifier EQ "dp">
			<span lang="es">Acceso a DoPlanning</span> <strong>#getClient.name#</strong>
			<cfelseif APPLICATION.identifier EQ "vpnet">
			Acceso a Colabora.
			</cfif>
			</span>
		</div>
	</div>
	
	<div class="row">
		<cfif isDefined("URL.dpage")>
			<cfset destination_page = URLDecode(URL.dpage)>
		<cfelse>
			<cfset destination_page = "">
		</cfif>
		
		<cfinclude template="#APPLICATION.corePath#/includes/login_form.cfm">
	</div>

</div>
</cfoutput>
<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
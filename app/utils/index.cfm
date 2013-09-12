<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_basica_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2013 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<!---<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />--->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#</title>
<!-- InstanceEndEditable -->
<link href="../../html/assets/favicon.ico" rel="shortcut icon" type="image/x-icon">
<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">

<link href="../../html/styles/styles.min.css" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "vpnet">
<link href="../../html/styles/styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="../../html/styles/styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<!--using caps S (Screen), Pocket IE ignores it. Windows Mobile 6.1 ignores media="handled"-->  
<link href="../../html/styles/styles_screen.css" rel="stylesheet" type="text/css" media="Screen" />
<link href="../../html/styles/styles_mobiles.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 800px)" />
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
		<script type="text/javascript" src="../scripts/App.js"></script>
		<script type="text/javascript" src="../../html/scripts/MessengerControl.js"></script>
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
<script type="text/javascript" src="../../html/scripts/functions.min.js"></script>
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

<strong>IMPORTACIÓN DE USUARIOS</strong>

<p>Para la importación de usuarios es necesario seguir los siguientes pasos:</p>

<p style="margin-left:20px;">
	<a href="import/import_1_users_from_csv.cfm" target="_blank">1º Cargar desde un CSV los usuarios.</a><br/>
	
	<a href="import/import_2_users_to_doplanning.cfm" target="_blank">2º Crear los usuarios cargados en DoPlanning.</a><br/>
</p>


<p>Una vez realizados los pasos anteriores correctamente, comprobar que los usuarios aparecen creados en la aplicación.</p>


<!-- InstanceEndEditable -->
<div class="div_contenedor_contenido">
<!-- InstanceBeginEditable name="contenido" -->
<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
<!DOCTYPE html>
<!---language--->
<cfset page_language = SESSION.user_language>

<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_iframes_estilos.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- InstanceBeginEditable name="doctitle" -->
<title></title>
<!-- InstanceEndEditable -->
<cfoutput>
<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">

<link href="../styles.min.css" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "vpnet">
<link href="../styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="../styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<link href="../styles_iframes.css" rel="stylesheet" type="text/css" media="all" />

<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.bootstrapJSPath#"></script>

<script type="text/javascript" src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.js" charset="utf-8" ></script>


<script type="text/javascript" src="../Scripts/functions.js"></script>
<script type="text/javascript" src="../Scripts/iframesFunctions.js"></script>

<script type="text/javascript">
	//Language
	jquery_lang_js.prototype.defaultLang = 'es';
	jquery_lang_js.prototype.currentLang = 'es';
	
	jquery_lang_js.prototype.lang.en = [{}];
	
	window.lang = new jquery_lang_js();
	
	$().ready(function () {
		//Language
   		window.lang.run();
		
		<!---<cfif page_language NEQ "es">
			<cfoutput>
			window.lang.change('#page_language#');
			</cfoutput>
		</cfif>--->
	});
	
</script>

</cfoutput>
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
</head>

<body onbeforeunload="onUnloadPage()" onLoad="onLoadPage()">
<!---divLoading--->
<div style="position:absolute; width:100%; text-align:center; padding-top:160px;" id="areaLoading">
	<cfoutput>
	<img src="#APPLICATION.htmlPath#/assets/icons/loading.gif" alt="Loading" title="Loading" style="text-align:center;" /> 
	</cfoutput>
</div>
<!-- InstanceBeginEditable name="content" -->

<cfinclude template="#APPLICATION.htmlPath#/includes/sms.cfm">

<!-- InstanceEndEditable -->
</body>
<!-- InstanceEnd --></html>

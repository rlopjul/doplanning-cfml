<!--- APP HTML HEADER --->

<cfif find("error.cfm", CGI.SCRIPT_NAME) IS 0 AND isDefined("SESSION.user_id")><!---error.cfm no necesita esto y puede dar problemas en errores de consulta de usuarios--->

  <cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="loggedUser">
    <cfinvokeargument name="user_id" value="#SESSION.user_id#">
  </cfinvoke>

</cfif>

<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
</cfinvoke>

<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

<!--Developed and copyright by Era7 Information Technologies & Web4Bio 2007-2016 (www.doplanning.net)-->
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<!---<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />--->
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<cfoutput>

<link href="#APPLICATION.htmlPath#/assets/favicon.ico" rel="shortcut icon" type="image/x-icon">
<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">
<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet">
<link href="#APPLICATION.dpCSSPath#" rel="stylesheet" />
<cfif len(APPLICATION.themeCSSPath) GT 0>
<link href="#APPLICATION.themeCSSPath#" rel="stylesheet">
</cfif>
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
    <link href="//maxcdn.bootstrapcdn.com/respond-proxy.html" id="respond-proxy" rel="respond-proxy" />
    <link href="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.gif" id="respond-redirect" rel="respond-redirect" />
    <script src="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.js"></script>
<![endif]-->
<!--[if lt IE 8]>
  	<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-ie7/bootstrap-ie7.css" rel="stylesheet" rel="stylesheet">
<![endif]-->
<!---<link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome-ie7.min.css" rel="stylesheet">--->
<!--[if IE 7]>
	<link href="#APPLICATION.htmlPath#/font-awesome/css/font-awesome-ie7.min.css" rel="stylesheet">
<![endif]-->

</cfoutput>

<cfif APPLICATION.identifier EQ "vpnet">
	<!---Esto solo debe mantenerse para la versión vpnet (por el Messenger)--->
	<script src="../SpryAssets/includes/xpath.js"></script>
	<script src="../SpryAssets/includes/SpryData.js"></script>
	<script src="../SpryAssets/includes/SpryXML.js"></script>
	<script src="../SpryAssets/includes/SpryDOMUtils.js"></script>
	<cfif APPLICATION.moduleMessenger EQ true>
		<script src="../app/scripts/App.js"></script>
		<script src="../html/scripts/MessengerControl.js"></script>
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
<script src="#APPLICATION.path#/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script src="#APPLICATION.path#/libs/bootbox/4.4.0/bootbox.min.js"></script>
<script src="#APPLICATION.path#/jquery/jquery.html5.history.min.js" charset="utf-8"></script>
<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.min.js" charset="utf-8" ></script>
<!---<script src="#APPLICATION.htmlPath#/language/base_en.js" charset="utf-8"></script>
<script src="#APPLICATION.htmlPath#/language/regex_en.js" charset="utf-8"></script>--->
<!---<script src="#APPLICATION.htmlPath#/language/dp_en.js" charset="utf-8"></script>--->
<script src="#APPLICATION.functionsJSPath#"></script>


<script>
	//Language
	window.lang = new Lang('es');
	window.lang.dynamic('en', '#APPLICATION.mainUrl#/html/language/main_en.cfm');

	<cfif isDefined("SESSION.user_language")>
		<cfif SESSION.user_language NEQ "es">
    $(document).ready(function() {
			window.lang.change('#SESSION.user_language#');
    });
		</cfif>
		bootbox.setDefaults({"locale" : "#SESSION.user_language#"});
	</cfif>
</script>
</cfoutput>
<script>
	function openUrlLite(url,target){
		window.location.href = url;
	}
	function openUrl(url,target,event){
		window.location.href = url;
	}
	function openUrlHtml2(url,target){
		<!---En esta version no se hace nada con las peticiones a este metodo--->
	}
</script>

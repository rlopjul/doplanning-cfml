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
<title>#APPLICATION.title#<cfif isDefined("SESSION.client_name")>-#SESSION.client_name#</cfif></title>
<!-- InstanceEndEditable -->
<link href="assets/favicon.ico" rel="shortcut icon" type="image/x-icon">
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

<link href="styles/styles.min.css?v=2" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "vpnet">
<link href="styles/styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="styles/styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<!--using caps S (Screen), Pocket IE ignores it. Windows Mobile 6.1 ignores media="handled"-->  
<link href="styles/styles_screen.css" rel="stylesheet" type="text/css" media="Screen" />
<link href="styles/styles_mobiles.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 800px)" />
<!---<link href="../html/styles_mobiles.css" rel="stylesheet" type="text/css" media="handheld" />
<link href="../html/styles_iphone.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 480px)" />--->
</cfoutput>

<cfif APPLICATION.identifier EQ "vpnet">
	<!---Esto solo debe mantenerse para la versión vpnet (por el Messenger)--->
	<script type="text/javascript" src="../SpryAssets/includes/xpath.js"></script>
	<script type="text/javascript" src="../SpryAssets/includes/SpryData.js"></script>
	<script type="text/javascript" src="../SpryAssets/includes/SpryXML.js"></script>
	<script type="text/javascript" src="../SpryAssets/includes/SpryDOMUtils.js"></script>
	<cfif APPLICATION.moduleMessenger EQ true>
		<script type="text/javascript" src="../app/scripts/App.js"></script>
		<script type="text/javascript" src="scripts/MessengerControl.js"></script>
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
<script type="text/javascript" src="scripts/functions.min.js?v=2.1"></script>
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

<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
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
<!-- InstanceBeginEditable name="header" -->

<!-- InstanceEndEditable -->
<div class="div_contenedor_contenido">
<!-- InstanceBeginEditable name="contenido" -->
<cfset current_page = "mobile.cfm">

<cfoutput>
<script src="#APPLICATION.htmlPath#/language/main_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	<cfinvokeargument name="format_content" value="all">
</cfinvoke>

<cfoutput>
<div>
	<cfif APPLICATION.identifier EQ "vpnet">
		<div style="float:right; height:50px; vertical-align:middle;">
			<div style="float:right; margin-right:5px; padding-top:2px;" class="div_text_user_logged">
				<a href="preferences.cfm" class="text_user_logged">#getAuthUser()#</a>&nbsp;&nbsp;&nbsp;<a href="logout.cfm" class="text_user_logged" title="Salir" lang="es">Salir</a>
			</div> 
		</div>
	<cfelse>
		<div class="div_inicio_logo">
			<a href="http://www.doplanning.net/" target="_blank"><img src="assets/logo_inicio.gif" /></a>
		</div>
		<div class="div_inicio_derecha">
			<div class="div_inicio_usuario">
				<div class="div_text_user_logged"><a href="preferences.cfm" class="link_user_logged" title="Preferencias del usuario" lang="es">#getAuthUser()#</a></div>
				<div class="div_text_user_logged"><a href="logout.cfm" class="text_user_logged" title="Salir" lang="es"><i class="icon-signout"></i> <span lang="es">Salir</span></a></div>
			</div>
		</div>
	</cfif>
</div>


<div style="clear:both">

	<ul class="nav nav-list">
	
		<li><a href="area.cfm"><img src="assets/icons_#APPLICATION.identifier#/organization.png" alt="Organización" title="Organización" lang="es"/>&nbsp;&nbsp;<cfif APPLICATION.identifier EQ "vpnet">Acceso a los grupos de trabajo<cfelse><span lang="es">Árbol</span><!---Organización---></cfif></a></li>
		
		<!---<li><a href="my_files.cfm"><img src="assets/icons/my_files.png" alt="Mis documentos" title="Mis documentos"/>&nbsp;&nbsp;Mis documentos</a></li>--->
		
		<li><a href="preferences.cfm"><img src="assets/icons/preferences.png" alt="Preferencias" title="Preferencias" lang="es"/>&nbsp;&nbsp;<span lang="es">Preferencias</span></a></li>
		
		<cfif APPLICATION.identifier NEQ "dp"><!---En DoPlanning se deshabilitan los contactos y los SMS--->
			<li><a href="contacts.cfm"><img src="assets/icons/contacts.png" alt="Contactos" title="Contactos"/>&nbsp;&nbsp;Contactos</a></li>
			
			<cfif objectUser.sms_allowed IS true>
			<li><a href="sms.cfm?return_page=#current_page#"><img src="assets/icons/sms.png" alt="SMS"/>&nbsp;&nbsp;SMS</a></li>
			</cfif>
	
		</cfif>
		
		<cfif APPLICATION.moduleMessenger EQ true>
		<li><a onClick="App.openMessenger('messenger_general.cfm')" style="cursor:pointer;"><img src="assets/icons_#APPLICATION.identifier#/messenger_general.png" alt="Messenger" title="Messenter general"/>&nbsp;&nbsp;Messenger general</a></li>
		
		<li><a onClick="App.openMessenger('messenger_private.cfm')" style="cursor:pointer;"><img src="assets/icons_#APPLICATION.identifier#/messenger_privado.gif" alt="Messenger" title="Messenger privado"/>&nbsp;&nbsp;Messenger privado</a></li>
		
		<li><a href="saved_conversations.cfm?return_page=#current_page#"><img src="assets/icons/saved_conversations.png" alt="Conversaciones guardadas" title="Conversaciones guardadas"/>&nbsp;&nbsp;Conversaciones guardadas</a></li>
		</cfif>
		
		<li><a href="messages_search.cfm?return_page=#current_page#"><img src="assets/icons/search.png" alt="Búsqueda" title="Buscar"/>&nbsp;&nbsp;<span lang="es">Buscar</span></a></li>

		<li><a href="search_areas.cfm?return_page=#current_page#"><img src="assets/icons/search.png" alt="Búsqueda" title="Buscar"/>&nbsp;&nbsp;<span lang="es">Buscar área</span></a></li>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="isMobileBrowser" returnvariable="isMobileBrowser">
		</cfinvoke>

		<cfif NOT isMobileBrowser><!--- Is not mobile version --->

				<li>
				<cfif objectUser.general_administrator EQ true>
					<a href="#APPLICATION.path#/#SESSION.client_id#/index.cfm?app=generalAdmin" target="_blank"><img src="assets/icons_#APPLICATION.identifier#/administration.png" alt="Administración general" title="Administración general" style="margin-right:3px;" lang="es"/>&nbsp;&nbsp;<span lang="es">Administración</span></a>
				<cfelse>
					<cfxml variable="areasAdminXml">
						#objectUser.areas_administration#
					</cfxml>
					<cfif isDefined("areasAdminXml.areas_administration.area")>
						<cfset nAreasAdmin = arrayLen(areasAdminXml.areas_administration.area)>
					<cfelse>
						<cfset nAreasAdmin = 0>
					</cfif>
					<cfif nAreasAdmin GT 0>
						<a href="#APPLICATION.path#/#SESSION.client_id#/index.cfm?app=areaAdmin" target="_blank"><img src="assets/icons_#APPLICATION.identifier#/administration.png" alt="Administración de áreas" title="Administración de áreas" style="margin-right:3px;" lang="es"/>&nbsp;&nbsp;<span lang="es">Administración de áreas</span></a>
					</cfif>
				</cfif>
				</li>

		</cfif>
		
		<!---<li><a href="incidences.cfm?return_page=#current_page#"><img src="assets/icons/incidence.png" alt="Incidencias" title="Incidencias"/>&nbsp;&nbsp;Incidencias<cfif APPLICATION.identifier EQ "dp"> y sugerencias</cfif></a></li>--->
		
	</ul>
	
</div>


<!---<div class="div_menu_inicio">
	
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="area.cfm"><img src="assets/icons_#APPLICATION.identifier#/organization.png" alt="Organización"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="area.cfm"><cfif APPLICATION.identifier EQ "vpnet">Acceso a los grupos de trabajo<cfelse>Organización</cfif></a>
	<!---<div style="margin-top:10px; margin-left:38px;"><a class="a_row_menu_inicio" href="area.cfm" style="font-size:12px;"><cfif APPLICATION.identifier EQ "vpnet">Versión móvil<cfelse>Versión móvil</cfif></a></div>---></div></div>
	
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="my_files.cfm"><img src="assets/icons/my_files.png" alt="Mis documentos" title="Mis documentos"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="my_files.cfm">Mis documentos</a></div></div>
	
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="preferences.cfm"><img src="assets/icons/preferences.png" alt="Preferencias" title="Preferencias"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="preferences.cfm">Preferencias</a></div></div>

	<cfif APPLICATION.identifier NEQ "dp"><!---En DoPlanning se deshabilitan los contactos y los SMS--->
		<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="contacts.cfm"><img src="assets/icons/contacts.png" alt="Contactos" title="Contactos"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="contacts.cfm">Contactos</a></div></div>
		
		<cfif objectUser.sms_allowed IS true>
		<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="sms.cfm?return_page=#current_page#"><img src="assets/icons/sms.png" alt="SMS"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="sms.cfm?return_page=#current_page#">SMS</a></div></div>
		</cfif>
	</cfif>
	
	<!---<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="notifications.cfm?return_page=#current_page#"><img src="assets/icons_#APPLICATION.identifier#/notifications.gif" alt="Notificaciones" title="Notificaciones"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="notifications.cfm?return_page=#current_page#">Notificaciones</a></div></div>--->
	
	<cfif APPLICATION.moduleMessenger EQ true>
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a onClick="App.openMessenger('messenger_general.cfm')" target="_blank"><img src="assets/icons_#APPLICATION.identifier#/messenger_general.png" alt="Messenger" title="Messenter general"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" onClick="App.openMessenger('messenger_general.cfm')" style="cursor:pointer;">Messenger general</a></div></div>
	
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a onClick="App.openMessenger('messenger_private.cfm')"><img src="assets/icons_#APPLICATION.identifier#/messenger_privado.gif" alt="Messenger" title="Messenger privado"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" onClick="App.openMessenger('messenger_private.cfm')" style="cursor:pointer;">Messenger privado</a></div></div>
	
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="saved_conversations.cfm?return_page=#current_page#"><img src="assets/icons/saved_conversations.png" alt="Conversaciones guardadas" title="Conversaciones guardadas"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="saved_conversations.cfm?return_page=#current_page#">Conversaciones guardadas</a></div></div>
	</cfif>
	
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="search.cfm?return_page=#current_page#"><img src="assets/icons/search.png" alt="Búsquedas" title="Buscar"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="search.cfm?return_page=#current_page#">Buscar</a></div></div>
	
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="incidences.cfm?return_page=#current_page#"><img src="assets/icons/incidence.png" alt="Incidencias" title="Incidencias"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="incidences.cfm?return_page=#current_page#">Incidencias<cfif APPLICATION.identifier EQ "dp"> y sugerencias</cfif></a></div></div>
	
	<!---<cfif SESSION.client_administrator EQ SESSION.user_id>
	Esto quitado porque no tiene mucha utilidad
	<div class="div_row_menu_inicio"><div class="div_img_row_menu_inicio"><a href="logs.cfm?return_page=#current_page#"><img src="assets/icons_#APPLICATION.identifier#/logs.gif" alt="Logs"/></a></div><div class="div_text_row_menu_inicio"><a class="a_row_menu_inicio" href="logs.cfm?return_page=#current_page#">Intentos de login fallidos</a></div></div>
	
	</cfif>--->
	
</div>--->

<div style="float:right;font-size:12px;">
	<cfset page_language = SESSION.user_language>
	<cfif page_language EQ "es">
		<a href="language_selection.cfm?lan=en&rpage=#CGI.SCRIPT_NAME#" onClick="window.lang.change('en');" style="font-size:12px">Inglés</a>
	<cfelse>
		<a href="language_selection.cfm?lan=es&rpage=#CGI.SCRIPT_NAME#" onClick="window.lang.change('es');" style="font-size:12px">Español</a>
	</cfif>
	<span style="font-size:12px;">&nbsp;|&nbsp;</span>
	<cfif APPLICATION.identifier EQ "vpnet">
	<a href="organization.cfm" style="font-size:12px; color:##333333;" lang="es">Versión estándar</a>
	<cfelse>
	<a href="main.cfm" style="font-size:12px;" lang="es">Versión estándar</a>
	</cfif>
	<!---<span style="font-size:12px; color:##FFFFFF;">&nbsp;|&nbsp;</span>
	<a href="#APPLICATION.path#/#SESSION.client_abb#/index.cfm" style="font-size:12px; color:##333333;">Versión Flash</a>--->
</div>
</cfoutput>
<div class="msg_div_error" id="errorMessage"></div>

<!---Download File--->
<cfinclude template="#APPLICATION.htmlPath#/includes/open_download_file.cfm">
<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
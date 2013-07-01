<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es">
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2012 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<!---<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />--->
<cfoutput>
<title>#APPLICATION.title#<cfif isDefined("SESSION.client_name")> - #SESSION.client_name#</cfif></title>
</cfoutput>
<cfif APPLICATION.identifier EQ "vpnet">
	<!---Esto solo debe mantenerse para la versión vpnet (por el Messenger)--->
	<script type="text/javascript" src="../SpryAssets/includes/xpath.js"></script>
	<script type="text/javascript" src="../SpryAssets/includes/SpryData.js"></script>
	<script type="text/javascript" src="../SpryAssets/includes/SpryXML.js"></script>
	<script type="text/javascript" src="../SpryAssets/includes/SpryDOMUtils.js"></script>
	<cfif APPLICATION.moduleMessenger EQ true>
		<script type="text/javascript" src="../app/scripts/App.js"></script>
		<script type="text/javascript" src="Scripts/MessengerControl.js"></script>
	</cfif>
	
</cfif>
<script type="text/javascript" src="Scripts/functions.min.js"></script>
<link href="styles.min.css" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "dp">
<link href="styles_dp.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<!---<!--using caps S (Screen), Pocket IE ignores it. Windows Mobile 6.1 ignores media="handled"-->  
<link href="styles_screen.css" rel="stylesheet" type="text/css" media="Screen" />
<link href="styles_mobiles.css" rel="stylesheet" type="text/css" media="handheld" />
<link href="styles_iphone.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 480px)" />--->

<cfoutput>
<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js"></script>
</cfoutput>

<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	<cfset area_id = URL.area>
	
	<cfinclude template="#APPLICATION.htmlPath#/includes/url_redirect.cfm">
	
	<cfif isDefined("redirect_page")>
		<cfset iframe_page = redirect_page>
	<cfelse>
		<cfset iframe_page = "">
	</cfif>
<cfelse>
	<cfset area_id = "null">
	
	<cfset iframe_page = "">
</cfif>

<script type="text/javascript">
	<cfoutput>
	var applicationPath = "#APPLICATION.path#";
	var applicationId = "#APPLICATION.identifier#";
	var selectAreaId = "#area_id#";
	var iframePage = "#iframe_page#";
	
	<!---Si se cambian estos valores, también hay que cambiarlos en los CSS--->
	<cfif APPLICATION.identifier EQ "vpnet">
		var treeDefaultWidth = "43%";
		var areaDefaultWidth = "56%";
	<cfelse>
		var treeDefaultWidth = "28%";
		var areaDefaultWidth = "71%";
	</cfif>
	
	</cfoutput>
</script>

<script type="text/javascript" src="Scripts/tree.min.js"></script>
<script type="text/javascript" src="Scripts/organization.js"></script>

<script type="text/javascript">
	
	function resizeIframe() {
		var newHeight = windowHeight();
		$(".iframes").height(newHeight);
		$("#treeContainer").height(newHeight);
	}
	
	function windowHeight() {
		var de = document.documentElement;
		return de.clientHeight-150; //92
		/*return document.body.clientHeight;*/
	}	
	
	/*$("#areaIframe").load(function (){
		areaIframeLoaded()
	});*/
	
	$(window).resize( function() {
		resizeIframe();
	} );
	$(window).load( function() {		
		resizeIframe();
		loadTree(selectAreaId);
		
		<cfif APPLICATION.moduleMessenger EQ true AND isDefined("SESSION.user_id")>
		Messenger.Private.initGetNewConversations();
		</cfif>
		
		$("#maximizeTree").click( function() {
			maximizeTree();
		} );
		
		$("#restoreTree").click( function() {
			restoreTree();
		} );
		
		$("#maximizeArea").click( function() {
			maximizeArea();
		} );
		
		$("#restoreArea").click( function() {
			restoreArea();
		} );
		
	} );
	
</script>
</head>

<body class="body_tree">
 
<cfoutput>
<div style="vertical-align:middle; height:60px; margin-bottom:2px;">
	<div style="float:left">
		<a id="areaImageAnchor" onClick="goToAreaLink()">
		<cfif isNumeric(area_id)>
			<img src="#APPLICATION.resourcesPath#/downloadAreaImage.cfm?id=#area_id#" id="areaImage" alt="Imagen del área" />
		<cfelse>
			<img src="#APPLICATION.resourcesPath#/#APPLICATION.identifier#_banner.png" id="areaImage" alt="Imagen del área" />
		</cfif>
		</a>
	</div>
	
	<!---<div style="float:right;">
	</div>--->
	
	<cfif APPLICATION.identifier EQ "dp">
		<div style="float:right; padding-top:18px;"><a href="http://www.doplanning.net/" target="_blank"><img src="assets/logo_doplanning.png" alt="DoPlanning" title="DoPlanning"/></a></div>
	<cfelseif APPLICATION.identifier EQ "vpnet">
		<div style="float:right; vertical-align:middle; text-align:center; margin-top:8px;">
			<div class="button_web"><a href="../intranet/" target="_blank"><img src="assets/icons_vpnet/intranet_small.png" alt="Intranet" style="margin-right:2px; vertical-align:middle" /></a><a href="../intranet/" target="_blank" class="link_web">Intranet</a></div>
			<div class="button_web" style="padding-left:2px; padding-right:2px; margin-top:1px;"><a href="../web/" target="_blank"><img src="assets/icons_vpnet/web_publica_small.png" alt="Web pública" style="margin-right:2px; vertical-align:middle" /></a><a href="../web/" target="_blank" class="link_web">Web pública</a></div>
		</div>	
	</cfif>
</div>
</cfoutput>

<div class="div_contenedor_contenido">

<cfoutput>
  	
	<cfset current_page = "organization.cfm">
	
	<!---Obtiene el usuario logeado--->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
		<cfinvokeargument name="user_id" value="#SESSION.user_id#">
		<cfinvokeargument name="format_content" value="all">
	</cfinvoke>
	
 	<div class="menu_bar">
		<div style="float:left; clear:none;">
		<a href="my_files.cfm"><img src="assets/icons/my_files.png" alt="Mis documentos" title="Mis documentos"/></a>
		<cfif APPLICATION.identifier EQ "dp">
		<a href="all_messages.cfm"><img src="assets/icons/messages.png" alt="Mensajes" title="Todos los mensajes"/></a>
		<a href="all_events.cfm"><img src="assets/icons/events.png" alt="Eventos" title="Todos los eventos"/></a>
		<a href="all_tasks.cfm"><img src="assets/icons/tasks.png" alt="Tareas" title="Todas las tareas"/></a>
			<cfif APPLICATION.moduleWeb EQ true>
			<a href="all_entries.cfm"><img src="assets/icons/entries.png" alt="Entradas" title="Todas las entradas"/></a>
			<a href="all_newss.cfm"><img src="assets/icons/news.png" alt="Noticias" title="Todas las noticias"/></a>
			<!---<a href="all_links.cfm"><img src="assets/icons/links.png" alt="Links" title="Links"/></a>--->
			</cfif>
		</cfif>
		
		<a href="preferences.cfm"><img src="assets/icons/preferences.png" alt="Preferencias" title="Preferencias"/></a>
		
		<cfif APPLICATION.identifier NEQ "dp"><!---En DoPlanning se deshabilitan los contactos y los SMS--->
			<a href="contacts.cfm"><img src="assets/icons/contacts.png" alt="Contactos" title="Contactos" /></a>
			
			<cfif objectUser.sms_allowed IS true>
			<a href="sms.cfm?return_page=#current_page#"><img src="assets/icons/sms.png" alt="SMS" title="Enviar SMS"/></a>
			</cfif>		
		</cfif>
		
		<!---<a href="notifications.cfm?return_page=#current_page#"><img src="assets/icons_#APPLICATION.identifier#/notifications.gif" alt="Notificaciones" title="Notificaciones"/></a>--->				
		<a href="search.cfm?return_page=#current_page#"><img src="assets/icons/search.png" alt="Búsquedas" title="Buscar"/></a>
		
		<a href="incidences.cfm?return_page=#current_page#"><img src="assets/icons/incidence.png" alt="Incidencias" title="Incidencias"/></a>
		
		
		<cfif APPLICATION.moduleMessenger EQ true>
		<a onClick="App.openMessenger('messenger_general.cfm')" target="_blank" style="cursor:pointer"><img src="assets/icons_#APPLICATION.identifier#/messenger_general.png" alt="Messenger" title="Messenter general" style="margin-left:2px;"/></a>
		<a onClick="App.openMessenger('messenger_private.cfm')" style="cursor:pointer"><img src="assets/icons_#APPLICATION.identifier#/messenger_private.png" alt="Messenger" title="Messenger privado" style="margin-left:1px;"/></a>
		<a href="saved_conversations.cfm?return_page=#current_page#"><img src="assets/icons/saved_conversations.png" alt="Conversaciones guardadas" title="Conversaciones guardadas" /></a>
		</cfif>
		
		<cfif objectUser.general_administrator EQ true>
			<a href="#APPLICATION.path#/#SESSION.client_id#/index.cfm?app=generalAdmin" target="_blank"><img src="assets/icons_#APPLICATION.identifier#/administration.png" alt="Administración general" title="Administración general" style="margin-left:2px;"/></a>
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
				<a href="#APPLICATION.path#/#SESSION.client_id#/index.cfm?app=areaAdmin" target="_blank"><img src="assets/icons_#APPLICATION.identifier#/administration.png" alt="Administración de áreas" title="Administración de áreas" style="margin-left:2px;"/></a>
			</cfif>
		</cfif>
		</div>
		
		<div style="float:right; text-align:right; clear:none;">
			<a href="preferences.cfm" title="Preferencias del usuario" class="link_user_logged">#objectUser.family_name# #objectUser.name# (#getAuthUser()#)</a><br/>
			<a href="logout.cfm" title="Cerrar sesión" class="link_user_logout">Salir</a>
		</div>
		
		<cfif APPLICATION.identifier NEQ "vpnet">
			<div style="float:right; padding-top:1px; padding-right:6px;">
				<a href="preferences.cfm" title="Preferencias del usuario">
				<cfif len(objectUser.image_file) GT 0>
					<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.image_file#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" />
				<cfelse>
					<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" />
				</cfif>
				</a>
			</div>
		</cfif>
		
	</div>
  
	<cfinclude template="#APPLICATION.htmlPath#/includes/loading_div.cfm">
	</cfoutput>
	
	<div id="mainContainer">
		<!---treeContainer--->
		<div id="treeWrapper">
			<cfoutput>
			<div style="cursor:pointer;float:right;clear:both;">
			<img src="#APPLICATION.htmlPath#/assets/icons/maximize.png" title="Maximizar Árbol" id="maximizeTree" />
			<img src="#APPLICATION.htmlPath#/assets/icons/restore.png" title="Restaurar Árbol" id="restoreTree" style="display:none;"/>
			</div>
			</cfoutput>
			<div id="treeContainer" style="overflow:auto;clear:both;"></div>			
		</div>
		<!---areaContainer--->
		<div id="areaContainer">
			<cfoutput>
			<div style="cursor:pointer;float:right;">
			<img src="#APPLICATION.htmlPath#/assets/icons/maximize.png" title="Maximizar" id="maximizeArea" />
			<img src="#APPLICATION.htmlPath#/assets/icons/restore.png" title="Restaurar" id="restoreArea" style="display:none;"/>
			</div>
			</cfoutput>
			<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframes" src="iframes/area.cfm" style="height:100%;background-color:#FFFFFF;clear:none;" id="areaIframe" onload="areaIframeLoaded()"></iframe>
		</div>
		<div style="clear:both"><!-- --></div>
		<!---foot--->
		<div>
			<img src="assets/icons/refresh_small.png" alt="Actualizar contenido" title="Actualizar contenido" style="float:left; margin-top:1px; margin-right:2px; cursor:pointer;" onClick="updateTree();" /><a onClick="updateTree();" class="link_bottom_small" style="float:left; cursor:pointer;">Actualizar contenido</a>
		</div>
		<div style="float:right; padding:0; margin:0; font-size:12px;">
			<a href="mobile.cfm" class="link_bottom_small">Versión móvil</a>
			<span style="font-size:12px; color:#FFFFFF;">&nbsp;|&nbsp;</span>
			<cfoutput>
			<a href="#APPLICATION.path#/#SESSION.client_id#/index.cfm?app=flash" class="link_bottom_small">Versión Flash</a>
			</cfoutput>
		</div>
	</div>
	
	<div style="clear:both"><!-- --></div>
	<div class="msg_div_error" id="errorMessage"></div>

</div>

<!---Download File--->
<cfinclude template="#APPLICATION.htmlPath#/includes/open_download_file.cfm">

</body>
</html>
</cfprocessingdirective>
	
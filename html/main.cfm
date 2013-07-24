<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>

<!---Obtiene el usuario logeado--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	<cfinvokeargument name="format_content" value="all">
</cfinvoke>

<html lang="es">
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2013 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<cfoutput>

<title>#APPLICATION.title#<cfif isDefined("SESSION.client_name")> - #SESSION.client_name#</cfif></title>

<cfif APPLICATION.identifier EQ "dp">
<link href="#APPLICATION.htmlPath#/assets/favicon.ico" rel="shortcut icon" type="image/x-icon"> 
</cfif>

<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">

<cfif APPLICATION.identifier EQ "dp">
<link rel="stylesheet" type="text/css" media="all" href="#APPLICATION.htmlPath#/styles/styles_dp2.min.css"/>
<cfelse>
<link rel="stylesheet" type="text/css" media="all" href="#APPLICATION.htmlPath#/styles/styles_vpnet.css"/>
</cfif>
<!--- <link rel="stylesheet" type="text/css" href="../jquery/jstree/themes/dp/style.css"/> --->

<cfif APPLICATION.identifier EQ "vpnet">
	<!---Esto solo debe mantenerse para la versión vpnet (por el Messenger)--->
	<script type="text/javascript" src="../SpryAssets/includes/xpath.js"></script>
	<script type="text/javascript" src="../SpryAssets/includes/SpryData.js"></script>
	<script type="text/javascript" src="../SpryAssets/includes/SpryXML.js"></script>
	<script type="text/javascript" src="../SpryAssets/includes/SpryDOMUtils.js"></script>
	<cfif APPLICATION.moduleMessenger EQ true>
		<script type="text/javascript" src="../app/scripts/App.js"></script>
		<script type="text/javascript" src="scripts/MessengerControl.js"></script>
	</cfif>
</cfif>

<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js"></script>

<script type="text/javascript" src="#APPLICATION.bootstrapJSPath#"></script>

<script type="text/javascript" src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.js" charset="utf-8" ></script>
<script src="#APPLICATION.htmlPath#/language/main_en.js" charset="utf-8" type="text/javascript"></script>

</cfoutput>

<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	<cfset area_id = URL.area>
	
	<cfinclude template="#APPLICATION.htmlPath#/includes/url_redirect.cfm">
	
	<cfif isDefined("redirect_page")>
		<cfset iframe_page = redirect_area_page>
	<cfelse>
		<cfset iframe_page = "">
	</cfif>
<cfelse>
	<cfset area_id = "null">
	
	<cfset iframe_page = "">
</cfif>

<script type="text/javascript">
	<cfoutput>
	<!--- var applicationPath = "#APPLICATION.path#"; --->
	var applicationId = "#APPLICATION.identifier#";
	var selectAreaId = "#area_id#";
	var iframePage = "#iframe_page#";
	var userLanguage = "#objectUser.language#";
	
	var areaImgHeight = 60;
	
	<!---Si se cambian estos valores, también hay que cambiarlos en los CSS--->
	var treeDefaultWidth = "99%";
	var areaDefaultWidth = "99%";
	
	//Language
	var selectedLanguage = 'es';
	jquery_lang_js.prototype.defaultLang = 'es';
	jquery_lang_js.prototype.currentLang = 'es';
	window.lang = new jquery_lang_js();
	</cfoutput>
	
</script>

<cfoutput>
<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/functions.min.js"></script>
<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/tree.min.js?v=2.1"></script>
<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/main.min.js?v=2.2"></script>
</cfoutput>

<script type="text/javascript">
	
	function resizeIframe() {
		var newHeight = windowHeight()-56;
		$(".iframes").height(newHeight);
		
		$("#itemIframe").height(newHeight-areaImgHeight);
		$("#searchItemIframe").height(newHeight);
		$("#treeContainer").height(newHeight-47);
	}
	
	function changeLanguage() {
		
		if(selectedLanguage == 'en')
			newLanguage = 'es';
		else
			newLanguage = 'en';
		
		window.lang.change(newLanguage);
		
		location.href = "language_selection.cfm?lan="+newLanguage;
	
	}

	function treeLoaded() {

		if ( !isNaN(selectAreaId) ) { //Hay área para seleccionar

			selectTreeNode(selectAreaId);
			
		}else if( isNaN(selectAreaId) ) { //No hay area para seleccionar

			emptyIframes();
		}

		$("#loadingContainer").hide();
		$("#treeContainer").css('visibility', 'visible');

		if($("#mainContainer").is(":hidden"))
			$("#mainContainer").show();
	}
	
	function searchIframeLoaded() {

		if($("#searchIframe").attr('src') != "about:blank" && $("#loadingContainer").css('display') == "block"){
			$("#loadingContainer").hide();
			<!---$("#mainContainer").show();--->
		}
			
	}

	function loadAreaImage(areaId) {

		if(applicationId != "vpnet") { //Esto solo está habilitado para DP ya que en la otra versión no se utiliza y carga la aplicación
			$("#areaImage").attr('src', "../app/downloadAreaImage.cfm?id="+areaId);
		}

	}

	function goToAreaLink() {
		
		if(areaWithLink == true) {
			window.open("../app/goToAreaLink.cfm?id="+curAreaId, "_blank");
		}
		
	}


	function emptyIframes(){

		$("#areaIframe").attr('src', 'iframes/area.cfm');
		$("#itemIframe").attr('src', 'about:blank');
		
	}

	
	$(window).resize( function() {
		resizeIframe();
	});
	
	$(window).load( function() {		
		resizeIframe();
		loadTree(selectAreaId);
		
		<cfif APPLICATION.moduleMessenger EQ true AND isDefined("SESSION.user_id")>
		Messenger.Private.initGetNewConversations();
		</cfif>
		
		<!---/*$("#maximizeTree").click( function() {
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
		} );*/--->
				
		$("#areaImage").load( function () {
			areaImgHeight = $("#areaImage").height();			
			resizeIframe();	
		});

		$('#dpTab a').click( function (e) {
			if(e.preventDefault)
		  		e.preventDefault();
			
		  	$(this).tab('show');
			
		});
		
		$('a[data-toggle="tab"]').on('shown', function (e) { //On show tab
			
			var pattern=/#.+/gi //use regex to get anchor(==selector)
			currentTab = e.target.toString().match(pattern)[0];

			if(currentTab == "#tab3" && $("#searchIframe").attr('src') == "about:blank") { //Load search page
				$("#searchIframe").attr('src', 'iframes/messages_search.cfm');
				$("#loadingContainer").show();
				<!---$("#mainContainer").hide();--->
			}

		})
		
		
		$("#searchText").on("keydown", function(e) { 
		
			if(e.which == 13) //Enter key
				searchTextInTree();
			
		});
		
	});
	
	$(document).ready(function () {
		//Language
   		window.lang.run();
		
		selectedLanguage = localStorage.getItem('langJs_currentLang');

		if(userLanguage != selectedLanguage)
			window.lang.change(userLanguage);
		
		if(selectedLanguage == 'en')
			$('#languageSelector').text('Español');
		else
			$('#languageSelector').text('English');
						
	});
	
</script>
</head>

<body class="body_tree">			

<!--- Loading --->
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_div.cfm">

<div class="div_contenedor_contenido">
  	
	<!---<cfset current_page = "main.cfm">--->
	
	<div id="mainContainer">
	
		
		<div class="tabbable"><!---Tab Panel--->
	
		  <ul class="nav nav-pills" id="dpTab" style="margin-bottom:0px; clear:none;">
			<li class="active"><a href="#tab1" data-toggle="tab" lang="es">Árbol</a></li>
			<li><a href="#tab2" data-toggle="tab" lang="es">Área</a></li>
			<li><a href="#tab3" data-toggle="tab" lang="es">Búsqueda</a></li>
		  </ul>
		  
		  <cfoutput>
		  <div style="float:right; clear:none;">
		  
		  	<div style="float:right; text-align:right; clear:none;">
				<a href="preferences.cfm" title="Preferencias del usuario" class="link_user_logged" lang="es">#objectUser.family_name# #objectUser.name# (#getAuthUser()#)</a><br/>
				
				<a href="logout.cfm" title="Cerrar sesión" class="link_user_logout" lang="es"><i class="icon-signout"></i> <span lang="es">Salir</span></a>
	
			</div>
			
			<cfif APPLICATION.identifier NEQ "vpnet">
				<div style="float:right; padding-top:1px; padding-right:6px; width:80px; text-align:right;">
					
					<cfif objectUser.general_administrator EQ true>
						<a href="#APPLICATION.path#/#SESSION.client_id#/index.cfm?app=generalAdmin"><img src="assets/icons_#APPLICATION.identifier#/administration.png" alt="Administración general" title="Administración general" style="margin-right:3px;" lang="es"/></a>
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
							<a href="#APPLICATION.path#/#SESSION.client_id#/index.cfm?app=areaAdmin"><img src="assets/icons_#APPLICATION.identifier#/administration.png" alt="Administración de áreas" title="Administración de áreas" style="margin-right:3px;" lang="es"/></a>
						</cfif>
					</cfif>
				
					<a href="preferences.cfm" title="Preferencias del usuario" lang="es">
					<cfif len(objectUser.image_file) GT 0>
						<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.image_file#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" />
					<cfelse>
						<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" />
					</cfif>
					</a>
				</div>
			</cfif>
		  
		  </div>
		  </cfoutput>
		  
		  <div class="tab-content" style="clear:both;">
		  
		  
			<div class="tab-pane active" id="tab1"><!---Tab Tree--->
				
				<div class="form-inline" style="padding-bottom:5px;">
										
					<div class="input-append">
						<input type="text" name="text" id="searchText" value="" class="input-medium" on/>
						<button onClick="searchTextInTree()" class="btn" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search"></i> <span lang="es">Buscar</span></button>
					</div>					
					
					<a onClick="updateTree();" class="btn" title="Actualizar" lang="es"><i class="icon-refresh"></i> <span lang="es">Actualizar</span></a>
					<a onClick="expandTree();" class="btn" title="Expandir todo el árbol" lang="es"><i class="icon-plus"></i> <span lang="es">Expandir</span></a>
					<a onClick="collapseTree();" class="btn" title="Colapsar todo el árbol" lang="es"><i class="icon-minus"></i> <span lang="es">Colapsar</span></a>

					<input type="hidden" id="changeTabDisabled" value="true"/><!---No cambiar de pestaña al seleccionar área--->
					
					<!---<a onclick="expandTree();" class="btn btn-mini" title="Abrir nodos del árbol"><i class="icon-plus"></i> Expandir</a>
					<a onclick="collapseTree();" class="btn btn-mini" title="Abrir nodos del árbol"><i class="icon-minus"></i> Colapsar</a>--->


					<cfif objectUser.general_administrator EQ true>
						<!---<a href="#APPLICATION.path#/#SESSION.client_id#/index.cfm?app=generalAdmin"><img src="assets/icons_#APPLICATION.identifier#/administration.png" alt="Administración general" title="Administración general" style="margin-right:3px;" lang="es"/></a>--->

						<a href="admin/" class="btn btn-info" style="float:right" title="Administración general"><i class="icon-wrench"></i> <span lang="es"></span></a>
					<cfelse>
						<!--- PROVISIONAL MIENTRAS ESTÉ EL ICONO TAMBIÉN ANTES
						<cfxml variable="areasAdminXml">
							#objectUser.areas_administration#
						</cfxml>
						<cfif isDefined("areasAdminXml.areas_administration.area")>
							<cfset nAreasAdmin = arrayLen(areasAdminXml.areas_administration.area)>
						<cfelse>
							<cfset nAreasAdmin = 0>
						</cfif> --->
						<cfif nAreasAdmin GT 0>
							<!---<a href="#APPLICATION.path#/#SESSION.client_id#/index.cfm?app=areaAdmin"><img src="assets/icons_#APPLICATION.identifier#/administration.png" alt="Administración de áreas" title="Administración de áreas" style="margin-right:3px;" lang="es"/></a>--->

							<a href="admin/" class="btn btn-info" style="float:right" title="Administración de áreas"><i class="icon-wrench"></i></a>
						</cfif>
					</cfif>

				</div>
				
				<!---treeContainer--->
				<div id="treeWrapper">
					<!---<cfoutput>
					<div style="cursor:pointer;float:right;clear:both;">
					<img src="#APPLICATION.htmlPath#/assets/icons/maximize.png" title="Maximizar Árbol" id="maximizeTree" />
					<img src="#APPLICATION.htmlPath#/assets/icons/restore.png" title="Restaurar Árbol" id="restoreTree" style="display:none;"/>
					</div>
					</cfoutput>--->
					
					<div id="treeContainer" style="overflow:auto;clear:both;"></div>			
				</div>
				
				<!---foot--->
				<div>				
					
					<div style="float:right; padding:0; margin:0;">
						
						<a onClick="changeLanguage()" id="languageSelector" style="font-size:12px;cursor:pointer;">Inglés</a>
						
						<span style="font-size:12px;">&nbsp;|&nbsp;</span>
						
						<a href="mobile.cfm" style="font-size:12px" lang="es">Versión móvil</a>
						<!---<span style="font-size:12px;">&nbsp;|&nbsp;</span>
						<cfoutput>
						<a href="#APPLICATION.path#/#SESSION.client_id#/index.cfm?app=flash" style="font-size:12px">Versión Flash</a>
						</cfoutput>--->
					</div>
					
				</div>
				
			</div><!---END Tab Tree--->
			
			
			<div class="tab-pane" id="tab2"><!---Tab Area--->
				
				<!---areaContainer--->
				<div id="areaContainer">
									
					<!---<cfoutput>
					<div style="cursor:pointer;float:right;">
					<img src="#APPLICATION.htmlPath#/assets/icons/maximize.png" title="Maximizar" id="maximizeArea" />
					<img src="#APPLICATION.htmlPath#/assets/icons/restore.png" title="Restaurar" id="restoreArea" style="display:none;"/>
					</div>
					</cfoutput>--->
					
					<div id="itemsContainer"><!---Items--->
					
						<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframes" src="about:blank" style="height:100%;background-color:#FFFFFF;" id="areaIframe" onload="areaIframeLoaded()"></iframe><!---iframes/area.cfm--->
					
					</div>
					
					<div id="itemContainer"><!---Item--->
					
						<a id="areaImageAnchor" onClick="goToAreaLink()"><!---Banner--->
						<cfoutput>
							<cfif isNumeric(area_id)>
								<img src="#APPLICATION.resourcesPath#/downloadAreaImage.cfm?id=#area_id#" id="areaImage" alt="Imagen del área" />
							<cfelse>
								<img src="#APPLICATION.resourcesPath#/#APPLICATION.identifier#_banner.png" id="areaImage" alt="Imagen del área" />
							</cfif>
						</cfoutput>
						</a>
						
						<!---Item--->
						<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframeItem" src="about:blank" style="height:100%;background-color:#FFFFFF;" id="itemIframe"></iframe>
						<!---iframes2/empty.cfm--->
						
					</div>
					
					
				</div>
				
			</div><!---END Tab Area--->
			
			
			<div class="tab-pane" id="tab3"><!---Tab Search--->
				
				<!---searchContainer--->
				<div id="searchContainer">
					
					
					<div id="searchItemsContainer"><!---Items Search--->
						
						<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframes" src="about:blank" style="height:100%;background-color:#FFFFFF;" id="searchIframe" onload="searchIframeLoaded()"></iframe><!---iframes/messages_search.cfm--->
					
					</div>
					
					<div id="searchItemContainer"><!---Item Search--->
					
						<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="searchItem" src="about:blank" style="height:100%;background-color:#FFFFFF;" id="searchItemIframe" ></iframe><!---iframes2/empty.cfm"--->
						
					</div>
					
				
				</div>
				
			</div><!---END Tab Search--->
						
			
		  </div>
		  
		</div><!---END TabPanel--->
	
		
		<div style="clear:both"><!-- --></div>
		
	</div>
	
	<div style="clear:both"><!-- --></div>
	<div class="msg_div_error" id="errorMessage"></div>

</div>

<!---Download File--->
<cfinclude template="#APPLICATION.htmlPath#/includes/open_download_file.cfm">

</body>
</html>
</cfprocessingdirective>
	
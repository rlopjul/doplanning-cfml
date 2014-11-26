<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>

<!---Obtiene el usuario logeado--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	<cfinvokeargument name="format_content" value="all">
	<cfinvokeargument name="return_type" value="object">
</cfinvoke>

<html lang="es">
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2014 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<cfoutput>

<title>#APPLICATION.title#<cfif isDefined("SESSION.client_name")> - #SESSION.client_name#</cfif></title>

<cfif APPLICATION.identifier EQ "dp">
<link href="#APPLICATION.htmlPath#/assets/favicon.ico" rel="shortcut icon" type="image/x-icon"> 
</cfif>

<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">
<cfif len(APPLICATION.themeCSSPath) GT 0>
<link href="#APPLICATION.themeCSSPath#" rel="stylesheet">
</cfif>
<!---
Parece que cargando los scrips de CDN con HTPPS hace que aparezca un mensaje de alerta/error de seguridad en IE8, pero no es seguro 100%--->
<!---
<script src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.2/html5shiv.min.js"></script>
--->
<!--[if lt IE 9]>
	<script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <link href="//netdna.bootstrapcdn.com/respond-proxy.html" id="respond-proxy" rel="respond-proxy" />
    <link href="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.gif" id="respond-redirect" rel="respond-redirect" />
    <script src="//oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <script src="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.js"></script>
<![endif]-->

<cfif APPLICATION.identifier EQ "dp">
<link rel="stylesheet" media="all" href="#APPLICATION.htmlPath#/styles/styles_dp2.min.css"/>
<cfelse>
<link rel="stylesheet" media="all" href="#APPLICATION.htmlPath#/styles/styles_vpnet.css"/>
</cfif>

<link href="#APPLICATION.path#/jquery/jstree/themes/dp/style.min.css?v=3.0" rel="stylesheet" />

<cfif APPLICATION.identifier EQ "vpnet">
	<!---Esto solo debe mantenerse para la versión vpnet (por el Messenger)--->
	<script src="../SpryAssets/includes/xpath.js"></script>
	<script src="../SpryAssets/includes/SpryData.js"></script>
	<script src="../SpryAssets/includes/SpryXML.js"></script>
	<script src="../SpryAssets/includes/SpryDOMUtils.js"></script>
	<cfif APPLICATION.moduleMessenger EQ true>
		<script src="../app/scripts/App.js"></script>
		<script src="scripts/MessengerControl.js"></script>
	</cfif>
</cfif>

<script src="#APPLICATION.jqueryJSPath#"></script>
<script src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js?v=3.0"></script>

<script src="#APPLICATION.bootstrapJSPath#"></script>

<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.min.js" charset="utf-8" ></script>
<script src="#APPLICATION.htmlPath#/language/main_en.js?v=1.2" charset="utf-8"></script>

<script src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js?v=4.4.4.4"></script>
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

<script>
	<cfoutput>
	var applicationId = "#APPLICATION.identifier#";
	var selectAreaId = "#area_id#";
	var iframePage = "#iframe_page#";
	var userLanguage = "#objectUser.language#";
	var clientAbb = "#SESSION.client_abb#";
	
	var areaImgHeight = 60;
	
	<!---Si se cambian estos valores, también hay que cambiarlos en los CSS--->
	var treeDefaultWidth = "99%";
	var areaDefaultWidth = "99%";
	
	//Language
	var selectedLanguage = 'es';
	<!---jquery_lang_js.prototype.defaultLang = 'es';
	jquery_lang_js.prototype.currentLang = 'es';
	window.lang = new jquery_lang_js();--->
	window.lang = new Lang('es');
	<!---window.lang.dynamic('en', '#APPLICATION.htmlPath#/language/main_en.json');--->
	</cfoutput>
	
</script>

<cfoutput>
<script src="#APPLICATION.htmlPath#/scripts/functions.min.js?v=2.3"></script>
<script src="#APPLICATION.htmlPath#/scripts/tree.min.js?v=3.1"></script>
<script src="#APPLICATION.htmlPath#/scripts/main.min.js?v=2.9"></script>
</cfoutput>

<script>

	<cfif APPLICATION.homeTab IS true>
		currentTab = "#tab0";
	</cfif>
	
	function resizeIframe() {
		var newHeight = windowHeight()-66;

		$(".iframes").height(newHeight);
		
		$("#itemIframe").height(newHeight-areaImgHeight);
		$("#searchItemIframe").height(newHeight);
		$("#treeContainer").height(newHeight-50);
		/*$("#lastItemsContainer").height(newHeight-87);
		$("#homeRightContainer").height(newHeight);*/
		$("#homeContainer").height(newHeight);

		//alert($("#lastItemsHead").height());
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

	function loadHome(){

		$("#loadingContainer").show();

		var limit = $("#limit").val();

		var noCacheNumber = Math.floor(Math.random()*1001);
		$("#homeContainer").load("html_content/home.cfm?limit="+limit+"&n="+noCacheNumber, function() {
			$("#loadingContainer").hide();
			resizeIframe();
		});
	}

	
	$(window).resize( function() {
		resizeIframe();
	});
	
	$(window).load( function() {	

		resizeIframe();

		<!---<cfif APPLICATION.homeTab IS true>
			loadHome();
		</cfif>--->

		<!---loadTree();--->
		showTree(true);	
		
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
		
		$('a[data-toggle="tab"]').on('show.bs.tab', function (e) { //On show tab
			
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
   		<!---window.lang.run();--->		
		var savedLanguage = selectedLanguage;

   		if(hasLocalStorage())
   			savedLanguage = localStorage.getItem('langJs_currentLang');
			<!---selectedLanguage = localStorage.getItem('langJs_currentLang');--->

		if(savedLanguage != selectedLanguage && userLanguage == savedLanguage){
			window.lang.change(userLanguage);
		}
			

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
	
		  <ul class="nav nav-pills" id="dpTab" style="clear:none;padding-bottom:5px;">
		  	<cfif APPLICATION.homeTab IS true>
		  		<li class="active"><a href="#tab0" data-toggle="tab" lang="es"><i class="icon-home"></i></a></li>
		  	</cfif>
			<li <cfif APPLICATION.homeTab IS false>class="active"</cfif>><a href="#tab1" data-toggle="tab" lang="es">Árbol</a></li>
			<li><a href="#tab2" data-toggle="tab" lang="es">Área</a></li>
			<li><a href="#tab3" data-toggle="tab" lang="es">Búsqueda</a></li>
		  </ul>
		  
		  <cfoutput>
		  <div style="clear:none; text-align:center"><!---float:right; --->

		  	<span class="main_title" style="font-weight:bold">#SESSION.client_name#</span>
		  
		  	<div style="float:right">

			  	<div style="float:right; text-align:right; clear:none;">
					<a href="preferences.cfm" title="Preferencias del usuario" class="link_user_logged">#objectUser.family_name# #objectUser.name# (#getAuthUser()#)</a><br/>
					
					<a href="logout.cfm" title="Cerrar sesión" class="link_user_logout" lang="es"><i class="icon-signout"></i> <span lang="es">Salir</span></a>
		
				</div>
				
				<cfif APPLICATION.identifier NEQ "vpnet">
					<div style="float:right; padding-top:1px; padding-right:6px; text-align:right;"><!---width:80px; --->
						
						<div class="btn-toolbar">
						
							<cfif objectUser.general_administrator EQ true>

								<div class="btn-group">
									<a href="admin/?abb=#SESSION.client_abb#" class="btn btn-primary btn-sm" title="Administración general nueva versión HTML" lang="es"><i class="icon-wrench"></i></a>
								</div>

								<cfif SESSION.client_abb EQ "hcs">
									<div class="btn-group">
										<a href="#APPLICATION.path#/#SESSION.client_id#/index.cfm?app=generalAdmin"><img src="assets/icons_#APPLICATION.identifier#/administration.png" alt="Administración general versión Flash" title="Administración general versión Flash" style="margin-right:3px;" lang="es"/></a>
									</div>
								</cfif>
								
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
									<!---<a href="#APPLICATION.path#/#SESSION.client_id#/index.cfm?app=areaAdmin"><img src="assets/icons_#APPLICATION.identifier#/administration.png" alt="Administración de áreas" title="Administración de áreas" style="margin-right:3px;" lang="es"/></a>--->
									<div class="btn-group">
										<a href="admin/?abb=#SESSION.client_abb#" class="btn btn-primary btn-sm" style="float:right" title="Administración de áreas" lang="es"><i class="icon-wrench"></i></a>
									</div>
								</cfif>
							</cfif>
						
							<div class="btn-group">
								<a href="preferences.cfm" title="Preferencias del usuario" lang="es">
								<cfif len(objectUser.image_file) GT 0>
									<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.image_file#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" />
								<cfelse>
									<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" />
								</cfif>
								</a>
							</div>

						</div>
					</div>
				</cfif>
			  
			  </div>
			  </cfoutput>

		  </div>
		  
		  <div class="tab-content" style="clear:both;">

		  	<cfif APPLICATION.homeTab IS true>
		  	<div class="tab-pane active" id="tab0"><!---Tab Home--->

		  		<!---homeContainer--->
				<div id="homeContainer" style="overflow:auto;">

					<cfinclude template="#APPLICATION.htmlPath#/includes/home_content.cfm">

				</div>

		  	</div>
		  	</cfif>
		  
			<div class="tab-pane <cfif APPLICATION.homeTab IS false>active</cfif>" id="tab1"><!---Tab Tree--->
				
				<div class="container" style="width:100%;">
					<div class="row" style="padding-bottom:5px;">
						
						<div class="col-sm-12" style="padding:0;">
							<div class="btn-toolbar">
								<div class="btn-group">
									<div class="input-group" style="width:260px;">
										<input type="text" name="text" id="searchText" value="" class="form-control" placeholder="Búsqueda de área" lang="es"/>
										<span class="input-group-btn">
											<button onClick="searchTextInTree()" class="btn btn-default" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search"></i> <span lang="es">Buscar</span></button>
										</span>
									</div>
								</div>
								<div class="btn-group">
									<a onClick="expandTree();" class="btn btn-default" title="Expandir todo el árbol" lang="es"><i class="icon-plus"></i> <span lang="es">Expandir</span></a>
									<a onClick="collapseTree();" class="btn btn-default" title="Colapsar todo el árbol" lang="es"><i class="icon-minus"></i> <span lang="es">Colapsar</span></a>
								</div>
								<div class="btn-group">
									<a onClick="updateTree();" class="btn btn-default" title="Actualizar" lang="es"><i class="icon-refresh"></i> <span lang="es">Actualizar</span></a>
								</div>									
								<!---<a onclick="expandTree();" class="btn btn-xs" title="Abrir nodos del árbol"><i class="icon-plus"></i> Expandir</a>
								<a onclick="collapseTree();" class="btn btn-xs" title="Abrir nodos del árbol"><i class="icon-minus"></i> Colapsar</a>--->
								
							</div>
							<input type="hidden" id="changeTabDisabled" value="true"/><!---No cambiar de pestaña al seleccionar área--->
						</div>

						<!---<div class="col-sm-1" style="padding:0;">	
						</div>--->

					</div>
				</div>
				
				<!---treeContainer--->
				<div id="treeWrapper">
					<!---<cfoutput>
					<div style="cursor:pointer;float:right;clear:both;">
					<img src="#APPLICATION.htmlPath#/assets/icons/maximize.png" title="Maximizar Árbol" id="maximizeTree" />
					<img src="#APPLICATION.htmlPath#/assets/icons/restore.png" title="Restaurar Árbol" id="restoreTree" style="display:none;"/>
					</div>
					</cfoutput>--->
					<div id="treeContainer" style="overflow:auto;clear:both;">
						<cfinclude template="#APPLICATION.htmlPath#/html_content/tree.cfm">
					</div>			
				</div>
				
				<!---foot--->
				<div>				
					
					<div style="float:right; padding:0; margin:0;">
						
						<a onClick="changeLanguage()" id="languageSelector" style="font-size:12px;cursor:pointer;">Inglés</a>
						
						<span style="font-size:12px;">&nbsp;|&nbsp;</span>
						<cfoutput>
						<a href="mobile.cfm?abb=#SESSION.client_abb#" style="font-size:12px" lang="es">Versión móvil</a>
						</cfoutput>
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
								<img src="#APPLICATION.resourcesPath#/downloadAreaImage.cfm?id=#area_id#" id="areaImage" alt="Imagen del área" style="max-width:100%;" />
							<cfelse>
								<img src="#APPLICATION.resourcesPath#/#APPLICATION.identifier#_banner.png" id="areaImage" alt="Imagen del área" style="max-width:100%" />
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
<!--- <cfinclude template="#APPLICATION.htmlPath#/includes/open_download_file.cfm"> --->

</body>
</html>
</cfprocessingdirective>
	
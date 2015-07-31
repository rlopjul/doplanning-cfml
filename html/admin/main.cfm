<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>

<!---Obtiene el usuario logeado--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	<cfinvokeargument name="format_content" value="all">
</cfinvoke>

<html lang="es">
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2014 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<cfoutput>

<title>Administración #APPLICATION.title#<cfif isDefined("SESSION.client_name")> - #SESSION.client_name#</cfif></title>

<cfif APPLICATION.identifier EQ "dp">
<link href="#APPLICATION.htmlPath#/assets/favicon.ico" rel="shortcut icon" type="image/x-icon"> 
</cfif>

<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">
<cfif len(APPLICATION.themeCSSPath) GT 0>
<link href="#APPLICATION.themeCSSPath#" rel="stylesheet">
</cfif>
<!--[if lt IE 9]>
	<script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <link href="//netdna.bootstrapcdn.com/respond-proxy.html" id="respond-proxy" rel="respond-proxy" />
    <link href="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.gif" id="respond-redirect" rel="respond-redirect" />
    <script src="//oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <script src="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.js"></script>
<![endif]-->

<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/css/bootstrap-modal-bs3patch.css" rel="stylesheet">
<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/css/bootstrap-modal.css" rel="stylesheet">

<link href="#APPLICATION.dpCSSPath#" rel="stylesheet" />


<cfif APPLICATION.identifier EQ "dp">
<link rel="stylesheet" media="all" href="#APPLICATION.htmlPath#/styles/styles_dp.min.css"/>
<cfelse>
<link rel="stylesheet" media="all" href="#APPLICATION.htmlPath#/styles/styles_vpnet.css"/>
</cfif>


<link href="#APPLICATION.path#/jquery/jstree/themes/dp/style.min.css?v=3.2" rel="stylesheet" />

<script src="#APPLICATION.jqueryJSPath#"></script>
<script src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js?v=3.0"></script>

<script src="#APPLICATION.bootstrapJSPath#"></script>

<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/js/bootstrap-modal.js"></script>
<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/js/bootstrap-modalmanager.js"></script>
<!---<script src="#APPLICATION.htmlPath#/bootstrap/bootbox/bootbox.js"></script>--->

<script>
	<!---To enable the loading spinner in Bootstrap 3--->
	$.fn.modal.defaults.spinner = $.fn.modalmanager.defaults.spinner = 
    '<div class="loading-spinner" style="width: 200px; margin-left: -100px;">' +
        '<div class="progress progress-striped active">' +
            '<div class="progress-bar" style="width: 100%;"></div>' +
        '</div>' +
    '</div>';
    <!--- To set modal max height --->
	$.fn.modal.defaults.maxHeight = function(){
	    return $(window).height() - 170; 
	}
</script>

<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/vendor/jquery.ui.widget.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.iframe-transport.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.fileupload.js"></script>
<script src="//blueimp.github.io/JavaScript-Templates/js/tmpl.min.js"></script>

<script src="#APPLICATION.path#/jquery/jquery-mask/jquery.mask.min.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-validate/jquery.validate.min.js"></script>

<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.min.js" charset="utf-8" ></script>
<!---<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang-dp.js" charset="utf-8"></script>--->

<script src="#APPLICATION.path#/jquery/typeahead/typeahead.bundle.min.js" charset="utf-8"></script>

<!---<script src="#APPLICATION.htmlPath#/language/main_en.js?v=1.2" charset="utf-8"></script>--->
<script src="#APPLICATION.htmlPath#/language/dp_en.js" charset="utf-8"></script>

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
	<!--- var applicationPath = "#APPLICATION.path#"; --->
	var applicationId = "#APPLICATION.identifier#";
	var selectAreaId = "#area_id#";
	var iframePage = "#iframe_page#";
	var userLanguage = "#objectUser.language#";
	var clientAbb = "#SESSION.client_abb#";
	
	<!--- var areaImgHeight = 60; --->
	
	<!---Si se cambian estos valores, también hay que cambiarlos en los CSS--->
	var treeDefaultWidth = "99%";
	var areaDefaultWidth = "99%";
	
	// Language
	var selectedLanguage = 'es';
	<!---jquery_lang_js.prototype.defaultLang = 'es';
	jquery_lang_js.prototype.currentLang = 'es';
	window.lang = new jquery_lang_js();--->
	window.lang = new Lang('es');
	<!---window.lang.dynamic('en', '#APPLICATION.htmlPath#/language/main_en.json');--->
	</cfoutput>

	// Modal
	var $modal = null;
	
</script>

<cfoutput>
<script src="#APPLICATION.htmlPath#/scripts/functions.min.js?v=2.7"></script>
<script src="#APPLICATION.htmlPath#/scripts/tree.min.js?v=3.1.2"></script>
<script src="#APPLICATION.htmlPath#/scripts/main.min.js?v=2.94"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
</cfoutput>

<script>
	
	function resizeIframe() {
		var newHeight = windowHeight()-78;
		$(".iframes").height(newHeight);
		
		var userIframeHeight = 300;

		$("#areaIframe").height(newHeight-userIframeHeight-5)
		$("#allUsersIframe").height(newHeight-userIframeHeight-5);
		$("#logItemIframe").height(newHeight);
		$("#treeContainer").height(newHeight-79);
	}

	function changeLanguage() {
		
		if(selectedLanguage == 'en')
			newLanguage = 'es';
		else
			newLanguage = 'en';
			
		window.lang.change(newLanguage);
			
		location.href = "../language_selection.cfm?lan="+newLanguage+"&rpage=admin/";
	
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

	function logIframeLoaded() {

		if($("#logIframe").attr('src') != "about:blank" && $("#loadingContainer").css('display') == "block"){
			$("#loadingContainer").hide();
		}
			
	}

	function loadAreaImage(areaId) {

		<!--- Aquí no se carga la imagen del área en la administración
		if(applicationId != "vpnet") { //Esto solo está habilitado para DP ya que en la otra versión no se utiliza y carga la aplicación
					$("#areaImage").attr('src', "../../app/downloadAreaImage.cfm?id="+areaId);
		} --->

	}

	<!---
	Esto no se usa en la administración
	function goToAreaLink() {
		
		if(areaWithLink == true) {
			window.open("../../app/goToAreaLink.cfm?id="+curAreaId, "_blank");
		}
		
	}--->

	function openAreaNewModal(){

		if($.isNumeric(curAreaId))
			loadModal('html_content/area_new.cfm?parent='+curAreaId);
		else
			showAlertModal(window.lang.translate("Debe seleccionar un área en la que crear la nueva"));
	}

	function openAreaImportModal(){

		if($.isNumeric(curAreaId))
			loadModal('html_content/area_import.cfm?parent='+curAreaId);
		else
			showAlertModal(window.lang.translate("Debe seleccionar un área en la que crear las nuevas áreas"));
	}

	function openAreaExportModal(){

		if($.isNumeric(curAreaId))
			loadModal('html_content/area_export_structure.cfm?parent='+curAreaId);
		else
			showAlertModal(window.lang.translate("Debe seleccionar un área para exportar"));
	}

	function openAreaMoveModal(){

		if($.isNumeric(curAreaId))
			loadModal('html_content/area_cut.cfm?area='+curAreaId);
		else
			showAlertModal(window.lang.translate("Debe seleccionar un área para mover"));
	}

	function openAreaAssociateModal(userId){

		if($.isNumeric(curAreaId))
			loadModal('html_content/area_user_associate.cfm?area='+curAreaId+'&user='+userId);
		else
			showAlertModal(window.lang.translate("Debe seleccionar un área para asociar el usuario"));
	}

	function openAreasAssociateModal(userId){

		if($.isNumeric(curAreaId))
			loadModal('html_content/areas_user_associate_tree.cfm?user='+userId+'&area='+curAreaId);
		else
			loadModal('html_content/areas_user_associate_tree.cfm?user='+userId);
		
	}

	function openAreaAssociateUsersModal(usersIds){

		if($.isNumeric(curAreaId))
			loadModal('html_content/area_users_associate.cfm?area='+curAreaId+'&users='+usersIds);
		else
			//alert("Debe seleccionar un área para asociar los usuarios");
			showAlertModal(window.lang.translate("Debe seleccionar un área para asociar los usuarios"));
	}

	function openAssociateUsersModal(usersIds, areaId){

		if($.isNumeric(areaId))
			loadModal('html_content/area_users_associate.cfm?area='+areaId+'&users='+usersIds);
		else
			showAlertModal(window.lang.translate("Debe seleccionar un área para asociar los usuarios"));
	}

	function openAreaAssociateAdministratorModal(userId){

		if($.isNumeric(curAreaId))
			loadModal('html_content/area_administrator_associate.cfm?area='+curAreaId+'&user='+userId);
		else
			showAlertModal(window.lang.translate("Debe seleccionar un área para asociar el administrador"));
	}

	function openAreaModifyModal(){

		if($.isNumeric(curAreaId))
			loadModal('html_content/area_modify.cfm?area='+curAreaId);
		else
			showAlertModal(window.lang.translate("Debe seleccionar un área para modificar"));
	}

	function openAreaDeleteModal(){

		if($.isNumeric(curAreaId))
			loadModal('html_content/area_delete.cfm?area='+curAreaId);
		else
			showAlertModal(window.lang.translate("Debe seleccionar un área para eliminar"));

	}


	function emptyIframes(){

		$("#areaIframe").attr('src', 'iframes/area.cfm');
		$("#userAreaIframe").attr('src', 'about:blank');
		
	}

	$(window).resize( function() {
		resizeIframe();
	});
	
	$(window).load( function() {		
		resizeIframe();
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
				
		<!---$("#areaImage").load( function () {
			areaImgHeight = $("#areaImage").height();			
			resizeIframe();	
		});--->

		$('#dpTab a').click( function (e) {
			if(e.preventDefault)
		  		e.preventDefault();
			
		  	$(this).tab('show');
			
		});
		
		$('a[data-toggle="tab"]').on('show.bs.tab', function (e) { //On show tab
			
			var pattern=/#.+/gi //use regex to get anchor(==selector)
			currentTab = e.target.toString().match(pattern)[0];

			if(currentTab == "#tab3" && $("#logIframe").attr('src') == "about:blank") { //Load logs page
				$("#logIframe").attr('src', 'iframes/logs.cfm');
				$("#loadingContainer").show();
			}

		})
		
		$("#searchText").on("keydown", function(e) { 
		
			if(e.which == 13) //Enter key
				searchTextInTree();
			
		});
		
	});
	
	$(document).ready(function () {
		// Language
   		<!---window.lang.run();

   		if(hasLocalStorage())
			selectedLanguage = localStorage.getItem('langJs_currentLang');

		if(userLanguage != selectedLanguage)
			window.lang.change(userLanguage);--->

		<!---if(hasLocalStorage())
   			savedLanguage = localStorage.getItem('langJs_currentLang');

		if(savedLanguage != selectedLanguage && userLanguage == savedLanguage){
			window.lang.change(userLanguage);
		}--->

		selectedLanguage = window.lang.currentLang;

		if( window.lang.currentLang != userLanguage ){
			window.lang.change(userLanguage);
			selectedLanguage = userLanguage;
		}
		
		if(selectedLanguage == 'en')
			$('#languageSelector').text('Español');
		else
			$('#languageSelector').text('English');

		// Modal
		$modal = $('#ajax-modal');

		// Alert
		$('#alertContainer .close').click(function(e) {

			hideAlertMessage();

		});


		<cfinclude template="#APPLICATION.htmlPath#/includes/jquery_validate_bootstrap_scripts.cfm">
				
	});
	
</script>
</head>

<body class="body_tree">			

<!--- Alert --->
<cfinclude template="#APPLICATION.htmlPath#/includes/main_alert.cfm">

<!--- Loading --->
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_div.cfm">

<div class="div_contenedor_contenido">

	<!---<cfset current_page = "main.cfm">--->
	
	<div id="mainContainer">
	
		
		<div class="tabbable"><!---Tab Panel--->
	
		  <ul class="nav nav-pills" id="dpTab" style="clear:none;padding-bottom:5px;">
			<li class="active"><a href="#tab1" data-toggle="tab" lang="es">Árbol</a></li>
			<li><a href="#tab2" data-toggle="tab" lang="es">Área</a></li>
			<cfif SESSION.client_administrator IS SESSION.user_id>
			<li><a href="#tab3" data-toggle="tab" lang="es">Logs</a></li>
			</cfif>
		  </ul>
		  
		  <cfoutput>
		  <div style="clear:none; text-align:center">

		  	<span class="main_title"><b lang="es"><cfif SESSION.client_administrator IS SESSION.user_id>Administración general<cfelse>Administración de áreas</cfif></b></span>
		  
		  	<div style="float:right; text-align:right; clear:none;">
				<a href="../preferences.cfm" title="Preferencias del usuario" class="link_user_logged" lang="es"><span>#objectUser.family_name# #objectUser.name# (#getAuthUser()#)</span></a><br/>
				
				<a href="../logout.cfm" title="Cerrar sesión" class="link_user_logout"><i class="icon-signout"></i> <span lang="es">Salir</span></a>

			</div>
			
			<cfif APPLICATION.identifier NEQ "vpnet">
				<div style="float:right; padding-top:1px; padding-right:6px; text-align:right;"><!---width:200px; --->
					
					<!--- 
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
										</cfif> --->
					<div class="btn-toolbar">

						<div class="btn-group">
							<a href="../main.cfm?abb=#SESSION.client_abb#" class="btn btn-default btn-sm"><i class="icon-arrow-left"></i> <span lang="es">Volver</span></a>
						</div>
					
						<div class="btn-group">
							<a href="../preferences.cfm" title="Preferencias del usuario" lang="es">
							<!---<cfif len(objectUser.image_file) GT 0>
								<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.image_file#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" />
							<cfelse>
								<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" />
							</cfif>--->

							<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUserImage">
								<cfinvokeargument name="user_id" value="#objectUser.id#">
								<cfinvokeargument name="user_id" value="#objectUser.id#">
								<cfinvokeargument name="user_full_name" value="#objectUser.family_name# #objectUser.name#">
								<cfinvokeargument name="user_image_type" value="#objectUser.image_type#">
								<cfinvokeargument name="width_px" value="30">
							</cfinvoke>
							</a>
						</div>

					</div>
				</div>
			</cfif>
		  
		  </div>
		  </cfoutput>
		  
		  <div class="tab-content" style="clear:both;">
		  
		  
			<div class="tab-pane active" id="tab1"><!---Tab Tree--->
				
				<!---<div class="form-inline" style="padding-bottom:5px;">--->
				<div class="container" style="width:100%;">
					<div class="row" style="padding-bottom:5px;">
						
						<div class="col-sm-12" style="padding:0;">

							<div class="btn-toolbar">

								<div class="btn-group">
									<div class="input-group" style="width:260px;" >
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
									<a onClick="updateTree();" class="btn btn-default" title="Actualizar" lang="es"><i class="icon-refresh"></i></a><!---<span lang="es">Actualizar</span>--->
								</div>

								<div class="btn-group">
									<a onClick="openAreaNewModal()" class="btn btn-info" title="Nueva área" lang="es"><i class="icon-plus icon-white"></i> <span lang="es">Nueva área</span></a><!---color:#5BB75B--->

									<a onclick="openAreaModifyModal()" class="btn btn-info" title="Modificar área" lang="es"><i class="icon-edit icon-white"></i> <span lang="es">Modificar</span></a>

									<a onClick="openAreaMoveModal()" class="btn btn-info" title="Mover área" lang="es"><i class="icon-cut icon-white"></i> <span lang="es">Mover</span></a>
								</div>

								<div class="btn-group">
									<a onClick="openAreaExportModal()" class="btn btn-info" title="Exportar áreas" lang="es"><i class="icon-circle-arrow-down icon-white"></i> <span lang="es">Exportar</span></a>

									<a onClick="openAreaImportModal()" class="btn btn-info" title="Importar áreas" lang="es"><i class="icon-circle-arrow-up icon-white"></i> <span lang="es">Importar</span></a>									
								</div>

								<div class="btn-group">
									<a onClick="openAreaDeleteModal()" class="btn btn-danger" title="Eliminar área" lang="es"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>
								</div>

							</div>

						</div>

						<!---<div class="col-sm-1" style="padding:0;">	
							<a href="../main.cfm" class="btn btn-info" style="float:right"><i class="icon-arrow-left"></i> <span>Volver</span></a>
						</div>--->

					</div>
				</div>

				<div class="form-inline" style="padding-bottom:5px; padding-left:5px;">
					<label class="checkbox">
						<input type="checkbox" id="changeTabDisabled" value="true" style="width:15px;height:15px"/>&nbsp;&nbsp;<span style="font-size:15px;" lang="es">No cambiar de pestaña al seleccionar área</span>
					</label>
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
						<cfinclude template="#APPLICATION.htmlPath#/admin/html_content/tree.cfm">
					</div>			
				</div>
				
				<!---foot--->
				<div>				
					
					<div style="float:right; padding:0; margin:0;">
						
						<a onClick="changeLanguage()" id="languageSelector" style="font-size:12px;cursor:pointer;">Inglés</a>
						
						<!--- <span style="font-size:12px;">&nbsp;|&nbsp;</span>
						<a href="mobile.cfm" style="font-size:12px" lang="es">Versión móvil</a> --->
						
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
					
					<div id="areaUsersContainer"><!---Area Users--->

						<!--- 
						<a id="areaImageAnchor" onClick="goToAreaLink()"><!---Banner--->
						<cfoutput>
							<cfif isNumeric(area_id)>
								<img src="#APPLICATION.resourcesPath#/downloadAreaImage.cfm?id=#area_id#" id="areaImage" alt="Imagen del área" />
							<cfelse>
								<img src="#APPLICATION.resourcesPath#/#APPLICATION.identifier#_banner.png" id="areaImage" alt="Imagen del área" />
							</cfif>
						</cfoutput>
						</a> --->
						
						<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframes" src="about:blank" style="height:100%;background-color:#FFFFFF;" id="areaIframe" onload="areaIframeLoaded()"></iframe><!---iframes/area.cfm--->

						<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframeItem" src="about:blank" style="height:300px;background-color:#FFFFFF; border-top: 1px solid #CCCCCC;" id="userAreaIframe"></iframe><!---iframes/area_user.cfm--->
					
					</div>
					
					<div id="usersContainer"><!---Users--->
						
						<!---All users--->
						<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframeItem" src="iframes/all_users.cfm" style="height:100%;background-color:#FFFFFF;" id="allUsersIframe"></iframe>

						<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframeItem" src="about:blank" style="height:300px;background-color:#FFFFFF; border-top: 1px solid #CCCCCC;" id="userAdminIframe"></iframe><!---iframes/user.cfm--->
						
					</div>
					
					
				</div>
				
			</div><!---END Tab Area--->
			
			
			<cfif SESSION.client_administrator IS SESSION.user_id>

			<div class="tab-pane" id="tab3"><!---Tab Logs--->
				
				<!---logContainer--->
				<div id="logContainer">
					
					
					<div id="logItemsContainer"><!---Items Log--->
						
						<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframes" src="about:blank" style="height:100%;background-color:#FFFFFF;" id="logIframe" onload="logIframeLoaded()"></iframe>
					
					</div>
					
					<div id="logItemContainer"><!---Item Log--->
					
						<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="logItem" src="about:blank" style="height:100%;background-color:#FFFFFF;" id="logItemIframe"></iframe>
						
					</div>
					
				
				</div>
				
			</div><!---END Tab Logs--->

			</cfif>
						
		  </div>
		  
		</div><!---END TabPanel--->
	
		
		<div style="clear:both"><!-- --></div>
		
	</div>

	<!--- Modal Window --->
	<div id="ajax-modal" class="modal container fade" role="dialog" tabindex="-1"></div><!---hide funcionaba en bs2--->

	<!---Alert modal--->
	<div id="alertModal" class="modal container fade" tabindex="-1"></div>

	<div style="clear:both"><!-- --></div>
	<div class="msg_div_error" id="errorMessage"></div>

	<!---<div id="prueba"></div>--->

</div>

<!---Download File--->
<!--- <cfinclude template="#APPLICATION.htmlPath#/includes/open_download_file.cfm"> --->

<!--- Alert modal --->
<script type="text/x-tmpl" id="tmpl-alert-modal">

{% if(o.error==true) { %}
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h4 class="text-danger"><i class="icon-warning-sign"></i>&nbsp;Error</h4>
</div>
{% } %}

<div class="modal-body">
	<br/>
	{%=o.msg%}
</div>
<div class="modal-footer">
	<button class="btn btn-primary" data-dismiss="modal" aria-hidden="true" lang="es">Aceptar</button>
</div>
</script>

</body>
</html>
</cfprocessingdirective>
	
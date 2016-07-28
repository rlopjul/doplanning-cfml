<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>

<!---Obtiene el usuario logeado--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	<cfinvokeargument name="format_content" value="all">
</cfinvoke>

<html lang="es">
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2016 (www.era7.com)-->
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

<link href="#APPLICATION.path#/libs/font-awesome/4.6.3/css/font-awesome.min.css" rel="stylesheet">

<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/css/bootstrap-modal-bs3patch.css" rel="stylesheet">
<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/css/bootstrap-modal.css" rel="stylesheet">

<link href="#APPLICATION.dpCSSPath#" rel="stylesheet" />


<cfif APPLICATION.identifier EQ "dp">
<link rel="stylesheet" media="all" href="#APPLICATION.htmlPath#/styles/styles_dp.min.css"/>
<cfelse>
<link rel="stylesheet" media="all" href="#APPLICATION.htmlPath#/styles/styles_vpnet.css"/>
</cfif>


<script src="#APPLICATION.jqueryJSPath#"></script>

<link href="#APPLICATION.jsTreeCSSPath#" rel="stylesheet" />
<script src="#APPLICATION.jsTreeJSPath#"></script>

<script src="#APPLICATION.bootstrapJSPath#"></script>

<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/js/bootstrap-modal.js"></script>
<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/js/bootstrap-modalmanager.js"></script>
<script src="#APPLICATION.path#/libs/bootbox/4.4.0/bootbox.min.js"></script>

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

<script src="#APPLICATION.path#/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.min.js" charset="utf-8" ></script>
<!---<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang-dp.js" charset="utf-8"></script>--->

<script src="#APPLICATION.path#/jquery/typeahead/typeahead.bundle.min.js" charset="utf-8"></script>

<!---<script src="#APPLICATION.htmlPath#/language/main_en.js?v=1.2" charset="utf-8"></script>--->
<!---<script src="#APPLICATION.htmlPath#/language/dp_en.js" charset="utf-8"></script>--->

</cfoutput>

<!--- isUserUserAdministrator --->
<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="isUserUserAdministrator" returnvariable="isUserUserAdministratorResponse">
	<cfinvokeargument name="check_user_id" value="#SESSION.user_id#">
</cfinvoke>

<cfif isUserUserAdministratorResponse.result IS false>
	<cfthrow message="#isUserUserAdministratorResponse.message#">
<cfelse>
	<cfset isUserAdministrator = isUserUserAdministratorResponse.isUserAdministrator>
</cfif>

<!---<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	<cfset area_id = URL.area>

	<cfinclude template="#APPLICATION.htmlPath#/includes/url_redirect.cfm">

	<cfif isDefined("redirect_page")>
		<cfset iframe_page = redirect_area_page>
	<cfelse>
		<cfset iframe_page = "">
	</cfif>--->

<cfset area_id = "null">
<cfset iframe_page = "">

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
	window.lang.dynamic('en', '#APPLICATION.htmlPath#/language/main_en.cfm');
	</cfoutput>

	// Modal
	var $modal = null;

</script>

<cfoutput>
<script src="#APPLICATION.htmlPath#/scripts/functions.min.js?v=2.7"></script>
<script src="#APPLICATION.htmlPath#/scripts/tree.min.js?v=3.1.2"></script>
<script src="#APPLICATION.htmlPath#/scripts/main.min.js?v=2.94"></script>
<script src="#APPLICATION.htmlPath#/admin/scripts/mainAdmin.min.js?v=1.1"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<cfif isUserAdministrator IS true>
	<cfinclude template="#APPLICATION.corePath#/includes/user_form_scripts.cfm">
	<script src="#APPLICATION.htmlPath#/admin/scripts/userFormFunctions.js?v=1.6"></script>
</cfif>


<cfif SESSION.client_abb EQ "ceseand">

	<cfset entitiesListAreaId = 100>

	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="canUserAccessToArea" returnvariable="canUserAccessToEntitiesList">
		<cfinvokeargument name="area_id" value="#entitiesListAreaId#">
	</cfinvoke>

</cfif>

</cfoutput>

<script>

	$(window).resize( function() {
		resizeIframe();
	});

	$(window).load( function() {
		resizeIframe();

		showTree(true);

		<!---<cfif APPLICATION.moduleMessenger EQ true AND isDefined("SESSION.user_id")>
		Messenger.Private.initGetNewConversations();
		</cfif>--->

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

			if(currentTab == "#tab3" && $("#typologiesUsersIframe").attr('src') == "about:blank") { //Load statistics page
				$("#typologiesUsersIframe").attr('src', 'iframes/users_typologies.cfm');
				$("#typologiesFilesIframe").attr('src', 'iframes/files_typologies.cfm');
				$("#loadingContainer").show();
			}

			if(currentTab == "#tab4" && $("#categoriesGeneralIframe").attr('src') == "about:blank") { //Load statistics page
				$("#categoriesGeneralIframe").attr('src', 'iframes/categories.cfm');
				$("#loadingContainer").show();
			}

			if(currentTab == "#tab5" && $("#statisticsGeneralIframe").attr('src') == "about:blank") { //Load statistics page
				$("#statisticsGeneralIframe").attr('src', 'iframes/statistics.cfm');
				$("#statisticsUsersIframe").attr('src', 'iframes/statistics_users.cfm');
				$("#statisticsFilesIframe").attr('src', 'iframes/statistics_files.cfm');
				$("#loadingContainer").show();
			}

			if(currentTab == "#tab6" && $("#logIframe").attr('src') == "about:blank") { //Load logs page
				$("#logIframe").attr('src', 'iframes/logs.cfm');
				$("#loadingContainer").show();
			}

			if(currentTab == "#tab7" && $("#usersGeneralIframe").attr('src') == "about:blank") { //Load users page
				$("#usersGeneralIframe").attr('src', 'iframes/users.cfm');
				$("#loadingContainer").show();
			}

			if(currentTab == "#tabEntities" && $("#entitiesIframe").attr('src') == "about:blank") { //Load entities page
				$("#entitiesIframe").attr('src', 'iframes/list_rows.cfm?list=4');
				$("#loadingContainer").show();
			}


		})

		$("#searchText").on("keydown", function(e) {

			if(e.which == 13) //Enter key
				searchTextInTree();

		});


		<cfif isUserAdministrator IS true AND isDefined("URL.user") AND isNumeric(URL.user)>

			$('#dpTab a[href="#tab7"]').tab('show');

			<cfoutput>
			loadModal('html_content/user_modify.cfm?user='+#URL.user#);
			</cfoutput>

		</cfif>

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

		<cfinclude template="#APPLICATION.corePath#/includes/jquery_validate_bootstrap_scripts.cfm">

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
			<cfif isUserAdministrator IS true>
				<li><a href="#tab7" data-toggle="tab" lang="es">Usuarios</a></li>
			</cfif>
			<cfif SESSION.client_abb EQ "ceseand" AND canUserAccessToEntitiesList IS true>
			<li><a href="#tabEntities" data-toggle="tab" lang="es">Entidades</a></li>
			</cfif>
			<cfif SESSION.client_administrator IS SESSION.user_id>
			<li><a href="#tab3" data-toggle="tab" lang="es">Tipologías</a></li>
			<li><a href="#tab4" data-toggle="tab" lang="es">Categorías</a></li>
			<li><a href="#tab5" data-toggle="tab" lang="es">Estadísticas</a></li>
			<li><a href="#tab6" data-toggle="tab" lang="es">Logs</a></li>
			</cfif>
		  </ul>

		  <cfoutput>
		  <div style="clear:none; text-align:center">

		  	<span class="main_title"><b lang="es"><cfif SESSION.client_administrator IS SESSION.user_id>Administración general<cfelse>Administración de áreas</cfif></b></span>

		  	<div style="float:right; text-align:right; clear:none;">
				<a href="../preferences_user_data.cfm" title="Datos personales" class="link_user_logged" lang="es"><span>#objectUser.family_name# #objectUser.name# (#getAuthUser()#)</span></a><br/>

				<a href="../logout.cfm" title="Cerrar sesión" class="link_user_logout" lang="es"><i class="icon-signout"></i> <span lang="es">Salir</span></a>

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
							<cfif len(objectUser.start_page) GT 0 AND objectUser.start_page NEQ "admin/">
								<!---<cfset start_page = "#APPLICATION.path#/html/#objectUser.start_page#">--->
								<cfset start_page = "#APPLICATION.path#/html/index.cfm">
							<cfelse>
								<cfset start_page = "#APPLICATION.path#/html/last_items.cfm?abb=#SESSION.client_abb#">
							</cfif>
							<a href="#start_page#" class="btn btn-default btn-sm"><i class="icon-arrow-left"></i> <span lang="es">Volver</span></a>
						</div>

						<!---<div class="btn-group">
							<a href="../preferences.cfm" title="Preferencias del usuario" lang="es">
							<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUserImage">
								<cfinvokeargument name="user_id" value="#objectUser.id#">
								<cfinvokeargument name="user_id" value="#objectUser.id#">
								<cfinvokeargument name="user_full_name" value="#objectUser.family_name# #objectUser.name#">
								<cfinvokeargument name="user_image_type" value="#objectUser.image_type#">
								<cfinvokeargument name="width_px" value="30">
							</cfinvoke>
							</a>
						</div>--->

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
					<img src="#APPLICATION.htmlPath#/assets/v3/icons/maximize.png" title="Maximizar Árbol" id="maximizeTree" />
					<img src="#APPLICATION.htmlPath#/assets/v3/icons/restore.png" title="Restaurar Árbol" id="restoreTree" style="display:none;"/>
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
					<img src="#APPLICATION.htmlPath#/assets/v3/icons/maximize.png" title="Maximizar" id="maximizeArea" />
					<img src="#APPLICATION.htmlPath#/assets/v3/icons/restore.png" title="Restaurar" id="restoreArea" style="display:none;"/>
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

			<cfif isUserAdministrator IS true>

				<div class="tab-pane" id="tab7"><!---Tab Users--->

					<div class="tabbable"><!---Tab Panel--->

						<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframes" src="about:blank" style="height:100%;background-color:##FFFFFF;" id="usersGeneralIframe" onload="usersGeneralIframeLoaded()"></iframe>

					</div><!---END TabPanel--->


				</div><!---END Tab Users--->

			</cfif>

			<cfif SESSION.client_abb EQ "ceseand" AND canUserAccessToEntitiesList IS true>

				<div class="tab-pane" id="tabEntities"><!---Tab Entities CESEAND--->

					<div class="tabbable"><!---Tab Panel--->

						<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframes" src="about:blank" style="height:100%;background-color:##FFFFFF;" id="entitiesIframe" onload="entitiesIframeLoaded()"></iframe>

					</div><!---END TabPanel--->


				</div><!---END Tab Entities CESEAND--->

			</cfif>

			<cfif SESSION.client_administrator IS SESSION.user_id>

			<div class="tab-pane" id="tab3"><!---Tab Typologies--->

				<div class="tabbable"><!---Tab Panel--->

					<ul class="nav nav-pills" id="typologiesTab" style="clear:none; padding-bottom:5px;">
						<li class="active"><a href="#typologiesTab1" data-toggle="tab" lang="es">Usuarios</a></li>
						<li><a href="#typologiesTab2" data-toggle="tab" lang="es">Archivos</a></li>
					</ul>

					<div class="tab-content">

						<div class="tab-pane active" id="typologiesTab1"><!---Tab Users--->

							<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframes" src="about:blank" style="height:100%;background-color:##FFFFFF;" id="typologiesUsersIframe" onload="typologiesUsersIframeLoaded()"></iframe>

						</div><!---END Tab Users--->

						<div class="tab-pane" id="typologiesTab2"><!---Tab Files--->

							<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframes" src="about:blank" style="height:100%;background-color:##FFFFFF;" id="typologiesFilesIframe" onload="typologiesFilesIframeLoaded()"></iframe>

						</div><!---END Tab Files--->

					</div>

				</div><!---END TabPanel--->


			</div><!---END Tab Statistics--->


			<div class="tab-pane" id="tab4"><!---Tab Categories--->

				<div class="tabbable"><!---Tab Panel--->

					<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframes" src="about:blank" style="height:100%;background-color:##FFFFFF;" id="categoriesGeneralIframe" onload="categoriesGeneralIframeLoaded()"></iframe>

				</div><!---END TabPanel--->


			</div><!---END Tab Categories--->


			<div class="tab-pane" id="tab5"><!---Tab Statistics--->

				<div class="tabbable"><!---Tab Panel--->

					<ul class="nav nav-pills" id="statisticsTab" style="clear:none; padding-bottom:5px;">
						<li class="active"><a href="#statisticsTab1" data-toggle="tab" lang="es">Generales</a></li>
						<li><a href="#statisticsTabUsers" data-toggle="tab" lang="es">Usuarios</a></li>
						<li><a href="#statisticsTabFiles" data-toggle="tab" lang="es">Archivos</a></li>
					</ul>

					<div class="tab-content">

						<div class="tab-pane active" id="statisticsTab1"><!---Tab General--->

							<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframes" src="about:blank" style="height:100%;background-color:##FFFFFF;" id="statisticsGeneralIframe" onload="statisticsGeneralIframeLoaded()"></iframe>

						</div><!---END Tab Generales--->

						<div class="tab-pane" id="statisticsTabUsers"><!---Tab Users--->

							<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframes" src="about:blank" style="height:100%;background-color:##FFFFFF;" id="statisticsUsersIframe" onload="statisticsUsersIframeLoaded()"></iframe>

						</div><!---END Tab Users--->


						<div class="tab-pane" id="statisticsTabFiles"><!---Tab Files--->

							<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframes" src="about:blank" style="height:100%;background-color:##FFFFFF;" id="statisticsFilesIframe" onload="statisticsFilesIframeLoaded()"></iframe>

						</div><!---END Tab Files--->

					</div>

				</div><!---END TabPanel--->


			</div><!---END Tab Statistics--->


			<div class="tab-pane" id="tab6"><!---Tab Logs--->

				<!---logContainer--->
				<div id="logContainer">


					<div id="logItemsContainer"><!---Items Log--->

						<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="iframes" src="about:blank" style="height:100%;background-color:##FFFFFF;" id="logIframe" onload="logIframeLoaded()"></iframe>

					</div>

					<div id="logItemContainer"><!---Item Log--->

						<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" class="logItem" src="about:blank" style="height:100%;background-color:##FFFFFF;" id="logItemIframe"></iframe>

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

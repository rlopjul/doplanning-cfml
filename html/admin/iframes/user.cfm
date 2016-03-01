<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_iframes_estilos.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<!-- InstanceBeginEditable name="doctitle" -->
<title></title>
<!-- InstanceEndEditable -->
<cfoutput>
<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">
<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet">
<!---<!--[if lt IE 9]>
	<script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <link href="//netdna.bootstrapcdn.com/respond-proxy.html" id="respond-proxy" rel="respond-proxy" />
    <link href="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.gif" id="respond-redirect" rel="respond-redirect" />
    <script src="//oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <script src="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.js"></script>
<![endif]-->
<!--[if IE 7]>
  	<link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome-ie7.min.css" rel="stylesheet" >
<![endif]-->--->

<!--[if lt IE 9]>
	<script src="#APPLICATION.htmlPath#/scripts/html5shiv/html5shiv.js"></script>
    <script src="#APPLICATION.htmlPath#/scripts/respond/respond.min.js"></script>
<![endif]-->
<!--[if lt IE 8]>
  	<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-ie7/bootstrap-ie7.css" rel="stylesheet" rel="stylesheet">
<![endif]-->
<!--[if IE 7]>
	<link href="#APPLICATION.htmlPath#/font-awesome/css/font-awesome-ie7.min.css" rel="stylesheet">
<![endif]-->

<link href="#APPLICATION.dpCSSPath#" rel="stylesheet" type="text/css" media="all" />
<cfif len(APPLICATION.themeCSSPath) GT 0>
<link href="#APPLICATION.themeCSSPath#" rel="stylesheet">
</cfif>
<cfif APPLICATION.identifier EQ "vpnet">
<link href="../../styles/styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="../../styles/styles_dp.min.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<link href="../../styles/styles_iframes.css" rel="stylesheet" type="text/css" media="all" />

<script src="#APPLICATION.jqueryJSPath#"></script>
<script src="#APPLICATION.bootstrapJSPath#"></script>

<!---<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang-dp.js" charset="utf-8" ></script>--->
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script src="#APPLICATION.path#/jquery/jquery.html5.history.min.js" charset="utf-8"></script>
<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.min.js" charset="utf-8" ></script>

<script src="#APPLICATION.path#/jquery/typeahead/typeahead.bundle.min.js" charset="utf-8"></script>

<script src="../../scripts/functions.min.js?v=2.4"></script>
<script src="../../scripts/iframesFunctions.min.js?v=2.1"></script>

<script>
	//Language
	<!--- jquery_lang_js.prototype.defaultLang = 'es';
	jquery_lang_js.prototype.currentLang = 'es';
	jquery_lang_js.prototype.lang.en = [{}];
	window.lang = new jquery_lang_js();

	$().ready(function () {
   		window.lang.run();
	});--->

	<!---Lang.prototype.pack.en = {};
	Lang.prototype.pack.en.token = {};--->

	$().ready(function () {
		window.lang = new Lang('es');

		window.lang.dynamic('en', '#APPLICATION.mainUrl#/html/language/main_en.cfm');
		<cfif SESSION.user_language NEQ "es">
			window.lang.change('#SESSION.user_language#');
		</cfif>
	});
</script>

</cfoutput>
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
</head>

<body onBeforeUnload="onUnloadPage()" onLoad="onLoadPage()">
<!---divLoading--->
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_page_div.cfm">

<!-- InstanceBeginEditable name="content" -->

<cfif isDefined("URL.user")>
	<cfset user_id = URL.user>
</cfif>

<cfoutput>
<div class="navbar navbar-default navbar-fixed-top navbar_admin" style="z-index:1029"><!--- z-index necesario para que se oculte cuando se están cargando datos --->
	<div class="container-fluid">

		<cfif isDefined("user_id")>


			<div class="btn-group">
			  <button type="button" class="btn btn-info btn-sm navbar-btn dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
			    <i class="icon-plus icon-white"></i> <span lang="es">Asociar usuario</span> <span class="caret"></span>
			  </button>
			  <ul class="dropdown-menu" role="menu">
			   	<li><a onclick="parent.openAreaAssociateModal(#user_id#);" style="cursor:pointer;text-transform:uppercase" lang="es">Al área seleccionada</a></li>
			    <li><a onclick="parent.openAreasAssociateModal(#user_id#);" style="cursor:pointer;text-transform:uppercase" lang="es">A varias áreas</a></li>
			  </ul>
			</div>

			<!---<a class="btn btn-info btn-sm navbar-btn" onclick="parent.openAreaAssociateModal(#user_id#);"><i class="icon-plus icon-white"></i> <span lang="es">Asociar al área</span></a>

			<a class="btn btn-info btn-sm navbar-btn" onclick="parent.openAreasAssociateModal(#user_id#);"><i class="icon-plus icon-white"></i> <span lang="es">Asociar a varias áreas</span></a>--->

			<cfif SESSION.client_administrator IS SESSION.user_id>

				<a class="btn btn-info btn-sm navbar-btn" onclick="parent.openAreaAssociateAdministratorModal(#user_id#);"><i class="icon-plus icon-white"></i> <span lang="es">Asociar como administrador del área</span></a>

				<!--- <a class="btn btn-default btn-sm navbar-btn" onclick="parent.loadModal('html_content/user_new.cfm');"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px"></i> Nuevo usuario</a> --->

				<span class="divider">&nbsp;</span>

				<div class="btn-group">
				  <button type="button" class="btn btn-default btn-sm navbar-btn dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
				    <i class="icon-sitemap icon-white"></i> <span lang="es">Ver árbol</span> <span class="caret"></span>
				  </button>
				  <ul class="dropdown-menu" role="menu">
				   	<li><a onclick="parent.loadModal('html_content/user_tree.cfm?user=#user_id#');" style="cursor:pointer" lang="es">De áreas</a></li>
				    <li><a onclick="parent.loadModal('html_content/user_tree_admin.cfm?user=#user_id#');" style="cursor:pointer" lang="es">De administración</a></li>
				  </ul>
				</div>

	 			<a class="btn btn-default btn-sm navbar-btn" onclick="parent.loadModal('html_content/user_modify.cfm?user=#user_id#');"><i class="icon-edit icon-white"></i> <span lang="es">Modificar</span></a>

				<cfif APPLICATION.changeUserPreferencesByAdmin IS true>

					<a class="btn btn-default btn-sm navbar-btn" onclick="parent.loadModal('html_content/preferences_alerts_modify.cfm?user=#user_id#');" title="Preferencias de notificaciones" lang="es"><i class="icon-envelope-alt icon-white"></i> <span lang="es">Preferencias</span></a>

				</cfif>

	 			<!---<a class="btn btn-default btn-sm navbar-btn" onclick="parent.loadModal('html_content/user_tree.cfm?user=#user_id#');"><i class="icon-sitemap icon-white"></i> <span lang="es">Árbol de áreas</span></a>--->

	 			<a class="btn btn-danger btn-sm navbar-btn" onclick="parent.loadModal('html_content/user_delete.cfm?user=#user_id#');" title="Eliminar usuario" lang="es"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>

			</cfif>


		</cfif>

	</div>
</div>
</cfoutput>

<div style="height:50px;"><!-- ---></div>

<cfif isDefined("user_id")>
	<cfinclude template="#APPLICATION.htmlPath#/admin/includes/user_content.cfm">
<cfelse>
	No hay usuario seleccionado
</cfif>

<!-- InstanceEndEditable -->
</body>
<!-- InstanceEnd --></html>

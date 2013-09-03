<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_iframes_estilos.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<!-- InstanceBeginEditable name="doctitle" -->
<title></title>
<!-- InstanceEndEditable -->
<cfoutput>
<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">

<link href="../../styles/styles.min.css" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "vpnet">
<link href="../../styles/styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="../../styles/styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<link href="../../styles/styles_iframes.css" rel="stylesheet" type="text/css" media="all" />

<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.bootstrapJSPath#"></script>

<script type="text/javascript" src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.js" charset="utf-8" ></script>

<script type="text/javascript" src="../../scripts/functions.min.js"></script>
<script type="text/javascript" src="../../scripts/iframesFunctions.min.js"></script>

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
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_iframe_div.cfm">

<!-- InstanceBeginEditable name="content" -->

<cfif isDefined("URL.user") AND isDefined("URL.area")>
	<cfset user_id = URL.user>
	<cfset area_id = URL.area>
</cfif>

<cfoutput>
<div class="navbar navbar-fixed-top">
	<div class="navbar-inner">
		<div class="container">

 			<cfif isDefined("user_id") AND isDefined("area_id")>
 			<a class="btn btn-warning btn-small" title="Quitar Usuario" onClick="parent.loadModal('html_content/area_user_dissociate.cfm?area=#area_id#&user=#user_id#');" lang="es"><i class="icon-remove"></i> <span lang="es">Quitar de este area</span></a>

 			</cfif>

 			<cfif SESSION.client_administrator IS SESSION.user_id>

 				<!---<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="isUserAreaAdministrator" returnvariable="isAdministratorResponse">
					<cfinvokeargument name="area_id" value="#area_id#"/>
					<cfinvokeargument name="user_id" value="#user_id#"/>
				</cfinvoke>

				<cfif isAdministratorResponse.result IS false>--->
					
					<a class="btn btn-info  btn-small disabled" title="Añadir administrador" lang="es"><i class="icon-plus"></i> <span lang="es">Añadir como administrador del área</span></a>

				<!---</cfif>--->

 			</cfif>
 			
		</div>
	</div>
</div>
</cfoutput>

<div style="height:40px;"><!-- ---></div>

<cfif isDefined("user_id") AND isDefined("URL.area")>
	<cfinclude template="#APPLICATION.htmlPath#/admin/includes/user_content.cfm">
<cfelse>
	No hay usuario seleccionado
</cfif>

<!-- InstanceEndEditable -->
</body>
<!-- InstanceEnd --></html>

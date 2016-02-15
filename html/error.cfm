<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#-Error</title>
<!-- InstanceEndEditable -->

<cfinclude template="#APPLICATION.htmlPath#/includes/html_head.cfm">


<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
</cfoutput>
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



<!---<cfoutput>
<cfif APPLICATION.title EQ "DoPlanning">
	<div style="float:left; padding-top:2px;">
		<a href="../html/index.cfm"><img src="../html/assets/logo_app.gif" alt="Inicio" title="Inicio"/></a>
	</div>
<cfelse>
	<div style="float:left;">
		<a href="../html/index.cfm" title="Inicio" class="btn"><i class="icon-home" style="font-size:16px"></i></a>
	</div>
</cfif>
<div style="float:right">
	<div style="float:right; margin-right:5px; padding-top:2px;" class="div_text_user_logged">
		<a href="../html/preferences.cfm" class="link_user_logged" title="Preferencias del usuario" lang="es">#getAuthUser()#</a>&nbsp;&nbsp;&nbsp;<a href="../html/logout.cfm" class="text_user_logged" title="Cerrar sesi?n" lang="es"><i class="icon-signout"></i> <span lang="es">Salir</span></a>
	</div>
</div>
</cfoutput>--->


<div id="wrapper"><!--- wrapper --->

	<!---<div class="container">
		<div class="row">
			<div class="col-lg-8 col-lg-offset-2">
				<h1></h1>
				<p></p>

			</div>
		</div>
	</div>--->

	<!---<div class="div_contenedor_contenido">--->


<cfinclude template="#APPLICATION.htmlPath#/includes/app_client_head.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/app_head.cfm">

<div id="page-content-wrapper"><!--- page-content-wrapper --->

	<div class="container app_main_container">
		<!-- InstanceBeginEditable name="contenido_app" -->
<!---<cfoutput>
<cfif isDefined("URL.title")>
	<div>#URLDecode(URL.title)#</div>
</cfif>
<cfif isDefined("URL.description")>
	<div>#URLDecode(URL.description)#</div>
</cfif>
</cfoutput>--->
<cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/app_page_head.cfm">

<cfif isDefined("URL.error_code")>

	<cfinvoke component="#APPLICATION.componentsPath#/ErrorManager" method="getError" returnvariable="objectError">
		<cfinvokeargument name="error_code" value="#URL.error_code#">
	</cfinvoke>

	<cfif objectError.error_code IS 102>

		<cflocation url="logout.cfm" addtoken="no">
		<!---<cflocation url="#APPLICATION.htmlPath#/login?client_abb=#SESSION.client_abb#&message=#URLEncodedFormat('Su sesión ha caducado, por favor acceda de nuevo')#" addtoken="no">--->

	<cfelse>

		<div class="row">
			<div class="col-sm-12">

				<div class="alert alert-warning" role="alert">

					<i class="fa fa-exclamation-triangle"></i> <strong lang="es">#objectError.title#</strong><br />
					<cfif objectError.error_code IS 10000>
						<span lang="es">Ha ocurrido un error inesperado, disculpe las molestias. Haga click en Volver para ir a la página anterior.</span>
					<cfelse>
						<span lang="es">#objectError.description#</span>
					</cfif>

				</div>

			</div>
		</div>

		<cfif objectError.error_code EQ 403>

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Web" method="getWeb" returnvariable="getWebResult">
				<cfinvokeargument name="path" value="intranet">
			</cfinvoke>

			<cfset intranetQuery = getWebResult.query>

			<cfif intranetQuery.recordCount GT 0>

				<div class="row">
					<div class="col-sm-12">

						<div class="alert alert-info" role="alert">

							<i class="fa fa-info-circle"></i>

							<span lang="es">No dispones de acceso a las áreas de #APPLICATION.title#, pero sí dispones de acceso a la intranet.</span>

						</div>

					</div>
				</div>

				<div class="row">

					<div class="col-sm-12">
						<a href="#APPLICATION.path#/intranet/?abb=#SESSION.client_abb#" class="btn btn-sm btn-primary"><i class="fa fa-archive fa-inverse"></i> <span lang="es">Acceder a la intranet</span></a>
					</div>

				</div>

			</cfif>

		</cfif>

	</cfif>

</cfif>


<cfif NOT isDefined("URL.error_code") OR URL.error_code NEQ 403>

	<div class="row">

		<div class="col-sm-12">

			<div class="div_return">
				<a href="" onClick="history.go(-1); return false;" class="btn btn-default btn-sm"><i class="icon-arrow-left"></i> <span lang="es">Volver</span></a>
			</div>

		</div>

	</div>

</cfif>

</cfoutput>
<!-- InstanceEndEditable -->
	</div>

</div><!---END page-content-wrapper --->


	<!---</div>--->

</div>
<!--- END wrapper --->

</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>

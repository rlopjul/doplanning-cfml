<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_diseno_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#</title>
<!-- InstanceEndEditable -->

<cfinclude template="#APPLICATION.htmlPath#/includes/html_head.cfm">

<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
</cfoutput>
</head>

<body onBeforeUnload="onUnloadPage()" onLoad="onLoadPage()" class="body_global">
<!---divLoading--->
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_page_div.cfm">
<cfif APPLICATION.identifier NEQ "dp">
	<div class="div_header">
		<a href="../../html"><div class="div_header_content"><!-- --></div></a>
		<div class="div_separador_header"><!-- --></div>
	</div>
</cfif>

<!-- InstanceBeginEditable name="header" -->
<!-- InstanceEndEditable -->

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
	<!-- InstanceBeginEditable name="contenido" -->


<cfif isDefined("URL.abb")>

  <cfset client_abb = URL.abb>
  <cfset client_dsn = APPLICATION.identifier&"_"&client_abb>

  <!--- getClient --->
  <cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
    <cfinvokeargument name="client_abb" value="#client_abb#">
  </cfinvoke>

  <cfif clientQuery.recordCount GT 0>

    <!---check if is enabled client public registration--->

		<cfif clientQuery.public_user_registration IS 1>

			<cfif isDefined("URL.lang") AND listFind(APPLICATION.languages, URL.lang) GT 0>
				<cfset pageLang = URL.lang>
			<cfelse>
				<cfset pageLang = clientQuery.default_language>
			</cfif>

			<cfoutput>
			<script>
				$(function () {

					window.lang.change('#pageLang#');

				});
			</script>
			</cfoutput>

			<cfif isDefined("URL.res") AND URL.res IS true>

				<script>

					$(function () {

						if (window.parent == window.top) {
							window.parent.$("body").animate({scrollTop:0}, 'slow');
						}

					});

				</script>

				<div class="container">

					<div class="row">

						<div class="col-sm-12">

							<div class="alert alert-success" role="alert">

								<span lang="es">Usuario registrado.</span><br/><span lang="es">Para completar el registro deberá acceder al enlace que recibirá en su cuenta de correo para la validación de la misma.</span>

							</div>

						</div>

					</div>

					<!---<cfif isDefined("URL.abb")>
						<div class="row">

							<div class="col-sm-12">
								<cfoutput>
								<a href="#APPLICATION.path#/intranet/?abb=#URL.abb#" class="btn btn-sm btn-primary" target="_parent"> <span lang="es">Login</span></a>
								</cfoutput>
							</div>

						</div>
					</cfif>--->

				</div>

			<cfelse>

	    	<cfinclude template="#APPLICATION.corePath#/includes/user_registration.cfm">

			</cfif>


		<cfelse>

			<div class="container">

				<div class="row">

					<div class="col-sm-12">

						<div class="alert alert-warning" role="alert">

							<span lang="es">Registro de usuarios deshabilitado.</span>

						</div>

					</div>

				</div>

			</div>


		</cfif><!---END clientQuery.public_user_registration IS 1--->


  </cfif>


</cfif>


<!-- InstanceEndEditable -->
	<!---</div>--->

</div>
<!--- END wrapper --->

</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>

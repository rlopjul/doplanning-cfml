<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_diseno_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title# - Registro</title>
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


	<div class="container">

		<div class="row">

			<div class="col-sm-12">

			<cfif isDefined("URL.abb")>

			  <cfset client_abb = URL.abb>
			  <cfset client_dsn = APPLICATION.identifier&"_"&client_abb>

			  <!--- getClient --->
			  <cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
			    <cfinvokeargument name="client_abb" value="#client_abb#">
			  </cfinvoke>

			  <cfif clientQuery.recordCount GT 0>

					<cfif isDefined("URL.user") AND isDefined("URL.verification_code")>

						<cfinvoke component="#APPLICATION.componentsPath#/LoginManager" method="verifyUser" returnvariable="response">
							<cfinvokeargument name="user_id" value="#URL.user#">
							<cfinvokeargument name="verification_code" value="#URL.verification_code#">
							<cfinvokeargument name="client_abb" value="#client_abb#">
						</cfinvoke>

						<cfoutput>
						<cfif response.result IS true>

							<div class="alert alert-success" role="alert">
								<span lang="es">Usuario verificado correctamente. Puede acceder a la aplicación.</span>
							</div>

							<div class="row">

								<div class="col-sm-12">
									<cfoutput>
									<a href="#APPLICATION.path#/intranet/?abb=#URL.abb#" class="btn btn-sm btn-primary" target="_parent"> <span lang="es">Login</span></a>
									</cfoutput>
								</div>

							</div>

						<cfelse>

							<div class="alert alert-warning" role="alert">
								<span lang="es">#response.message#</span>
							</div>

						</cfif>
						</cfoutput>

					<cfelse>

						<div class="alert alert-danger" role="alert">
							<span lang="es">Parámetros incorrectos.</span>
						</div>

					</cfif>

			  </cfif>

			</cfif>

			</div>

		</div>

	</div>


<!-- InstanceEndEditable -->
	<!---</div>--->

</div>
<!--- END wrapper --->

</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>

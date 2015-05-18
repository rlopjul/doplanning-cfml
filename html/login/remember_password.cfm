<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_diseno_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<cfinclude template="#APPLICATION.corePath#/includes/remember_password_query.cfm">

<cfif NOT isDefined("URL.client_abb")>
	<cfif len(APPLICATION.path) GT 0>
		<cflocation url="#APPLICATION.path#" addtoken="no">
	<cfelse>
		<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
	</cfif>
<cfelse>
	<cfset client_abb = URL.client_abb>
</cfif>

<!---Aqu� se a�ade COLLATE utf8_bin para que sea case sensitive en la comparaci�n--->
<cfquery datasource="#APPLICATION.dsn#" name="getClient">
	SELECT *
	FROM app_clients
	WHERE abbreviation LIKE <cfqueryparam value="#client_abb#" cfsqltype="cf_sql_varchar"> COLLATE utf8_bin;
</cfquery>

<cfif getClient.recordCount IS 0>
	<cfif len(APPLICATION.path) GT 0>
		<cflocation url="#APPLICATION.path#" addtoken="no">
	<cfelse>
		<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
	</cfif>
</cfif>

<title>#APPLICATION.title#-#getClient.name#: obtener nueva contrase&ntilde;a</title>
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
		<a href="../../html/"><div class="div_header_content"><!-- --></div></a>
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
<cfoutput>
<div class="container"><!---login_container--->

	<div class="row">
	
		<!---<cfif APPLICATION.identifier EQ "dp">
			<div class="col-md-2">
				<div class="row">
					<div class="col-xs-6">
					<cfif APPLICATION.title EQ "DoPlanning">
						<a href="http://doplanning.net/" target="_blank"><img src="../assets/logo_inicio.gif" alt="DoPlanning" title="DoPlanning" /></a>
					</cfif>
					</div>
					<cfif APPLICATION.title EQ "DoPlanning">
					<div class="col-xs-6" style="text-align:right;">
						<a href="#APPLICATION.helpUrl#" target="_blank" title="Ayuda DoPlanning" class="visible-sm visible-xs" lang="es"><i class="icon-question-sign"></i></a>
					</div>
					</cfif>
				</div>
			</div>
		</cfif>--->
		
		
		<cfif APPLICATION.identifier EQ "dp">
		<div class="col-sm-offset-3 col-sm-5" style="text-align:right; padding-top:60px;">
			<img src="download_login_image.cfm?abb=#client_abb#" alt="Login Banner" />
		</div>
		</cfif>
		
		<!---<cfif APPLICATION.title EQ "DoPlanning" AND APPLICATION.identifier EQ "dp">
		<div class="col-md-2" style="text-align:right;">
			<a href="#APPLICATION.helpUrl#" target="_blank" title="Ayuda DoPlanning" class="hidden-sm hidden-xs" lang="es"><i class="icon-question-sign"></i></a>
		</div>
		</cfif>--->
		
	</div>

	<cfif APPLICATION.identifier EQ "dp">

	<div class="row">
		<div class="col-sm-offset-2 col-sm-6" style="text-align:center;padding-top:40px;padding-bottom:20px;">
			<cfoutput>
				<div class="page-header" style="text-align:left;">
					<h5 style="margin-bottom:0;color:##878787;font-size:17px;font-weight:100"><span lang="es">Obtener una nueva contrase&ntilde;a para #APPLICATION.title#</span> <strong>#getClient.name#</strong></h5>
				</div>
			</cfoutput>
		</div>
	</div>
	
	<div class="row">
		<div class="col-sm-offset-2 col-md-offset-3 col-sm-7 col-md-5">

			<cfinclude template="#APPLICATION.corePath#/includes/remember_password_form.cfm">
			
		</div>
	</div>

	</cfif>

</div>
</cfoutput>
<!-- InstanceEndEditable -->
	<!---</div>--->
	
</div>
<!--- END wrapper --->

</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
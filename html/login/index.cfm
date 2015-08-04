<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_diseno_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<cfinclude template="#APPLICATION.corePath#/includes/login_query.cfm">

<cfif NOT isDefined("URL.client_abb")>
	<cfif len(APPLICATION.path) GT 0>
		<cflocation url="#APPLICATION.path#" addtoken="no">
	<cfelse>
		<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
	</cfif>
<cfelse>
	<cfset client_abb = URL.client_abb>
</cfif>

<!---Aquí se añade COLLATE utf8_bin para que sea case sensitive en la comparación--->
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

<title><cfif APPLICATION.title NEQ getClient.name>#APPLICATION.title# - #getClient.name#<cfelse>#getClient.name#</cfif></title>
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

	<cfif isDefined("URL.logo")>
		<cfset show_logo = URL.logo>
	<cfelse>
		<cfset show_logo = true>
	</cfif>

	<cfif isDefined("URL.banner")>
		<cfset show_banner = URL.banner>
	<cfelse>
		<cfset show_banner = true>
	</cfif>

	<cfif isDefined("URL.help")>
		<cfset show_help = URL.help>
	<cfelse>
		<cfset show_help = true>
	</cfif>

	<cfif isDefined("URL.title")>
		<cfset show_title = URL.title>
	<cfelse>
		<cfset show_title = true>
	</cfif>

	

	<cfif show_logo OR show_banner OR show_help>
		
	<div class="row">
		
		<!---<cfif APPLICATION.identifier EQ "dp" AND show_logo>
			<div class="col-md-2">
				<div class="row">
					<div class="col-xs-6">
					<cfif APPLICATION.title EQ "DoPlanning">
						<a href="http://doplanning.net/" target="_blank"><img src="../assets/logo_inicio.gif" alt="DoPlanning" title="DoPlanning" /></a>
					</cfif>
					</div>
					<cfif APPLICATION.title EQ "DoPlanning" AND show_help>
					<div class="col-xs-6" style="text-align:right;">
						<a href="#APPLICATION.helpUrl#" target="_blank" title="Ayuda DoPlanning" class="visible-sm visible-xs" lang="es"><i class="icon-question-sign"></i></a>
					</div>
					</cfif>
				</div>
			</div>
		</cfif>--->

		
		<cfif APPLICATION.identifier EQ "dp" AND show_banner>
			<div class="col-sm-offset-3 col-sm-5" style="text-align:right; padding-top:60px;">
				<img src="download_login_image.cfm?abb=#client_abb#&v=3" alt="Login Banner" />
			</div>
		</cfif>

		
		<!---<cfif APPLICATION.title EQ "DoPlanning" AND show_help>
			<div class="col-md-2" style="text-align:right;">
				<a href="#APPLICATION.helpUrl#" target="_blank" title="Ayuda DoPlanning" class="hidden-sm hidden-xs" lang="es"><i class="icon-question-sign"></i></a>
			</div>
		</cfif>--->
		
	</div>

	</cfif>

	<cfif show_title IS true>
		<div class="row">
			<div class="col-sm-offset-2 col-sm-6" style="text-align:center;padding-top:40px;padding-bottom:20px;">
				<!---
				<cfif APPLICATION.identifier EQ "dp" >
					<cfif APPLICATION.title EQ "DoPlanning">
						<span lang="es">Acceso a DoPlanning</span> 
					</cfif><strong>#getClient.name#</strong>
				<cfelseif APPLICATION.identifier EQ "vpnet">
				Acceso a Colabora.
				</cfif>--->
				<cfoutput>
					<div class="page-header" style="text-align:left;">
					  <h5 style="margin-bottom:0;color:##878787;font-size:17px;font-weight:100">#getClient.app_title#</h5>
					</div>
				</cfoutput>
			</div>
		</div>
	</cfif>

	


  <cfif FindNoCase('MSIE',CGI.HTTP_USER_AGENT) GT 0 OR arrayLen(REMatch("Trident/7.*rv:11", CGI.HTTP_USER_AGENT)) GT 0>
    <div class="row">

    	<div class="col-sm-offset-2 col-sm-6">

		    <div class="alert alert-warning" role="alert">
		      <span lang="es">Para una mejor experiencia con DoPlanning recomendamos el uso de un navegador moderno distinto a Internet Explorer</span>
		    </div>

		</div>

	</div>
  </cfif>
	
	
	<cfif isDefined("URL.dpage")>
		<cfset destination_page = URLDecode(URL.dpage)>
	<cfelse>
		<cfset destination_page = "">
	</cfif>
	<div class="row">
		<div class="col-sm-offset-2 col-md-offset-3 col-sm-7 col-md-5">
		
		<!---<div class="div_login_form">--->
			<cfinclude template="#APPLICATION.corePath#/includes/login_form.cfm">
		<!---</div>--->

		</div>
	</div>


	<!---
	<cfif show_logo IS true AND APPLICATION.title EQ "DoPlanning" AND URL.client_abb NEQ "hcs">

		<div class="row">

			<div class="col-sm-offset-3 col-sm-6">

				<div class="panel panel-default" style="margin-top:35px;">
				  <div class="panel-body">
				    <h5>�Gracias por usar DoPlanning!. Tenemos el placer de comunicarte que DoPlanning ha sido nominado para los premios UP-Start 2014 como mejor herramienta web de trabajo colaborativo. </h5>
					<small><b>Puedes votar DoPlanning aqu� para que est� entre los 3 finalistas:</b><br/> 
		 			<a href="http://awards.up-con.com/2014/vote?page=3" target="_blank">http://awards.up-con.com/2014/vote?page=3</a></small><br/><br/>

		 			<small><a href="http://www.ideal.es/granada/201410/28/pyme-local-aspira-premio-20141027234437.html" target="_blank">Noticia en el peri�dico Ideal con la nominaci�n</a></small>
				  </div>
				</div>

			</div>

		</div>

	</cfif>
	--->

	<!---<div class="row">

		<div class="col-sm-offset-2 col-sm-6">

			<div class="panel panel-default" style="margin-top:35px;">
			  <div class="panel-body">
			    <h5 lang="es">¡Bienvenido a la nueva versión de DoPlanning!</h5>
				<p><span lang="es">Danos tu opinión a través del email</span> <a href="mailto:support@doplanning.net" onclick="showLoading = false">support@doplanning.net</a></b></p>
			  </div>
			</div>

		</div>

	</div>--->


</div>
</cfoutput>
<!-- InstanceEndEditable -->
	<!---</div>--->
	
</div>
<!--- END wrapper --->

</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
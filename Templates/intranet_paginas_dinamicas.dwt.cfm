<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es"><!-- InstanceBegin template="/Templates/intranet_basica_menu.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<cfsilent>
	<cfif APPLICATION.identifier EQ "dp"><!---DP--->
		<cfset clientAbb = "software7">
		<cfset rootAreaId = 233>
	<cfelse><!---ASNC--->
		<cfset clientAbb = "asnc">
		<cfset rootAreaId = 464>
	</cfif>
	<cfset clientDsn = APPLICATION.identifier&"_"&clientAbb>
	<cfset areaTypeRequired = "intranet">
	
	<cfset export = false>
</cfsilent>
<!-- InstanceBeginEditable name="nohtml" -->
<!-- TemplateBeginEditable name="nohtml" --><!-- TemplateEndEditable -->
<cfinclude template="../templates_pages/item_query.cfm">
<!-- InstanceEndEditable -->
<link rel="shortcut icon" href="../intranet/favicon.ico" /> 

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- InstanceBeginEditable name="doctitle" -->
@@(" ")@@
<cfoutput>
<title>#area_name# - Intranet ASNC</title>
</cfoutput>
<!-- InstanceEndEditable -->    

<script type="text/javascript" src="../Scripts/functions.js"></script>
<!-- InstanceBeginEditable name="head" --><!-- TemplateBeginEditable name="head" --><!-- TemplateEndEditable --><!-- InstanceEndEditable -->
<link rel="stylesheet" href="../styles.css" type="text/css" />
<link rel="stylesheet" href="../styles_menu.css" type="text/css" />
<!--Google Analytics-->
<!---<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', '']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>--->
</head>

<body class="body_intranet">
	<div id="centrado">
	<div id="contenedor">
		<div id="header_intranet">
			<div id="logos">
				<div id="logo_junta">
					<a href="http://www.juntadeandalucia.es/servicioandaluzdesalud" target="_blank"><img src="../assets/logo_sas.jpg" alt="Servicio Andaluz de Salud" title="Servicio Andaluz de Salud" /></a>
				</div><!--fin logo junta-->
				<div id="logo_asnc">
					<img src="../assets/logo_asnc_intranet.jpg" alt="Área Sanitaria Norte de Córdoba" title="Área Sanitaria Norte de Córdoba" />
				</div><!--fin logo asnc-->
			</div><!--fin logos-->
			
			
			
			<cfinclude template="#APPLICATION.path#/templates_pages/menu_intranet_content.cfm">
			
			<div id="contenedor_navegacion">
				<div id="navegacion_right">
				<cfif getFileFromPath(CGI.SCRIPT_NAME) NEQ "index.cfm"> 
				<cfoutput>
				<span>#getAuthUser()#</span> <a href="logout.cfm" class="link_min_verde">Salir</a>
				</cfoutput>
				</cfif>
				</div><!--navegacion right-->
				<div id="navegacion_left">
				<a href="index.cfm">Inicio</a> <!-- InstanceBeginEditable name="apartado_actual" -->
				@@("")@@
				<cfinclude template="../templates_pages/navigation_path.cfm">			
		<!-- InstanceEndEditable -->
				</div><!--navegacion left-->
			</div><!--fin contenedor navegacion-->
			
			
			
		</div><!--fin header-->
		<div id="wrapper">
		<!-- InstanceBeginEditable name="wrapper" -->
		@@("")@@
		<div id="apartados_left">
			<cfinclude template="../templates_pages/submenu_content.cfm">
		</div><!--fin apartados left-->
		
		<div id="apartados_right">
			<cfinclude template="../templates_pages/item_content.cfm">
		</div><!--fin apartados right-->
		<!-- InstanceEndEditable -->
		</div><!--fin wrapper-->
		<div id="contenedor_footer">
			
			
			<div id="footer">
				<div id="footer_left">
					Área Sanitaria Norte de Córdoba
				</div><!--fin footer left-->
				<div id="footer_right">
					<a href="../intranet/mapa_web.cfm">Mapa web</a> | <a href="../web/terminos_de_uso.cfm" target="_blank">Términos de uso</a>
				</div><!--fin footer right-->
			</div><!--fin footer-->
			
		</div><!--fin contenedor footer-->
	</div><!--fin contenedor-->
	</div><!--fin centrado -->
</body>
<!-- InstanceEnd --></html>

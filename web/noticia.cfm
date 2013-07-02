<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es"><!-- InstanceBegin template="/Templates/web_paginas_dinamicas.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<cfsilent>
	<cfif APPLICATION.identifier EQ "dp"><!---DP--->
		<cfset clientAbb = "software7">
		<cfset rootAreaId = 232>
	<cfelse><!---ASNC--->
		<cfset clientAbb = "asnc">
		<cfset rootAreaId = 491>
	</cfif>
	<cfset clientDsn = APPLICATION.identifier&"_"&clientAbb>
	<cfset areaTypeRequired = "web">
	
	<cfset export = false>
</cfsilent>

<!-- InstanceBeginEditable name="nohtml" -->
<cfset itemTypeId = 4>
<!-- InstanceEndEditable -->
<cfinclude template="../templates_pages/item_query.cfm">

<link rel="shortcut icon" href="favicon.ico" /> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

 
<cfoutput>
<title>#page_title# - ASNC</title>
</cfoutput>
    
<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
<link rel="stylesheet" href="../styles.css" type="text/css" />
<link rel="stylesheet" href="../styles_menu.css" type="text/css" />
<script type="text/javascript" src="../Scripts/functions.js"></script>
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

<body class="body_web">
	<div id="centrado">
	<div id="contenedor">
		<div id="header">
			<div id="logos">
				<div id="logo_junta">
					<a href="http://www.juntadeandalucia.es/servicioandaluzdesalud" target="_blank"><img src="../assets/logo_sas.jpg" alt="Servicio Andaluz de Salud" title="Servicio Andaluz de Salud" /></a>
				</div><!--fin logo junta-->
				<div id="logo_asnc">
					<img src="../assets/logo_asnc.jpg" alt="Área Sanitaria Norte de Córdoba" title="Área Sanitaria Norte de Córdoba" />
				</div><!--fin logo asnc-->
			</div><!--fin logos-->
			
			<!---Menú superior--->
			<cfinclude template="#APPLICATION.path#/templates_pages/menu_web_content.cfm">
				
			<div id="contenedor_navegacion">
				<div id="navegacion_right">
				<cfif getFileFromPath(CGI.SCRIPT_NAME) NEQ "index.cfm"> 
				<cfoutput>
				<span>#getAuthUser()#</span> <a href="logout.cfm" class="link_min_verde">Salir</a>
				</cfoutput>
				</cfif>
				</div><!--navegacion right-->
				<div id="navegacion_left">
				<a href="index.cfm">Inicio</a> 
				
				<cfinclude template="../templates_pages/navigation_path.cfm">
				
				</div><!--navegacion left-->
			</div><!--fin contenedor navegacion-->
			
			
		</div><!--fin header-->
		<div id="wrapper">
		
		
		<div id="apartados_left">
			<cfinclude template="../templates_pages/submenu_content.cfm">
		</div><!--fin apartados left-->
		
		<div id="apartados_right">
			<cfinclude template="../templates_pages/item_content.cfm">
		</div><!--fin apartados right-->
		
		</div><!--fin wrapper-->
		<div id="contenedor_footer">
			<div id="footer">
				<div id="footer_left">
					Área Sanitaria Norte de Córdoba
				</div><!--fin footer left-->
				<div id="footer_right">
					<a href="mapa_web.cfm">Mapa web</a> | <a href="terminos_de_uso.cfm">Términos de uso</a>
				</div><!--fin footer right-->
			</div><!--fin footer-->
		</div><!--fin contenedor footer-->
	</div><!--fin contenedor-->
	</div><!--fin centrado -->
</body>
<!-- InstanceEnd --></html>

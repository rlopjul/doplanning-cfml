<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es"><!-- InstanceBegin template="/Templates/web_basica.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
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
<!-- InstanceEndEditable -->
<link rel="shortcut icon" href="../web/favicon.ico" /> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- InstanceBeginEditable name="doctitle" -->
<title>Área Sanitaria Norte de Córdoba</title>
<!-- InstanceEndEditable -->    
<!-- InstanceBeginEditable name="head" --><!-- TemplateBeginEditable name="head" --><!-- TemplateEndEditable --><!-- InstanceEndEditable -->
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
				<a href="index.cfm">Inicio</a> <!-- InstanceBeginEditable name="apartado_actual" -->
		<!-- InstanceEndEditable -->
				</div><!--navegacion left-->
			</div><!--fin contenedor navegacion-->
			
			
		</div><!--fin header-->
		<div id="wrapper">
		<!-- InstanceBeginEditable name="wrapper" -->
		@@(" ")@@
		<cfoutput>
		<div id="home_left">
			<div class="box_border_sup"><img src="../assets/box_border_sup.jpg" alt="ASNC" title="ASNC" /></div>
			<div class="box_border_content">
				<p class="title_bold_14px">Síguenos en:</p><br />
				<table style="width:100%" border="0" title="Síguenos en" summary="Síguenos en Facebook, Twitter, RSS">
				  <tr>
					<td style="width:23%"><a href="https://www.facebook.com/pages/%C3%81rea-Sanitaria-Norte-de-C%C3%B3rdoba/464972406855637" target="_blank"><img src="../assets/facebook.jpg" alt="Facebook" title="Facebook" /></a></td>
					<td style="width:24%"><a href="https://twitter.com/agsnortecordoba" target="_blank"><img src="../assets/twitter.jpg" alt="Twitter" title="Twitter" /></a></td>
					<td style="width:44%"><a href="rss.cfm"><img src="../assets/rss.jpg" alt="RSS" title="RSS" /></a></td>
					<td style="width:9%">&nbsp;</td>
				  </tr>
				</table>

			</div>
			
			
			
			<!---Noticias--->
			<cfset newsAreaId = 498><!---ANSC--->
			<!---<cfset newsAreaId = 235>DP--->
			<cfinvoke component="#APPLICATION.componentsPath#/components/AreaItemQuery" method="getAreaItems" returnvariable="getAreaNewsResult">
				<cfinvokeargument name="area_id" value="#newsAreaId#">
				<cfinvokeargument name="itemTypeId" value="4">
				<cfinvokeargument name="format_content" value="all">
				<cfinvokeargument name="listFormat" value="true">
				<cfinvokeargument name="limit" value="2">
								
				<cfinvokeargument name="client_abb" value="#clientAbb#">
				<cfinvokeargument name="client_dsn" value="#clientDsn#">
			</cfinvoke>			
			<cfset newsQuery = getAreaNewsResult.query>
			
			<div class="box_border_bottom"><img src="../assets/box_border_bottom.jpg" alt="ASNC" title="ASNC" /></div>
		
			<div class="box_border_sup"><img src="../assets/box_border_sup.jpg" alt="ASNC" title="ASNC" /></div>
			<div class="box_border_content">
				<p><a href="page.cfm?id=#newsAreaId#&title=noticias" class="link_bold_14px">Noticias</a></p><br />
				
				<cfloop query="newsQuery">
				<cfset news_url = titleToUrl(newsQuery.title)>
				
				<p>#newsQuery.title#<br />
				<a href="noticia.cfm?id=#newsQuery.id#&title=#news_url#" class="link" title="#newsQuery.title#">Leer más</a></p><br />
				</cfloop>

			</div>
			<div class="box_border_bottom"><img src="../assets/box_border_bottom.jpg" alt="ASNC" title="ASNC" /></div>
			<div id="blogs">
					<p class="title_bold_14px_sub">Blogs:</p><br />
					<ul class="lista_contenidos">
						<li><a href="" class="link">Blog del Ciudadano</a></li>
						<li><a href="" class="link">Blog del Profesional</a></li>
					</ul>
				</div>
		</div><!--fin home left-->
		<div id="home_center">
		<!-- TemplateBeginEditable name="titulo_home" -->
		
		<!-- TemplateEndEditable -->
		<img src="../assets/anim_home.jpg" alt="ASNC" title="ASNC" />
		<!-- TemplateBeginEditable name="contenido_home" -->
		
		<!-- TemplateEndEditable -->
		</div><!--fin home center-->
		<div id="home_right">				
			<table style="width:100%" border="0" title="Intranet" summary="Acceso a la Intranet del ASNC">
			  <tr>
				<td style="width:53%">&nbsp;</td>
				<td style="width:15%"><a href="../intranet/"><img src="../assets/intranet.png" alt="Intranet" title="Intranet" /></a></td>
				<td style="width:32%"><a href="../intranet/" class="link_bold_14px">Intranet</a></td>
			  </tr>
			</table><br />				
			<a href=""><img src="../assets/oficina_virtual.jpg" alt="Oficina Virtual" title="Oficina Virtual" /></a><br /><br />
			<a href=""><img src="../assets/cita_medica.jpg" alt="Petición de Cita Médica" title="Petición de Cita Médica" /></a><br /><br />
			<a href="../asnc/"><img src="../assets/colabora.jpg" alt="Colabora" title="Colabora" /></a><br /><br />
			<a href=""><img src="../assets/area_sin_papeles.jpg" alt="Área sin papeles" title="Área sin papeles" /></a><br /><br />
			<a href="http://www.ivoox.com/perfil-a-g-sanitaria-norte-cordoba_aj_149022_1.html" target="_blank"><img src="../assets/podcast_asnc.jpg" alt="Podcast ASNC" title="Podcast ASNC" /></a><br /><br />
				
		</div><!--fin home right-->
		</cfoutput>
		<!-- InstanceEndEditable -->
		</div><!--fin wrapper-->
		<div id="contenedor_footer">
			<div id="footer">
				<div id="footer_left">
					Área Sanitaria Norte de Córdoba
				</div><!--fin footer left-->
				<div id="footer_right">
					<a href="../web/mapa_web.cfm">Mapa web</a> | <a href="../web/terminos_de_uso.cfm">Términos de uso</a>
				</div><!--fin footer right-->
			</div><!--fin footer-->
		</div><!--fin contenedor footer-->
	</div><!--fin contenedor-->
	</div><!--fin centrado -->
</body>
<!-- InstanceEnd --></html>

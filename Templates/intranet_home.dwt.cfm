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
<!-- InstanceBeginEditable name="nohtml" --><!-- InstanceEndEditable -->
<link rel="shortcut icon" href="../intranet/favicon.ico" /> 

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- InstanceBeginEditable name="doctitle" -->
<title>Intranet Área Sanitaria Norte de Córdoba</title>
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
		<!-- InstanceEndEditable -->
				</div><!--navegacion left-->
			</div><!--fin contenedor navegacion-->
			
			
			
		</div><!--fin header-->
		<div id="wrapper">
		<!-- InstanceBeginEditable name="wrapper" -->
		@@(" ")@@
		<cfinclude template="#APPLICATION.path#/templates_pages/udfs.cfm">
		
		<!---Obtiene todas las áreas de la intranet--->
		<!---<cfinvoke component="#APPLICATION.componentsPath#/components/AreaQuery" method="geSubAreasIds" returnvariable="areas_list">
			<cfinvokeargument name="area_id" value="#rootAreaId#">
			
			<cfinvokeargument name="client_abb" value="#clientAbb#">
			<cfinvokeargument name="client_dsn" value="#clientDsn#">
		</cfinvoke>
		
		<cfoutput>#areas_list#</cfoutput>--->
		
		
		<cfoutput>
		<div id="home_left_intranet">
		
			<!---Documentos--->
			<cfset documentsAreaId = 470>
			
			<!---Obtiene todas las áreas de documentos--->
			<cfinvoke component="#APPLICATION.componentsPath#/components/AreaQuery" method="geSubAreasIds" returnvariable="documentos_areas_list">
				<cfinvokeargument name="area_id" value="#documentsAreaId#">
				
				<cfinvokeargument name="client_abb" value="#clientAbb#">
				<cfinvokeargument name="client_dsn" value="#clientDsn#">
			</cfinvoke>
			
			<cfset documentos_areas_list = listAppend(documentos_areas_list, documentsAreaId)>
						
			<cfinvoke component="#APPLICATION.componentsPath#/components/FileQuery" method="getAreaFiles" returnvariable="filesQuery">
				<!---<cfinvokeargument name="area_id" value="#documentsAreaId#">--->
				<cfinvokeargument name="areas_ids" value="#documentos_areas_list#">
				<cfinvokeargument name="limit" value="2">
			
				<cfinvokeargument name="client_abb" value="#clientAbb#">
				<cfinvokeargument name="client_dsn" value="#clientDsn#">
			</cfinvoke>
			
			<div class="box_border_sup_intranet">
			Documentos
			</div>			
			<div class="box_border_content_intranet">
				<ul class="lista_box">
					<cfloop query="filesQuery">
					<li><a href="../intranet/download_file.cfm?file=#filesQuery.id#&area=#filesQuery.area_id#" class="link">#filesQuery.name#</a></li>
					</cfloop>
				</ul>
				<p style="text-align:right"><a href="page.cfm?id=#documentsAreaId#" class="link_min_verde">Ver más documentos</a></p>
			</div>
			<div class="box_border_bottom_intranet"><img src="../assets/box_border_bottom_intranet.jpg" alt="ASNC" title="ASNC" /></div>
			
			
			<!---Enlaces--->
			<cfset linksAreaId = 467>
			<div class="box_border_sup_intranet">
			Enlaces
			</div>
			<div class="box_border_content_intranet">
				<table width="95%" border="0" cellpadding="0" cellspacing="0" style="margin:0 auto;">
				  <tr>
					<td width="1%"></td>
					<td width="79%"><a href="http://10.72.32.8/modulosurls.php" class="link_bold_14px">Acceso aplicaciones ASNC y corporativa</a></td>
				  </tr>
				  <tr>
				    <td>&nbsp;</td>
				    <td>&nbsp;</td>
			      </tr>
				  <tr>
					<td></td>
					<td>
					
					<cfset secret_key = generateSecretKey("DESEDE")>
					<!---Hay que guardar el password encriptado en la sesión--->
					<form name="modulo_form" method="post" action="http://10.72.32.8/modulosauth.php">
						<input type="hidden" name="usr" value="#getAuthUser()#"/>
						<input type="hidden" name="pwd" value="#encrypt('pozoblanco','#secret_key#','DESEDE')#"/>					
					</form>
					
					<!---<cfset encrypted = encrypt('pozoblanco','#secret_key#','DESEDE')>
					#decrypt('#encrypted#', '#secret_key#', 'DESEDE')#--->
					<a onclick="document.modulo_form.submit();" class="link_bold_14px" style="cursor:pointer;">Modulos single sign-on</a>
					</td>
				  </tr>
				</table><br />
			
				<!---<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabla_enlaces_home">
				  <tr>
					<td width="45%"><a href=""><img src="../assets/historias_clinicas_digitalizadas.jpg" alt="Historias clínidas digitalizadas" title="Historias clínidas digitalizadas" /></a></td>
					<td width="5%">&nbsp;</td>
					<td width="45%"><a href=""><img src="../assets/notificacion_de_errores.jpg" alt="Notificación de errores de medicación" title="Notificación de errores de medicación" /></a></td>
				  </tr>
				  <tr>
					<td><a href="">Historias Clínicas Digitalizadas</a></td>
					<td>&nbsp;</td>
					<td><a href="">Notificación de errores de medicación</a></td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td><a href=""><img src="../assets/laboratorio_analisis_clinicos.jpg" alt="Laboratorio de Análisis Clínicos" title="Laboratorio de Análisis Clínicos" /></a></td>
					<td>&nbsp;</td>
					<td><a href=""><img src="../assets/acceso_a_acg.jpg" alt="Acceso a A.C.G" title="Acceso a A.C.G" /></a></td>
				  </tr>
				  <tr>
					<td><a href="">Laboratorio de Análisis Clínicos</a></td>
					<td>&nbsp;</td>
					<td><a href="">Acceso a A.C.G</a></td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td><a href=""><img src="../assets/sistema_informacion_radiologica.jpg" alt="Sistema de Información Radiológica" title="Sistema de Información Radiológica" /></a></td>
					<td>&nbsp;</td>
					<td><a href=""><img src="../assets/botiquines_primaria_vacunas.jpg" alt="Botiquines Primaria Vacunas" title="Botiquines Primaria Vacunas" /></a></td>
				  </tr>
				  <tr>
					<td><a href="">Sistema de Información Radiológica</a></td>
					<td>&nbsp;</td>
					<td><a href="">Botiquines Primaria Vacunas</a></td>
				  </tr>
				   <tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td><a href=""><img src="../assets/estacion_clinica_dae.jpg" alt="Estación Clínica DAE" title="Estación Clínica DAE" /></a></td>
					<td>&nbsp;</td>
					<td><a href=""><img src="../assets/acceso_dae_para_frutos.jpg" alt="Acceso Dae para FRUTOS" title="Acceso Dae para FRUTOS" /></a></td>
				  </tr>
				  <tr>
					<td><a href="">Estación Clínica DAE</a></td>
					<td>&nbsp;</td>
					<td><a href="">Acceso Dae para FUTROS</a></td>
				  </tr>
				</table><br />--->

				<p style="text-align:right"><a href="page.cfm?id=#linksAreaId#" class="link_min_verde">Ver más enlaces</a></p>
			</div>
			<div class="box_border_bottom_intranet"><img src="../assets/box_border_bottom_intranet.jpg" alt="ASNC" title="ASNC" /></div>
		
		</div><!--fin home left-->
		
		
		<!---Noticias--->
		<cfset newsAreaId = 465>
		<cfinvoke component="#APPLICATION.componentsPath#/components/AreaItemQuery" method="getAreaItems" returnvariable="getAreaNewsResult">
			<cfinvokeargument name="area_id" value="#newsAreaId#">
			<cfinvokeargument name="itemTypeId" value="4">
			<cfinvokeargument name="format_content" value="all">
			<cfinvokeargument name="listFormat" value="true">
			<cfinvokeargument name="limit" value="4">
							
			<cfinvokeargument name="client_abb" value="#clientAbb#">
			<cfinvokeargument name="client_dsn" value="#clientDsn#">
		</cfinvoke>
		<cfset newsQuery = getAreaNewsResult.query>		
		
		<div id="home_center_intranet">
			<p><a href="page.cfm?id=#newsAreaId#" class="link_16px">Últimas Noticias</a></p><br />
			
			<cfloop query="newsQuery">
				<div>
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
					  <tr>
						<cfif isNumeric(newsQuery.attached_image_id)><td width="16%"><img src="download_file.cfm?file=#newsQuery.attached_image_id#&news=#newsQuery.id#" width="108" /></td>
						<td width="2%">&nbsp;</td><td width="82%">
						<cfelse>
						<td>
						</cfif>
						<div class="text_date" style="background-color:##F5F5F5;">#DateFormat(newsQuery.creation_date,"dd/mm/yyyy")#</div>
						<a href="noticia.cfm?id=#newsQuery.id#" class="subtitle">#newsQuery.title#</a>
						<div style="font-size:12px; padding-top:1px;"><cfif len(newsQuery.description) GT 170>#leftToNextSpace(newsQuery.description, 170)#...<cfelse>#newsQuery.description#</cfif></div>
					
						</td>
					  </tr>
					</table>
					<p style="text-align:right"><a href="noticia.cfm?id=#newsQuery.id#" class="link_min">Leer noticia completa</a></p>
				</div>
				<div class="separador"></div>
			</cfloop>
			
			<!---<table width="100%" border="0">
			  <tr>
				<td width="16%"><img src="../assets/img1_min.jpg" /></td>
				<td width="2%">&nbsp;</td>
				<td width="82%"><p class="text_date">16/05/2012</p>
			<p class="subtitle">Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Integer a enim at mauris placerat iaculis.</p></td>
			  </tr>
			</table>
<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer a enim at mauris placerat iaculis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam elementum dictum posuere.</p>
			<p><a href="" class="link_min">Leer noticia completa</a></p>
			<div class="separador"></div>--->
			<p style="text-align:right;"><a href="page.cfm?id=#newsAreaId#" class="link_bold_14px_verde">Ver más noticias</a></p>
		</div><!--fin home center-->
		<div id="home_right_intranet">
			<div class="box_border_sup_intranet">
			Usuario Identificado
			</div>
			<cfoutput>
			<div class="box_border_content_intranet">
				<p>#getAuthUser()#</p>
				<p style="text-align:right"><a href="logout.cfm" class="link_min_verde">Salir</a></p>
			</div>
			</cfoutput>
			<div class="box_border_bottom_intranet"><img src="../assets/box_border_bottom_intranet.jpg" alt="ASNC" title="ASNC" /></div>
			
			<div class="box_border_sup_intranet">
			Servicios
			</div>
			<div class="box_border_content_intranet">
				<table width="95%" border="0" cellpadding="0" cellspacing="0" style="margin:0 auto;">
				  <tr>
					<td width="27%"><a href="../web/"><img src="../assets/web_publica.jpg" alt="Acceso a la web pública" title="Acceso a la web pública" /></a></td>
					<td width="11%">&nbsp;</td>
					<td width="62%"><a href="../web/" class="link_bold_14px">Acceso a la web pública</a></td>
				  </tr>
				  <tr>
				    <td>&nbsp;</td>
				    <td>&nbsp;</td>
				    <td>&nbsp;</td>
			      </tr>
				  <tr>
					<td><a href="../asnc/html/"><img src="../assets/colabora_intranet.jpg" alt="Colabora" title="Colabora" /></a></td>
					<td>&nbsp;</td>
					<td><a href="../asnc/html/" class="link_bold_14px">Colabora</a></td>
				  </tr>
				</table><br />
			</div>
			<div class="box_border_bottom_intranet"><img src="../assets/box_border_bottom_intranet.jpg" alt="ASNC" title="ASNC" /></div>
			
			
			<!---Eventos--->
			<cfset eventsAreaId = 466>
			<cfinvoke component="#APPLICATION.componentsPath#/components/AreaItemQuery" method="getAreaItems" returnvariable="getAreaEventsResult">
				<cfinvokeargument name="area_id" value="#eventsAreaId#">
				<cfinvokeargument name="itemTypeId" value="5">
				<cfinvokeargument name="format_content" value="all">
				<cfinvokeargument name="listFormat" value="true">
				<cfinvokeargument name="limit" value="2">
								
				<cfinvokeargument name="client_abb" value="#clientAbb#">
				<cfinvokeargument name="client_dsn" value="#clientDsn#">
			</cfinvoke>
			<cfset eventsQuery = getAreaEventsResult.query>	
			
			<div class="box_border_sup_intranet">
			Eventos
			</div>
			<div class="box_border_content_intranet">
				<cfloop query="eventsQuery">
				<p>
				<cfif eventsQuery.start_date NEQ eventsQuery.end_date>
				#DateFormat(eventsQuery.start_date,"dd/mm/yyyy")# - #DateFormat(eventsQuery.end_date,"dd/mm/yyyy")#
				<cfelse>
				#DateFormat(eventsQuery.start_date,"dd/mm/yyyy")#
				</cfif>
				<br />
<a href="evento.cfm?id=#eventsQuery.id#" class="link">#eventsQuery.title#</a></p><br />
				</cfloop>
<!---<p>Madrid, 26 de abril de 2012<br />
<a href="" class="link">Presentación informe “Diez temas
Candentes de la Sanidad Española
para 2012”</a></p><br />--->
				<p style="text-align:right"><a href="page.cfm?id=#eventsAreaId#" class="link_min_verde">Ver más eventos</a></p>
			</div>
			<div class="box_border_bottom_intranet"><img src="../assets/box_border_bottom_intranet.jpg" alt="ASNC" title="ASNC" /></div>
			
			
			
			
			<!---Formación--->
			<cfset formacionAreaId = 471>
			
			<!---Obtiene todas las áreas de formación--->
			<cfinvoke component="#APPLICATION.componentsPath#/components/AreaQuery" method="geSubAreasIds" returnvariable="formacion_areas_list">
				<cfinvokeargument name="area_id" value="#formacionAreaId#">
				
				<cfinvokeargument name="client_abb" value="#clientAbb#">
				<cfinvokeargument name="client_dsn" value="#clientDsn#">
			</cfinvoke>
			
			<cfset formacion_areas_list = listAppend(formacion_areas_list, formacionAreaId)>
						
			<cfinvoke component="#APPLICATION.componentsPath#/components/AreaItemQuery" method="getAreaItems" returnvariable="getAreaFormacionResult">
				<!---<cfinvokeargument name="area_id" value="#formacionAreaId#">--->
				<cfinvokeargument name="areas_ids" value="#formacion_areas_list#">
				<cfinvokeargument name="itemTypeId" value="2">
				<cfinvokeargument name="format_content" value="all">
				<cfinvokeargument name="listFormat" value="true">
				<cfinvokeargument name="limit" value="2">
								
				<cfinvokeargument name="client_abb" value="#clientAbb#">
				<cfinvokeargument name="client_dsn" value="#clientDsn#">
			</cfinvoke>
			<cfset formacionQuery = getAreaFormacionResult.query>	
			
			<div class="box_border_sup_intranet">
			Formación
			</div>
			<div class="box_border_content_intranet">
				<ul class="lista_box">
					<cfloop query="formacionQuery">
					<li><a href="page.cfm?id=#formacionQuery.area_id###entry-#formacionQuery.id#" class="link">#formacionQuery.title#</a></li>
					</cfloop>
				</ul>
				<p style="text-align:right"><a href="page.cfm?id=#formacionQuery.area_id#" class="link_min_verde">Ver más formación</a></p>
			</div>
			<div class="box_border_bottom_intranet"><img src="../assets/box_border_bottom_intranet.jpg" alt="ASNC" title="ASNC" /></div>
			
			
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
					<a href="../intranet/mapa_web.cfm">Mapa web</a> | <a href="../web/terminos_de_uso.cfm" target="_blank">Términos de uso</a>
				</div><!--fin footer right-->
			</div><!--fin footer-->
			
		</div><!--fin contenedor footer-->
	</div><!--fin contenedor-->
	</div><!--fin centrado -->
</body>
<!-- InstanceEnd --></html>

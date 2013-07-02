<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es"><!-- InstanceBegin template="/Templates/intranet_basica.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
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
<cfinclude template="#APPLICATION.htmlPath#/includes/login_query.cfm">
<!-- InstanceEndEditable -->
<link rel="shortcut icon" href="../favicon.ico" /> 
<!-- InstanceParam name="apartado" type="text" value="" -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- InstanceBeginEditable name="doctitle" -->
<title>Intranet Área Sanitaria Norte de Córdoba</title>
<!-- InstanceEndEditable -->    
<!-- InstanceBeginEditable name="head" -->
<style>
<!--
	.div_login_form
	{
		margin-top:30px;
		margin-left:180px;
	}
	
	.div_login_input
	{
		font-size:14px;
		color:#000000;
		margin-top:18px;
	}
	
	.div_login_submit
	{
		margin-top:18px;
	}
	
	.input_login
	{
		width:240px;
		font-size:16px;
	}
	
	.input_login_submit
	{
		width:90px;
		background-color:#8BA213;
		color:#FFFFFF;
		border-color:#CCCCCC;
		cursor:pointer;
		padding-top:1px;
		padding-bottom:1px;
	}
	.div_message_login
	{
		padding-left:10px;
		padding-top:20px;
		font-size:14px;
		color:#000000;
	}
-->
</style>
<script type="text/javascript" src="../../html/Scripts/functions.min.js"></script>
<script type="text/javascript" src="../../html/login/class.cod.min.js" ></script>
<script type="text/javascript">
// JavaScript Document
function codificarForm(form)
{ 
	form.password.readonly = true;
	<cfif APPLICATION.identifier EQ "dp">
		var password = form.password.value;
		form.password.value = "";
		var passwordcod = MD5.hex_md5(password);
		form.password.value = passwordcod;
	</cfif>
	return (true);
}
</script>
<!-- InstanceEndEditable -->
<link rel="stylesheet" href="../../styles.css" type="text/css" />
<link rel="stylesheet" href="../../styles_menu.css" type="text/css" />
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
					<a href="http://www.juntadeandalucia.es/servicioandaluzdesalud" target="_blank"><img src="../../assets/logo_sas.jpg" alt="Servicio Andaluz de Salud" title="Servicio Andaluz de Salud" /></a>
				</div><!--fin logo junta-->
				<div id="logo_asnc">
					<img src="../../assets/logo_asnc_intranet.jpg" alt="Área Sanitaria Norte de Córdoba" title="Área Sanitaria Norte de Córdoba" />
				</div><!--fin logo asnc-->
			</div><!--fin logos-->
			
			<!-- InstanceBeginEditable name="menu_content" -->
			
			
			
			<!-- InstanceEndEditable -->
			
		</div><!--fin header-->
		<div id="wrapper">
		<!-- InstanceBeginEditable name="wrapper" -->
		
		<cfif isDefined("URL.dpage")>
			<cfset destination_page = URLDecode(URL.dpage)>
		<cfelse>
			<cfset destination_page = APPLICATION.path&"/intranet/">
		</cfif>
		
		<div style="margin-left:180px; margin-top:8px; color:#0574A2">Introduzca su usuario y contraseña para acceder:</div>
		
		<cfset client_abb = clientAbb>
		<cfinclude template="#APPLICATION.htmlPath#/includes/login_form.cfm">
		
		<!-- InstanceEndEditable -->
		</div><!--fin wrapper-->
		<div id="contenedor_footer">
			<!-- InstanceBeginEditable name="foot_content" -->
			
			<!-- InstanceEndEditable -->
		</div><!--fin contenedor footer-->
	</div><!--fin contenedor-->
	</div><!--fin centrado -->
</body>
<!-- InstanceEnd --></html>

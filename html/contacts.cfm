<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#-Contactos</title>
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

	<!---<button type="button" class="hamburger is-closed" data-toggle="offcanvas">
		<span class="hamb-top"></span>
		<span class="hamb-middle"></span>
		<span class="hamb-bottom"></span>
	</button>--->
	
	<div class="container app_main_container">
		<!-- InstanceBeginEditable name="contenido_app" -->
<cfinclude template="includes/contacts_head.cfm">
<cfinclude template="includes/alert_message.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	<cfinvokeargument name="format_content" value="all">
</cfinvoke>

<div style="padding-top:5px; clear:both">

<cfoutput>

<cfif APPLICATION.identifier NEQ "dp"><!---En DoPlanning se deshabilitan los contactos--->
<div class="div_element_menu">
		<div class="div_icon_menus">
			<a href="contact_new.cfm"><img src="assets/icons/contact_new.png" alt="Nuevo Contacto" title="Nuevo Contacto" /></a></div>			
		<div class="div_text_menus"><a href="contact_new.cfm">Nuevo<br />contacto</a></div>
</div>
</cfif>

<form action="users.cfm" method="post">

<!---<div class="div_element_menu">
<div class="div_icon_menus"><input type="image" name="notification" src="assets/icons/notifications.gif" title="Enviar notificación a contactos seleccionados" /></div>
<div class="div_text_menus"><span class="span_text_menus">Enviar<br />notificación</span></div>

</div>--->
<cfif objectUser.sms_allowed IS true>
<div class="div_element_menu">
<div class="div_icon_menus"><input type="image" name="sms" src="assets/icons/sms.png" title="Enviar SMS a contactos seleccionados" /></div>
<div class="div_text_menus"><span class="span_text_menus">Enviar<br />SMS</span></div>
</div>
</cfif>
</cfoutput>

</div>

</div>

<cfset page_type = 2>
<cfinclude template="includes/users_list.cfm">

</form>
<cfset return_page = "index.cfm">
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>
<!-- InstanceEndEditable -->
	</div>

</div><!---END page-content-wrapper --->


	<!---</div>--->
	
</div>
<!--- END wrapper --->

</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#-Contacto</title>
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

	<div class="container app_main_container">
		<!-- InstanceBeginEditable name="contenido_app" -->
<cfif isDefined("URL.user")>
	<cfset contact_id = URL.user>
<cfelse>
	<cflocation url="contacts.cfm" addtoken="no">
</cfif>

<cfinclude template="includes/contacts_head.cfm">

<cfinclude template="includes/contact_head.cfm">

<cfoutput>
<div style="padding-top:5px;">

	<div class="div_element_menu">
		<div class="div_icon_menus"><a href="contact_modify.cfm?contact=#contact_id#"><img src="assets/icons/contact_modify.png" title="Modificar contacto" alt="Modificar" /></a></div>
		<div class="div_text_menus"><a href="contact_modify.cfm?contact=#contact_id#" class="text_menus">Modificar</a>			</div>
	</div>

	<div class="div_element_menu">
		<div class="div_icon_menus"><a href="#APPLICATION.htmlComponentsPath#/Contact.cfc?method=deleteContact&contact_id=#contact_id#"><img src="assets/icons/contact_delete.png" title="Eliminar contacto" alt="Eliminar contacto"/></a></div><div class="div_text_menus"><a href="#APPLICATION.htmlComponentsPath#/Contact.cfc?method=deleteContact&contact_id=#contact_id#"> <span class="texto_normal">Eliminar</span></a></div>
	</div>

</div>
</cfoutput>

<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Contact" method="selectContact" returnvariable="xmlResponse">
	<cfinvokeargument name="contact_id" value="#contact_id#">
</cfinvoke>

<cfxml variable="xmlContact">
	<cfoutput>
	#xmlResponse.response.result.contact#
	</cfoutput>
</cfxml>

<cfinvoke component="#APPLICATION.componentsPath#/ContactManager" method="objectContact" returnvariable="objectContact">
	<cfinvokeargument name="xml" value="#xmlContact.contact#">
	<cfinvokeargument name="return_type" value="object">
</cfinvoke>--->

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Contact" method="getContact" returnvariable="objectContact">
	<cfinvokeargument name="contact_id" value="#contact_id#">
</cfinvoke>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUser">
	<cfinvokeargument name="objectUser" value="#objectContact#">
</cfinvoke>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="returnElement">
		<cfinvokeargument name="return_page" value="contacts.cfm">
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
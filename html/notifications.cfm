<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#</title>
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
<cfset current_page = "notifications.cfm">
<cfinclude template="includes/notifications_head.cfm">
<cfinclude template="includes/alert_message.cfm">

<!---Send FORM to select users or select contacts--->
<cfif isDefined("FORM")>
	<cfif isDefined("FORM.submit")>
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Email" method="sendNotification" argumentcollection="#FORM#">
		</cfinvoke>
	<cfelse>
		
		<cfif isDefined("FORM.select_users.x")>
			<cfset selected_enc = URLEncodedFormat(FORM.recipients)>
			<cfset content_enc = URLEncodedFormat(FORM.content)>
			<cfset subject_enc = URLEncodedFormat(FORM.subject)>
			<cflocation url="select_users.cfm?page=#current_page#&sel=#selected_enc#&content=#content_enc#&subject=#subject_enc#" addtoken="no">
		<cfelseif isDefined("FORM.select_contacts.x")>
			<cfset selected_enc = URLEncodedFormat(FORM.recipients)>
			<cfset content_enc = URLEncodedFormat(FORM.content)>
			<cfset subject_enc = URLEncodedFormat(FORM.subject)>
			<cflocation url="select_contacts.cfm?page=#current_page#&sel=#selected_enc#&content=#content_enc#&subject=#subject_enc#" addtoken="no">
		</cfif>
	</cfif>
</cfif>

<cfset email_list = "">
<cfset content = "">
<cfset subject = "">

<cfif isDefined("URL.sel") AND len(URL.sel) GT 0>
	<cfset selected = URLDecode(URL.sel)>
	<cfset email_list = selected>
</cfif>

<cfinclude template="includes/get_selected_emails.cfm">

<cfif isDefined("URL.content")>
	<cfset content = URLDecode(URL.content)>
</cfif>
<cfif isDefined("URL.subject")>
	<cfset subject = URLDecode(URL.subject)>
</cfif>


<cfset email_list_enc = URLEncodedFormat(email_list)>

<!---<cfif len(users_ids) GT 0>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUsersEmails" returnvariable="users_emails">
		<cfinvokeargument name="users_ids" value="#users_ids#">
	</cfinvoke>
	
	<cfset email_list = users_emails>

</cfif>--->
<div class="contenedor_fondo_blanco">
<!--- <div class="div_send_message"> --->
	<cfoutput>
<form action="#current_page#" method="post">
	
	<div><span class="texto_normal">Para:</span>&nbsp;<input type="text" name="recipients" value="#email_list#">&nbsp;<input type="image" name="select_users" src="assets/icons_#APPLICATION.identifier#/users.gif" alt="Agregar usuarios" value="select_users" title="Seleccionar usuarios" />&nbsp;<input type="image" name="select_contacts" src="assets/icons_#APPLICATION.identifier#/contacts.gif" alt="Agregar contactos" value="select_contacts" title="Seleccionar contactos" /></div>
	

	<div><span class="texto_normal">Asunto:</span>&nbsp;<input type="text" name="subject" class="input-xxlarge" value="#subject#"></div>
    
    <div><textarea name="content" class="input-xxlarge">#content#</textarea></div>
    </cfoutput>
    <!---<div><cfinput type="file" name="Filedata"></div>--->
    
    <div><input type="submit" class="btn btn-primary" name="submit" value="Enviar"></div>
</form>
<!--- </div> END div_send_message --->

</div>
<cfif isDefined("URL.return_page") AND len(URL.return_page) GT 0>
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="returnElement">
		<cfinvokeargument name="return_page" value="#URL.return_page#">
	</cfinvoke>
</cfif>
<!-- InstanceEndEditable -->
	</div>

</div><!---END page-content-wrapper --->


	<!---</div>--->
	
</div>
<!--- END wrapper --->

</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
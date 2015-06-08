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

	<div class="container app_main_container">
		<!-- InstanceBeginEditable name="contenido_app" -->
<cfinclude template="includes/conversations_head.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Messenger" method="getMyConversations" returnvariable="xmlResponse">
</cfinvoke>

<cfinclude template="includes/alert_message.cfm">

<!---<cfoutput>
<textarea>
#xmlResponse#
</textarea>
</cfoutput>--->

<!---<div class="div_element_folder"><div style="float: left;"><img src="assets/icons/folder_grey.gif"></div><span class="text_file_name">Mis conversaciones guardadas</span></div>--->
<div style="padding-left: 10px; background:#fff;">

<cfoutput>
<cfloop index="xmlConversation" array="#xmlResponse.response.result.conversations.xmlChildren#">
	<div class="div_file">
		<!---<div class="div_img_file">---><a href="conversation_download.cfm?id=#xmlConversation.xmlAttributes.id#"><img src="assets/icons/file_download.gif" class="img_file"></a><!---</div>--->
		
		<div class="div_file_right">
			<div class="div_text_file_name"><a href="conversation_view.cfm?conversation=#xmlConversation.xmlAttributes.id#" class="text_item">#xmlConversation.name.xmlText#</a></div>
			<div class="div_text_file_email"></div>
			<div class="div_text_file_date">#xmlConversation.xmlAttributes.saved_date#</div><div class="div_text_file_size"></div>
		</div>
	</div>
</cfloop>
</cfoutput>

<!---<div class="div_file">
	<div class="div_img_file"><a href=""><img src="assets/icons/file_download.png" class="img_file"></a></div>
	
	<div class="div_file_right">

		<div class="div_text_file_name"><a href="" class="text_item">Conversación PRIVADA con Manuel Martín</a></div>
		<div class="div_text_file_email"></div>
		<div class="div_text_file_date">12-12-2008 12:30:20</div><div class="div_text_file_size">300 KB</div>
	</div>
</div>


<div class="div_file">
	<div class="div_img_file"><a href=""><img src="assets/icons/file_download.png" class="img_file"></a></div>
	
	<div class="div_file_right">

		<div class="div_text_file_name"><a href="" class="text_item">Conversación PRIVADA con Ramón Ramírez</a></div>
		<div class="div_text_file_email"></div>
		<div class="div_text_file_date">12-12-2008 12:30:20</div><div class="div_text_file_size">300 KB</div>
	</div>
</div>--->

</div>
	
		
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
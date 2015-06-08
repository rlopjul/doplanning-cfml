<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#</title>
<!-- InstanceEndEditable -->

<cfinclude template="#APPLICATION.htmlPath#/includes/html_head.cfm">


<!-- InstanceBeginEditable name="head" -->
<link href="styles/styles_messenger.css" rel="stylesheet" type="text/css" media="all" />
<!-- InstanceEndEditable -->
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
<cfif isDefined("URL.conversation") AND isValid("integer",URL.conversation)>
	<cfset conversation_id = URL.conversation>
<cfelse>
	<cflocation url="index.cfm">
</cfif>

<script type="text/javascript">

function confirmDeleteConversation()
{
	var message_delete = "¿Seguro que desea eliminar la conversación?";
	return confirm(message_delete);
}

</script>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Messenger" method="getConversation" returnvariable="xmlResponse">
	<cfinvokeargument name="conversation_id" value="#conversation_id#">
</cfinvoke>
<cfoutput>

<cfoutput>
<div class="div_head_menu">
	<div class="div_element_menu">
		<div class="div_icon_menus"><a href="conversation_download.cfm?id=#conversation_id#"><img src="assets/icons/file_download.png" title="Descargar conversación" alt="Descargar conversación"/></a></div>
		<div class="div_text_menus"><a href="conversation_download.cfm?id=#conversation_id#" class="text_menus"><br />Descargar</a></div>
	</div>
	<div class="div_element_menu">
		<div class="div_icon_menus"><a href="#APPLICATION.htmlComponentsPath#/Messenger.cfc?method=deleteConversation&conversation_id=#conversation_id#" onClick="return confirmDeleteConversation();"><img src="assets/icons_#APPLICATION.identifier#/delete_conversation.gif" title="Eliminar conversación" alt="Eliminar conversación" /></a></div>
		<div class="div_text_menus"><a href="#APPLICATION.htmlComponentsPath#/Messenger.cfc?method=deleteConversation&conversation_id=#conversation_id#" class="text_menus" onClick="return confirmDeleteConversation();"><br />Eliminar</a></div>
	</div>
	
</div>
</cfoutput>

<div class="div_file_page_name" style="clear:both; margin-top:0px;">
#xmlResponse.response.result.conversation.name.xmlText#
</div>

<div class="msg_conversation_area" id="conversationTextArea" name="conversationTextArea">#xmlResponse.response.result.conversation.text.xmlText#</div>
</cfoutput>

<cfset return_page = "saved_conversations.cfm">
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
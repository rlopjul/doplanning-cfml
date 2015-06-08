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

<!---UpdateFolder--->
<cfif isDefined("FORM.folder_id") AND isNumeric(FORM.folder_id)>
	
	<cfset folder_id = FORM.folder_id>
	<cfset name = FORM.name>
	<cfset description = FORM.description>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Folder" method="updateFolder" returnvariable="updateFolderResult">
		<cfinvokeargument name="folder_id" value="#folder_id#">
		<cfinvokeargument name="name" value="#name#">
		<cfinvokeargument name="description" value="#description#">
	</cfinvoke>

	<cfset msg = URLEncodedFormat(updateFolderResult.message)>
	<cfset res = updateFolderResult.result>
	
	<cfif res IS 1>
		<cflocation url="my_files.cfm?folder=#folder_id#&res=1&msg=#msg#" addtoken="no">
	<cfelse>
		<cflocation url="#CGI.SCRIPT_NAME#?folder=#folder_id#&res=1&msg=#msg#" addtoken="no">
	</cfif>

</cfif>




<cfif isDefined("URL.folder") AND isNumeric(URL.folder)>
	<cfset folder_id = URL.folder>
<cfelse>
	<cflocation url="my_files.cfm" addtoken="no"> 
</cfif>

<cfinclude template="includes/my_files_head.cfm">


<cfinvoke component="#APPLICATION.htmlComponentsPath#/Folder" method="getFolder" returnvariable="objectFolder">
	<cfinvokeargument name="folder_id" value="#folder_id#">
</cfinvoke>

<cfset return_page = "my_files.cfm?folder=#folder_id#">

<cfoutput>
<div class="div_element_folder"><div style="float:left;"><img src="#APPLICATION.htmlPath#/assets/icons/folder.png" /></div><span class="text_item">#objectFolder.name#</span></div>
</cfoutput>

<div class="div_head_subtitle">
Modificar carpeta</div>


<cfinclude template="includes/alert_message.cfm">


<cfoutput>
<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
	<input type="hidden" name="folder_id" value="#folder_id#" />
	<label>Nombre:</label>
	<input type="text" name="name" value="#objectFolder.name#" style="width:100%;"/>
	
	<label>Descripción:</label>
	<textarea name="description" style="width:100%;">#objectFolder.description#</textarea>
	
	<div><input type="submit" class="btn btn-primary" name="modify" value="Guardar" /></div>
</form>
</cfoutput>


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
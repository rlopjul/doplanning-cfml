<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/plantilla_app_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2012 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#</title>
<!-- InstanceEndEditable -->
</cfoutput>
<script type="text/javascript" src="../SpryAssets/includes/xpath.js"></script>
<script type="text/javascript" src="../SpryAssets/includes/SpryData.js"></script>
<script type="text/javascript" src="../SpryAssets/includes/SpryXML.js"></script>
<script type="text/javascript" src="../SpryAssets/includes/SpryDOMUtils.js"></script>
<cfif APPLICATION.moduleMessenger EQ "enabled">
<script type="text/javascript" src="../app/scripts/App.js"></script>
<script type="text/javascript" src="Scripts/MessengerControl.js"></script>
<cfif isDefined("SESSION.user_id")>
<script type="text/javascript">
window.onload = function ()
{
	Messenger.Private.initGetNewConversations();
}
</script>
</cfif>
</cfif>
<script type="text/javascript" src="Scripts/functions.js"></script>
<link href="styles.css" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "vpnet">
<link href="styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<!--using caps S (Screen), Pocket IE ignores it. Windows Mobile 6.1 ignores media="handled"-->  
<link href="styles_screen.css" rel="stylesheet" type="text/css" media="Screen" />
<link href="styles_mobiles.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 800px)" />
<!---<link href="../html/styles_mobiles.css" rel="stylesheet" type="text/css" media="handheld" />
<link href="../html/styles_iphone.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 480px)" />--->
<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
</head>

<body class="body_global">
<cfif APPLICATION.identifier NEQ "dp">
	<div class="div_header">
		<a href="../html/"><div class="div_header_content"><!-- --></div></a>
		<div class="div_separador_header"><!-- --></div>
	</div>
</cfif>

 
<cfoutput>
<cfif APPLICATION.identifier EQ "dp">
<div style="float:left; padding-top:2px;"><a href="index.cfm"><img src="assets/logo_app.gif" alt="Inicio" title="Inicio"/></a></div>
</cfif>
<div style="float:right">
	<div style="float:right; margin-right:5px; padding-top:2px;" class="div_text_user_logged">
		<a href="preferences.cfm" class="text_user_logged" title="Preferencias del usuario">#getAuthUser()#</a>&nbsp;&nbsp;&nbsp;<a href="logout.cfm" class="text_user_logged" title="Salir">Logout</a>
	</div> 
</div>
</cfoutput>

<div class="div_contenedor_contenido">
<!-- InstanceBeginEditable name="contenido" -->

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
<div class="div_element_folder"><div style="float:left;"><img src="#APPLICATION.htmlPath#/assets/icons/folder.png" /></div><span class="text_file_name">#objectFolder.name#</span></div>
</cfoutput>

<div class="div_head_subtitle">
Modificar carpeta</div>


<cfinclude template="includes/alert_message.cfm">


<cfoutput>
<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="form_preferences_user_data">
	<input type="hidden" name="folder_id" value="#folder_id#" />
	<div class="form_fila"><span class="texto_gris_12px">Nombre:</span><br />
	<input type="text" name="name" value="#objectFolder.name#" style="width:100%;"/></div>
	<div class="form_fila"><span class="texto_gris_12px">Descripción:</span><br /> 
	<textarea name="description" style="width:100%;">#objectFolder.description#</textarea></div>
	
	<div class="input_submit"><input type="submit" name="modify" value="Guardar" /></div>
</form>
</cfoutput>


<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>
<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
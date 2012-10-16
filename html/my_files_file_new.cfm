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
<!-- InstanceBeginEditable name="head" -->
<cfoutput>
<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
</cfoutput>
<!-- InstanceEndEditable -->
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
<cfif isDefined("URL.parent") AND isValid("integer",URL.parent)>
	<cfset parent_id = URL.parent>
<cfelse>
	<cflocation url="my_files.cfm" addtoken="no"> 
</cfif>

<cfinclude template="includes/my_files_head.cfm">
<cfinclude template="includes/alert_message.cfm">

<div class="div_head_subtitle">
Nuevo archivo</div>

<cfset return_page = "my_files.cfm?folder=#parent_id#">


<script type="text/javascript">

$(document).ready(function(){

	$('#formFile').change(function(e){
		$inputFile=$(this);
	  	  
     	var fileName = $inputFile.val();
		
	  	if(fileName.length > 0) {
		  fileName = fileName.substr(fileName.lastIndexOf('\\') + 1);
				  
		  if($('#formFileName').val().length == 0)
		  	$('#formFileName').val(fileName);
		}
		
	});
	
});

function onSubmitForm()
{
	if(check_custom_form())
	{
		document.getElementById("submitDiv").innerHTML = "Enviando...";

		return true;
	}
	else
		return false;
}
</script>

<cfoutput>

<cfform action="#APPLICATION.htmlPath#/my_files_upload_file.cfm?user_id=#SESSION.user_id#&client_abb=#SESSION.client_abb#&language=#SESSION.user_language#&folder_id=#parent_id#&session_id=#SESSION.SessionID#" method="post" class="form_preferences_user_data" enctype="multipart/form-data" name="file_form" onsubmit="return onSubmitForm();">
	
	<script type="text/javascript">
		var railo_custom_form=new RailoForms('file_form');
	</script>
	<script type="text/javascript" src="#APPLICATION.htmlPath#/Scripts/checkRailoForm.js"></script>
	
	<div class="form_fila"><span class="texto_gris_12px">Archivo:</span><br />
	<cfinput type="file" name="Filedata" value="" id="formFile" style="width:100%; height:23px;" required="yes" message="Debe seleccionar un archivo para subirlo"/></div>
	<div class="form_fila"><span class="texto_gris_12px">Nombre:</span><br />
	<cfinput type="text" name="name" value="" id="formFileName" style="width:100%;" required="yes" message="Debe especificar un nombre para el archivo"/></div>
	<div class="form_fila"><span class="texto_gris_12px">Descripción:</span><br /> 
	<textarea name="description" style="width:100%;"></textarea></div>
	
	<div class="input_submit" id="submitDiv"><input type="submit" name="modify" value="Guardar" /></div>
	<div class="texto_gris_12px" style="padding-top:2px; padding-bottom:2px">Una vez pulsado el botón, la solicitud tardará dependiendo del tamaño del archivo.</div>
</cfform>
</cfoutput>


<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>
<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
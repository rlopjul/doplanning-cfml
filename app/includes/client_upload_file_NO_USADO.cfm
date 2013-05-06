<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<script type="text/javascript" src="../../SpryAssets/includes/xpath.js"></script>
<script type="text/javascript" src="../../SpryAssets/includes/SpryData.js"></script>
<script type="text/javascript" src="../scripts/AppUploadFile.js"></script>
</head>

<body>
<div id="initState">
<cfoutput>
<!---<form action="#APPLICATION.htmlPath#/my_files_upload_file.cfm?user_id=#SESSION.user_id#&client_abb=#SESSION.client_abb#&language=#SESSION.user_language#&folder_id=1&session_id=#SESSION.SessionID#" method="post"  enctype="multipart/form-data" onsubmit="onSubmitForm();">
	<!---<input type="hidden" name="parent_id" value="#parent_id#" />--->
	<div class="form_fila"><span class="texto_gris_12px">Nombre:</span><br />
	<input type="text" name="name" value="" style="width:100%;"/></div>
	<div class="form_fila"><span class="texto_gris_12px">Archivo:</span><br />
	<input type="file" name="Filedata" value="" style="width:100%; height:23px;"/></div>
	<div class="form_fila"><span class="texto_gris_12px">Descripción:</span><br /> 
	<textarea name="description" style="width:100%;"></textarea></div>
	
	<div><input type="submit" name="modify" value="Guardar" /></div>
</form>--->
<form action="#APPLICATION.htmlPath#/my_files_upload_file.cfm?user_id=#SESSION.user_id#&client_abb=#SESSION.client_abb#&language=#SESSION.user_language#&folder_id=1&session_id=#SESSION.SessionID#" method="post" enctype="multipart/form-data" onsubmit="onSubmitForm();">
	<!---<input type="hidden" name="parent_id" value="#parent_id#" />--->
	<input type="hidden" id="nameInput" name="name" value="" style="width:100%;"/>
	<div class="form_fila"><span>Archivo:</span><br />
	<input type="file" name="Filedata" value="" style="width:100%; height:23px;"/></div>
	<input type="hidden" id="descriptionInput" name="description" value="" />	
	<div><input type="submit" name="modify" value="Guardar" /></div>
</form>
<button onclick="test()">Prueba</button>
</cfoutput>
</div>
<div id="uploadingState" style="display:none;">
Subiendo el archivo.
</div>
<script type="text/javascript">

/*function test()
{
	var flexApp;
	if (navigator.userAgent.indexOf("MSIE") != -1) {
		flexApp = window.parent.window["DPCore"];
	} else {
		flexApp = window.parent.document["DPCore"];
	}
 	//window.parent.prueba();
	var recibido = flexApp.pruebaJavaScript("Hola esto es una prueba desde el iframe JavaScript");
	alert(recibido);
}*/
function hola()
{
	alert("HOLA DESDE EL PADRE");
}
function test()
{
	//window.parent.prueba();
	App.UploadFile.setFile(1, "Nombre", "Description");
}
</script>
</body>
</html>
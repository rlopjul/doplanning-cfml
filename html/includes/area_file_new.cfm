<cfif isDefined("URL.area") AND isValid("integer",URL.area)>
	<cfset area_id = URL.area>
	<cfset return_page = "files.cfm?area=#area_id#">
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>
<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_head_subtitle">
Nuevo archivo</div>

<!---<cfset return_page = "area.cfm?area=#area_id#">--->


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

<div class="contenedor_fondo_blanco">

<cfoutput>

<cfform action="area_file_upload.cfm?user_id=#SESSION.user_id#&client_abb=#SESSION.client_abb#&language=#SESSION.user_language#&session_id=#SESSION.SessionID#" method="post" class="form_preferences_user_data" enctype="multipart/form-data" name="file_form" onsubmit="return onSubmitForm();">
	
	<script type="text/javascript">
		var railo_custom_form=new RailoForms('file_form');
	</script>
	<script type="text/javascript" src="#APPLICATION.htmlPath#/Scripts/checkRailoForm.js"></script>
	
	<input type="hidden" name="area_id" value="#area_id#"/>
	
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

</div>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>
<cfoutput>
<script src="#APPLICATION.htmlPath#/language/file_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>


<cfif isDefined("URL.area") AND isValid("integer",URL.area)>
	<cfset area_id = URL.area>
	<cfset return_page = "files.cfm?area=#area_id#">
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>
<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_head_subtitle"><span lang="es">Nuevo Archivo</span></div>

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
		document.getElementById("submitDiv").innerHTML = window.lang.convert("Enviando archivo...");

		return true;
	}
	else
		return false;
}
</script>

<div class="contenedor_fondo_blanco">

<cfoutput>

<cfform action="area_file_upload.cfm?user_id=#SESSION.user_id#&client_abb=#SESSION.client_abb#&language=#SESSION.user_language#&session_id=#SESSION.SessionID#" method="post" enctype="multipart/form-data" name="file_form" onsubmit="return onSubmitForm();">
	
	<script type="text/javascript">
		var railo_custom_form=new RailoForms('file_form');
	</script>
	<script type="text/javascript" src="#APPLICATION.htmlPath#/Scripts/checkRailoForm.js"></script>
	
	<input type="hidden" name="area_id" value="#area_id#"/>
	
	<label for="formFile" lang="es">Archivo:</label>
	<cfinput type="file" name="Filedata" value="" id="formFile" required="yes" message="Debe seleccionar un archivo para subirlo"/>
	
	<label for="formFileName" lang="es">Nombre:</label>
	<cfinput type="text" name="name" value="" id="formFileName" class="input-block-level" required="yes" message="Debe especificar un nombre para el archivo"/>
	
	<label for="description" lang="es">Descripción:</label> 
	<textarea name="description" id="description" class="input-block-level"></textarea>
	
	<div id="submitDiv"><input type="submit" class="btn btn-primary" name="modify" value="Enviar" lang="es"/></div>
	<small lang="es">Una vez pulsado el botón, la solicitud tardará dependiendo del tamaño del archivo.</small>
</cfform>

</cfoutput>

</div>
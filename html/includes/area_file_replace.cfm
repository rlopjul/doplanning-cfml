<cfif isDefined("URL.file") AND isValid("integer",URL.file) AND isDefined("URL.area") AND isValid("integer",URL.area)>
	<cfset file_id = URL.file>
	<cfset area_id = URL.area>
<cfelse>
	<cflocation url="area.cfm" addtoken="no"> 
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_head_subtitle">
Reemplazar archivo</div>

<cfset return_page = "area_file.cfm?area=#area_id#&file=#file_id#">

<script type="text/javascript">

function onSubmitForm()
{
	/*if(check_custom_form())
	{*/
		document.getElementById("submitDiv").innerHTML = "Enviando...";

		return true;
	/*}
	else
		return false;*/
}
</script>


<div class="contenedor_fondo_blanco">

<cfoutput>
<cfform action="area_file_replace_upload.cfm?user_id=#SESSION.user_id#&client_abb=#SESSION.client_abb#&language=#SESSION.user_language#&session_id=#SESSION.SessionID#" method="post" class="form_preferences_user_data" enctype="multipart/form-data" onsubmit="return onSubmitForm();">
	<input type="hidden" name="file_id" value="#file_id#" />
	<input type="hidden" name="area_id" value="#area_id#" />
	<!---<div class="form_fila"><span class="texto_gris_12px">Nombre:</span><br />
	<input type="text" name="name" value="" style="width:100%;"/></div>--->
	<div class="form_fila"><span class="texto_gris_12px">Archivo:</span><br />
	<cfinput type="file" name="Filedata" value="" style="width:100%; height:23px;" required="yes" message="Debe seleccionar un archivo"/></div>
	<!---<div class="form_fila"><span class="texto_gris_12px">Descripción:</span><br /> 
	<textarea name="description" style="width:100%;"></textarea></div>--->
	
	<div class="input_submit" id="submitDiv"><input type="submit" name="modify" value="Guardar" /></div>
	<div class="texto_gris_12px" style="padding-top:2px; padding-bottom:2px">Una vez pulsado el botón, la solicitud tardará dependiendo del tamaño del archivo.</div>
</cfform>
</cfoutput>


</div>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>
<cfoutput>
<script src="#APPLICATION.htmlPath#/language/file_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfif isDefined("URL.file") AND isValid("integer",URL.file) AND isDefined("URL.area") AND isValid("integer",URL.area)>
	<cfset file_id = URL.file>
	<cfset area_id = URL.area>
<cfelse>
	<cflocation url="area.cfm" addtoken="no"> 
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_head_subtitle"><span lang="es">Reemplazar Archivo</span></div>

<cfset return_page = "file.cfm?area=#area_id#&file=#file_id#">

<script type="text/javascript">

function onSubmitForm()
{
	/*if(check_custom_form())
	{*/
		document.getElementById("submitDiv").innerHTML =  window.lang.convert("Enviando...");

		return true;
	/*}
	else
		return false;*/
}
</script>


<div class="contenedor_fondo_blanco">

<cfoutput>
<cfform action="area_file_replace_upload.cfm?user_id=#SESSION.user_id#&client_abb=#SESSION.client_abb#&language=#SESSION.user_language#&session_id=#SESSION.SessionID#" method="post" enctype="multipart/form-data" onsubmit="return onSubmitForm();">
	<input type="hidden" name="file_id" value="#file_id#" />
	<input type="hidden" name="area_id" value="#area_id#" />

	<label lang="es">Archivo:</label>
	<cfinput type="file" name="Filedata" value="" required="yes" message="Debe seleccionar un archivo"/>
	
	<div style="height:12px;"></div>
	
	<div id="submitDiv"><input type="submit" class="btn btn-primary" name="modify" value="Guardar" lang="es"/>
	
	<a href="#return_page#" class="btn" style="float:right;" lang="es">Cancelar</a>	
	</div>
	<small lang="es">Una vez pulsado el botón, la solicitud tardará dependiendo del tamaño del archivo.</small>
</cfform>
</cfoutput>


</div>

<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>--->
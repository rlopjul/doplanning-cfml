<cfinclude template="#APPLICATION.htmlPath#/includes/area_file_replace_query.cfm">

<cfoutput>
<script src="#APPLICATION.htmlPath#/language/file_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<div class="div_head_subtitle"><span lang="es"><cfif fileTypeId IS 3>Subir nueva versión de<cfelse>Reemplazar</cfif> Archivo</span></div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

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
<cfform action="#CGI.SCRIPT_NAME#?file=#file_id#&fileTypeId=#fileTypeId#&area=#area_id#" method="post" enctype="multipart/form-data" onsubmit="return onSubmitForm();">
	<input type="hidden" name="file_id" value="#file_id#" />
	<input type="hidden" name="area_id" value="#area_id#" />

	<div class="form-group">
		<label lang="es"><cfif fileTypeId IS 3>Nueva versión de archivo:<cfelse>Archivo a reemplazar:</cfif></label>
		<span>#file.name#</span>
	</div>

	<div class="form-group">
		<label lang="es">Archivo:</label>
		<cfinput type="file" name="Filedata" value="" required="yes" message="Debe seleccionar un archivo"/>
	</div>

	<cfif fileTypeId IS NOT 1>
		
		<div class="checkbox">
		    <label>
		    	<input type="checkbox" name="unlock" value="true" checked> Desbloquear archivo tras subir nueva versión
		    </label>
	  	</div>

	</cfif>
	
	<div style="height:12px;"></div>
	
	<div id="submitDiv"><input type="submit" class="btn btn-primary" name="modify" value="Guardar" lang="es"/>
	
	<a href="#return_page#" class="btn btn-default" style="float:right;" lang="es">Cancelar</a>	
	</div>
	<small lang="es">Una vez pulsado el botón, la solicitud tardará dependiendo del tamaño del archivo.</small>
</cfform>
</cfoutput>


</div>

<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>--->
<cfif isDefined("URL.file") AND isValid("integer",URL.file) AND isDefined("URL.area") AND isValid("integer",URL.area)>
	<cfset file_id = URL.file>
	<cfset area_id = URL.area>
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_head_subtitle">
Modificar archivo</div>

<cfset return_page = "area_file.cfm?area=#area_id#&file=#file_id#">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
	<cfinvokeargument name="file_id" value="#file_id#">
</cfinvoke>

<script type="text/javascript">

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

<cfform action="#APPLICATION.htmlComponentsPath#/File.cfc?method=updateFileRemote" method="post" class="form_preferences_user_data" name="file_form" onsubmit="return onSubmitForm();">
	
	<script type="text/javascript">
		var railo_custom_form=new RailoForms('file_form');
	</script>
	<script type="text/javascript" src="#APPLICATION.htmlPath#/Scripts/checkRailoForm.js"></script>

	<input type="hidden" name="file_id" value="#file_id#" />
	<input type="hidden" name="area_id" value="#area_id#" />
	<input type="hidden" name="return_path" value="#return_path#" />
	<div class="form_fila"><span class="texto_gris_12px">Nombre:</span><br />
	<cfinput type="text" name="name" value="#objectFile.name#" style="width:100%;" required="yes" message="Debe introducir un nombre de archivo"/></div>
	<!---<div class="form_fila"><span class="texto_gris_12px">Archivo:</span><br />
	<input type="file" name="Filedata" value="" style="width:100%; height:23px;"/></div>--->
	<div class="form_fila"><span class="texto_gris_12px">Descripción:</span><br /> 
	<textarea name="description" style="width:100%;">#objectFile.description#</textarea></div>
	
	<div class="input_submit" id="submitDiv"><input type="submit" name="modify" value="Guardar" /></div>
</cfform>
</cfoutput>

</div>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>
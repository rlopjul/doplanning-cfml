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

<div class="div_head_subtitle">
<span lang="es">Modificar Archivo</span></div>

<cfset return_page = "file.cfm?area=#area_id#&file=#file_id#">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
	<cfinvokeargument name="file_id" value="#file_id#">
</cfinvoke>

<script type="text/javascript">

function onSubmitForm()
{
	if(check_custom_form())
	{
		document.getElementById("submitDiv").innerHTML = window.lang.convert("Enviando...");

		return true;
	}
	else
		return false;
}

</script>

<div class="contenedor_fondo_blanco">

<cfoutput>

<cfform action="#APPLICATION.htmlComponentsPath#/File.cfc?method=updateFileRemote" method="post" name="file_form" onsubmit="return onSubmitForm();">
	
	<script type="text/javascript">
		var railo_custom_form=new RailoForms('file_form');
	</script>
	<script type="text/javascript" src="#APPLICATION.htmlPath#/Scripts/checkRailoForm.js"></script>

	<input type="hidden" name="file_id" value="#file_id#" />
	<input type="hidden" name="area_id" value="#area_id#" />
	<input type="hidden" name="return_path" value="#return_path#" />
	<label for="name" lang="es">Nombre:</label>
	<cfinput type="text" name="name" id="name" value="#objectFile.name#" class="input-block-level" required="yes" message="Debe introducir un nombre de archivo"/>

	<label for="description" lang="es">Descripción:</label> 
	<textarea name="description" id="description" class="input-block-level">#objectFile.description#</textarea>
	
	<div id="submitDiv"><input type="submit" class="btn btn-primary" name="modify" value="Guardar" lang="es"/>
	
	<a href="#return_page#" class="btn" style="float:right;" lang="es">Cancelar</a>
	</div>
</cfform>
</cfoutput>

</div>

<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>--->
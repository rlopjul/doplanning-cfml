<cfinclude template="#APPLICATION.htmlPath#/includes/area_file_replace_query.cfm">

<!---
<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput> --->


<cfset itemTypeId = 10>
<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<div class="div_head_subtitle"><span lang="es"><cfif fileTypeId IS 3>Subir nueva versión de<cfelse>Reemplazar</cfif> Archivo</span></div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfset return_page = "file.cfm?area=#area_id#&file=#file_id#">

<script type="text/javascript">

function onSubmitForm()
{
	/*if(check_custom_form())
	{*/
		document.getElementById("submitDiv").innerHTML =  window.lang.translate("Enviando...");

		return true;
	/*}
	else
		return false;*/
}
</script>


<div class="contenedor_fondo_blanco">

<cfoutput>
<cfform action="#CGI.SCRIPT_NAME#?file=#file_id#&fileTypeId=#fileTypeId#&area=#area_id#" method="post" enctype="multipart/form-data" class="form-horizontal" onsubmit="return onSubmitForm();">
	<input type="hidden" name="file_id" value="#file_id#" />
	<input type="hidden" name="area_id" value="#area_id#" />

	<div class="row">
		<div class="col-sm-12">
			<label lang="es"><cfif fileTypeId IS 3>Nueva versión de archivo:<cfelse>Archivo a reemplazar:</cfif></label>
			<span>#objectFile.name#</span>
		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">
			<label lang="es" id="filedata">Nuevo Archivo:</label>
			<cfinput type="file" name="Filedata" id="filedata" value="" required="yes" message="Debe seleccionar un archivo"/>
		</div>
	</div>

	<cfif fileTypeId IS NOT 1>

		<cfif fileTypeId IS 3>

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getLastFileVersion" returnvariable="lastVersion">
				<cfinvokeargument name="file_id" value="#file_id#"/>
				<cfinvokeargument name="fileTypeId" value="#fileTypeId#"/>
			</cfinvoke>

			<cfif isNumeric(lastVersion.version_index)>
				<cfset version_index_value = lastVersion.version_index+1>
			<cfelse>
				<cfset version_index_value = "">
			</cfif>

			<div class="row">
				<div class="col-sm-12" style="padding-top:8px;">
					<label lang="es" for="version_index">Número de versión</label>
				</div>
		  	</div>
		  	<div class="row">
				<div class="col-sm-1 col-xs-3">
					<cfinput type="text" name="version_index" id="version_index" value="#version_index_value#" required="false" validate="integer" message="Debe introducir un valor numérico para el número de versión" class="form-control" />
				</div>
			</div>
		</cfif>

		<div class="row">
			<div class="col-sm-12">
				<div class="checkbox">
				    <label>
				    	<input type="checkbox" name="unlock" value="true" checked> Desbloquear archivo tras subir nueva versión
				    </label>
			  	</div>
			</div>
		</div>

	</cfif>

	<div class="row">
		<div class="col-md-12">

			<div class="checkbox">
				<label>
					<input type="checkbox" name="no_notify" id="no_notify" value="true" <cfif isDefined("objectFile.no_notify") AND objectFile.no_notify IS true>checked="checked"</cfif> /><span lang="es"> NO enviar notificación por email</span>
				</label>
				<small class="help-block" lang="es">Si selecciona esta opción no se enviará notificación instantánea por email de esta acción a los usuarios.</small>
			</div>

		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">
			<div style="height:12px;"></div>
		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">

			<div id="submitDiv"><input type="submit" class="btn btn-primary" name="modify" value="Guardar" lang="es"/>

				<a href="#return_page#" class="btn btn-default" style="float:right;" lang="es">Cancelar</a>
			</div>

		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">

			<small lang="es">Una vez pulsado el botón, la solicitud tardará dependiendo del tamaño del archivo.</small>

		</div>
	</div>

</cfform>
</cfoutput>


</div>

<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>--->

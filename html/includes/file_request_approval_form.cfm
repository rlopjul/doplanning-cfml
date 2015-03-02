<cfif isDefined("FORM.page")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="requestRevision" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>	

	<cfif actionResponse.result IS true>

		<cfset file_id = actionResponse.file_id>
		
		<cfset msg = URLEncodedFormat(actionResponse.message)>
		
		<cflocation url="area_items.cfm?area=#area_id#&file=#file_id#&res=1&msg=#msg#" addtoken="no">
			
	<cfelse>
		
		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset newUser = FORM>

	</cfif>

<cfelse>

	<cfif isDefined("URL.file") AND isNumeric(URL.file)>
		<cfset file_id = URL.file>
	<cfelse>
		<cflocation url="empty.cfm" addtoken="no">
	</cfif>

</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="file">
	<cfinvokeargument name="file_id" value="#file_id#">
</cfinvoke>

<cfset area_id = file.area_id>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFileVersions" returnvariable="fileVersionsResult">
	<cfinvokeargument name="file_id" value="#file_id#">
	<cfinvokeargument name="fileTypeId" value="#file.file_type_id#">
</cfinvoke>

<cfset versions = fileVersionsResult.fileVersions>

<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<div class="div_head_subtitle"><span lang="es">Solicitar aprobación de documento</span></div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfoutput>

<script type="text/javascript">

	function onSubmitForm() {

		if(check_custom_form())	{
			document.getElementById("submitDiv").innerHTML = window.lang.translate("Enviando...");

			return true;
		}
		else
			return false;
	}

</script>

<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>

<div class="contenedor_fondo_blanco">

<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data" name="file_form" onsubmit="return onSubmitForm();">
	
	<script type="text/javascript">
		var railo_custom_form=new LuceeForms('file_form');
	</script>
	
	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#" />
	<input type="hidden" name="file_id" value="#file_id#" />
	<input type="hidden" name="area_id" value="#area_id#"/>

	<div class="form-group">
		<span>Nombre del archivo:</span>
		<strong>#file.name#</strong>
	</div>

	<div class="form-group">
		<span>Fecha de versión:</span>
		<strong>#versions.uploading_date#</strong>
	</div>

	<div class="form-group">
		<span>Usuario revisor:</span>
		<strong>#file.reviser_user_full_name#</strong>
	</div>

	<div class="form-group">
		<span>Usuario aprobador:</span>
		<strong>#file.approver_user_full_name#</strong>
	</div>

	<p class="help-block" style="font-size:12px;">
		Proceso de aprobación:<br/>
		1º Se enviará el archivo al usuario revisor.<br/>
		2º El usuario revisor debe validar el documento.<br/>
		3º Si el usuario revisor valida el documento, se envía el documento al usuario aprobador.<br/>
		4º El usuario aprobador debe validar el documento.<br/>
		Si el documento no es validado por el revisor o el aprobador, se debe iniciar de nuevo el proceso de aprobación con una nueva versión del archivo.
	</p>
	
	<div style="height:10px;"><!--- ---></div>

	<div id="submitDiv">
		<input type="submit" class="btn btn-primary" name="modify" value="Iniciar proceso de aprobación" lang="es"/>

		<a href="file.cfm?file=#file_id#&area=#area_id#" class="btn btn-default" style="float:right">Cancelar</a>
	</div>

</cfform>

</div>

</cfoutput>
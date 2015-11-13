<!---
page_type

1 reject revision
2 reject approval
--->

<cfif isDefined("FORM.page")>

	<cfif page_type IS 1>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="rejectRevisionFileVersion" argumentcollection="#FORM#" returnvariable="actionResponse">
		</cfinvoke>

	<cfelse>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="rejectApproveFileVersion" argumentcollection="#FORM#" returnvariable="actionResponse">
		</cfinvoke>

	</cfif>

<cfelse>

	<cfif isDefined("URL.file") AND isNumeric(URL.file) AND isDefined("URL.fileTypeId") AND isNumeric(URL.fileTypeId) AND isDefined("URL.area") AND isNumeric(URL.area) AND isDefined("URL.return_path")>
		<cfset file_id = URL.file>
		<cfset fileTypeId = URL.fileTypeId>
		<cfset area_id = URL.area>
		<cfset return_path = URL.return_path>
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

<!---
<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput> --->


<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<div class="div_head_subtitle"><span lang="es">Rechazar <cfif page_type IS 1>validación<cfelse>aprobación</cfif> de versión de archivo</span></div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfoutput>

<script>

	function onSubmitForm() {

		if(check_custom_form())	{
			document.getElementById("submitDiv").innerHTML = window.lang.translate("Enviando...");

			return true;
		}
		else
			return false;
	}

</script>

<script src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>

<div class="contenedor_fondo_blanco">

<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data" name="file_form" onsubmit="return onSubmitForm();">

	<script>
		var railo_custom_form;

		if( typeof LuceeForms !== 'undefined' && $.isFunction(LuceeForms) )
			railo_custom_form = new LuceeForms('file_form');
		else
			railo_custom_form = new RailoForms('file_form');
	</script>

	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#" />
	<input type="hidden" name="file_id" value="#file_id#" />
	<input type="hidden" name="fileTypeId" value="#fileTypeId#" />
	<input type="hidden" name="valid" value="false" />
	<input type="hidden" name="area_id" value="#area_id#"/>
	<input type="hidden" name="return_path" value="#return_path#"/>

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

	<cfif page_type IS 1>
		<cfset result_input = "revision_result_reason">
	<cfelse>
		<cfset result_input = "approval_result_reason">
	</cfif>

	<div class="form-group">
		<label for="#result_input#">Motivo de rechazo de <cfif page_type IS 1>validación<cfelse>aprobación</cfif> de versión:</label>
		<textarea name="#result_input#" id="#result_input#" required="true" style="height:160px;" class="form-control"></textarea>
		<script type="text/javascript">
			addRailoRequiredTextInput("#result_input#", "Campo 'Motivo de rechazo' obligatorio");
		</script>
	</div>


	<div style="height:10px;"><!--- ---></div>

	<div id="submitDiv">
		<button type="submit" class="btn btn-primary"><span lang="es">Rechazar versión</span></button>

		<a href="file.cfm?file=#file_id#&area=#area_id#" class="btn btn-default" style="float:right">Cancelar</a>
	</div>

</cfform>

</div>

</cfoutput>

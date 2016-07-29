<cfinclude template="#APPLICATION.htmlPath#/includes/file_change_user_query.cfm">

<!---
<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput> --->


<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<div class="div_head_subtitle"><span lang="es">Cambiar propietario del archivo</span></div>

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

	function openUserSelector(){

		 return openPopUp('#APPLICATION.mainUrl##APPLICATION.htmlPath#/iframes/area_users_select.cfm?area=#area_id#');
	}

	var curUserId = null;

	function setSelectedUser(userId, userName) {

		if( isNaN(curUserId) || curUserId != userId) {
			document.getElementById("new_user_in_charge").value = userId;
			document.getElementById("new_user_full_name").value = userName;
		} else {
			alert("Debe seleccionar un propietario distinto al actual");
		}

	}

</script>

<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="contenedor_fondo_blanco">

<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data" name="file_form" class="form-horizontal" onsubmit="return onSubmitForm();">

	<script>
		var railo_custom_form;

		if( typeof LuceeForms !== 'undefined' && $.isFunction(LuceeForms) )
			railo_custom_form = new LuceeForms('file_form');
		else
			railo_custom_form = new RailoForms('file_form');
	</script>

	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#" />
	<input type="hidden" name="files_ids" value="#files_ids#"/>
	<input type="hidden" name="area_id" value="#area_id#"/>

	<cfloop list="#files_ids#" index="file_id">

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="file">
			<cfinvokeargument name="file_id" value="#file_id#">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="outputFileSmall">
			<cfinvokeargument name="fileQuery" value="#file#">
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfinvoke>

		<cfif listLen(files_ids) IS 1>
			<script>
				curUserId = "#file.user_in_charge#";
			</script>
		</cfif>

	</cfloop>

	<div class="row">
		<div class="col-xs-12 col-sm-6">
			<label class="control-label" for="new_user_full_name" lang="es">Nuevo propietario</label>
			<input type="hidden" name="new_user_in_charge" id="new_user_in_charge" value="#newUser.new_user_in_charge#" validate="integer" required="true"/>
			<cfinput type="text" name="new_user_full_name" id="new_user_full_name" value="#newUser.new_user_full_name#" readonly="true" required="true" message="Debe seleccionar un nuevo propietario" onclick="openUserSelector()" class="form-control" /> <button onclick="return openUserSelector()" class="btn btn-default" lang="es">Seleccionar usuario</button>
		</div>
	</div>

	<div style="height:10px;"><!--- ---></div>

	<div id="submitDiv">
		<input type="submit" class="btn btn-primary" name="modify" value="Cambiar propietario" lang="es"/>

		<cfif listLen(files_ids) IS 1>
			<a href="file.cfm?file=#files_ids#&area=#area#" class="btn btn-default" style="float:right" lang="es">Cancelar</a>
		<cfelse>
			<a href="files.cfm?area=#area#" class="btn btn-default" style="float:right" lang="es">Cancelar</a>
		</cfif>

	</div>

	<br/>
	<small class="help-block" lang="es">Se enviará notificación por email del cambio al nuevo propietario y al anterior.</small>
</cfform>

</div>

</cfoutput>

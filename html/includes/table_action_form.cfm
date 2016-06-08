<!---page_types
1 Create new action
2 Modify action
--->

<cfinclude template="#APPLICATION.htmlPath#/includes/table_action_form_query.cfm">

<cfset return_page = "#tableTypeName#_actions.cfm?#tableTypeName#=#table_id#">

<cfset url_return_path = "&return_path="&URLEncodedFormat(return_path&return_page)>

<cfoutput>
<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" />

<!---<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-select/bootstrap-select.min.js"></script>
<link rel="stylesheet" href="#APPLICATION.htmlPath#/bootstrap/bootstrap-select/bootstrap-select.min.css">--->

<cfinclude template="#APPLICATION.htmlPath#/includes/summernote_scripts.cfm">

<script src="#APPLICATION.htmlPath#/scripts/tablesFunctions.js?v=2.2"></script>

<script>

	function confirmDeleteAction() {

		var message_delete = "¿Seguro que desea eliminar la acción definitivamente?";
		return confirm(window.lang.translate(message_delete));
	}

	function onSubmitForm(){

		document.getElementById("submitDiv1").innerHTML = 'Enviando...';
		document.getElementById("submitDiv2").innerHTML = 'Enviando...';

		return true;
	}


	function actionTypeChange(typeId){


	}

	$(document).ready(function() {

		actionTypeChange(#action.action_type_id#);

		<cfif isDefined("action.list_area_id") AND isNumeric(action.list_area_id)>
			loadAreaList(#action.list_area_id#, '#action.default_value#');
		</cfif>

		$('##action_content').summernote({
			height: "300px"

			, disableDragAndDrop: true,
			maximumImageFileSize: 1,
			toolbar: [
			    ['style', ['style']],
			    ['font', ['bold', 'italic', 'underline', 'superscript', 'subscript', 'clear']],
			    ['fontname', ['fontname']],
			    ['color', ['color']],
			    ['para', ['ul', 'ol', 'paragraph']],
			    ['height', ['height']],
			    ['table', ['table']],
			    ['insert', ['link', 'picture', 'hr']],
			    ['view', ['fullscreen']],
			    ['help', ['help']]
			    <!---, ['misc', ['emoji']]--->
			  ]
			<cfif SESSION.user_language EQ "es">
				, lang: 'es-ES'
			</cfif>
		});
	});
</script>
</cfoutput>

<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

<!---Table actions types--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Action" method="getActionTypes" returnvariable="typesResult">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset actionTypesStruct = typesResult.actionTypes>

<cfset actionTypesArray = structSort(actionTypesStruct, "numeric", "ASC", "position")>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="contenedor_fondo_blanco">
<cfoutput>
<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="form-horizontal" onsubmit="return onSubmitForm();">

	<div id="submitDiv1" style="margin-bottom:10px;">
		<input type="submit" value="Guardar" class="btn btn-primary" lang="es"/>

		<cfif page_type IS 2>
			<span class="divider">&nbsp;&nbsp;</span>

			<a href="#APPLICATION.htmlComponentsPath#/Action.cfc?method=deleteActionRemote&action_id=#action_id#&tableTypeId=#tableTypeId##url_return_path#" onclick="return confirmDeleteAction();" title="Eliminar campo" class="btn btn-danger btn-sm" lang="es"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>
		</cfif>

		<a href="#return_page#" class="btn btn-default" style="float:right;" lang="es">Cancelar</a>
	</div>
	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#"/>
	<input type="hidden" name="table_id" value="#table_id#"/>
	<input type="hidden" name="tableTypeId" value="#tableTypeId#"/>
	<!---<input type="hidden" name="return_path" value="#return_path#"/>--->

	<cfif page_type IS 2>
		<input type="hidden" name="action_id" value="#action.action_id#"/>
	</cfif>

	<div class="row">
		<div class="col-md-12">
			<label for="title" class="control-label"><span lang="es">Título</span> *</label>
			<cfinput type="text" name="title" id="title" value="#action.title#" maxlength="255" required="true" message="Título requerido" class="form-control"/>
		</div>
	</div>

	<div class="row">
		<div class="col-md-12">
			<cfif page_type IS 2>
				<input name="action_type_id" type="hidden" value="#action.action_type_id#"/>
			</cfif>
			<label for="action_type_id" class="control-label"><span lang="es">Tipo</span> *</label>
			<select name="action_type_id" id="action_type_id" class="form-control" onchange="actionTypeChange($('##action_type_id').val());" <cfif page_type IS 2>disabled</cfif>>
				<cfloop array="#actionTypesArray#" index="actionTypeId">
					<option value="#actionTypesStruct[actionTypeId].id#" lang="es" <cfif isDefined("action.action_type_id") AND action.action_type_id IS actionTypesStruct[actionTypeId].id>selected="selected"</cfif>>#actionTypesStruct[actionTypeId].label#</option>
				</cfloop>
			</select>
			<small class="help-block" lang="es">No se puede modificar el tipo una vez creada la acción</small>
		</div>
	</div>

	<div class="row">
		<div class="col-md-12">
			<label for="action_event_type_id" class="control-label"><span lang="es">Evento que lanza la acción</span> *</label>
			<select name="action_event_type_id" id="action_event_type_id" class="form-control">
				<option value="1" <cfif isDefined("action.action_event_type_id") AND action.action_event_type_id IS 1>selected</cfif> lang="es">Nuevo registro rellenado en #tableTypeNameEs#</option>
				<cfif tableTypeId IS 1>
					<option value="2" <cfif isDefined("action.action_event_type_id") AND action.action_event_type_id IS 2>selected</cfif> lang="es">Registro modificado en #tableTypeNameEs#</option>
				</cfif>
				<option value="3" <cfif isDefined("action.action_event_type_id") AND action.action_event_type_id IS 3>selected</cfif> lang="es">Registro eliminado en #tableTypeNameEs#</option>

				<cfif isDefined("action.action_event_type_id") AND action.action_event_type_id IS 4><!---Esta opción no está habilitada para ser seleccionada por el usuario--->
					<option value="4" <cfif isDefined("action.action_event_type_id") AND action.action_event_type_id IS 4>selected</cfif> lang="es">Acción iniciada por usuario responsable de #itemTypeNameEs#</option>
				</cfif>

			</select>
			<small class="help-block" lang="es">Se realizará la acción cuando ocurra este evento</small>
		</div>
	</div>


	<!---Table fields--->
	<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTableFields" returnvariable="getTableFieldsResponse">
		<cfinvokeargument name="table_id" value="#table_id#">
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		<cfinvokeargument name="with_types" value="true">
	</cfinvoke>

	<cfif getTableFieldsResponse.result IS false>
		<cfthrow message="#getTableFieldsResponse.message#">
	</cfif>

	<cfset fields = getTableFieldsResponse.tableFields>


	<cfif page_type IS 2>

		<!---Action fields--->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Action" method="getActionFields" returnvariable="getActionFieldsResponse">
			<cfinvokeargument name="action_id" value="#action.action_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<cfset actionFields = getActionFieldsResponse.actionFields/>

	</cfif>


	<cfset fieldEmail = false>

	<div class="row">
		<div class="col-md-12">
			<label for="action_field_id" class="control-label"><span lang="es">Campo <cfif tableTypeGender EQ "male">del<cfelse>de la</cfif> #tableTypeNameEs# con la dirección de email</span> *</label>
			<select name="action_field_id" id="action_field_id" class="form-control" required>

				<option value=""></option>

				<cfloop query="fields">
					<cfif fields.field_type_id EQ 17>
						<cfset fieldEmail = true>
						<option value="#fields.field_id#" <cfif isDefined("actionFields") AND actionFields.recordCount GT 0 AND actionFields.field_id IS fields.field_id>selected</cfif>>#fields.label#</option>
					</cfif>
				</cfloop>

			</select>
			<cfif fieldEmail IS false>
				<div class="alert alert-warning" role="alert">
				  <span lang="es">Necesita definir un campo del tipo Email para poder crear esta acción</span>
				</div>
			<cfelse>
				<small class="help-block" lang="es">Sólo están disponibles para seleccionar los campos del tipo Email</small>
			</cfif>

		</div>
	</div>

	<div class="row">
		<div class="col-md-12">
			<label for="action_subject" class="control-label"><span lang="es">Asunto del email</span> *</label>
			<cfinput type="text" name="action_subject" id="action_subject" value="#action.action_subject#" maxlength="255" required="true" message="Asunto requerido" class="form-control"/>
		</div>
	</div>

	<div class="row">
		<div class="col-md-12">
			<label for="action_content" class="control-label"><span lang="es">Contenido del email</span> *</label>
			<textarea name="action_content" id="action_content" class="form-control" style="height:200px;">#action.action_content#</textarea>
			<small class="help-block" lang="es">Si aplicas formato al contenido del email, el aspecto que visualizará el usuario podrá variar dependiendo de su cliente de correo.</small>
		</div>
	</div>

	<div id="submitDiv2" style="margin-top:20px;">
		<input type="submit" value="Guardar" class="btn btn-primary" lang="es"/>
		<!---<a href="area_items.cfm?area=#area_id#" class="btn btn-default">Cancelar</a>--->

		<a href="#return_page#" class="btn btn-default" style="float:right;" lang="es">Cancelar</a>
	</div>

</cfform>
</cfoutput>
</div>

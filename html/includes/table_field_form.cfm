<!---page_types
1 Create new field
2 Modify field
--->

<cfinclude template="#APPLICATION.htmlPath#/includes/table_field_form_query.cfm">

<cfset return_page = "#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#">

<cfset url_return_path = "&return_path="&URLEncodedFormat(return_path&return_page)>

<cfoutput>
<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>

<script type="text/javascript" src="#APPLICATION.htmlPath#/bootstrap/bootstrap-select/bootstrap-select.min.js"></script>
<link rel="stylesheet" type="text/css" href="#APPLICATION.htmlPath#/bootstrap/bootstrap-select/bootstrap-select.min.css">

<script type="text/javascript">

	function confirmDeleteField() {
	
		var message_delete = "Si ELIMINA el campo, se borrarán definitivamente todos los contenidos que almacena. ¿Seguro que desea eliminar el campo?";
		return confirm(message_delete);
	}

	function onSubmitForm(){

		var typeId = $('##field_type_id').val();

		if(typeId == 9 || typeId == 10){

			var selectedAreaid = $('##list_area_id').val();
			if(!$.isNumeric(selectedAreaid)){
				alert("Debe seleccionar un área para generar la lista");
				return false;
			}

		}

		document.getElementById("submitDiv1").innerHTML = 'Enviando...';
		document.getElementById("submitDiv2").innerHTML = 'Enviando...';

		return true;
	}

	function openAreaSelector(){
		
		return openPopUp('#APPLICATION.htmlPath#/iframes/area_select.cfm');
		
	}

	function setSelectedArea(areaId, areaName) {
		
		$("##list_area_id").val(areaId);
		$("##list_area_name").val(areaName);

		loadAreaList(areaId, 1)
			
	}

	function loadAreaList(areaId, selectedValue) {

		if(!isNaN(areaId)){

			showLoadingPage(true);

			var areaListPage = "#APPLICATION.htmlPath#/html_content/area_list_input_options.cfm?area="+areaId;

			if(!isNaN(selectedValue)){
				areaListPage = areaListPage+"&selected="+selectedValue;
			}

			$("##default_value_list").load(areaListPage, function() {

				showLoadingPage(false);

				//$('.selectpicker').selectpicker('refresh');
			});

		} else {

			$("##default_value_list").empty();
		}
	}


	function fieldTypeChange(typeId){

		if(typeId == 6){ //Date

			//$("##requiredContainer").show();

			$("##textDefaultValue").hide();
			$("##dateDefaultValue").show();
			$("##booleanDefaultValue").hide();
			$("##listDefaultValue").hide();
			$("##listAreaSelector").hide();

			$("##default_value_text").prop('disabled', true);
			$("##default_value_date").prop('disabled', false);
			$("##default_value_boolean").prop('disabled', true);
			$("##default_value_list").prop('disabled', true);
			$("##list_area_id").prop('disabled', true);

		}else if(typeId == 7){ //Boolean

			$("##textDefaultValue").hide();
			$("##dateDefaultValue").hide();
			$("##booleanDefaultValue").show();
			$("##listDefaultValue").hide();
			$("##listAreaSelector").hide();

			$("##default_value_text").prop('disabled', true);
			$("##default_value_date").prop('disabled', true);
			$("##default_value_boolean").prop('disabled', false);
			$("##default_value_list").prop('disabled', true);
			$("##list_area_id").prop('disabled', true);

		}else if(typeId == 9 || typeId ==10){ //List

			$("##textDefaultValue").hide();
			$("##dateDefaultValue").hide();
			$("##booleanDefaultValue").hide();
			$("##listDefaultValue").show();
			$("##listAreaSelector").show();

			$("##default_value_text").prop('disabled', true);
			$("##default_value_date").prop('disabled', true);
			$("##default_value_boolean").prop('disabled', true);
			$("##default_value_list").prop('disabled', false);
			$("##list_area_id").prop('disabled', false);

		}else {

			$("##textDefaultValue").show();
			$("##dateDefaultValue").hide();
			$("##booleanDefaultValue").hide();
			$("##listDefaultValue").hide();
			$("##listAreaSelector").hide();

			$("##default_value_text").prop('disabled', false);
			$("##default_value_date").prop('disabled', true);
			$("##default_value_boolean").prop('disabled', true);
			$("##default_value_list").prop('disabled', true);
			$("##list_area_id").prop('disabled', true);

			if(typeId == 2 || typeId == 3){

				$("##default_value_text").attr("rows", '4');

			}else{

				$("##default_value_text").attr("rows", '1');
			}

		}
	}

	function enableDatePicker(selector){

		$(selector).datepicker({
		  format: 'dd-mm-yyyy', 
		  autoclose: true,
		  weekStart: 1,
		  language: 'es',
		  todayBtn: 'linked'
		});
	}

	$(document).ready(function() { 

		fieldTypeChange(#field.field_type_id#);

		enableDatePicker('##default_value_date');

		<cfif isDefined("field.list_area_id") AND isNumeric(field.list_area_id)>
			loadAreaList(#field.list_area_id#, '#field.default_value#');
		</cfif>

		//$('.selectpicker').selectpicker();
	});
</script>
</cfoutput>

<!---Table fields types--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Field" method="getFieldTypes" returnvariable="typesResult">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset fieldTypes = typesResult.fieldTypes>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="contenedor_fondo_blanco">
<cfoutput>
<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="form-inline" onsubmit="return onSubmitForm();">

	<div id="submitDiv1" style="margin-bottom:10px;">
		<input type="submit" value="Guardar" class="btn btn-primary"/>

		<cfif page_type IS 2>
			<span class="divider">&nbsp;&nbsp;</span>

			<a href="#APPLICATION.htmlComponentsPath#/Field.cfc?method=deleteFieldRemote&field_id=#field_id#&tableTypeId=#tableTypeId##url_return_path#" onclick="return confirmDeleteField();" title="Eliminar campo" class="btn btn-danger btn-small"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>
		</cfif>
	</div>
	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#"/>
	<input type="hidden" name="table_id" value="#table_id#"/>
	<input type="hidden" name="tableTypeId" value="#tableTypeId#"/>
	<!---<input type="hidden" name="return_path" value="#return_path#"/>--->

	<cfif page_type IS 2>
		<input type="hidden" name="field_id" value="#field.field_id#"/>
	</cfif>

	<div class="control-group">
		<label for="label">Nombre *</label>
		<cfinput type="text" name="label" id="label" value="#field.label#" maxlength="100" required="true" message="Nombre requerido" class="span5"/>
	</div>

	<div class="control-group">
		<cfif page_type IS 2>
			<input name="field_type_id" type="hidden" value="#field.field_type_id#"/>
		</cfif>
		<label for="field_type_id">Tipo *</label>
		<select name="field_type_id" id="field_type_id" class="span5" onchange="fieldTypeChange($('##field_type_id').val());" <cfif page_type IS 2>disabled="disabled"</cfif>>
			<cfloop query="fieldTypes">
				<option value="#fieldTypes.field_type_id#" <cfif field.field_type_id IS fieldTypes.field_type_id>selected="selected"</cfif>>#fieldTypes.name#</option>
			</cfloop>
		</select>
		<small class="help-block">No se puede modificar el tipo una vez creado el campo.</small>
	</div>

	<div class="control-group" id="listAreaSelector">
		<cfif isDefined("field.list_area_id") AND isNumeric(field.list_area_id)>
			<!--- getArea --->
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="listArea">
				<cfinvokeargument name="area_id" value="#field.list_area_id#">
			</cfinvoke>
			<cfset list_area_name = listArea.name>
		<cfelse>
			<cfset list_area_name = "">
		</cfif>
		<label for="default_value_text">Área a para generar la lista</label>
		<div class="controls">
			<input type="hidden" name="list_area_id" id="list_area_id" value="#field.list_area_id#" />
			<cfinput type="text" name="list_area_name" id="list_area_name" value="#list_area_name#" readonly="true" onclick="openAreaSelector()" /> <button onclick="return openAreaSelector()" type="button" class="btn" lang="es">Seleccionar área</button>
		</div>
	</div>

	<div class="control-group">
		<label for="required" class="checkbox" id="requiredContainer">
			<input type="checkbox" name="required" id="required" value="true" <cfif isDefined("field.required") AND field.required IS true>checked="checked"</cfif> /> Obligatorio<br/>
		</label>
		<small class="help-block">Indica si el campo deber rellenarse de forma obligatoria</small>
	</div>

	<div class="control-group">
		<label for="description">Descripción</label>
		<textarea name="description" id="description" class="input-block-level" maxlength="1000">#field.description#</textarea>
	</div>

	<div class="control-group" id="textDefaultValue">
		<label for="default_value_text">Valor por defecto</label>
		<textarea name="default_value" id="default_value_text" class="input-block-level" maxlength="1000" rows="4" <cfif field.field_type_id IS 6 OR field.field_type_id IS 7>disabled="disabled"</cfif>>#field.default_value#</textarea>
	</div>
	<div class="control-group" id="dateDefaultValue">
		<label for="default_value_date">Valor por defecto</label>
		<input type="text" name="default_value" id="default_value_date" value="#field.default_value#" maxlength="10" class="input_datepicker" <cfif field.field_type_id NEQ 6>disabled="disabled"</cfif>/> <span class="help-inline">Fecha formato DD-MM-AAAA</span>
	</div>
	<div class="control-group" id="booleanDefaultValue">
		<label for="default_value_boolean">Valor por defecto</label>
		<select name="default_value" id="default_value_boolean" class="input-small" <cfif field.field_type_id NEQ 7>disabled="disabled"</cfif>>
			<option value=""></option>
			<option value="0" <cfif field.default_value IS false>selected="selected"</cfif>>No</option>
			<option value="1" <cfif field.default_value IS true>selected="selected"</cfif>>Sí</option>
		</select>
	</div>

	<div class="control-group" id="listDefaultValue">
		<label for="default_value_boolean">Valor por defecto</label>
		<select name="default_value" id="default_value_list" class="selectpicker span5" <cfif field.field_type_id NEQ 9 OR field.field_type_id NEQ 10>disabled="disabled"</cfif>><!---multiple---></select>
	</div>
	

	<!---<label for="position">Posición</label>
	<cfinput type="text" name="position" id="position" value="#field.position#" required="true" validate="integer" message="Posición debe ser un número entero" style="width:50px;">--->

	<div id="submitDiv2" style="margin-top:20px;">
		<input type="submit" value="Guardar" class="btn btn-primary"/>
		<!---<a href="area_items.cfm?area=#area_id#" class="btn">Cancelar</a>--->
	</div>
	
</cfform>
</cfoutput>
</div>
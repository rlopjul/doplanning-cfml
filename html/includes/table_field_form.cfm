<!---page_types
1 Create new field
2 Modify field
--->

<cfinclude template="#APPLICATION.htmlPath#/includes/table_field_form_query.cfm">

<cfset return_page = "#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#">

<cfset url_return_path = "&return_path="&URLEncodedFormat(return_path&return_page)>

<cfoutput>
<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" />
<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>

<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-select/bootstrap-select.min.js"></script>
<link rel="stylesheet" href="#APPLICATION.htmlPath#/bootstrap/bootstrap-select/bootstrap-select.min.css">

<script src="#APPLICATION.htmlPath#/scripts/tablesFunctions.js?v=2.1"></script>

<script>

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

		return openPopUp('#APPLICATION.mainUrl##APPLICATION.htmlPath#/iframes/area_select.cfm');

	}

	function setSelectedArea(areaId, areaName) {

		$("##list_area_id").val(areaId);
		$("##list_area_name").val(areaName);

		loadAreaList(areaId, 1)

	}

	function openUserSelectorWithField(fieldName){

		return openPopUp('#APPLICATION.mainUrl##APPLICATION.htmlPath#/iframes/users_select.cfm?field='+fieldName);

	}

	function openItemSelectorWithField(itemTypeId,fieldName){

		return openPopUp('#APPLICATION.mainUrl##APPLICATION.htmlPath#/iframes/all_items_select.cfm?itemTypeId='+itemTypeId+'&field='+fieldName);

	}

	function loadAreaList(areaId, selectedValue) {

		if(!isNaN(areaId)){

			showLoadingPage(true);

			var areaListPage = "#APPLICATION.mainUrl##APPLICATION.htmlPath#/html_content/area_list_input_options.cfm?area="+areaId;

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

		$("##textDefaultValue").hide();
		$("##dateDefaultValue").hide();
		$("##booleanDefaultValue").hide();
		$("##listDefaultValue").hide();
		$("##userDefaultValue").hide();
		$("##itemDefaultValue").hide();

		$("##listAreaSelector").hide();
		$("##listAreaHelpText").hide();
		$("##fieldInputTypeBoolean").hide();
		$("##fieldInputTypeList").hide();
		$("##fieldInputTypeListMultiple").hide();
		$("##fieldInputItemType").hide();
		$("##fieldInputTableType").hide();
		$("##fieldInputTable").hide();
		$("##fieldInputTableField").hide();
		$("##fieldInputMaskType").hide();
		$("##listTextValues").hide();

		<!---$("##fieldInputIncludeAllUsers").show();--->

		$("##default_value_text").prop('disabled', true);
		$("##default_value_date").prop('disabled', true);
		$("##default_value_boolean").prop('disabled', true);
		$("##default_value_list").prop('disabled', true);
		$("##default_value_user").prop('disabled', true);
		$("##default_value_item").prop('disabled', true);

		$("##list_area_id").prop('disabled', true);
		$("##field_input_type_boolean").prop('disabled', true);
		$("##field_input_type_list").prop('disabled', true);
		$("##field_input_type_list_multiple").prop('disabled', true);
		$("##item_type_id").prop('disabled', true);
		$("##table_type_id").prop('disabled', true);
		$("##referenced_table_id").prop('disabled', true);
		$("##referenced_field_id").prop('disabled', true);
		$("##mask_type_id").prop('disabled', true);

		$("##list_values").prop('disabled', true);


		if(typeId == 6){ //Date

			$("##dateDefaultValue").show();

			$("##default_value_date").prop('disabled', false);


		}else if(typeId == 7){ //Boolean

			$("##booleanDefaultValue").show();
			$("##fieldInputTypeBoolean").show();

			$("##default_value_boolean").prop('disabled', false);
			$("##field_input_type_boolean").prop('disabled', false);

		}else if(typeId == 9 || typeId == 10 || typeId == 15 || typeId == 16){ //List

			if( typeId == 9 || typeId == 10 ) { //Areas list

				$("##listDefaultValue").show();
				$("##listAreaSelector").show();

				$("##default_value_list").prop('disabled', false);
				$("##list_area_id").prop('disabled', false);

				$("##listAreaText").text(window.lang.translate('Área a para generar la lista'));

			} else { // List of text values

				$("##textDefaultValue").show();
				$("##listTextValues").show();
				$("##listTextValuesLabel").text( window.lang.translate("Valores de la lista") );
				$("##listTextValuesHelp").text( window.lang.translate("Introduce cada valor de la lista en una línea distinta") );

				$("##default_value_text").prop('disabled', false);
				$("##list_values").prop('disabled', false);

			}


			if(typeId == 9 || typeId == 15){
				$("##fieldInputTypeList").show();
				$("##field_input_type_list").prop('disabled', false);

				$("##fieldInputTypeListMultiple").hide();
				$("##field_input_type_list_multiple").prop('disabled', true);
			} else {
				$("##fieldInputTypeList").hide();
				$("##field_input_type_list").prop('disabled', true);

				$("##fieldInputTypeListMultiple").show();
				$("##field_input_type_list_multiple").prop('disabled', false);
			}

		}else if(typeId == 12){ //User

			$("##userDefaultValue").show();

			$("##default_value_user").prop('disabled', false);

		}else if(typeId == 13){ //DoPlanning Item

			$("##fieldInputItemType").show();
			$("##itemDefaultValue").show();
			$("##listAreaSelector").show();

			<cfif page_type IS 1>
				$("##item_type_id").prop('disabled', false);
			</cfif>
			$("##default_value_item").prop('disabled', false);
			$("##list_area_id").prop('disabled', false);

			$("##listAreaText").text( window.lang.translate('Área desde la que habrá que seleccionar el elemento de DoPlanning') );
			$("##listAreaHelpText").show();

		}else if(typeId == 18){ //Attached file

			$("##listTextValues").show();
			$("##listTextValuesLabel").text( window.lang.translate("Lista de extensiones de archivo aceptadas (por defecto se aceptan todas)") );
			$("##listTextValuesHelp").text( window.lang.translate("Introduce cada extensión en una línea distinta. Ejemplos de extensiones válidas: .pdf .doc .pages .jpg .png") );
			$("##list_values").prop('disabled', false);

			$("##default_value_text").prop('disabled', false);

		}else if(typeId == 19){ //Table row

			$("##fieldInputTableType").show();
			$("##fieldInputTable").show();
			$("##fieldInputTableField").show();

			<cfif page_type IS 1>
				$("##table_type_id").prop('disabled', false);
				$("##referenced_table_id").prop('disabled', false);
			</cfif>

			$("##referenced_field_id").prop('disabled', false);

			$("##default_value_text").prop('disabled', false);

		}else if(typeId == 20){ //SEPARATOR

			$("##fieldInputRequired").hide();
			$("##fieldInputOrderBy").hide();
			<!---$("##fieldInputIncludeAllUsers").hide();--->

			$("##default_value_text").prop('disabled', false);
			<!---$("##include_in_all_users").prop('checked', true);--->

		}else {

			$("##textDefaultValue").show();

			$("##default_value_text").prop('disabled', false);

			if(typeId == 2 || typeId == 3){

				$("##default_value_text").attr("rows", '4');

			}else{

				$("##default_value_text").attr("rows", '1');
			}

			if(typeId == 5) { //Decimal

				$("##fieldInputMaskType").show();

				$("##mask_type_id").prop('disabled', false);

			}


		}

	}

	function fieldItemTypeChange(itemTypeId){

		clearFieldSelectedItem('default_value_item');

	}

	function fieldItemTableTypeChange(itemTypeId){

		clearFieldSelectedItem('referenced_table_id')

	}

	function loadTableFields(itemTypeId, tableId) {

		$( 'select[name="referenced_field_id"]' ).load( '#APPLICATION.htmlPath#/html_content/table_fields_select_options.cfm?itemTypeId='+itemTypeId+'&table='+tableId  );

	}

	$(document).ready(function() {

		fieldTypeChange(#field.field_type_id#);

		enableDatePicker('##default_value_date');

		<cfif isDefined("field.list_area_id") AND isNumeric(field.list_area_id)>
			loadAreaList(#field.list_area_id#, '#field.default_value#');
		</cfif>

		$("##referenced_table_id").change(function() {

			loadTableFields($('##table_type_id').val(),$('##referenced_table_id').val());

		});


		//$('.selectpicker').selectpicker();
	});
</script>
</cfoutput>

<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

<!---Table fields types--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Field" method="getFieldTypes" returnvariable="typesResult">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset fieldTypes = typesResult.fieldTypes>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="contenedor_fondo_blanco">
<cfoutput>
<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="form-horizontal" onsubmit="return onSubmitForm();">

	<div id="submitDiv1" style="margin-bottom:10px;">
		<input type="submit" value="Guardar" class="btn btn-primary" lang="es"/>

		<cfif page_type IS 2>
			<span class="divider">&nbsp;&nbsp;</span>

			<a href="#APPLICATION.htmlComponentsPath#/Field.cfc?method=deleteFieldRemote&field_id=#field_id#&tableTypeId=#tableTypeId##url_return_path#" onclick="return confirmDeleteField();" title="Eliminar campo" class="btn btn-danger btn-sm" lang="es"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>
		</cfif>

		<a href="#return_page#" class="btn btn-default" style="float:right;" lang="es">Cancelar</a>
	</div>
	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#"/>
	<input type="hidden" name="table_id" value="#table_id#"/>
	<input type="hidden" name="tableTypeId" value="#tableTypeId#"/>
	<!---<input type="hidden" name="return_path" value="#return_path#"/>--->

	<cfif page_type IS 2>
		<input type="hidden" name="field_id" value="#field.field_id#"/>
	</cfif>

	<div class="row">
		<div class="col-md-12">
			<label for="label" class="control-label"><span lang="es">Nombre</span> *</label>
			<cfif tableTypeId IS 2>
				<cfset labelMaxLength = "500">
			<cfelse>
				<cfset labelMaxLength = "100">
			</cfif>
			<cfinput type="text" name="label" id="label" value="#field.label#" maxlength="#labelMaxLength#" required="true" message="Nombre requerido" class="form-control"/>
		</div>
	</div>

	<div class="row">
		<div class="col-md-12">
			<cfif page_type IS 2>
				<input name="field_type_id" type="hidden" value="#field.field_type_id#"/>
			</cfif>
			<label for="field_type_id" class="control-label"><span lang="es">Tipo</span> *</label>
			<select name="field_type_id" id="field_type_id" class="form-control" onchange="fieldTypeChange($('##field_type_id').val());" <cfif page_type IS 2>disabled</cfif>>
				<cfloop query="fieldTypes">

					<cfif ( ( tableTypeId EQ 2 OR tableTypeId EQ 4 ) AND (fieldTypes.field_type_group EQ "user" OR fieldTypes.field_type_group EQ "doplanning_item") ) OR ( tableTypeId NEQ 3 AND fieldTypes.field_type_id EQ 14 ) OR ( ( tableTypeId EQ 3 OR tableTypeId EQ 4 ) AND fieldTypes.field_type_id EQ 18 ) OR ( tableTypeId NEQ 2 AND fieldTypes.field_type_id EQ 21 )><!---Los campos "user" y "doplanning_item" no están disponibles en los formularios y tiplogías de usuarios. El campo "Request URL" sólo está disponible en archivos. El campo archivo adjunto no está disponible en las tipologías. El campo oculto sólo es para formularios--->
						<cfcontinue>
					<cfelse>
						<option value="#fieldTypes.field_type_id#" lang="es" <cfif field.field_type_id IS fieldTypes.field_type_id>selected="selected"</cfif>>#fieldTypes.name#</option>
					</cfif>

				</cfloop>
			</select>
			<small class="help-block" lang="es">No se puede modificar el tipo una vez creado el campo.</small>
		</div>
	</div>

	<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
	</cfinvoke>

	<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

	<div class="row" id="fieldInputItemType">
		<div class="col-md-10">
			<cfif page_type IS 2 AND field.field_type_id IS 13 AND isDefined("field.item_type_id") AND isNumeric(field.item_type_id)>
				<input name="item_type_id" type="hidden" value="#field.item_type_id#"/>
			</cfif>

			<label class="control-label" for="item_type_id" id="subTypeLabel"><span lang="es">Tipo de elemento de DoPlanning</span> *</label>
			<select name="item_type_id" id="item_type_id" class="form-control" onchange="fieldItemTypeChange($('##item_type_id').val());" <cfif page_type IS 2>disabled</cfif>>
				<cfloop array="#itemTypesArray#" index="itemTypeId">
					<cfif itemTypesStruct[itemTypeId].showInSelect IS true>
						<option value="#itemTypeId#" lang="es" <cfif isDefined("field.item_type_id") AND field.item_type_id IS itemTypeId>selected="selected"</cfif>>#itemTypesStruct[itemTypeId].label#</option>
					</cfif>
				</cfloop>
			</select>
			<small class="help-block" lang="es">No se puede modificar el tipo de elemento DoPlanning una vez creado el campo.</small>

		</div>
	</div>

	<div class="row" id="fieldInputTableType">
		<div class="col-md-10">
			<cfif page_type IS 2 AND field.field_type_id IS 19 AND isDefined("field.item_type_id") AND isNumeric(field.item_type_id)>
				<input name="item_type_id" type="hidden" value="#field.item_type_id#"/>
			</cfif>

			<label class="control-label" for="table_type_id" id="subTableLabel"><span lang="es">Tipo de tabla</span> *</label>
			<select name="item_type_id" id="table_type_id" class="form-control" onchange="fieldItemTableTypeChange($('##table_type_id').val());" <cfif page_type IS 2>disabled</cfif>>
				<cfloop array="#itemTypesArray#" index="itemTypeId">
					<cfset itemTypeStruct = itemTypesStruct[itemTypeId]>
					<cfif isDefined("itemTypeStruct.tableTypeId") AND isNumeric(itemTypeStruct.tableTypeId) AND ( itemTypeId IS 11 OR itemTypeId IS 12 )>
						<option value="#itemTypeId#" lang="es" <cfif isDefined("field.item_type_id") AND field.item_type_id IS itemTypeId>selected="selected"</cfif>>#itemTypeStruct.label#</option>
					</cfif>
				</cfloop>
			</select>
			<small class="help-block" lang="es">No se puede modificar el tipo de tabla una vez creado el campo.</small>

		</div>
	</div>

	<cfif page_type IS 2 AND isDefined("field.item_type_id") AND isNumeric(field.item_type_id) AND isDefined("field.referenced_table_id") AND isNumeric(field.referenced_table_id)>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
			<cfinvokeargument name="item_id" value="#field.referenced_table_id#">
			<cfinvokeargument name="itemTypeId" value="#field.item_type_id#">
			<cfinvokeargument name="parse_dates" value="false"/>
			<cfinvokeargument name="published" value="false"/>

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<cfif itemQuery.recordCount GT 0>
			<cfif len(itemQuery.title) GT 0>
				<cfset referenced_table_title = itemQuery.title>
			<cfelse>
				<cfset referenced_table_title = "ELEMENTO SELECCIONADO SIN TÍTULO">
			</cfif>
		<cfelse>
			<cfset referenced_table_title = "ELEMENTO NO DISPONIBLE">
			<cfset referenced_table_value = "">
		</cfif>

	<cfelse>

		<cfset referenced_table_title = "">
		<cfset referenced_table_value = "">

	</cfif>

	<cfif isDefined("field.referenced_table_id")>

	<div class="row" id="fieldInputTable">
		<div class="col-md-10">

			<label class="control-label" for="referenced_table_id"><span lang="es">Tabla referenciada</span> *</label>

			<input type="hidden" name="referenced_table_id" id="referenced_table_id" value="#field.referenced_table_id#" />
			<input type="text" name="referenced_table_id_title" id="referenced_table_id_title" value="#referenced_table_title#" required class="form-control" readonly onclick="openItemSelectorWithField($('##table_type_id').val(),'referenced_table_id')" />

			<cfif page_type IS 1>
				<button onclick="openItemSelectorWithField($('##table_type_id').val(),'referenced_table_id')" type="button" class="btn btn-default" lang="es">Seleccionar elemento</button>
				<button onclick="clearFieldSelectedItem('referenced_table_id')" type="button" class="btn btn-default" lang="es" title="Quitar elemento seleccionado"><i class="icon-remove"></i></button>
			</cfif>

		</div>
	</div>

	</cfif>

	<div class="row" id="fieldInputTableField">
		<div class="col-md-10">

			<label class="control-label" for="referenced_field_id"><span lang="es">Campo a mostrar</span> *</label>

			<select name="referenced_field_id" id="referenced_field_id" class="form-control" required>
				<cfif page_type IS 2 AND isDefined("field.referenced_table_id") AND isNumeric(field.referenced_table_id)>

					<!--- getTableFields --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getTableFields" returnvariable="allFields">
						<cfinvokeargument name="table_id" value="#field.referenced_table_id#">
						<cfinvokeargument name="tableTypeId" value="#itemTypesStruct[field.item_type_id].tableTypeId#">
						<cfinvokeargument name="with_types" value="false">
						<cfinvokeargument name="with_table" value="false">

						<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfloop query="allFields">
						<option value="#allFields.field_id#" <cfif isNumeric(field.referenced_field_id) AND field.referenced_field_id EQ allFields.field_id>selected</cfif>>#allFields.label#</option>
					</cfloop>

				<cfelse>

					<option value="">Seleccione una tabla para poder seleccionar uno de sus campos</option>

				</cfif>
			</select>

			<small class="help-block" lang="es">IMPORTANTE: todos los usuarios podrán ver los valores de este campo en la tabla referenciada para poder seleccionarlo, aunque no dispongan de permiso de acceso a la misma. No podrán ver el resto de campos de esa tabla.</small>

		</div>
	</div>



	<div class="row" id="fieldInputMaskType">
		<div class="col-md-12">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldManager" method="getFieldMaskTypesStruct" returnvariable="maskTypesStruct">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			</cfinvoke>

			<cfset maskTypesArray = structSort(maskTypesStruct, "numeric", "ASC", "position")>

			<label for="mask_type_id" class="control-label" lang="es">Máscara</label>
			<select name="mask_type_id" id="mask_type_id" class="form-control"><!---onchange="fieldItemTypeChange($('##item_type_id').val());"--->
				<option value="" lang="es">Sin máscara</option>
				<cfloop array="#maskTypesArray#" index="maskTypeId">
					<option value="#maskTypeId#" lang="es" <cfif isDefined("field.mask_type_id") AND field.mask_type_id IS maskTypeId>selected="selected"</cfif>>#maskTypesStruct[maskTypeId].label# (#maskTypesStruct[maskTypeId].description#)</option>
				</cfloop>
			</select>
			<small class="help-block" lang="es">Permite definir como se mostrará el valor numérico introducido.</small>
		</div>
	</div>

	<div class="row" id="fieldInputTypeBoolean">
		<div class="col-md-12">
			<label for="field_input_type_boolean" class="control-label" lang="es">Mostrar opciones en</label>
			<select name="field_input_type" id="field_input_type_boolean" class="form-control">
				<option value="select" <cfif isDefined("field.field_input_type") AND field.field_input_type EQ "select">selected="selected"</cfif> lang="es">Lista desplegable</option>
				<option value="checkbox" <cfif isDefined("field.field_input_type") AND field.field_input_type EQ "checkbox">selected="selected"</cfif> lang="es">Checkbox</option>
				<option value="radio" <cfif isDefined("field.field_input_type") AND field.field_input_type EQ "radio">selected="selected"</cfif> lang="es">Radio</option>
			</select>
		</div>
	</div>

	<div class="row" id="fieldInputTypeList">
		<div class="col-md-12">
			<label for="field_input_type_list" class="control-label" lang="es">Mostrar opciones en</label>
			<select name="field_input_type" id="field_input_type_list" class="form-control">
				<option value="select" <cfif isDefined("field.field_input_type") AND field.field_input_type EQ "select">selected="selected"</cfif> lang="es">Lista desplegable</option>
				<option value="radio" <cfif isDefined("field.field_input_type") AND field.field_input_type EQ "radio">selected="selected"</cfif> lang="es">Radio (se muestran visibles todas las opciones)</option>
			</select>
		</div>
	</div>

	<div class="row" id="fieldInputTypeListMultiple">
		<div class="col-md-12">
			<label for="field_input_type_list_multiple" class="control-label" lang="es">Mostrar opciones en</label>
			<select name="field_input_type" id="field_input_type_list_multiple" class="form-control">
				<option value="select" <cfif isDefined("field.field_input_type") AND field.field_input_type EQ "select">selected="selected"</cfif> lang="es">Lista</option>
				<option value="checkbox" <cfif isDefined("field.field_input_type") AND field.field_input_type EQ "checkbox">selected="selected"</cfif> lang="es">Checkbox (se muestran visibles todas las opciones)</option>
			</select>
		</div>
	</div>

	<div class="row" id="listAreaSelector">
		<div class="col-md-12">
			<cfif isDefined("field.list_area_id") AND isNumeric(field.list_area_id)>
				<!--- getArea --->
				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="listArea">
					<cfinvokeargument name="area_id" value="#field.list_area_id#">
				</cfinvoke>
				<cfset list_area_name = listArea.name>
			<cfelse>
				<cfset list_area_name = "">
			</cfif>

			<label for="list_area_id" id="listAreaText" class="control-label" lang="es">Área a para generar la lista</label>
			<div class="row">
				<div class="col-sm-4">
					<input type="hidden" name="list_area_id" id="list_area_id" <cfif isDefined("field.list_area_id")>value="#field.list_area_id#"</cfif> />
					<cfinput type="text" name="list_area_name" id="list_area_name" class="form-control" value="#list_area_name#" readonly="true" onclick="openAreaSelector()" />
				</div>
				<div class="col-sm-8">
					<button onclick="return openAreaSelector()" type="button" class="btn btn-default" lang="es">Seleccionar área</button>
				</div>
			</div>
			<small class="help-block" id="listAreaHelpText" lang="es">Opcional, definir sólo si el elemento seleccionado debe ser de un área específica de forma obligatoria.<br/>IMPORTANTE: si el usuario no tiene acceso al área seleccionada, no podrá seleccionar ningún elemento.</small>
		</div>
	</div>

	<div class="row" id="listTextValues">
		<div class="col-md-12">
			<label for="list_values" id="listTextValuesLabel" lang="es">Valores de la lista</label>
			<textarea name="list_values" id="list_values" class="form-control" maxlength="5000" rows="5" <cfif field.field_type_id NEQ 15>disabled="disabled"</cfif>><cfif isDefined("field.list_values")>#field.list_values#</cfif></textarea>
			<small class="help-block" id="listTextValuesHelp" lang="es">Introduce cada valor de la lista en una línea distinta</small>
		</div>
	</div>

	<div class="row" id="fieldInputRequired">
		<div class="col-md-12">
			<div class="checkbox">
				<label for="required">
					<input type="checkbox" name="required" id="required" value="true" <cfif isDefined("field.required") AND field.required IS true>checked="checked"</cfif> /> <span lang="es">Obligatorio</span>
				</label>
				<small class="help-block" lang="es">Indica si el campo deber rellenarse de forma obligatoria</small>
			</div>
		</div>
	</div>

	<cfif tableTypeId IS NOT 3>

	<div class="row" id="fieldInputOrderBy">
		<div class="col-md-12">
			<label for="sort_by_this" class="control-label" lang="es">Ordenar por defecto por este campo</label>
			<select name="sort_by_this" id="sort_by_this" class="form-control">
				<option value="" <cfif field.sort_by_this IS "">selected="selected"</cfif> lang="es">No</option>
				<option value="asc" <cfif field.sort_by_this IS "asc">selected="selected"</cfif> lang="es">Orden ascendente</option>
				<option value="desc" <cfif field.sort_by_this IS "desc">selected="selected"</cfif> lang="es">Orden descendente</option>
			</select>
			<small class="help-block" lang="es">Se mostrarán ordenados los registros en el orden especificado por el primer campo que tenga seleccionada esta opción</small>
			<!---<div class="checkbox">
				<label for="sort_by_this">
					<input type="checkbox" name="sort_by_this" id="sort_by_this" value="true" <cfif isDefined("field.sort_by_this") AND field.sort_by_this IS true>checked="checked"</cfif> /> Ordenar por defecto por este campo<br/>
				</label>
				<small class="help-block">Se mostrarán ordenados los registros por el primer campo que tenga seleccionada esta opción</small>
			</div>--->
		</div>
	</div>

	<cfelse><!--- Typologies --->
		<input name="sort_by_this" type="hidden" value="" />
	</cfif>

	<div class="row">
		<div class="col-md-12">
			<label for="description" class="control-label" lang="es">Descripción</label>
			<textarea name="description" id="description" class="form-control" maxlength="1000">#field.description#</textarea>
		</div>
	</div>

	<div class="row" id="textDefaultValue">
		<div class="col-md-12">
			<label for="default_value_text" lang="es">Valor por defecto</label>
			<textarea name="default_value" id="default_value_text" class="form-control" maxlength="1000" rows="4" <cfif field.field_type_id IS 6 OR field.field_type_id IS 7>disabled="disabled"</cfif>>#field.default_value#</textarea>
		</div>
	</div>
	<div class="row" id="dateDefaultValue">
		<div class="col-md-12">
			<label for="default_value_date" class="control-label" lang="es">Valor por defecto</label>
			<input type="text" name="default_value" id="default_value_date" value="#field.default_value#" maxlength="10" class="form-control input_datepicker" <cfif field.field_type_id NEQ 6>disabled="disabled"</cfif>/> <span class="help-inline" lang="es">Fecha formato DD-MM-AAAA</span>
		</div>
	</div>
	<div class="row" id="booleanDefaultValue">
		<div class="col-md-12">
			<label for="default_value_boolean" class="control-label" lang="es">Valor por defecto</label>
			<select name="default_value" id="default_value_boolean" class="form-control" <cfif field.field_type_id NEQ 7>disabled="disabled"</cfif>>
				<option value=""></option>
				<option value="0" <cfif field.default_value IS false>selected="selected"</cfif> lang="es">No</option>
				<option value="1" <cfif field.default_value IS true>selected="selected"</cfif> lang="es">Sí</option>
			</select>
		</div>
	</div>

	<div class="row" id="listDefaultValue">
		<div class="col-md-12">
			<label for="default_value_boolean" class="control-label" lang="es">Valor por defecto</label>
			<select name="default_value" id="default_value_list" class="selectpicker span5" <cfif field.field_type_id NEQ 9 OR field.field_type_id NEQ 10>disabled="disabled"</cfif>><!---multiple---></select>
		</div>
	</div>

	<div class="row" id="userDefaultValue">
		<div class="col-md-12">

			<cfset field_default_value = field.default_value>

			<cfif field.field_type_id IS 12 AND isNumeric(field_default_value)>
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="userQuery">
					<cfinvokeargument name="user_id" value="#field_default_value#">

					<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif userQuery.recordCount GT 0>
					<cfif len(userQuery.user_full_name) GT 0 AND userQuery.user_full_name NEQ " ">
						<cfset field_value_user = userQuery.user_full_name>
					<cfelse>
						<cfset field_value_user = "USUARIO SELECCIONADO SIN NOMBRE">
					</cfif>
				<cfelse>
					<cfset field_value_user = "USUARIO NO DISPONIBLE">
					<cfset field_default_value = "">
				</cfif>
			<cfelse>
				<cfset field_value_user = "">
			</cfif>

			<div class="row">
				<div class="col-md-12">
					<label for="default_value_user" class="control-label" lang="es">Valor por defecto</label>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-11 col-sm-6">
					<input type="hidden" name="default_value" id="default_value_user" value="#field_default_value#" />
					<input type="text" name="default_value_user_user_full_name" id="default_value_user_user_full_name" value="#field_value_user#" class="form-control" readonly onclick="openUserSelectorWithField('default_value_user')" />
				</div>
				<div class="col-xs-1 col-sm-6">
					<button onclick="clearFieldSelectedUser('default_value_user')" type="button" class="btn btn-default" lang="es" title="Quitar usuario seleccionado"><i class="icon-remove"></i></button>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-12 col-sm-6">
					<button onclick="openUserSelectorWithField('default_value_user')" type="button" class="btn btn-default" lang="es">Seleccionar usuario</button>
				</div>
			</div>

		</div>
	</div>

	<div class="row" id="itemDefaultValue">
		<div class="col-md-12">

			<!---El tipo de campo Elemento de DoPlanning no está disponible en formularios porque no se puede acceder a la selección o elementos desde la web--->

			<cfset field_default_value = field.default_value>

			<cfif field.field_type_id IS 13 AND isNumeric(field_default_value)>

				<cfif field.item_type_id IS 10><!--- FILE --->

					<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
						<cfinvokeargument name="file_id" value="#field_default_value#">
						<cfinvokeargument name="parse_dates" value="false"/>
						<cfinvokeargument name="published" value="false"/>

						<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfif fileQuery.recordCount GT 0>
						<cfif len(fileQuery.name) GT 0>
							<cfset field_value_title = fileQuery.name>
						<cfelse>
							<cfset field_value_title = "ARCHIVO SELECCIONADO SIN TÍTULO">
						</cfif>
					<cfelse>
						<cfset field_value_title = "ARCHIVO NO DISPONIBLE">
						<cfset field_default_value = "">
					</cfif>

				<cfelse><!--- ITEM --->

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
						<cfinvokeargument name="item_id" value="#field_default_value#">
						<cfinvokeargument name="itemTypeId" value="#field.item_type_id#">
						<cfinvokeargument name="parse_dates" value="false"/>
						<cfinvokeargument name="published" value="false"/>

						<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfif itemQuery.recordCount GT 0>
						<cfif len(itemQuery.title) GT 0>
							<cfset field_value_title = itemQuery.title>
						<cfelse>
							<cfset field_value_title = "ELEMENTO SELECCIONADO SIN TÍTULO">
						</cfif>
					<cfelse>
						<cfset field_value_title = "ELEMENTO NO DISPONIBLE">
						<cfset field_default_value = "">
					</cfif>

				</cfif>

			<cfelse>
				<cfset field_value_title = "">
			</cfif>

			<div class="row">
				<div class="col-md-12">
					<label for="default_value_item" class="control-label" lang="es">Valor por defecto</label>
				</div>
			</div>

			<div class="row">
				<div class="col-xs-11 col-sm-6">
					<input type="hidden" name="default_value" id="default_value_item" value="#field_default_value#" />
					<textarea name="default_value_title" id="default_value_item_title" class="form-control" readonly onclick="openItemSelectorWithField($('##item_type_id').val(),'default_value_item')">#field_value_title#</textarea>
				</div>
				<div class="col-xs-1 col-sm-6">
					<button onclick="clearFieldSelectedItem('default_value_item')" type="button" class="btn btn-default" lang="es" title="Quitar elemento seleccionado"><i class="icon-remove"></i></button>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-12 col-sm-6">
					<button onclick="openItemSelectorWithField($('##item_type_id').val(),'default_value_item')" type="button" class="btn btn-default" lang="es">Seleccionar elemento</button>
				</div>
			</div>


		</div>
	</div>

	<div class="row">
		<div class="col-md-12" style="height:20px;">
		</div>
	</div>

	<div class="row" id="advancedOptionsContainer">
		<div class="col-md-12">

			<button class="btn btn-info btn-sm" type="button" data-toggle="collapse" data-target="##advancedOptions" aria-expanded="false" aria-controls="advancedOptions">
			  <span lang="es">Mostrar opciones avanzadas</span>
			</button>

			<div class="collapse" id="advancedOptions">

				<div class="row" id="fieldInputIncludeInList">
					<div class="col-md-12">
						<div class="checkbox">
							<label for="include_in_list">
								<input type="checkbox" name="include_in_list" id="include_in_list" value="true" <cfif isDefined("field.include_in_list") AND field.include_in_list IS true>checked="checked"</cfif> /> <span lang="es">Incluir visible este campo en el listado de registros</span>
							</label>
							<small class="help-block" lang="es">Incluye una columna con los valores de este campo en el listado de registros y en los resúmenes de notificaciones por email</small>
						</div>
					</div>
				</div>

				<div class="row" id="fieldInputIncludeInContenido">
					<div class="col-md-12">
						<div class="checkbox">
							<label for="include_in_row_content">
								<input type="checkbox" name="include_in_row_content" id="include_in_row_content" value="true" <cfif isDefined("field.include_in_row_content") AND field.include_in_row_content IS true>checked="checked"</cfif> /> <span lang="es">Incluir visible este campo en la página de contenido del registro</span>
							</label>
							<small class="help-block" lang="es">Incluye el valor en la página de contenido del registro y en las notificaciones individuales por email</small>
						</div>
					</div>
				</div>

				<div class="row" id="fieldInputIncludeInNewRow">
					<div class="col-md-12">
						<div class="checkbox">
							<label for="include_in_new_row">
								<input type="checkbox" name="include_in_new_row" id="include_in_new_row" value="true" <cfif isDefined("field.include_in_new_row") AND field.include_in_new_row IS true>checked="checked"</cfif> /> <span lang="es">Incluir este campo en el formulario de nuevo registro</span>
							</label>
							<small class="help-block" lang="es">Permite rellenar este campo al crear un nuevo registro. Si esta opción no está marcada, este campo no podrá ser un campo obligatorio.</small>
						</div>
					</div>
				</div>

				<cfif tableTypeId NEQ 2><!--- IS NOT FORM --->
					<div class="row" id="fieldInputIncludeInUpdateRow">
						<div class="col-md-12">
							<div class="checkbox">
								<label for="include_in_update_row">
									<input type="checkbox" name="include_in_update_row" id="include_in_update_row" value="true" <cfif isDefined("field.include_in_update_row") AND field.include_in_update_row IS true>checked="checked"</cfif> /> <span lang="es">Incluir este campo en el formulario de modificar registro existente</span>
								</label>
								<small class="help-block" lang="es">Permite rellenar este campo al modificar un registro existente.</small>
							</div>
						</div>
					</div>
				<cfelseif isDefined("field.include_in_update_row") AND field.include_in_update_row IS true>
					<input type="hidden" name="include_in_update_row" value="#field.include_in_update_row#" />
				</cfif>

				<div class="row" id="fieldInputIncludeAllUsers">
					<div class="col-md-12">
						<div class="checkbox">
							<label for="include_in_all_users">
								<input type="checkbox" name="include_in_all_users" id="include_in_all_users" value="true" <cfif isDefined("field.include_in_all_users") AND field.include_in_all_users IS true>checked="checked"</cfif> /> <span lang="es">Editable por todos los usuarios con acceso a la edición.</span>
							</label>
							<small class="help-block" lang="es">Si no se marca este campo, el campo sólo es editable por los usuarios con permiso de responsable de área.</small>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-md-12">
						<label for="import_name" class="control-label"><span lang="es">Nombre para importación</span></label>
						<input type="text" name="import_name" id="import_name" value="#field.import_name#" maxlength="100" message="Nombre requerido" class="form-control"/>
						<small class="help-block" lang="es">Nombre del elemento que contiene el valor de este campo (sólo para importaciones de datos).</small>
					</div>
				</div>

			</div>

		</div>
	</div>




	<!---<label for="position">Posición</label>
	<cfinput type="text" name="position" id="position" value="#field.position#" required="true" validate="integer" message="Posición debe ser un número entero" style="width:50px;">--->

	<div id="submitDiv2" style="margin-top:20px;">
		<input type="submit" value="Guardar" class="btn btn-primary" lang="es"/>
		<!---<a href="area_items.cfm?area=#area_id#" class="btn btn-default">Cancelar</a>--->

		<a href="#return_page#" class="btn btn-default" style="float:right;" lang="es">Cancelar</a>
	</div>

</cfform>
</cfoutput>
</div>

<!---page_types
1 Create new field
2 Modify field
--->

<cfif page_type IS 1>
	<cfset form_action = "#APPLICATION.htmlComponentsPath#/Field.cfc?method=createFieldRemote">
	<!---<cfset return_page = "#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#">--->
<cfelse>
	<cfset form_action = "#APPLICATION.htmlComponentsPath#/Field.cfc?method=updateFieldRemote">
	<!---<cfset return_page = "#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#">--->
</cfif>


<cfif app_version EQ "mobile">
	<cfset return_path = "#APPLICATION.htmlPath#/#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#">
<cfelse>
	<cfset return_path = "#APPLICATION.htmlPath#/iframes2/#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#">
</cfif>




<cfset url_return_path = "&return_path="&URLEncodedFormat(return_path)>

<!---<cfset read_only = false>
<cfif read_only IS true>
	<cfset passthrough = 'readonly="readonly"'>
<cfelse>
	<cfset passthrough = "">
</cfif>--->

<!---Table fields types--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Field" method="getFieldTypes" returnvariable="typesResult">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset fieldTypes = typesResult.fieldTypes>

<script type="text/javascript">

	function confirmDeleteField() {
	
		var message_delete = "Si ELIMINA el campo, se borrarán definitivamente todos los contenidos que almacena. ¿Seguro que desea eliminar el campo?";
		return confirm(message_delete);
	}

	function onSubmitForm(){

		document.getElementById("submitDiv1").innerHTML = 'Enviando...';
		document.getElementById("submitDiv2").innerHTML = 'Enviando...';

		return true;
	}
</script>

<div class="contenedor_fondo_blanco">
<cfoutput>
<cfform action="#form_action#" method="post" onsubmit="return onSubmitForm();">

	<div id="submitDiv1" style="margin-bottom:10px;">
		<input type="submit" value="Guardar" class="btn btn-primary"/>

		<cfif page_type IS 2>
			<span class="divider">&nbsp;&nbsp;</span>

			<a href="#APPLICATION.htmlComponentsPath#/Field.cfc?method=deleteFieldRemote&field_id=#field_id#&tableTypeId=#tableTypeId##url_return_path#" onclick="return confirmDeleteField();" title="Eliminar campo" class="btn btn-danger btn-small"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>
		</cfif>
	</div>

	<input type="hidden" name="tableTypeId" value="#tableTypeId#">
	<input type="hidden" name="return_path" value="#return_path#">
		
	<cfif page_type IS 1>
		<input type="hidden" name="table_id" value="#table_id#">
	<cfelse>
		<input type="hidden" name="field_id" value="#field.field_id#">
	</cfif>

	<label for="label">Nombre</label>
	<cfinput type="text" name="label" id="label" value="#field.label#" maxlength="100" required="true" message="Nombre requerido" class="input-block-level"/>

	<label for="field_type_id">Tipo</label>
	<select name="field_type_id" id="field_type_id" <cfif page_type IS 2>disabled="disabled"</cfif>>
		<cfloop query="fieldTypes">
			<option value="#fieldTypes.field_type_id#" <cfif field.field_type_id IS fieldTypes.field_type_id>selected="selected"</cfif>>#fieldTypes.name#</option>
		</cfloop>
	</select>
	<span class="help-block">No se puede modificar el tipo una vez creado el campo.</span>

	<label for="required" class="checkbox">
		<input type="checkbox" name="required" id="required" value="true" <cfif field.required IS true>checked="checked"</cfif> /> Obligatorio
	</label>
	<span class="help-block">Indica si el campo deber rellenarse de forma obligatoria</span>

	<label for="description">Descripción</label>
	<textarea name="description" id="description" class="input-block-level" maxlength="1000">#field.description#</textarea>

	<label for="default_value">Valor por defecto</label>
	<textarea name="default_value" id="default_value" class="input-block-level" maxlength="1000">#field.default_value#</textarea>

	<!---<label for="position">Posición</label>
	<cfinput type="text" name="position" id="position" value="#field.position#" required="true" validate="integer" message="Posición debe ser un número entero" style="width:50px;">--->

	<div id="submitDiv2" style="margin-top:20px;">
		<input type="submit" value="Guardar" class="btn btn-primary"/>
		<!---<a href="area_items.cfm?area=#area_id#" class="btn">Cancelar</a>--->
	</div>
	
</cfform>
</cfoutput>
</div>
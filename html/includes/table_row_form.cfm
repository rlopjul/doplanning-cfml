<!---page_types
1 Create new row
2 Modify row
--->

<cfinclude template="#APPLICATION.htmlPath#/includes/table_row_form_query.cfm">

<cfset return_page = "#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#">

<cfset url_return_path = "&return_path="&URLEncodedFormat(return_path&return_page)>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<!---Table fields--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	<cfinvokeargument name="with_types" value="true"/>
</cfinvoke>
<cfset fields = fieldsResult.tableFields>

<div class="contenedor_fondo_blanco">
<cfif fields.recordCount IS 0>

	No hay campos definidos para rellenar.

<cfelse>

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

<cfoutput>
<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" onsubmit="return onSubmitForm();">

	<div id="submitDiv1" style="margin-bottom:10px;">
		<input type="submit" value="Guardar" class="btn btn-primary"/>

		<cfif page_type IS 2>
			<a href="#tableTypeName#_row.cfm?#tableTypeName#=#table_id#&row=#row_id#" class="btn" style="float:right">Cancelar</a>
		</cfif>
	</div>
	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#"/>
	<input type="hidden" name="tableTypeId" value="#tableTypeId#"/>
	<input type="hidden" name="table_id" value="#table_id#"/>

	<cfif page_type IS 2>
		<input type="hidden" name="row_id" value="#row.row_id#"/>
	</cfif>

	<cfloop query="fields">

		<cfset field_label = fields.label&"">
		<cfset field_name = "field_#fields.field_id#">
		

		<cfif fields.input_type IS "check">

			<cfif isDefined("row.#field_name#")>
				<cfset field_value = row[field_name]>
			<cfelse>
				<fset field_value = "">
			</cfif>

			<label for="#field_name#" class="checkbox">
				<input type="checkbox" name="#field_name#" id="#field_name#" value="true" <cfif isDefined("field.required") AND field_value IS true>checked="checked"</cfif> /> #field_label# 
			</label>
			<cfif len(fields.description) GT 0><small>#fields.description#</small></cfif>

		<cfelse>

			<cfset field_value = row[field_name]>

			<label for="#field_name#">#field_label#</label>
			<cfif len(fields.description) GT 0><small>#fields.description#</small></cfif>

			<cfif fields.input_type IS "textarea">

				<textarea name="#field_name#" id="#field_name#" class="input-block-level" <cfif len(fields.max_length) GT 0>maxlength="#fields.max_length#"</cfif>>#field_value#</textarea>

			<cfelseif fields.input_type IS "text">

				<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" class="input-block-level"/>

			</cfif>

		</cfif>		
		
		<!---<cfif len(fields.description) GT 0>
			<span class="help-block">#fields.description#</span>
		</cfif>--->

	</cfloop>

	
	<div id="submitDiv2" style="margin-top:20px;">
		<input type="submit" value="Guardar" class="btn btn-primary"/>
		<cfif page_type IS 2>
			<a href="#tableTypeName#_row.cfm?#tableTypeName#=#table_id#&row=#row_id#" class="btn" style="float:right">Cancelar</a>
		</cfif>
	</div>
	
</cfform>
</cfoutput>

</cfif>
</div>
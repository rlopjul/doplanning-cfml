<cfoutput>

<input type="hidden" name="tableTypeId" value="#tableTypeId#"/>
<input type="hidden" name="table_id" value="#table_id#"/>

<cfif isNumeric(row.row_id)>
	<input type="hidden" name="row_id" value="#row.row_id#"/>
	<cfif tableTypeId IS 3><!--- Typology --->
		<input type="hidden" name="typology_row_id" value="#row.row_id#"/>
	</cfif>
	<input type="hidden" name="action" value="modify"/>
<cfelse>
	<input type="hidden" name="action" value="create"/>
</cfif>


<cfloop query="fields">

	<cfset field_label = fields.label&"">
	<cfset field_name = "field_#fields.field_id#">
	<cfif fields.required IS true>
		<cfset field_required_att = 'required="required"'>
	<cfelse>
		<cfset field_required_att = "">
	</cfif>
	

	<!---
	<cfif fields.input_type IS "check"><!--- BOOLEAN --->

		<cfif isDefined("row.#field_name#")>
			<cfset field_value = row[field_name]>
		<cfelse>
			<cfset field_value = "">
		</cfif>

		<label for="#field_name#" class="checkbox">
			<input type="checkbox" name="#field_name#" id="#field_name#" value="true" <cfif field_value IS true>checked="checked"</cfif> /> #field_label# 
			<cfif len(fields.description) GT 0><br/><small class="help-block">#fields.description#</small></cfif>
		</label>

	<cfelse>--->

	<cfset field_value = row[field_name]>

	<label for="#field_name#">#field_label# <cfif fields.required IS true>*</cfif></label>
	<cfif len(fields.description) GT 0><small class="help-block">#fields.description#</small></cfif>

	<cfif fields.input_type IS "textarea"><!--- TEXTAREA --->

		<textarea name="#field_name#" id="#field_name#" class="input-block-level" #field_required_att# maxlength="#fields.max_length#">#field_value#</textarea>

		<cfif fields.required IS true>
			<script type="text/javascript">
				addRailoRequiredTextInput("#field_name#", "Campo '#field_label#' obligatorio");
			</script>
		</cfif>	

	<cfelseif fields.input_type IS "number"><!--- INTEGER --->

		<input type="number" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="span2"/>

		<script type="text/javascript">
			<cfif fields.required IS true>
				addRailoRequiredInteger("#field_name#", "El campo '#field_label#' debe ser numérico y es obligatorio");
			<cfelse>
				addRailoValidateInteger("#field_name#", "El campo '#field_label#' debe ser numérico");
			</cfif>	
		</script>

	<cfelseif fields.input_type IS "url"><!--- URL --->

		<input type="url" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# placeholder="http://" class="input-block-level"/>

		<cfif fields.required IS true>
			<script type="text/javascript">
				addRailoRequiredTextInput("#field_name#", "Campo '#field_label#' obligatorio");
			</script>
		</cfif>	

	<cfelseif fields.input_type IS "date"><!--- DATE --->
		
		<cfif isNumeric(row.row_id) AND NOT isDefined("FORM.tableTypeId") AND isDate(field_value)>
			<cfset field_value = DateFormat(field_value, APPLICATION.dateFormat)>
		</cfif>

		<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="input_datepicker"/> <span class="help-inline">Fecha formato DD-MM-AAAA</span>

		<script type="text/javascript">
			<cfif fields.required IS true>
				addRailoRequiredDate("#field_name#", "El campo '#field_label#' debe ser una fecha con formato DD-MM-AAAA y es obligatorio");
			<cfelse>
				addRailoValidateDate("#field_name#", "El campo '#field_label#' debe ser una fecha con formato DD-MM-AAAA");
			</cfif>

			enableDatePicker('###field_name#');	
		</script>

	<cfelseif fields.input_type IS "text">			


		<cfif fields.cf_sql_type IS "cf_sql_date">

		<cfelseif fields.cf_sql_type IS "cf_sql_decimal"><!--- DECIMAL --->

			<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="span2"/>

			<script type="text/javascript">
				<cfif fields.required IS true>
					addRailoRequiredFloat("#field_name#", "El campo '#field_label#' debe ser numérico y es obligatorio");
				<cfelse>
					addRailoValidateFloat("#field_name#", "El campo '#field_label#' debe ser numérico");
				</cfif>	
			</script>

		<cfelse><!--- TEXT --->

			<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="input-block-level"/>

			<cfif fields.required IS true>
				<script type="text/javascript">
					addRailoRequiredTextInput("#field_name#", "Campo '#field_label#' obligatorio");
				</script>
			</cfif>	

		</cfif>

	<cfelseif fields.input_type IS "select"><!--- SELECT --->

		<cfif fields.field_type_id IS 7><!--- BOOLEAN --->

			<select name="#field_name#" id="#field_name#" #field_required_att# class="input-small">
				<option value=""></option>
				<option value="1" <cfif field_value IS true>selected="selected"</cfif>>Sí</option>
				<option value="0" <cfif field_value IS false>selected="selected"</cfif>>No</option>
			</select>

			<cfif fields.required IS true>
				<script type="text/javascript">
					addRailoRequiredSelect("#field_name#", "Campo '#field_label#' obligatorio");
				</script>
			</cfif>	
		
		<cfelse><!--- LISTS --->

			<!---<select name="#field_name#" id="#field_name#"></select>--->

		</cfif>

	</cfif>

	<!---</cfif>--->		
	
	<!---<cfif len(fields.description) GT 0>
		<span class="help-block">#fields.description#</span>
	</cfif>--->

</cfloop>
</cfoutput>
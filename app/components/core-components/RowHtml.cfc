<!---Copyright Era7 Information Technologies 2007-2013--->
<cfcomponent output="true">
	
	<cfset component = "RowHtml">


	<!--- ----------------------- outputRowFormInputs -------------------------------- --->

	<cffunction name="outputRowFormInputs" access="public" returntype="void" output="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row" type="object" required="true">
		<cfargument name="fields" type="query" required="true">
		<cfargument name="language" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">	

		<cfoutput>

		<input type="hidden" name="tableTypeId" value="#tableTypeId#"/>
		<input type="hidden" name="table_id" value="#table_id#"/>

		<cfif isDefined("row.row_id") AND isNumeric(row.row_id)>
			<cfset action = "modify">
			<input type="hidden" name="row_id" value="#row.row_id#"/>
			<cfif tableTypeId IS 3><!--- Typology --->
				<input type="hidden" name="typology_row_id" value="#row.row_id#"/>
			</cfif>
		<cfelse>
			<cfset action = "create">
		</cfif>
		<input type="hidden" name="action" value="#action#"/>

		<cfloop query="fields">

			<cfset field_label = fields.label&"">
			<cfset field_name = "field_#fields.field_id#">
			<cfif fields.required IS true>
				<cfset field_required_att = 'required="required"'>
			<cfelse>
				<cfset field_required_att = "">
			</cfif>
			
			<cfif fields.field_type_id NEQ 9 AND fields.field_type_id NEQ 10><!--- IS SELECT --->
				<cfset field_value = row[field_name]>
			</cfif>

			<div class="control-group">

			<label for="#field_name#">#field_label# <cfif fields.required IS true>*</cfif></label>
			<cfif len(fields.description) GT 0><small class="help-block">#fields.description#</small></cfif>

			<cfif fields.input_type IS "textarea"><!--- TEXTAREA --->

				<textarea name="#field_name#" id="#field_name#" class="input-block-level" #field_required_att# maxlength="#fields.max_length#" <cfif fields.field_type_id IS 2>rows="4"<cfelse>rows="10"</cfif>>#field_value#</textarea>

				<cfif fields.required IS true>
					<script type="text/javascript">
						addRailoRequiredTextInput("#field_name#", "Campo '#field_label#' obligatorio");
					</script>
				</cfif>	

				<cfif fields.field_type_id IS 3 OR fields.field_type_id IS 11>
					<!--- CKEditor --->
					<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/CKEditorManager" method="loadComponent">
						<cfinvokeargument name="name" value="#field_name#">
						<cfinvokeargument name="language" value="#SESSION.user_language#"/>
					</cfinvoke>--->
					<script type="text/javascript">
						CKEDITOR.replace('#field_name#', {toolbar:'DP', toolbarStartupExpanded:true, language:'#arguments.language#'});
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
				
				<cfif action NEQ "create" AND NOT isDefined("FORM.tableTypeId") AND isDate(field_value)>
					<cfset field_value = DateFormat(field_value, APPLICATION.dateFormat)>
				</cfif>

				<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="input_datepicker"/> <small class="help-inline">Fecha formato DD-MM-AAAA</small>

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

					<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="input-block-level" />

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
				
				<cfelse><!--- LISTS --->

					<cfif NOT isDefined("FORM.tableTypeId")>

						<cfif action EQ "create">
							
							<cfset selectedAreasList = row[field_name]>

						<cfelse>

							<!--- Get selected areas --->
							<cfinvoke component="RowQuery" method="getRowSelectedAreas" returnvariable="getRowAreasQuery">
								<cfinvokeargument name="table_id" value="#arguments.table_id#">
								<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
								<cfinvokeargument name="field_id" value="#fields.field_id#">
								<cfinvokeargument name="row_id" value="#row.row_id#">
								
								<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
								<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
							</cfinvoke>

							<cfset selectedAreas = getRowAreasQuery>
							<cfset selectedAreasList = valueList(selectedAreas.area_id)>

						</cfif>

					<cfelse><!---FORM is Defined--->

						<cfif isDefined("FORM.#field_name#")>
							<cfset selectedAreasList = arrayToList(FORM[field_name])>
						<cfelse>
							<cfset selectedAreasList = "">
						</cfif>
						
					</cfif>

					<select name="#field_name#[]" id="#field_name#" #field_required_att# class="selectpicker span5" <cfif fields.field_type_id IS 10>multiple style="height:90px"</cfif>>
						<cfif fields.field_type_id IS 9 AND fields.required IS false>
							<option value=""></option>
						</cfif>

						<cfinvoke component="AreaHtml" method="outputSubAreasSelect">
							<cfinvokeargument name="area_id" value="#fields.list_area_id#">
							<cfif len(selectedAreasList) GT 0>
								<cfinvokeargument name="selected_areas_ids" value="#selectedAreasList#">
							</cfif>
							<cfinvokeargument name="recursive" value="false">

							<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
							<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
						</cfinvoke>
					</select>
					<cfif fields.field_type_id IS 10>
						<small class="help-block">Utilice la tecla Ctrl para seleccionar varios elementos de la lista</small>
					</cfif>

				</cfif>

				<cfif fields.required IS true>
					<script type="text/javascript">
						addRailoRequiredSelect("#field_name#", "Campo '#field_label#' obligatorio");
					</script>
				</cfif>	

			</cfif>

			</div><!---END div class="control-group"--->
			
		</cfloop>
		</cfoutput>


	</cffunction>


</cfcomponent>
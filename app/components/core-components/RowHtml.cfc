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
		<cfargument name="search_inputs" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">	

		<!---<cfif arguments.search_inputs IS true>
			<cfset text_input_class = "span5">
		<cfelse>
			<cfset text_input_class = "form-control">
		</cfif>--->
		<cfset var text_input_class = "form-control">

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

			<cfset field_label = fields.label><!---&""--->
			<cfset field_name = "field_#fields.field_id#">
			<cfif fields.required IS true AND arguments.search_inputs IS false>
				<cfset field_required_att = 'required="required"'>
			<cfelse>
				<cfset field_required_att = "">
			</cfif>
			
			<cfif fields.field_type_id NEQ 9 AND fields.field_type_id NEQ 10><!--- IS SELECT --->
				<cfset field_value = row[field_name]>
			</cfif>

			<div class="row">

			<div class="col-md-12">

				<cfif fields.field_input_type NEQ "checkbox">
					<label for="#field_name#" class="control-label">#field_label# <cfif fields.required IS true AND arguments.search_inputs IS false>*</cfif></label>
				</cfif>
				
				<cfif len(fields.description) GT 0 AND arguments.search_inputs IS false><small class="help-block">#fields.description#</small></cfif>


				<cfif fields.field_type_group IS "long_text" OR fields.field_type_group IS "very_long_text"><!--- TEXTAREA --->


					<cfif arguments.search_inputs IS false>
						
						<textarea name="#field_name#" id="#field_name#" class="form-control" #field_required_att# maxlength="#fields.max_length#" <cfif fields.field_type_id IS 2>rows="4"<cfelse>rows="10"</cfif>>#field_value#</textarea>

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

					<cfelse><!--- Search --->

						<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="#text_input_class#" />

					</cfif>


				<cfelseif fields.field_type_group IS "integer"><!--- INTEGER --->


					<div class="row">
						<div class="col-xs-6 col-sm-3">

						<input type="number" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="form-control"/>

						</div>
					</div>

					<script type="text/javascript">
						<cfif fields.required IS true AND arguments.search_inputs IS false>
							addRailoRequiredInteger("#field_name#", "El campo '#field_label#' debe ser numérico y es obligatorio");
						<cfelse>
							addRailoValidateInteger("#field_name#", "El campo '#field_label#' debe ser numérico");
						</cfif>	
					</script>


				<cfelseif fields.field_type_group IS "url"><!--- URL --->


					<cfif arguments.client_abb EQ "hcs"><!--- Deshabilitado en el HCS la obligación de introducir URLs completas para que se puedan introducir URLs relativas --->
						<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# placeholder="http://" class="#text_input_class#"/>
					<cfelse>
						<input type="url" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# placeholder="http://" class="#text_input_class#"/>
					</cfif>
					

					<cfif fields.required IS true AND arguments.search_inputs IS false>
						<script type="text/javascript">
							addRailoRequiredTextInput("#field_name#", "Campo '#field_label#' obligatorio");
						</script>
					</cfif>	


				<cfelseif fields.field_type_group IS "date"><!--- DATE --->
					

					<cfif action NEQ "create" AND NOT isDefined("FORM.tableTypeId") AND isDate(field_value)>
						<cfset field_value = DateFormat(field_value, APPLICATION.dateFormat)>
					</cfif>

					<div class="row">
						<div class="col-xs-6 col-sm-3">

							<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="form-control input_datepicker"/>

						</div>
						<div class="col-xs-6 col-sm-9" style="padding-top:5px;">

							<small>Fecha formato DD-MM-AAAA</small>

						</div>
					</div>
					<script type="text/javascript">
						<cfif fields.required IS true AND arguments.search_inputs IS false>
							addRailoRequiredDate("#field_name#", "El campo '#field_label#' debe ser una fecha con formato DD-MM-AAAA y es obligatorio");
						<cfelse>
							addRailoValidateDate("#field_name#", "El campo '#field_label#' debe ser una fecha con formato DD-MM-AAAA");
						</cfif>

						enableDatePicker('###field_name#');	
					</script>


				<cfelseif fields.field_type_group IS "short_text"><!--- TEXT --->


					<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="#text_input_class#" />

					<cfif fields.required IS true AND arguments.search_inputs IS false>
						<script type="text/javascript">
							addRailoRequiredTextInput("#field_name#", "Campo '#field_label#' obligatorio");
						</script>
					</cfif>	
				

				<cfelseif fields.field_type_group IS "decimal"><!--- DECIMAL --->

					<div class="row">
						<div class="col-xs-6 col-sm-3">
					
						<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="col-md-2"/>

						</div>
					</div>

					<script>
						<cfif fields.required IS true AND arguments.search_inputs IS false>
							addRailoRequiredFloat("#field_name#", "El campo '#field_label#' debe ser numérico y es obligatorio");
						<cfelse>
							addRailoValidateFloat("#field_name#", "El campo '#field_label#' debe ser numérico");
						</cfif>	
					</script>


				<cfelseif fields.field_type_group IS "boolean"><!--- BOOLEAN --->


					<div class="row">
						<div class="col-xs-5 col-sm-2">

							<cfif fields.field_input_type EQ "radio"><!---Radio--->

								<div>
								  <label>
								  	<input type="#field_input_type#" name="#field_name#" value="1" <cfif field_value IS true>checked</cfif> />&nbsp;Sí
								  </label>&nbsp;&nbsp;
								  <label>
								    <input type="#field_input_type#" name="#field_name#" value="0" <cfif field_value IS false>checked</cfif> />&nbsp;No
								    
								  </label>
								</div>

							<cfelseif fields.field_input_type EQ "checkbox"><!---Checkbox--->

								<div class="checkbox">
								  <label>
								    <input type="#field_input_type#" name="#field_name#" value="1" <cfif field_value IS true>checked</cfif> /> #field_label#
								    
								  </label>
								</div>

							<cfelse>

								<select name="#field_name#" id="#field_name#" #field_required_att# class="form-control">
									<option value=""></option>
									<option value="1" <cfif field_value IS true>selected="selected"</cfif>>Sí</option>
									<option value="0" <cfif field_value IS false>selected="selected"</cfif>>No</option>
								</select>
								
							</cfif>

						</div>
					</div>

					<cfif fields.required IS true AND arguments.search_inputs IS false>
						<cfif fields.field_input_type EQ "radio">
							<script>
								addRailoRequiredRadio("#field_name#", "Campo '#field_label#' obligatorio");
							</script>
						<cfelseif fields.field_input_type EQ "checkbox">
							<script>
								addRailoRequiredCheckBox("#field_name#", "Campo '#field_label#' obligatorio");
							</script>
						<cfelse>
							<script>
								addRailoRequiredSelect("#field_name#", "Campo '#field_label#' obligatorio");
							</script>
						</cfif>
					</cfif>	


				<cfelseif fields.field_type_group IS "list"><!--- SELECT --->


						<cfif NOT isDefined("FORM.tableTypeId")>

							<cfif action EQ "create">
								
								<cfset selectedAreasList = row[field_name]>

								<cfif isArray(selectedAreasList)>
									<cfset selectedAreasList = arrayToList(selectedAreasList)>
								</cfif>

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


						<cfif fields.field_input_type EQ "radio" OR fields.field_input_type EQ "checkbox"><!---RADIO / CHECKBOX--->

							<!---<cfif (fields.field_type_id IS 9 AND fields.required IS false) OR arguments.search_inputs IS true>
								<option value=""></option>
							</cfif>--->

							<cfinvoke component="AreaHtml" method="outputSubAreasInput">
								<cfinvokeargument name="area_id" value="#fields.list_area_id#">
								<cfif len(selectedAreasList) GT 0>
									<cfinvokeargument name="selected_areas_ids" value="#selectedAreasList#">
								</cfif>
								<cfinvokeargument name="recursive" value="false">
								<cfinvokeargument name="field_name" value="#field_name#"/>
								<cfinvokeargument name="field_input_type" value="#fields.field_input_type#">
								<!---<cfif fields.required IS true AND arguments.search_inputs IS false>
									<cfinvokeargument name="field_required" value="true">
								<cfelse>
									<cfinvokeargument name="field_required" value="false">
								</cfif>--->
								<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
								<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
							</cfinvoke>

							<cfif fields.required IS true AND arguments.search_inputs IS false>
								<cfif fields.field_input_type EQ "radio">
									<script>
										addRailoRequiredRadio("#field_name#[]", "Campo '#field_label#' obligatorio");
									</script>
								<cfelseif fields.field_input_type EQ "checkbox">
									<script>
										addRailoRequiredCheckBox("#field_name#[]", "Campo '#field_label#' obligatorio");
									</script>
								</cfif>
							</cfif>	

						<cfelse><!---SELECT--->


							<select name="#field_name#[]" id="#field_name#" #field_required_att# class="form-control selectpicker" <cfif fields.field_type_id IS 10 AND arguments.search_inputs IS false>multiple style="height:90px"</cfif>>
								<cfif (fields.field_type_id IS 9 AND fields.required IS false) OR arguments.search_inputs IS true>
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
							<cfif fields.field_type_id IS 10 AND arguments.search_inputs IS false>
								<small class="help-block">Utilice la tecla Ctrl para seleccionar varios elementos de la lista</small>
							</cfif>

							<cfif fields.required IS true AND arguments.search_inputs IS false>
								<script>
									addRailoRequiredSelect("#field_name#", "Campo '#field_label#' obligatorio");
								</script>
							</cfif>	


						</cfif>
						

				<cfelseif fields.field_type_group IS "user"><!--- doplanning_user USER --->

					<cfset field_value_user = "">

					<cfif isNumeric(field_value)>
						<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="userQuery">
							<cfinvokeargument name="user_id" value="#field_value#">

							<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
							<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
						</cfinvoke>
						<cfif userQuery.recordCount GT 0>
							<cfif len(userQuery.user_full_name) GT 0 AND userQuery.user_full_name NEQ " ">
								<cfset field_value_user = userQuery.user_full_name>
							<cfelse>
								<cfset field_value_user = "USUARIO SELECCIONADO SIN NOMBRE">
							</cfif>
						<cfelse>
							<cfset field_value_user = "USUARIO NO DISPONIBLE">
							<cfset field_value = "">
						</cfif>
					</cfif>

					<div class="row">
						<div class="col-xs-11 col-sm-6">
							<input type="hidden" name="#field_name#" id="#field_name#" value="#field_value#" />
							<input type="text" name="#field_name#_user_full_name" id="#field_name#_user_full_name" value="#field_value_user#" #field_required_att# class="#text_input_class#" readonly onclick="openUserSelectorWithField('#field_name#')" />
							<cfif fields.required IS true AND arguments.search_inputs IS false>
								<script type="text/javascript">
									addRailoRequiredInteger("#field_name#", "Campo '#field_label#' obligatorio");
								</script>
							</cfif>	
						</div>
						<cfif fields.required IS false>
							<div class="col-xs-1 col-sm-6">
								<button onclick="clearFieldSelectedUser('#field_name#')" type="button" class="btn btn-default" lang="es" title="Quitar usuario seleccionado"><i class="icon-remove"></i></button> 
							</div>
						</cfif>
					</div>
					<div class="row">
						<div class="col-xs-12 col-sm-6">
							<button onclick="openUserSelectorWithField('#field_name#')" type="button" class="btn btn-default" lang="es">Seleccionar usuario</button>							
						</div>
					</div>
					
					

				<cfelseif fields.field_type_group IS "doplanning_item"><!--- AREA ITEMS --->


					<cfif isNumeric(field_value)>
						
						<cfif fields.item_type_id IS 10><!--- FILE --->

							<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
								<cfinvokeargument name="file_id" value="#field_value#">
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
								<cfset field_value = "">
							</cfif>
							
						<cfelse><!--- ITEM --->

							<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
								<cfinvokeargument name="item_id" value="#field_value#">
								<cfinvokeargument name="itemTypeId" value="#fields.item_type_id#">
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
								<cfset field_value = "">
							</cfif>

						</cfif>

					<cfelse>

						<cfset field_value_title = "">

					</cfif>

					<div class="row">
						<div class="col-xs-11 col-sm-6">
							<input type="hidden" name="#field_name#" id="#field_name#" value="#field_value#" />
							<input type="text" name="#field_name#_title" id="#field_name#_title" value="#field_value_title#" #field_required_att# class="#text_input_class#" readonly onclick="openItemSelectorWithField(#fields.item_type_id#,'#field_name#')" />
							<cfif fields.required IS true AND arguments.search_inputs IS false>
								<script type="text/javascript">
									addRailoRequiredInteger("#field_name#", "Campo '#field_label#' obligatorio");
								</script>
							</cfif>	
						</div>
						<cfif fields.required IS false>
							<div class="col-xs-1 col-sm-6">
								<button onclick="clearFieldSelectedItem('#field_name#')" type="button" class="btn btn-default" lang="es" title="Quitar elemento seleccionado"><i class="icon-remove"></i></button> 
							</div>
						</cfif>
					</div>
					<div class="row">
						<div class="col-xs-12 col-sm-6">
							<button onclick="openItemSelectorWithField(#fields.item_type_id#,'#field_name#')" type="button" class="btn btn-default" lang="es">Seleccionar elemento</button>							
						</div>
					</div>

				</cfif>

			</div><!---END col-md-12--->
			</div><!---END div class="row"--->
			
		</cfloop>
		</cfoutput>


	</cffunction>


</cfcomponent>
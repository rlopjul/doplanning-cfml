<!---Copyright Era7 Information Technologies 2007-2014--->
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
			
			<cfif fields.field_type_id NEQ 9 AND fields.field_type_id NEQ 10><!--- IS NOT SELECT --->
				<cfset field_value = row[field_name]>
			</cfif>

			<div class="row">

			<div class="col-md-12">

				<cfif ( fields.field_input_type NEQ "checkbox" OR fields.field_type_group EQ "list" ) AND len(field_label) GT 0>
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
							<!--- Enable CKEDITOR in mobile browsers --->
							<script>
								if ( window.CKEDITOR && ( !CKEDITOR.env.ie || CKEDITOR.env.version > 7 ) )
   									CKEDITOR.env.isCompatible = true;

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

					<script>
						<cfif fields.required IS true AND arguments.search_inputs IS false>
							addRailoRequiredInteger("#field_name#", "El campo '#field_label#' debe ser numérico y es obligatorio");
						<cfelse>
							addRailoValidateInteger("#field_name#", "El campo '#field_label#' debe ser numérico");
						</cfif>	
					</script>


				<cfelseif fields.field_type_group IS "decimal"><!--- DECIMAL --->

					<div class="row">
						<div class="col-xs-6 col-sm-3">

							<cfif isNumeric(fields.mask_type_id)>
								
								<!--- getFieldMaskTypes --->
								<cfinvoke component="FieldManager" method="getFieldMaskTypesStruct" returnvariable="maskTypesStruct">
									<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
									<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
								</cfinvoke>

								<cfset mask_label = maskTypesStruct[fields.mask_type_id].label>
								<cfset cf_prefix = maskTypesStruct[fields.mask_type_id].cf_prefix>
								<cfset cf_sufix = maskTypesStruct[fields.mask_type_id].cf_sufix>

							<cfelse>
								<cfset mask_label = "">
								<cfset cf_prefix = "">
								<cfset cf_sufix = "">
							</cfif>
							
							<cfif len(cf_prefix) GT 0 OR len(cf_sufix) GT 0>
								<div class="input-group">
							</cfif>
								<cfif len(cf_prefix) GT 0>
									<span class="input-group-addon">#cf_prefix#</span>
								</cfif>
							 		<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="form-control"/>
							 	<cfif len(cf_sufix) GT 0>
							 		<span class="input-group-addon">#cf_sufix#</span>
							 	</cfif>
							<cfif len(cf_prefix) GT 0 OR len(cf_sufix) GT 0>
								</div>
							</cfif>

						</div>
						<div class="col-xs-6 col-sm-9" style="padding-top:5px;">

							<i id="decimal-help" class="icon-question-sign" data-toggle="tooltip" data-placement="bottom" data-html="true" title="Los decimales se deben introducir con un punto, ejemplo: 9999.99<cfif len(mask_label) GT 0><br>Al valor introducido se le aplicará posteriormente la siguiente máscara para mostrarlo: #mask_label#</cfif>" lang="es" style="cursor:pointer"></i>

						</div>
					</div>

					<script>
						$(document).ready(function() {
							$("##decimal-help").tooltip();
						});
						<cfif fields.required IS true AND arguments.search_inputs IS false>
							addRailoRequiredFloat("#field_name#", "El campo '#field_label#' debe ser numérico y es obligatorio");
						<cfelse>
							addRailoValidateFloat("#field_name#", "El campo '#field_label#' debe ser numérico");
						</cfif>	
					</script>


				<cfelseif fields.field_type_group IS "url"><!--- URL --->


					<cfif arguments.client_abb EQ "hcs"><!--- Deshabilitado en el HCS la obligación de introducir URLs completas para que se puedan introducir URLs relativas --->
						<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# placeholder="http://" class="#text_input_class#"/>
					<cfelse>
						<input type="url" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# placeholder="http://" class="#text_input_class#"/>
					</cfif>
					

					<cfif fields.required IS true AND arguments.search_inputs IS false>
						<script>
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


					<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="#text_input_class#" <cfif len(field_label) IS 0><!---PARA DP ASEBIO (campo otros)--->style="margin-left:35px;width:80%;"</cfif> />

					<cfif fields.required IS true AND arguments.search_inputs IS false>
						<script type="text/javascript">
							addRailoRequiredTextInput("#field_name#", "Campo '#field_label#' obligatorio");
						</script>
					</cfif>	


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


					<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- List area values --->

						
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


					<cfelse><!--- List text values ---> 


						<cfif NOT isDefined("FORM.tableTypeId")>

							<cfif action EQ "create">

								<cfif isArray(field_value)>
									<cfset field_value = arrayToList(selectedAreasList,";")>
								</cfif>

							</cfif>

						<cfelse><!---FORM is Defined--->

							<cfif isDefined("FORM.#field_name#")>
								<cfset field_value = arrayToList(field_value,";")>
							<cfelse>
								<cfset field_value = "">
							</cfif>
							
						</cfif>


					</cfif>

					<cfif fields.field_input_type EQ "radio" OR fields.field_input_type EQ "checkbox"><!---RADIO / CHECKBOX--->

						<!---<cfif (fields.field_type_id IS 9 AND fields.required IS false) OR arguments.search_inputs IS true>
							<option value=""></option>
						</cfif>--->

						<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- List area values --->

							<cfinvoke component="AreaHtml" method="outputSubAreasInput">
								<cfinvokeargument name="area_id" value="#fields.list_area_id#">
								<cfif len(selectedAreasList) GT 0>
									<cfinvokeargument name="selected_areas_ids" value="#selectedAreasList#">
								</cfif>
								<cfinvokeargument name="recursive" value="false">
								<cfinvokeargument name="field_name" value="#field_name#"/>
								<cfinvokeargument name="field_input_type" value="#fields.field_input_type#">
								<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
								<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
							</cfinvoke>

						<cfelse><!--- List text values --->

							<div class="row">
								<div class="col-sm-offset-1 col-sm-10" style="margin-bottom:10px;">
								
								<cfloop list="#fields.list_values#" delimiters="#chr(13)##chr(10)#" index="list_value">

									<cfset list_value = trim(list_value)>

									<cfif listFind(field_value, list_value, "#chr(13)##chr(10)#") GT 0>
										<cfset value_selected = true>
									<cfelse>
										<cfset value_selected = false>
									</cfif>

									<div class="radio">
									  <label>
									    <input type="#fields.field_input_type#" name="#field_name#[]" value="#list_value#" <cfif value_selected>checked</cfif> />&nbsp;#list_value#
									  </label>
									</div>
									<div class="clearfix"></div>
			
								</cfloop>

								</div>
							</div>

						</cfif>

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


						<select name="#field_name#[]" id="#field_name#" #field_required_att# class="form-control selectpicker" <cfif (fields.field_type_id IS 10 OR fields.field_type_id IS 16) AND arguments.search_inputs IS false>multiple style="height:90px"</cfif>>
							<cfif ( (fields.field_type_id IS 9 OR fields.field_type_id IS 15) AND fields.required IS false ) OR arguments.search_inputs IS true>
								<option value=""></option>
							</cfif>

							<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- List area values --->

								<cfinvoke component="AreaHtml" method="outputSubAreasSelect">
									<cfinvokeargument name="area_id" value="#fields.list_area_id#">
									<cfif len(selectedAreasList) GT 0>
										<cfinvokeargument name="selected_areas_ids" value="#selectedAreasList#">
									</cfif>
									<cfinvokeargument name="recursive" value="false">

									<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
									<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
								</cfinvoke>

							<cfelse><!--- List text values --->

								<cfloop list="#fields.list_values#" delimiters="#chr(13)##chr(10)#" index="list_value">
									<cfset list_value = trim(list_value)>
									<cfif listFind(field_value, list_value, "#chr(13)##chr(10)#") GT 0>
										<cfset value_selected = true>
									<cfelse>
										<cfset value_selected = false>
									</cfif>
									<option value="#list_value#" <cfif value_selected>selected</cfif>>#list_value#</option>		
								</cfloop>

							</cfif>

						</select>
						<cfif ( fields.field_type_id IS 10 OR fields.field_type_id IS 16) AND arguments.search_inputs IS false>
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






	<!--- ----------------------- outputRowList -------------------------------- --->

	<cffunction name="outputRowList" access="public" returntype="void" output="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="view_id" type="numeric" required="false">
		<cfargument name="tableRows" type="query" required="true">
		<cfargument name="fields" type="query" required="true">
		<cfargument name="openRowOnSelect" type="boolean" required="false" default="false">
		<cfargument name="app_version" type="string" required="false" default="mobile">
		<cfargument name="columnSelectorContainer" type="string" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

		<!--- getFieldMaskTypes --->
		<cfinvoke component="FieldManager" method="getFieldMaskTypesStruct" returnvariable="maskTypesStruct">
			<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
		</cfinvoke>

		<cfoutput>

		<script>
			$(document).ready(function() { 
				
				$("##dataTable#arguments.tableTypeId#_#arguments.table_id#").tablesorter({  <!--- Se le asigna un id único a la tabla por si hay más en la misma página --->

					<!---widthFixed: true,--->
					showProcessing: true,
					delayInit: true,
					widgets: ['zebra','uitheme','filter','stickyHeaders','math','saveSort'<cfif isDefined("arguments.columnSelectorContainer")>,'columnSelector'</cfif>],<!---'select',--->

					theme : "bootstrap",
					headerTemplate : '{content} {icon}',<!---new in v2.7. Needed to add the bootstrap icon!--->

					<!--- http://mottie.github.io/tablesorter/docs/example-option-date-format.html ---->
					dateFormat : "ddmmyyyy", // set the default date format

					headers: { 

						0: {
							sorter: "digit"
						}
						
						<cfset sortArray = arrayNew(1)>
						<!---<cfset fieldsWithHeader = false>--->

						<cfloop query="fields">

							<cfif fields.field_id IS "creation_date" OR fields.field_id IS "last_update_date" OR fields.field_type_id IS 6><!--- DATE --->

								<!---<cfif fieldsWithHeader IS true>,</cfif>--->, #fields.currentRow#: { 
									<!---sorter: "datetime"--->
									sorter: "shortDate"
								}
								<!---<cfset fieldsWithHeader = true>--->

							<cfelseif fields.field_id NEQ 4 AND fields.field_id NEQ 5><!--- IS NOT INTEGER OR DECIMAL --->

								<!---<cfif fieldsWithHeader IS true>,</cfif>--->, #fields.currentRow#: { 
									sorter: "text"
								}
								<!---<cfset fieldsWithHeader = true>--->

							</cfif>

							<cfif len(fields.sort_by_this) GT 0>
								<cfif fields.sort_by_this IS "asc">
									<cfset sortOrder = 0>
								<cfelse>
									<cfset sortOrder = 1>
								</cfif>
								<cfset arrayAppend(sortArray, {row=fields.currentRow, order=sortOrder})>
							</cfif>

						</cfloop>
					},
					// default "emptyTo"
		   			emptyTo: 'zero',
					<!---textExtraction: 'basic',--->
					textAttribute: "data-text",
					textExtraction: "basic",
					usNumberFormat: true, <!--- Requerido para que la suma de los valores de las comlumnas con decimales separados por . sea correcta (esto hace que los decimales separados por , no se sumen correctamente, pero para eso se usa la opción de definir el valor de la columena en data-text)  ---->
					<cfset sortArrayLen = arrayLen(sortArray)>
					<cfif sortArrayLen GT 0>
									
						sortList: [
						<cfloop from="1" to="#sortArrayLen#" index="curSort">
							[#sortArray[curSort].row#, #sortArray[curSort].order#]
							<cfif curSort NEQ sortArrayLen>
								,
							</cfif>
						</cfloop> ],

					<cfelse>
						<cfif tableRows.recordCount LT 100><!---Ordenar de nuevo la tabla por el campo por defecto ralentiza las tablas con muchas filas--->
							sortList: [[0,1]] ,
						</cfif>
					</cfif>

					widgetOptions : {

						<!--- Filter options --->
						filter_childRows : false,
						filter_columnFilters : true,
						filter_cssFilter : 'tablesorter-filter',
						filter_filteredRow   : 'filtered',
						filter_formatter : null,
						filter_functions : null,
						filter_hideFilters : false,
						filter_ignoreCase : true,
						filter_liveSearch : true,
						//filter_reset : 'button.reset',
						filter_searchDelay : 500,
						filter_serversideFiltering: false,
						filter_startsWith : false,
						filter_useParsedRow : false
						<!--- END Filter options --->						

						<!--- Suma de valores de las columnas --->
							, math_data     : 'math' // data-math attribute
						    , math_ignore   : [0
						    <cfloop query="fields"> 
						    	<cfif fields.field_type_id NEQ 4 AND fields.field_type_id NEQ 5>
						    		, #fields.currentRow#
						    	</cfif>
						    </cfloop>]
						    <!---, math_mask     : '##.000,00'--->
						    <!---, math_complete : function($cell, wo, result, value, arry) {
						        var txt = '<span class="align-decimal"> ' + result + '</span>';
						        if ($cell.attr('data-math') === 'all-sum') {
						          // when the "all-sum" is processed, add a count to the end
						          return txt + ' (Sum of ' + arry.length + ' cells)';
						        }
						        return txt;
						    }--->
						<!--- Fin suma de los valores de las columnas --->


						<!---,stickyHeaders_attachTo : '##pageHeaderContainer' Esto no funciona--->

						<cfif isDefined("arguments.columnSelectorContainer")>

							<!--- Column selector options --->

							// target the column selector markup
							, columnSelector_container : $('###arguments.columnSelectorContainer#')
							// column status, true = display, false = hide
							// disable = do not display on list
							, columnSelector_columns : {
								0: 'disable' /* set to disabled; not allowed to unselect it */
							},
							// remember selected columns (requires $.tablesorter.storage)
							columnSelector_saveColumns: true,

							// container layout
							columnSelector_layout : '<li><label><input type="checkbox">{name}</label>&nbsp;&nbsp;&nbsp;&nbsp;</li>',
							// data attribute containing column name to use in the selector container
							columnSelector_name  : 'data-selector-name',

							/* Responsive Media Query settings */
							// enable/disable mediaquery breakpoints
							columnSelector_mediaquery: false,
							// toggle checkbox name
							columnSelector_mediaqueryName: '<i>Selección de columnas automática</i>',
							// breakpoints checkbox initial setting
							columnSelector_mediaqueryState: true,
							// responsive table hides columns with priority 1-6 at these breakpoints
							// see http://view.jquerymobile.com/1.3.2/dist/demos/widgets/table-column-toggle/##Applyingapresetbreakpoint
							// *** set to false to disable ***
							columnSelector_breakpoints : [ '20em', '30em', '40em', '50em', '60em', '70em' ],
							// data attribute containing column priority
							// duplicates how jQuery mobile uses priorities:
							// http://view.jquerymobile.com/1.3.2/dist/demos/widgets/table-column-toggle/
							columnSelector_priority : 'data-priority',

							// class name added to checked checkboxes - this fixes an issue with Chrome not updating FontAwesome
							// applied icons; use this class name (input.checked) instead of input:checked
							columnSelector_cssChecked : 'checked'

						    <!--- END column selector options --->

						</cfif>
				    }
				});
	

				<cfif arguments.openRowOnSelect IS true>
				<!--- https://code.google.com/p/tablesorter-extras/wiki/TablesorterSelect --->
				<!---$('##dataTable#arguments.tableTypeId#_#arguments.table_id#').bind('select.tablesorter.select', function(event, ts){
				    var itemUrl= $(ts.elem).data("item-url");
				    openUrlLite(itemUrl,'itemIframe');
				});--->

				$('##dataTable#arguments.tableTypeId#_#arguments.table_id# tbody tr').on('click', function(e) {

			       	var row = $(this);

			        if(!row.hasClass("selected")) {
			        	$('##dataTable#arguments.tableTypeId#_#arguments.table_id# tbody tr').removeClass("selected");
			        	row.addClass("selected");
			        }

			        var itemUrl= row.data("item-url");
				    openUrlLite(itemUrl,'itemIframe');

			    });

				</cfif>
	
				$('##tableDoubleScroll#arguments.tableTypeId#_#arguments.table_id#').doubleScroll({
				    onlyIfScroll: true, // top scrollbar is not shown if the bottom one is not present
				    resetOnWindowResize: true 
				});

				<!---$('##dataTablePopover#arguments.tableTypeId#_#arguments.table_id#').popover({
				      placement: 'right',
				      html: true, // required if content has HTML
				      content: '<ul class="list-inline" id="popoverTarget#arguments.tableTypeId#_#arguments.table_id#"></ul>'
				    })
				    // bootstrap popover event triggered when the popover opens
				    .on('shown.bs.popover', function () {
				      // call this function to copy the column selection code into the popover
				      $.tablesorter.columnSelector.attachTo( $("##dataTable#arguments.tableTypeId#_#arguments.table_id#"), '##popoverTarget#arguments.tableTypeId#_#arguments.table_id#');
				});--->

			}); 
		</script>

		<cfset selectFirst = true>
		<cfset listFields = false>

		<cfif isDefined("URL.row")>
			<cfset selectFirst = false>
		</cfif>

		<!---<div class="columnSelectorWrapper">
		  <input id="colSelect1" type="checkbox" class="hidden">
		  <label class="columnSelectorButton" for="colSelect1">Column</label>
		  <div id="columnSelector" class="columnSelector">
		    <!-- this div is where the column selector is added -->
		  </div>
		</div>--->

		<!---<button id="dataTablePopover#arguments.tableTypeId#_#arguments.table_id#" type="button" class="btn btn-default btn-sm">
		  <i class="fa-eye-slash"></i> Mostrar/ocultar columnas
		</button>--->

			<div id="tableDoubleScroll#arguments.tableTypeId#_#arguments.table_id#">

				<table id="dataTable#arguments.tableTypeId#_#arguments.table_id#" class="data-table table-hover" style="margin-top:5px;">
					<thead>
						<tr>
							<th style="width:25px;">##</th>
							<!---<th>Fecha última modificación</th>--->
							<cfloop query="fields">
								<th>#fields.label#</th>
								<cfif fields.field_type_id EQ 9 OR fields.field_type_id IS 10><!--- LISTS --->
									<cfset listFields = true>
								</cfif>
							</cfloop>
						</tr>
					</thead>

					<tbody>
					<cfif listFields IS true>
						
						<!--- Get selected areas --->
						<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getRowSelectedAreas" returnvariable="getRowSelectedAreasResponse">
							<cfinvokeargument name="table_id" value="#table_id#">
							<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
						</cfinvoke>

						<cfset selectedAreas = getRowSelectedAreasResponse.areas>---->

						<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getRowSelectedAreas" returnvariable="selectedAreas">
							<cfinvokeargument name="table_id" value="#table_id#">
							<cfinvokeargument name="tableTypeId" value="#tableTypeId#">

							<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
							<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
						</cfinvoke>

					</cfif>

					<!---<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>--->

					<cfset alreadySelected = false>

					<cfloop query="tableRows">

						<cfif isDefined("arguments.view_id")>
							<cfset rpage = "#tableTypeName#_view_rows.cfm?#tableTypeName#_view=#arguments.view_id#">
							<cfset row_page_url = "#tableTypeName#_view_row.cfm?#tableTypeName#_view=#arguments.view_id#&row=#tableRows.row_id#&return_page=#URLEncodedFormat(rpage)#">
						<cfelse>
							<cfset rpage = "#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#">
							<cfset row_page_url = "#tableTypeName#_row.cfm?#tableTypeName#=#table_id#&row=#tableRows.row_id#&return_page=#URLEncodedFormat(rpage)#">
						</cfif>
						

						<!---Row selection--->
						<cfset dataSelected = false>
						
						<cfif alreadySelected IS false>

							<cfif ( isDefined("URL.row") AND URL.row IS tableRows.row_id ) OR ( selectFirst IS true AND tableRows.currentRow IS 1 AND app_version NEQ "mobile" ) ><!--- tableRows.recordCount --->

								<!--- ESTO PUESTO AQUÍ HACE QUE FALLE EL TABLESORTER PARA LAS SUMAS --->
								<!---<script>
									openUrlHtml2('#row_page_url#','itemIframe');
								</script>--->
								<cfset onpenUrlHtml2 = row_page_url>

								<cfset dataSelected = true>
								<cfset alreadySelected = true>
																				
							</cfif>
							
						</cfif>

						<tr <cfif dataSelected IS true>class="selected"</cfif> <cfif arguments.openRowOnSelect IS true>data-item-url="#row_page_url#"</cfif>>

							<td>#tableRows.row_id#</td>
							
							<cfset row_id = tableRows.row_id>
							<cfloop query="fields">

								<cfif fields.field_id IS "creation_date"><!--- CREATION DATE --->

									<td>#DateFormat(tableRows.creation_date, APPLICATION.dateFormat)# #TimeFormat(tableRows.creation_date, "HH:mm")#</td>

								<cfelseif fields.field_id IS "last_update_date"><!--- LAST UPDATE DATE --->
									
									<td><cfif len(tableRows.last_update_date) GT 0>#DateFormat(tableRows.last_update_date, APPLICATION.dateFormat)# #TimeFormat(tableRows.last_update_date, "HH:mm")#<cfelse>-</cfif></td>

								<cfelseif fields.field_id IS "insert_user"><!--- INSERT USER --->

									<td>#insert_user_full_name#</td>

								<cfelseif fields.field_id IS "update_user"><!--- UPDATE USER --->

									<td>#update_user_full_name#</td>

								<cfelse><!--- TABLE FIELDS --->

									<cfset field_value = "">

									<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- IS LIST --->

										<cfif selectedAreas.recordCount GT 0>

											<cfquery dbtype="query" name="rowSelectedAreas">
												SELECT name
												FROM selectedAreas
												WHERE field_id = <cfqueryparam value="#fields.field_id#" cfsqltype="cf_sql_integer">
												AND row_id = <cfqueryparam value="#row_id#" cfsqltype="cf_sql_integer">;
											</cfquery>

											<cfif rowSelectedAreas.recordCount GT 0>
												<cfset field_value = valueList(rowSelectedAreas.name, "<br/>")>
											</cfif>

										</cfif>

									<cfelseif fields.field_type_id IS 15 OR fields.field_type_id IS 16><!--- Text values list --->

										<cfset field_value = tableRows['field_#fields.field_id#']>

										<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="insertBR" returnvariable="field_value">
											<cfinvokeargument name="string" value="#field_value#">
										</cfinvoke>
										
									<cfelse><!--- IS NOT LIST --->

										<cfset field_value = tableRows['field_#fields.field_id#']>

										<cfif len(field_value) GT 0>

											<cfif fields.field_type_id IS 5><!--- DECIMAL --->

												<cfif isNumeric(fields.mask_type_id)>

													<cfset field_mask_type_id = fields.mask_type_id>

													<cfset cf_data_mask = maskTypesStruct[field_mask_type_id].cf_data_mask>
													<cfset cf_prefix = maskTypesStruct[field_mask_type_id].cf_prefix>
													<cfset cf_sufix = maskTypesStruct[field_mask_type_id].cf_sufix>
													<cfset cf_locale = maskTypesStruct[field_mask_type_id].cf_locale>
													<cfset field_value = cf_prefix&LSnumberFormat(field_value, cf_data_mask, cf_locale)&cf_sufix>

													<!---<cfset field_value = LSnumberFormat(field_value, ",.__", getLocale())>--->

												<cfelse>
													<!---<cfset field_value = LSnumberFormat(field_value, ".__", "en_US")>--->

													<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="trimDecimal" returnvariable="field_value">
														<cfinvokeargument name="value" value="#field_value#">
													</cfinvoke>
													
												</cfif>
												
												
											<cfelseif fields.field_type_id IS 6><!--- DATE --->
												<cfset field_value = DateFormat(dateConvert("local2Utc",field_value), APPLICATION.dateFormat)>
											<cfelseif fields.field_type_id IS 7><!--- BOOLEAN --->
												<cfif field_value IS true>
													<cfset field_value = "Sí">
												<cfelseif field_value IS false>
													<cfset field_value = "No">
												</cfif>
												<cfset field_value = '<span lang="es">#field_value#</span>'>

											<cfelseif fields.field_type_id IS 12><!--- USER --->

												<cfif isNumeric(field_value)>
										
													<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="userQuery">
														<cfinvokeargument name="user_id" value="#field_value#">

														<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
														<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
													</cfinvoke>
													<cfif userQuery.recordCount GT 0>
														<cfif len(userQuery.user_full_name) GT 0 AND userQuery.user_full_name NEQ " ">
															<cfset field_value = userQuery.user_full_name>
														<cfelse>
															<cfset field_value = "<i>USUARIO SIN NOMBRE</i>">
														</cfif>
													<cfelse>
														<cfset field_value = '<i lang="es">USUARIO NO ENCONTRADO</i>'>
													</cfif>
													
												</cfif>


											<cfelseif fields.field_type_id IS 13><!--- ITEM --->


												<cfif isNumeric(field_value)>

													<cfif fields.item_type_id IS 10><!--- FILE --->

														<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
															<cfinvokeargument name="file_id" value="#field_value#">
															<cfinvokeargument name="parse_dates" value="false"/>
															<cfinvokeargument name="published" value="false"/>

															<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
															<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
														</cfinvoke>

														<cfif fileQuery.recordCount GT 0>
															<cfif len(fileQuery.name) GT 0>
																<cfset field_value = fileQuery.name>
															<cfelse>
																<cfset field_value = "<i>ARCHIVO SIN TÍTULO</i>">
															</cfif>
														<cfelse>
															<cfset field_value = "<i>ARCHIVO NO DISPONIBLE</i>">
														</cfif>
														
													<cfelse><!--- ITEM --->

														<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
															<cfinvokeargument name="item_id" value="#field_value#">
															<cfinvokeargument name="itemTypeId" value="#fields.item_type_id#">
															<cfinvokeargument name="parse_dates" value="false"/>
															<cfinvokeargument name="published" value="false"/>

															<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
															<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
														</cfinvoke>

														<cfif itemQuery.recordCount GT 0>
															<cfif len(itemQuery.title) GT 0>
																<cfset field_value = itemQuery.title>
															<cfelse>
																<cfset field_value = "<i>ELEMENTO SIN TÍTULO</i>">
															</cfif>
														<cfelse>
															<cfset field_value = "<i>ELEMENTO NO DISPONIBLE</i>">
														</cfif>

													</cfif>

												</cfif>


											<cfelse>

												<cfif fields.field_type_id IS 2 OR fields.field_type_id IS 3 OR fields.field_type_id IS 11><!--- TEXTAREAS --->
													
													<cfif len(field_value) GT 60><!---200--->

														<cfif fields.field_type_id IS 2>
															
															<cfset field_value = HTMLEditFormat(field_value)>

														<cfelse>

															<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="removeHTML" returnvariable="field_value">
																<cfinvokeargument name="string" value="#field_value#">
															</cfinvoke>

														</cfif>

														<cfset summary_value = left(field_value, 55)&"...">

														<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="insertBR" returnvariable="summary_value">
															<cfinvokeargument name="string" value="#summary_value#">
														</cfinvoke>--->
														<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="insertBR" returnvariable="summary_value">
															<cfinvokeargument name="string" value="#summary_value#">
														</cfinvoke>

														<cfif fields.field_type_id IS NOT 11><!--- IS NOT Very long text --->
															<cfset field_value = '#summary_value#<span class="hidden">#field_value#</span>'>
														<cfelse>
															<cfset field_value = summary_value>
														</cfif>											

													<cfelseif fields.field_type_id IS 2>

														<cfset field_value = HTMLEditFormat(field_value)>

														<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="insertBR" returnvariable="field_value">
															<cfinvokeargument name="string" value="#field_value#">
														</cfinvoke>---->

														<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="insertBR" returnvariable="field_value">
															<cfinvokeargument name="string" value="#field_value#">
														</cfinvoke>

													</cfif>

												</cfif>
												
											</cfif>
										</cfif>

									</cfif>
									
									<cfif fields.field_type_id IS 5 AND isDefined("cf_locale") AND cf_locale EQ "es_ES"><!---Esto es neceario para que se sume correctamente, el valor que se suma es el de data-text--->

										<cfif tableRows['field_#fields.field_id#'] GT 0>
											<td data-text="#tableRows['field_#fields.field_id#']#">#field_value#</td>
										<cfelse>
											<td data-text="0">#field_value#</td>
										</cfif>

									<cfelseif fields.field_type_id IS 4 OR fields.field_type_id IS 5>

										<!--- Para que las sumas de los campos numéricos sean correctas deben introducirse 0 en los valores vacíos --->
										<cfif tableRows['field_#fields.field_id#'] GT 0>
											<td>#field_value#</td>
										<cfelse>
											<td data-text="0">#field_value#</td>
										</cfif>

									<cfelse>

										<td>#field_value#</td>

									</cfif>

								</cfif>

							</cfloop>
						</tr>
					</cfloop>
					</tbody>

					<tfoot>
					   <tr>
							<th></th>
							<cfloop query="fields">
								<cfif fields.field_type_id EQ 4><!--- INTEGER --->
									<th data-math="col-sum" data-math-mask="##"></th><!---data-math-mask="##000"--->
								<cfelseif fields.field_type_id IS 5><!--- DECIMAL --->

									<cfif isNumeric(fields.mask_type_id)>
										<cfset field_mask_type_id = fields.mask_type_id>
										<th data-math="col-sum" data-math-mask="#maskTypesStruct[field_mask_type_id].tablesorterd_data_mask#"></th>
									<cfelse>
										<th data-math="col-sum" data-math-mask="####.00"></th>
									</cfif>

									<!---<th data-math="col-sum" data-math-mask="##.00"></th>--->
									
								<cfelse>
									<th></th>
								</cfif>
							</cfloop>
						</tr>
					</tfoot>

				</table>

			</div>

		<cfif isDefined("onpenUrlHtml2")>
			
			<!---Esta acción sólo se completa si está en la versión HTML2--->
			<script>
				openUrlHtml2('#onpenUrlHtml2#','itemIframe');
			</script>

		</cfif>


		</cfoutput>


	</cffunction>


</cfcomponent>
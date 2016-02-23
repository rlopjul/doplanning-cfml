<!---Copyright Era7 Information Technologies 2007-2014--->
<cfcomponent output="true">

	<cfset component = "RowHtml">

	<cfset DISPLAY_TYPE_DEFAULT = "default">
	<cfset DISPLAY_TYPE_HORIZONTAL = "horizontal">


	<!--- ----------------------- outputRowFormInputs -------------------------------- --->

	<cffunction name="outputRowFormInputs" access="public" returntype="void" output="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row" type="object" required="true">
		<cfargument name="fields" type="query" required="true">
		<cfargument name="language" type="string" required="true">
		<cfargument name="search_inputs" type="boolean" required="false" default="false">
		<cfargument name="displayType" type="string" required="false" default="#DISPLAY_TYPE_DEFAULT#">
		<cfargument name="include_admin_fields" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">


		<cfset var text_input_class = "form-control">
		<cfset var fieldSetOpen = false>

		<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

		<cfoutput>

		<input type="hidden" name="tableTypeId" value="#tableTypeId#"/>
		<input type="hidden" name="table_id" value="#table_id#"/>
		<input type="hidden" name="include_admin_fields" value="#arguments.include_admin_fields#"/>

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

			<cfset field_label = fields.label>
			<cfset field_name = "field_#fields.field_id#">


			<cfif fields.field_type_id EQ 20><!---SEPARATOR--->

				<cfif fieldSetOpen IS true>
					</fieldset>
				</cfif>

				<fieldset>

				<legend>#field_label#</legend>

				<cfif len(fields.description) GT 0 AND arguments.search_inputs IS false><p>#fields.description#</p></cfif>

				<cfset fieldSetOpen = true>

			<cfelseif fields.field_type_id EQ 21><!---HIDDEN FIELD--->

				<cfif isDefined("row[field_name]")>
					<cfset field_value = row[field_name]>
				<cfelse>
					<cfset field_value = "">
				</cfif>

				<input type="#fields.input_type#" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" />

			<cfelse>

				<cfif fields.required IS true AND arguments.search_inputs IS false>
					<cfset field_required_att = 'required="required"'>
				<cfelse>
					<cfset field_required_att = "">
				</cfif>

				<cfif fields.field_type_id NEQ 9 AND fields.field_type_id NEQ 10><!--- IS NOT SELECT FROM AREA--->
					<cfif isDefined("row[field_name]")>
						<cfset field_value = row[field_name]>
					<cfelse>
						<cfset field_value = ""><!---Empty booleans and text lists--->
					</cfif>
				</cfif>

				<div class="row">
				<div class="col-md-12">

					<cfif ( fields.field_input_type NEQ "checkbox" OR arguments.search_inputs IS true OR fields.field_type_group EQ "list" ) AND len(field_label) GT 0>

						<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
							<cfset labelClass = "col-xs-5 col-sm-4 col-md-3 control-label">
						<cfelse>
							<cfset labelClass = "control-label">
						</cfif>

						<label for="#field_name#" class="#labelClass#">#field_label# <cfif fields.required IS true AND arguments.search_inputs IS false>*</cfif></label>

					</cfif>

					<cfif arguments.displayType NEQ DISPLAY_TYPE_HORIZONTAL>
						<cfif len(fields.description) GT 0 AND arguments.search_inputs IS false><small class="help-block">#fields.description#</small></cfif>
					</cfif>


					<cfif fields.field_type_group IS "long_text" OR fields.field_type_group IS "very_long_text"><!--- TEXTAREA --->

						<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
								<div class="col-xs-7 col-sm-8 col-md-9">
						</cfif>

						<cfif arguments.search_inputs IS false>

							<textarea name="#field_name#" id="#field_name#" class="form-control" #field_required_att# maxlength="#fields.max_length#" <cfif fields.field_type_id IS 2>rows="4"<cfelse>rows="10"</cfif>>#field_value#</textarea>

							<cfif fields.required IS true>
								<script type="text/javascript">
									addRailoRequiredTextInput("#field_name#", "Campo '#field_label#' obligatorio");
								</script>
							</cfif>

							<cfif fields.field_type_id IS 3 OR fields.field_type_id IS 11>
								<!--- Enable CKEDITOR in mobile browsers --->
								<script>
									if ( window.CKEDITOR && ( !CKEDITOR.env.ie || CKEDITOR.env.version > 7 ) )
	   									CKEDITOR.env.isCompatible = true;

									CKEDITOR.replace('#field_name#', {toolbar:'DP', toolbarStartupExpanded:true, language:'#arguments.language#'});
								</script>
							</cfif>

						<cfelse><!--- Search --->

							<cfset field_value = HTMLEditFormat(field_value)>

							<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="#text_input_class#" />

						</cfif>

						<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
							</div>
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

						<cfif displayType EQ DISPLAY_TYPE_HORIZONTAL>
							<div class="col-xs-7 col-sm-8 col-md-9">
						<cfelse>
							<div class="row">
								<div class="col-xs-6 col-sm-3">
						</cfif>


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


							<cfif displayType NEQ DISPLAY_TYPE_HORIZONTAL>
								</div>
								<div class="col-xs-6 col-sm-9" style="padding-top:5px;">
							</cfif>

								<i id="decimal-help#fields.field_id#" class="icon-question-sign" data-toggle="tooltip" data-placement="bottom" data-html="true" title="Los decimales se deben introducir con un punto, ejemplo: 9999.99<cfif len(mask_label) GT 0><br>Al valor introducido se le aplicará posteriormente la siguiente máscara para mostrarlo: #mask_label#</cfif>" lang="es" style="cursor:pointer"></i>

						<cfif displayType EQ DISPLAY_TYPE_HORIZONTAL>
							</div>
						<cfelse>
								</div>
							</div>
						</cfif>

						<script>
							$(document).ready(function() {
								$("##decimal-help#fields.field_id#").tooltip();
							});
							<cfif fields.required IS true AND arguments.search_inputs IS false>
								addRailoRequiredFloat("#field_name#", "El campo '#field_label#' debe ser numérico y es obligatorio");
							<cfelse>
								addRailoValidateFloat("#field_name#", "El campo '#field_label#' debe ser numérico");
							</cfif>
						</script>


					<cfelseif fields.field_type_group IS "date"><!--- DATE --->


						<cfif action NEQ "create" AND NOT isDefined("FORM.tableTypeId") AND isDate(field_value)>
							<cfset field_value = DateFormat(field_value, APPLICATION.dateFormat)>
						</cfif>

						<cfif displayType EQ DISPLAY_TYPE_HORIZONTAL>
							<div class="col-xs-7 col-sm-8 col-md-9">
						<cfelse>
							<div class="row">
								<div class="col-xs-6 col-sm-3">
						</cfif>

								<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="form-control input_datepicker"/>

						<cfif displayType NEQ DISPLAY_TYPE_HORIZONTAL>
							</div>
							<div class="col-xs-6 col-sm-9" style="padding-top:5px;">
						</cfif>

								<small lang="es">Fecha formato DD-MM-AAAA</small>

						<cfif displayType EQ DISPLAY_TYPE_HORIZONTAL>
							</div>
						<cfelse>
								</div>
							</div>
						</cfif>


						<script type="text/javascript">
							<cfif fields.required IS true AND arguments.search_inputs IS false>
								addRailoRequiredDate("#field_name#", "El campo '#field_label#' debe ser una fecha con formato DD-MM-AAAA y es obligatorio");
							<cfelse>
								addRailoValidateDate("#field_name#", "El campo '#field_label#' debe ser una fecha con formato DD-MM-AAAA");
							</cfif>

							<!---$(document).ready(function(){--->
								enableDatePicker('###field_name#');
							<!---});--->
						</script>

					<cfelseif fields.field_type_group IS "url"><!--- URL --->


						<cfif displayType EQ DISPLAY_TYPE_HORIZONTAL>
								<div class="col-xs-7 col-sm-8 col-md-9">
						</cfif>

						<!---<cfif arguments.client_abb EQ "hcs" OR ><!--- Deshabilitado en el HCS la obligación de introducir URLs completas para que se puedan introducir URLs relativas --->
							<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# placeholder="http://" class="#text_input_class#"/>
						<cfelse>--->
							<input type="#fields.input_type#" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# placeholder="http://" class="#text_input_class#"/>
						<!---</cfif>--->

						<cfif displayType EQ DISPLAY_TYPE_HORIZONTAL>
							</div>
						</cfif>

						<cfif fields.required IS true AND arguments.search_inputs IS false>
							<script>
								addRailoRequiredTextInput("#field_name#", "Campo '#field_label#' obligatorio");
							</script>
						</cfif>


					<cfelseif fields.field_type_group IS "short_text"><!--- TEXT --->


						<cfif displayType EQ DISPLAY_TYPE_HORIZONTAL>
								<div class="col-xs-7 col-sm-8 col-md-9">
						</cfif>

						<cfif arguments.search_inputs IS true>
							<cfset field_value = HTMLEditFormat(field_value)>
						</cfif>

						<input type="#fields.input_type#" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="#fields.max_length#" #field_required_att# class="#text_input_class#" <cfif len(field_label) IS 0><!---PARA DP ASEBIO (campo otros)--->style="margin-left:35px;width:80%;"</cfif> />

						<cfif displayType EQ DISPLAY_TYPE_HORIZONTAL>
							</div>
						</cfif>

						<cfif fields.required IS true AND arguments.search_inputs IS false>
							<script type="text/javascript">
								addRailoRequiredTextInput("#field_name#", "Campo '#field_label#' obligatorio");
							</script>
						</cfif>


					<cfelseif fields.field_type_group IS "boolean"><!--- BOOLEAN --->

						<cfif displayType EQ DISPLAY_TYPE_HORIZONTAL>
							<div class="<cfif arguments.search_inputs IS false AND fields.field_input_type EQ 'checkbox'>col-xs-offset-5 col-sm-offset-4 col-md-offset-3</cfif> col-xs-7 col-sm-8 col-md-9">
						<cfelse>
							<div class="row">
								<div class="col-sm-12"><!---col-xs-5 col-sm-2--->
						</cfif>

								<cfif fields.field_input_type EQ "radio"><!---Radio--->

									<div>
									  <label>
									  	<input type="#field_input_type#" name="#field_name#" value="1" <cfif field_value IS true>checked</cfif> />&nbsp;Sí
									  </label>&nbsp;&nbsp;
									  <label>
									    <input type="#field_input_type#" name="#field_name#" value="0" <cfif field_value IS false>checked</cfif> />&nbsp;No

									  </label>
									</div>

								<cfelseif fields.field_input_type EQ "checkbox" AND arguments.search_inputs IS false><!---Checkbox--->

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

						<cfif displayType EQ DISPLAY_TYPE_HORIZONTAL>
								</div>
						<cfelse>
								</div>
							</div>
						</cfif>

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

									<cfif isDefined("row[field_name]")>

										<cfset selectedAreasList = row[field_name]>

										<cfif isArray(selectedAreasList)>
											<cfset selectedAreasList = arrayToList(selectedAreasList)>
										</cfif>

									<cfelse><!--- Empty field in searchs --->
										<cfset selectedAreasList = "">
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
										<cfset field_value = arrayToList(field_value,"#chr(13)##chr(10)#")>
									</cfif>

								</cfif>

							<cfelse><!---FORM is Defined--->

								<cfif isDefined("FORM.#field_name#")>
									<cfset field_value = arrayToList(field_value,"#chr(13)##chr(10)#")>
								<cfelse>
									<cfset field_value = "">
								</cfif>

							</cfif>


						</cfif>

						<cfif fields.field_input_type EQ "radio" OR fields.field_input_type EQ "checkbox"><!---RADIO / CHECKBOX--->

							<!---<cfif (fields.field_type_id IS 9 AND fields.required IS false) OR arguments.search_inputs IS true>
								<option value=""></option>
							</cfif>--->

							<cfif displayType EQ DISPLAY_TYPE_HORIZONTAL>
								<div class="col-xs-7 col-sm-8 col-md-9" style="margin-bottom:10px;">
							<cfelse>
								<div class="row">
									<div class="col-sm-offset-1 col-sm-10" style="margin-bottom:10px;">
							</cfif>

							<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- List area values --->

								<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreas" returnvariable="subAreas">
									<cfinvokeargument name="area_id" value="#fields.list_area_id#">
									<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
									<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
								</cfinvoke>

								<cfif subAreas.recordCount GT 0>

									<cfinvoke component="AreaHtml" method="outputSubAreasInput">
										<cfinvokeargument name="area_id" value="#fields.list_area_id#">
										<cfinvokeargument name="subAreas" value="#subAreas#">
										<cfif len(selectedAreasList) GT 0>
											<cfinvokeargument name="selected_areas_ids" value="#selectedAreasList#">
										</cfif>
										<cfinvokeargument name="recursive" value="false">
										<cfinvokeargument name="field_name" value="#field_name#"/>
										<cfinvokeargument name="field_input_type" value="#fields.field_input_type#">
										<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
										<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
									</cfinvoke>

								<cfelse>

									<p class="help-block" lang="es">No hay opciones definidas para seleccionar</p>

								</cfif>


							<cfelse><!--- List text values --->

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

							</cfif>

							<cfif displayType EQ DISPLAY_TYPE_HORIZONTAL>
								</div>
							<cfelse>
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

							<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
								<div class="col-xs-7 col-sm-8 col-md-9">
							</cfif>

							<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- List area values --->

								<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreas" returnvariable="subAreas">
									<cfinvokeargument name="area_id" value="#fields.list_area_id#">
									<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
									<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
								</cfinvoke>

								<cfif subAreas.recordCount IS 0>

									<p class="help-block" lang="es">No hay opciones definidas para seleccionar</p>

								</cfif>

							</cfif>

							<select name="#field_name#[]" id="#field_name#" #field_required_att# class="form-control selectpicker" <cfif (fields.field_type_id IS 10 OR fields.field_type_id IS 16)>multiple style="height:90px"</cfif>><!---AND arguments.search_inputs IS false--->
								<cfif ( (fields.field_type_id IS 9 OR fields.field_type_id IS 15) AND fields.required IS false ) OR ( arguments.search_inputs IS true AND (fields.field_type_id NEQ 10 AND fields.field_type_id NEQ 16) )>
									<option value=""></option>
								</cfif>

								<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- List area values --->

									<cfinvoke component="AreaHtml" method="outputSubAreasSelect">
										<cfinvokeargument name="area_id" value="#fields.list_area_id#">
										<cfinvokeargument name="subAreas" value="#subAreas#">
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
								<small class="help-block" lang="es">Utilice la tecla Ctrl para seleccionar varios elementos de la lista</small>
							</cfif>

							<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
							</div>
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

						<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
							<div class="col-xs-6 col-sm-7 col-md-8">
						<cfelse>
							<div class="row">
								<div class="col-xs-11 col-sm-6">
						</cfif>

									<input type="hidden" name="#field_name#" id="#field_name#" value="#field_value#" />
									<input type="text" name="#field_name#_user_full_name" id="#field_name#_user_full_name" value="#field_value_user#" #field_required_att# class="#text_input_class#" readonly onclick="openUserSelectorWithField('#field_name#')" />
									<cfif fields.required IS true AND arguments.search_inputs IS false>
										<script type="text/javascript">
											addRailoRequiredInteger("#field_name#", "Campo '#field_label#' obligatorio");
										</script>
									</cfif>
								</div>

							<cfif fields.required IS false OR arguments.search_inputs IS true>
								<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
									<div class="col-xs-1 col-sm-1 col-md-1">
								<cfelse>
									<div class="col-xs-1 col-sm-6">
								</cfif>
									<button onclick="clearFieldSelectedUser('#field_name#')" type="button" class="btn btn-default" lang="es" title="Quitar usuario seleccionado"><i class="icon-remove"></i></button>
								</div>
							</cfif>

						<cfif arguments.displayType NEQ DISPLAY_TYPE_HORIZONTAL>
							</div><!--- END row --->
						</cfif>

						<div class="row">

							<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
								<div class="col-xs-5 col-sm-4 col-md-3"></div>
								<div class="col-xs-7 col-sm-8 col-md-9">
							<cfelse>
								<div class="col-xs-12 col-sm-6">
							</cfif>

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

									<cfinvokeargument name="client_abb" value="#client_abb#">
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

									<cfinvokeargument name="client_abb" value="#client_abb#">
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


						<cfif isNumeric(fields.list_area_id)><!--- Select item of one area --->

							<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
								<div class="col-xs-7 col-sm-8 col-md-9">
							</cfif>

							<cfif isDefined("SESSION.user_id")>

								<!--- checkAreaAccess --->
								<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaManager" method="canUserAccessToArea" returnvariable="accessResult">
									<cfinvokeargument name="area_id" value="#fields.list_area_id#">
									<cfinvokeargument name="user_id" value="#SESSION.user_id#">

									<cfinvokeargument name="client_abb" value="#client_abb#">
									<cfinvokeargument name="client_dsn" value="#client_dsn#">
								</cfinvoke>

								<cfif accessResult IS true>

									<select name="#field_name#" id="#field_name#" #field_required_att# class="form-control">

										<cfif fields.required IS false OR arguments.search_inputs IS true>
											<option value=""></option>
										</cfif>

										<cfif fields.item_type_id IS 10><!--- Files --->

											<!--- getAreaFiles --->
											<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getAreaFiles" returnvariable="getAreaFilesResult">
												<cfinvokeargument name="area_id" value="#fields.list_area_id#">
												<cfinvokeargument name="parse_dates" value="true">

												<cfinvokeargument name="with_user" value="true"/>

												<cfinvokeargument name="order_by" value="name">
												<cfinvokeargument name="order_type" value="ASC">

												<cfinvokeargument name="client_abb" value="#client_abb#">
												<cfinvokeargument name="client_dsn" value="#client_dsn#">
											</cfinvoke>

											<cfset files = getAreaFilesResult.query>

											<cfloop query="files">
												<cfif files.id IS field_value>
													<cfset value_selected = true>
												<cfelse>
													<cfset value_selected = false>
												</cfif>
												<option value="#files.id#" <cfif value_selected>selected</cfif>>#files.name#</option>
											</cfloop>


										<cfelse><!--- Items --->


											<!--- getAreaItems --->
											<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getAreaItems" returnvariable="getAreaItemsResult">
												<cfinvokeargument name="area_id" value="#fields.list_area_id#">
												<cfinvokeargument name="itemTypeId" value="#fields.item_type_id#">
												<cfinvokeargument name="listFormat" value="true">
												<cfinvokeargument name="format_content" value="default">
												<cfinvokeargument name="with_user" value="false">
												<cfinvokeargument name="parse_dates" value="false"/>
												<cfinvokeargument name="published" value="false">

												<cfinvokeargument name="client_abb" value="#client_abb#">
												<cfinvokeargument name="client_dsn" value="#client_dsn#">
											</cfinvoke>

											<cfset areaItemsQuery = getAreaItemsResult.query>

											<cfloop query="areaItemsQuery">
												<cfif areaItemsQuery.id IS field_value>
													<cfset value_selected = true>
												<cfelse>
													<cfset value_selected = false>
												</cfif>
												<option value="#areaItemsQuery.id#" <cfif value_selected>selected</cfif>>#areaItemsQuery.title#</option>
											</cfloop>


										</cfif>

									</select>

								<cfelse>

									<cfthrow message="No tiene permiso de acceso al área donde están los elementos a seleccionar">

								</cfif>

							<cfelse>

								<cfthrow message="Este tipo de campo (Elemento de DoPlanning) sólo está disponible para ser rellenado desde DoPlanning">

							</cfif>

							<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
							</div>
							</cfif>


						<cfelse><!--- Select item of all areas --->


							<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
								<div class="col-xs-6 col-sm-7 col-md-8">
							<cfelse>
								<div class="row">
									<div class="col-xs-11 col-sm-6">
							</cfif>

									<input type="hidden" name="#field_name#" id="#field_name#" value="#field_value#" />
									<input type="text" name="#field_name#_title" id="#field_name#_title" value="#HTMLEditFormat(field_value_title)#" #field_required_att# class="#text_input_class#" readonly onclick="openItemSelectorWithField(#fields.item_type_id#,'#field_name#')" />
									<cfif fields.required IS true AND arguments.search_inputs IS false>
										<script type="text/javascript">
											addRailoRequiredInteger("#field_name#", "Campo '#field_label#' obligatorio");
										</script>
									</cfif>


								</div>

								<cfif fields.required IS false OR arguments.search_inputs IS true>
									<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
										<div class="col-xs-1 col-sm-1 col-md-1">
									<cfelse>
										<div class="col-xs-1 col-sm-6">
									</cfif>

										<button onclick="clearFieldSelectedItem('#field_name#')" type="button" class="btn btn-default" lang="es" title="Quitar elemento seleccionado"><i class="icon-remove"></i></button>

									</div>
								</cfif>

							<cfif arguments.displayType NEQ DISPLAY_TYPE_HORIZONTAL>
							</div><!--- END row --->
							</cfif>

							<div class="row">

								<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
									<div class="col-xs-5 col-sm-4 col-md-3"></div>
									<div class="col-xs-7 col-sm-8 col-md-9">
								<cfelse>
									<div class="col-xs-12 col-sm-6">
								</cfif>

									<button onclick="openItemSelectorWithField(#fields.item_type_id#,'#field_name#')" type="button" class="btn btn-default" lang="es">Seleccionar elemento</button>

								</div>

							</div>


						</cfif>

					<cfelseif fields.field_type_group IS "table_row"><!--- Registro de tabla --->



						<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
							<div class="col-xs-7 col-sm-8 col-md-9">
						</cfif>

								<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
								</cfinvoke>

								<cfset referencedTableId = fields.referenced_table_id>
								<cfset referencedTableTypeName = itemTypesStruct[fields.item_type_id].name>

								<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTable" returnvariable="referencedTableQuery">
									<cfinvokeargument name="table_id" value="#referencedTableId#">
									<cfinvokeargument name="tableTypeId" value="#itemTypesStruct[fields.item_type_id].tableTypeId#">
									<cfinvokeargument name="parse_dates" value="false">
									<cfinvokeargument name="published" value="false">

									<cfinvokeargument name="client_abb" value="#client_abb#">
									<cfinvokeargument name="client_dsn" value="#client_dsn#">
								</cfinvoke>

								<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="rowQuery">
									<cfinvokeargument name="table_id" value="#referencedTableId#">
									<cfinvokeargument name="tableTypeId" value="#itemTypesStruct[fields.item_type_id].tableTypeId#">

									<cfinvokeargument name="client_abb" value="#client_abb#">
									<cfinvokeargument name="client_dsn" value="#client_dsn#">
								</cfinvoke>

								<cfset referencedRowUrl = "#APPLICATION.mainUrl#/?abb=#client_abb#&area=#referencedTableQuery.area_id#&#referencedTableTypeName#=#referencedTableId#&row=">

								<select name="#field_name#" id="#field_name#" #field_required_att# class="form-control selectpicker" data-live-search="true" data-width="100%" data-size="5" data-container="body" onchange=" $('##referencedRowLink').attr('href', '#referencedRowUrl#'+$('###field_name#').val() )">

									<cfif fields.required IS false OR arguments.search_inputs IS true>
										<option value=""></option>
									</cfif>

									<cfloop query="rowQuery">
										<cfif rowQuery.row_id IS field_value>
											<cfset value_selected = true>
											<cfset selected_row_id = rowQuery.row_id>
										<cfelse>
											<cfset value_selected = false>
										</cfif>

										<cfset referencedRowValue = rowQuery['field_#fields.referenced_field_id#']>

										<option value="#rowQuery.row_id#" <cfif value_selected>selected</cfif>>#referencedRowValue#</option>
									</cfloop>

								</select>

								<script>
								$('###field_name#').selectpicker();
								</script>

								<cfif arguments.tableTypeId NEQ 2><!--- IS NOT FORM --->

									<cfif isDefined("selected_row_id") AND isNumeric(selected_row_id)>
										<a class="btn btn-default btn-xs" id="referencedRowLink" target="_blank" href="#APPLICATION.mainUrl#/?abb=#client_abb#&area=#referencedTableQuery.area_id#&#referencedTableTypeName#=#referencedTableId#&row=#selected_row_id#"><i class="fa fa-external-link"></i> <span lang="es">Ver</span> #field_label#</a>
									<cfelseif ( isDefined("row.row_id") AND isNumeric(row.row_id) ) OR arguments.tableTypeId NEQ 4><!---Is not user register public page--->
										<a class="btn btn-default btn-xs" id="referencedRowLink" target="_blank" href="#APPLICATION.mainUrl#/?abb=#client_abb#&area=#referencedTableQuery.area_id#&#referencedTableTypeName#=#referencedTableId#"><i class="fa fa-external-link"></i> <span lang="es">Ver</span> #field_label#</a>
									</cfif>

									<!---<a class="btn btn-default btn-xs" target="_blank" href="#APPLICATION.mainUrl#/?abb=#client_abb#&area=#referencedTableQuery.area_id#&#referencedTableTypeName#=#referencedTableId#"><i class="fa fa-external-link"></i> Editar</a>--->

								</cfif>

						<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
						</div>
						</cfif>



					<cfelseif fields.field_type_group IS "file"><!--- Attached file --->

						<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
							<div class="col-xs-7 col-sm-8 col-md-9">
						</cfif>

						<cfif arguments.search_inputs IS false>

							<cfif len(fields.list_values) GT 0>
								<cfset acceptFileTypes = ListChangeDelims(fields.list_values, ",", "#chr(13)##chr(10)#")>
							</cfif>

							<cfif isNumeric(field_value) GT 0 AND NOT isDefined("FORM.tableTypeId")>
								<cfset field_required_att = "">
							</cfif>

							<input type="#fields.input_type#" name="#field_name#" id="#field_name#" #field_required_att# <cfif len(fields.list_values) GT 0>accept="#acceptFileTypes#"</cfif> class="#text_input_class#" />

							<cfif isNumeric(field_value) GT 0 AND NOT isDefined("FORM.tableTypeId")>

								<div id="attachedFile#field_id#">

									<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
										<cfinvokeargument name="file_id" value="#field_value#">
										<cfinvokeargument name="parse_dates" value="false"/>
										<cfinvokeargument name="published" value="false"/>

										<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
										<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
									</cfinvoke>

									<cfif fileQuery.recordCount GT 0>
										<cfset fileName = fileQuery.file_name>
									<cfelse>
										<cfset fileName = "<i>ARCHIVO NO DISPONIBLE</i>">
									</cfif>

									<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#field_value#&#tableTypeName#=#table_id#" onclick="return downloadFileLinked(this,event)">#fileName#</a>&nbsp;

									<cfif fields.required IS false>
										<button type="button" onclick="deleteAttachedFile(#field_id#)" class="btn btn-xs btn-default"><i class="icon-remove"></i> <span lang="es">Eliminar archivo</span></button>
									</cfif>

								</div>

							<cfelse>

								<cfif fields.required IS true AND arguments.search_inputs IS false>
									<script>
										addRailoRequiredTextInput("#field_name#", "Campo '#field_label#' obligatorio");
									</script>
								</cfif>

							</cfif>

							<cfif len(fields.list_values) GT 0>
								<div class="help-block"><span lang="es">Formatos aceptados:</span> <span lang="es">#acceptFileTypes#</span></div>
							</cfif>

						<cfelse><!--- Search --->

							<input type="text" name="#field_name#" id="#field_name#" value="#field_value#" maxlength="100" #field_required_att# class="#text_input_class#" />

						</cfif>

						<cfif arguments.displayType EQ DISPLAY_TYPE_HORIZONTAL>
						</div>
						</cfif>


					</cfif><!--- END fields.field_type_group --->

					<cfif displayType EQ DISPLAY_TYPE_HORIZONTAL>
						<div><!---class="row"--->
							<div class="col-xs-5 col-sm-4 col-md-3"></div>
							<div class="col-xs-7 col-sm-8 col-md-9">
								<cfif len(fields.description) GT 0 AND arguments.search_inputs IS false><small class="help-block">#fields.description#</small></cfif>
								<cfif fields.include_in_all_users IS false AND arguments.search_inputs IS false>
									<small lang="es">Este campo solo pueden rellenarlo los usuarios administradores</small>
								</cfif>
							</div>
						</div>
					</cfif>

				</div><!---END col-md-12--->
				</div><!---END div class="row"--->

			</cfif><!---END fields.field_type_id NEQ 20--->

		</cfloop>

		<cfif fieldSetOpen IS true>
			</fieldset>
		</cfif>

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
		<cfargument name="tablesorterEnabled" type="boolean" required="false" default="true">
		<cfargument name="mathEnabled" type="boolean" required="false" default="false">
		<cfargument name="includeLinkButton" type="boolean" required="false" default="false">
		<cfargument name="linkButtonText" type="string" required="false" default='<i class="fa fa-external-link"></i>'>
		<cfargument name="includeEditButton" type="boolean" required="false" default="false">
		<cfargument name="rowUrlPath" type="string" required="false">
		<cfargument name="fileUrlPath" type="string" required="false">
		<cfargument name="includeFullText" type="boolean" required="false" default="true">
		<cfargument name="table_general" type="boolean" required="false" default="false">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="includeFromAreaColumn" type="boolean" required="false" default="false">
		<cfargument name="includePositionColumn" type="boolean" required="false" default="true">
		<cfargument name="doubleScrollEnabled" type="boolean" required="false" default="true">
		<cfargument name="scrollerEnabled" type="boolean" required="false" default="false"><!---Widget deshabilitado. Scroller no se debe usar en tablas de más de 100 registros--->
		<cfargument name="stickyHeadersEnabled" type="boolean" required="false" default="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

		<!--- getFieldMaskTypes --->
		<cfinvoke component="FieldManager" method="getFieldMaskTypesStruct" returnvariable="maskTypesStruct">
			<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
		</cfinvoke>

		<cfoutput>

		<!---uitheme ralentiza las tablas grandes--->

		<cfif arguments.tablesorterEnabled IS true>
			<script>

				$(document).ready(function() {

					$("##dataTable#arguments.tableTypeId#_#arguments.table_id#").tablesorter({  <!--- Se le asigna un id único a la tabla por si hay más en la misma página --->

						<!---widthFixed: true,--->
						showProcessing: true,
						delayInit: false, <!--- Tiene que estar a false para que funcione filter sin orden de columnas predefinido --->
						widgets: ['filter'
							<!---<cfif tableRows.recordCount LT 100>,'saveSort'</cfif>Este plugin no debe usarse con listas grandes--->
							<cfif arguments.mathEnabled IS true>,'math'</cfif>
							<cfif isDefined("arguments.columnSelectorContainer")>,'columnSelector'</cfif>
							<cfif arguments.stickyHeadersEnabled IS true>
								,'stickyHeaders'
							<cfelseif arguments.scrollerEnabled IS true>
								,'scroller'
							</cfif>
						],<!---'zebra','uitheme',--->

						<!--- http://mottie.github.io/tablesorter/docs/example-option-date-format.html ---->
						dateFormat : "ddmmyyyy", // set the default date format

						headers: {

							<cfif arguments.includeLinkButton IS true OR arguments.includeEditButton IS true>
							0: {
								sorter: false
							},
								<cfif arguments.includePositionColumn IS true>
								1: {
									sorter: "digit"
								},
								</cfif>
							<cfelseif arguments.includePositionColumn IS true>
							0: {
								sorter: "digit"
							},
							</cfif>

							<cfset sortArray = arrayNew(1)>

							<cfloop query="fields">

								<cfif arguments.includeLinkButton IS true OR arguments.includeEditButton IS true>
									<cfif arguments.includePositionColumn IS true>
										<cfset curFieldIndex = fields.currentRow+1>
									<cfelse>
										<cfset curFieldIndex = fields.currentRow>
									</cfif>
								<cfelseif arguments.includePositionColumn IS true>
									<cfset curFieldIndex = fields.currentRow>
								<cfelse>
									<cfset curFieldIndex = fields.currentRow-1>
								</cfif>

								<cfif fields.field_id IS "creation_date" OR fields.field_id IS "last_update_date" OR fields.field_type_id IS 6><!--- DATE --->

									#curFieldIndex#: {
										<!---sorter: "datetime"--->
										sorter: "shortDate"
									},

								<cfelseif fields.field_id NEQ 4 AND fields.field_id NEQ 5><!--- IS NOT INTEGER OR DECIMAL --->

									#curFieldIndex#: {
										sorter: "text"
									},

								</cfif>

								<cfif len(fields.sort_by_this) GT 0>
									<cfif fields.sort_by_this IS "asc">
										<cfset sortOrder = 0>
									<cfelse>
										<cfset sortOrder = 1>
									</cfif>

									<cfset arrayAppend(sortArray, {row=curFieldIndex, order=sortOrder})>

								</cfif>

							</cfloop>
						},
						// default "emptyTo"
			   			emptyTo: 'zero',
						<!---textExtraction: 'basic',--->
						 // Enable use of the characterEquivalents reference
	    				sortLocaleCompare : true,
						textAttribute: "data-text",
						textExtraction: "basic",
						usNumberFormat: true, <!--- Requerido para que la suma de los valores de las comlumnas con decimales separados por . sea correcta (esto hace que los decimales separados por , no se sumen correctamente, pero para eso se usa la opción de definir el valor de la columena en data-text)  ---->
						<cfset sortArrayLen = arrayLen(sortArray)>
						<cfif sortArrayLen GT 0>

							<cfif tableRows.recordCount LT 1000>
								sortList: [
								<cfloop from="1" to="#sortArrayLen#" index="curSort">
									[#sortArray[curSort].row#, #sortArray[curSort].order#]
									<cfif curSort NEQ sortArrayLen>
										,
									</cfif>
								</cfloop> ],
							</cfif>

						<cfelseif arguments.includePositionColumn IS true>
							<cfif tableRows.recordCount LT 100><!---Ordenar de nuevo la tabla por el campo por defecto ralentiza las tablas con muchas filas--->
								<cfif arguments.includeLinkButton IS true OR arguments.includeEditButton IS true>
									sortList: [[1,1]] ,
								<cfelse>
									sortList: [[0,1]] ,
								</cfif>
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

							<cfif arguments.mathEnabled IS true>
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
							</cfif>

							<!---<cfif arguments.stickyHeadersEnabled IS true>
								Esto no vale para dispositivos móviles en los que ##mainNavBarFixedTop está oculto
								<cfif arguments.doubleScrollEnabled IS true>
									,stickyHeaders_offset: $('##mainNavBarFixedTop').height()+18
								<cfelse>
									,stickyHeaders_offset: $('##mainNavBarFixedTop')
								</cfif>
							</cfif>--->

							<!---,stickyHeaders_attachTo : '##pageHeaderContainer' Esto no funciona--->

							<!---<cfif arguments.doubleScrollEnabled IS true>
							, stickyHeaders_xScroll : $('##tableDoubleScroll#arguments.tableTypeId#_#arguments.table_id#')
							</cfif>--->

							<cfif isDefined("arguments.columnSelectorContainer")>

								<!--- Column selector options --->

								// target the column selector markup
								, columnSelector_container : $('###arguments.columnSelectorContainer#')
								// column status, true = display, false = hide
								// disable = do not display on list
								, columnSelector_columns : {
									0: 'disable' /* set to disabled; not allowed to unselect it */
									<cfif arguments.includeLinkButton IS true OR arguments.includeEditButton IS true>
									, 1: 'disable'
									</cfif>
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

							<cfif arguments.scrollerEnabled IS true>
								, scroller_height : $(window).height()
							</cfif>
					    }

					}).bind('tablesorter-ready', function(e, table) {

						<cfif arguments.stickyHeadersEnabled IS true>

							adjustTableSorterStickyHeader();

						<cfelseif arguments.scrollerEnabled IS true>

							updateTableSorterScroller(getTableSorterScrollerHeight());

						</cfif>

					});

					$(window).resize( function() {

						<cfif arguments.stickyHeadersEnabled IS true>

							adjustTableSorterStickyHeader();

							<cfif arguments.doubleScrollEnabled IS true>

								onDoubleScrollAffixed(); <!--- Lo pone en su estado inicial --->

								$('.doubleScroll-scroll-wrapper').affix('checkPosition');

								if ( $('.doubleScroll-scroll-wrapper').css('position') == "fixed" ) {

									onDoubleScrollAffix(); <!--- Si está fijado recalcula la posicion --->

								}

							</cfif>

						<cfelseif arguments.scrollerEnabled IS true>

							updateTableSorterScroller(getTableSorterScrollerHeight());

						</cfif>

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

					<cfif arguments.doubleScrollEnabled IS true>

						$('##tableDoubleScroll#arguments.tableTypeId#_#arguments.table_id#').doubleScroll({
						    onlyIfScroll: true, // top scrollbar is not shown if the bottom one is not present
						    resetOnWindowResize: true
						});


						<cfif arguments.stickyHeadersEnabled IS true>

							$('.doubleScroll-scroll-wrapper').affix({
							  offset: {
							    top: function () {

										if( $('##mainNavBarFixedTop').length )
											return $('##mainNavBarFixedTop').height();
										else
											return 0;
							    }

							  }
							});

							$('##tableDoubleScroll#arguments.tableTypeId#_#arguments.table_id#').scroll(function(){

								if( $('.tablesorter-sticky-wrapper').css('visibility') == 'visible' )
									$(window).scroll(); <!--- Update stickyHeader position --->

							});

							$('.doubleScroll-scroll-wrapper').on('affix.bs.affix', function () {

								onDoubleScrollAffix();

							});


							$('.doubleScroll-scroll-wrapper').on('affixed-top.bs.affix', function () {

								onDoubleScrollAffixed();

							});

						</cfif>

					</cfif>

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
		</cfif>

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

		<cfif arguments.tablesorterEnabled IS true>
			<div id="tableDoubleScroll#arguments.tableTypeId#_#arguments.table_id#">
		</cfif>

				<cfif arguments.tablesorterEnabled IS false>
					<cfset tdStyle = 'style="padding:5px;border-width: 1px; border-style: solid; border-color: ##CCCCCC;"'>
					<cfset thStyle = 'style="padding:5px;border-left-width: 1px;border-left-color: ##CCCCCC;border-left-style: solid;"'>
					<cfset thTrStyle = 'style="background-color: ##EEEEEE;"'>
				<cfelse>
					<cfset tdStyle = ''>
					<cfset thStyle = ''>
					<cfset thTrStyle = ''>
				</cfif>

				<table id="dataTable#arguments.tableTypeId#_#arguments.table_id#" class="data-table table table-hover table-bordered table-striped tablesorter-bootstrap" style="<cfif arguments.tablesorterEnabled IS false>font-size:12px;border-collapse:collapse;margin-bottom:15px;<cfelse>margin-top:5px;</cfif>">
					<thead>
						<tr #thTrStyle#>
							<cfif arguments.includeLinkButton IS true OR arguments.includeEditButton IS true>
								<cfif arguments.includeLinkButton IS true AND arguments.includeEditButton IS true>
									<th style="width:65px;" class="filter-false"></th>
								<cfelse>
									<th style="width:25px;" class="filter-false"></th>
								</cfif>
							</cfif>
							<cfif arguments.includePositionColumn IS true>
								<th style="width:25px;">##</th>
							</cfif>
							<!---<th>Fecha última modificación</th>--->
							<cfloop query="fields">
								<cfif fields.field_id EQ "last_update_date">
									<th #thStyle#><span lang="es">#fields.label#</span></th>
								<cfelse>
									<th #thStyle# <cfif fields.field_type_id IS 7><!---Boolean--->class="filter-select"</cfif>>#fields.label#</th>
								</cfif>
								<cfif fields.field_type_id EQ 9 OR fields.field_type_id IS 10><!--- LISTS --->
									<cfset listFields = true>
								</cfif>
							</cfloop>
							<cfif arguments.includeFromAreaColumn IS true>
								<th class="filter-select"><span lang="es">De esta área</span></th>
							</cfif>
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

						<cfif NOT isDefined("arguments.rowUrlPath")>

							<cfif isDefined("arguments.view_id")>
								<cfset rpage = "#tableTypeName#_view_rows.cfm?#tableTypeName#_view=#arguments.view_id#">
								<cfset row_page_url = "#tableTypeName#_view_row.cfm?#tableTypeName#_view=#arguments.view_id#&row=#tableRows.row_id#&return_page=#URLEncodedFormat(rpage)#">
							<cfelse>

								<cfif table_general IS true>
									<cfset row_area_id = tableRows.area_id>
									<cfif isDefined("arguments.area_id")>
										<cfset from_area_param = "&from_area=#arguments.area_id#">
										<cfset rpage = "#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#&area=#arguments.area_id#">
									<cfelse>
										<cfset from_area_param = "">
										<cfset rpage = "#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#&area=#row_area_id#">
									</cfif>
									<cfset row_page_url = "#tableTypeName#_row.cfm?#tableTypeName#=#table_id#&row=#tableRows.row_id#&area=#row_area_id##from_area_param#&return_page=#URLEncodedFormat(rpage)#">
									<cfset row_edit_page_url = "#tableTypeName#_row_modify.cfm?#tableTypeName#=#table_id#&row=#tableRows.row_id#&area=#row_area_id##from_area_param#">

								<cfelse>
									<cfset rpage = "#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#">
									<cfset row_page_url = "#tableTypeName#_row.cfm?#tableTypeName#=#table_id#&row=#tableRows.row_id#&return_page=#URLEncodedFormat(rpage)#">
									<cfset row_edit_page_url = "#tableTypeName#_row_modify.cfm?#tableTypeName#=#table_id#&row=#tableRows.row_id#&area=#area_id#">
								</cfif>

							</cfif>

						<cfelse>

							<cfset row_page_url = "#arguments.rowUrlPath##tableRows.row_id#">

						</cfif>



						<!---Row selection--->
						<cfset dataSelected = false>

						<cfif alreadySelected IS false>

							<cfif ( isDefined("URL.row") AND URL.row IS tableRows.row_id ) OR ( selectFirst IS true AND tableRows.currentRow IS 1 AND app_version NEQ "mobile" ) ><!--- tableRows.recordCount --->

								<!---<cfset onpenUrlHtml2 = row_page_url>--->

								<cfset dataSelected = true>
								<cfset alreadySelected = true>

							</cfif>

						</cfif>

						<tr <cfif dataSelected IS true>class="selected"</cfif> <cfif arguments.openRowOnSelect IS true>data-item-url="#row_page_url#"</cfif>>

							<cfif arguments.includeLinkButton IS true OR arguments.includeEditButton IS true>
								<td #tdStyle#><cfif arguments.includeLinkButton IS true><a class="btn btn-default btn-xs" href="#row_page_url#" target="_blank" onclick="event.stopPropagation()">#arguments.linkButtonText#</a></cfif>
									<cfif arguments.includeEditButton IS true>
									<a class="btn btn-primary btn-xs" href="#row_edit_page_url#" onclick="event.stopPropagation()"><i class="fa fa-pencil"></i></a>
									</cfif>
								</td>
							</cfif>
							<cfif arguments.includePositionColumn IS true>
								<td #tdStyle#>#tableRows.row_id#</td>
							</cfif>

							<cfset row_id = tableRows.row_id>
							<cfloop query="fields">

								<cfif fields.field_id IS "creation_date"><!--- CREATION DATE --->

									<td #tdStyle#>#DateFormat(tableRows.creation_date, APPLICATION.dateFormat)# #TimeFormat(tableRows.creation_date, "HH:mm")#</td>

								<cfelseif fields.field_id IS "last_update_date"><!--- LAST UPDATE DATE --->

									<td #tdStyle#><cfif len(tableRows.last_update_date) GT 0>#DateFormat(tableRows.last_update_date, APPLICATION.dateFormat)# #TimeFormat(tableRows.last_update_date, "HH:mm")#<cfelse>-</cfif></td>

								<cfelseif fields.field_id IS "insert_user"><!--- INSERT USER --->

									<td #tdStyle#>#insert_user_full_name#</td>

								<cfelseif fields.field_id IS "update_user"><!--- UPDATE USER --->

									<td #tdStyle#>#update_user_full_name#</td>

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
												<!---<cfset field_value = DateFormat(dateConvert("local2Utc",field_value), APPLICATION.dateFormat)>--->
												<cfset field_value = DateFormat(field_value, APPLICATION.dateFormat)>
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


											<cfelseif fields.field_type_id IS 18><!--- ATTACHED FILE --->

												<cfif isNumeric(field_value)>

													<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
														<cfinvokeargument name="file_id" value="#field_value#">
														<cfinvokeargument name="parse_dates" value="false"/>
														<cfinvokeargument name="published" value="false"/>

														<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
														<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
													</cfinvoke>

													<cfif fileQuery.recordCount GT 0>
														<cfif isDefined("arguments.fileUrlPath")>

															<cfset downloadFileUrl = "#arguments.fileUrlPath#?file=#fileQuery.id#&#tableTypeName#=#arguments.table_id#">

															<cfif arguments.openRowOnSelect IS true>
																<cfset field_value = '<a href="#downloadFileUrl#" onclick="return downloadFileLinked(this,event)">#fileQuery.file_name#</a>'>
															<cfelse>
																<cfset field_value = '<a href="#downloadFileUrl#">#fileQuery.file_name#</a>'>
															</cfif>

														<cfelse>
															<cfset field_value = fileQuery.file_name>
														</cfif>
													<cfelse>
														<cfset field_value = "<i>ARCHIVO NO DISPONIBLE</i>">
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

														<cfif fields.field_type_id IS NOT 11 AND arguments.includeFullText IS true><!--- IS NOT Very long text --->
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
											<td #tdStyle# data-text="#tableRows['field_#fields.field_id#']#">#field_value#</td>
										<cfelse>
											<td #tdStyle# data-text="0">#field_value#</td>
										</cfif>

									<cfelseif fields.field_type_id IS 4 OR fields.field_type_id IS 5>

										<!--- Para que las sumas de los campos numéricos sean correctas deben introducirse 0 en los valores vacíos --->
										<cfif tableRows['field_#fields.field_id#'] GT 0>
											<td #tdStyle#>#field_value#</td>
										<cfelse>
											<td #tdStyle# data-text="0">#field_value#</td>
										</cfif>

									<cfelse>

										<td #tdStyle#>#field_value#</td>

									</cfif>

								</cfif>

							</cfloop>

							<cfif arguments.includeFromAreaColumn IS true>
								<td><span lang="es"><cfif arguments.area_id EQ tableRows.area_id>Sí<cfelse>No</cfif></span></td>
							</cfif>
						</tr>
					</cfloop>
					</tbody>

					<cfif arguments.tablesorterEnabled IS true AND arguments.mathEnabled IS true>

						<tfoot>
						   <tr>
								<cfif arguments.includeLinkButton IS true>
									<th></th>
								</cfif>
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
								<cfif arguments.includeFromAreaColumn IS true>
									<th></th>
								</cfif>
							</tr>
						</tfoot>

					</cfif>

				</table>

		<cfif arguments.tablesorterEnabled IS true>

			</div><!---END div id="tableDoubleScroll#arguments.tableTypeId#_#arguments.table_id#"--->

			<!---
			<cfif isDefined("onpenUrlHtml2")>

				<!---Esta acción sólo se completa si está en la versión HTML2--->
				<script>
					openUrlHtml2('#onpenUrlHtml2#','itemIframe');
				</script>

			</cfif>
			--->

		</cfif>


		</cfoutput>


	</cffunction>


</cfcomponent>

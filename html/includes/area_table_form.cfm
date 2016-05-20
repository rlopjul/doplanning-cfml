<!---page_types
1 Create new table
2 Modify table
--->

<cfinclude template="#APPLICATION.htmlPath#/includes/area_table_form_query.cfm">

<cfset return_page = "#tableTypeNameP#.cfm?area=#table.area_id#">

<cfset url_return_path = "&return_path="&URLEncodedFormat(return_path&return_page)>

<cfoutput>
<!---
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8"></script>
<script src="#APPLICATION.htmlPath#/language/area_table_content_en.js" charset="utf-8"></script>
 --->
<script src="#APPLICATION.ckeditorJSPath#"></script>
</cfoutput>

<cfif tableTypeId IS NOT 4>

	<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfelse><!--- Users typologies --->
	<cfinclude template="area_id.cfm">

	<cfinclude template="area_checks.cfm">
</cfif>


<cfoutput>
<cfif tableTypeId IS NOT 3 AND len(area_type) GT 0><!--- WEB --->
<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>
</cfif>
</cfoutput>


<script>

	$(function() {

		<cfif tableTypeId IS NOT 3 AND len(area_type) GT 0><!--- WEB --->

			$('#publication_date').datepicker({
			  format: 'dd-mm-yyyy',
			  weekStart: 1,
			  language: 'es',
			  todayBtn: 'linked',
			  autoclose: true
			});

		</cfif>

	});

	function onSubmitForm(){

		if(check_custom_form())	{
			<!---document.getElementById("submitDiv1").innerHTML = 'Enviando...';--->
			document.getElementById("submitDiv2").innerHTML = 'Enviando...';
			return true;
		} else {
			return false;
		}

	}
</script>

<cfset passthrough = "">

<cfoutput>

<!---<div class="div_head_subtitle">
	<span lang="es"><cfif page_type IS 1><cfif tableTypeGender EQ "male">Nuevo<cfelse>Nueva</cfif><cfelse>Modificar</cfif> #tableTypeNameEs#</span>
</div>--->

<!---<div class="div_message_page_title">#table.label#</div>
<div class="div_separator"><!-- --></div>--->

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="contenedor_fondo_blanco">

<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="form-horizontal item_form" name="item_form" onsubmit="return onSubmitForm();">

	<script>
		var railo_custom_form;

		if( typeof LuceeForms !== 'undefined' && $.isFunction(LuceeForms) )
			railo_custom_form = new LuceeForms('item_form');
		else
			railo_custom_form = new RailoForms('item_form');
	</script>
	<script src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>

	<!---<div id="submitDiv1" style="margin-bottom:10px;">
		<input type="submit" value="Guardar" class="btn btn-primary"/>

		<cfif page_type IS 2>
			<a href="#tableTypeName#.cfm?#tableTypeName#=#table_id#" class="btn btn-default" style="float:right">Cancelar</a>
		</cfif>
	</div>--->
	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#"/>
	<input type="hidden" name="tableTypeId" value="#tableTypeId#"/>

	<input type="hidden" name="area_id" value="#table.area_id#"/>
	<cfif page_type IS 2>
		<input type="hidden" name="table_id" value="#table_id#"/>
	</cfif>

	<div class="row">
		<div class="col-xs-12 col-sm-12">
			<label for="label" class="control-label"><span lang="es">Nombre</span> <span lang="es">#tableTypeNameEs#</span>: *</label>
			<cfinput type="text" name="title" id="label" value="#table.title#" maxlength="200" required="true" message="Nombre requerido" class="form-control"/>
		</div>
	</div>

	<div class="row">
		<div class="col-xs-12 col-sm-12">
			<label for="description" class="control-label" lang="es"><span lang="es">Descripción</span> <span lang="es">#tableTypeNameEs#</span>:</label>
			<textarea name="description" id="description" class="form-control" maxlength="1000">#table.description#</textarea>
		</div>
	</div>

	<fieldset>

		<legend lang="es">Opciones de acceso</legend>

		<div class="row">
			<div class="col-xs-12 col-sm-12">
				<div class="checkbox">
					<label>
						<input type="checkbox" name="structure_available" id="structure_available" value="true" <cfif isDefined("table.structure_available") AND table.structure_available IS true>checked="checked"</cfif> /> <span lang="es">Permitir copiar la estructura de campos de <cfif tableTypeGender EQ "male">este<cfelse>esta</cfif> #lCase(tableTypeNameEs)#</span>
					</label>
					<small class="help-block" lang="es">Indica si la definición de campos de <cfif tableTypeGender EQ "male">este<cfelse>esta</cfif> #lCase(tableTypeNameEs)# está disponible para ser usada como plantilla por cualquier usuario de la organización.</small>
				</div>
			</div>
		</div>

		<cfif SESSION.client_administrator EQ SESSION.user_id AND tableTypeId NEQ 4>

			<cfset changeGeneralEnabled = true>

			<cfif page_type IS 2>

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="hasTableRowsOfOtherAreas" returnvariable="hasTableRowsOfOtherAreas">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				</cfinvoke>

				<cfif hasTableRowsOfOtherAreas IS true>
					<cfset changeGeneralEnabled = false>
				</cfif>

			</cfif>

			<div class="row">
				<div class="col-xs-12 col-sm-12">
					<div class="checkbox">
						<label>
							<input type="checkbox" name="general" id="general" value="true" <cfif isDefined("table.general") AND table.general IS true OR changeGeneralEnabled IS false>checked="checked"</cfif> <cfif changeGeneralEnabled IS false>disabled="disable"</cfif> /> <span lang="es">Habilitar como #lCase(tableTypeNameEs)# global</span>
						</label>

						<cfif changeGeneralEnabled IS true>
							<small class="help-block" lang="es">Se podrá utilizar <cfif tableTypeGender EQ "male">este<cfelse>esta</cfif> #lCase(tableTypeNameEs)# en cualquier área de la organización.</small>
						<cfelse>
							<small class="help-block"><b lang="es">No se puede convertir <cfif tableTypeGender EQ "male">este<cfelse>esta</cfif> #lCase(tableTypeNameEs)# en normal porque tiene registros introducidos en otras áreas, antes debe borrarlos.</b></small>
						</cfif>

						<cfif APPLICATION.moduleListsWithPermissions IS true AND tableTypeId EQ 1>
							<small class="help-block" lang="es">IMPORTANTE: los registros de <cfif tableTypeGender EQ "male">los<cfelse>las</cfif> #lCase(tableTypeNameEs)# globales pueden ser editados por cualquier usuario con acceso al área donde han sido introducidos, no requieren permiso de edición.</small>
						</cfif>
					</div>
				</div>
			</div>

		</cfif>

	</fieldset>

	<cfif tableTypeId IS 1 OR tableTypeId IS 2>

	<fieldset>

		<legend lang="es">Listado de registros</legend>

		<div class="row">
			<div class="col-xs-12 col-sm-12">
				<div class="checkbox">
					<label>
						<input type="checkbox" name="list_rows_by_default" id="list_rows_by_default" value="true" <cfif isDefined("table.list_rows_by_default") AND table.list_rows_by_default IS true>checked="checked"</cfif> /> <span lang="es">Listar todos los registros por defecto</span>
					</label>
					<small class="help-block" lang="es">Desmarcar esta opción si hay o habrá muchos registros. Si no se marca esta opción, se mostrará una búsqueda de registros, en lugar del listado de todos los registros.</small>
				</div>
			</div>
		</div>

		<div class="row">
			<div class="col-xs-12 col-sm-12">
				<div class="checkbox">
					<label>
						<input type="checkbox" name="math_enabled" id="math_enabled" value="true" <cfif isDefined("table.math_enabled") AND table.math_enabled IS true>checked="checked"</cfif> /> <span lang="es">Habilitar suma total en valores numéricos</span>
					</label>
					<small class="help-block" lang="es">Desmarcar esta opción si hay o habrá muchos registros, ya que aumenta el tiempo de carga de la lista.</small>
				</div>
			</div>
		</div>

	</fieldset>

	<fieldset>

		<div class="row">
			<div class="col-sm-12 col-sm-8">
				<label for="form_display_type" class="control-label"><span lang="es">Modo del formulario de edición de registros</span>:</label>
				<select name="form_display_type" id="form_display_type" class="form-control">
						<option value="" lang="es">Por defecto</option>
						<option value="horizontal" <cfif table.form_display_type IS "horizontal">selected</cfif> lang="es">Horizontal: título y campo en una misma fila</option>
				</select>
				<small class="help-block" lang="es">Define la posición de los campos en el formulario de edición de registros</small>
			</div>
		</div>

	</fieldset>

	</cfif>


	<!--- <cfdump var="#table#"> --->

	<cfif APPLICATION.publicationScope IS true AND ( tableTypeId IS 1 OR tableTypeId IS 2 )>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Scope" method="getScopes" returnvariable="getScopesResult">
		</cfinvoke>
		<cfset scopesQuery = getScopesResult.scopes>

		<cfif scopesQuery.recordCount GT 0>

			<fieldset>

				<legend lang="es">Ámbito de publicación</legend>

				<div class="row">
					<div class="col-sm-12 col-sm-8">
						<label for="publication_scope_id" class="sr-only"><span lang="es">Ámbito de publicación</span>:</label>
						<select name="publication_scope_id" id="publication_scope_id" class="form-control">
							<cfloop query="scopesQuery">
								<option value="#scopesQuery.scope_id#" <cfif table.publication_scope_id IS scopesQuery.scope_id OR ( NOT isNumeric(table.publication_scope_id) AND findNoCase(area_type, scopesQuery.name) GT 0)>selected="selected"</cfif>>#scopesQuery.name#</option>
							</cfloop>
						</select>
						<small class="help-block" lang="es">Define dónde se podrán publicar vistas <cfif tableTypeGender EQ "male">del<cfelse>de la</cfif> #tableTypeNameEs#</small>
					</div>
				</div>

			</fieldset>
		</cfif>

	</cfif>


	<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_categories_inputs.cfm">


	<cfif tableTypeId IS NOT 3 AND len(area_type) GT 0><!--- WEB --->

		<fieldset>

			<legend><span lang="es">Publicación en <cfif len(area_type)>#area_type#<cfelse>web</cfif></legend>

			<div class="row">

				<cfif isDefined("table.publication_hour")><!--- After send FORM --->

					<cfset publication_hour = table.publication_hour>
					<cfset publication_minute = table.publication_minute>

				<cfelse>

					<cfset publication_hour = timeFormat(table.publication_date, "HH")>
					<cfset publication_minute = timeFormat(table.publication_date, "mm")>

					<cfif len(table.publication_date) GT 10>
						<cfset table.publication_date = left(table.publication_date, findOneOf(" ", table.publication_date))>
					</cfif>

				</cfif>

				<div class="col-xs-3 col-md-2">
					<label class="control-label" for="publication_date"><span lang="es">Fecha de publicación</span> <span lang="es">#tableTypeNameEs#</span>:</label>
				</div>

				<div class="col-xs-9 col-md-10">
					<cfinput type="text" name="publication_date" id="publication_date" class="form-control" value="#table.publication_date#" required="false" message="Fecha de publicación válida requerida" validate="eurodate" mask="DD-MM-YYYY" passthrough="#passthrough#">
				</div>

				<input type="hidden" name="publication_hour" value="00"/>
				<input type="hidden" name="publication_minute" value="00"/>

			</div>

			<div class="row">
				<div class="col-sm-12">
					<small class="help-block" lang="es">Si está definida, <cfif tableTypeGender EQ "male">el<cfelse>la</cfif> #tableTypeNameEs# se publicará en la fecha especificada.</small>
				</div>
			</div>

			<cfif APPLICATION.publicationValidation IS true AND is_user_area_responsible IS true>

				<div class="row">
					<div class="col-xs-12 col-sm-12">
						<div class="checkbox">
							<label>
								<input type="checkbox" name="publication_validated" id="publication_validated" value="true" <cfif isDefined("table.publication_validated") AND table.publication_validated IS true>checked="checked"</cfif> /> <span lang="es">Aprobar publicación</span>
							</label>
							<small class="help-block" lang="es">Valida <cfif tableTypeGender EQ "male">el<cfelse>la</cfif> #tableTypeNameEs# para que pueda ser <cfif tableTypeGender EQ "male">publicado<cfelse>publicada</cfif>.</small>
						</div>
					</div>
				</div>

			</cfif>

		</fieldset>

	</cfif>

	<!--- getClient --->
	<cfinvoke component="#APPLICATION.htmlPath#/components/Client" method="getClient" returnvariable="clientQuery">
		<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
	</cfinvoke>

	<cfif clientQuery.force_notifications IS false>

		<fieldset>

			<div class="row">
				<div class="col-md-12">
					<div class="checkbox">
						<label>
							<input type="checkbox" name="no_notify" id="no_notify" value="true" <cfif isDefined("table.no_notify") AND table.no_notify IS true>checked="checked"</cfif> /> <span lang="es">NO enviar notificación por email</span>
						</label>
						<small class="help-block" lang="es">Si selecciona esta opción no se enviará notificación instantánea por email de esta acción a los usuarios.</small>
					</div>
				</div>
			</div>

		</fieldset>

	</cfif>


	<div id="submitDiv2" style="margin-top:20px;">
		<input type="submit" value="Guardar" class="btn btn-primary" lang="es"/>
		<cfif page_type IS 2 AND isDefined("URL.area") AND isNumeric(URL.area)>
			<cfif tableTypeId IS 4>
				<a href="#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#" class="btn btn-default" style="float:right" lang="es">Cancelar</a>
			<cfelse>
				<a href="#tableTypeName#.cfm?#tableTypeName#=#table_id#&area=#URL.area#" class="btn btn-default" style="float:right" lang="es">Cancelar</a>
			</cfif>
		</cfif>
	</div>

</cfform>
</cfoutput>
</div>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/CKEditorManager" method="loadComponent">
	<cfinvokeargument name="name" value="description">
	<cfinvokeargument name="language" value="#SESSION.user_language#"/>
	<cfinvokeargument name="toolbarStartupExpanded" value="false"/>
	<cfinvokeargument name="toolbarCanCollapse" value="true"/>
</cfinvoke>

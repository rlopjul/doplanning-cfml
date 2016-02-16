<!---get area_type--->
<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaType" returnvariable="areaTypeResult">
	<cfif isDefined("parent_area_id")>
		<cfinvokeargument name="area_id" value="#parent_area_id#">
	<cfelse>
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfif>
</cfinvoke>

<cfif areaTypeResult.result EQ true>

	<cfset area_type = areaTypeResult.areaType>

<cfelse>
	<div class="alert alert-danger">
		<i class="icon-warning-sign"></i> <span>Error al obtener el tipo de área</span>
	</div>
</cfif>

<cfif len(area_type) GT 0>
	<cfset areaTypeWeb = true>
<cfelse>
	<cfset areaTypeWeb = false>
</cfif>

<cfif areaTypeWeb IS true>
<script>

	$(function () {

		$('#url_id').focus( function() {

			if(	$('#url_id').val().length == 0 ) {

				var pageUrl = $('#name').val()
		    pageUrl = pageUrl.toLowerCase();
				pageUrl = removeDiacritics(pageUrl);
		    pageUrl = pageUrl.replace(/(^\s+|[^a-zA-Z0-9 ]+|\s+$)/g,"");
		    pageUrl = pageUrl.replace(/\s+/g, "-");

		    $('#url_id').val(pageUrl);
			}

		});

		$('#url_id').mask("A", {
			translation: {
				"A": { pattern: /[\w@\-.+]/, recursive: true }
			}
		});

	});

</script>
</cfif>

<cfoutput>
<form id="areaForm" method="post" enctype="multipart/form-data" class="form-horizontal"><!---class="form-inline"--->
	<cfif isDefined("area_id")>
		<input type="hidden" name="area_id" id="area_id" value="#area_id#" />
	<cfelseif isDefined("parent_area_id")>
		<input type="hidden" name="parent_id" id="parent_id" value="#parent_area_id#" />
	</cfif>
	<div class="row">
		<div class="col-sm-12">
			<label class="control-label" for="name" lang="es">Nombre</label>
			<input type="text" name="name" id="name" value="#HTMLEditFormat(objectArea.name)#" required="true" title="Nombre de área requerida" class="form-control" />
		</div>
	</div>

	<cfif areaTypeWeb IS true>

		<div class="row">
			<div class="col-sm-12">
				<label class="control-label" for="url_id" lang="es">Nombre de la página (URL)</label>
				<input type="text" name="url_id" id="url_id" value="#HTMLEditFormat(objectArea.url_id)#" required="true" maxlength="75" title="Nombre de la página (URL) requerido" class="form-control" />
				<small class="help-block" style="margin-bottom:0" lang="es">Valor que aparecerá en la URL de la página, ejemplo: nombre-de-la-pagina</small>
			</div>
		</div>

	</cfif>

	<cfif isDefined("objectParentArea")>
	<div class="row">
		<div class="col-sm-12">
			<label class="control-label" for="name" lang="es">Área padre</label>
			<input type="text" name="parent_name" id="parent_name" value="#objectParentArea.name#" class="form-control" readonly="true" />
		</div>
	</div>
	</cfif>

	<div class="row">
		<div class="col-sm-12">
			<label class="control-label" for="user_full_name" lang="es">Responsable</label>
			<input type="hidden" name="user_in_charge" id="user_in_charge" value="#objectArea.user_in_charge#" required="true"/>
			<input type="text" name="user_in_charge_full_name" id="user_in_charge_full_name" value="#objectArea.user_full_name#" required="true" readonly="true" class="form-control" /> <button type="button" class="btn btn-default" onclick="showSelectUserModal()"><span lang="es">Seleccionar usuario</span></button>
		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">
			<label class="control-label" for="description" lang="es">Descripción</label>
			<textarea type="text" name="description" id="description" class="form-control" rows="2">#objectArea.description#</textarea>
		</div>
	</div>

	<cfinclude template="area_menu_inputs.cfm" />

	<div class="row">
		<div class="col-sm-12">

			<h5 lang="es" style="margin-top:30px">Opciones de personalización del área</h5>

		</div>
	</div>

	<div class="row">
		<div class="col-xs-12">

			<label for="list_mode" class="control-label"><span lang="es">Modo de listado de elementos del área</span>:</label>
			<select name="list_mode" id="list_mode" class="form-control">
					<option value="" lang="es">Completo (Por defecto)</option>
					<option value="list" lang="es" <cfif objectArea.list_mode IS "list">selected</cfif>>Lista</option>
			</select>

		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">
			<label class="control-label" lang="es">En esta área se pueden crear los siguientes elementos:</label>
		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">
			<div class="checkbox">
				<label class="control-label">
					<input type="checkbox" name="select_all" checked="checked" onclick="toggleCheckboxesChecked(this.checked);"/> <span lang="es">Seleccionar/quitar todos</span>
				</label>
			</div>
		</div>
	</div>

	<div class="row">

		<div class="col-xs-12">
			<ul class="list-inline">

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
				</cfinvoke>

				<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

				<cfloop array="#itemTypesArray#" index="itemTypeId">
					<cfif itemTypeId NEQ 14 AND itemTypeId NEQ 15>
						<cfif ( areaTypeWeb AND itemTypesStruct[itemTypeId].web ) OR ( areaTypeWeb IS false AND itemTypesStruct[itemTypeId].noWeb )>
							<li>
								<div class="checkbox">
									<label class="control-label" for="item_type_#itemTypeId#_enabled" lang="es">
										<input id="item_type_#itemTypeId#_enabled" name="item_type_#itemTypeId#_enabled" type="checkbox" value="true" <cfif ( NOT isDefined('objectArea["item_type_#itemTypeId#_enabled"]') AND itemTypeId NEQ 17 ) OR ( isDefined('objectArea["item_type_#itemTypeId#_enabled"]') AND objectArea["item_type_#itemTypeId#_enabled"] IS true )>checked="checked"</cfif> />

											<img src="#APPLICATION.htmlPath#/assets/v3/icons/#itemTypesStruct[itemTypeId].name#.png" alt="#itemTypesStruct[itemTypeId].label#" lang="es" style="width:30px"/>

										<span lang="es">#itemTypesStruct[itemTypeId].labelPlural#<cfif itemTypeId IS 10> y archivos de área</cfif></span>&nbsp;
									</label>
								</div>
							</li>
						<cfelse>
							<input id="item_type_#itemTypeId#_enabled" name="item_type_#itemTypeId#_enabled" type="hidden" value="true" />
						</cfif>
					</cfif>
				</cfloop>

			</ul>

			<small class="help-block" style="margin-bottom:0" lang="es">Esta selección no afecta a los elementos ya existentes en el área</small>
		</div>
	</div>

	<div class="row">
		<div class="col-xs-12">

			<div class="checkbox">
				<label class="control-label" for="users_visible">
					<input id="users_visible" name="users_visible" type="checkbox" value="true" class="checkbox_locked" <cfif NOT isDefined("objectArea.users_visible") OR objectArea.users_visible IS true>checked="checked"</cfif> />
						<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/users.png" alt="Usuarios" lang="es" style="width:30px"/>
					<span lang="es">Mostrar visible el listado de usuarios del área</span>&nbsp;
				</label>
				<small class="help-block" lang="es">Esta opción no afecta a los elementos en los que es necesario acceder a la lista de usuarios del área para su creación y edición como: tareas<cfif APPLICATION.moduleListsWithPermissions IS true>, archivos de área, listas y formularios.
					<cfelse> y archivos de área.</cfif></small>
			</div>

		</div>
	</div>

	<div class="row">
		<div class="col-xs-12">

			<div class="checkbox">
				<label class="control-label" for="read_only">
					<input id="read_only" name="read_only" type="checkbox" value="true" class="checkbox_locked" <cfif isDefined("objectArea.read_only") AND objectArea.read_only IS true>checked="checked"</cfif> />
					&nbsp;&nbsp;<i class="icon-lock" style="font-size:18px"></i>&nbsp;&nbsp;<span lang="es">Área de sólo lectura</span>&nbsp;
				</label>
			</div>

		</div>
	</div>

	<cfif isDefined("area_id")><!--- Modify area --->
	<div class="row">
		<div class="col-xs-12">

			<div class="checkbox">
				<label class="control-label" for="items_enabled_subareas">
					<input id="items_enabled_subareas" name="items_enabled_subareas" type="checkbox" value="true" class="checkbox_locked" />
					<span lang="es">Aplicar selección anterior de opciones a todas las áreas inferiores</span>
				</label>
				<small class="help-block" lang="es">Esta definición se puede modificar posteriormente de forma individual para cada área.</small>
			</div>

		</div>
	</div>
	</cfif>


</form>
</cfoutput>

<!--- Select User Modal --->
<cfinclude template="user_select_modal.cfm" />

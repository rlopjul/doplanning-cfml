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
			<input type="text" name="name" id="name" value="#HTMLEditFormat(objectArea.name)#" required="true" message="Nombre de área requerida" class="form-control" />
		</div>
	</div>
	
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

		<!---<cfif len(area_type) IS 0>
			<div class="col-xs-4">
				<div class="checkbox" style="margin-top:5px;">
					<label class="control-label" for="item_type_1_enabled" lang="es">
						<input id="item_type_1_enabled" name="item_type_1_enabled" type="checkbox" value="true" <cfif objectArea.item_type_1_enabled IS true>checked="checked"</cfif> />
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/message.png" alt="Mensaje" lang="es"/> Mensajes
					</label>
				</div>
			</div>
		</cfif>		

		<div class="col-xs-4">
			<div class="checkbox" style="margin-top:5px;">
				<label class="control-label" for="item_type_10_enabled" lang="es">
					<input id="item_type_10_enabled" name="item_type_10_enabled" type="checkbox" value="true" <cfif objectArea.item_type_10_enabled IS true>checked="checked"</cfif> />
					<img src="#APPLICATION.htmlPath#/assets/v3/icons/file.png" alt="Archivo" lang="es" /> Archivos
				</label>
			</div>
		</div>	

		<div class="col-xs-4">
			<div class="checkbox" style="margin-top:5px;">
				<label class="control-label" for="item_type_20_enabled" lang="es">
					<input id="item_type_20_enabled" name="item_type_20_enabled" type="checkbox" value="true" <cfif objectArea.item_type_20_enabled IS true>checked="checked"</cfif> />
					<img src="#APPLICATION.htmlPath#/assets/v3/icons/entry.png" alt="Entrada" lang="es" /> Documentos DoPlanning
				</label>
			</div>
		</div>--->

		<div class="col-xs-12">
			<ul class="list-inline">

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
					<!---<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">--->
				</cfinvoke>

				<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

				<cfif len(area_type) GT 0>
					<cfset areaTypeWeb = true>
				<cfelse>
					<cfset areaTypeWeb = false>
				</cfif>

				<cfloop array="#itemTypesArray#" index="itemTypeId">
					<cfif itemTypeId NEQ 14 AND itemTypeId NEQ 15>
						<cfif ( areaTypeWeb AND itemTypesStruct[itemTypeId].web ) OR ( areaTypeWeb IS false AND itemTypesStruct[itemTypeId].noWeb )>
							<li>
								<div class="checkbox">
									<label class="control-label" for="item_type_#itemTypeId#_enabled" lang="es">
										<input id="item_type_#itemTypeId#_enabled" name="item_type_#itemTypeId#_enabled" type="checkbox" value="true" <cfif NOT isDefined('objectArea["item_type_#itemTypeId#_enabled"]') OR objectArea["item_type_#itemTypeId#_enabled"] IS true>checked="checked"</cfif> />
										<!---
										<cfif itemTypeId IS 7><!---Consultations--->
											<i class="icon-exchange" style="font-size:19px;line-height:22px;color:##0088CC"></i>
										<cfelseif itemTypeId IS 13><!---Typologies--->
											<i class="icon-file-text" style="font-size:19px; line-height:23px; color:##7A7A7A"></i>
										<cfelse>--->
											<img src="#APPLICATION.htmlPath#/assets/v3/icons/#itemTypesStruct[itemTypeId].name#.png" alt="#itemTypesStruct[itemTypeId].label#" lang="es" style="width:30px"/>
										<!---</cfif>--->
										<span lang="es">#itemTypesStruct[itemTypeId].labelPlural#<cfif itemTypeId IS 10> y archivos de área</cfif></span>&nbsp;
									</label>
								</div>
							</li>
						<cfelse>
							<input id="item_type_#itemTypeId#_enabled" name="item_type_#itemTypeId#_enabled" type="hidden" value="true" />				
						</cfif>
					</cfif>
				</cfloop>

				<!---<li>
					<label class="control-label" for="item_type_1_enabled" lang="es">
						<input id="item_type_1_enabled" name="item_type_1_enabled" type="checkbox" value="true" <cfif objectArea.item_type_1_enabled IS true>checked="checked"</cfif> />
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/message.png" alt="Mensaje" lang="es"/> <span lang="es">Mensajes</span>&nbsp;
					</label>
				</li>
				<li>
					<label class="control-label" for="item_type_10_enabled" lang="es">
						<input id="item_type_10_enabled" name="item_type_10_enabled" type="checkbox" value="true" <cfif objectArea.item_type_10_enabled IS true>checked="checked"</cfif> />
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/file.png" alt="Archivo" lang="es" /> <span lang="es">Archivos</span>&nbsp;
					</label>
				</li>
				<li>
					<label class="control-label" for="item_type_20_enabled" lang="es">
						<input id="item_type_20_enabled" name="item_type_20_enabled" type="checkbox" value="true" <cfif objectArea.item_type_20_enabled IS true>checked="checked"</cfif> />
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/entry.png" alt="Entrada" lang="es" /> <span lang="es">Documentos DoPlanning</span>&nbsp;
					</label>
				</li>
				<li>
					<label class="control-label" for="item_type_1_enabled" lang="es">
						<input id="item_type_5_enabled" name="item_type_5_enabled" type="checkbox" value="true" <cfif objectArea.item_type_1_enabled IS true>checked="checked"</cfif> />
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/event.png" alt="Mensaje" lang="es"/> Eventos
					</label>
				</li>
				<li>
					<label class="control-label" for="item_type_10_enabled" lang="es">
						<input id="item_type_6_enabled" name="item_type_6_enabled" type="checkbox" value="true" <cfif objectArea.item_type_10_enabled IS true>checked="checked"</cfif> />
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/file.png" alt="Archivo" lang="es" /> Tareas
					</label>
				</li>
				<li>
					<label class="control-label" for="item_type_2_enabled" lang="es">
						<input id="item_type_11_enabled" name="item_type_11_enabled" type="checkbox" value="true" <cfif objectArea.item_type_2_enabled IS true>checked="checked"</cfif> />
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/list.png" alt="Entrada" lang="es" /> Listas 
					</label>
				</li>--->

			</ul>

			<small class="help-block" style="margin-bottom:0" lang="es">Esta selección no afecta a los elementos ya existentes en el área</small>
		</div>
	</div>	

	<div class="row">
		<div class="col-xs-12">

			<div class="checkbox">
				<label class="control-label" for="users_visible">
					<input id="users_visible" name="users_visible" type="checkbox" value="true" class="checkbox_locked" <cfif NOT isDefined("objectArea.users_visible") OR objectArea.users_visible IS true>checked="checked"</cfif> />
						<img src="#APPLICATION.htmlPath#/assets/icons_dp/users.png" alt="Usuarios" lang="es" style="width:30px"/>
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
					<span lang="es">Aplicar selección anterior de elementos, usuarios disponibles y sólo lectura a todas las áreas inferiores</span>
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
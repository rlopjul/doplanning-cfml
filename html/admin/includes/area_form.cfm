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
			<input type="text" name="user_in_charge_full_name" id="user_in_charge_full_name" value="#objectArea.user_full_name#" required="true" readonly="true" class="form-control" /> <button type="button" class="btn btn-default" onclick="showSelectUserModal()">Seleccionar usuario</button>
		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">
			<label class="control-label" for="description" lang="es">Descripción</label>
			<textarea type="text" name="description" id="description" class="form-control" rows="2">#objectArea.description#</textarea>
		</div>
	</div>	

	<cfinclude template="area_menu_inputs.cfm" />
	
			
</form>
</cfoutput>

<!--- Select User Modal --->
<cfinclude template="user_select_modal.cfm" />
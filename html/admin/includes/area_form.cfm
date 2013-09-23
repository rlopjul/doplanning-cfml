<cfoutput>
<form id="areaForm" method="post" enctype="multipart/form-data" class="form-inline">
	<cfif isDefined("area_id")>
		<input type="hidden" name="area_id" id="area_id" value="#area_id#" />
	</cfif>
	<cfif isDefined("parent_area_id")>
		<input type="hidden" name="parent_id" id="parent_id" value="#parent_area_id#" />		
	</cfif>
	<div class="control-group">
		<label class="control-label" for="name" lang="es">Nombre:</label>
		<div class="control-group">
			<input type="text" name="name" id="name" value="#objectArea.name#" required="true" message="Nombre de área requerida" class="input-block-level" />
		</div>
	</div>

	<cfif isDefined("objectParentArea")>
	<div class="control-group">
		<label class="control-label" for="name" lang="es">Área padre:</label>
		<div class="control-group">
			<input type="text" name="parent_name" id="parent_name" value="#objectParentArea.name#" class="input-block-level" readonly="true" />
		</div>
	</div>
	</cfif>

	<div class="control-group">
		<label class="control-label" for="user_full_name" lang="es">Responsable:</label>
		<div class="controls">
			<input type="hidden" name="user_in_charge" id="user_in_charge" value="#objectArea.user_in_charge#" validate="integer" required="true"/>
			<input type="text" name="user_in_charge_full_name" id="user_in_charge_full_name" value="#objectArea.user_full_name#" required="true" readonly="true" class="input-large" /> <button type="button" class="btn" onclick="showSelectUserModal()">Seleccionar usuario</button>
		</div>
	</div>

	<div class="control-group">
		<label class="control-label" for="description" lang="es">Descripción:</label>
		<div class="controls">
			<textarea type="text" name="description" id="description" class="input-block-level" rows="2"/>#objectArea.description#</textarea>
		</div>
	</div>			
</form>
</cfoutput>


<!--- Select user modal --->
<div id="selectUserModal" class="modal hide fade" tabindex="-1">

	<div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	    <h3 id="areaModalLabel">Seleccionar usuario</h3>
	</div>

 	<div class="modal-body">
 		<cfif NOT isDefined("area_id")>
 			<cfset area_id = parent_area_id>
 		</cfif>
 		<cfinclude template="#APPLICATION.htmlPath#/includes/area_users_select.cfm">
 	</div>

	<!---<div class="modal-footer">
	    <button class="btn" data-dismiss="modal" aria-hidden="true">Cancelar</button>
	    <button class="btn btn-primary" id="selectUser">Guardar cambios</button>
	</div>--->

</div>	

<cfoutput>
<script type="text/javascript">
	
	function showSelectUserModal(){

		<!---
		Esto quitado porque tarda en cargarse el tablesorter al mostrarse
		$('##selectUserModal').modal({
				  keyboard: true,
				  <cfif isDefined("area_id")>
				  	remote: "html_content/area_users_select.cfm?area="+#objectArea.id#,
				  <cfelse>
				  	remote: "html_content/area_users_select.cfm?area="+#parent_area_id#,
				  </cfif>
				});--->
		$('##selectUserModal').modal();
	}

	function setResponsibleUser(userId, userFullName) {
				
		document.getElementById("user_in_charge").value = userId;
		document.getElementById("user_in_charge_full_name").value = userFullName;

		hideModal('##selectUserModal');
	}

</script>
</cfoutput>
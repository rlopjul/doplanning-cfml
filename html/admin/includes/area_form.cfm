<cfoutput>
<form id="areaForm" method="post" enctype="multipart/form-data" class="form-inline">
	<cfif isDefined("area_id")>
		<input type="hidden" name="area_id" id="area_id" value="#area_id#" />
	</cfif>
	<cfif isDefined("parent_area_id")>
		<input type="hidden" name="parent_id" id="parent_id" value="#parent_area_id#" />		
	</cfif>
	<div class="form-group">
		<label class="control-label" for="name" lang="es">Nombre</label>
		<div class="form-group">
			<input type="text" name="name" id="name" value="#objectArea.name#" required="true" message="Nombre de área requerida" class="input-block-level" />
		</div>
	</div>

	<cfif isDefined("objectParentArea")>
	<div class="form-group">
		<label class="control-label" for="name" lang="es">Área padre</label>
		<div class="form-group">
			<input type="text" name="parent_name" id="parent_name" value="#objectParentArea.name#" class="input-block-level" readonly="true" />
		</div>
	</div>
	</cfif>

	<div class="form-group">
		<label class="control-label" for="user_full_name" lang="es">Responsable</label>
		<div class="controls">
			<input type="hidden" name="user_in_charge" id="user_in_charge" value="#objectArea.user_in_charge#" validate="integer" required="true"/>
			<input type="text" name="user_in_charge_full_name" id="user_in_charge_full_name" value="#objectArea.user_full_name#" required="true" readonly="true" class="input-lg" /> <button type="button" class="btn btn-default" onclick="showSelectUserModal()">Seleccionar usuario</button>
		</div>
	</div>

	<div class="form-group">
		<label class="control-label" for="description" lang="es">Descripción</label>
		<div class="controls">
			<textarea type="text" name="description" id="description" class="input-block-level" rows="2">#objectArea.description#</textarea>
		</div>
	</div>	
	
	<cfif isDefined("area_id")>
		<cfset check_area = area_id>
	<cfelseif isDefined("parent_area_id")>
		<cfset check_area = parent_area_id>
	</cfif>
	
	
	<cfif isDefined("check_area")>
	

		<!---get area_type--->
		<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaType" returnvariable="areaTypeResult">				
			<cfinvokeargument name="area_id" value="#check_area#">
		</cfinvoke>
		
		<cfif areaTypeResult.result EQ true>
		
			<cfset area_type = areaTypeResult.areaType>
			
			<cfif area_type EQ "web" OR area_type EQ "intranet">
				
				<div class="form-group">		
					<div class="controls">					
						<input style="margin-top:-2px;" id="hide_in_menu" name="hide_in_menu" type="checkbox" value="true" <cfif objectArea.hide_in_menu IS true>checked="checked"</cfif>  />
						<label class="control-label" for="hide_in_menu" lang="es" style="margin-top:5px;">Ocultar del menú (no se mostrará esta área ni sus áreas inferiores)</label>		
					</div>
				</div>	
				
				<cfset show_type_menu = false>
				
				<cfif isDefined("area_id")><!---si está definidio area_id--->
				<!---solo se muestra si es un área de 3er nivel--->
				
					<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getArea" returnvariable="objectAreaParent">				
						<cfinvokeargument name="get_area_id" value="#objectArea.parent_id#">
						<cfinvokeargument name="return_type" value="object">
						
					</cfinvoke>	
					
					<cfset area_parent = objectAreaParent>
					
					<cfif area_parent.type EQ "web" OR area_parent.type EQ "intranet"><!---si es de tipo web o intranet--->
					
						<cfset show_type_menu = true>
					
					</cfif><!---end  si es de tipo web o intranet--->
					
				<cfelseif isDefined("parent_area_id")>
				
					<cfif objectParentArea.type EQ "web" OR objectParentArea.type EQ "intranet">
						<cfset show_type_menu = true>
					</cfif>				
				
				</cfif><!---end si está definidio area_id--->
				
					
				<cfif show_type_menu>
					
					<div class="form-group">		
						<div class="controls">
							<label class="control-label" for="type_menu" lang="es">Tipo de menú</label>
							
							<cfinclude template="menu_type_list.cfm" />
						</div>
					</div>					
				
				</cfif>
				
			
			</cfif>	
			
		<cfelse>	
			<span>Error al obtener el tipo de área</span>
		</cfif>
		
	</cfif>

	
			
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
 		<cfset page_type = 1>
 		<cfinclude template="#APPLICATION.htmlPath#/includes/area_users_select.cfm">
 	</div>

	<!---<div class="modal-footer">
	    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancelar</button>
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
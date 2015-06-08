<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	
	<cfset area_id = URL.area>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>

	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaPath" returnvariable="area_path">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>
	
	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 id="areaModalLabel" lang="es">Asociar usuarios a otra área</h4>
		</div>

	 	<div class="modal-body">

	 		<!---
	 		<ul class="nav nav-tabs" role="tablist">
				<li class="active"><a href="##destinationArea" role="tab" data-toggle="tab">Área de destino</a></li>
				<li><a href="##usersToAssociate" role="tab" data-toggle="tab">Usuarios</a></li>
			</ul>
	  		
			<!--- Tab panes --->
			<div class="tab-content">

				<div class="tab-pane active" id="destinationArea">--->

			 		<span lang="es">Selecciona el área de destino:</span>

			 		<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" src="iframes/area_users_associate_select_tree.cfm?area=#area_id#" style="height:365px;background-color:##FFFFFF;"></iframe>

			 		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getAllAreaUsers" returnvariable="areaUsersResponse">	
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfinvoke>

					<cfset areaUsers = areaUsersResponse.users>
					<cfset usersToAssociate = "">

					<cfloop index="objectUser" array="#areaUsers#">

						<cfset usersToAssociate = listAppend(usersToAssociate, objectUser.id)>

					</cfloop>
	

			 	<!---</div>

				
				<div class="tab-pane" id="usersToAssociate">

					<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getAllAreaUsers" returnvariable="areaUsersResponse">	
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfinvoke>

					<cfset areaUsers = areaUsersResponse.users>
					<div class="row">
						<div class="col-sm-12">
							Usuarios:
						</div>
					</div>
						
					<div class="row">
						<div class="col-sm-12">
							<div class="well well-sm" style="margin-bottom:15px;">
					  			<ul class="list-inline" style="margin-bottom:0px;">
								<cfloop index="objectUser" array="#areaUsers#">	

									<cfset usersToAssociate = listAppend(usersToAssociate, objectUser.id)>

									<li>
									<cfif len(objectUser.image_type) GT 0>
										<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" style="max-width:20px;max-height:20px;" />									
									<cfelse>							
										<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectUser.user_full_name#" style="width:20px;" />
									</cfif>
									&nbsp;<small style="font-size:11px;">#objectUser.family_name# #objectUser.name#</small>
									</li>
								</cfloop>
								</ul>
							</div>
						</div>
					</div>

					<a href="##destinationArea" class="btn btn-primary">Seleccionar área de destino</a>

			 	</div>
			 	

			</div>--->

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" lang="es">Cancelar</button>
		    <button class="btn btn-primary" id="areaModifySubmit" onclick="submitAreaUsersAssociateSelect(event)" lang="es">Asociar usuarios al área seleccionada</button>
		</div>

		<script>

			var newAreaId = "undefined";
			var associateUsersIds = "#usersToAssociate#";

			function submitAreaUsersAssociateSelect(e){

				if(e.preventDefault)
					e.preventDefault();

				if( $.isNumeric(newAreaId) ){
					
					if(associateUsersIds.length > 0){
						openAssociateUsersModal(associateUsersIds, newAreaId);
						$('body').modalmanager('removeLoading');
					}
					else
						showAlertModal("No hay usuarios");

				} else {

					showAlertModal("Debe seleccionar un área para asociar los usuarios");
				}

			}

			function setNewAreaId(areaId){
				newAreaId = areaId;
			}
		</script>

	</cfoutput>

</cfif>
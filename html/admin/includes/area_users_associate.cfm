<cfif isDefined("URL.area") AND isNumeric(URL.area) AND isDefined("URL.users")>
	
	<cfset area_id = URL.area>
	<cfset users_ids = URL.users>

	<cfset return_page = "area_users.cfm?area=#area_id#">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>

	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaPath" returnvariable="area_path">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

	
	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h3>Asociar usuarios a área</h3>
		</div>

	 	<div class="modal-body">

	 		<div><p>Compruebe los usuarios seleccionados:</p></div>

	 		<div>

		 		<cfset usersToAssociate = "">

		 		<cfloop list="#users_ids#" index="user_id">
		 			
		 			<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
						<cfinvokeargument name="user_id" value="#user_id#">
					</cfinvoke>

					<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="isUserAssociatedToArea" returnvariable="isUserInAreaResponse">
						<cfinvokeargument name="area_id" value="#area_id#">
						<cfinvokeargument name="check_user_id" value="#user_id#">
					</cfinvoke>	

					<cfif isUserInAreaResponse.isUserInArea IS false>

						<cfset usersToAssociate = listAppend(usersToAssociate, user_id)>

						<!--- <p>¿Seguro que desea asociar este usuario a esta área?</p> --->

						<div class="well well-sm">
							<cfif len(objectUser.image_type) GT 0>
								<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" class="item_img" style="margin-right:2px;"/>									
							<cfelse>							
								<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" class="item_img_default" style="margin-right:2px;"/>
							</cfif> <strong>#objectUser.family_name# #objectUser.name#</strong> (#objectUser.email#)<br/>
						</div>

					<cfelse>

						<p>El usuario <b>#objectUser.family_name# #objectUser.name#</b> ya está asociado a esta área, no es necesario asociarlo.</p>

					</cfif>
						
		 		</cfloop>

		 		<div class="well well-sm">Área:
					<strong>#objectArea.name#</strong><br/>
					<span>Ruta del área: #area_path#
				</div>

	 		</div>

	 		<cfif listLen(usersToAssociate) GT 0>
	 			
	 			<small class="help-block">Se le enviará notificación por email a estos usuarios, si están activos.</small>

				<form id="associateUsersForm" method="post">
					<input type="hidden" name="area_id" value="#objectArea.id#"/>
					<input type="hidden" name="users_ids" value="#usersToAssociate#"/>
				</form>

			<cfelse>

				<p>No hay usuarios seleccionados no pertenecientes al área</p>

	 		</cfif>
			
		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancelar</button>
		    <cfif listLen(usersToAssociate) GT 0>
		   		<button class="btn btn-primary" id="areaModifySubmit" onclick="submitAssociateUsersModal(event)">Asociar usuarios</button>
		   	</cfif>
		</div>

		<script>
			function submitAssociateUsersModal(e){

			    if(e.preventDefault)
					e.preventDefault();

				postModalForm("##associateUsersForm", "#APPLICATION.htmlComponentsPath#/User.cfc?method=assignUsersToArea", "#return_page#", "areaIframe");
			}
		</script>

	</cfoutput>

</cfif>
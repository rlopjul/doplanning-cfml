<cfif isDefined("URL.area") AND isNumeric(URL.area) AND isDefined("URL.user") AND isNumeric(URL.user)>

	<cfset area_id = URL.area>
	<cfset user_id = URL.user>

	<cfset return_page = "area_users.cfm?area=#area_id#">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
		<cfinvokeargument name="user_id" value="#user_id#">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>

	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaPath" returnvariable="area_path">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="isUserAssociatedToArea" returnvariable="isUserInAreaResponse">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="check_user_id" value="#user_id#">
	</cfinvoke>

	<cfif isUserInAreaResponse.isUserInArea IS NOT true>

		<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getNearestAreaUserAssociated" returnvariable="getNearestAreaResponse">
			<cfinvokeargument name="area_id" value="#area_id#"/>
			<cfinvokeargument name="user_id" value="#user_id#"/>
			<cfinvokeargument name="userType" value="users"/>
		</cfinvoke>

	</cfif>

	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 lang="es">Quitar usuario de área</h4>
		</div>

	 	<div class="modal-body">


			<cfif objectArea.user_in_charge IS user_id>

				<p lang="es">Este usuario es el responsable del área, debe asignar a otro usuario como responsable para poder quitar a este del área.</p>

			<cfelse>


				<cfif isUserInAreaResponse.isUserInArea IS true><!--- The user already is in the area  --->

					<p lang="es">¿Seguro que desea quitar este usuario de esta área?:</p>

				<cfelse>

					<cfif getNearestAreaResponse.result IS true>

						<p><span class="label label-warning" lang="es">CUIDADO</span> <span lang="es">Este usuario no está asociado directamente a esta área, esta asociado a un área superior</span>:</p>

					<cfelse>

						<p><span class="label label-warning" lang="es">CUIDADO</span> <span lang="es">Este usuario no está asociado a esta área</span></p>

					</cfif>

				</cfif>

				<div class="well well-sm">
					<cfif len(objectUser.image_type) GT 0>
						<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" class="item_img" style="margin-right:2px;"/>
					<cfelse>
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" class="item_img_default" style="margin-right:2px;"/>
					</cfif> <strong>#objectUser.family_name# #objectUser.name#</strong> (#objectUser.email#)<br/>
				</div>

				<cfif isUserInAreaResponse.isUserInArea IS true><!--- The user already is in the area  --->

					<div class="well well-sm"><span lang="es">Área</span>:
						<strong>#objectArea.name#</strong><br/>
						<span lang="es">Ruta del área</span>: #area_path#
					</div>

					<form id="dissociateForm" method="post">
						<input type="hidden" name="area_id" value="#objectArea.id#"/>
						<input type="hidden" name="user_id" value="#objectUser.id#"/>
					</form>


				<cfelse>

					<cfif getNearestAreaResponse.result IS true>

						<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaPath" returnvariable="nearest_area_path">
							<cfinvokeargument name="area_id" value="#getNearestAreaResponse.area_id#">
						</cfinvoke>

						<div class="well well-sm"><span lang="es">Area superior</span>:
							<strong>#getNearestAreaResponse.area_name#</strong><br/>
							<span lang="es">Ruta del área</span>: #nearest_area_path#
						</div>

						<p lang="es">Si quita el usuario de esta área superior lo estará quitando del resto de áreas inferiores.</p>

						<form id="dissociateForm" method="post">
							<input type="hidden" name="area_id" value="#getNearestAreaResponse.area_id#"/>
							<input type="hidden" name="user_id" value="#objectUser.id#"/>
						</form>

					</cfif>

				</cfif>

				<small class="help-block" lang="es">No se enviará notificación por email de esta acción</small>


			</cfif>


		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" lang="es">Cancelar</button>

		    <cfif objectArea.user_in_charge NEQ user_id>

		    	<cfif isUserInAreaResponse.isUserInArea IS true>
			    	<button class="btn btn-primary" id="areaDissociateSubmitButton" data-loading-text="Quitando..." onclick="submitDissociateModal(event)" lang="es">Quitar usuario del área</button>
			    <cfelseif getNearestAreaResponse.result IS true>
			    	<button class="btn btn-warning" id="areaDissociateSubmitButton" data-loading-text="Quitando..." onclick="submitDissociateModal(event)" lang="es">Quitar usuario del área superior</button>
			    </cfif>

		    </cfif>

		</div>

		<script>
			function submitDissociateModal(e){

			    if(e.preventDefault)
					e.preventDefault();

				$("##areaDissociateSubmitButton").button('loading');

				postModalForm("##dissociateForm", "#APPLICATION.htmlComponentsPath#/User.cfc?method=dissociateUserFromArea", "#return_page#", "areaIframe");

			}
		</script>

	</cfoutput>

</cfif>

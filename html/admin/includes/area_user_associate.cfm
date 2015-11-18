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

	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 lang="es">Asociar usuario a área</h4>
		</div>

	 	<div class="modal-body">

	 		<cfif isUserInAreaResponse.isUserInArea IS false>

				<p lang="es">¿Seguro que desea asociar este usuario a esta área?</p>

			<cfelse>

				<p lang="es">Este usuario ya está asociado a esta área</p>

			</cfif>

			<div>
				<div class="well well-sm">
					<cfif len(objectUser.image_type) GT 0>
						<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" class="item_img" style="margin-right:2px;"/>
					<cfelse>
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" class="item_img_default" style="margin-right:2px;"/>
					</cfif> <strong>#objectUser.family_name# #objectUser.name#</strong> (#objectUser.email#)<br/>
				</div>
				<div class="well well-sm"><span lang="es">Área</span>:
					<strong>#objectArea.name#</strong><br/>
					<span lang="es">Ruta del área</span>: #area_path#
				</div>
			</div>

			<cfif isUserInAreaResponse.isUserInArea IS false>

				<form id="associateForm" method="post">

					<div class="checkbox">
						<label>
							<input type="checkbox" name="send_alert" value="true" checked /> Enviar notificación de asociación al área
							<p class="help-block">Si se selecciona esta opción se enviará notificación por email al usuario asociado y a los usuarios del área.</p>
						</label>
					</div>

					<input type="hidden" name="area_id" value="#objectArea.id#"/>
					<input type="hidden" name="user_id" value="#objectUser.id#"/>
				</form>

			</cfif>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" lang="es">Cancelar</button>
		    <cfif isUserInAreaResponse.isUserInArea IS false>
		   		<button class="btn btn-primary" id="areaAssociateSubmitButton" data-loading-text="Asociando..." onclick="submitAssociateModal(event)" lang="es">Asociar usuario</button>
		   	</cfif>
		</div>

		<script>
			function submitAssociateModal(e){

			    if(e.preventDefault)
					e.preventDefault();

				$("##areaAssociateSubmitButton").button('loading');

				var formId = "##associateAreasForm";
				var requestUrl = "#APPLICATION.htmlComponentsPath#/User.cfc?method=assignUserToAreas";

				postModalForm("##associateForm", "#APPLICATION.htmlComponentsPath#/User.cfc?method=assignUserToArea", "#return_page#", "areaIframe");

			}
		</script>

	</cfoutput>

</cfif>

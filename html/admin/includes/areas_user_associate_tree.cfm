<cfif isDefined("URL.user") AND isNumeric(URL.user)>

	<cfset user_id = URL.user>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
		<cfinvokeargument name="user_id" value="#user_id#">
	</cfinvoke>

	<!---<cfif isDefined("URL.area") AND isNumeric(URL.area)>

		<cfset return_page = "area_users.cfm?area=#area_id#">

		<cfset area_id = URL.area>

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

	</cfif>--->


	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 lang="es">Asociar usuario a áreas</h4>
		</div>

	 	<div class="modal-body">

	 		<div class="well well-sm" style="margin-bottom:5px;">
				<cfif len(objectUser.image_type) GT 0>
					<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" class="item_img" style="margin-right:2px;"/>
				<cfelse>
					<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" class="item_img_default" style="margin-right:2px;"/>
				</cfif> <strong>#objectUser.family_name# #objectUser.name#</strong> (#objectUser.email#)<br/>
			</div>

	 		<p lang="es">Selecciona las áreas a las que quieres añadir el usuario. Ten en cuenta que un usuario asociado a un área tendrá acceso a todas las áreas que haya dentro de ésta, sin necesidad de asociarlo también a esas áreas. Si no asocias el usuario a ningún área no podrá utilizar DoPlanning.</p>

			<cfinclude template="#APPLICATION.htmlPath#/admin/includes/areas_user_associate_tree_inline.cfm">

		</div>

		<div class="modal-footer">

		    <button class="btn btn-default" data-dismiss="modal" lang="es">Cancelar</button>

		   	<button class="btn btn-primary" id="areaAssociateSelectButton" data-loading-text="Enviando..." onclick="submitAssociateAreasSelectModal(event)" lang="es">Asociar usuario a áreas seleccionadas</button>

		</div>

		<script>

			function submitAssociateAreasSelectModal(e){

			    if(e.preventDefault)
					e.preventDefault();

				var userId = #user_id#;
				var areasIdsArray = [];

				$('input:checkbox[name="areas_ids[]"]:checked').each(function() {

					areasIdsArray.push($(this).val());

			    });


				if(areasIdsArray.length > 0){

					var areasIds = areasIdsArray.join();

					$("##areaAssociateSelectButton").button('loading');

					<cfif isDefined("URL.area") AND isNumeric(URL.area)>
						loadModal('html_content/areas_user_associate.cfm?areas='+areasIds+'&user='+userId+'&area='+#URL.area#);
					<cfelse>
						loadModal('html_content/areas_user_associate.cfm?areas='+areasIds+'&user='+userId);
					</cfif>


					$('body').modalmanager('removeLoading');

				} else {

					showAlertModal(window.lang.translate("Debe seleccionar al menos un área para asociar el usuario"));

				}

			}

		</script>

	</cfoutput>

</cfif>

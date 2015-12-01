<cfif isDefined("URL.user") AND isNumeric(URL.user)>

	<cfset user_id = URL.user>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
		<cfinvokeargument name="user_id" value="#user_id#"/>
	</cfinvoke>

	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 lang="es">Eliminar usuario</h4>
		</div>

	 	<div class="modal-body">

			<span lang="es">¿Seguro que deseas eliminar definitivamente este usuario?</span>:<br/>
			<div style="padding-left:50px; padding-top:15px; padding-bottom:15px;">
				<div>
					<cfif len(objectUser.image_type) GT 0>
						<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" class="item_img" style="margin-right:2px;"/>
					<cfelse>
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" class="item_img_default" style="margin-right:2px;"/>
					</cfif> <strong>#objectUser.family_name# #objectUser.name#</strong> (#objectUser.email#)<br/>
				</div>
			</div>

			<div class="alert alert-danger"><i class="icon-warning-sign"></i> <span lang="es">Ten en cuenta que <b>se eliminarán definitivamente todos los contenidos del usuario</b>: mensajes, archivos, tareas, eventos, ...<br/>
			En las áreas en las que este usuario esté asignado como responsable, el administrador general de la organización pasará a ser el responsable.</span>
			</div>

			<form id="deleteUserForm" method="post">
				<input type="hidden" name="user_id" value="#user_id#"/>
			</form>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true"><span lang="es">Cancelar</span></button>
		    <button class="btn btn-danger" id="deleteUserSubmitButton" data-loading-text="Eliminando..." onclick="submitUserModal(event)"><span lang="es">Eliminar usuario</span></button>
		</div>

		<script>
			function submitUserModal(e){

			    if(e.preventDefault)
					e.preventDefault();

				$("##deleteUserSubmitButton").button('loading');

				if(currentTab == "##tab7") //usersGeneralIframe
					postModalForm("##deleteUserForm", "#APPLICATION.htmlComponentsPath#/User.cfc?method=deleteUser", "users.cfm", "usersGeneralIframe");
				else
					postModalForm("##deleteUserForm", "#APPLICATION.htmlComponentsPath#/User.cfc?method=deleteUser", "all_users.cfm", "allUsersIframe");


			}
		</script>

	</cfoutput>

</cfif>

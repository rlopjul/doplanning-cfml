<cfif isDefined("URL.user") AND isNumeric(URL.user)>
	
	<cfset user_id = URL.user>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
		<cfinvokeargument name="user_id" value="#user_id#"/>
	</cfinvoke>

	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4>Eliminar usuario</h4>
		</div>

	 	<div class="modal-body">
	  		
			¿Seguro que deseas eliminar definitivamente este usuario?:<br/>
			<div style="padding-left:50px; padding-top:15px; padding-bottom:15px;">
				<div>
					<cfif len(objectUser.image_type) GT 0>
						<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" class="item_img" style="margin-right:2px;"/>									
					<cfelse>							
						<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" class="item_img_default" style="margin-right:2px;"/>
					</cfif> <strong>#objectUser.family_name# #objectUser.name#</strong> (#objectUser.email#)<br/>
				</div>
			</div>

			<div class="alert alert-danger"><i class="icon-warning-sign"></i> Ten en cuenta que <b>se eliminarán definitivamente todos los contenidos del usuario</b>: mensajes, archivos, tareas, eventos, ...</div>

			<form id="deleteUserForm" method="post">
				<input type="hidden" name="user_id" value="#user_id#"/>
			</form>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancelar</button>
		    <button class="btn btn-danger" id="deleteUserSubmitButton" data-loading-text="Eliminando..." onclick="submitUserModal(event)">Eliminar usuario</button>
		</div>

		<script>
			function submitUserModal(e){

			    if(e.preventDefault)
					e.preventDefault();

				$("##deleteUserSubmitButton").button('loading');
				
				postModalForm("##deleteUserForm", "#APPLICATION.htmlComponentsPath#/User.cfc?method=deleteUser", "all_users.cfm", "allUsersIframe");

			}
		</script>

	</cfoutput>

</cfif>
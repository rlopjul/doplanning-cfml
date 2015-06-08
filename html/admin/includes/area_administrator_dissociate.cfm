<cfif isDefined("URL.area") AND isNumeric(URL.area) AND isDefined("URL.user") AND isNumeric(URL.user)>
	
	<cfset area_id = URL.area>
	<cfset user_id = URL.user>

	<cfset return_page = "area_users.cfm?area=#area_id#&no-cache=#RandRange(0,100)###administrators">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
		<cfinvokeargument name="user_id" value="#user_id#">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>

	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaPath" returnvariable="area_path">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="isUserAssociatedAsAdministrator" returnvariable="isAdministratorResponse">
		<cfinvokeargument name="area_id" value="#area_id#"/>
		<cfinvokeargument name="check_user_id" value="#user_id#"/>
	</cfinvoke>
	
	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h3>Quitar administrador de área</h3>
		</div>

	 	<div class="modal-body">

	 		<cfif isAdministratorResponse.isUserAdministrator IS true>
				
	  			<p lang="es">¿Seguro que desea quitar este usuario de administrador de esta área?:</p>

	  		<cfelse>

				<p><span class="label label-warning" lang="es">CUIDADO</span> <span lang="es">Este usuario no está asociado como administrador directamente a esta área, ha sido asociado a la siguiente área superior</span>:</p> 

			</cfif>


			<div class="well well-sm">
				<cfif len(objectUser.image_type) GT 0>
					<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" class="item_img" style="margin-right:2px;"/>									
				<cfelse>							
					<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" class="item_img_default" style="margin-right:2px;"/>
				</cfif> <strong>#objectUser.family_name# #objectUser.name#</strong> (#objectUser.email#)<br/>
			</div>


			<cfif isAdministratorResponse.isUserAdministrator IS true>
				
				<div class="well well-sm"><span lang="es">Área</span>:
					<strong>#objectArea.name#</strong><br/>
					<span lang="es">Ruta del área</span>: #area_path#
				</div>

				<form id="dissociateForm" method="post">
					<input type="hidden" name="area_id" value="#objectArea.id#"/>
					<input type="hidden" name="user_id" value="#objectUser.id#"/>
				</form>

			<cfelse>

				<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getNearestAreaUserAssociated" returnvariable="getNearestAreaResponse">
					<cfinvokeargument name="area_id" value="#area_id#"/>
					<cfinvokeargument name="user_id" value="#user_id#"/>
					<cfinvokeargument name="userType" value="administrators"/>
				</cfinvoke>

				<cfif getNearestAreaResponse.result IS true>
					
					<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaPath" returnvariable="nearest_area_path">
						<cfinvokeargument name="area_id" value="#getNearestAreaResponse.area_id#">
					</cfinvoke>

					<div class="well well-sm"><span lang="es">Area superior</span>:
						<strong>#getNearestAreaResponse.area_name#</strong><br/>
						<span lang="es">Ruta del área</span>: #nearest_area_path#
					</div>

					<p>Debe quitar al usuario de administrador en el área anterior para que deje de tener acceso en la actual.</p>

					<form id="dissociateForm" method="post">
						<input type="hidden" name="area_id" value="#getNearestAreaResponse.area_id#"/>
						<input type="hidden" name="user_id" value="#objectUser.id#"/>
					</form>

				<cfelseif SESSION.client_administrator IS user_id>

					<p><b lang="es">Este usuario es el administrador general, tiene acceso de administración por defecto a todas las áreas.</b></p>

				</cfif>

			</cfif>

			<small class="help-block" lang="es">No se enviará notificación por email de esta acción</small>
			
		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" lang="es">Cancelar</button>
		    <cfif isAdministratorResponse.isUserAdministrator IS true>
		   		<button class="btn btn-primary" id="areaModifySubmit" onclick="submitDissociateAdministratorModal(event)" lang="es">Quitar administrador</button>
		   	<cfelseif getNearestAreaResponse.result IS true>
		   		<button class="btn btn-warning" id="areaModifySubmit" onclick="submitDissociateAdministratorModal(event)" lang="es">Quitar administrador del área superior</button>
		   	</cfif>
		</div>

		<script>
			function submitDissociateAdministratorModal(e){

			    if(e.preventDefault)
					e.preventDefault();

				if (typeof $administratorDissociateModal !== 'undefined') { <!---Si $administratorDissociateModal está definido (listado de administradores), se oculta--->
				   $administratorDissociateModal.modal('hide');
				}

				postModalForm("##dissociateForm", "#APPLICATION.htmlComponentsPath#/User.cfc?method=dissociateAreaAdministrator", "#return_page#", "areaIframe");

			}
		</script>

	</cfoutput>

</cfif>
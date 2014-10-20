<cfif isDefined("URL.area") AND isNumeric(URL.area) AND isDefined("URL.user") AND isNumeric(URL.user)>
	
	<cfset area_id = URL.area>
	<cfset user_id = URL.user>

	<cfset return_page = "area_users.cfm?area=#area_id#&user=#user_id#&no-cache=#RandRange(0,100)###administrators">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
		<cfinvokeargument name="user_id" value="#user_id#">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>

	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaPath" returnvariable="area_path">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>
	
	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h3>Asociar administrador de área</h3>
		</div>

		<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="isUserAssociatedAsAdministrator" returnvariable="isAreaAdministratorResponse">
			<cfinvokeargument name="area_id" value="#area_id#"/>
			<cfinvokeargument name="check_user_id" value="#user_id#"/>
		</cfinvoke>


	 	<div class="modal-body">

  			<cfif isAreaAdministratorResponse.isUserAdministrator IS false>

				<p>¿Seguro que desea asociar este usuario como <b>administrador</b> de esta área?:</p>

			<cfelse>

				<p>Este usuario <b>ya es administrador de esta área</b>.</p>

			</cfif>

			<div>
				<div class="well well-sm">
					<cfif len(objectUser.image_type) GT 0>
						<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" class="item_img" style="margin-right:2px;"/>									
					<cfelse>							
						<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" class="item_img_default" style="margin-right:2px;"/>
					</cfif> <strong>#objectUser.family_name# #objectUser.name#</strong> (#objectUser.email#)<br/>
				</div>
				<div class="well well-sm">Área:
					<strong>#objectArea.name#</strong><br/>
					<span>Ruta del área: #area_path#
				</div>
			</div>

			<cfif isAreaAdministratorResponse.isUserAdministrator IS false>

				<small class="help-block">No se enviará notificación por email de esta acción</small>

				<form id="associateForm" method="post">
					<input type="hidden" name="area_id" value="#objectArea.id#"/>
					<input type="hidden" name="user_id" value="#objectUser.id#"/>
				</form>

			</cfif>


		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancelar</button>
		    <cfif isAreaAdministratorResponse.isUserAdministrator IS false>
		   		<button class="btn btn-primary" id="areaModifySubmit" onclick="submitAssociateAdministratorModal(event)">Asociar administrador</button>
		   	</cfif>
		</div>

		<script>
			function submitAssociateAdministratorModal(e){

			    if(e.preventDefault)
					e.preventDefault();

				postModalForm("##associateForm", "#APPLICATION.htmlComponentsPath#/User.cfc?method=associateAreaAdministrator", "#return_page#", "areaIframe");

			}
		</script>

	</cfoutput>

</cfif>
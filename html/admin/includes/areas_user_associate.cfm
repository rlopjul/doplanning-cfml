<cfif isDefined("URL.user") AND isNumeric(URL.user) AND isDefined("URL.areas")>
	
	<cfset user_id = URL.user>
	<cfset areas_ids = URL.areas>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
		<cfinvokeargument name="user_id" value="#user_id#">
	</cfinvoke>

	<cfif isDefined("URL.area") AND isNumeric(URL.area)>
		
		<cfset return_page = "area_users.cfm?area=#URL.area#">

	</cfif>
	
	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 lang="es">Asociar usuario a áreas</h4>
		</div>

	 	<div class="modal-body">

	 		<div class="well well-sm">
				<cfif len(objectUser.image_type) GT 0>
					<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" class="item_img" style="margin-right:2px;"/>									
				<cfelse>							
					<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" class="item_img_default" style="margin-right:2px;"/>
				</cfif> <strong>#objectUser.family_name# #objectUser.name#</strong> (#objectUser.email#)<br/>
			</div>

	 		<div><p lang="es">Confirma las áreas seleccionadas:</p></div>

	 		<div>

		 		<cfset areasToAssociate = "">

		 		<cfloop list="#areas_ids#" index="area_id">
		 			
		 			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
						<cfinvokeargument name="area_id" value="#area_id#"/>
					</cfinvoke>

					<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="isUserAssociatedToArea" returnvariable="isUserInAreaResponse">
						<cfinvokeargument name="area_id" value="#area_id#">
						<cfinvokeargument name="check_user_id" value="#user_id#">
					</cfinvoke>	

					<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaPath" returnvariable="area_path">
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfinvoke>

					<cfif isUserInAreaResponse.isUserInArea IS false>

						<cfset areasToAssociate = listAppend(areasToAssociate, area_id)>

						<div class="well well-sm" style="margin-bottom:10px"><span lang="es">Área</span>:
							<strong>#objectArea.name#</strong><br/>
							<span lang="es">Ruta del área</span>: #area_path#
						</div>

					<cfelse>

						<div class="well well-sm" style="margin-bottom:10px"><span lang="es">Área</span>:
							<strong>#objectArea.name#</strong><br/>
							<span lang="es">Ruta del área</span>: #area_path#
							<p><b>#objectUser.family_name# #objectUser.name#</b> <span lang="es">ya está asociado a esta área, no es necesario asociarlo</span>.</p>
						</div>

					</cfif>
						
		 		</cfloop>

	 		</div>

	 		<cfif listLen(areasToAssociate) GT 0>
	 			
	 			<small class="help-block" lang="es">Se enviará notificación al usuario y a los usuarios del área.</small>

				<form id="associateAreasUserForm" method="post">
					<input type="hidden" name="user_id" value="#objectUser.id#"/>
					<input type="hidden" name="areas_ids" value="#areasToAssociate#"/>
				</form>

			<cfelse>

				<p lang="es">No hay areas seleccionadas en las que no esté el usuario asociado</p>

	 		</cfif>
			
		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" lang="es">Cancelar</button>
		    <cfif listLen(areasToAssociate) GT 0>
		   		<button class="btn btn-primary" id="areaAssociateAreasSubmitButton" data-loading-text="Asociando..." onclick="submitAssociateAreasConfirmModal(event)" lang="es">Asociar a áreas</button>
		   	</cfif>
		</div>

		<script>
			function submitAssociateAreasConfirmModal(e){

			    if(e.preventDefault)
					e.preventDefault();

				$("##areaAssociateAreasSubmitButton").button('loading');

				var formId = "##associateAreasUserForm";
				var requestUrl = "#APPLICATION.htmlComponentsPath#/User.cfc?method=assignUserToAreas";

				<cfif isDefined("return_page")>
					postModalForm(formId, requestUrl, "#return_page#", "areaIframe");
				<cfelse>

					$('body').modalmanager('loading');

					$.ajax({

						  type: "POST",
						  url: requestUrl,
						  data: $(formId).serialize(),
						  dataType: "json",
						  success: function(data, status) {

						  	if(status == "success"){
						  		var message = data.message;

						  		//openUrl(responseUrl+"&msg="+message+"&res="+data.result,responseTarget);

						  		hideDefaultModal();

						  		$('body').modalmanager('removeLoading');

						  		showAlertMessage(message, data.result);

						  	}else
								alert(status);
							
						  }		  
						});


				</cfif>
			}
		</script>

	</cfoutput>

</cfif>
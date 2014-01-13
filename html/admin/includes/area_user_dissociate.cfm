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
	
	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h3 id="areaModalLabel">Quitar usuario de área</h3>
		</div>

	 	<div class="modal-body">
	  		
			¿Seguro que desea quitar este usuario de esta área?:<br/>
			<div style="padding-left:50px; padding-top:15px;">
				<div>
					<cfif len(objectUser.image_type) GT 0>
						<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" class="item_img" style="margin-right:2px;"/>									
					<cfelse>							
						<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" class="item_img_default" style="margin-right:2px;"/>
					</cfif> <strong>#objectUser.family_name# #objectUser.name#</strong> (#objectUser.email#)<br/>
				</div>
				<div style="margin-top:10px;">Area:
					<strong>#objectArea.name#</strong><br/>
					<span>Ruta del área: #area_path#
				</div>
			</div>

			<form id="dissociateForm" method="post">
				<input type="hidden" name="area_id" value="#objectArea.id#"/>
				<input type="hidden" name="user_id" value="#objectUser.id#"/>
			</form>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancelar</button>
		    <button class="btn btn-primary" id="areaModifySubmit" onclick="submitAssociateModal(event)">Quitar usuario</button>
		</div>

		<script>
			function submitAssociateModal(e){

			    if(e.preventDefault)
					e.preventDefault();

				postModalForm("##dissociateForm", "#APPLICATION.htmlComponentsPath#/User.cfc?method=dissociateUserFromArea", "#return_page#", "areaIframe");

			}
		</script>

	</cfoutput>

</cfif>
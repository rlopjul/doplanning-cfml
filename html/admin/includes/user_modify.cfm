<cfif isDefined("URL.user") AND isNumeric(URL.user)>

	<cfset user_id = URL.user>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
		<cfinvokeargument name="user_id" value="#user_id#"/>
		<cfinvokeargument name="format_content" value="all"/>
	</cfinvoke>

	<cfoutput>
	<script>

		$(function () {

			$("##deleteImageButton").click(function() {

				if(confirmAction('eliminar')) {

					var requestUrl = "#APPLICATION.htmlComponentsPath#/User.cfc?method=deleteUserImage&user_id=#user_id#";

					$.ajax({
					  type: "POST",
					  url: requestUrl,
					  success: function(data, status) {

					  	if(status == "success"){
					  		var message = data.message;

					  		var userId = data.user_id;
					  		openUrl("all_users.cfm?user="+userId, "allUsersIframe");

					  		hideDefaultModal();

					  		$('body').modalmanager('removeLoading');

					  		showAlertMessage(message, data.result);

					  	}else
							showAlertErrorModal(status);

					  },
					  dataType: "json"
					});

				}

			});


			$("##updateUserData").validate({

				submitHandler: function(form) {

					postUserDataForm("#APPLICATION.htmlComponentsPath#/User.cfc?method=updateUser");

				}

			});


		});


		<!---
		function submitUserModifyModal(){

			postUserDataForm("#APPLICATION.htmlComponentsPath#/User.cfc?method=updateUser");

		}--->

	</script>
	</cfoutput>

	<div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	    <h4 lang="es">Modificar usuario</h4>
	</div>

 	<div class="modal-body">

 		<div class="container-fluid">
 			<cfset page_type = 1>
				<cfinclude template="#APPLICATION.corePath#/includes/user_data_form.cfm">
		</div>

	</div>

	<div class="modal-footer">
	    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true"><span lang="es">Cancelar</span></button>
	    <button class="btn btn-primary" id="userSubmitButton" data-loading-text="Guardando..." onclick="$('#updateUserData').submit()"><span lang="es">Guardar cambios</span></button>
	</div>

	<!---<cfinclude template="#APPLICATION.htmlPath#/admin/includes/error_modal.cfm"/>--->

<cfelse>
	<div class="alert alert-danger"><span>Error</span></div>
</cfif>

<cfoutput>
<script src="#APPLICATION.htmlPath#/language/user_content_en.js" charset="utf-8"></script>
<script src="#APPLICATION.htmlPath#/admin/scripts/userFormFunctions.js"></script>
</cfoutput>

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
							alert(status);
						
					  },
					  dataType: "json"
					});

				}
			
			});

		});


		function submitUserModifyModal(){

			postUserDataForm("#APPLICATION.htmlComponentsPath#/User.cfc?method=updateUser");

		}

	</script>
	</cfoutput>

	<div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	    <h4>Modificar usuario</h4>
	</div>

 	<div class="modal-body">

 		<div class="container-fluid">
 			<cfset page_type = 1>
			<cfinclude template="#APPLICATION.htmlPath#/includes/user_data_form.cfm"/>
		</div>

	</div>

	<div class="modal-footer">
	    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancelar</button>
	    <button class="btn btn-primary" onclick="submitUserModifyModal()">Guardar cambios</button>
	</div>

	<cfinclude template="#APPLICATION.htmlPath#/admin/includes/error_modal.cfm"/>

<cfelse>
	<div class="alert alert-danger"><span>Error</span></div>
</cfif>
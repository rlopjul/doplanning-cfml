<cfoutput>
<script src="#APPLICATION.htmlPath#/admin/scripts/userFormFunctions.js?v=1.5"></script>
</cfoutput>


<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="getEmptyUser" returnvariable="getUserResponse">
</cfinvoke>

<cfif getUserResponse.result IS true>

	<cfset objectUser = getUserResponse.user>

	<cfoutput>
	<script>

		$(function () {


			$("##updateUserData").validate({

				submitHandler: function(form) {

					postUserDataForm("#APPLICATION.htmlComponentsPath#/User.cfc?method=createUser");

				}

			});


		});

		<!---
		function submitUserNewModal(){

			$("##createUserSubmitButton").button('loading');

			postUserDataForm("#APPLICATION.htmlComponentsPath#/User.cfc?method=createUser");

		}--->

	</script>
	</cfoutput>

	<div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	    <h4 lang="es">Nuevo usuario</h4>
	</div>

	<div class="modal-body">

		<div class="container-fluid">
			<cfset page_type = 1>
			<cfinclude template="#APPLICATION.htmlPath#/includes/user_data_form.cfm"/>

			<div class="row">
				<div class="col-sm-12">
					<small class="help-block" lang="es">Si el usuario se marca como activo, se le enviará una <b>notificación por email</b> con los datos de acceso a la aplicación, incluyendo la contraseña.</small>
				</div>
			</div>
		</div>

	</div>

	<div class="modal-footer">
	    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true"><span lang="es">Cancelar</span></button>
	    <button class="btn btn-primary" id="userSubmitButton" data-loading-text="Guardando..." onclick="$('#updateUserData').submit()"><span lang="es">Guardar</span></button>
	</div>


	<!---<cfinclude template="#APPLICATION.htmlPath#/admin/includes/error_modal.cfm"/>--->

<cfelse>
	<div class="alert alert-danger"><span>Error</span></div>
</cfif>

<cfif isDefined("URL.user") AND isNumeric(URL.user)>

	<cfset user_id = URL.user>

	<cfoutput>
	<script>

		$(function () {

			$("##updateUserAlertPreferences").validate({

				submitHandler: function(form) {

					postUserAlertPreferencesForm("#APPLICATION.htmlComponentsPath#/User.cfc?method=updateUserPreferences");

				}

			});


		});

	</script>
	</cfoutput>

	<div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	    <h4 lang="es">Modificar preferencias de notificaciones</h4>
	</div>

 	<div class="modal-body">

 		<div class="container-fluid">

			<div class="alert alert-warning" role="alert">Tenga en cuenta que no debe modificar las preferencias de notificaciones de los usuarios sin su consentimiento</div>

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUserPreferences" returnvariable="preferences">
				<cfinvokeargument name="get_user_id" value="#user_id#">
			</cfinvoke>

			<cfinclude template="#APPLICATION.htmlPath#/includes/user_preferences_alerts_form.cfm">

		</div>

	</div>

	<div class="modal-footer">
	    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true"><span lang="es">Cancelar</span></button>
	    <button class="btn btn-primary" id="userPreferencesSubmitButton" data-loading-text="Guardando..." onclick="$('#updateUserAlertPreferences').submit()"><span lang="es">Guardar cambios</span></button>
	</div>

	<!---<cfinclude template="#APPLICATION.htmlPath#/admin/includes/error_modal.cfm"/>--->

<cfelse>
	<div class="alert alert-danger"><span>Error</span></div>
</cfif>



<cfinvoke component="#APPLICATION.componentsPath#/ClientManager" method="getClient" returnvariable="getClientResponse">
	<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
</cfinvoke>


<cfif getClientResponse.result IS true>

	<cfset clientQuery = getClientResponse.client>
	
	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 id="areaModalLabel">Opciones de notificación a usuarios</h4>
		</div>

	 	<div class="modal-body">
	  		
	  		<form id="notificationsForm" method="post" class="form-horizontal">

				<div class="row">
					<div class="col-sm-12">
						<div class="checkbox">
						    <label>
						    	<input type="checkbox" name="force_notifications" value="true" <cfif clientQuery.force_notifications IS true>checked</cfif>/> Habilitar a todos los usuarios todas las notificaciones por email de forma obligatoria
						    </label>
						    <small class="help-block">
								Los usuarios no podrán deshabilitar las notificaciones que envía la aplicación
							</small>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-sm-12">
						<div class="checkbox">
						    <label>
						    	<input type="checkbox" name="tasks_reminder_notifications" value="true" <cfif clientQuery.tasks_reminder_notifications IS true>checked</cfif>> Habilitar notificaciones para recordar tareas
						    </label>
						    <small class="help-block">
								Se enviará una notificación por email el número de días antes especificado a continuación y el mismo día que caduque la tarea.
							</small>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-sm-12">
						<label class="control-label" for="tasks_reminder_days" lang="es">Número de días previos a caducidad para enviar recordatorio de tareas</label>

						<div class="row">
							<div class="col-sm-2">
								<input type="text" name="tasks_reminder_days" id="tasks_reminder_days" value="#clientQuery.tasks_reminder_days#" required="true" message="Número de días obligatorio" class="form-control" />
							</div>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-sm-12">
						<label class="control-label" for="default_language" lang="es">Idioma por defecto</label>

						<div class="row">
							<div class="col-sm-4">
								<select name="default_language" id="default_language" class="form-control">
									<option value="es" <cfif clientQuery.default_language EQ "es">selected="selected"</cfif>>Español</option>
									<option value="en" <cfif clientQuery.default_language EQ "en">selected="selected"</cfif>>English</option>
								</select>
							</div>
							<div class="col-sm-8">
								<small class="help-block">
									Los usuarios podrán modificar el idioma en que se muestra la aplicación
								</small>
							</div>
						</div>
					</div>					
				</div>

			</form>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancelar</button>
		    <button class="btn btn-primary" onclick="submitNotificationOptionsModal(event)">Guardar cambios</button>
		</div>

		<script>
			function submitNotificationOptionsModal(e){

			    if(e.preventDefault)
					e.preventDefault();
			      
				if( $.isNumeric($("##tasks_reminder_days").val()) ){
				
			    	<!---if( $("##name").val().length > 0 ){
			    		postModalFormTree("##areaForm", "#APPLICATION.htmlComponentsPath#/Area.cfc?method=updateArea");
			    	} else {
			    		alert("Debe introducir un nombre de área");
			    	}--->

			    	$('body').modalmanager('loading');

					var formId = "##notificationsForm";
					var requestUrl = "#APPLICATION.htmlComponentsPath#/Client.cfc?method=updateClientAdminOptions";

					$.ajax({
						  type: "POST",
						  url: requestUrl,
						  data: $(formId).serialize(),
						  success: function(data, status) {

						  	if(status == "success"){
						  		var message = data.message;

						  		hideDefaultModal();

						  		$('body').modalmanager('removeLoading');
						  		
						  		showAlertMessage(message, data.result);

						  	}else
								alert(status);
							
						  },
						  dataType: "json"
					});


				} else {

					alert("Debe introducir un número válido de días");
				}
				
			}
		</script>

	</cfoutput>

<cfelse>
	Error
</cfif>
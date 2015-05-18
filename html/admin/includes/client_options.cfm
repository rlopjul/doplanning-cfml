

<cfinvoke component="#APPLICATION.componentsPath#/ClientManager" method="getClient" returnvariable="getClientResponse">
	<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
</cfinvoke>


<cfif getClientResponse.result IS true>

	<cfset clientQuery = getClientResponse.client>
	
	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4>Opciones de de la organización</h4>
		</div>

	 	<div class="modal-body">
	  		
	  		<form id="notificationsForm" method="post" class="form-horizontal">

	  			<div class="row">
					<div class="col-sm-12">
						<label for="app_title" lang="es">Título de la aplicación</label>

						<div class="row">
							<div class="col-sm-12">
								<input type="text" name="app_title" id="app_title" value="#clientQuery.app_title#" class="form-control" required />
								<small class="help-block">
									Título que aparece en la parte superior de la aplicación y en la pantalla de login.<br>
									Una vez modificado es necesario salir y volver acceder a la aplicación para que el cambio se vea reflejado.
								</small>
							</div>
						</div>
					</div>					
				</div>

	  			<div class="row">
					<div class="col-sm-12">
						<label for="default_language" lang="es">Idioma por defecto de la aplicación</label>

						<div class="row">
							<div class="col-sm-12">
								<select name="default_language" id="default_language" class="form-control">
									<option value="es" <cfif clientQuery.default_language EQ "es">selected="selected"</cfif>>Español</option>
									<option value="en" <cfif clientQuery.default_language EQ "en">selected="selected"</cfif>>English</option>
								</select>
								<small class="help-block">
									Idioma en el que se muestra por defecto la pantalla de login de la aplicación y el que se define por defecto al crear un nuevo usuario.<br>
									Cada usuario tiene definido su propio idioma, que puede cambiarlo en cualquier momento.
								</small>
							</div>
						</div>
					</div>					
				</div>

				<div class="row">
					<div class="col-sm-12">
						<br>
						<h4>Notificaciones automáticas por email</h4>
					</div>
				</div>

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
						<label for="tasks_reminder_days" lang="es">Número de días previos a caducidad para enviar recordatorio de tareas</label>

						<div class="row">
							<div class="col-sm-2">
								<input type="number" name="tasks_reminder_days" id="tasks_reminder_days" value="#clientQuery.tasks_reminder_days#" required="true" min="1" max="500" message="Número de días obligatorio" class="form-control" />
							</div>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-sm-12">
						<br>
					</div>
				</div>


				<div class="row">
					<div class="col-sm-12">
						<h4>Papelera</h4>
					</div>
				</div>

				<div class="row">
					<div class="col-sm-12">
						<div class="checkbox">
						    <label>
						    	<input type="checkbox" name="bin_enabled" value="true" <cfif clientQuery.bin_enabled IS true>checked</cfif>> Habilitar papelera
						    </label>
						    <small class="help-block">
								Los archivos se mantendrán en la papelera el número de días especificados a continuación.<br/>
								Si se deshabilita la papelera después de habilitarla, los usuarios dejarán de tener acceso a los elementos almacenados en la misma.
							</small>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-sm-12">
						<label for="bin_days" lang="es">Número de días que se mantendrán los archivos en la papelera</label>

						<div class="row">
							<div class="col-sm-2">
								<input type="text" name="bin_days" id="bin_days" value="#clientQuery.bin_days#" required="true" min="1" max="500" message="Número de días obligatorio" class="form-control" />
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
			    		showAlertModal("Debe introducir un nombre de área");
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
								showAlertErrorModal(status);
							
						  },
						  dataType: "json"
					});


				} else {

					showAlertModal("Debe introducir un número válido de días");
				}
				
			}
		</script>

	</cfoutput>

<cfelse>
	Error
</cfif>
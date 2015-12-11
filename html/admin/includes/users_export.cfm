<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="isUserUserAdministrator" returnvariable="isUserUserAdministratorResponse">
	<cfinvokeargument name="check_user_id" value="#SESSION.user_id#">
</cfinvoke>

<cfif isUserUserAdministratorResponse.result IS 0 OR isUserUserAdministratorResponse.isUserAdministrator NEQ true>

	<div class="alert alert-warning" role="alert"><i class="fa fa-warning"></i> <span lang="es">No dispone de permiso.</span></div>

<cfelse>

	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 lang="es">Exportar usuarios</h4>
		</div>

	 	<div class="modal-body">

			<form name="export_users" method="post" action="#APPLICATION.htmlComponentsPath#/User.cfc?method=exportUsersDownload" class="form-horizontal">

				<div class="row">
					<div class="col-sm-12">
				      <b lang="es">Incluir las siguientes columnas:</b>
				    </div>
				</div>

				<div class="row">
					<div class="col-xs-offset-1 col-xs-11">
				      <div class="checkbox">
				        <label>
				          <input type="checkbox" name="include_creation_date" value="true"><span lang="es">Fecha de creación</span>
				      	</label>
				      </div>
				    </div>
				</div>

				<div class="row">
					<div class="col-xs-offset-1 col-xs-11">
				      <div class="checkbox">
				        <label>
				          <input type="checkbox" name="include_number_of_connections" value="true"><span lang="es">Número de conexiones</span>
				      	</label>
				      </div>
				    </div>
				</div>

				<div class="row">
					<div class="col-xs-offset-1 col-xs-11">
				      <div class="checkbox">
				        <label>
				          <input type="checkbox" name="include_last_connection" value="true"><span lang="es">Fecha última conexión</span>
				      	</label>
				      </div>
				    </div>
				</div>

			</div>

		</form>

		<div class="modal-footer">
		  <button class="btn btn-default" data-dismiss="modal" aria-hidden="true"><span lang="es">Cancelar</span></button>
		  <button class="btn btn-primary" onclick="submitUsersExportModal(event)"><span lang="es">Exportar</span></button>
		</div>

		<script>
			function submitUsersExportModal(e){

			  if(e.preventDefault)
					e.preventDefault();

				showLoading = false;

				submitForm("export_users");

				showLoadingPage(false);

				hideDefaultModal();

			}
		</script>

	</cfoutput>

</cfif>

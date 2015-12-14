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

			<form name="export_users" method="post" action="#APPLICATION.htmlComponentsPath#/User.cfc?method=exportUsersDownload" target="downloadFileIframe" class="form-horizontal">

				<!--- Users Typologies --->

				<cfset typologyTableTypeId = 4>

				<cfset selected_typology_id = "null">

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAllTypologies" returnvariable="getAllTypologiesResponse">
					<cfinvokeargument name="tableTypeId" value="#typologyTableTypeId#">
				</cfinvoke>
				<cfset typologies = getAllTypologiesResponse.query>

				<cfif typologies.recordCount GT 0>

					<div class="row">

						<div class="col-sm-12">

							<label for="typology_id" class="col-xs-5 col-sm-3 control-label" lang="es">Tipología</label>

							<div class="col-xs-7 col-sm-9">

								<select name="typology_id" id="typology_id" class="form-control">
									<option value="null" <cfif selected_typology_id EQ "null">selected="selected"</cfif> lang="es">Básica</option>
									<cfif typologies.recordCount GT 0>
										<cfloop query="typologies">
											<option value="#typologies.id#" <cfif typologies.id IS selected_typology_id>selected="selected"</cfif>>#typologies.title#</option>
										</cfloop>
									</cfif>
								</select>

							</div>

						</div>

					</div>

				</cfif>

				<div class="row" style="padding-top:15px;">

					<div class="col-xs-12">
						<label lang="es">Incluir las siguientes columnas:</label>
					</div>

				</div>

				<div class="row">

					<div class="col-xs-5 col-sm-3">
					</div>

					<div class="col-xs-7 col-sm-9">

						<div class="row">
							<div class="col-xs-12">
						      <div class="checkbox">
						        <label>
						          <input type="checkbox" name="include_id" value="true"> <span lang="es">ID interno del usuario</span>
						      	</label>
						      </div>
						  </div>
						</div>

						<div class="row">
							<div class="col-xs-12">
						      <div class="checkbox">
						        <label>
						          <input type="checkbox" name="include_creation_date" value="true"> <span lang="es">Fecha de creación</span>
						      	</label>
						      </div>
						  </div>
						</div>

						<div class="row">
							<div class="col-xs-12">
						      <div class="checkbox">
						        <label>
						          <input type="checkbox" name="include_number_of_connections" value="true"> <span lang="es">Número de conexiones</span>
						      	</label>
						      </div>
						  </div>
						</div>

						<div class="row">
							<div class="col-xs-12">
						      <div class="checkbox">
						        <label>
						          <input type="checkbox" name="include_last_connection" value="true"> <span lang="es">Fecha última conexión</span>
						      	</label>
						      </div>
						  </div>
						</div>

					</div>

				</div>

			</div>

		</form>

		<iframe id="downloadFileIframe" name="downloadFileIframe" style="display:none"></iframe>

		<div class="modal-footer">
		  <button class="btn btn-default" data-dismiss="modal" aria-hidden="true"><span lang="es">Cancelar</span></button>
		  <button class="btn btn-primary" onclick="submitUsersExportModal(event)"><span lang="es">Exportar</span></button>
		</div>

		<script>
			function submitUsersExportModal(e){

			  if(e.preventDefault)
					e.preventDefault();

				submitForm("export_users");

				//hideDefaultModal();

			}
		</script>

	</cfoutput>

</cfif>

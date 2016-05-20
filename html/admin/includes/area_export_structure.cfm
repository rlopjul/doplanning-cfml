<cfif isDefined("URL.parent")>

	<cfset parent_area_id = URL.parent>

	<!--- Get parent area --->
	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getArea" returnvariable="objectParentArea">
		<cfinvokeargument name="get_area_id" value="#parent_area_id#">
		<cfinvokeargument name="return_type" value="query">
	</cfinvoke>

	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 lang="es">Exportar estructura de áreas</h4>
		</div>

	 	<div class="modal-body">

			<div clas="container">

				<cfif isDefined("objectParentArea")>
				<div class="row">
					<div class="col-sm-12">
						<span lang="es">Área a exportar:</span> <strong>#objectParentArea.name#</strong>
					</div>
				</div>
				</cfif>

				<div class="row">
					<div class="col-sm-12">

						<p class="help-block" style="font-size:12px;" lang="es">
							Se generará un archivo en formato xml que se podrá usar para realizar importaciones de estructuras de áreas en la aplicación.<br/>
							Este archivo contendrá la estructura de todas las áreas desde el área seleccionada hacia abajo.
						</p>

					</div>
				</div>

			</div>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true"><span lang="es">Cancelar</span></button>
		    <button class="btn btn-primary" onclick="submitAreaExportModal(event)"><span lang="es">Exportar</span></button>
		</div>

		<script>
			function submitAreaExportModal(e){

			    if(e.preventDefault)
					e.preventDefault();

				hideDefaultModal();

			    goToUrl("area_export_structure_download.cfm?area=#parent_area_id#");

			}
		</script>

	</cfoutput>

</cfif>

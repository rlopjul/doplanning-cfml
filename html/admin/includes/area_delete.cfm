<cfif isDefined("URL.area") AND isNumeric(URL.area)>

	<cfset area_id = URL.area>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>

	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaPath" returnvariable="area_path">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 lang="es">Eliminar área</h3>
		</div>

	 	<div class="modal-body">

			<span lang="es">¿Seguro que deseas eliminar definitivamente esta área?</span>:<br/>
			<div style="padding-left:50px; padding-top:15px; padding-bottom:15px;">

				<div style="margin-top:10px;"><span lang="es">Área</span>:
					<strong>#objectArea.name#</strong><br/>
					<span lang="es">Ruta</span><span>: #area_path#</span>
				</div>
			</div>

			<div class="alert alert-danger"><i class="icon-warning-sign"></i>
				<span lang="es">Ten en cuenta que <b>se eliminarán DEFINITIVAMENTE todos los elementos del área</b>: mensajes, archivos, tareas, eventos...</span></div>
			</div>

			<form id="deleteAreaForm" method="post">
				<input type="hidden" name="area_id" value="#objectArea.id#"/>
			</form>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true"><span lang="es">Cancelar</span></button>
		    <button class="btn btn-danger" id="areaDeleteSubmit" data-loading-text="Eliminando..." onclick="submitAssociateModal(event)"><span lang="es">Eliminar área</span></button>
		</div>

		<script>
			function submitAssociateModal(e){

			    if(e.preventDefault)
					e.preventDefault();

				$("##areaDeleteSubmit").button('loading');

				postModalFormTree("##deleteAreaForm", "#APPLICATION.htmlComponentsPath#/Area.cfc?method=deleteArea");

			}
		</script>

	</cfoutput>

</cfif>

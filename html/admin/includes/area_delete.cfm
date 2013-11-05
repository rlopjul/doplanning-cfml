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
		    <h3 id="areaModalLabel">Eliminar área</h3>
		</div>

	 	<div class="modal-body">
	  		
			¿Seguro que desea eliminar definitivamente esta área?:<br/>
			<div style="padding-left:50px; padding-top:15px; padding-bottom:15px;">

				<div style="margin-top:10px;">Area:
					<strong>#objectArea.name#</strong><br/>
					<span>Ruta: #area_path#
				</div>
			</div>

			<div>Tenga en cuenta que se eliminarán definitivamente todos los elementos del área: mensajes, tareas, eventos...</div>

			<form id="deleteAreaForm" method="post">
				<input type="hidden" name="area_id" value="#objectArea.id#"/>
			</form>

		</div>

		<div class="modal-footer">
		    <button class="btn" data-dismiss="modal" aria-hidden="true">Cancelar</button>
		    <button class="btn btn-primary" id="areaModifySubmit" onclick="submitAssociateModal(event)">Eliminar área</button>
		</div>

		<script>
			function submitAssociateModal(e){

			    if(e.preventDefault)
					e.preventDefault();
				
				postModalFormTree("##deleteAreaForm", "#APPLICATION.htmlComponentsPath#/Area.cfc?method=deleteArea");

			}
		</script>

	</cfoutput>

</cfif>
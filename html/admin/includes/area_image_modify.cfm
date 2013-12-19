<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	
	<cfset area_id = URL.area>

	<cfset return_page = "area_users.cfm?area=#area_id#">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>
	
	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h3 id="areaModalLabel">Modificar imagen de área</h3>
		</div>

	 	<div class="modal-body">
	  
			<cfform id="areaForm" method="post" enctype="multipart/form-data" class="form-inline">
				<cfif isDefined("area_id")>
					<input type="hidden" name="area_id" id="area_id" value="#area_id#" />
				</cfif>
				<!---<div class="form-group">
					<label class="control-label" for="name" lang="es">Nombre:</label>
					<div class="form-group">
						<cfinput type="text" name="name" id="name" value="#objectArea.name#" required="true" message="Nombre de área requerida" class="form-control" />
					</div>
				</div>--->
				
				<div class="form-group">
					<label class="control-label" for="image_file" lang="es">Imagen:</label>
					<div class="form-group">
						<cfinput type="file" name="image_file" id="image_file" /><br/>
						<small>Si no se asigna una imagen a esta área se mostrará la heredada de las áreas superiores.</small>
					</div>
				</div>

				<div class="form-group">
					<label class="control-label" for="image_file" lang="es">URL:</label>
					<div class="form-group">
						<cfinput type="text" name="link" id="link" value="#objectArea.link#" required="false" class="form-control" /><br/>
						<small>URL a la que se enlazará al hacer clic en la imagen.</small>
					</div>
				</div>

			</cfform>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancelar</button>
		    <button class="btn btn-primary" id="areaModifySubmit" onclick="submitAreaModal(event)">Guardar cambios</button>
		</div>

		<script>
			function submitAreaModal(e){

			    if(e.preventDefault)
					e.preventDefault();

				postModalForm("##areaForm", "#APPLICATION.htmlComponentsPath#/Area.cfc?method=updateAreaImage", "#return_page#", "areaIframe");

			}
		</script>

	</cfoutput>

</cfif>
<cfif isDefined("URL.parent")>
	
	<cfset parent_area_id = URL.parent>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectParentArea">
		<cfinvokeargument name="area_id" value="#parent_area_id#"/>
	</cfinvoke>

	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="objectArea" returnvariable="objectArea">
		<cfinvokeargument name="return_type" value="object">
	</cfinvoke>

	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h3 id="areaModalLabel">Crear área</h3>
		</div>

	 	<div class="modal-body">
	  
			<cfinclude template="#APPLICATION.htmlPath#/admin/includes/area_form.cfm"/>

		</div>

		<div class="modal-footer">
		    <button class="btn" data-dismiss="modal" aria-hidden="true">Cancelar</button>
		    <button class="btn btn-primary" id="areaModifySubmit" onclick="submitAreaModal(event)">Guardar</button>
		</div>

		<script>
			function submitAreaModal(e){

			    e.preventDefault();
			      
				postModalFormTree("##areaForm", "#APPLICATION.htmlComponentsPath#/Area.cfc?method=createArea");

			}
		</script>

	</cfoutput>
	

</cfif>
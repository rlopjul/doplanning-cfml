<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	
	<cfset area_id = URL.area>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>
	
	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 lang="es">Modificar área</h4>
		</div>

	 	<div class="modal-body">
	  
			<cfinclude template="#APPLICATION.htmlPath#/admin/includes/area_form.cfm"/>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true"><span lang="es">Cancelar</span></button>
		    <button class="btn btn-primary" id="areaModifySubmit" onclick="submitAreaModal(event)"><span lang="es">Guardar cambios</span></button>
		</div>

		<script>
			function submitAreaModal(e){

			    if(e.preventDefault)
					e.preventDefault();
			      
				<!--- postModalForm("##areaForm", "##areaModal", "#APPLICATION.htmlComponentsPath#/Area.cfc?method=updateArea", "#return_page#", "areaIframe"); --->

				<!---postModalForm("##areaForm", "#APPLICATION.htmlComponentsPath#/Area.cfc?method=updateArea", "#return_page#", "areaIframe"); --->

				if( $.isNumeric($("##user_in_charge").val()) ){

			    	if( $("##name").val().length > 0 ){
			    		postModalFormTree("##areaForm", "#APPLICATION.htmlComponentsPath#/Area.cfc?method=updateArea");
			    	} else {
			    		showAlertModal(window.lang.translate("Debe introducir un nombre de área"));
			    	}

				} else {

					showAlertModal(window.lang.translate("Debe seleccionar un usuario responsable"));
				}

			}
		</script>

	</cfoutput>

</cfif>
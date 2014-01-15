<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	
	<cfset area_id = URL.area>

	<!---<cfset return_page = "area_users.cfm?area=#area_id#">--->

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>
	
	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 id="areaModalLabel">Modificar área</h4>
		</div>

	 	<div class="modal-body">
	  
			<cfinclude template="#APPLICATION.htmlPath#/admin/includes/area_form.cfm"/>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancelar</button>
		    <button class="btn btn-primary" id="areaModifySubmit" onclick="submitAreaModal(event)">Guardar cambios</button>
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
			    		alert("Debe introducir un nombre de área");
			    	}

				} else {

					alert("Debe seleccionar un usuario responsable");
				}

			}
		</script>

	</cfoutput>

</cfif>
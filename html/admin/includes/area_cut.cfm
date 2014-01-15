<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	
	<cfset area_id = URL.area>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>
	
	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 id="areaModalLabel">Cortar área</h4>
		</div>

	 	<div class="modal-body">
	  		
	 		Seleccione el área de destino:

	 		<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" src="iframes/area_cut_tree.cfm?area=#area_id#" style="height:350px;background-color:##FFFFFF;"></iframe>

	 		<form id="cutAreaForm" method="post">
				<input type="hidden" name="area_id" value="#objectArea.id#"/>
				<input type="hidden" name="parent_id" value="" id="newParentInput"/>
			</form>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancelar</button>
		    <button class="btn btn-primary" id="areaModifySubmit" onclick="submitAreaModal(event)">Mover área</button>
		</div>

		<script>
			function submitAreaModal(e){

				if( $.isNumeric($("##newParentInput").val()) ){
					postModalFormTree("##cutAreaForm", "#APPLICATION.htmlComponentsPath#/Area.cfc?method=moveArea");
				} else {

					alert("Debe seleccionar un área de destino");
				}

			}

			function setNewParentId(areaId){
				$("##newParentInput").val(areaId);
			}
		</script>

	</cfoutput>

</cfif>
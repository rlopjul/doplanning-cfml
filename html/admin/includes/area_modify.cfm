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

			$(function () {

				$("##areaForm").validate({

					submitHandler: function(form) {

						if( $("##url_id_suffix").length ){

							var url_id = $("##url_id_prefix").text()+$("##url_id_suffix").val();

							$("##url_id").val( url_id.toLowerCase() );
						}

						if( $.isNumeric($("##user_in_charge").val()) ){

							if( $("##name").val().length > 0 ){

								postModalFormTree("##areaForm", "#APPLICATION.htmlComponentsPath#/Area.cfc?method=updateArea");

							} else {
								showAlertModal("Debe introducir un nombre de área");
							}

						} else {

							showAlertModal("Debe seleccionar un usuario responsable");
						}

					}

				});

			});

			function submitAreaModal(e){

			  if(e.preventDefault)
				e.preventDefault();

				$("##areaForm").submit();

			}
		</script>

	</cfoutput>

</cfif>

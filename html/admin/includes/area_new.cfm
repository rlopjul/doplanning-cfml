<cfif isDefined("URL.parent")>

	<cfset parent_area_id = URL.parent>

	<!--- Get parent area --->
	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getArea" returnvariable="objectParentArea">
		<cfinvokeargument name="get_area_id" value="#parent_area_id#">
		<cfinvokeargument name="return_type" value="query">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="objectArea" returnvariable="objectArea">
		<cfinvokeargument name="return_type" value="object">
	</cfinvoke>

	<!--- Set default responsible --->
	<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="getUser" returnvariable="userQuery">
		<cfinvokeargument name="get_user_id" value="#SESSION.user_id#">
		<cfinvokeargument name="format_content" value="default">
		<cfinvokeargument name="return_type" value="query">
	</cfinvoke>

	<cfset objectArea.user_in_charge = userQuery.id>
	<cfset objectArea.user_full_name = userQuery.user_full_name>

	<cfset objectArea.list_mode = objectParentArea.list_mode>
	<cfset objectArea.users_visible = objectParentArea.users_visible>
	<cfset objectArea.read_only = objectParentArea.read_only>
	<cfset objectArea.url_id = "">

	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 id="areaModalLabel" lang="es">Crear área</h4>
		</div>

	 	<div class="modal-body">

			<cfinclude template="#APPLICATION.htmlPath#/admin/includes/area_form.cfm"/>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" lang="es">Cancelar</button>
		    <button class="btn btn-primary" id="areaModifySubmit" onclick="submitAreaModal(event)" lang="es">Guardar</button>
		</div>

		<script>

			$(function () {

				$("##areaForm").validate({

					submitHandler: function(form) {

						if( $.isNumeric($("##user_in_charge").val()) ){

							if( $("##name").val().length > 0 ){

								postModalFormTree("##areaForm", "#APPLICATION.htmlComponentsPath#/Area.cfc?method=createArea");

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

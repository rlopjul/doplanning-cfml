<cfset select_enabled = true>
  
<cfoutput>
	<script>

		function getSelectedItemsIds() {

			var selectedItemsIds = "";

			$('##listTable tbody tr:visible input[type=checkbox]:checked').each(function() {

				if(selectedItemsIds.length > 0)
					selectedItemsIds = selectedItemsIds+","+this.value;
				else
					selectedItemsIds = this.value;

			});

			return selectedItemsIds;

		}

		function goToChangeUser(){

			var itemsIds = getSelectedItemsIds();

			if(itemsIds.length > 0)
				goToUrl("item_change_user.cfm?area=#area_id#&itemTypeId=#itemTypeId#&items="+itemsIds);
			else
				parent.showAlertModal("No hay elementos seleccionados");

		}

		function goToDeleteItems(){

			var deleteItemsIds = getSelectedItemsIds();

			if(deleteItemsIds.length > 0)
				goToUrl("item_delete.cfm?area=#area_id#&itemTypeId=#itemTypeId#&items="+deleteItemsIds);
			else
				parent.showAlertModal("No hay elementos seleccionados");

		}

	</script>
</cfoutput>

<div class="row">

	<div class="col-sm-12" id="actionItemsHelpText">
		<small class="help-block">Selecciona elementos de la lista para visualizar las acciones disponibles sobre varios archivos a la vez</small>
	</div>

	<nav class="navbar-default" id="actionItemsNavBar" style="display:none">
		<div class="container">
			<div class="row">
				<div class="col-sm-12">

					<div class="btn-toolbar">

						<cfif itemTypeId IS NOT 1>
							<div class="btn-group">
								<button class="btn btn-default btn-sm navbar-btn" onclick="goToChangeUser()"><i class="fa icon-user" aria-hidden="true"></i> <span lang="es">Cambiar propietario</span></button>
							</div>
						</cfif>

						<div class="btn-group">
							<button class="btn btn-danger btn-sm navbar-btn" onclick="goToDeleteItems()"><i class="fa fa-trash-o" aria-hidden="true"></i> <span lang="es">Eliminar</span></button>
						</div>

					</div>

				</div>
			</div>
		</div>
	</nav>

</div>

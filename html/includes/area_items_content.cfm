<cfoutput>
<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">


<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAreaItemsList" returnvariable="getAreaItemsListResponse">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="area_type" value="#area_type#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>

<cfset areaItems = getAreaItemsListResponse.areaItems>

<cfset numItems = areaItems.recordCount>

<div class="row">

	<!---<cfif APPLICATION.identifier NEQ "vpnet">---><!---DP--->

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu.cfm">

	<!---
	<cfelse><!---VPNET--->

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu_vpnet.cfm">

	</cfif>--->

</div>


<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfif select_enabled IS true>

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

			var itemsIds = getSelectedFilesIds();

			if(itemsIds.length > 0)
				goToUrl("item_change_user.cfm?area=#area_id#&items="+itemsIds);
			else
				parent.showAlertModal("No hay elementos seleccionados");

		}

		function goToDeleteItems(){

			var deleteItemsIds = getSelectedItemsIds();

			if(deleteItemsIds.length > 0)
				goToUrl("file_delete.cfm?area=#area_id#&files="+deleteItemsIds);
			else
				parent.showAlertModal("No hay elementos seleccionados");

		}

	</script>

</cfif>

<div class="row">

	<div class="col-sm-12" id="actionItemsHelpText">
		<small class="help-block">Selecciona elementos de la lista para visualizar las acciones disponibles sobre varios archivos a la vez</small>
	</div>

	<nav class="navbar-default" id="actionItemsNavBar" style="display:none">
		<div class="container">
			<div class="row">
				<div class="col-sm-12">

					<div class="btn-toolbar">

						<div class="btn-group">
							<button class="btn btn-default btn-sm navbar-btn" onclick="goToChangeUser()"><i class="fa icon-user" aria-hidden="true"></i> <span lang="es">Cambiar propietario</span></button>
						</div>

						<!---<div class="btn-group">
							<button class="btn btn-danger btn-sm navbar-btn" onclick="goToDeleteFiles()"><i class="fa fa-trash-o" aria-hidden="true"></i> <span lang="es">Eliminar</span></button>
						</div>--->
					</div>

				</div>
			</div>
		</div>
	</nav>

</div>


<div class="row">
	<div class="col-sm-12">

	<cfif numItems GT 0>


		<!---
		<cfif isDefined("URL.mode") AND URL.mode EQ "list"><!--- TABLE LIST --->
		--->

			<cfif itemTypeId IS NOT 7>

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItemsList">
					<cfinvokeargument name="itemsQuery" value="#areaItems#">
					<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
					<cfinvokeargument name="return_page" value="#lCase(itemTypeNameP)#.cfm?area=#area_id#">
					<cfinvokeargument name="app_version" value="#app_version#">
					<cfinvokeargument name="select_enabled" value="true">
				</cfinvoke>

			<cfelse><!---Consultations--->

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputConsultationsList">
					<cfinvokeargument name="itemsQuery" value="#areaItems#">
					<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
					<cfinvokeargument name="return_page" value="#lCase(itemTypeNameP)#.cfm?area=#area_id#">
					<cfinvokeargument name="app_version" value="#app_version#">
				</cfinvoke>

			</cfif>


		<!---
		<cfelse><!--- FULL CONTENT --->

			<cfquery dbtype="query" name="itemsQuery">
				SELECT *, #itemTypeId# AS itemTypeId
				FROM areaItems;
			</cfquery>

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsFullList">
				<cfinvokeargument name="itemsQuery" value="#itemsQuery#">
				<cfinvokeargument name="return_path" value="#APPLICATION.htmlPath#/">
				<cfinvokeargument name="area_id" value="#area_id#"/>
			</cfinvoke>

		</cfif>
		--->


	<cfelse>

		<script>
			openUrlHtml2('empty.cfm','itemIframe');
		</script>

		<cfoutput>
		<div class="alert alert-info" role="alert" style="margin:10px;"><i class="icon-info-sign"></i> <span lang="es">No hay #lCase(itemTypeNameEsP)# en esta área.</span></div>
		</cfoutput>

	</cfif>

	</div>
</div>

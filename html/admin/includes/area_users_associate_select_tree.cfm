<cfif isDefined("URL.area") AND isNumeric(URL.area)>

	<cfset area_id = URL.area>

	<cfinclude template="#APPLICATION.htmlPath#/includes/jstree_scripts.cfm">

	<script>
		
		<cfoutput>
		var curAreaId = #area_id#;
		</cfoutput>

		function areaSelected(areaId, areaUrl, withLink)  {

			if(areaId != curAreaId){
				parent.setNewAreaId(areaId);
			} else {
				$("#areasTreeContainer").jstree("deselect_all"); 
				parent.setNewAreaId(undefined);
				parent.showAlertModal("No puede seleccionar como área de destino el área origen");
			}

		}

	</script>

	<cfinclude template="#APPLICATION.htmlPath#/includes/loading_div.cfm">

	<div class="form-inline" style="position:fixed;">

		<cfinclude template="#APPLICATION.htmlPath#/includes/tree_toolbar.cfm">

	</div>

	<cfprocessingdirective suppresswhitespace="true">
	<div id="areasTreeContainer" style="clear:both; padding-top:35px;">

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTreeAdmin">
		</cfinvoke>

	</div>
	</cfprocessingdirective>

</cfif>
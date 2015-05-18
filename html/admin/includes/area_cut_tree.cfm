<cfif isDefined("URL.area") AND isNumeric(URL.area)>

	<cfset area_id = URL.area>

	<cfinclude template="#APPLICATION.htmlPath#/includes/jstree_scripts.cfm">

	<script>
		
		<cfoutput>
		var curAreaId = #area_id#;
		</cfoutput>

		<!---function treeLoaded() { 
			
			$("#loadingContainer").hide();
			
		}--->

		function areaSelected(areaId, areaUrl, withLink)  {

			if(areaId != curAreaId){
				parent.setNewParentId(areaId);
			} else {
				$("#areasTreeContainer").jstree("deselect_all"); 
				parent.setNewParentId(undefined);
				parent.showAlertModal("No puede seleccionar como área de destino el área a mover");
			}

		}

		<!---function searchTextInTree(){
			searchInTree(document.getElementById('searchText').value);	
		}
		
		$(window).load( function() {		

			showTree(true);
			
			$("#searchText").on("keydown", function(e) { 
			
				if(e.which == 13) //Enter key
					searchTextInTree();
				
			});
		});--->

	</script>

	<cfinclude template="#APPLICATION.htmlPath#/includes/loading_div.cfm">

	<div class="form-inline" style="position:fixed;">

		<cfinclude template="#APPLICATION.htmlPath#/includes/tree_toolbar.cfm">

	</div>

	<cfprocessingdirective suppresswhitespace="true">
	<div id="areasTreeContainer" style="clear:both; padding-top:35px;">

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTreeAdmin">
			<!---<cfinvokeargument name="with_input_type" value="checkbox">
			<cfif objectArea.type EQ "">
				<cfinvokeargument name="disable_input_web" value="true"><!---Esto es para que no se puedan copiar áreas no web a las áreas WEB--->
			<cfelse>
				<cfinvokeargument name="disable_input_area" value="true"><!---Esto es para que no se puedan copiar áreas WEB a las áreas no WEB--->
			</cfif>--->
		</cfinvoke>

	</div>
	</cfprocessingdirective>

</cfif>
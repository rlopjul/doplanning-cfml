<cfif isDefined("URL.area") AND isNumeric(URL.area)>

	<cfset area_id = URL.area>

	<cfoutput>
	<link href="#APPLICATION.path#/jquery/jstree/themes/dp/style.min.css" rel="stylesheet" />

	<script src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js?v=3"></script>

	<script src="#APPLICATION.htmlPath#/scripts/tree.min.js?v=3.1"></script>

	<script src="#APPLICATION.htmlPath#/language/main_en.js" charset="utf-8"></script>
	</cfoutput>

	<script type="text/javascript">
		
		<cfoutput>
		var curAreaId = #area_id#;
		</cfoutput>

		function treeLoaded() { 
			
			$("#loadingContainer").hide();
			
		}

		function areaSelected(areaId, areaUrl, withLink)  {

			if(areaId != curAreaId){
				parent.setNewParentId(areaId);
			} else {
				$("#areasTreeContainer").jstree("deselect_all"); 
				parent.setNewParentId(undefined);
				parent.showAlertModal("No puede seleccionar como área de destino el área a mover");
			}

		}

		function searchTextInTree(){
			searchInTree(document.getElementById('searchText').value);	
		}
		
		$(window).load( function() {		

			showTree(true);
			
			$("#searchText").on("keydown", function(e) { 
			
				if(e.which == 13) //Enter key
					searchTextInTree();
				
			});
		});

	</script>

	<cfinclude template="#APPLICATION.htmlPath#/includes/loading_div.cfm">

	<div class="form-inline" style="position:fixed;">

		<div class="btn-group">
			<div class="input-group input-group-sm" style="width:260px;" >
				<input type="text" name="text" id="searchText" value="" class="form-control" placeholder="Búsqueda de área"/>
				<span class="input-group-btn">
					<button onClick="searchTextInTree()" class="btn btn-default" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search"></i> <span lang="es">Buscar</span></button>
				</span>
			</div>
		</div>

		<div class="btn-group btn-group-sm">
			<a onClick="expandTree();" class="btn btn-default" title="Expandir todo el árbol" lang="es"><i class="icon-plus"></i> <span lang="es">Expandir</span></a>
			<a onClick="collapseTree();" class="btn btn-default" title="Colapsar todo el árbol" lang="es"><i class="icon-minus"></i> <span lang="es">Colapsar</span></a>
		</div>

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
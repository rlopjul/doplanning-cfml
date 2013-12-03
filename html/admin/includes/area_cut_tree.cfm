<cfif isDefined("URL.area") AND isNumeric(URL.area)>

	<cfset area_id = URL.area>

	<cfoutput>
	<script type="text/javascript" src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js"></script>

	<script type="text/javascript">
		var applicationId = "#APPLICATION.identifier#";
	</script>
	<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/tree.min.js?v=2.3"></script>

	<script src="#APPLICATION.htmlPath#/language/main_en.js" charset="utf-8" type="text/javascript"></script>
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
				alert("No puede seleccionar como área de destino el área a mover");
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

	<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>--->

	<div class="form-inline" style="margin-top:2px;">

		<div class="input-group">
			<input type="text" name="text" id="searchText" value="" class="input-medium" />
			<button onClick="searchTextInTree()" class="btn btn-default" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search"></i> <span lang="es">Buscar</span></button>
		</div>

		<a onClick="expandTree();" class="btn btn-default" title="Expandir todo el árbol" lang="es"><i class="icon-plus"></i> <span lang="es">Expandir</span></a>
		<a onClick="collapseTree();" class="btn btn-default" title="Colapsar todo el árbol" lang="es"><i class="icon-minus"></i> <span lang="es">Colapsar</span></a>

	</div>

	<cfprocessingdirective suppresswhitespace="true">
	<div id="areasTreeContainer" style="clear:both">

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
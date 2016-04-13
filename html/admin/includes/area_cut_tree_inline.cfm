
<!---<cfinclude template="#APPLICATION.htmlPath#/includes/jstree_scripts.cfm">--->

<script>

	function cutAreaTreeLoaded() {

		//$("#loadingContainer").hide();

	}

	function searchTextInCutAreaTree(){
		searchInCutAreaTree(document.getElementById('searchInCutAreaText').value);
	}

	/*$(window).load( function() {

		showTree(true);

		$("#searchText").on("keydown", function(e) {

			if(e.which == 13) //Enter key
				searchTextInTree();

		});

	});*/

	function showCutAreaTree(selectable) {

		$("#cutAreaTreeContainer").bind("ready.jstree", function (event, data) { /*loaded es el que hay que usar cuando NO se carga todo el árbol*/
			cutAreaJsTreeLoaded(event, data);
		})
		.bind("search.jstree", function (e, data) {
		   if (data.res.length == 0){
		   		showAlertMessage("No hay resultados",0);
		   }else{
		   		showAlertMessage(data.res.length+" "+window.lang.translate("resultados"),1);
		   }
		})
		.jstree({
			"core" : {
				"themes" : {
					"name" : "dp",
					"dots" : false,
					"responsive" : false
				},
				"multiple" : false

			},
			"search" : {
				"fuzzy" : false
			},
			"plugins" : [ "search" ] /*"types", "state" */


	  	});

	}

	var searchInCutAreaTreeTimeOut = false;

	function searchInCutAreaTree(text) {

		if(searchInCutAreaTreeTimeOut) { clearTimeout(searchInCutAreaTreeTimeOut); }

	    searchInCutAreaTreeTimeOut = setTimeout(function () {
	    	$('#cutAreaTreeContainer').jstree(true).search(text);
	    }, 250);
	}

	function expandCutAreaTree() {

		$('#cutAreaTreeContainer').jstree('open_all');

	}

	function collapseCutAreaTree() {

		$('#cutAreaTreeContainer').jstree('close_all');

	}

	function expandCutAreaTreeNode() {

		$("#cutAreaTreeContainer").jstree("open_all", $("#cutAreaTreeContainer").jstree('get_selected') );

	}

	function collapseCutAreaTreeNode() {

		$("#cutAreaTreeContainer").jstree("close_all", $("#cutAreaTreeContainer").jstree('get_selected') );

	}

	function cutAreaJsTreeLoaded(event, data) { //JStree loaded

		$("#cutAreaTreeContainer").bind("select_node.jstree", function (e, data) {
		   	var node = data.node;
		   	cutAreaSelected(node.id, node.a_attr.href, node.li_attr.link=="1");
		});


		cutAreaTreeLoaded();
	}

</script>

<script>


	function cutAreaSelected(areaId, areaUrl, withLink)  {

		<cfoutput>
		var currentAreaId = #area_id#;
		</cfoutput>

		if(areaId != currentAreaId){
			setNewParentId(areaId);
		} else {
			$("#cutAreaTreeContainer").jstree("deselect_all");
			setNewParentId(undefined);
			showAlertModal("No puede seleccionar como área de destino el área a mover");
		}

	}

</script>

<!---<cfinclude template="#APPLICATION.htmlPath#/includes/loading_div.cfm">--->

<div class="form-inline">

	<!---<cfinclude template="#APPLICATION.htmlPath#/includes/tree_toolbar.cfm">--->

	<div class="btn-toolbar" style="background-color:#FFFFFF;">

		<div class="btn-group">
			<div class="input-group input-group-sm" style="width:260px;" >
				<input type="text" name="text" id="searchInCutAreaText" value="" class="form-control" placeholder="Búsqueda de área" lang="es"/>
				<span class="input-group-btn">
					<button onClick="searchTextInCutAreaTree()" class="btn btn-default" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search"></i> <span lang="es">Buscar</span></button>
				</span>
			</div>
		</div>

		<div class="btn-group btn-group-sm">
			<a onClick="expandCutAreaTree();" class="btn btn-default" title="Expandir todo el árbol" lang="es"><i class="icon-plus"></i> <span lang="es">Expandir</span></a>
			<a onClick="collapseCutAreaTree();" class="btn btn-default" title="Colapsar todo el árbol" lang="es"><i class="icon-minus"></i> <span lang="es">Colapsar</span></a>
		</div>

	</div>

</div>

<cfprocessingdirective suppresswhitespace="true">
<div id="cutAreaTreeContainer" style="clear:both; height:350px; overflow-y:auto">

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


<script>
	showCutAreaTree(true);

	$("#searchInCutAreaText").on("keydown", function(e) {

		if(e.which == 13) //Enter key
			searchTextInCutAreaTree();

	});
</script>

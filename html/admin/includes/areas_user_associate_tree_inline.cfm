
<!---<cfinclude template="#APPLICATION.htmlPath#/includes/jstree_scripts.cfm">--->

<script>

	function associateUserTreeLoaded() {

		//$("#loadingContainer").hide();

	}

	function searchTextInAssociateUserTree(){
		searchInAssociateUserTree(document.getElementById('searchInAssociateUserText').value);
	}

	/*$(window).load( function() {

		showTree(true);

		$("#searchText").on("keydown", function(e) {

			if(e.which == 13) //Enter key
				searchTextInTree();

		});

	});*/

	function showAssociateUserTree(selectable) {

		$("#associateUserTreeContainer").bind("ready.jstree", function (event, data) { /*loaded es el que hay que usar cuando NO se carga todo el árbol*/
			associateUserJsTreeLoaded(event, data);
		})
		.bind("search.jstree", function (e, data) {
		   if (data.res.length == 0){
		   		showAlertMessage(window.lang.translate("No hay resultados"),0);
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

	var searchInAssociateUserTreeTimeOut = false;

	function searchInAssociateUserTree(text) {

		if(searchInAssociateUserTreeTimeOut) { clearTimeout(searchInAssociateUserTreeTimeOut); }

	    searchInAssociateUserTreeTimeOut = setTimeout(function () {
	    	$('#associateUserTreeContainer').jstree(true).search(text);
	    }, 250);
	}

	function expandAssociateUserTree() {

		$('#associateUserTreeContainer').jstree('open_all');

	}

	function collapseAssociateUserTree() {

		$('#associateUserTreeContainer').jstree('close_all');

	}

	function expandAssociateUserTreeNode() {

		$("#associateUserTreeContainer").jstree("open_all", $("#associateUserTreeContainer").jstree('get_selected') );

	}

	function collapseAssociateUserTreeNode() {

		$("#associateUserTreeContainer").jstree("close_all", $("#associateUserTreeContainer").jstree('get_selected') );

	}

	function associateUserJsTreeLoaded(event, data) { //JStree loaded

		$("#associateUserTreeContainer").bind("select_node.jstree", function (e, data) {
		   	var node = data.node;
		   	associateUserSelected(node.id, node.a_attr.href, node.li_attr.link=="1");
		});


		associateUserTreeLoaded();
	}



</script>

<script>


	function associateUserSelected(areaId, areaUrl, withLink)  {

		<!---
		<cfoutput>
		var currentAreaId = #area_id#;
		</cfoutput>

		if(areaId != currentAreaId){
			setNewParentId(areaId);
		} else {
			$("#associateUserTreeContainer").jstree("deselect_all");
			setNewParentId(undefined);
			showAlertModal("No puede seleccionar como área de destino el área a mover");
		}--->

		var checkBoxId = "#area"+areaId;
		if($(checkBoxId).attr('disabled')!='disabled')
			toggleCheckboxChecked(checkBoxId);

	}

</script>

<!---<cfinclude template="#APPLICATION.htmlPath#/includes/loading_div.cfm">--->

<div class="form-inline"><!---position:fixed;z-index:2;--->

	<!---<cfinclude template="#APPLICATION.htmlPath#/includes/tree_toolbar.cfm">--->

	<div class="btn-toolbar" style="background-color:#FFFFFF;">

		<div class="btn-group">
			<div class="input-group input-group-sm" style="width:260px;" >
				<input type="text" name="text" id="searchInAssociateUserText" value="" class="form-control" placeholder="Búsqueda de área" lang="es"/>
				<span class="input-group-btn">
					<button onClick="searchTextInAssociateUserTree()" class="btn btn-default" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search"></i> <span lang="es">Buscar</span></button>
				</span>
			</div>
		</div>

		<div class="btn-group btn-group-sm">
			<a onClick="expandAssociateUserTree();" class="btn btn-default" title="Expandir todo el árbol" lang="es"><i class="icon-plus"></i> <span lang="es">Expandir</span></a>
			<a onClick="collapseAssociateUserTree();" class="btn btn-default" title="Colapsar todo el árbol" lang="es"><i class="icon-minus"></i> <span lang="es">Colapsar</span></a>
		</div>

	</div>

</div>

<form id="associateAreasForm" method="post">
	<cfoutput>
	<input type="hidden" name="user_id" value="#objectUser.id#"/>
	<!---<input type="hidden" name="area_id" value="#objectArea.id#"/>--->
	</cfoutput>

	<cfprocessingdirective suppresswhitespace="true">
	<div id="associateUserTreeContainer" style="clear:both; height:350px; overflow-y:auto"><!---padding-top:35px; --->

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTreeAdmin">
			<cfinvokeargument name="with_input_type" value="checkbox">
			<!---<cfif objectArea.type EQ "">
				<cfinvokeargument name="disable_input_web" value="true"><!---Esto es para que no se puedan copiar áreas no web a las áreas WEB--->
			<cfelse>
				<cfinvokeargument name="disable_input_area" value="true"><!---Esto es para que no se puedan copiar áreas WEB a las áreas no WEB--->
			</cfif>--->
		</cfinvoke>

	</div>
	</cfprocessingdirective>

</form>


<script>
	showAssociateUserTree(true);

	$("#searchInAssociateUserText").on("keydown", function(e) {

		if(e.which == 13) //Enter key
			searchTextInAssociateUserTree();

	});


	<!--- Hack para posibilitar la selección de los checkboxs en el árbol al hacer click sobre ellos --->

	$("#associateUserTreeContainer").on('click', 'input:checkbox', function(event) {
		var inputId = "#"+this.id;
		setTimeout(function(){
	       $(inputId).prop("checked",!($(inputId).is(":checked")));
	    }, 100);
	});
</script>

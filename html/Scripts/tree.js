//Variable requerida: applicationPath (YA NO SE USA)

function showTree(selectable) { /*, areaId*/

	$("#areasTreeContainer").bind("loaded.jstree", function (event, data) {
		treeLoaded(event, data);
	})
	.jstree({ 
		"themes" : {
			"theme" : "dp",
			"dots" : false,
			"icons" : true,
			/*Deshabilitadas las URLs porque no funcionan desde accesos externos como el del SAS que tienen reescritura de direcciones. Desde páginas normales no funcionan si no son absolutas.*/
			/*"url" : applicationPath+"/jquery/jstree/themes/dp/style2.min.css"*/
		},
		"types" : {
			"valid_children" : [ "all" ],
			"types" : {
				"allowed" : {
					/*"icon" : { 
						"image" : applicationPath+"/html/assets/icons_"+applicationId+"/area_small.png"
					},*/
					"max_children"	: -1,
					"max_depth"		: -1,
					"valid_children": "all",
					"hover_node" : selectable,
					"select_node" : selectable
			
				},
				"allowed-web" : {
					/*"icon" : { 
						"image" : applicationPath+"/html/assets/icons_"+applicationId+"/area_web_small.png" 
					},*/
					"max_children"	: -1,
					"max_depth"		: -1,
					"valid_children": "all",
					"hover_node" : selectable,
					"select_node" : selectable
			
				},
				"not-allowed" : {
					/*"icon" : { 
						"image" : applicationPath+"/html/assets/icons_"+applicationId+"/area_small_disabled.png" 
					},*/
					"max_children"	: -1,
					"max_depth" 	: -1,
					"valid_children" : "all",
					"hover_node" : selectable,
					"select_node" : selectable
				},
				"not-allowed-web" : {
					/*"icon" : { 
						"image" : applicationPath+"/html/assets/icons_"+applicationId+"/area_web_small_disabled.png" 
					},*/
					"max_children"	: -1,
					"max_depth" 	: -1,
					"valid_children" : "all",
					"hover_node" : selectable,
					"select_node" : selectable
				}
				
			}
		},
		"plugins" : [ "themes", "html_data", "types", "ui", "search", "crrm"]
	});
	
	/*$("##areasTreeContainer").delegate("a","click", function(e) { 
		//$("##areasTreeContainer").jstree("toggle_node", this);
		//window.parent.changeIframeUrl(this.href);
	}); */
	
}

function searchInTree(text) {	
	$('#areasTreeContainer').jstree("search", text);
	
	 /*$("#demo").jstree("search", document.getElementById("text").value);*/

}

function expandTree() {
	
	$('#areasTreeContainer').jstree('open_all');
	
}

function collapseTree() {
	
	$('#areasTreeContainer').jstree('close_all');
	
}

function expandNode() {
	
	$("#areasTreeContainer").jstree("open_all", $("#areasTreeContainer").jstree('get_selected') );	
	
}

function collapseNode() {
	
	$("#areasTreeContainer").jstree("close_all", $("#areasTreeContainer").jstree('get_selected') );	
	
}


function treeLoaded(event, data) { //JStree loaded
	
	$("#areasTreeContainer").bind("select_node.jstree", function (e, data) {
	   var $obj = data.rslt.obj; // this will be a jquery object representing the <li> you've clicked
	   areaSelected($obj.attr("id"),$obj.children("a").attr("href"),$obj.attr("with_link")=="true");
	});
	
	if ( !isNaN(selectAreaId) ) { //Hay área para cargar

		selectTreeNode(selectAreaId);
		
	}else if( isNaN(selectAreaId) ) { //No hay area para cargar
	
		//$("#areaIframe").attr('src', applicationPath+"/html/iframes/area.cfm");
		$("#areaIframe").attr('src', "iframes/area.cfm");
		
	}

	$("#loadingContainer").hide();
	$("#treeContainer").css('visibility', 'visible');

	if($("#mainContainer").is(":hidden"))
		$("#mainContainer").show();
}
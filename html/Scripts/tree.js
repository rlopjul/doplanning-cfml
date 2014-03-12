
function showTree(selectable) { 

	$("#areasTreeContainer").bind("loaded.jstree", function (event, data) {
		jsTreeLoaded(event, data);
	})
	.jstree({ 
		"core" : {
			"themes" : { 
				"name" : "dp", 
				"dots" : false,
				"responsive" : false
			}
		},
		"search" : { 
			"fuzzy" : false 
		},
		"types" : {
			"valid_children" : [ "all" ],
			"types" : {
				"allowed" : {
					"max_children"	: -1,
					"max_depth"		: -1,
					"valid_children": -1,
					"hover_node" : selectable,
					"select_node" : selectable
			
				},
				"allowed-web" : {
					"max_children"	: -1,
					"max_depth"		: -1,
					"valid_children": -1,
					"hover_node" : selectable,
					"select_node" : selectable
			
				},
				"not-allowed" : {
					"max_children"	: -1,
					"max_depth" 	: -1,
					"valid_children" : -1,
					"hover_node" : selectable,
					"select_node" : selectable
				},
				"not-allowed-web" : {
					"max_children"	: -1,
					"max_depth" 	: -1,
					"valid_children" : -1,
					"hover_node" : selectable,
					"select_node" : selectable
				}
				
			}
		},
		"plugins" : [ "types", "search" ]
  	});
		
}

var searchTimeOut = false; 

function searchInTree(text) {	
	//$('#areasTreeContainer').jstree("search", text);

	if(searchTimeOut) { clearTimeout(searchTimeOut); }

    searchTimeOut = setTimeout(function () {
    	$('#areasTreeContainer').jstree(true).search(text);
    }, 250);
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

function jsTreeLoaded(event, data) { //JStree loaded

	$("#areasTreeContainer").on("select_node.jstree", function (e, data) {
	   	var node = data.node;
	   	areaSelected(node.id, node.a_attr.href, node.li_attr.with_link=="true");
	});
	
	treeLoaded();
}
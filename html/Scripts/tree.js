
function showTree(selectable) { 

	$("#areasTreeContainer").bind("ready.jstree", function (event, data) { /*loaded es el que hay que usar cuando NO se carga todo el árbol*/
		jsTreeLoaded(event, data);
	})
	.jstree({ 
		"core" : {
			"themes" : { 
				"name" : "dp", 
				"dots" : false,
				"responsive" : false
			},
			"multiple" : false
			/*, "data" : {
		    	"url" : "/html/html_content/tree.cfm",
		    	"data" : function (node) {
			      return { "id" : node.id };
		    	}
		    }*/
		},
		"search" : { 
			"fuzzy" : false 
		},
		/*"types" : {
			"allowed" : {},
			"allowed-web" : {},
			"not-allowed" : {},
			"not-allowed-web" : {}	
		},*/

		"plugins" : [ "search" ] /*"types", */
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

	$("#areasTreeContainer").bind("select_node.jstree", function (e, data) {
	   	var node = data.node;
	   	//areaSelected(node.id, node.a_attr.href, node.li_attr.with_link=="true");
	   	areaSelected(node.id, node.a_attr.href, node.li_attr.link=="1");
	});
	
	treeLoaded();
}
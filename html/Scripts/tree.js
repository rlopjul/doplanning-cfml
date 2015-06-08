var areasNamesArray = [];

function showTree(selectable) { 

	/********************************** Typeahead **********************************/

	/*$('#areasTreeContainer ul li a').each(function(){
	    areasNamesArray.push( $.trim( $(this).text() ) );
	});*/

	//console.log(areasNamesArray);

	/********************************** END Typeahead **********************************/


	$("#areasTreeContainer").bind("ready.jstree", function (event, data) { /*loaded es el que hay que usar cuando NO se carga todo el árbol*/
		jsTreeLoaded(event, data);
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
		},
		Plugin state da problemas en MAC porque se guarda la selección de área
		"state" : { 
			"key" : "main_tree",
			"events" : "open_node.jstree close_node.jstree"
		},*/

		"plugins" : [ "search" ] /*"types", "state" */


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


	/********************************** Typeahead **********************************/

	/*
		DESHABILITADO HASTA PODER PROBARLO BIEN

	var substringMatcher = function(strs) {
	  return function findMatches(q, cb) {
	    var matches, substrRegex;
	 
	    // an array that will be populated with substring matches
	    matches = [];
	 
	    // regex used to determine if a string contains the substring `q`
	    substrRegex = new RegExp(q, 'i');
	 
	    // iterate through the pool of strings and for any string that
	    // contains the substring `q`, add it to the `matches` array
	    $.each(strs, function(i, str) {
	      if (substrRegex.test(str)) {
	        // the typeahead jQuery plugin expects suggestions to a
	        // JavaScript object, refer to typeahead docs for more info
	        matches.push({ value: str });
	      }
	    });
	 
	    cb(matches);
	  };
	};
	 
	 
	// constructs the suggestion engine
	var areasNamesArray2 = new Bloodhound({
	  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
	  queryTokenizer: Bloodhound.tokenizers.whitespace,
	  // `areasNamesArray` is an array of state names defined in "The Basics"
	  local: $.map(areasNamesArray, function(state) { return { value: state }; })
	});
	 
	// kicks off the loading/processing of `local` and `prefetch`
	areasNamesArray2.initialize();
	 
	$('#searchText').typeahead({
	  hint: true,
	  highlight: true,
	  minLength: 1
	},
	{
	  name: 'areasNamesArray2',
	  displayKey: 'value',
	  // `ttAdapter` wraps the suggestion engine in an adapter that
	  // is compatible with the typeahead jQuery plugin
	  source: areasNamesArray2.ttAdapter()
	});

	*/

	/*********************************** END Typeahead ***********************************/

	
	treeLoaded();
}
//Variable requerida: appplicationPath

function showTree(selectable, areaId) {

	$("#areasTreeContainer").bind("loaded.jstree", function (event, data) {
		treeLoaded(event, data);
	})
	.jstree({ 
		"themes" : {
			"theme" : "dp",
			"dots" : false,
			"icons" : true,
			"url" : applicationPath+"/jquery/jstree/themes/dp/style.css"
		},
		"types" : {
			"valid_children" : [ "all" ],
			"types" : {
				"allowed" : {
					"icon" : { 
						"image" : applicationPath+"/html/assets/icons_"+applicationId+"/area_small.png" 
					},
					"max_children"	: -1,
					"max_depth"		: -1,
					"valid_children": "all",
					"hover_node" : selectable,
					"select_node" : selectable
			
				},
				"allowed-web" : {
					"icon" : { 
						"image" : applicationPath+"/html/assets/icons_"+applicationId+"/area_web_small.png" 
					},
					"max_children"	: -1,
					"max_depth"		: -1,
					"valid_children": "all",
					"hover_node" : selectable,
					"select_node" : selectable
			
				},
				"not-allowed" : {
					"icon" : { 
						"image" : applicationPath+"/html/assets/icons_"+applicationId+"/area_small_disabled.png" 
					},
					"max_children"	: -1,
					"max_depth" 	: -1,
					"valid_children" : "all",
					"hover_node" : selectable,
					"select_node" : selectable
				},
				"not-allowed-web" : {
					"icon" : { 
						"image" : applicationPath+"/html/assets/icons_"+applicationId+"/area_web_small_disabled.png" 
					},
					"max_children"	: -1,
					"max_depth" 	: -1,
					"valid_children" : "all",
					"hover_node" : selectable,
					"select_node" : selectable
				}
				
			}
		},
		"plugins" : [ "themes", "html_data", "types", "ui"]
	});
	
	/*$("##areasTreeContainer").delegate("a","click", function(e) { 
		//$("##areasTreeContainer").jstree("toggle_node", this);
		//window.parent.changeIframeUrl(this.href);
		//alert("clickA");
	}); */
	
}
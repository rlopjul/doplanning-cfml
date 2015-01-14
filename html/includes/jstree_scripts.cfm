<cfoutput>
<link href="#APPLICATION.path#/jquery/jstree/themes/dp/style.min.css" rel="stylesheet" />

<script src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js?v=3.2"></script>

<script src="#APPLICATION.htmlPath#/scripts/tree.min.js?v=3.2"></script>

<script src="#APPLICATION.htmlPath#/language/main_en.js" charset="utf-8"></script>
</cfoutput>

<script>
	
	function treeLoaded() { 
		
		$("#loadingContainer").hide();
		
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
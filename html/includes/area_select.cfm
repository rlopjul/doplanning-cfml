<cfoutput>
<script type="text/javascript" src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js"></script>

<script type="text/javascript">
	var applicationId = "#APPLICATION.identifier#";
</script>
<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/tree.min.js?v=2.3"></script>

<script src="#APPLICATION.htmlPath#/language/main_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<script type="text/javascript">
	
	function treeLoaded() { 
		
		$("#loadingContainer").hide();
		
	}

	function areaSelected(areaId, areaUrl, withLink)  {

		var areaName = $.trim( $("#"+areaId+" a:first").text() );

		window.opener.setSelectedArea(areaId, areaName);
		window.close();

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

<div class="form-inline" style="margin-top:2px;">

	<div class="input-append">
		<input type="text" name="text" id="searchText" value="" class="input-medium" />
		<button onClick="searchTextInTree()" class="btn" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search"></i> <span lang="es">Buscar</span></button>
	</div>

	<a onClick="expandTree();" class="btn" title="Expandir todo el árbol" lang="es"><i class="icon-plus"></i> <span lang="es">Expandir</span></a>
	<a onClick="collapseTree();" class="btn" title="Colapsar todo el árbol" lang="es"><i class="icon-minus"></i> <span lang="es">Colapsar</span></a>

</div>

<cfprocessingdirective suppresswhitespace="true">
<div id="areasTreeContainer" style="clear:both">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTree">
	</cfinvoke>

</div>
</cfprocessingdirective>
<div style="height:2px; clear:both;"><!-- --></div>
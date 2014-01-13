<cfif isDefined("URL.all_enabled") AND URL.all_enabled IS true>
	<cfset allEnabled = true>
<cfelse>
	<cfset allEnabled = false>
</cfif>
<cfif isDefined("URL.web_enabled") AND URL.web_enabled IS NOT true>
	<cfset webEnabled = false>
<cfelse>
	<cfset webEnabled = true>
</cfif>
<cfif isDefined("URL.no_web_enabled") AND URL.no_web_enabled IS NOT true>
	<cfset noWebEnabled = false>
<cfelse>
	<cfset noWebEnabled = true>
</cfif>

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
		var allEnabled = #allEnabled#;
		var webEnabled = #webEnabled#;
		var noWebEnabled = #noWebEnabled#;
	</cfoutput>
	
	function treeLoaded() { 
		
		$("#loadingContainer").hide();
		
	}

	function areaSelected(areaId, areaUrl, withLink)  {

		var areaNode = $("#"+areaId);

		var relAtt = (areaNode).attr("rel");

		if( allEnabled == false) {

			if( relAtt == "not-allowed" || relAtt == "not-allowed-web" ){

				alert("No tiene permiso de acceso en esta área");
				return;

			} else if( (webEnabled == false && relAtt == "allowed-web") || (noWebEnabled == false && relAtt == "allowed") ) {

				alert("No puede seleccionar este tipo de área");
				return;
			}

		}

		//var areaName = $.trim( $("#"+areaId+" a:first").text() );
		var areaName = $.trim( $(areaNode).find("a:first").text() );

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

	<!---<div class="input-group">
		<input type="text" name="text" id="searchText" value="" class="input-medium" />
		<button onClick="searchTextInTree()" class="btn btn-default" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search"></i> <span lang="es">Buscar</span></button>
	</div>--->
	<div class="btn-toolbar">
								
		<div class="btn-group">
			<div class="input-group" style="width:260px;" >
				<input type="text" name="text" id="searchText" value="" class="form-control"/>
				<span class="input-group-btn">
					<button onClick="searchTextInTree()" class="btn btn-default" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search"></i> <span lang="es">Buscar</span></button>
				</span>
			</div>
		</div>

		<div class="btn-group">
			<a onClick="expandTree();" class="btn btn-default" title="Expandir todo el árbol" lang="es"><i class="icon-plus"></i> <span lang="es">Expandir</span></a>
			<a onClick="collapseTree();" class="btn btn-default" title="Colapsar todo el árbol" lang="es"><i class="icon-minus"></i> <span lang="es">Colapsar</span></a>
		</div>

	</div>

</div>

<cfprocessingdirective suppresswhitespace="true">
<div id="areasTreeContainer" style="clear:both">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTree">
	</cfinvoke>

</div>
</cfprocessingdirective>
<div style="height:2px; clear:both;"><!-- --></div>
<cfoutput>
<link href="#APPLICATION.path#/jquery/jstree/themes/dp/style.min.css?v=3.2" rel="stylesheet" />

<script src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js?v=3.1.1"></script>

<script src="#APPLICATION.path#/jquery/typeahead/typeahead.bundle.min.js" charset="utf-8"></script>

<script src="#APPLICATION.htmlPath#/scripts/tree.min.js?v=3.1.3"></script>
</cfoutput>

<script>

	<!---function showAlertMessage(msg, res){

		if($("#alertContainer span").length != 0)
			$("#alertContainer span").remove();

		if(res == true)
			$("#alertContainer").attr("class", "alert alert-success");
		else
			$("#alertContainer").attr("class", "alert alert-danger");

		$("#alertContainer button").after('<span>'+msg+'</span>');

		var maxZIndex = getMaxZIndex();

	    $("#alertContainer").css('zIndex',maxZIndex+1);

		$("#alertContainer").fadeIn('slow');


		setTimeout(function(){

		    hideAlertMessage();

		    }, 9500);
	}

	function hideAlertMessage(){

		$("#alertContainer").fadeOut('slow', function() {
		    $("#alertContainer span").remove();
		});

	}--->

	function treeLoaded() {

		<!---$("#loadingContainer").hide();

		$("#treeContainer").css('visibility', 'visible');

		if($("#mainContainer").is(":hidden"))
			$("#mainContainer").show();--->
	}

	function areaSelected(areaId, areaUrl, withLink)  {

		<!---curAreaId = areaId;--->

		$('#openNewTab').is(':checked')
		goToUrl(areaUrl);

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

	<!---$(document).ready(function () {

		// Alert
		$('#alertContainer .close').click(function(e) {

			hideAlertMessage();

		});

	});--->

</script>

<!--- Alert --->
<!---<cfinclude template="#APPLICATION.htmlPath#/includes/main_alert.cfm">--->

<!--- Tree --->

	<div class="row">

		<div class="col-sm-offset-1 col-sm-7">

			<div class="btn-toolbar">
				<div class="btn-group">
					<div class="input-group">
						<input type="text" name="text" id="searchText" value="" class="form-control typeahead" placeholder="Búsqueda de área" lang="es" style="box-shadow:inset 0 -1px 0 #ADCEE1"/>
						<span class="input-group-btn">
							<button onClick="searchTextInTree()" class="btn btn-link" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search" style="font-size:24px;color:#99B3C7"></i></button>
						</span>
					</div>
				</div>
			</div>

		</div>

		<div class="col-sm-4 col-lg-offset-1 col-lg-3">

			<div class="btn-toolbar">

				<div class="btn-group">
					<a onClick="expandTree();" class="btn btn-default" title="Expandir todo el árbol" lang="es"><i class="icon-plus"></i> <span lang="es">Expandir</span></a>
					<a onClick="collapseTree();" class="btn btn-default" title="Colapsar todo el árbol" lang="es"><i class="icon-minus"></i> <span lang="es">Colapsar</span></a>
				</div>
				<!---<div class="btn-group">
					<a onClick="updateTree();" class="btn btn-default" title="Actualizar" lang="es"><i class="icon-refresh"></i> <span lang="es">Actualizar</span></a>
				</div>---->
				<!---<a onclick="expandTree();" class="btn btn-xs" title="Abrir nodos del árbol"><i class="icon-plus"></i> Expandir</a>
				<a onclick="collapseTree();" class="btn btn-xs" title="Abrir nodos del árbol"><i class="icon-minus"></i> Colapsar</a>--->

			</div>

		</div>

		<input type="hidden" id="changeTabDisabled" value="true"/><!---No cambiar de pestaña al seleccionar área--->


		<!---<div class="form-inline" style="padding-bottom:5px; padding-left:5px;">
			<label class="checkbox">
				<input type="checkbox" id="openNewTab" value="true" style="width:15px;height:15px"/>&nbsp;&nbsp;<span style="font-size:15px;" lang="es">Abrir las áreas en nuevas pestañas</span>
			</label>
		</div>--->

	</div>


	<div class="row">

		<div class="col-sm-12">

			<!---treeContainer--->
			<div id="treeWrapper" style="border-style:none;margin-top:22px;">
				<!---<cfoutput>
				<div style="cursor:pointer;float:right;clear:both;">
				<img src="#APPLICATION.htmlPath#/assets/v3/icons/maximize.png" title="Maximizar Árbol" id="maximizeTree" />
				<img src="#APPLICATION.htmlPath#/assets/v3/icons/restore.png" title="Restaurar Árbol" id="restoreTree" style="display:none;"/>
				</div>
				</cfoutput>--->
				<div id="treeContainer" style="overflow:auto;overflow-y:hidden;clear:both;">
					<cfinclude template="#APPLICATION.htmlPath#/html_content/tree.cfm">
				</div>
			</div>

		</div>

	</div>

<!--- END Tree --->

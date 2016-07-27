<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_iframes_estilos.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<meta charset="utf-8"> 
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<!-- InstanceBeginEditable name="doctitle" -->
<title></title>
<!-- InstanceEndEditable -->
<cfoutput>
<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">
<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet">
<!---<!--[if lt IE 9]>
	<script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <link href="//netdna.bootstrapcdn.com/respond-proxy.html" id="respond-proxy" rel="respond-proxy" />
    <link href="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.gif" id="respond-redirect" rel="respond-redirect" />
    <script src="//oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <script src="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.js"></script>
<![endif]-->
<!--[if IE 7]>
  	<link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome-ie7.min.css" rel="stylesheet" >
<![endif]-->--->

<!--[if lt IE 9]>
	<script src="#APPLICATION.htmlPath#/scripts/html5shiv/html5shiv.js"></script>
    <script src="#APPLICATION.htmlPath#/scripts/respond/respond.min.js"></script>
<![endif]-->
<!--[if lt IE 8]>
  	<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-ie7/bootstrap-ie7.css" rel="stylesheet" rel="stylesheet">
<![endif]-->
<!--[if IE 7]>
	<link href="#APPLICATION.htmlPath#/font-awesome/css/font-awesome-ie7.min.css" rel="stylesheet">
<![endif]-->

<link href="#APPLICATION.dpCSSPath#" rel="stylesheet" type="text/css" media="all" />
<cfif len(APPLICATION.themeCSSPath) GT 0>
<link href="#APPLICATION.themeCSSPath#" rel="stylesheet">
</cfif>
<cfif APPLICATION.identifier EQ "vpnet">
<link href="../styles/styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="../styles/styles_dp.min.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<link href="../styles/styles_iframes.css" rel="stylesheet" type="text/css" media="all" />

<script src="#APPLICATION.jqueryJSPath#"></script>
<script src="#APPLICATION.bootstrapJSPath#"></script>

<!---<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang-dp.js" charset="utf-8" ></script>--->
<script src="#APPLICATION.path#/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/bootbox.js/4.4.0/bootbox.min.js"></script>
<script src="#APPLICATION.path#/jquery/jquery.html5.history.min.js" charset="utf-8"></script>
<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.min.js" charset="utf-8" ></script>

<script src="#APPLICATION.path#/jquery/typeahead/typeahead.bundle.min.js" charset="utf-8"></script>

<script src="../scripts/functions.min.js?v=2.4"></script>
<script src="../scripts/iframesFunctions.min.js?v=2.1"></script>

<script>
	//Language
	<!--- jquery_lang_js.prototype.defaultLang = 'es';
	jquery_lang_js.prototype.currentLang = 'es';
	jquery_lang_js.prototype.lang.en = [{}];
	window.lang = new jquery_lang_js();
	
	$().ready(function () {
   		window.lang.run();
	});--->
	
	<!---Lang.prototype.pack.en = {};
	Lang.prototype.pack.en.token = {};--->
	
	$().ready(function () {
		window.lang = new Lang('es');
		
		window.lang.dynamic('en', '#APPLICATION.mainUrl#/html/language/main_en.cfm');
		<cfif SESSION.user_language NEQ "es">
			window.lang.change('#SESSION.user_language#');
		</cfif>
	});
</script>

</cfoutput>
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
</head>

<body onBeforeUnload="onUnloadPage()" onLoad="onLoadPage()">
<!---divLoading--->
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_page_div.cfm">

<!-- InstanceBeginEditable name="content" -->

<!---<cfinclude template="#APPLICATION.htmlPath#/includes/jstree_scripts.cfm">

<script>

	<cfoutput>
	var curAreaId = #area_id#;
	</cfoutput>

	function areaSelected(areaId, areaUrl, withLink)  {

		if(areaId != curAreaId){
			parent.setNewParentId(areaId);
		} else {
			$("#areasTreeContainer").jstree("deselect_all");
			parent.setNewParentId(undefined);
			parent.showAlertModal("No puede seleccionar como área de destino el área a mover");
		}

	}

</script>--->

<cfif isDefined("URL.area")>

	<cfoutput>

	<link href="#APPLICATION.path#/jquery/jstree/themes/dp/style.min.css" rel="stylesheet" />
	<script src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js?v=3.2"></script>
	<script src="#APPLICATION.htmlPath#/scripts/tree.min.js?v=3.1.2"></script>
	<!---<script src="#APPLICATION.htmlPath#/language/main_en.js" charset="utf-8"></script>--->

	<script>

		var selectAreaId = #URL.area#;

		var firstSelect = true;

		function selectTreeNode(nodeId) {

			var $areasJsTree = $("##areasTreeContainer");

			$areasJsTree.jstree("deselect_all");
			if($areasJsTree.jstree("select_node", nodeId) == false) { // Es false si el área no está en el árbol y no se puede seleccionar

				alert("Área no accesible en su árbol");

			}else {

				<!---$areasJsTree.scrollTop = $("##"+selectAreaId).position().top - $areasJsTree.offsetHeight/2;
				alert($areasJsTree.scrollTop);--->

				$('html, body').animate({
				    scrollTop: $("##"+selectAreaId).offset().top-35
				}, 500
				, "swing"
				, function() {
				    // Animation complete.
				    expandNode();
				});

			}

			firstSelect = false;
		}

		function areaSelected(areaId, areaUrl, withLink)  {

			if (firstSelect == false) {
				parent.goToUrl("#APPLICATION.htmlPath#/"+areaUrl);
			}

		}

		function treeLoaded() {

			$("##loadingContainer").hide();

			selectTreeNode(selectAreaId);

		}

		function searchTextInTree(){
			searchInTree(document.getElementById('searchText').value);
		}

		$(window).load( function() {

			showTree(true);

			$("##searchText").on("keydown", function(e) {

				if(e.which == 13) //Enter key
					searchTextInTree();

			});

		});

	</script>

	</cfoutput>


	<div class="form-inline" style="position:fixed;width:100%">

		<cfinclude template="#APPLICATION.htmlPath#/includes/tree_toolbar.cfm">

	</div>

	<div class="treeContainer" style="overflow:auto">

		<cfprocessingdirective suppresswhitespace="true">
		<div id="areasTreeContainer" style="clear:both; padding-top:35px;">
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTree">
			<cfinvokeargument name="get_user_id" value="#SESSION.user_id#">
		</cfinvoke>
		</div>
		</cfprocessingdirective>

	</div>


</cfif><!--- END isDefined("URL.area") --->

<!-- InstanceEndEditable -->
</body>
<!-- InstanceEnd --></html>

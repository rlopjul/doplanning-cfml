<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">
<div class="div_head_subtitle_area">
<cfoutput>
<!---<div class="div_head_subtitle_area_text"><strong>#uCase(itemTypeNameEsP)#</strong><br/>del área</div>--->

<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->
	<div class="btn-toolbar" style="padding-right:5px;" role="toolbar">

		<div class="btn-group">
			<a href="#itemTypeName#_new.cfm?area=#area_id#" onclick="openUrl('#itemTypeName#_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm" title="<cfif itemTypeGender EQ 'male'>Nuevo<cfelse>Nueva</cfif> #itemTypeNameEs#" lang="es"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>  
				<cfif itemTypeId IS 7>
					<i class="icon-exchange" style="font-size:18px; color:##0088CC"></i>
				<cfelse>
					<img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#.png" style="height:22px;"/>
				</cfif></a>
		</div>

		<!---<span class="divider">&nbsp;</span>--->


		<!---<span class="divider">&nbsp;</span>--->
		
		<cfif app_version NEQ "mobile">
			<div class="btn-group pull-right">
				<a href="#APPLICATION.htmlPath#/#lCase(itemTypeNameP)#.cfm?area=#area_id#&mode=tree" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
			</div>
		</cfif>

		<div class="btn-group pull-right">
			<a href="#lCase(itemTypeNameP)#.cfm?area=#area_id#&mode=tree" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>
		</div>

		<div class="btn-group pull-right">
			<a href="#lCase(itemTypeNameP)#.cfm?area=#area_id#&mode=list" class="btn btn-default btn-sm"><i class="icon-th-list" style="font-size:14px; line-height:23px;"></i> <span lang="es">Modo lista</span></a>
		</div>
	
	</div>
	
<cfelse><!---VPNET--->

	<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_tree_menu_vpnet.cfm">
	
</cfif>

</cfoutput>
</div>
<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">


<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAreaItemsTree" returnvariable="getTreeResponse">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>

<cfxml variable="xmlItems">
	<cfoutput>
	#getTreeResponse.xmlItems#
	</cfoutput>
</cfxml>

<cfoutput>

<link href="#APPLICATION.path#/jquery/jstree/themes/dp/style.min.css" rel="stylesheet" />
<script src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js?v=3"></script>

<script>
	var loadTree = true;
	
	$(document).ready(function() { 
		
		if(loadTree) {
		
			$("##treeContainer").jstree({ 
				"core" : {
					"themes" : { 
						"name" : "dp", 
						"dots" : false,
						"responsive" : true
					},
					"multiple" : false
				},
				"search" : { 
					"fuzzy" : false 
				},
				"types" : {
					"message" : {
						"icon" : "#APPLICATION.htmlPath#/assets/icons/message_small.png"
					}
				},
				"plugins" : [ "types", "search" ]
				<!---,"ui" : {
					<cfif isDefined("URL.#itemTypeName#")>
					"initially_select" : [ "#URL[itemTypeName]#" ]
					<cfelseif app_version NEQ "mobile" AND isDefined("xmlItems.#itemTypeNameP#.#itemTypeName#")><!---En la versión móvil no se puede seleccionar por defecto porque cambia de pantalla--->
					"initially_select" : [ "#xmlItems['#itemTypeNameP#']['#itemTypeName#'].xmlAttributes.id#" ]
					</cfif>
				}--->
			});

			$("##treeContainer").bind("select_node.jstree", function (event, data) { 
		
				<!---var href = data.rslt.obj.children("a").attr("href");--->
				var node = data.node;
				openUrl(node.a_attr.href,'itemIframe',event);
				
		  	}); 

		  	$("##searchText").on("keydown", function(e) { 
			
				if(e.which == 13) //Enter key
					searchTextInTree();
				
			});

			<cfif isDefined("URL.#itemTypeName#")>
				$("##treeContainer").jstree("select_node", "##"+"#URL[itemTypeName]#", false); 
			<cfelseif app_version NEQ "mobile" AND isDefined("xmlItems.#itemTypeNameP#.#itemTypeName#")><!---En la versión móvil no se puede seleccionar por defecto porque cambia de pantalla--->
				$("##treeContainer").jstree("select_node", "##"+"#xmlItems['#itemTypeNameP#']['#itemTypeName#'].xmlAttributes.id#", false); 
			</cfif>
		}

		<!---<cfif isDefined("URL.#itemTypeName#")>
			$("##treeContainer").jstree("select_node", "##"+"#URL[itemTypeName]#", true); 
		</cfif>--->
		
    }); 
	
	var searchItemsTimeOut = false;
	function searchTextInTree() {	

		var text = $("##searchText").val();

		if(searchItemsTimeOut) { clearTimeout(searchItemsTimeOut); }

	    searchItemsTimeOut = setTimeout(function () {
	    	$('##treeContainer').jstree(true).search(text);
	    }, 250);
	}

	function expandTree() {

		$('##treeContainer').jstree('open_all');
		
	}

	function collapseTree() {
		
		$('##treeContainer').jstree('close_all');
		
	}
</script>
</cfoutput>


<div class="form-inline" style="margin-left:2px;margin-top:2px;margin-bottom:2px;clear:both">

	<div class="btn-toolbar">
								
		<div class="btn-group">
			<div class="input-group input-group-sm" style="width:260px;" >
				<input type="text" name="text" id="searchText" value="" class="form-control"/>
				<span class="input-group-btn">
					<button onClick="searchTextInTree()" class="btn btn-default" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search"></i> <span lang="es">Buscar</span></button>
				</span>
			</div>
		</div>

		<div class="btn-group btn-group-sm">
			<a onClick="expandTree();" class="btn btn-default" title="Expandir todo el árbol" lang="es"><i class="icon-plus"></i> <span lang="es">Expandir</span></a>
			<a onClick="collapseTree();" class="btn btn-default" title="Colapsar todo el árbol" lang="es"><i class="icon-minus"></i> <span lang="es">Colapsar</span></a>
		</div>

	</div>

</div>

<div id="treeContainer" style="clear:both">

<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItemTree" method="outputAreaItemsTree">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>--->

<!---<cfoutput>
<textarea style="width:100%">#xmlItems#</textarea>
</cfoutput>--->

<cfif isDefined("xmlItems.#itemTypeNameP#.#itemTypeName#")>
	<ul>
		
	<cfloop index="curItem" array="#xmlItems['#itemTypeNameP#']['#itemTypeName#']#">
		
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItemTree" method="outputItem">
			<cfinvokeargument name="itemXml" value="#curItem#">
			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfinvoke>
				
	</cfloop>
	</ul>
<cfelse>
	<script type="text/javascript">
		loadTree = false;
		openUrlHtml2('empty.cfm','itemIframe');
	</script>
	<cfoutput>
	<div class="div_items">
	<div class="div_text_result"><span lang="es">No hay #lCase(itemTypeNameEsP)# en esta área.</span></div>
	</div>
	</cfoutput>
</cfif>


</div>
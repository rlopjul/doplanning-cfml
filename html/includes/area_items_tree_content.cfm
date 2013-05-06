<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_items_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">
<div class="div_head_subtitle_area">
<cfoutput>
<!---<div class="div_head_subtitle_area_text"><strong>#uCase(itemTypeNameEsP)#</strong><br/>del área</div>--->

<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->
	
	<a href="#itemTypeName#_new.cfm?area=#area_id#" onclick="openUrl('#itemTypeName#_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-small btn-info"><i class="icon-plus icon-white"></i> <span lang="es"><cfif itemTypeGender EQ "male">Nuevo<cfelse>Nueva</cfif> #itemTypeNameEs#</span></a>
	
	<a href="#itemTypeNameP#.cfm?area=#area_id#&mode=list" class="btn btn-small"><i class="icon-th-list"></i> <span lang="es">Modo lista</span></a>
	
	<a href="#itemTypeNameP#.cfm?area=#area_id#&mode=tree" class="btn btn-small" title="Actualizar" lang="es"><i class="icon-refresh"></i> <span lang="es">Actualizar</span></a>	
	
	
<cfelse><!---VPNET--->

	<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_tree_menu_vpnet.cfm">
	
</cfif>

</cfoutput>
</div>
<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">


<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAreaItemsTree" returnvariable="xmlTreeResponse">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>

<cfxml variable="xmlItems">
	<cfoutput>
	#xmlTreeResponse.response.result['#itemTypeNameP#'][1]#
	</cfoutput>
</cfxml>

<cfoutput>

<script type="text/javascript" src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js"></script>

<script type="text/javascript">
	var loadTree = true;
	
	$(document).ready(function() { 
		
		if(loadTree) {
		
			$("##treeContainer").jstree({ 
				"themes" : {
					"theme" : "dp",
					"dots" : false,
					"icons" : false,
					"url" : "#APPLICATION.path#/jquery/jstree/themes/dp/style.css"
				},
				"types" : {
					"valid_children" : [ "all" ],
					"types" : {
						"message" : {
							<!---"icon" : { 
								"image" : "#APPLICATION.path#/html/assets/icons/message_small.png" 
							},--->
							"max_children"	: -1,
							"max_depth"		: -1,
							"valid_children": "all",
							"hover_node" : true,
							"select_node" : true
					
						}
						
					}
				},
				"plugins" : [ "themes", "html_data", "types", "ui"]
				,"ui" : {
					<cfif isDefined("URL.#itemTypeName#")>
					"initially_select" : [ "#URL[itemTypeName]#" ]
					<cfelseif app_version NEQ "mobile" AND isDefined("xmlItems.#itemTypeNameP#.#itemTypeName#")><!---En la versión móvil no se puede seleccionar por defecto porque cambia de pantalla--->
					"initially_select" : [ "#xmlItems['#itemTypeNameP#']['#itemTypeName#'].xmlAttributes.id#" ]
					</cfif>
				}
			});
		}
		
		<!---$("##treeContainer").delegate("a","click", function(e) { 
			//window.location.href=this.href;
			openUrl(this.href,'itemIframe',e);
		});--->

		$("##treeContainer").bind("select_node.jstree", function (event, data) { 
		
			var href = data.rslt.obj.children("a").attr("href");
			openUrl(href,'itemIframe',event);
			
	  	}); 
		
		<!---<cfif isDefined("URL.#itemTypeName#")>
			$("##treeContainer").jstree("select_node", "##"+"#URL[itemTypeName]#", true); 
		</cfif>--->
		
    }); 
</script>
</cfoutput>




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
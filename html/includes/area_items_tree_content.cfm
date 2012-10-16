<cfoutput>
<!---<link href="#APPLICATION.jqueryUICSSPath#" rel="stylesheet" type="text/css" />
<link href="#APPLICATION.path#/jquery/wijmo-complete/development-bundle/themes/rocket/jquery-wijmo.css" type="text/css" />
<link href="#APPLICATION.path#/jquery/wijmo-complete/development-bundle/themes/wijmo/jquery.wijmo.wijtree.css" type="text/css" />
<link href="#APPLICATION.path#/jquery/wijmo-complete/css/jquery.wijmo-complete.all.2.0.5.min.css" type="text/css" />
<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.jqueryUIJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/wijmo-open/js/jquery.wijmo-open.all.2.0.5.min.js"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/wijmo-complete/js/jquery.wijmo-complete.all.2.0.5.min.js"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/wijmo-complete/development-bundle/wijmo/minified/jquery.wijmo.wijtree.min.js"></script>--->
<!---<script type="text/javascript" src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.extras-0.1.22.min.js"></script>
<link href="#APPLICATION.path#/jquery/tablesorter/css/style.css" rel="stylesheet" type="text/css" media="all" />--->

<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js"></script>

<script type="text/javascript">
	var loadTree = true;
	
	$(document).ready(function() { 
		
		if(loadTree) {
		
			$("##treeContainer").jstree({ 
				"themes" : {
					"theme" : "dp",
					"dots" : false,
					"icons" : true,
					"url" : "#APPLICATION.path#/jquery/jstree/themes/dp/style.css"
				},
				"types" : {
					"valid_children" : [ "all" ],
					"types" : {
						"message" : {
							"icon" : { 
								"image" : "#APPLICATION.path#/html/assets/icons/message_small.png" 
							},
							"max_children"	: -1,
							"max_depth"		: -1,
							"valid_children": "all",
							"hover_node" : true,
							"select_node" : true
					
						}
						
					}
				},
				"plugins" : [ "themes", "html_data", "types", "ui"]
			});
		}
		
		
		$("##treeContainer").delegate("a","click", function(e) { 
			//$("##treeContainer").jstree("toggle_node", this);
			window.location.href=this.href;
		});
		
    }); 
</script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">


<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">
<div class="div_head_subtitle_area">
<cfoutput>
<div class="div_head_subtitle_area_text">#itemTypeNameEsP#<br/> del área</div>
<div class="div_element_menu">
	<div class="div_icon_menus"><a href="#itemTypeNameP#.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/refresh.png" alt="Actualizar" title="Actualizar" /></a></div>
	<div class="div_text_menus"><a href="#itemTypeNameP#.cfm?area=#area_id#"> Actualizar</a></div>
</div>
<div class="div_element_menu">
	<div class="div_icon_menus"><a href="#itemTypeName#_new.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_new.png" alt="Nuevo #itemTypeName#" title="Crear #itemTypeNameEs#" /></a></div>
	<div class="div_text_menus"><a href="#itemTypeName#_new.cfm?area=#area_id#"><cfif itemTypeGender EQ "male">Nuevo<cfelse>Nueva</cfif><br/>#itemTypeNameEs#</a></div>
</div>
<div class="div_element_menu">
	<div class="div_icon_menus"><a href="#itemTypeNameP#.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/list_mode.png" alt="Modo lista" title="Modo lista" /></a></div>
	<div class="div_text_menus"><a href="#itemTypeNameP#.cfm?area=#area_id#">Modo<br/>lista</a></div>
</div>
</cfoutput>
</div>
<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div id="treeContainer" style="clear:both">
<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItemTree" method="outputAreaItemsTree">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>
</div>

</div>
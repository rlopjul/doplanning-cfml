<cfoutput>
<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.extras-0.1.22.min.js"></script>
<link href="#APPLICATION.path#/jquery/tablesorter/css/style.css" rel="stylesheet" type="text/css" media="all" />
</cfoutput>


<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">


<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">
<div class="div_head_subtitle_area">
<cfoutput>
<div class="div_head_subtitle_area_text"><strong>#uCase(itemTypeNameEsP)#</strong><br/> del área</div>
<div class="div_element_menu">
	<div class="div_icon_menus"><a href="#itemTypeNameP#.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/refresh.png" alt="Actualizar" title="Actualizar" /></a></div>
	<div class="div_text_menus"><a href="#itemTypeNameP#.cfm?area=#area_id#"> Actualizar</a></div>
</div>
<div class="div_element_menu">
	<div class="div_icon_menus"><a href="#itemTypeName#_new.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_new.png" alt="Nuevo #itemTypeName#" title="Crear #itemTypeNameEs#" /></a></div>
	<div class="div_text_menus"><a href="#itemTypeName#_new.cfm?area=#area_id#"><cfif itemTypeGender EQ "male">Nuevo<cfelse>Nueva</cfif><br/>#itemTypeNameEs#</a></div>
</div>
<cfif itemTypeId IS 1><!---Messages--->
<div class="div_element_menu">
	<div class="div_icon_menus"><a href="#itemTypeNameP#.cfm?area=#area_id#&mode=tree"><img src="#APPLICATION.htmlPath#/assets/icons/tree_mode.png" alt="Modo árbol" title="Modo árbol" /></a></div>
	<div class="div_text_menus"><a href="#itemTypeNameP#.cfm?area=#area_id#&mode=tree">Modo<br/>árbol</a></div>
</div>
</cfif>
</cfoutput>
</div>
<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAreaItemsList" returnvariable="xmlResponse">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>

<cfxml variable="xmlItems">
	<cfoutput>
	#xmlResponse.response.result.xmlChildren[1]#
	</cfoutput>
</cfxml>

<cfset numItems = ArrayLen(xmlItems.xmlChildren[1].XmlChildren)>
<div class="div_messages">
<cfif numItems GT 0>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItemsList">
		<cfinvokeargument name="xmlItems" value="#xmlItems#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		<cfinvokeargument name="return_page" value="#lCase(itemTypeNameP)#.cfm?area=#area_id#">
	</cfinvoke>

<cfelse>
	<cfoutput>
	<div class="div_text_result">No hay #lCase(itemTypeNameEsP)# en esta área.</div>
	</cfoutput>
</cfif>
</div>
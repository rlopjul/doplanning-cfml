<cfoutput>
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

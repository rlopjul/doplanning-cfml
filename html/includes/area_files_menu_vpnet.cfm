<div class="div_element_menu">
	<div class="div_icon_menus"><a href="files.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/v3/icons/refresh.png" alt="Actualizar" title="Actualizar" /></a></div>
	<div class="div_text_menus"><a href="files.cfm?area=#area_id#"> Actualizar</a></div>
</div>
<cfif APPLICATION.identifier NEQ "vpnet">
<div class="div_element_menu">
	<div class="div_icon_menus"><a href="area_file_new.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/v3/icons/file_new.png" alt="Subir nuevo archivo" title="Subir nuevo archivo" /></a></div>
		<div class="div_text_menus"><a href="area_file_new.cfm?area=#area_id#"> Nuevo<br/> archivo</a></div>
</div>
</cfif>
<div class="div_element_menu">
	<div class="div_icon_menus"><a href="file_associate.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/v3/icons/file_area.png" alt="Asociar archivo al área" title="Asociar archivo al área" /></a></div>
		<div class="div_text_menus"><a href="file_associate.cfm?area=#area_id#"> Asociar<br/> archivo</a></div>
</div>
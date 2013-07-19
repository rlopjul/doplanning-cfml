<!---Required var: 
	folder_id
	
--->
<div class="div_head_menu">
	<cfoutput>
	<!---
	<cfif APPLICATION.identifier EQ "vpnet"><!---Esto está deshabilitado en DoPlanning--->
			<div class="div_element_menu">
				<div class="div_icon_menus"><a href="my_files_file_new.cfm?parent=#folder_id#"><img src="assets/icons/file_new.png" title="Nuevo archivo" alt="Nuevo archivo" /></a></div>
				<div class="div_text_menus"><a href="my_files_file_new.cfm?parent=#folder_id#" class="text_menus">Nuevo<br />archivo</a></div>
			</div>
	</cfif> --->
	
	
	<cfif isDefined("URL.folder")><!---Si no está en el directorio raiz--->
	<div class="div_element_menu">
		<div class="div_icon_menus"><a href="folder_modify.cfm?folder=#folder_id#"><img src="assets/icons/folder_modify.png" title="Modificar carpeta" alt="Modificar carpeta"/></a></div>
		<div class="div_text_menus"><a href="folder_modify.cfm?folder=#folder_id#" class="text_menus">Modificar<br />carpeta</a></div>
	</div>
	</cfif>
	
	<!--- 
	<cfif APPLICATION.identifier EQ "vpnet"><!---Esto está deshabilitado en DoPlanning--->
		<div class="div_element_menu">
			<div class="div_icon_menus"><a href="folder_new.cfm?parent=#folder_id#"><img src="assets/icons/folder_new.png" title="Nueva carpeta" alt="Nueva carpeta"/></a></div>
			<div class="div_text_menus"><a href="folder_new.cfm?parent=#folder_id#" class="text_menus">Nueva<br />carpeta</a></div>
		</div>
	</cfif> --->
	
	</cfoutput>
</div>
<div style="height:6px;"><!-- --></div>
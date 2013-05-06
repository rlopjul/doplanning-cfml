<div class="div_element_menu">
	<div class="div_icon_menus"><a onclick="downloadFile('#APPLICATION.htmlPath#/file_download.cfm?id=#objectFile.id#')" style="cursor:pointer"><img src="#APPLICATION.htmlPath#/assets/icons/file_download.png" title="Descargar archivo" alt="Descargar archivo"/></a></div>
	<div class="div_text_menus"><a onclick="downloadFile('#APPLICATION.htmlPath#/file_download.cfm?id=#objectFile.id#')" class="text_menus" style="cursor:pointer"><br />Descargar</a></div>
</div>
<cfif objectFile.user_in_charge EQ SESSION.user_id>
	<cfif page_type IS 1> 
		<div class="div_element_menu">
			<div class="div_icon_menus"><a href="file_associate_areas.cfm?file=#objectFile.id#&folder=#folder_id#"><img src="#APPLICATION.htmlPath#/assets/icons/file_area.png" title="Asociar archivo a áreas" alt="Asociar archivo a áreas" /></a></div>
			<div class="div_text_menus"><a href="file_associate_areas.cfm?file=#objectFile.id#&folder=#folder_id#" class="text_menus">Asociar <br />a áreas</a></div>
		</div>
		<div class="div_element_menu">
			<div class="div_icon_menus"><a href="my_files_file_replace.cfm?file=#objectFile.id#&folder=#folder_id#"><img src="#APPLICATION.htmlPath#/assets/icons/file_replace.png" title="Reemplazar archivo" alt="Reemplazar archivo" /></a></div>
			<div class="div_text_menus"><a href="my_files_file_replace.cfm?file=#objectFile.id#&folder=#folder_id#" class="text_menus">Reemplazar<br />archivo</a></div>
		</div>
		<div class="div_element_menu">
			<div class="div_icon_menus"><a href="my_files_file_modify.cfm?file=#objectFile.id#&folder=#folder_id#"><img src="#APPLICATION.htmlPath#/assets/icons/file_modify.png" title="Modificar archivo" alt="Modificar archivo" /></a></div>
			<div class="div_text_menus"><a href="my_files_file_modify.cfm?file=#objectFile.id#&folder=#folder_id#" class="text_menus">Modificar<br />archivo</a></div>
		</div>
		<div class="div_element_menu">
			<div class="div_icon_menus"><a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=deleteFile&file_id=#objectFile.id#&folder_id=#folder_id#" onclick="return confirmDeleteFile();"><img src="#APPLICATION.htmlPath#/assets/icons/file_delete.png" title="Eliminar archivo definitivamente" alt="Eliminar archivo" /></a></div>
			<div class="div_text_menus"><a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=deleteFile&file_id=#objectFile.id#&folder_id=#folder_id#" class="text_menus" onclick="return confirmDeleteFile();">Eliminar<br />archivo</a></div>
		</div>
	<cfelseif page_type IS 2>
		
		<!---
		Esta funcionalidad es la misma que la de asociar el archivo a áreas
		<div class="div_element_menu">
			<div class="div_icon_menus"><a href="file_copy.cfm?file=#objectFile.id#&area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/file_copy.png" title="Copiar archivo a áreas" alt="Copiar archivo a áreas" /></a></div>
			<div class="div_text_menus"><a href="file_copy.cfm?file=#objectFile.id#&area=#area_id#" class="text_menus">Copiar<br />archivo</a></div>
		</div>--->
		
		<div class="div_element_menu">
			<div class="div_icon_menus"><a href="area_file_associate_areas.cfm?file=#objectFile.id#&area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/file_area.png" title="Asociar archivo a otras áreas" alt="Asociar archivo a otras áreas" /></a></div>
			<div class="div_text_menus"><a href="area_file_associate_areas.cfm?file=#objectFile.id#&area=#area_id#" class="text_menus">Asociar a <br />otras áreas</a></div>
		</div>
		
		<div class="div_element_menu">
			<div class="div_icon_menus"><a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=dissociateFile&file_id=#objectFile.id#&area_id=#area_id#&return_path=#return_path#"><img src="#APPLICATION.htmlPath#/assets/icons/file_delete.png" title="Quitar archivo del área" alt="Quitar archivo" /></a></div>
			<div class="div_text_menus"><a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=dissociateFile&file_id=#objectFile.id#&area_id=#area_id#&return_path=#return_path#" class="text_menus">Quitar<br />del área</a></div>
		</div>
		
		<cfif APPLICATION.identifier EQ "dp"><!---Solo para DoPlanning--->
		
			<div class="div_element_menu">
				<div class="div_icon_menus"><a href="area_file_replace.cfm?file=#objectFile.id#&area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/file_replace.png" title="Reemplazar archivo" alt="Reemplazar archivo" /></a></div>
				<div class="div_text_menus"><a href="area_file_replace.cfm?file=#objectFile.id#&area=#area_id#" class="text_menus">Reemplazar<br />archivo</a></div>
			</div>
			<div class="div_element_menu">
				<div class="div_icon_menus"><a href="area_file_modify.cfm?file=#objectFile.id#&area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/file_modify.png" title="Modificar archivo" alt="Modificar archivo" /></a></div>
				<div class="div_text_menus"><a href="area_file_modify.cfm?file=#objectFile.id#&area=#area_id#" class="text_menus">Modificar<br />archivo</a></div>
			</div>
			<div class="div_element_menu">
				<div class="div_icon_menus"><a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=deleteFileRemote&file_id=#objectFile.id#&area_id=#area_id#&return_path=#return_path#" onclick="return confirmDeleteFile();"><img src="#APPLICATION.htmlPath#/assets/icons/file_delete.png" title="Eliminar archivo definitivamente" alt="Eliminar archivo" /></a></div>
				<div class="div_text_menus"><a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=deleteFileRemote&file_id=#objectFile.id#&area_id=#area_id#&return_path=#return_path#" class="text_menus" onclick="return confirmDeleteFile();">Eliminar<br />archivo</a></div>
			</div>
		
		</cfif>
		
	</cfif>
</cfif>
<cfif listFind(".gif,.jpg,.png",objectFile.file_type) GT 0>
<div class="div_element_menu">
	<cfif page_type IS 1>
	<div class="div_icon_menus"><a href="my_files_file_view.cfm?file=#objectFile.id#&folder=#folder_id#"><img src="#APPLICATION.htmlPath#/assets/icons/file_view.png"/></a></div>
	<div class="div_text_menus"><a href="my_files_file_view.cfm?file=#objectFile.id#&folder=#folder_id#" class="text_menus"><br />Visualizar</a></div>
	<cfelse>
	<div class="div_icon_menus"><a href="area_file_view.cfm?file=#objectFile.id#&area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/file_view.png" title="Visualizar el archivo (imagen)"/></a></div>
	<div class="div_text_menus"><a href="area_file_view.cfm?file=#objectFile.id#&area=#area_id#" class="text_menus"><br />Visualizar</a></div>
	</cfif>
</div>
</cfif>
<cfif APPLICATION.moduleConvertFiles EQ "enabled">
	<cfif objectFile.file_types_conversion.recordCount GT 0>
		<div class="div_element_menu" style="width:130px;">
			<cfif page_type IS 1>
				<cfset form_action = "my_files_file_convert.cfm">
			<cfelse>
				<cfset form_action = "area_file_convert.cfm">
			</cfif>
			<form name="convert_file" id="convert_file" method="get" action="#form_action#" onsubmit="showHideDiv('convert_file_loading');">
				<input type="hidden" name="file" value="#objectFile.id#" />
				<cfif page_type IS 1>
				<input type="hidden" name="folder" value="#folder_id#" />
				<cfelse>
				<input type="hidden" name="area" value="#area_id#" />
				</cfif>
				<div class="div_icon_menus"><input type="image" src="assets/icons/view_file.gif" title="Visualizar el archivo"/></div>
				<div class="div_text_menus"><a href="##" onclick="showHideDiv('convert_file_loading');submitForm('convert_file');" class="text_menus">Visualizar en </a>
				<select name="file_type" style="width:90px;" onchange="showHideDiv('convert_file_loading');submitForm('convert_file');">
					<cfloop query="objectFile.file_types_conversion">
						<option value="#objectFile.file_types_conversion.file_type#">#objectFile.file_types_conversion.name_es#</option>
					</cfloop>
				</select>
				</div>
			</form>
		</div>
	</cfif> 
</cfif>
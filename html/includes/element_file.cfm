<!---ESTA PÁGINA YA NO SE USA PARA ARCHIVOS DE UN ÁREA--->

<!---Required vars
	page_type
	return_path
	
	page_types:
		1 Mis documentos
			folder_id required
		2 Asociar archivo a un área
		3 Archivos de un área / Búsqueda de archivos
			area_id required
		
	
--->
<cfoutput>
<div class="div_file">
	
	<div class="div_file_right">
		<div class="div_text_file_name">
		
		<!---<div class="div_img_file">--->
		<cfif isDefined("page_type") AND page_type IS 2>
		<form action="#APPLICATION.htmlComponentsPath#/File.cfc?method=associateFile" method="post" style="float:left;">
			<input type="hidden" name="area_id" value="#area_id#" />
			<input type="hidden" name="file_id" value="#objectFile.id#" />
			<input type="hidden" name="return_path" value="#return_path#" />
			<input type="image" src="#APPLICATION.htmlPath#/assets/icons/file_new.png" class="img_file" title="Añadir archivo"/>
		</form>
		<cfelse>
		<a href="file_download.cfm?id=#objectFile.id#"><img src="#APPLICATION.htmlPath#/assets/icons/file_download.png" class="img_file"/></a>
		</cfif>
		<!---</div>--->
		
		<cfif isDefined("page_type")>
			<cfif page_type IS 1>
				<a href="my_files_file.cfm?folder=#folder_id#&file=#objectFile.id#" class="text_item"><cfif len(objectFile.name) GT 0>#objectFile.name#<cfelse><i>Archivo sin nombre</i></cfif></a>
			<cfelseif page_type IS 2>
				<span class="text_item">#objectFile.name#</span>
			<cfelseif page_type IS 3>
				<a href="file.cfm?area=#area_id#&file=#objectFile.id#" class="text_item">#objectFile.name#</a>
			</cfif>
		</cfif>
		</div>
		<cfif len(objectFile.user_full_name) GT 0>
		<div class="div_text_file_email">#objectFile.user_full_name#</div></cfif>
		<cfif len(objectFile.uploading_date) GT 0><div class="div_text_file_date">#objectFile.uploading_date#</div></cfif><div class="div_text_file_size">#objectFile.file_size#</div>
	</div>
</div>
</cfoutput>
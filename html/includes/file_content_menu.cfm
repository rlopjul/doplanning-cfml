<cfoutput>
<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#objectFile.id#&fileTypeId=#fileTypeid#" onclick="return downloadFileLinked(this,event)" class="btn btn-sm btn-primary"><i class="icon-download-alt"></i> <span lang="es">Descargar</span></a>
		
<cfif listFind(".gif,.jpg,.png",objectFile.file_type) GT 0>
	<cfif page_type IS 1>
	
		<a href="my_files_file_view.cfm?file=#objectFile.id#&folder=#folder_id#" class="btn btn-default btn-sm"><i class="icon-eye-open"></i> <span lang="es">Visualizar</span></a>
	
	<cfelse>
	
		<a href="area_file_view.cfm?file=#objectFile.id#&area=#area_id#" class="btn btn-default btn-sm"><i class="icon-eye-open"></i> <span lang="es">Visualizar</span></a>
	
	</cfif>
</cfif>


<cfif page_type IS 1> 

	<a href="my_files_file_replace.cfm?file=#objectFile.id#&folder=#folder_id#" class="btn btn-info btn-sm"><i class="icon-repeat"></i> <span lang="es">Reemplazar</span></a>
	
	<a href="file_associate_areas.cfm?file=#objectFile.id#&folder=#folder_id#" class="btn btn-info btn-sm"><i class="icon-plus-sign"></i> <span lang="es">Asociar a áreas</span></a>
	
	<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=deleteFile&file_id=#objectFile.id#&folder_id=#folder_id#" onclick="return confirmDeleteFile();" class="btn btn-danger btn-sm"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>
	<a href="my_files_file_modify.cfm?file=#objectFile.id#&folder=#folder_id#" class="btn btn-sm btn-info"><i class="icon-edit"></i> <span lang="es">Modificar datos</span></a>


<cfelseif page_type IS 2>

	<cfif fileTypeId IS NOT 1><!---Area file--->
		
		<!---area_allowed--->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="canUserAccessToArea" returnvariable="file_area_allowed">
			<cfinvokeargument name="area_id" value="#objectFile.area_id#">
		</cfinvoke>

	</cfif>
	
	<cfif (fileTypeId IS 1 AND objectFile.user_in_charge EQ SESSION.user_id) OR (fileTypeId IS NOT 1 AND file_area_allowed IS true)>

		<cfif fileTypeId IS 1 || (fileTypeId IS NOT 1 AND objectFile.locked IS true AND objectFile.lock_user_id IS SESSION.user_id)>
			<cfif fileTypeId IS 1 OR fileTypeId IS 2>
				<a href="area_file_replace.cfm?file=#objectFile.id#&fileTypeId=#fileTypeId#&area=#area_id#" class="btn btn-info btn-sm"><i class="icon-repeat"></i> <span lang="es">Reemplazar</span></a>
			<cfelse>
				<a href="area_file_replace.cfm?file=#objectFile.id#&fileTypeId=#fileTypeId#&area=#area_id#" class="btn btn-info btn-sm"><i class="icon-upload-alt"></i> <span lang="es">Nueva versión</span></a>
			</cfif>
			
			<a href="area_file_modify.cfm?file=#objectFile.id#&area=#area_id#&fileTypeId=#fileTypeId#" class="btn btn-default btn-sm"><i class="icon-edit"></i> <span lang="es">Modificar datos</span></a>
		</cfif>
		
		<!--- 
		<cfif app_version NEQ "mobile">
					<a href="#APPLICATION.htmlPath#/file.cfm?file=#objectFile.id#&area=#area_id#" title="Abrir en nueva ventana" target="_blank" class="btn btn-default btn-sm" lang="es"><i class="icon-external-link"></i> <span lang="es">Ampliar</span></a>
				</cfif> --->
		
		<cfif fileTypeId IS 1 OR fileTypeId IS 2>
			<a href="area_file_associate_areas.cfm?file=#objectFile.id#&area=#area_id#" class="btn btn-default btn-sm"><i class="icon-plus-sign"></i> <span lang="es">Asociar a áreas</span></a>
		</cfif>
		
		<cfif fileTypeId IS 1 OR (fileTypeId IS 2 AND area_id NEQ objectFile.area_id)>
			<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=dissociateFile&file_id=#objectFile.id#&area_id=#area_id#&return_path=#return_path#" class="btn btn-warning btn-sm"><i class="icon-minus-sign"></i> <span lang="es">Quitar del área</span></a>
		</cfif>

		<cfif fileTypeId IS NOT 1><!--- Area file --->
			
			<cfif objectFile.locked IS true>

				<cfif objectFile.lock_user_id IS SESSION.user_id OR is_user_area_responsible>
					<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=lockFile&file_id=#objectFile.id#&fileTypeId=#fileTypeId#&area_id=#area_id#&lock=false&return_path=#return_path#" class="btn btn-warning btn-sm" onclick="return confirmLockFile(false);"><i class="icon-unlock"></i> <span lang="es">Desbloquear</span></a>
				</cfif>

			<cfelseif objectFile.in_approval IS false>

				<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=lockFile&file_id=#objectFile.id#&fileTypeId=#fileTypeId#&area_id=#area_id#&lock=true&return_path=#return_path#" class="btn btn-warning btn-sm" onclick="return confirmLockFile(true);"><i class="icon-lock"></i> <span lang="es">Bloquear</span></a>

				<cfif fileTypeId IS 3 AND len(version.revision_request_date) IS 0>
					
					<a href="file_request_approval.cfm?file=#objectFile.id#" class="btn btn-default btn-sm"><i class="icon-check"></i> <span lang="es">Solicitar aprobación</span></a>

				</cfif>

			</cfif>

			<cfif fileTypeId IS 3>
				
				<a href="file_versions.cfm?file=#objectFile.id#" class="btn btn-default btn-sm"><i class="icon-list-alt"></i> <span lang="es">Versiones</span></a>

				<cfif version.approved IS true AND NOT isNumeric(version.publication_file_id) AND is_user_area_responsible>
				
					<a href="file_publish.cfm?file=#objectFile.id#&area=#area_id#&fileTypeId=#fileTypeId#&version=#version.version_id#" class="btn btn-default btn-sm"><i class="icon-share"></i> <span lang="es">Publicar versión</span></a>

				</cfif>

			</cfif>

		</cfif>

	</cfif>

	<cfif len(area_type) GT 0 AND is_user_area_responsible>

		<cfset url_return_path = "&return_path="&URLEncodedFormat("#return_path#area_items.cfm?area=#area_id#&file=#file_id#")>

		<!--- publication validation --->
		<cfif objectFile.publication_validated IS false>
			<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=changeFilePublicationValidation&file_id=#file_id#&area_id=#area_id#&validate=true#url_return_path#" onclick="return confirmReversibleAction('Permitir la publicación');" title="Aprobar publicación" class="btn btn-success btn-sm"><i class="icon-check"></i> <span lang="es">Aprobar publicación</span></a>
		<cfelse>
			<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=changeFilePublicationValidation&file_id=#file_id#&area_id=#area_id#&validate=false#url_return_path#" onclick="return confirmReversibleAction('Impedir la publicación');" title="Desaprobar publicación" class="btn btn-warning btn-sm"><i class="icon-remove-sign"></i> <span lang="es">Desaprobar publicación</span></a>					
		</cfif>
		
	</cfif>

	<cfif (fileTypeId IS 1 AND objectFile.user_in_charge EQ SESSION.user_id) OR (fileTypeId IS 2 AND file_area_allowed IS true AND objectFile.locked IS false) OR (fileTypeId IS 3 AND file_area_allowed IS true AND objectFile.locked IS false AND isFileApproved IS false) OR (SESSION.user_id EQ SESSION.client_administrator)>

		<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=deleteFileRemote&file_id=#objectFile.id#&area_id=#area_id#&return_path=#return_path#" onclick="return confirmDeleteFile();" class="btn btn-danger btn-sm"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>

	</cfif>

	<cfif ( fileTypeId IS 1 || (fileTypeId IS NOT 1 AND objectFile.locked IS true AND objectFile.lock_user_id EQ SESSION.user_id) ) AND ( objectFile.user_in_charge EQ SESSION.user_id OR is_user_area_responsible )>
		
		<cfif fileTypeId IS 1>
			
			<cfif objectFile.user_in_charge EQ SESSION.user_id OR SESSION.user_id EQ SESSION.client_administrator>

				<div class="btn-group">
					<a href="##" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" title="Cambiar propietario" lang="es"> 
					<i class="icon-user"></i> <span lang="es">Cambiar propietario</span> <span class="caret"></span></a>
					<ul class="dropdown-menu">
						
						<li><a href="file_change_user.cfm?file=#objectFile.id#&area=#area_id#">Cambiar usuario propietario</a></li>
						
						<li><a href="file_change_owner_to_area.cfm?file=#objectFile.id#&area=#area_id#">Convertir en archivo del área</a></li>

					</ul>
				</div>

				<!---<a href="file_change_user.cfm?file=#objectFile.id#&area=#area_id#" class="btn btn-warning btn-sm"><i class="icon-user"></i> <span lang="es">Cambiar propietario</span></a>
				<a href="file_change_owner_to_area.cfm?file=#objectFile.id#&area=#area_id#" class="btn btn-warning btn-sm"><i class="icon-user"></i> <span lang="es">Convertir en archivo del área</span></a>--->
			</cfif>
			
		<cfelse><!--- fileTypeId IS NOT 1 --->
			<cfif APPLICATION.changeElementsArea IS true>
				<a href="file_change_area.cfm?file=#objectFile.id#&area=#area_id#" class="btn btn-default btn-sm"><i class="icon-cut"></i> <span lang="es">Cambiar área</span></a>
			</cfif>	
		</cfif>

	</cfif>

	<cfif app_version NEQ "mobile">
		<a href="#APPLICATION.htmlPath#/file.cfm?file=#objectFile.id#&area=#area_id#" title="Abrir en nueva ventana" target="_blank" class="btn btn-default btn-sm" lang="es"><i class="icon-external-link"></i> <span lang="es">Ampliar</span></a>
	</cfif>

</cfif>


<cfif APPLICATION.moduleConvertFiles EQ true>
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
				<div class="div_text_menus"><a href="##" onclick="showHideDiv('convert_file_loading');submitForm('convert_file');" class="text_menus"><span lang="es">Visualizar en</span> </a>
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
</cfoutput>
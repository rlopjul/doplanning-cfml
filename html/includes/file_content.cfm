<!---Required var: 
	page_type
	return_path (para eliminar o quitar un archivo de un área)
	
	page_types:
		1 Mis documentos
			folder_id required
		2 Archivos de un area
			area_id required
--->

<!--- File --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
	<cfinvokeargument name="file_id" value="#file_id#">
	<cfif isDefined("area_id")>
	<cfinvokeargument name="area_id" value="#area_id#">
	</cfif>
</cfinvoke>

<cfset fileTypeId = objectFile.file_type_id>

<cfif fileTypeId IS 3>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getLastFileVersion" returnvariable="version">
		<cfinvokeargument name="file_id" value="#file_id#">
		<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
	</cfinvoke>

	<cfif version.approved IS true>

		<cfset isFileApproved = true>

	<cfelse>

		<!--- isFileApproved --->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="isFileApproved" returnvariable="isFileApproved">
			<cfinvokeargument name="file_id" value="#file_id#">
			<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
		</cfinvoke>

	</cfif>

</cfif>

<cfoutput>
<script src="#APPLICATION.htmlPath#/language/file_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<div class="contenedor_fondo_blanco">
<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">
</div>

<script>

	function confirmDeleteFile() {
		
		var messageDelete = window.lang.translate("Si ELIMINA el archivo, se borrará de TODAS las áreas a las que esté asociado. ¿Seguro que desea borrar el archivo?");
		return confirm(messageDelete);
	}

	function confirmLockFile(value) {
		
		var messageLock = "";

		if(value)
			messageLock = "¿Seguro que desea bloquear el archivo?. No podrá ser modificado por otros usuarios.";
		else
			messageLock = "¿Seguro que desea desbloquear el archivo?.";
		
		return confirm(messageLock);
	}

	function confirmValidateFile(value) {
		
		var messageLock = "";

		if(value)
			messageLock = "¿Seguro que desea validar esta versión del archivo?. Se enviará a aprobación.";
		else
			messageLock = "¿Seguro que desea rechazar esta versión del archivo?.";
		
		return confirm(messageLock);
	}

	function confirmApproveFile(value) {
		
		var messageLock = "";

		if(value)
			messageLock = "¿Seguro que desea aprobar esta versión del archivo?. El archivo se podrá publicar.";
		else
			messageLock = "¿Seguro que desea rechazar esta versión del archivo?.";
		
		return confirm(messageLock);
	}

</script>


<cfinclude template="#APPLICATION.htmlPath#/includes/file_name_head.cfm">

<cfoutput>
<div class="div_elements_menu"><!---div_elements_menu--->

	<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->
	
		<cfinclude template="#APPLICATION.htmlPath#/includes/file_content_menu.cfm">
		
	<cfelse>
		
		<cfinclude template="#APPLICATION.htmlPath#/includes/file_content_menu_vpnet.cfm">
	
	</cfif>
</div>
<!---<cfdump var="#objectFile.file_types_conversion#">--->
</cfoutput>

<cfoutput>
	<!---<div class="div_file_page_name">#objectFile.name#</div>
	<div class="div_separator"><!-- --></div>--->
	<div class="div_file_page_file">
		<cfif page_type NEQ 1>

			<cfif objectFile.file_type_id IS 2 OR objectFile.file_type_id IS 3>

				<cfif (objectFile.file_type_id IS 2 AND area_id EQ objectFile.area_id) OR objectFile.file_type_id IS 3>

					<cfif objectFile.locked IS true>
						<div class="alert alert-warning">
							<span>Archivo bloqueado por el usuario <a href="area_user.cfm?area=#objectFile.area_id#&user=#objectFile.lock_user_id#">#objectFile.lock_user_full_name#</a>.</span>
						</div>

						<div class="div_file_page_label">
							<span>Fecha de bloqueo:</span> <span class="text_file_page">#objectFile.lock_date#</span>
						</div>
					<cfelse>

						<cfif objectFile.file_type_id IS 3 AND objectFile.in_approval IS true>

							<div class="alert alert-warning">
								<p>Archivo en proceso de revisión y aprobación.<br/>
									Estado actual:
									<b><cfif version.revised IS true>
										pendiente de aprobación <a href="area_user.cfm?area=#area_id#&user=#objectFile.approver_user#">#objectFile.approver_user_full_name#</a>.
									<cfelse>
										pendiente de ser revisado por <a href="area_user.cfm?area=#area_id#&user=#objectFile.reviser_user#">#objectFile.reviser_user_full_name#</a>.
									</cfif></b>
								</p>

								<cfif version.revised IS false AND SESSION.user_id IS objectFile.reviser_user>
									<!--- validateFileVersion --->
									<p>
										Debe validar o rechazar la versión de este archivo:<br/>
										<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=validateFileVersion&file_id=#objectFile.id#&fileTypeId=#fileTypeId#&area_id=#area_id#&valid=true&return_path=#return_path#" onclick="return confirmValidateFile(true);" class="btn btn-success btn-sm"><i class="icon-check"></i> <span lang="es">Validar versión</span></a>
										<!---<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=validateFileVersion&file_id=#objectFile.id#&fileTypeId=#fileTypeId#&area_id=#area_id#&valid=false&return_path=#return_path#" onclick="return confirmValidateFile(false);" class="btn btn-danger btn-sm"><i class="icon-remove-sign"></i> <span lang="es">Rechazar versión</span></a>--->
										<a href="file_reject_revision.cfm?file=#objectFile.id#&fileTypeId=#fileTypeId#&area=#area_id#&return_path=#return_path#" class="btn btn-danger btn-sm"><i class="icon-remove-sign"></i> <span lang="es">Rechazar versión</span></a>
									</p>

								<cfelseif version.revised IS true AND SESSION.user_id IS objectFile.approver_user>
									<!--- approveFileVersion --->
									<p>
										Debe aprobar o rechazar la versión de este archivo:<br/>
										<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=approveFileVersion&file_id=#objectFile.id#&fileTypeId=#fileTypeId#&area_id=#area_id#&approve=true&return_path=#return_path#" onclick="return confirmApproveFile(true);" class="btn btn-success btn-sm"><i class="icon-check"></i> <span lang="es">Aprobar versión</span></a>
										<!---<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=approveFileVersion&file_id=#objectFile.id#&fileTypeId=#fileTypeId#&area_id=#area_id#&approve=false&return_path=#return_path#" onclick="return confirmApproveFile(false);" class="btn btn-danger btn-sm"><i class="icon-remove-sign"></i> <span lang="es">Rechazar versión</span></a>--->
										<a href="file_reject_approval.cfm?file=#objectFile.id#&fileTypeId=#fileTypeId#&area=#area_id#&return_path=#return_path#" class="btn btn-danger btn-sm"><i class="icon-remove-sign"></i> <span lang="es">Rechazar versión</span></a>
									</p>

								</cfif>

								<cfif version.revised IS false>
									<!--- cancelRevisionRequest --->
									<p>
										<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=cancelRevisionRequest&file_id=#objectFile.id#&fileTypeId=#fileTypeId#&area_id=#area_id#&return_path=#return_path#" onclick="return confirmAction('cancelar el proceso de revisión');" class="btn btn-warning btn-sm"><i class="icon-undo"></i> <span lang="es">Cancelar revisión</span></a>
									</p>								
								</cfif>
								
								
							</div>
							<div class="div_file_page_label">
								<span>Fecha de envío a revisión:</span> <span class="text_file_page">#version.revision_request_date#</span>
							</div>
							<cfif len(version.revision_date)>
							<div class="div_file_page_label">
								<span>Fecha de envío a revisión:</span> <span class="text_file_page">#version.revision_date#</span>
							</div>
							</cfif>

						<cfelse>
							<div class="alert alert-info">
								<span lang="es">Debe bloquear el archivo para poder realizar cualquier modificación.</span>
							</div>

							<cfif fileTypeId IS 3>
								
								<!--- outputFileVersionStatus --->
								<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="outputFileVersionStatus">
									<cfinvokeargument name="version" value="#version#">
								</cfinvoke>

								<cfif version.approved NEQ true AND isFileApproved IS true>

									<div class="label label-warning">La versión actual de este archivo no es la versión aprobada</div>

								</cfif>

							</cfif>
							
						</cfif>
						
					</cfif>

				</cfif>

				<div class="div_file_page_label">
					<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="fileArea">
						<cfinvokeargument name="area_id" value="#objectFile.area_id#">
					</cfinvoke>

					<b><span lang="es">Propiedad del área:</span></b>
					
					<a onclick="openUrl('area_items.cfm?area=#objectFile.area_id#&file=#objectFile.id#','areaIframe',event)" style="cursor:pointer">#fileArea.name#</a>
				</div>

				<cfif objectFile.file_type_id IS 3 AND isNumeric(version.publication_area_id) AND isNumeric(version.publication_file_id)>

					<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="publicationArea">
						<cfinvokeargument name="area_id" value="#version.publication_area_id#">
					</cfinvoke>
					<div class="div_file_page_label"><span lang="es">Versión de archivo publicada en el área:</span> <a onclick="openUrl('area_items.cfm?area=#version.publication_area_id#&file=#version.publication_file_id#','areaIframe',event)" style="cursor:pointer">#publicationArea.name#</a></div>

				</cfif>

			</cfif><!--- END objectFile.file_type_id IS 2 OR objectFile.file_type_id IS 3 --->

			<div class="div_file_page_label">
				<cfif objectFile.file_type_id IS 1><!--- User file --->
					<a href="area_user.cfm?area=#area_id#&user=#objectFile.user_in_charge#">
					<cfif len(objectFile.user_image_type) GT 0>
						<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectFile.user_in_charge#&type=#objectFile.user_image_type#&small=" alt="#objectFile.user_full_name#" class="item_img" style="margin-right:2px;"/>									
					<cfelse>						
						<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectFile.user_full_name#" class="item_img_default" style="margin-right:2px;"/>
					</cfif></a>
				<cfelse><!--- Area file --->	
					<span lang="es">Creado por:</span>
				</cfif>				
				<a href="area_user.cfm?area=#area_id#&user=#objectFile.user_in_charge#">#objectFile.user_full_name#</a>
			</div>
			<!---<div class="div_file_page_user">#objectFile.user_full_name#</div>--->
		</cfif>
		<cfif objectFile.file_type_id IS NOT 1>
			<div class="div_file_page_label">
				<span lang="es"><cfif objectFile.file_type_id IS 2>Último reemplazo por:<cfelse>Última version por:</cfif></span>			
				<a href="area_user.cfm?area=#area_id#&user=#objectFile.replacement_user#">#objectFile.replacement_user_full_name#</a>
			</div>
		</cfif>
		<cfif objectFile.file_type_id IS 3>
			
			<div class="div_file_page_label">
				<span lang="es">Revisor:</span>			
				<a href="area_user.cfm?area=#area_id#&user=#objectFile.reviser_user#">#objectFile.reviser_user_full_name#</a>
			</div>

			<div class="div_file_page_label">
				<span lang="es">Aprobador:</span>			
				<a href="area_user.cfm?area=#area_id#&user=#objectFile.approver_user#">#objectFile.approver_user_full_name#</a>
			</div>

		</cfif>

		<div class="div_file_page_label"><span lang="es">Nombre de archivo:</span></div>
		<div class="div_file_page_user">#objectFile.file_name#</div>
		
		<div class="div_file_page_label"><span lang="es">Fecha de creación:</span> <span class="text_file_page">#objectFile.uploading_date#</span></div>
		<cfif len(objectFile.replacement_date) GT 0 OR objectFile.file_type_id IS NOT 3>	
		<div class="div_file_page_label"><span lang="es"><cfif objectFile.file_type_id IS 3>Fecha de última versión:<cfelse>Fecha de reemplazo:</cfif></span> <span class="text_file_page"><cfif len(objectFile.replacement_date) GT 0>#objectFile.replacement_date#<cfelse>-</cfif></span></div>
		</cfif>

		<cfif len(area_type) GT 0><!--- WEB --->

			<cfif len(objectFile.publication_date) GT 0>
				<div class="div_file_page_label"><span lang="es">Fecha de publicación:</span> <span class="text_file_page">#objectFile.publication_date#</span>
				</div>
			</cfif>
			<cfif APPLICATION.publicationValidation IS true AND len(objectFile.publication_validated) GT 0>
				<div class="div_file_page_label"><span lang="es">Publicación aprobada:</span> <span class="text_file_page" lang="es"><cfif objectFile.publication_validated IS true>Sí<cfelse><b>No</b></cfif></span>
				</div>
			</cfif>

		</cfif>
					
		
		<div class="div_file_page_label"><span lang="es">Tipo de archivo:</span> <span class="text_file_page">#objectFile.file_type#</span></div>
		

		<cfif isNumeric(objectFile.file_size)>
			<!---fileUrl--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="trasnformFileSize" returnvariable="file_size">
				<cfinvokeargument name="file_size_full" value="#objectFile.file_size#">
			</cfinvoke>
		<cfelse>
			<cfset file_size = objectFile.file_size>
		</cfif>

		<div class="div_file_page_size"><div class="div_file_page_label"><span lang="es">Tamaño:</span> <span class="text_file_page">#file_size#</span></div></div>
		
		<div class="div_file_page_label"><span lang="es">Descripción:</span></div>
		<div class="div_file_page_description">#objectFile.description#</div>

		<cfif APPLICATION.publicationScope IS true AND fileTypeId IS NOT 3>

			<div class="div_message_page_label"><span lang="es">Ámbito de publicación:</span> <span class="text_message_page">#objectFile.publication_scope_name#</span></div>

		</cfif>


		<cfif APPLICATION.moduleAntiVirus IS true>

			<div class="div_message_page_label"><span lang="es"><cfif fileTypeId IS 3>Última versión de archivo analizada por Antivirus<cfelse>Analizado por Antivirus</cfif>:</span>
			<span class="text_message_page" lang="es"><cfif objectFile.anti_virus_check IS true>Sí<cfelse>No</cfif></span></div>

		</cfif>

		<!---fileUrl--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaFileUrl" returnvariable="areaFileUrl">
			<cfinvokeargument name="file_id" value="#objectFile.id#">
			<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
			<cfinvokeargument name="area_id" value="#area_id#">

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>

		<div class="div_message_page_label"><span lang="es">URL del archivo en #APPLICATION.title#:</span></div>
		<input type="text" value="#areaFileUrl#" onClick="this.select();" class="form-control" readonly="readonly" style="cursor:text"/>

		<!---getDownloadFileUrl--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getDownloadFileUrl" returnvariable="downloadFileUrl">
			<cfinvokeargument name="file_id" value="#objectFile.id#">
			<cfinvokeargument name="fileTypeId" value="#fileTypeId#">

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>

		<div class="div_message_page_label"><span lang="es">URL de descarga desde #APPLICATION.title#:</span></div>
		<input type="text" value="#downloadFileUrl#" onClick="this.select();" class="form-control" readonly="readonly" style="cursor:text"/>


		<!---<cfif SESSION.client_abb EQ "hcs">---><!---DoPlanning HCS--->

		<cfif (area_type EQ "web" OR area_type EQ "intranet") AND isDefined("webPath")>

			<!---fileWebUrl--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getFileWebPage" returnvariable="filePage">
				<cfinvokeargument name="file_id" value="#objectFile.id#">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>
			<cfset fileWebUrl = "/#webPath#/#filePage#">

			<div class="div_message_page_label"><span lang="es">URL <b>relativa en la #area_type#</b>:</span></div>
			<input type="text" value="#fileWebUrl#" onClick="this.select();" class="form-control" readonly="readonly" style="cursor:text"/>

		</cfif>
			
		<!---</cfif>--->

		<!---Typology--->
		<cfif APPLICATION.modulefilesWithTables IS true>
			
			<!---Typology fields--->
			<cfset table_id = objectFile.typology_id>
			<cfset tableTypeId = 3>
			<cfset row_id = objectFile.typology_row_id>

			<cfif isNumeric(table_id) AND isNumeric(row_id)>
				
				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getRow" returnvariable="getRowResponse">
					<cfinvokeargument name="table_id" value="#table_id#"/>
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#"/>
					<cfinvokeargument name="row_id" value="#row_id#"/>
					<cfinvokeargument name="file_id" value="#objectFile.id#"/>
				</cfinvoke>
				<cfset table = getRowResponse.table>
				<cfset row = getRowResponse.row>

				<div class="div_message_page_label">Tipología: <span class="text_message_page"><strong>#table.title#</strong></span></div>

				<!---<cfinclude template="#APPLICATION.htmlPath#/includes/table_row_content_fields.cfm">--->

				<!---outputRowContent--->
				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="outputRowContent">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="row" value="#row#">
					<cfinvokeargument name="file_id" value="#file_id#"/>
				</cfinvoke>
				
			</cfif>

		</cfif>
	</div>
</cfoutput>

<div id="convert_file_loading" style="position:absolute; width:100%; height:94%; top:0px; background-color:#EEEEEE; text-align:center; padding-top:90px; display:none;">
<cfoutput>
<div class="alert"><span lang="es">Generando archivo...</span></div>
<div style="margin:auto; text-align:center; padding-top:30px;">
<img src="#APPLICATION.path#/html/assets/icons/loading.gif" alt="Cargando" />
</div>
</cfoutput>
</div>

<cfif isDefined("URL.download") AND URL.download IS true>
	<cfoutput>
	<iframe style="display:none" src="#APPLICATION.htmlPath#/file_download.cfm?id=#file_id#"></iframe>
	</cfoutput>
</cfif>


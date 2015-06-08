<!---Required var: 
	page_type
	return_path (para eliminar o quitar un archivo de un área)
	
	page_types:
		1 Mis documentos (NO SE USA)
			folder_id required (NO SE USA)
		2 Archivos de un area
			area_id required
--->

<!--- File --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
	<cfinvokeargument name="file_id" value="#file_id#">
	<cfif isDefined("area_id")>
	<cfinvokeargument name="area_id" value="#area_id#">
	</cfif>
	<cfinvokeargument name="with_owner_area" value="true"> 		
</cfinvoke>

<cfset fileTypeId = objectFile.file_type_id>

<cfif isDefined("area_id")>
	
	<cfset itemTypeId = 10>
	<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

	<cfinclude template="#APPLICATION.htmlPath#/includes/area_id.cfm">
	<cfinclude template="#APPLICATION.htmlPath#/includes/area_checks.cfm">

	<cfinclude template="#APPLICATION.htmlPath#/includes/app_page_head.cfm">

	<cfinclude template="#APPLICATION.htmlPath#/includes/area_path.cfm">

</cfif>

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

<!--- 
<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput> --->


<!---<div class="contenedor_fondo_blanco">--->
<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">
<!---</div>--->

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
		
		return confirm(window.lang.translate(messageLock));
	}

	function confirmValidateFile(value) {
		
		var messageLock = "";

		if(value)
			messageLock = "¿Seguro que desea validar esta versión del archivo?. Se enviará a aprobación.";
		else
			messageLock = "¿Seguro que desea rechazar esta versión del archivo?.";
		
		return confirm(window.lang.translate(messageLock));
	}

	function confirmApproveFile(value) {
		
		var messageLock = "";

		if(value)
			messageLock = "¿Seguro que desea aprobar esta versión del archivo?. El archivo se podrá publicar.";
		else
			messageLock = "¿Seguro que desea rechazar esta versión del archivo?.";
		
		return confirm(window.lang.translate(messageLock));
	}

</script>


<!---<cfinclude template="#APPLICATION.htmlPath#/includes/file_name_head.cfm">--->

<cfoutput>
<div class="div_elements_menu"><!---div_elements_menu--->

	<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->
	
		<cfinclude template="#APPLICATION.htmlPath#/includes/file_content_menu.cfm">
		
	<cfelse>
		
		<cfinclude template="#APPLICATION.htmlPath#/includes/file_content_menu_vpnet.cfm">
	
	</cfif>

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

			<!---Table fields--->
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
				<cfinvokeargument name="table_id" value="#table_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="with_types" value="true"/>
				<cfinvokeargument name="file_id" value="#file_id#"/>
			</cfinvoke>

			<cfset fields = fieldsResult.tableFields>

			<cfset requestUrl = "">

			<cfloop query="fields">
				
				<cfif fields.field_type_id IS 14><!---REQUEST URL--->

					<cfset field_name = "field_#fields.field_id#">

					<cfif len(row[field_name]) GT 0>
						<cfset requestUrl = row[field_name]>
					</cfif>

				</cfif>

			</cfloop>
			
			<cfif len(requestUrl) GT 0>
				
				<a href="#requestUrl#?file_path=#URLEncodedFormat('/html/file_download.cfm?id=#file_id#')#" target="_blank" class="btn btn-success btn-sm"><i class="icon-asterisk"></i> <span>#table.title#</span></a>

			</cfif>
			

		</cfif>

	</cfif>

</div>
<!---<cfdump var="#objectFile.file_types_conversion#">--->
</cfoutput>

<cfoutput>
	<!---<div class="div_file_page_name">#objectFile.name#</div>
	<div class="div_separator"><!-- --></div>--->
	<!---<div class="div_file_page_file">--->

	<div class="panel panel-default"><!---class="div_message_page_message"--->
		
		<div class="panel-body" style="word-wrap:break-word;overflow-x:auto">

			<div class="row">

				<div class="col-xs-12">

					<div class="media"><!--- item user name and date --->

						<div class="media-left">

							<a href="area_user.cfm?area=#area_id#&user=#objectFile.user_in_charge#">

								<!---
								<div class="div_file_page_label">
									<cfif objectFile.file_type_id IS 1><!--- User file --->
										<a href="area_user.cfm?area=#area_id#&user=#objectFile.user_in_charge#">
										<cfif len(objectFile.user_image_type) GT 0>
											<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectFile.user_in_charge#&type=#objectFile.user_image_type#&small=" alt="#objectFile.user_full_name#" class="item_img" style="margin-right:2px;"/>									
										<cfelse>						
											<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectFile.user_full_name#" class="item_img_default" style="margin-right:2px;"/>
										</cfif></a>
									<cfelse><!--- Area file --->	
										<span lang="es">Creado por</span>
									</cfif>				
									<a href="area_user.cfm?area=#area_id#&user=#objectFile.user_in_charge#">#objectFile.user_full_name#</a>
								</div>
								--->

								<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUserImage">
									<cfinvokeargument name="user_id" value="#objectFile.user_in_charge#">
									<cfinvokeargument name="user_full_name" value="#objectFile.user_full_name#">
									<cfinvokeargument name="user_image_type" value="#objectFile.user_image_type#">
								</cfinvoke>

							</a>

						</div>

						<div class="media-body">

							<a href="area_user.cfm?area=#objectFile.area_id#&user=#objectFile.user_in_charge#" class="link_user">#objectFile.user_full_name#</a>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<cfset spacePos = findOneOf(" ", objectFile.uploading_date)>
							<span class="text_date">#left(objectFile.uploading_date, spacePos)#</span>
							&nbsp;&nbsp;&nbsp;
							<span class="text_hour">#right(objectFile.uploading_date, len(objectFile.uploading_date)-spacePos)#</span>

						</div>

					
					</div><!--- END media --->

					<hr style="margin-top:3px;">

				</div><!--- END col-xs-12 --->

			</div><!--- END row --->

			<div class="row">

				<div class="col-sm-12">

		<cfif page_type NEQ 1>

			<cfif objectFile.file_type_id IS 2 OR objectFile.file_type_id IS 3>

				<cfif (objectFile.file_type_id IS 2 AND area_id EQ objectFile.area_id) OR objectFile.file_type_id IS 3>

					<cfif objectFile.locked IS true>
						<div class="alert alert-warning">
							<span lang="es">Archivo bloqueado por el usuario</span> <a href="area_user.cfm?area=#objectFile.area_id#&user=#objectFile.lock_user_id#">#objectFile.lock_user_full_name#</a>
						</div>

						<div class="div_file_page_label">
							<span lang="es">Fecha de bloqueo</span> <span class="text_file_page">#objectFile.lock_date#</span>
						</div>
					<cfelse>

						<cfif objectFile.file_type_id IS 3 AND objectFile.in_approval IS true>

							<div class="panel panel-warning">

								<div class="panel-heading"><h5 class="panel-title" lang="es">Archivo en proceso de revisión y aprobación</h5></div>

								<div class="panel-body">
									<p>
										<span lang="es">Estado actual</span>
										<b lang="es"><cfif version.revised IS true>
											pendiente de aprobación <a href="area_user.cfm?area=#area_id#&user=#objectFile.approver_user#">#objectFile.approver_user_full_name#</a>.
										<cfelse>
											pendiente de ser revisado por <a href="area_user.cfm?area=#area_id#&user=#objectFile.reviser_user#">#objectFile.reviser_user_full_name#</a>.
										</cfif></b>
									</p>

									<cfif objectArea.read_only IS false>
									
										<cfif version.revised IS false AND SESSION.user_id IS objectFile.reviser_user>
											<!--- validateFileVersion --->
											
												<span lang="es">Debe validar o rechazar la versión de este archivo</span><br/>
												<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=validateFileVersion&file_id=#objectFile.id#&fileTypeId=#fileTypeId#&area_id=#area_id#&valid=true&return_path=#return_path#" onclick="return confirmValidateFile(true);" class="btn btn-success btn-sm"><i class="icon-check"></i> <span lang="es">Validar versión</span></a>


												<!---<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=validateFileVersion&file_id=#objectFile.id#&fileTypeId=#fileTypeId#&area_id=#area_id#&valid=false&return_path=#return_path#" onclick="return confirmValidateFile(false);" class="btn btn-danger btn-sm"><i class="icon-remove-sign"></i> <span lang="es">Rechazar versión</span></a>--->
												<a href="file_reject_revision.cfm?file=#objectFile.id#&fileTypeId=#fileTypeId#&area=#area_id#&return_path=#return_path#" class="btn btn-danger btn-sm"><i class="icon-remove-sign"></i> <span lang="es">Rechazar versión</span></a>
											

										<cfelseif version.revised IS true AND SESSION.user_id IS objectFile.approver_user>
											<!--- approveFileVersion --->
											
												<span lang="es">Debe aprobar o rechazar la versión de este archivo</span><br/>
												<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=approveFileVersion&file_id=#objectFile.id#&fileTypeId=#fileTypeId#&area_id=#area_id#&approve=true&return_path=#return_path#" onclick="return confirmApproveFile(true);" class="btn btn-default btn-sm"><i class="icon-check"></i> <span lang="es">Aprobar versión</span></a>
												<!---<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=approveFileVersion&file_id=#objectFile.id#&fileTypeId=#fileTypeId#&area_id=#area_id#&approve=false&return_path=#return_path#" onclick="return confirmApproveFile(false);" class="btn btn-danger btn-sm"><i class="icon-remove-sign"></i> <span lang="es">Rechazar versión</span></a>--->
												<a href="file_reject_approval.cfm?file=#objectFile.id#&fileTypeId=#fileTypeId#&area=#area_id#&return_path=#return_path#" class="btn btn-danger btn-sm"><i class="icon-remove-sign"></i> <span lang="es">Rechazar versión</span></a>
											

										</cfif>

										<cfif version.revised IS false>
											<!--- cancelRevisionRequest --->
											
												<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=cancelRevisionRequest&file_id=#objectFile.id#&fileTypeId=#fileTypeId#&area_id=#area_id#&return_path=#return_path#" onclick="return confirmAction('cancelar el proceso de revisión');" class="btn btn-warning btn-sm"><i class="icon-undo"></i> <span lang="es">Cancelar revisión</span></a>
																			
										</cfif>

									</cfif>
								</div><!--- END panel-body --->
								
							</div><!--- END panel-warning --->

							<div class="div_file_page_label">
								<span lang="es">Fecha de envío a revisión</span> <span class="text_file_page">#version.revision_request_date#</span>
							</div>
							<cfif len(version.revision_date)>
							<div class="div_file_page_label">
								<span lang="es">Fecha de envío a revisión</span> <span class="text_file_page">#version.revision_date#</span>
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


				<cfif NOT isDefined("loggedUser")>
						
					<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="loggedUser">
						<cfinvokeargument name="user_id" value="#SESSION.user_id#">
					</cfinvoke>

				</cfif>

				<div class="div_file_page_label">
					<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="fileArea">
						<cfinvokeargument name="area_id" value="#objectFile.area_id#">
					</cfinvoke>--->

					<cfset file_area_allowed = false>

					<cfif loggedUser.internal_user IS false>
						
						<!---area_allowed--->
						<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="canUserAccessToArea" returnvariable="file_area_allowed">
							<cfinvokeargument name="area_id" value="#objectFile.area_id#">
						</cfinvoke>

					</cfif>

					<cfif loggedUser.internal_user IS true OR file_area_allowed>
						
						<b><span lang="es">Propiedad del área</span></b>
					
						<a onclick="openUrl('area_items.cfm?area=#objectFile.area_id#&file=#objectFile.id#','areaIframe',event)" style="cursorpointer">#objectFile.area_name#</a>

					</cfif>

				</div>

				<cfif objectFile.file_type_id IS 3 AND isNumeric(version.publication_area_id) AND isNumeric(version.publication_file_id)><!--- Published file --->

					<cfset file_publication_area_allowed = false>

					<cfif loggedUser.internal_user IS false>
						
						<!---area_allowed--->
						<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="canUserAccessToArea" returnvariable="file_publication_area_allowed">
							<cfinvokeargument name="area_id" value="#version.publication_area_id#">
						</cfinvoke>

					</cfif>

					<cfif loggedUser.internal_user IS true OR file_publication_area_allowed>

						<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="publicationArea">
							<cfinvokeargument name="area_id" value="#version.publication_area_id#">
						</cfinvoke>
						<div class="div_file_page_label"><span lang="es">Versión de archivo publicada en el área</span> <a onclick="openUrl('area_items.cfm?area=#version.publication_area_id#&file=#version.publication_file_id#','areaIframe',event)" style="cursor:pointer">#publicationArea.name#</a></div>

					</cfif>

				</cfif>

			</cfif><!--- END objectFile.file_type_id IS 2 OR objectFile.file_type_id IS 3 --->

			
			<!---<div class="div_file_page_user">#objectFile.user_full_name#</div>--->
		</cfif>
		<cfif objectFile.file_type_id IS NOT 1>
			<div class="div_file_page_label">
				<span lang="es"><cfif objectFile.file_type_id IS 2>Último reemplazo por<cfelse>Última version por</cfif></span>			
				<a href="area_user.cfm?area=#area_id#&user=#objectFile.replacement_user#">#objectFile.replacement_user_full_name#</a>
			</div>
		</cfif>
		<cfif objectFile.file_type_id IS 3>
			
			<div class="div_file_page_label">
				<span lang="es">Revisor</span> <a href="area_user.cfm?area=#area_id#&user=#objectFile.reviser_user#">#objectFile.reviser_user_full_name#</a>
			</div>

			<div class="div_file_page_label">
				<span lang="es">Aprobador</span> <a href="area_user.cfm?area=#area_id#&user=#objectFile.approver_user#">#objectFile.approver_user_full_name#</a>
			</div>

		</cfif>

		<div class="div_file_page_label"><span lang="es">Nombre de archivo</span></div>
		<div class="div_file_page_user">#objectFile.file_name#</div>
		
		<div class="div_file_page_label"><span lang="es">Fecha de creación</span> <span class="text_file_page">#objectFile.uploading_date#</span></div>
		<cfif len(objectFile.replacement_date) GT 0 OR objectFile.file_type_id IS NOT 3>	
		<div class="div_file_page_label"><span lang="es"><cfif objectFile.file_type_id IS 3>Fecha de última versión<cfelse>Fecha de reemplazo</cfif></span> <span class="text_file_page"><cfif len(objectFile.replacement_date) GT 0>#objectFile.replacement_date#<cfelse>-</cfif></span></div>
		</cfif>

		<cfif len(area_type) GT 0><!--- WEB --->

			<cfif len(objectFile.publication_date) GT 0>
				<div class="div_file_page_label"><span lang="es">Fecha de publicación</span> <span class="text_file_page">#objectFile.publication_date#</span>
				</div>
			</cfif>
			<cfif APPLICATION.publicationValidation IS true AND len(objectFile.publication_validated) GT 0>
				<div class="div_file_page_label"><span lang="es">Publicación aprobada</span> <span class="text_file_page" lang="es"><cfif objectFile.publication_validated IS true>Sí<cfelse><b>No</b></cfif></span>
				</div>
			</cfif>

		</cfif>
					
		
		<div class="div_file_page_label"><span lang="es">Tipo de archivo</span> <span class="text_file_page">#objectFile.file_type#</span></div>
		

		<cfif isNumeric(objectFile.file_size)>
			<!---fileUrl--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="trasnformFileSize" returnvariable="file_size">
				<cfinvokeargument name="file_size_full" value="#objectFile.file_size#">
			</cfinvoke>
		<cfelse>
			<cfset file_size = objectFile.file_size>
		</cfif>

		<!---<div class="div_file_page_size">--->
			<div class="div_file_page_label"><span lang="es">Tamaño</span> <span class="text_file_page">#file_size#</span></div>
		<!---</div>--->
		
		<div class="div_file_page_label"><span lang="es">Descripción</span></div>
		<div class="div_file_page_description">#objectFile.description#</div>

		<cfif APPLICATION.publicationScope IS true AND fileTypeId IS NOT 3>

			<div class="div_file_page_label"><span lang="es">Ámbito de publicación</span> <span class="text_message_page">#objectFile.publication_scope_name#</span></div>

		</cfif>


		<cfif APPLICATION.moduleAntiVirus IS true>

			<div class="div_file_page_label"><span lang="es"><cfif fileTypeId IS 3>Última versión de archivo analizada por Antivirus<cfelse>Analizado por Antivirus</cfif></span>
			<span class="text_message_page" lang="es"><cfif objectFile.anti_virus_check IS true>Sí<cfelse>No</cfif></span></div>

		</cfif>


		<div class="well well-sm" style="clear:both;">

			<!---fileUrl--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaFileUrl" returnvariable="areaFileUrl">
				<cfinvokeargument name="file_id" value="#objectFile.id#">
				<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
				<cfinvokeargument name="area_id" value="#area_id#">

				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			</cfinvoke>

			<div class="div_file_page_label"><span lang="es">URL para compartir el archivo con</span> <b lang="es">usuarios de #APPLICATION.title#</b>:</div>
			<div class="div_file_page_user"><input type="text" value="#areaFileUrl#" onClick="this.select();" class="form-control item_url_dp" readonly="readonly" style="cursor:text"/></div>

			<!---getDownloadFileUrl--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getDownloadFileUrl" returnvariable="downloadFileUrl">
				<cfinvokeargument name="file_id" value="#objectFile.id#">
				<cfinvokeargument name="fileTypeId" value="#fileTypeId#">

				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			</cfinvoke>

			<div class="div_file_page_label"><span lang="es">URL para enlazar a</span> <b lang="es">descargar el archivo desde #APPLICATION.title#</b>:</div>
			<div class="div_file_page_user"><input type="text" value="#downloadFileUrl#" onClick="this.select();" class="form-control item_url_dp" readonly="readonly" style="cursor:text"/></div>

			<!---<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-dropdowns-enhancement/css/dropdowns-enhancement.min.css" rel="stylesheet">
			<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-dropdowns-enhancement/js/dropdowns-enhancement.min.js"></script>

			<div class="dropdown">

			  <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
			    Obtener URL del archivo
			    <span class="caret"></span>
			  </button>

			  <ul class="dropdown-menu noclose" role="menu" aria-labelledby="dropdownMenu1">
			    <li role="presentation">
			    	<span lang="es">URL de <b>descarga</b> desde #APPLICATION.title#:</span><br/>
			    	<input type="text" value="#downloadFileUrl#" onClick="this.select();" class="form-control" readonly="readonly" style="cursor:text;width:400px;"/></li>
			    <li role="presentation">URL de desde #APPLICATION.title#:</span><br/>
			    	<input type="text" value="#downloadFileUrl#" onClick="this.select();" class="form-control" readonly="readonly" style="cursor:text;width:400px;"/></li>
			  </ul>

			</div>--->

			<!---<cfif SESSION.client_abb EQ "hcs">---><!---DoPlanning HCS--->

			<cfif (area_type EQ "web" OR area_type EQ "intranet") AND isDefined("webPath")>

				<!---fileWebUrl--->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getFileWebPage" returnvariable="filePage">
					<cfinvokeargument name="file_id" value="#objectFile.id#">
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>
				<cfset fileWebUrl = "/#webPath#/#filePage#">

				<div class="div_file_page_label"><span lang="es">URL</span> <b lang="es">relativa para enlazar el archivo en la #area_type#</b><cfif APPLICATION.publicationValidation IS true AND objectFile.publication_validated IS false>(publicación de archivo <b>no aprobada</b>)</cfif></span>:</div>
				<div class="div_file_page_user"><input type="text" value="#fileWebUrl#" onClick="this.select();" class="form-control item_url_dp" readonly="readonly" style="cursor:text"/></div>


			<cfelseif APPLICATION.publicationScope IS true AND ( SESSION.client_abb EQ "hcs" ) AND ( objectFile.publication_scope_id IS 2 OR objectFile.publication_scope_id IS 3 )><!--- Scope IS Web OR Intranet --->

				<!--- Permite que se muestre esta URL para los archivos que tienen asociado el ámbito WEB o INTRANET --->

				<cfif objectFile.publication_scope_id IS 2>
					<cfset webPath = "intranet">
				<cfelse>
					<cfset webPath = "web">
				</cfif>

				<!---fileWebUrl--->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getFileWebPage" returnvariable="filePage">
					<cfinvokeargument name="file_id" value="#objectFile.id#">
				</cfinvoke>
				<cfset fileWebUrl = "/#webPath#/#filePage#">

				<div class="div_file_page_label"><span lang="es">URL relativa para</span> <b lang="es">enlazar el archivo en la #webPath#</b>:</div>
				<div class="div_file_page_user"><input type="text" value="#fileWebUrl#" onClick="this.select();" class="form-control item_url_dp" readonly="readonly" style="cursor:text"/></div>

			</cfif>

			<!---</cfif>--->

			<cfif (fileTypeId IS 1 OR fileTypeId IS 2) AND objectFile.public IS true>

				<!---fileWebUrl--->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getFilePublicUrl" returnvariable="filePublicUrl">
					<cfinvokeargument name="file_public_id" value="#objectFile.file_public_id#">

					<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				</cfinvoke>
				
				<div class="div_file_page_label"><span lang="es">URL pública para</span> <b lang="es">compartir el archivo con cualquier usuario</b>:</div>
				<div class="div_file_page_user"><input type="text" value="#filePublicUrl#" onClick="this.select();" class="form-control item_url_dp" readonly="readonly" style="cursor:text"/></div>

			</cfif>


		</div><!--- END well well-sm --->

		 
		<!---
		<div style="clear:both">

			<button class="btn btn-default btn-sm" type="button" id="showFilesUrls" data-toggle="collapse" data-target="##fileUrlsContainer" aria-expanded="false" aria-controls="fileUrlsContainer">
			  <i class="icon-expand-alt" style="font-size:16px;"></i> Mostrar URLs del archivo
			</button>

			<button class="btn btn-default btn-sm" type="button" id="hideFilesUrls" data-toggle="collapse" data-target="##fileUrlsContainer" aria-expanded="false" aria-controls="fileUrlsContainer" style="display:none">
			  <i class="icon-collapse-alt" style="font-size:16px;"></i> Ocultar URLs del archivo
			</button>

			<div class="collapse" id="fileUrlsContainer">

			</div>
				
		</div>

		<script>

			$('##fileUrlsContainer').on('hidden.bs.collapse', function () {
				$('##showFilesUrls').show();
				$('##hideFilesUrls').hide();

			});

			$('##fileUrlsContainer').on('shown.bs.collapse', function () {
				$('##showFilesUrls').hide();
				$('##hideFilesUrls').show();
			});			

		</script>

		--->
			
		<!---Typology--->
		<cfif APPLICATION.modulefilesWithTables IS true>
			
			<!---Typology fields--->
			<!---<cfset table_id = objectFile.typology_id>
			<cfset tableTypeId = 3>
			<cfset row_id = objectFile.typology_row_id>--->

			<cfif isNumeric(table_id) AND isNumeric(row_id)>
				
				<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getRow" returnvariable="getRowResponse">
					<cfinvokeargument name="table_id" value="#table_id#"/>
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#"/>
					<cfinvokeargument name="row_id" value="#row_id#"/>
					<cfinvokeargument name="file_id" value="#objectFile.id#"/>
				</cfinvoke>
				<cfset table = getRowResponse.table>
				<cfset row = getRowResponse.row>--->

				<div class="div_file_page_label"><span lang="es">Tipología</span> <span class="text_message_page"><span class="label label-default" style="font-size:11px">#table.title#</span></span></div>

				<!---<cfinclude template="#APPLICATION.htmlPath#/includes/table_row_content_fields.cfm">--->

				<!---outputRowContent--->
				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="outputRowContent">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="row" value="#row#">
					<cfinvokeargument name="fields" value="#fields#">
					<cfinvokeargument name="file_id" value="#file_id#"/>
				</cfinvoke>
				
			</cfif>

		</cfif>
	<!--- </div> --->

				</div><!--- END col-sm-12 --->

			</div><!--- END row --->

		</div><!--- END panel-body --->

	</div><!--- END panel panel-default --->
</cfoutput>

<div id="convert_file_loading" style="position:absolute; width:100%; height:94%; top:0px; background-color:#EEEEEE; text-align:center; padding-top:90px; display:none;">
<cfoutput>
<div class="alert"><span lang="es">Generando archivo...</span></div>
<!---<div style="margin:auto; text-align:center; padding-top:30px;">
<img src="#APPLICATION.path#/html/assets/icons/loading.gif" alt="Cargando" />
</div>--->
</cfoutput>
</div>

<cfif isDefined("URL.download") AND URL.download IS true>
	<cfoutput>
	<iframe style="display:none" src="#APPLICATION.htmlPath#/file_download.cfm?id=#file_id#"></iframe>
	</cfoutput>
</cfif>


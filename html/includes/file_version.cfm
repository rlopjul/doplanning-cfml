<cfset fileTypeId = 3>

<cfif isDefined("URL.file_version") AND isNumeric(URL.file_version)>
	<cfset version_id = URL.file_version>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>

<!--- getFileVersion --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFileVersion" returnvariable="version">
	<cfinvokeargument name="version_id" value="#version_id#">
	<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
</cfinvoke>

<!--- getFile --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
	<cfinvokeargument name="file_id" value="#version.file_id#">
	<cfinvokeargument name="fileTypeId" value="#fileTypeId#"/>
</cfinvoke>

<cfset area_id = objectFile.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>
<script src="#APPLICATION.htmlPath#/language/file_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<script type="text/javascript">

function confirmDuplicateVersion() {
	
	var messageDuplicate = "¿Seguro que desea duplicar y marcar esta versión como vigente?";
	
	return confirm(messageDuplicate);
}

function confirmDeleteFileVersion() {
		
	var messageDelete = window.lang.translate("Si ELIMINA la versión, se borrará definitivamente. ¿Seguro que desea borrar esta versión?");
	return confirm(messageDelete);
}

</script>

<cfif app_version NEQ "html2">
<div class="div_head_subtitle">
Versión de archivo
</div>
</cfif>

<cfoutput>
<div class="div_file_page_name">#version.file_name#</div>
<div class="div_separator"><!-- --></div>

<div class="div_elements_menu"><!---div_elements_menu--->
	
	<a href="#APPLICATION.htmlPath#/file_version_download.cfm?id=#version.version_id#" onclick="return downloadFileLinked(this,event)" class="btn btn-sm btn-info"><i class="icon-download-alt"></i> <span lang="es">Descargar</span></a>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getLastFileVersion" returnvariable="lastVersion">
		<cfinvokeargument name="file_id" value="#version.file_id#">
		<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
	</cfinvoke>

	<cfif objectFile.in_approval IS false AND objectFile.locked IS true AND objectFile.lock_user_id IS SESSION.user_id>

		<cfif lastVersion.version_id NEQ version_id OR ( len(version.revision_request_date) GT 0 AND version.approved IS NOT true )>

			<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=duplicateFileVersion&file_id=#objectFile.id#&fileTypeId=#fileTypeId#&version_id=#version_id#&return_path=#return_path#" onclick="return confirmDuplicateVersion();" class="btn btn-warning btn-sm"><i class="icon-copy"></i> <span lang="es">Duplicar y definir como versión vigente</span></a>

		</cfif>
		
	</cfif>

	<cfif SESSION.client_abb NEQ "hcs">
		<cfif version.approved IS NOT true AND version.revised IS NOT true AND objectFile.locked IS false AND lastVersion.version_id NEQ version_id AND version.user_in_charge EQ SESSION.user_id>
			<a href="#APPLICATION.htmlComponentsPath#/File.cfc?method=deleteFileVersionRemote&file_id=#objectFile.id#&version_id=#version_id#&return_path=#return_path#" onclick="return confirmDeleteFileVersion();" class="btn btn-danger btn-sm"><i class="icon-remove"></i> <span lang="es">Eliminar versión</span></a>
		</cfif>
	</cfif>
	

</div>
</cfoutput>

<cfoutput>

	<div class="div_file_page_file">

		<cfif version.revised IS true>
			
			<!--- outputFileVersionStatus --->
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="outputFileVersionStatus">
				<cfinvokeargument name="version" value="#version#">
			</cfinvoke>

			<!---<cfif version.revision_result IS false>
				<div class="div_file_page_label"><span lang="es">Motivo de rechazo en revisión:</span><br> 
				<span class="text_file_page">#version.revision_result_reason#</span></div>	
			</cfif>

			<cfif version.approved IS false>
				<div class="div_file_page_label"><span lang="es">Motivo de rechazo en aprobación:</span><br>
				<span class="text_file_page">#version.approval_result_reason#</span></div>	
			</cfif>--->

		<cfelse>
			<div>
				<cfif len(version.revision_request_date) GT 0>
					<div class="label label-warning">Versión de archivo enviada a revisión</div>
				<cfelse>
					<div class="label label-info">Versión no revisada</div>
				</cfif>
			</div>
		</cfif>

		<cfif isNumeric(version.publication_area_id) AND isNumeric(version.publication_file_id)>

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="publicationArea">
				<cfinvokeargument name="area_id" value="#version.publication_area_id#">
			</cfinvoke>
			<div class="div_file_page_label"><span lang="es">Archivo publicado en el área:</span> <a onclick="openUrl('area_items.cfm?area=#version.publication_area_id#&file=#version.publication_file_id#','areaIframe',event)" style="cursor:pointer">#publicationArea.name#</a></div>

		</cfif>
		<cfif len(version.revision_request_date) GT 0>
			<div class="div_file_page_label"><span lang="es">Fecha de envío a revisión:</span> <span class="text_file_page">#version.revision_request_date#</span></div>	
		</cfif>

		<cfif len(version.revision_date) GT 0>
			<div class="div_file_page_label"><span lang="es">Fecha de revision:</span> <span class="text_file_page">#version.revision_date#</span></div>	
		</cfif>

		<cfif len(version.approval_request_date) GT 0>
			<div class="div_file_page_label"><span lang="es">Fecha de envío a aprobación:</span> <span class="text_file_page">#version.approval_request_date#</span></div>	
		</cfif>

		<cfif len(version.approval_date) GT 0>
			<div class="div_file_page_label"><span lang="es">Fecha de aprobación:</span> <span class="text_file_page">#version.approval_date#</span></div>	
		</cfif>


		<div class="div_file_page_label">
			<a href="area_user.cfm?area=#area_id#&user=#version.user_in_charge#">
			<cfif len(version.user_image_type) GT 0>
				<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#version.user_in_charge#&type=#version.user_image_type#&small=" alt="#version.user_full_name#" class="item_img" style="margin-right:2px;"/>									
			<cfelse>						
				<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#version.user_full_name#" class="item_img_default" style="margin-right:2px;"/>
			</cfif></a> <a href="area_user.cfm?area=#area_id#&user=#objectFile.user_in_charge#">#objectFile.user_full_name#</a>
		</div>

		<div class="div_file_page_label"><span lang="es">Fecha de subida:</span> <span class="text_file_page">#version.uploading_date#</span></div>	
		
		<div class="div_file_page_label"><span lang="es">Tipo de archivo:</span> <span class="text_file_page">#version.file_type#</span></div>
		
		<!---fileUrl--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="trasnformFileSize" returnvariable="file_size">
			<cfinvokeargument name="file_size_full" value="#version.file_size#">
		</cfinvoke>
		
		<div class="div_file_page_size"><div class="div_file_page_label"><span lang="es">Tamaño:</span> <span class="text_file_page">#file_size#</span></div></div>
		
		<!---<div class="div_file_page_label"><span lang="es">Descripción:</span></div>
		<div class="div_file_page_description">#version.description#</div>--->

		<!---fileUrl--->
		<!---
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaFileUrl" returnvariable="areaFileUrl">
			<cfinvokeargument name="file_id" value="#objectFile.id#">
			<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
			<cfinvokeargument name="area_id" value="#area_id#">

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>

		<div class="div_message_page_label"><span lang="es">URL en #APPLICATION.title#:</span></div>
		<input type="text" value="#areaFileUrl#" onClick="this.select();" class="form-control" readonly="readonly" style="cursor:text"/>--->

	</div>
</cfoutput>
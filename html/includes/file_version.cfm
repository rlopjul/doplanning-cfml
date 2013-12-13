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

<!---<script type="text/javascript">

function confirmDeleteFile() {
	
	var messageDelete = window.lang.convert("Si ELIMINA el archivo, se borrará de definitivamente y podrá ser recuperado. ¿Seguro que desea borrar el archivo?");
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

</script>--->

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
		
</div>
</cfoutput>

<cfoutput>

	<div class="div_file_page_file">

		<cfif version.revised IS true>
			
			<!--- outputFileVersionStatus --->
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="outputFileVersionStatus">
				<cfinvokeargument name="version" value="#version#">
			</cfinvoke>

		<cfelse>
			<div>
				<div class="label label-info">Versión no revisada</div>
			</div>
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
		</cfinvoke>

		<div class="div_message_page_label"><span lang="es">URL en DoPlanning:</span></div>
		<input type="text" value="#areaFileUrl#" onClick="this.select();" class="input-block-level" readonly="readonly" style="cursor:text"/>--->

	</div>
</cfoutput>
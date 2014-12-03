<cfoutput>
<div class="div_file_page_name">
<cfif fileTypeId IS 1><!--- User file --->
	<img src="#APPLICATION.htmlPath#/assets/icons/file.png" alt="Archivo" title="Archivo"/>
<cfelseif fileTypeId IS 2><!--- Area file --->
	<cfif objectFile.locked IS true>
		<img src="#APPLICATION.htmlPath#/assets/icons/file_area_locked.png" alt="Archivo del área bloqueado" title="Archivo del área bloqueado"/>
	<cfelse>
		<img src="#APPLICATION.htmlPath#/assets/icons/file_area.png" alt="Archivo del área" title="Archivo del área"/>
	</cfif>
<cfelseif fileTypeId IS 3>
	<cfif objectFile.locked IS true>
		<img src="#APPLICATION.htmlPath#/assets/icons/file_edited_locked.png" alt="Archivo del área en edición" title="Archivo del área bloqueado"/>
	<cfelse>
		<img src="#APPLICATION.htmlPath#/assets/icons/file_edited.png" alt="Archivo del área en edición" title="Archivo del área en edición"/>
	</cfif>
</cfif>

 #objectFile.name#</div>
<div class="div_separator"><!-- --></div>
</cfoutput>
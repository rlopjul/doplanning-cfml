<cfif isDefined("URL.file")>
	<cfset file_id = URL.file>
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>

<cfif app_version NEQ "html2">
<div class="div_head_subtitle">
Archivo
</div>
</cfif>
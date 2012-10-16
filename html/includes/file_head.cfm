<cfif isDefined("URL.file")>
	<cfset file_id = URL.file>
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>

<div class="div_head_subtitle">
Archivo
</div>
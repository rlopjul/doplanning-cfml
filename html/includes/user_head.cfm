<cfif isDefined("URL.user")>
	<cfset user_id = URL.user>
<cfelse>
	<cflocation url="index.cfm" addtoken="no">
</cfif>

<div class="div_head_subtitle">
Usuario
</div>
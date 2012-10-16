<cfif isDefined("URL.file")>
	<cfset redirect_page = "area_file.cfm?file=#URL.file#&area=#URL.area#">
<cfelseif isDefined("URL.message")>
	<cfset redirect_page = "message.cfm?message=#URL.message#">
<cfelseif isDefined("URL.entry")>
	<cfset redirect_page = "entry.cfm?entry=#URL.entry#">
<cfelseif isDefined("URL.link")>
	<cfset redirect_page = "link.cfm?link=#URL.link#">
<cfelseif isDefined("URL.news")>
	<cfset redirect_page = "news.cfm?news=#URL.news#">
<cfelseif isDefined("URL.event")>
	<cfset redirect_page = "event.cfm?event=#URL.event#">
</cfif>
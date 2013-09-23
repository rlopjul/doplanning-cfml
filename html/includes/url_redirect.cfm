<cfif isDefined("URL.file")>
	<cfset redirect_page = "file.cfm?file=#URL.file#&area=#URL.area#">
	<!---<cfset redirect_area_page = "files.cfm?file=#URL.file#&area=#URL.area#">--->
	<cfset redirect_area_page = "area_items.cfm?file=#URL.file#&area=#URL.area#">
<cfelseif isDefined("URL.message")>
	<cfset redirect_page = "message.cfm?message=#URL.message#">
	<!---<cfset redirect_area_page = "messages.cfm?message=#URL.message#&area=#URL.area#">--->
	<cfset redirect_area_page = "area_items.cfm?message=#URL.message#&area=#URL.area#">
<cfelseif isDefined("URL.entry")>
	<cfset redirect_page = "entry.cfm?entry=#URL.entry#">
	<!---<cfset redirect_area_page = "entries.cfm?entry=#URL.entry#&area=#URL.area#">--->
	<cfset redirect_area_page = "area_items.cfm?entry=#URL.entry#&area=#URL.area#">
<cfelseif isDefined("URL.link")>
	<cfset redirect_page = "link.cfm?link=#URL.link#">
	<!---<cfset redirect_area_page = "links.cfm?link=#URL.link#&area=#URL.area#">--->
	<cfset redirect_area_page = "area_items.cfm?link=#URL.link#&area=#URL.area#">
<cfelseif isDefined("URL.news")>
	<cfset redirect_page = "news.cfm?news=#URL.news#">
	<!---<cfset redirect_area_page = "newss.cfm?news=#URL.news#&area=#URL.area#">--->
	<cfset redirect_area_page = "area_items.cfm?news=#URL.news#&area=#URL.area#">
<cfelseif isDefined("URL.event")>
	<cfset redirect_page = "event.cfm?event=#URL.event#">
	<!---<cfset redirect_area_page = "events.cfm?event=#URL.event#&area=#URL.area#">--->
	<cfset redirect_area_page = "area_items.cfm?event=#URL.event#&area=#URL.area#">
<cfelseif isDefined("URL.task")>
	<cfset redirect_page = "task.cfm?task=#URL.task#">
	<!---<cfset redirect_area_page = "tasks.cfm?task=#URL.task#&area=#URL.area#">--->
	<cfset redirect_area_page = "area_items.cfm?task=#URL.task#&area=#URL.area#">
<cfelseif APPLICATION.moduleConsultations AND isDefined("URL.consultation")>
	<cfset redirect_page = "consultation.cfm?consultation=#URL.consultation#">
	<!---<cfset redirect_area_page = "consultations.cfm?consultation=#URL.consultation#&area=#URL.area#">--->
	<cfset redirect_area_page = "area_items.cfm?consultation=#URL.consultation#&area=#URL.area#">
<cfelseif APPLICATION.moduleLists IS true AND isDefined("URL.list")>
	<cfset redirect_page = "list.cfm?list=#URL.list#">
	<cfset redirect_area_page = "area_items.cfm?list=#URL.list#&area=#URL.area#">
</cfif>
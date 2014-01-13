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
<cfelseif isDefined("URL.image")>
	<cfset redirect_page = "image.cfm?image=#URL.image#">
	<cfset redirect_area_page = "area_items.cfm?image=#URL.image#&area=#URL.area#">
<cfelseif isDefined("URL.file_edited")>
	<cfset redirect_page = "file_edited.cfm?file_edited=#URL.file_edited#">
	<cfset redirect_area_page = "area_items.cfm?file_edited=#URL.file_edited#&area=#URL.area#">
<cfelseif APPLICATION.moduleConsultations AND isDefined("URL.consultation")>
	<cfset redirect_page = "consultation.cfm?consultation=#URL.consultation#">
	<!---<cfset redirect_area_page = "consultations.cfm?consultation=#URL.consultation#&area=#URL.area#">--->
	<cfset redirect_area_page = "area_items.cfm?consultation=#URL.consultation#&area=#URL.area#">
<cfelseif APPLICATION.modulePubMedComments IS true AND isDefined("URL.pubmed")>
	<cfset redirect_page = "pubmed.cfm?pubmed=#URL.pubmed#">
	<cfset redirect_area_page = "area_items.cfm?pubmed=#URL.pubmed#&area=#URL.area#">
<cfelseif APPLICATION.moduleLists IS true AND isDefined("URL.list")>
	<cfif isDefined("URL.row")>
		<cfset redirect_page = "list_row.cfm?list=#URL.list#&row=#URL.row#">
		<cfset redirect_area_page = "list_rows.cfm?list=#URL.list#&row=#URL.row#&area=#URL.area#">
	<cfelse>
		<cfset redirect_page = "list.cfm?list=#URL.list#">
		<cfset redirect_area_page = "area_items.cfm?list=#URL.list#&area=#URL.area#">
	</cfif>
<cfelseif APPLICATION.moduleForms IS true AND isDefined("URL.form")>
	<cfif isDefined("URL.row")>
		<cfset redirect_page = "form_row.cfm?form=#URL.form#&row=#URL.row#">
		<cfset redirect_area_page = "form_rows.cfm?form=#URL.form#&row=#URL.row#&area=#URL.area#">
	<cfelse>
		<cfset redirect_page = "form.cfm?form=#URL.form#">
		<cfset redirect_area_page = "area_items.cfm?form=#URL.form#&area=#URL.area#">
	</cfif>
<cfelseif APPLICATION.modulefilesWithTables IS true AND isDefined("URL.typology")>
	<cfset redirect_page = "typology.cfm?typology=#URL.typology#">
	<cfset redirect_area_page = "typologies.cfm?typology=#URL.typology#&area=#URL.area#">
</cfif>
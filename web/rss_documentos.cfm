<cfif APPLICATION.identifier EQ "dp"><!---DP--->
	<cfset clientAbb = "software7">
	<cfset rootAreaId = 232>
<cfelse><!---ASNC--->
	<cfset clientAbb = "asnc">
	<cfset rootAreaId = 491>
</cfif>
<cfset clientDsn = APPLICATION.identifier&"_"&clientAbb>
<cfset areaTypeRequired = "web">

<cfinclude template="../templates_pages/rss_files_query.cfm">

<cfset source_page_url = "#base_url#rss_documentos.cfm">
<cfset rss_title = "ASNC - Documentos del portal">

<cfset itemTypeId = 10><!---Documentos--->

<cfinclude template="../templates_pages/rss_items_content.cfm">
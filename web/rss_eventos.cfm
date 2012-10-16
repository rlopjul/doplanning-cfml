<cfif APPLICATION.identifier EQ "dp"><!---DP--->
	<cfset clientAbb = "software7">
	<cfset rootAreaId = 232>
<cfelse><!---ASNC--->
	<cfset clientAbb = "asnc">
	<cfset rootAreaId = 491>
</cfif>
<cfset clientDsn = APPLICATION.identifier&"_"&clientAbb>
<cfset areaTypeRequired = "web">

<cfset itemTypeId = 5><!---Eventos--->

<cfinclude template="../templates_pages/rss_items_query.cfm">

<cfset source_page_url = "#base_url#rss_eventos.cfm">
<cfset rss_title = "ASNC - Eventos del portal">

<cfinclude template="../templates_pages/rss_items_content.cfm">
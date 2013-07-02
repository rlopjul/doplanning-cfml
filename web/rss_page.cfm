<cfif APPLICATION.identifier EQ "dp"><!---DP--->
	<cfset clientAbb = "software7">
	<cfset rootAreaId = 232>
<cfelse><!---ASNC--->
	<cfset clientAbb = "asnc">
	<cfset rootAreaId = 491>
</cfif>
<cfset clientDsn = APPLICATION.identifier&"_"&clientAbb>
<cfset areaTypeRequired = "web">


<cfsetting enablecfoutputonly="yes">
<cfinclude template="#APPLICATION.path#/templates_pages/page_query.cfm">

<!---AreaItems--->
<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="listAllAreaWebItems" returnvariable="items">
	<cfinvokeargument name="area_id" value="#area_id#">
					
	<cfinvokeargument name="client_abb" value="#clientAbb#">
	<cfinvokeargument name="client_dsn" value="#clientDsn#">
</cfinvoke>

<cfif APPLICATION.identifier EQ "dp"><!---DP--->
	<cfset base_url = "#APPLICATION.mainUrl#/#areaTypeRequired#/">
<cfelse><!---ASNC--->
	<cfif CGI.HTTP_HOST IS "10.72.32.24">
		<cfset base_url = "http://10.72.32.24/servicioandaluzdesalud/asnc/colabora/beta/#areaTypeRequired#/">
	<cfelse>
		<cfset base_url = "#APPLICATION.alternateUrl#/#areaTypeRequired#/">
	</cfif>
</cfif>

<cfset source_page_url = "#base_url#page.cfm?id=#area_id#">
<cfset rss_title = "ASNC - #area_name#">

<cfinclude template="../templates_pages/rss_items_content.cfm">
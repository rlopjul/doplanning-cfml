<cfset clientAbb = "asnc">
<cfset clientDsn = APPLICATION.identifier&"_"&clientAbb>
<cfset rootAreaId = 464>
<cfset areaTypeRequired = "intranet">

<cfinclude template="#APPLICATION.path#/templates_pages/generate_pdf.cfm">
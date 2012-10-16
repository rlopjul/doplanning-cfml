<cfif APPLICATION.identifier EQ "dp"><!---DP--->
	<cfset clientAbb = "software7">
	<cfset rootAreaId = 232>
<cfelse><!---ASNC--->
	<cfset clientAbb = "asnc">
	<cfset rootAreaId = 491>
</cfif>
<cfset clientDsn = APPLICATION.identifier&"_"&clientAbb>
<cfset areaTypeRequired = "web">

<cfinclude template="../templates_pages/download_file.cfm">
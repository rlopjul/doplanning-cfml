<cfinclude template="area_id.cfm">

<cfinclude template="area_checks.cfm">

<cfif NOT isDefined("includeAppMenu") OR includeAppMenu IS true>
	<cfinclude template="area_menu.cfm">
</cfif>

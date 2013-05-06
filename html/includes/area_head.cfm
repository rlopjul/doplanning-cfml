<cfinclude template="area_id.cfm">

<cfinclude template="area_checks.cfm">

<cfif app_version NEQ "html2"><!---ESTO ES PARA QUE NO SE MUESTRE EL MENU EN iframes2--->
	<cfinclude template="area_menu.cfm">
</cfif>
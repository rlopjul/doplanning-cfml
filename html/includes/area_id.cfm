<cfif NOT isDefined("area_id")>
	<cfif isDefined("URL.area") AND isValid("integer",URL.area)>
	
		<cfset area_id = URL.area>
	
	<cfelse>
	
		<cflocation url="area.cfm" addtoken="no">
	
	</cfif>
</cfif>
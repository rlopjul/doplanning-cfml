<!--- ORDER --->
<cfif isDefined("arguments.order_by")>
	
	<cfif arguments.order_by EQ "user_id">
		<cfset order_by = "id">
	</cfif>
	
<cfelse>

	<cfset order_by = "name">
	<cfset order_type = "asc">

</cfif>
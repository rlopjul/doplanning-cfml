<!--- ORDER --->
<cfif isDefined("xmlRequest.request.parameters.order")>

	<cfset order_by = xmlRequest.request.parameters.order.xmlAttributes.parameter>
	
	<cfif order_by EQ "user_id">
		<cfset order_by = "id">
	</cfif>
	
	<cfset order_type = xmlRequest.request.parameters.order.xmlAttributes.order_type>

<cfelse>

	<cfset order_by = "name">
	<cfset order_type = "asc">

</cfif>
<cfif NOT isDefined("method")>
	<cfset method = "undefined">
</cfif>
<cfset xmlResponseContent = "undefined">

<cfif isDefined("client_abb")>
	<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>
</cfif>

<cfif isDefined("arguments.request") AND arguments.request NEQ "">				
	<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="xmlRequest" returnvariable="xmlRequest">
		<cfinvokeargument name="request" value="#arguments.request#">
	</cfinvoke>
</cfif>
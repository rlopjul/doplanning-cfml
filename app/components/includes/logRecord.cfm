<cfif isDefined("arguments.request")>
	<cfset log_content = arguments.request>
<cfelse>
	<cfset log_content = "No request passed to this function">
</cfif>
<cfinvoke component="#APPLICATION.componentsPath#/LogManager" method="saveLog">
	<cfinvokeargument name="log_component" value="#component#" >
	<cfinvokeargument name="log_method" value="#method#">
	<cfinvokeargument name="log_content" value="#log_content#">
</cfinvoke>
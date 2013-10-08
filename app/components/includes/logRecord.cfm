<!---<cfif isDefined("arguments.request")>
	<cfset log_content = arguments.request>
<cfelse>
	<cfset log_content = "No request passed to this function">
</cfif>--->
<cfif isDefined("arguments.request")>
	<cfset log_content = arguments.request>
<cfelse>
	<!---<cfwddx action="cfml2wddx" input="#arguments#" output="wddxText" usetimezoneinfo="false">
	<cfset log_content = wddxText>--->
	<cfset log_content = SerializeJSON(arguments)>
</cfif>
<cfinvoke component="#APPLICATION.componentsPath#/LogManager" method="saveLog">
	<cfinvokeargument name="log_component" value="#component#" >
	<cfinvokeargument name="log_method" value="#method#">
	<cfinvokeargument name="log_content" value="#log_content#">
</cfinvoke>
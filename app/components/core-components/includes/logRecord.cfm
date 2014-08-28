<cfset log_content = SerializeJSON(arguments)>

<cfinvoke component="#APPLICATION.coreComponentsPath#/LogManager" method="saveLog">
	<cfinvokeargument name="log_component" value="#component#" >
	<cfinvokeargument name="log_method" value="#method#">
	<cfinvokeargument name="log_content" value="#log_content#">

	<cfif isDefined("user_id")>
		<cfinvokeargument name="user_id" value="#user_id#">
	</cfif>
	<cfinvokeargument name="client_abb" value="#client_abb#">
</cfinvoke>
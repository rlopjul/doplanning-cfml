<!---Copyright Era7 Information Technologies 2007-2014--->

<cfcomponent output="false">

	<cfset component = "Client">


	<!--- ----------------------------------- getClient ------------------------------------- --->
	
	<!---Este método NO hay que usarlo en páginas en las que su contenido se cague con JavaScript (páginas de html_content) porque si hay un error este método redirige a otra página. En esas páginas hay que obtener el Area directamente del ClientManager y comprobar si result es true o false para ver si hay error y mostrarlo correctamente--->
	
	<cffunction name="getClient" output="false" returntype="query" access="public">
		<cfargument name="client_abb" type="string" required="true">
		
		<cfset var method = "getClient">
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/ClientManager" method="getClient" returnvariable="getClientResponse">				
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn getClientResponse.client>
		
	</cffunction>


	<!--- ----------------------------------- updateClientAdminOptions -------------------------------------- --->

	<cffunction name="updateClientAdminOptions" output="false" returntype="struct" returnformat="json" access="remote">
		<cfargument name="default_language" type="string" required="true">
		<cfargument name="force_notifications" type="boolean" required="false" default="false">
		<cfargument name="tasks_reminder_notifications" type="boolean" required="false" default="false">
		<cfargument name="tasks_reminder_days" type="numeric" required="true">
		
		<cfset var method = "force_notifications">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/ClientManager" method="updateClientAdminOptions" returnvariable="response">
				<cfinvokeargument name="default_language" value="#arguments.default_language#">
				<cfinvokeargument name="force_notifications" value="#arguments.force_notifications#">
				<cfinvokeargument name="tasks_reminder_notifications" value="#arguments.tasks_reminder_notifications#">
				<cfinvokeargument name="tasks_reminder_days" value="#arguments.tasks_reminder_days#">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Opciones modificadas">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>

</cfcomponent>
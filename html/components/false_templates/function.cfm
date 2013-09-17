<!--- 
Ejemplos de este tipo
Area/getMainTree 
--->
<cffunction name="" output="false"  returntype="struct" access="public">
	
	<cfset var method = "functionName">
	
	<cfset var response = structNew()>	
		
	<cftry>
		
		
		<!---Para gestión de respuesta por defecto
		<cfinclude template="includes/responseHandlerStruct.cfm">--->

		<cfinclude template="includes/responseHandlerStructNoRedirect.cfm">

		<cfcatch>
			<!---Para gestión de errores por defecto
			<cfinclude template="includes/errorHandlerStruct.cfm">--->

			<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
		</cfcatch>										
		
	</cftry>
	
	<cfreturn response>
	
</cffunction>



<!--- 
Ejemplos de este tipo
Area/createArea
Area/deleteArea
User/assignUserToArea 
--->
<cffunction name="" output="false" returntype="struct" returnformat="json" access="remote">
	
	<cfset var method = "functionName">

	<cfset var response = structNew()>
				
	<cftry>

		
		<cfif response.result IS true>
			<cfset response.message = "Mensaje de respuesta en español">
		</cfif>

		<cfcatch>
			<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
		</cfcatch>										
		
	</cftry>
	
	<cfreturn response>
		
</cffunction>
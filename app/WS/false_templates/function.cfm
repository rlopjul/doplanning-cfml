<!---NOTAS:
	-Las funciones que son public deben ser llamadas por otras funciones de ColdFusion que serán remote, por lo que las funciones public no tendrán try-catch, ya que son las funciones que las llaman las que gestionan los errores, y serán las que tienen el try-catch y se encargan de gestionar los errores.
--->

<cffunction name="" output="false" returntype="string" access="remote">
	<cfargument name="request" type="string" required="yes">
	
	<cfset var method = "">
	
	<!---<cfinclude template="includes/initVars.cfm">--->	
		
	<cftry>
		
		<cfinclude template="includes/functionStart.cfm">
		
		<cfinclude template="includes/checkAreaAccess.cfm">
		
		<cfinclude template="includes/checkAreaAdminAccess.cfm">
		
		<cfinclude template="includes/checkAdminAccess.cfm">
		
		
		
		<cfset xmlResponseContent = arguments.request>
		
		<cfinclude template="includes/functionEndNoLog.cfm">
		
		<cfcatch>
			<cfset xmlResponseContent = arguments.request>
			<cfinclude template="includes/errorHandler.cfm">
		</cfcatch>										
		
	</cftry>
	
	<cfreturn xmlResponse>
	
</cffunction>
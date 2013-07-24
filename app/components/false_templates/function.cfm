<!--- 
Ejemplos de este tipo
AreaManager/getMainTree 
AreaManager/createArea
AreaManager/updateArea
UserManager/assignUserToArea
UserManager/dissociateUserFromArea
--->
<cffunction name="" output="false" returntype="struct" access="public">
	<cfargument name="argument_1" type="numeric" required="true">
	<cfargument name="argument_2" type="string" required="true">
	
	<cfset var method = "functionName">

	<cfset response = structNew()>
			
	<cftry>
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
		<cfinclude template="includes/checkAreaAccess.cfm">
		
		<cfinclude template="includes/checkAreaAdminAccess.cfm">
		
		<cfinclude template="includes/checkAdminAccess.cfm">
		
		



		
		<cfinclude template="includes/functionEndOnlyLog.cfm">

		<cfset response = {result=true, message="", argument_response_1=#arg_res_1#, argument_response_2=#arg_res_2#}>
		
		<cfcatch>

			<cfinclude template="includes/errorHandlerStruct.cfm">

		</cfcatch>
	</cftry>
	
	<cfreturn response>
	
</cffunction>
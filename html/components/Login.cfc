<!---Copyright Era7 Information Technologies 2007-2014

    File created by: alucena
    ColdFusion version required: 8

--->
<cfcomponent output="false">

	<cfset component = "Login">
	<cfset request_component = "LoginManager">

	
	<!--- GET USER LOGGED --->
	
	<cffunction name="getUserLoggedIn" returntype="query" output="false" access="public">
		
		<cfset var method = "getUserLoggedIn">
		
		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/LoginManager" method="getUserLoggedIn" returnvariable="response">
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.user>
		
	</cffunction>
	
	
</cfcomponent>
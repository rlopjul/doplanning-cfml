<!---Copyright Era7 Information Technologies 2007-2014--->

<cfcomponent output="false">

	<cfset component = "Scope">


	<!--- ----------------------------------- getScopes ------------------------------------- --->
	
	<!---Este método NO hay que usarlo en páginas en las que su contenido se cague con JavaScript (páginas de html_content) porque si hay un error este método redirige a otra página. En esas páginas hay que obtener el Area directamente del ScopeManager y comprobar si result es true o false para ver si hay error y mostrarlo correctamente--->
	
	<cffunction name="getScopes" output="false" returntype="struct" access="public">
		
		<cfset var method = "getScopes">

		<cfset var response = structNew()>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/ScopeManager" method="getScopes" returnvariable="response">				
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response>

	</cffunction>


	<cffunction name="getScope" output="false" returntype="query" access="public">
		<cfargument name="scope_id" type="numeric" required="true">
		
		<cfset var method = "getScope">

		<cfset var response = structNew()>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/ScopeManager" method="getScope" returnvariable="response">
				<cfinvokeargument name="scope_id" value="#arguments.scope_id#">		
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.scope>

	</cffunction>


	<cffunction name="getScopeAreas" output="false" returntype="struct" access="public">
		<cfargument name="scope_id" type="numeric" required="true">
		
		<cfset var method = "getScopeAreas">

		<cfset var response = structNew()>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/ScopeManager" method="getScopeAreas" returnvariable="response">
				<cfinvokeargument name="scope_id" value="#arguments.scope_id#">		
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response>

	</cffunction>

</cfcomponent>
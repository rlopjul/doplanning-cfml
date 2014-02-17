<!--- Copyright Era7 Information Technologies 2007-2014 --->

<cfcomponent output="false">
	
	<cfset component = "ScopeManager">


	<!--- ------------------------------------- getScope -------------------------------------  --->
	
	<cffunction name="getScope" output="false" access="public" returntype="struct">
		<cfargument name="scope_id" type="numeric" required="yes">

		<cfset var method = "getScope">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/ScopeQuery" method="getScope" returnvariable="scopeQuery">
				<cfinvokeargument name="scope_id" value="#arguments.scope_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, scope=#scopeQuery#}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- getScopes -------------------------------------  --->
	
	<cffunction name="getScopes" output="false" access="public" returntype="struct">

		<cfset var method = "getScopes">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/ScopeQuery" method="getScopes" returnvariable="scopesQuery">			
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, scopes=#scopesQuery#}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- getScopeAreas -------------------------------------  --->
	
	<cffunction name="getScopeAreas" output="false" access="public" returntype="struct">
		<cfargument name="scope_id" type="numeric" required="yes">

		<cfset var method = "getScopeAreas">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/ScopeQuery" method="getScopeAreas" returnvariable="scopesAreasQuery">
				<cfinvokeargument name="scope_id" value="#arguments.scope_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, scopesAreas=#scopesAreasQuery#}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- isAreaInScope -------------------------------------  --->
	
	<cffunction name="isAreaInScope" output="false" access="public" returntype="struct">
		<cfargument name="scope_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">

		<cfset var method = "getScopeAreas">

		<cfset var response = structNew()>

		<cfset var scopeAreas = "">
		<cfset var result = false>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/ScopeQuery" method="getScopeAreas" returnvariable="scopesAreasQuery">
				<cfinvokeargument name="scope_id" value="#arguments.scope_id#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset scopeAreas = valueList(scopesAreasQuery.area_id)>

			<cfif listLen(scopeAreas) GT 0>
				
				<cfinvoke component="#APPLICATION.coreComponentsPath#/ScopeQuery" method="isAreaInScope" returnvariable="result">
					<cfinvokeargument name="scope_id" value="#arguments.scope_id#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="scopeAreas" value="#scopeAreas#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>

			<cfset response = {result=result}>
			
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>

</cfcomponent>
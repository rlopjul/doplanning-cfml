<!---Copyright Era7 Information Technologies 2007-2014--->

<cfcomponent output="false">

	<cfset component = "ClientQuery">	

	
	<!---getScope--->
		
	<cffunction name="getScope" output="false" returntype="query" access="public">
		<cfargument name="scope_id" type="numeric" required="true">
		
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
		
		<cfset var method = "getScope">
			
			<cfquery name="selectScopeQuery" datasource="#client_dsn#">
				SELECT *
				FROM `#client_abb#_scopes` AS scopes
				WHERE scopes.scope_id = <cfqueryparam value="#arguments.scope_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
		
		<cfreturn selectScopeQuery>
		
	</cffunction>


	<!---getScopes--->
		
	<cffunction name="getScopes" output="false" returntype="query" access="public">
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getScopes">
							
			<cfquery name="getScopesQuery" datasource="#client_dsn#">
				SELECT *
				FROM `#client_abb#_scopes` AS scopes
				ORDER BY position ASC;
			</cfquery>
				
		<cfreturn getScopesQuery>
				
	</cffunction>


	<!---getScopeAreas--->
		
	<cffunction name="getScopeAreas" output="false" returntype="query" access="public">
		<cfargument name="scope_id" type="numeric" required="true">
		
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
		
		<cfset var method = "getScopeAreas">
			
			<cfquery name="selectScopeAreasQuery" datasource="#client_dsn#">
				SELECT *
				FROM `#client_abb#_scopes_areas` AS scopes_areas
				WHERE scopes_areas.scope_id = <cfqueryparam value="#arguments.scope_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
		
		<cfreturn selectScopeAreasQuery>
		
	</cffunction>


	<!--- ------------------------------------- isAreaInScope -------------------------------------  --->
	
	<cffunction name="isAreaInScope" output="false" access="public" returntype="boolean">
		<cfargument name="scope_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="scopeAreas" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getScopeAreas">

		<cfset var result = false>
			
			<cfif listFind(arguments.scopeAreas, arguments.area_id) GT 0>
				
				<cfset result = true>

			<cfelse>

				<cfquery name="getAreaQuery" datasource="#client_dsn#">
					SELECT parent_id
					FROM #client_abb#_areas
					WHERE id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfif isNumeric(getAreaQuery.parent_id)>
					
					<cfinvoke component="#APPLICATION.coreComponentsPath#/ScopeQuery" method="isAreaInScope" returnvariable="result">
						<cfinvokeargument name="scope_id" value="#arguments.scope_id#">
						<cfinvokeargument name="area_id" value="#getAreaQuery.parent_id#">
						<cfinvokeargument name="scopeAreas" value="#arguments.scopeAreas#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

				</cfif>

			</cfif>

		<cfreturn result>
			
	</cffunction>

</cfcomponent>
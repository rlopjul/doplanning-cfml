<!---Copyright Era7 Information Technologies 2007-2014--->

<cfcomponent output="false">

	<cfset component = "ClientQuery">	

	
	<!---getClient--->
		
	<cffunction name="getClient" output="false" returntype="query" access="public">
		<cfargument name="client_abb" type="string" required="true">
		
		<cfset var method = "getClient">

		<cfset var client_dsn = "#APPLICATION.identifier#_#arguments.client_abb#">
			
			<!---<cfquery name="selectClientQuery" datasource="#APPLICATION.dsn#">--->
			<cfquery name="selectClientQuery" datasource="#client_dsn#">
				SELECT *
				FROM `doplanning_app`.`app_clients`
				WHERE abbreviation = <cfqueryparam value="#arguments.client_abb#" cfsqltype="cf_sql_varchar">;
			</cfquery>
		
		<cfreturn selectClientQuery>
		
	</cffunction>


	<!---getClients--->
		
	<cffunction name="getClients" output="false" returntype="query" access="public">

		<cfset var method = "getClients">
			
			<cfquery name="selectClientsQuery" datasource="#APPLICATION.dsn#">
				SELECT *
				FROM `doplanning_app`.`app_clients`;
			</cfquery>
		
		<cfreturn selectClientsQuery>
		
	</cffunction>

</cfcomponent>
	
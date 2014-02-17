<!---Copyright Era7 Information Technologies 2007-2014--->

<cfcomponent output="false">

	<cfset component = "ClientQuery">	

	
	<!---getClient--->
		
	<cffunction name="getClient" output="false" returntype="query" access="public">
		<cfargument name="client_abb" type="string" required="true">
		
		<cfset var method = "getClient">
			
			<cfquery name="selectClientQuery" datasource="#APPLICATION.dsn#">
				SELECT *
				FROM `APP_clients`
				WHERE abbreviation = <cfqueryparam value="#arguments.client_abb#" cfsqltype="cf_sql_varchar">;
			</cfquery>
		
		<cfreturn selectClientQuery>
		
	</cffunction>

</cfcomponent>
	
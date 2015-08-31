<!---Copyright Era7 Information Technologies 2007-2014--->

<cfcomponent output="false">

	<cfset component = "WebQuery">

	<!---getWeb--->

	<cffunction name="getWeb" output="false" returntype="query" access="public">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="area_type" type="string" required="false">
		<cfargument name="path" type="string" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getWeb">

			<cfquery name="selectWebQuery" datasource="#arguments.client_dsn#">
				SELECT * <!---webs.web_id, webs.area_id, webs.area_type, webs.path, webs.path_url--->
				FROM `#client_abb#_webs` AS webs
				WHERE
				<cfif isDefined("arguments.area_id")>
					webs.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				<cfelse>
					webs.path = <cfqueryparam value="#arguments.path#" cfsqltype="cf_sql_varchar">
				</cfif>
				;
			</cfquery>

		<cfreturn selectWebQuery>

	</cffunction>


	<!---getWebs--->

	<cffunction name="getWebs" output="false" returntype="query" access="public">
		<cfargument name="area_type" type="string" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getWebs">

			<cfquery name="selectWebsQuery" datasource="#arguments.client_dsn#">
				SELECT *
				FROM `#client_abb#_webs` AS webs
				<cfif isDefined("arguments.area_type")>
				WHERE	webs.area_type = <cfqueryparam value="#arguments.area_type#" cfsqltype="cf_sql_varchar">
				</cfif>;
			</cfquery>

		<cfreturn selectWebQuery>

	</cffunction>

</cfcomponent>

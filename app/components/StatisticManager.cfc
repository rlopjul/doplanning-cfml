<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "StatisticManager">


	<!--- ----------------- GET GENERAL STATISTICS --------------------------------------------   --->
	
	<cffunction name="getGeneralStatistics" output="false" returntype="struct" access="public">
		<cfargument name="from_date" type="string" required="false">
		<cfargument name="end_date" type="string" required="false">
		
		<cfset var method = "getGeneralStatistics">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="includes/checkAdminAccess.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/StatisticQuery" method="getGeneralStatistics" returnvariable="statisticsQuery">
				<cfif isDefined("arguments.from_date")>
					<cfinvokeargument name="from_date" value="#from_date#"/>
				</cfif>
				<cfif isDefined("arguments.end_date")>
					<cfinvokeargument name="end_date" value="#end_date#"/>
				</cfif>
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#"/>
				<cfinvokeargument name="client_dsn" value="#client_dsn#"/>
			</cfinvoke>

			<cfset response = {result=true, query=#statisticsQuery#}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>
	<!--- ------------------------------------------------------------------------------  --->

	
</cfcomponent>
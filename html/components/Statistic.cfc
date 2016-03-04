<!--- Copyright Era7 Information Technologies 2007-2015 --->
<cfcomponent output="false">

	<cfset component = "Statistic">

	<!--- ----------------------- GET GENERAL STATISTICS -------------------------------- --->

	<cffunction name="getGeneralStatistics" returntype="struct" access="public">
		<cfargument name="from_date" type="string" required="false">
		<cfargument name="end_date" type="string" required="false">

		<cfset var method = "getGeneralStatistics">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/StatisticManager" method="getGeneralStatistics" returnvariable="response">
				<cfif isDefined("arguments.from_date")>
					<cfinvokeargument name="from_date" value="#arguments.from_date#"/>
				</cfif>
				<cfif isDefined("arguments.end_date")>
					<cfinvokeargument name="end_date" value="#arguments.end_date#"/>
				</cfif>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ----------------------- GET TOTAL ITEMS BY USERS -------------------------------- --->

	<cffunction name="getTotalItemsByUser" returntype="struct" access="remote">
		<cfargument name="area_id" type="numric" required="true">
		<cfargument name="include_subareas" type="boolean" required="false" default="false">

		<cfset var method = "getTotalItemsByUser">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/StatisticManager" method="getTotalItemsByUser" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="include_subareas" value="#arguments.include_subareas#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStructNoRedirect.cfm">

			<cfcatch>
				<cfinclude template="includes/responseHandlerStructNoRedirect.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>



</cfcomponent>

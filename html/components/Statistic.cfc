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

	<cffunction name="getTotalItemsByUser" returntype="struct" returnformat="json" access="remote">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="area_type" type="string" require="true">
		<cfargument name="include_subareas" type="boolean" required="false" default="false">

		<cfset var method = "getTotalItemsByUser">

		<cfset var response = structNew()>

		<!---
		commented for development
		<cftry>--->

			<cfinvoke component="#APPLICATION.componentsPath#/StatisticManager" method="getTotalItemsByUser" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="area_type" value="#arguments.area_type#"/>
				<cfinvokeargument name="include_subareas" value="#arguments.include_subareas#"/>
			</cfinvoke>

			<!---
			commented for development
			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>--->

		<cfreturn response>

	</cffunction>


	<!--- ----------------------- GET TOTAL ITEMS BY DATE -------------------------------- --->

	<cffunction name="getAllItems" returntype="struct" returnformat="json" access="remote">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="area_type" type="string" require="true">
		<cfargument name="include_subareas" type="boolean" required="false" default="false">
		<cfargument name="parse_dates" type="boolean" required="false">

		<cfset var method = "getAllItems">

		<cfset var response = structNew()>

		<!---
		commented for development
		<cftry>--->

			<cfinvoke component="#APPLICATION.componentsPath#/StatisticManager" method="getAllItems" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="area_type" value="#arguments.area_type#"/>
				<cfinvokeargument name="include_subareas" value="#arguments.include_subareas#"/>
				<cfinvokeargument name="parse_dates" value="#arguments.parse_dates#"/>
			</cfinvoke>

			<!---
			commented for development
			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>--->

		<cfreturn response>

	</cffunction>



</cfcomponent>

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


</cfcomponent>
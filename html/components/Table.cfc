<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="true">

	<cfset component = "Table">
	<cfset request_component = "TableManager">


	<!--- ----------------------------------- getAreaTables ------------------------------------- --->
	
	<cffunction name="getAreaTables" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfset var method = "getAreaTables">
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getAreaTables" returnvariable="response">
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>

</cfcomponent>
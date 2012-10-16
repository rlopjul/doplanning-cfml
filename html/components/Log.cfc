<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 08-07-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 08-07-2009
	
--->
<cfcomponent output="true">

	<cfset component = "Log">
	<cfset request_component = "LogManager">
	
	
	<cffunction name="getLogs" returntype="xml" access="public" output="true">
		<cfargument name="date_from" type="string" required="true">
		<cfargument name="date_to" type="string" required="true">
		<cfargument name="action_id" type="string" required="true">
		<cfargument name="page" type="numeric" required="no" default="1">
		<cfargument name="items_page" type="numeric" required="no" default="1000000">
		
		<cfset var method = "getLogs">
		
		<cfset var request_parameters = "">
		
		<cftry>		
			
			<cfset request_parameters = '<logs page="#arguments.page#" items_page="#arguments.items_page#"'>
			<cfif len(arguments.date_from) GT 0>
				<cfset request_parameters = request_parameters&' date_from="#arguments.date_from#"'>
			</cfif>
			<cfif len(arguments.date_to) GT 0>
				<cfset request_parameters = request_parameters&' date_to="#arguments.date_to#"'>
			</cfif>
			<cfif len(arguments.action_id) GT 0>
				<cfset request_parameters = request_parameters&' action_id="#arguments.action_id#"'>
			</cfif>
			<cfset request_parameters = request_parameters&'>'>
			<cfset request_parameters = request_parameters&'</logs>'>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
</cfcomponent>
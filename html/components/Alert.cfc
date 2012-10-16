<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 13-01-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 13-01-2009
	
--->
<cfcomponent output="false">

	<cfset component = "Alert">
	<cfset request_component = "AlertManager">
	

    <cffunction name="notifyReplaceFile" returntype="void" access="public">
		<cfargument name="xmlFile" type="string" required="true">
		
		<cfset var method = "notifyReplaceFile">
		
		<cfset var request_parameters = "">
		
		<cftry>		
			
			<cfset request_parameters = arguments.xmlFile>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>

            
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
</cfcomponent>
<!---Copyright Era7 Information Technologies 2007-2013

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 09-04-2013
	
--->
<cfcomponent output="false">
	
	<cfset component = "IframeDisplayTypeManager">
	
	
	
	<!---  ---------------------- GET DISPLAY TYPES -------------------------------- --->
	
	<cffunction name="getDisplayTypes" returntype="query" access="public">
		
		<cfset var method = "getDisplayTypes">
		
		
		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">
						
			<cfinvoke component="#APPLICATION.componentsPath#/components/IframeDisplayTypeQuery" method="getDisplayTypes" returnvariable="getDisplayTypesResult">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfreturn getDisplayTypesResult>
							
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
				
	</cffunction>
	
	<!---  ------------------------------------------------------------------------ --->
	
	
</cfcomponent>
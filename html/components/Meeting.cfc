<!---Copyright Era7 Information Technologies 2007-2013

	Date of file creation: 15-05-2013
	File created by: alucena
	Last file change by: alucena
	Date of last file change: 15-05-2013
	
--->
<cfcomponent output="false">

	<cfset component = "Meeting">
	<cfset request_component = "MeetingManager">
	
	
	<!---getUserMeetingSession--->
    <cffunction name="getUserMeetingSession" access="public" returntype="string">
		<cfargument name="user_a_id" type="numeric" required="yes">
		<cfargument name="user_b_id" type="numeric" required="yes">
		
		<cfset var method = "getUserMeetingSession">
				
		<cftry>
		
			<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/MeetingManager" method="getUserMeetingSession" returnvariable="session_id">
				<cfinvokeargument name="user_a_id" value="#arguments.user_a_id#">
				<cfinvokeargument name="user_b_id" value="#arguments.user_b_id#">
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfreturn session_id>
            
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	<!---getSessionToken--->
    <cffunction name="getSessionToken" access="public" returntype="string">
		<cfargument name="session_id" type="string" required="yes">
		
		<cfset var method = "getSessionToken">
				
		<cftry>
					
			<cfinvoke component="#APPLICATION.coreComponentsPath#/MeetingManager" method="getSessionToken" returnvariable="token_id">
				<cfinvokeargument name="session_id" value="#arguments.session_id#">
			</cfinvoke>
			
			<cfreturn token_id>
            
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
</cfcomponent>
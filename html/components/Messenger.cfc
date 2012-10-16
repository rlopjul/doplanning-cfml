<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 23-01-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 23-01-2008
	
--->
<cfcomponent output="false">

	<cfset component = "Messenger">
	<cfset request_component = "MessengerManager">
	

    <cffunction name="getMyConversations" returntype="xml" access="public">
	
		<cfset var method = "getMyConversations">
		
		<cfset var request_parameters = "">
		
		<cfset var xmlResponse = "">
		
		<cftry>
			
			
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
	
	
	 <cffunction name="getConversation" returntype="xml" access="public">
		<cfargument name="conversation_id" type="numeric" required="true">
		
		<cfset var method = "getConversation">
		
		<cfset var request_parameters = "">
		
		<cfset var xmlResponse = "">
		
		<cftry>
			
			<cfset request_parameters = '<conversation id="#arguments.conversation_id#"/>'>
			
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
	
	
	<cffunction name="deleteConversation" returntype="void" access="remote">
		<cfargument name="conversation_id" type="string" required="true">
		
		<cfset var method = "deleteConversation">
		
		<cfset var request_parameters = "">
		
		<cftry>
			
			<cfset response_page = "saved_conversations.cfm">
			
			<cfif len(arguments.conversation_id) IS 0 OR NOT isValid("integer",arguments.conversation_id)>
			
				<cfset message = "Conversación incorrecta.">
				<cfset message = URLEncodedFormat(message)>
				<cflocation url="#APPLICATION.htmlPath#/#response_page#?message=#message#" addtoken="no">
			
			</cfif>
			
			<cfset request_parameters = '<conversation id="#arguments.conversation_id#"/>'>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>	
			
			<cfset message = "Conversación eliminada.">
			<cfset message = URLEncodedFormat(message)>
            
            <cflocation url="#APPLICATION.htmlPath#/#response_page#?message=#message#" addtoken="no">	
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
</cfcomponent>
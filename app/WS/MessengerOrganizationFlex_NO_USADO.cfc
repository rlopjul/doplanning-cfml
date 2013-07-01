<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 06-02-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 06-02-2009
	
--->
<cfcomponent output="false">

	<cfset component = "MessengerOrganizationFlex">
	<cfset request_component = "MessengerOrganization">		
	
	<!--- ----------------------- connectToOrganizationConversation -------------------------------- --->
	
	<cffunction name="connectToOrganizationConversation" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "connectToOrganizationConversation">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>		
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- disconnectFromOrganizationConversation -------------------------------- --->
	
	<cffunction name="disconnectFromOrganizationConversation" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "disconnectFromOrganizationConversation">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- getOrganizationConversationMessages -------------------------------- --->

	<cffunction name="getOrganizationConversationMessages" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getOrganizationConversationMessages">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- acknowledgeOrganizationConversationMessages -------------------------------- --->
	
	<cffunction name="acknowledgeOrganizationConversationMessages" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "acknowledgeOrganizationConversationMessages">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- getOrganizationConversationUsers -------------------------------- --->

	<cffunction name="getOrganizationConversationUsers" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getOrganizationConversationUsers">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	<!--- ----------------------- sendOrganizationConversationMessage -------------------------------- --->
	
	<cffunction name="sendOrganizationConversationMessage" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "sendOrganizationConversationMessage">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	
</cfcomponent>
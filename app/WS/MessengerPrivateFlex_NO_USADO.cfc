<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 06-02-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 06-02-2009
	
--->
<cfcomponent output="false">

	<cfset component = "MessengerPrivateFlex">
	<cfset request_component = "MessengerPrivate">	
	
	
	<!--- ----------------------- connectToPrivateConversation -------------------------------- --->
	
	<cffunction name="connectToPrivateConversation" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "connectToPrivateConversation">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- disconnectFromPrivateConversation -------------------------------- --->
	
	<cffunction name="disconnectFromPrivateConversation" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "disconnectFromPrivateConversation">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- getNewPrivateConversations -------------------------------- --->
	
	<cffunction name="getNewPrivateConversations" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getNewPrivateConversations">
		
		<cfset var xmlResponse = "">
						
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- getPrivateConversationMessages -------------------------------- --->
	
	<cffunction name="getPrivateConversationMessages" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getPrivateConversationMessages">
			
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- acknowledgePrivateConversationMessages -------------------------------- --->
	
	<cffunction name="acknowledgePrivateConversationMessages" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "acknowledgePrivateConversationMessages">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- sendPrivateConversationMessage -------------------------------- --->
	
	<cffunction name="sendPrivateConversationMessage" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "sendPrivateConversationMessage">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
</cfcomponent>
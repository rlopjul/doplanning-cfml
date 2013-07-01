<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 06-02-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 06-02-2009
	
--->
<cfcomponent output="false">

	<cfset component = "MessengerAreaFlex">
	<cfset request_component = "MessengerArea">		
	
	<!--- ----------------------- connectToAreaConversation -------------------------------- --->
	
	<cffunction name="connectToAreaConversation" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "connectToAreaConversation">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- disconnectFromAreaConversation -------------------------------- --->
	
	<cffunction name="disconnectFromAreaConversation" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "disconnectFromAreaConversation">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	<!--- ----------------------- getAreaConversationMessages -------------------------------- --->
	
	<cffunction name="getAreaConversationMessages" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getAreaConversationMessages">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
		
	</cffunction>
	
	
	<!--- ----------------------- getAreaConversationUsers -------------------------------- --->

	<cffunction name="getAreaConversationUsers" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getAreaConversationUsers">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- acknowledgeAreaConversationMessages -------------------------------- --->
	
	<cffunction name="acknowledgeAreaConversationMessages" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "acknowledgeAreaConversationMessages">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	<!--- ----------------------- sendAreaConversationMessage -------------------------------- --->
	
	<cffunction name="sendAreaConversationMessage" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "sendAreaConversationMessage">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
</cfcomponent>
<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 06-02-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 06-02-2009
	
--->
<cfcomponent output="false">

	<cfset component = "MessengerManagerFlex">	
	<cfset request_component = "MessengerManager">	
	
	
	<!--- ---------------------------- getAllUsers -------------------------------- --->
	
	<cffunction name="getAllUsers" returntype="string" output="false" access="remote">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "getAllUsers">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	<!--- ----------------------- getMyConversations -------------------------------- --->
	
	<cffunction name="getMyConversations" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getMyConversations">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- getConversation -------------------------------- --->
	
	<cffunction name="getConversation" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getConversation">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- saveConversation -------------------------------- --->
	
	<cffunction name="saveConversation" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "saveConversation">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	<!--- ----------------------- deleteConversation -------------------------------- --->
	
	<cffunction name="deleteConversation" returntype="string" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "deleteConversation">
		
		<cfset var xmlResponse = "">
		
		<cfinvoke component="#request_component#" method="#method#" returnvariable="xmlResponse">
			<cfinvokeargument name="request" value="#arguments.request#">
		</cfinvoke>
		
		<cfreturn xmlResponse>
		
	</cffunction>
		
	
</cfcomponent>
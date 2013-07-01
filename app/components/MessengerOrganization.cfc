<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 16-01-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 11-03-2009
	
--->
<cfcomponent output="false">

	<cfset component = "MessengerOrganization">		
	
	<!--- ----------------------- connectToOrganizationConversation -------------------------------- --->
	
	<!---request:
	<request method="connectToOrganizationConversation" />--->

	<!---response:
	<response status="ok/error" method="connectToOrganizationConversation">
	<result>
		<users>
			<user  id="" …/>
			…
		</users>
	</result>
	</response>
	--->
	
	<cffunction name="connectToOrganizationConversation" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "connectToOrganizationConversation">
		
		<cfset var xmlRequest = "">
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">
		
		<cfset var msg_users_table = "">
						
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset msg_users_table = "#client_abb#_msg_organization_users">
			
			<cfquery datasource="#client_dsn#" name="getIfUserIsConnected">
				SELECT *
				FROM #msg_users_table#
				WHERE user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif getIfUserIsConnected.recordCount GT 0>
				<cfinvoke component="MessengerManager" method="disconnectFromConversation" returnvariable="xmlResult">
				</cfinvoke>		
			</cfif>
			
			<cfquery datasource="#client_dsn#" name="connectToConversation">
				INSERT INTO #msg_users_table#
				(user_id) 
				VALUES (		
					<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
					);			
			</cfquery>			
			
			
			<cfinvoke component="MessengerManager" method="getConnectedUsers" returnvariable="xmlResult">
			</cfinvoke>
			
			<cfset xmlResponseContent = xmlResult>
		
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- disconnectFromOrganizationConversation -------------------------------- --->
	
	<!---request:
	<request method="disconnectFromOrganizationConversation" ></request>--->

	<!---response:
	<response status="ok/error" method="disconnectFromOrganizationConversation" />--->
	
	<cffunction name="disconnectFromOrganizationConversation" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "disconnectFromOrganizationConversation">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">

		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinvoke component="MessengerManager" method="disconnectFromConversation" returnvariable="xmlResult">
			</cfinvoke>
			
			<cfset xmlResponseContent = xmlResult>
		
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- getOrganizationConversationMessages -------------------------------- --->
	<!---response:
	<response status=”ok/error”>
		<result>
			<user_messages>
				<user_message sent_date=”” color=””>
					<user_full_name><![CDATA[]]></user_full_name>
	<text><![CDATA[]]></text >
				</ user_message >
				….
				<users>
					<user  id=”” …/>
					…
				</users>
			</ user_messages >		
		</result>
	</response>--->

	<cffunction name="getOrganizationConversationMessages" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getOrganizationConversationMessages">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">	
		
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinvoke component="MessengerManager" method="getNewMessages" returnvariable="xmlResult">
			</cfinvoke>
			
			<cfset xmlResponseContent = xmlResult>
		
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- acknowledgeOrganizationConversationMessages -------------------------------- --->
	
	<!---request: 
	<request method="acknowledgeOrganizationConversationMessages">
		<parameters>
			<user_messages>
				<user_message/>
			</usersmessages>		
		</parameters>
	</request>
	--->
	
	<!---response:
	<response status="ok/error"/>--->
	
	<cffunction name="acknowledgeOrganizationConversationMessages" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "acknowledgeOrganizationConversationMessages">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">	
				
		<cftry>
			
			<!---<cfset msg_users_table = "#client_abb#_msg_organization_users">
			
			<cfloop index="xmlMessage" array="#xmlRequest.request.parameters.user_messages.XmlChildren#">
			
				<cfif xmlMessage.xmlAttributes.id GT lastMessageId>
					<cfset lastMessageId = xmlMessage.xmlAttributes.id>
				</cfif>
			
			</cfloop>
			
			<cfquery datasource="#client_dsn#" name="getUserLastMessage">
				SELECT *
				FROM #msg_users_table#
				WHERE user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif getUserLastMessage.last_message LT lastMessageId>
				<cfquery datasource="#client_dsn#" name="connectToConversation">
					UPDATE #msg_users_table#
					SET last_message = <cfqueryparam value="#lastMessageId#" cfsqltype="cf_sql_integer">
					WHERE user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>		
		
			<cfset xmlResponseContent = "<last_message_id><![CDATA[#lastMessageId#]]></last_message_id>">--->
			
			<cfinvoke component="MessengerManager" method="acknowledgeConversationMessages" returnvariable="xmlResult">
				<cfinvokeargument name="request" value="#arguments.request#">
			</cfinvoke>
			
			<cfset xmlResponseContent = xmlResult>
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- getOrganizationConversationUsers -------------------------------- --->
	<!---response:
	<response status=”ok/error”>
		<result>
				<users>
					<user  id=”” …/>
					…
				</users>	
		</result>
	</response>--->

	<cffunction name="getOrganizationConversationUsers" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getOrganizationConversationUsers">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">	
		
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinvoke component="MessengerManager" method="getConnectedUsers" returnvariable="xmlResult">
			</cfinvoke>
			
			<cfset xmlResponseContent = xmlResult>
		
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	<!--- ----------------------- sendOrganizationConversationMessage -------------------------------- --->
	
	<!---request: 
	--->
	
	<!---response:
	--->
	
	<cffunction name="sendOrganizationConversationMessage" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "sendOrganizationConversationMessage">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">	
				
		<cftry>
		
			<!---<cfinclude template="includes/functionStart.cfm">--->
			
			<cfinvoke component="MessengerManager" method="sendMessage" returnvariable="xmlResult">
				<cfinvokeargument name="request" value="#arguments.request#">
			</cfinvoke>
			
			<cfset xmlResponseContent = xmlResult>
		
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	
</cfcomponent>
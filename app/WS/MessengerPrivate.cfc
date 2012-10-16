<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 15-01-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 23-03-2009
	
--->
<cfcomponent output="false">

	<cfset component = "MessengerPrivate">	
	
	
	<!--- ----------------------- connectToPrivateConversation -------------------------------- --->
	
	<!---request:
	<request>
		<parameters>
			<user id=""/>
		</parameters>
	</request>--->

	<!---response:
	<response status="ok/error" method="connectToPrivateConversation">
		<result>
			<conversation id=""/>
		</result>
	</response>--->
	
	<cffunction name="connectToPrivateConversation" returntype="xml" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "connectToPrivateConversation">
		
		<cfset var xmlRequest = "">
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">
		
		<cfset var user_id = "">
		<cfset var msg_users_table = "">
		<cfset var conversation_id = "">
						
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset conversation_user_id = xmlRequest.request.parameters.user.xmlAttributes.id>
			
			<cfset msg_users_table = "#client_abb#_msg_private_conversations_users">
			<cfset msg_conversations_table = "#client_abb#_msg_private_conversations">
			
			<cfquery datasource="#client_dsn#" name="getIfConversationExist">
				SELECT conversation_id
				FROM #msg_users_table#
				WHERE user_id = <cfqueryparam value="#conversation_user_id#" cfsqltype="cf_sql_integer"> 
				AND conversation_id IN 
				(SELECT conversation_id FROM #msg_users_table# WHERE user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">);
			</cfquery>
			
			<cfif getIfConversationExist.recordCount GT 0><!---the conversation exist--->
				
				<cfset conversation_id = getIfConversationExist.conversation_id>
				
				<cfquery datasource="#client_dsn#" name="updateConversation">
					UPDATE #msg_users_table#
					SET connected = 1
					WHERE conversation_id = <cfqueryparam value="#conversation_id#" cfsqltype="cf_sql_integer"> AND user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;		
				</cfquery>
				
			<cfelse><!---the conversation does not exist--->
				
				<cfquery name="beginQuery" datasource="#client_dsn#">
					BEGIN;
				</cfquery>
				
				<cfquery datasource="#client_dsn#" name="createConversation" result="createConversationResult">
					INSERT INTO #msg_conversations_table#
					(creation_user) 
					VALUES (
						<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
						);			
				</cfquery>
				
				<!---<cfset conversation_id = createConversationResult.GENERATED_KEY>--->
				<cfquery name="getLastInsertId" datasource="#client_dsn#">
					SELECT LAST_INSERT_ID() AS last_insert_id FROM #msg_conversations_table#;
				</cfquery>
				<cfset conversation_id = getLastInsertId.last_insert_id>
				
				<cfquery datasource="#client_dsn#" name="createConversation">
					INSERT INTO #msg_users_table#
					(conversation_id, user_id, connected) 
					VALUES (
						<cfqueryparam value="#conversation_id#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
						1
						);			
				</cfquery>
				
				<cfquery datasource="#client_dsn#" name="createConversation">
					INSERT INTO #msg_users_table#
					(conversation_id, user_id, connected) 
					VALUES (
						<cfqueryparam value="#conversation_id#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#conversation_user_id#" cfsqltype="cf_sql_integer">,
						0
						);			
				</cfquery>
				
				<cfquery name="commitQuery" datasource="#client_dsn#">
					COMMIT;
				</cfquery>
				
			</cfif>
			
			<cfset xmlResponseContent = '<conversation id="#conversation_id#"/>'>
		
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- disconnectFromPrivateConversation -------------------------------- --->
	
	<!---request:
	<request>
		<parameters>
			<conversation id=""/>
		</parameters>
	</request>--->

	<!---response:
	<response method="disconnectFromPrivateConversation" status="ok/error" />--->
	
	<cffunction name="disconnectFromPrivateConversation" returntype="xml" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "disconnectFromPrivateConversation">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">
		
		<cfset var conversation_id = "">
		<cfset var msg_users_table = "">

		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset conversation_id = xmlRequest.request.parameters.conversation.xmlAttributes.id>
			
			<cfset msg_users_table = "#client_abb#_msg_private_conversations_users">
			
			<cfquery datasource="#client_dsn#" name="disconnectFromConversation">
				UPDATE #msg_users_table#
				SET connected = 0
				WHERE user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
				AND conversation_id = <cfqueryparam value="#conversation_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfset xmlResponse = "">
		
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- getNewPrivateConversations -------------------------------- --->
	
	<!---request:
	<request />--->
	
	<!---response:
	<response status="ok/error" method="getNewPrivateConversations">
		<result>
			<conversations>
				<conversation id=””>
					<user id=”” connected=”true/false”>	
						
					</user>
				</conversation>
				…
			</conversations>		
		</result>
	</response>--->
	
	<cffunction name="getNewPrivateConversations" returntype="xml" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getNewPrivateConversations">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">
						
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinvoke component="MessengerManager" method="setLastRequest">
			</cfinvoke>
			
			<cfquery datasource="#client_dsn#" name="getNewConversations">
				SELECT DISTINCT msg_conv_users.conversation_id AS conversation_id, users.id AS user_id, users.family_name AS user_family_name, users.name AS user_name, users.connected AS user_connected
				FROM #client_abb#_msg_private_conversations_users AS msg_conv_users
				INNER JOIN #client_abb#_msg_private_messages AS msg_conv_messages ON msg_conv_users.conversation_id = msg_conv_messages.conversation_id
				INNER JOIN #client_abb#_users AS users ON msg_conv_messages.user_id = users.id
				WHERE msg_conv_users.user_id=<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer"/> AND msg_conv_messages.user_id !=<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer"/> AND msg_conv_users.connected = 0 AND msg_conv_messages.id>msg_conv_users.last_message;				
			</cfquery>
			
			
			<cfif getNewConversations.recordCount GT 0>
			
				<cfset xmlResult = "<conversations>">
				
				<cfloop query="getNewConversations">
				
					<cfinvoke component="UserManager" method="objectUser" returnvariable="xmlUser">
							<cfinvokeargument name="id" value="#getNewConversations.user_id#">
							<cfinvokeargument name="user_full_name" value="#getNewConversations.user_family_name# #getNewConversations.user_name#">
							<cfinvokeargument name="connected" value="#getNewConversations.user_connected#">							
							
							<cfinvokeargument name="return_type" value="xml">
					</cfinvoke>
					
					<cfset xmlConversation = '<conversation id="#getNewConversations.conversation_id#">'&xmlUser&'</conversation>'>
					
				</cfloop>
				
				<cfset xmlResult = xmlResult&xmlConversation&"</conversations>">
			
			<cfelse>
			
				<cfset xmlResult = "<conversations/>">
			
			</cfif>
			
			<cfset xmlResponseContent = xmlResult>
		
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- getPrivateConversationMessages -------------------------------- --->
	
	<!---request: 
	<request method=”getPrivateConversationMessages” >
		<parameters>
			<conversation id=""/>
		</parameters>
	</request>--->
	
	<!---response:
	<response status=”ok/error”>
		<result>
			<conversation id="">
				< user_message sent_date=”” color=””>
					<user_full_name><![CDATA[]]></user_full_name>
	<text><![CDATA[]]></text >
				</ user_message >
				….
			</conversation >		
		</result>
	</response>--->
	
	<cffunction name="getPrivateConversationMessages" returntype="xml" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getPrivateConversationMessages">
		
		<cfset var conversation_id = "">	
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">	
				
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">			
			
			<cfinvoke component="MessengerManager" method="setLastRequest">
			</cfinvoke>
			
			<cfset conversation_id = xmlRequest.request.parameters.conversation.xmlAttributes.id>
			
			<cfset msg_messages_table = "#client_abb#_msg_private_messages">
			<cfset msg_users_table = "#client_abb#_msg_private_conversations_users">
			<cfset users_table = "#client_abb#_users">
			
			<cfquery datasource="#client_dsn#" name="getNewMessages">
			SELECT *
			FROM #msg_messages_table# AS msg_messages 
			INNER JOIN #users_table# AS users ON msg_messages.user_id = users.id 
			AND msg_messages.user_id != <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
			INNER JOIN #msg_users_table# AS msg_users ON msg_messages.conversation_id = msg_users.conversation_id
			WHERE msg_users.user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
			AND msg_messages.id > msg_users.last_message
			
			AND msg_messages.conversation_id = <cfqueryparam value="#conversation_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfset xmlResult = '<conversation id="#conversation_id#"/><user_messages>'>
			
			<cfif getNewMessages.recordCount GT 0>
				
				<cfloop query="getNewMessages">
					<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringDateCreation">
						<cfinvokeargument name="timestamp_date" value="#getNewMessages.creation_date#">
					</cfinvoke>
					
					<cfset xmlUserMessage = '<user_message id="#getNewMessages.id#" sent_date="#stringDateCreation#" color="#getNewMessages.color#"><user_full_name><![CDATA[#getNewMessages.family_name# #getNewMessages.name#]]></user_full_name><text><![CDATA[#getNewMessages.text#]]></text></user_message>'>
					
					<cfset xmlResult = xmlResult&xmlUserMessage>
					
				</cfloop>
				
			</cfif>
			
			<cfset xmlResult = xmlResult&"</user_messages>">

			<cfset xmlResponseContent = xmlResult>
		
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- acknowledgePrivateConversationMessages -------------------------------- --->
	
	<!---request: 
	<request method="acknowledgePrivateConversationMessages">
		<parameters>
			<conversation id=""/>
			<user_messages>
				<user_message/>
			</usersmessages>		
		</parameters>
	</request>
	--->
	
	<!---response:
	<response status="ok/error"/>--->
	
	<cffunction name="acknowledgePrivateConversationMessages" returntype="xml" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "acknowledgePrivateConversationMessages">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">	
				
		<cftry>
			
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
	
	
	<!--- ----------------------- sendPrivateConversationMessage -------------------------------- --->
	
	<!---request: 
	--->
	
	<!---response:
	--->
	
	<cffunction name="sendPrivateConversationMessage" returntype="xml" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "sendPrivateConversationMessage">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">	
				
		<cftry>
					
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
	
	
	
	<!---<cffunction name="acknowledgePrivateConversationMessages" output="false" returntype="xml" access="remote">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "acknowledgePrivateConversationMessages">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset messagesList = "">
			
			<!---<cfloop index="iXml" from="1" to="#ArrayLen(xmlUsers.users.XmlChildren)#" step="1">
		
				<cfset curr_val = xmlUsers.users.user[#iXml#].xmlAttributes.email>
				<cfif xmlUsers.users.user[#iXml#].xmlAttributes.whole_tree_visible IS true>
					<cfset listInternalUsers = ListAppend(listInternalUsers,curr_val,";")>	
				<cfelse>
					<cfset listExternalUsers = ListAppend(listExternalUsers,curr_val,";")>
				</cfif>
						
			</cfloop>--->
			
			<cfloop index="xmlMessage" array="#xmlRequest.request.parameters.conversation.user_message#">
				
				<cfset listAppend(messagesList,#xmlMessage.xmlAttributes.id#)>
			
			</cfloop>
									
			<cfset xmlResponseContent = arguments.request>
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
	
		<cfreturn xmlResponse>
	
	</cffunction>--->
	
</cfcomponent>
<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 16-01-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 14-07-2009
	
--->

<cfcomponent output="false">

	<cfset component = "MessengerManager">	
	
	
	<!--- ----------------------- setLastRequest -------------------------------- --->
	
	<!---Guarda la fecha de la última petición hecha por el usuario conectado--->
	<!---Pone al usuario como conectado si no lo estaba en la base de datos--->
	
	<cffunction name="setLastRequest" returntype="void" output="false" access="public">
		
		<cfset var method = "setLastRequest">
		
		<cfinclude template="includes/functionStart.cfm">
		
		<!---<cfinvoke component="#APPLICATION.componentsPath#/DateManager" method="getCurrentDateTime" returnvariable="current_date">
		</cfinvoke>--->
		<cfquery datasource="#client_dsn#" name="setLastUpdate">
			UPDATE #client_abb#_users
			SET connected = 1, 
			last_request = NOW()
			WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;		
		</cfquery>
		
	</cffunction>
	
	
	<!--- ----------------------- getConnectedUsers -------------------------------- --->
	
	<cffunction name="getConnectedUsers" returntype="string" output="false" access="public">		
		<cfargument name="area_id" type="string" required="no" default="0"><!---0 is organization messenger--->
				
		<cfset var method = "getConnectedUsers">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">
		
		<cfset var msg_users_table = "">
		
		<cfinclude template="includes/functionStart.cfm">
		
		<cfif arguments.area_id IS 0>
			<cfset msg_users_table = "#client_abb#_msg_organization_users">
		<cfelse>
			<cfset msg_users_table = "#client_abb#_msg_area_users">
			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">
		</cfif>
		
		<cfquery datasource="#client_dsn#" name="getConnectedUsers">
			SELECT *
			FROM #msg_users_table# AS msg_users 
			INNER JOIN #client_abb#_users AS users ON msg_users.user_id = users.id
			<cfif arguments.area_id NEQ 0>
			WHERE msg_users.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
			</cfif>
			ORDER BY family_name ASC;			
		</cfquery>
		
		<cfif arguments.area_id IS 0>
			<cfset xmlResult = "<users>">
		<cfelse>
			<cfset xmlResult = '<area id="#arguments.area_id#"/><users>'>
		</cfif>
		
		<cfif getConnectedUsers.recordCount GT 0>
			
			<cfloop query="getConnectedUsers">
				
				<cfset xmlResult = xmlResult&'<user id="#getConnectedUsers.user_id#"><user_full_name><![CDATA[#getConnectedUsers.family_name# #getConnectedUsers.name#]]></user_full_name></user>'>
			
			</cfloop>
			
			<!---<cfset xmlResult = xmlResult&'<user id="#getConnectedUsers.user_id#"><family_name><![CDATA[#getConnectedUsers.family_name#]]></family_name><name><![CDATA[#getConnectedUsers.name#]]></name></user>'>--->
			
		</cfif>
		
		<cfset xmlResult = xmlResult&"</users>">
			
		<cfset xmlResponse = xmlResult>
	
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ---------------------------- getAllUsers -------------------------------- --->
	<!---Devuelve la lista de todos los usuarios de la organización--->
	
	<cffunction name="getAllUsers" returntype="xml" output="false" access="public">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "getAllUsers">
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">
		
		<cfset var with_external = "">
			
		<cfset var xmlRequest = "">
		<cfset var xmlResponseContent = "">
	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<!---<cfxml variable="xmlUser">
				<cfoutput>
					#xmlRequest.request.parameters.user#
				</cfoutput>
			</cfxml>--->
			
			<cfinvoke component="UserManager" method="getAllUsers" returnvariable="result">
				<cfinvokeargument name="request" value="#arguments.request#">
			</cfinvoke>
			
			<cfxml variable="xmlResponse">
				<cfoutput>
				#result#
				</cfoutput>
			</cfxml>
			
			<cfset xmlResponse.response.xmlAttributes.component = component>
			<cfset xmlResponse.response.xmlAttributes.method = method>
			

			<!---<cfset xmlResponseContent = ''>--->
			
			<!---<cfinclude template="includes/functionEndNoLog.cfm">--->	
		
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- getNewMessages -------------------------------- --->
	
	<cffunction name="getNewMessages" returntype="string" output="false" access="public">		
		<cfargument name="area_id" type="numeric" required="no" default="0"><!---0 is organization messenger--->
				
		<cfset var method = "getNewMessages">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">
		
		<cfset var msg_messages_table = "">
		
		<cfinclude template="includes/functionStart.cfm">
		
		<cfif arguments.area_id IS 0>
			<cfset msg_messages_table = "#client_abb#_msg_organization_messages">
			<cfset msg_users_table = "#client_abb#_msg_organization_users">
		<cfelse>
			<cfset msg_messages_table = "#client_abb#_msg_area_messages">
			<cfset msg_users_table = "#client_abb#_msg_area_users">
			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">
		</cfif>

		<cfinvoke component="MessengerManager" method="setLastRequest">
		</cfinvoke>
			
		<cfquery datasource="#client_dsn#" name="getNewMessages">
			SELECT *
			FROM #msg_messages_table# AS msg_messages 
			INNER JOIN #client_abb#_users AS users ON msg_messages.user_id = users.id 
			AND msg_messages.user_id != <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
			, #msg_users_table# AS msg_users
			WHERE msg_users.user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
			AND msg_messages.id > msg_users.last_message
			AND msg_messages.creation_date > msg_users.connection_date
			<cfif arguments.area_id NEQ 0>
			AND msg_messages.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfif>			
		</cfquery>
		
	<!---INNER JOIN #msg_users_table# AS msg_users ON msg_users.user_id = msg_messages.user_id AND msg_messages.user_id != <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">--->
		
		<cfif arguments.area_id IS 0>
			<cfset xmlResult = "<user_messages>">
		<cfelse>
			<cfset xmlResult = '<area id="#arguments.area_id#"/><user_messages>'>
		</cfif>
		
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
		
		<cfset xmlResponse = xmlResult>
	
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- acknowledgeConversationMessages -------------------------------- --->
	
	<!---request: 
	<request method="acknowledgeConversationMessages">
		<parameters>
			<user_messages>
				<user_message/>
			</usersmessages>		
		</parameters>
	</request>
	--->
	
	<!---response:
	<response status="ok/error"/>--->
	
	<cffunction name="acknowledgeConversationMessages" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "acknowledgeConversationMessages">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">	
		
		<cfset var area_id = "">
		<cfset var conversation_id = "">	
		<cfset var lastMessageId = 0>
				
		<cfinclude template="includes/functionStart.cfm">
		
		<cfif isDefined("xmlRequest.request.parameters.area.xmlAttributes.id")>
			<cfset area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
			<cfif NOT isValid("integer", area_id)><!---XML receibed is incorrect or incomplete--->
				<cfset error_code = 1002>
			
				<cfthrow errorcode="#error_code#">
			</cfif>
			<cfset msg_users_table = "#client_abb#_msg_area_users">
			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">
		<cfelseif isDefined("xmlRequest.request.parameters.conversation.xmlAttributes.id")>
			<cfset conversation_id = xmlRequest.request.parameters.conversation.xmlAttributes.id>
			<cfif NOT isValid("integer", conversation_id)><!---XML receibed is incorrect or incomplete--->
				<cfset error_code = 1002>
			
				<cfthrow errorcode="#error_code#">
			</cfif>
			<cfset msg_users_table = "#client_abb#_msg_private_conversations_users">
		<cfelse>
			<cfset msg_users_table = "#client_abb#_msg_organization_users">
		</cfif>
		
		<cfloop index="xmlMessage" array="#xmlRequest.request.parameters.user_messages.XmlChildren#">
		
			<cfif xmlMessage.xmlAttributes.id GT lastMessageId>
				<cfset lastMessageId = xmlMessage.xmlAttributes.id>
			</cfif>
		
		</cfloop>
		
		<cfquery datasource="#client_dsn#" name="getUserLastMessage">
			SELECT *
			FROM #msg_users_table#
			WHERE user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
			<cfif area_id NEQ "">
			AND area_id = <cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer">
			<cfelseif conversation_id NEQ "">
			AND conversation_id = <cfqueryparam value="#conversation_id#" cfsqltype="cf_sql_integer">
			</cfif>;
		</cfquery>
		
		<cfif getUserLastMessage.last_message LT lastMessageId>
			<cfquery datasource="#client_dsn#" name="connectToConversation">
				UPDATE #msg_users_table#
				SET last_message = <cfqueryparam value="#lastMessageId#" cfsqltype="cf_sql_integer">
				WHERE user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
				<cfif area_id NEQ "">
				AND area_id = <cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer">
				<cfelseif conversation_id NEQ "">
				AND conversation_id = <cfqueryparam value="#conversation_id#" cfsqltype="cf_sql_integer">
				</cfif>;
			</cfquery>
		</cfif>		
	
		<cfset xmlResponse = "<last_message_id><![CDATA[#lastMessageId#]]></last_message_id>">
			
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- sendMessage -------------------------------- --->
	
	<!---request:
	<request method=”sendOrganizationConversationMessage” >
		<parameters>
			<user_message/>
		</parameters>
	</request>
	
	<request method=”sendAreaConversationMessage” >
		<parameters>
			<area id=””/>
			<user_message/>
		</parameters>
	</request>	
	--->
	
	<!---response:
	<response status=”ok/error”/>--->
	
	<cffunction name="sendMessage" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "sendMessage">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">
	
		<cfset var area_id = "">	
		<cfset var conversation_id = "">
		<cfset var msg_messages_table = "">
	
		<cfset var user_id = "">
		<cfset var text = "">
		<cfset var color = "">
		
		<cfinclude template="includes/functionStart.cfm">
		
		<cfif isDefined("xmlRequest.request.parameters.area.xmlAttributes.id")>
			<cfset area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
			<cfif NOT isValid("integer", area_id)><!---XML receibed is incorrect or incomplete--->
				<cfset error_code = 1002>
			
				<cfthrow errorcode="#error_code#">
			</cfif>
			<cfset msg_messages_table = "#client_abb#_msg_area_messages">
			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">
		<cfelseif isDefined("xmlRequest.request.parameters.conversation.xmlAttributes.id")>
			<cfset conversation_id = xmlRequest.request.parameters.conversation.xmlAttributes.id>
			<cfif NOT isValid("integer", conversation_id)><!---XML receibed is incorrect or incomplete--->
				<cfset error_code = 1002>
			
				<cfthrow errorcode="#error_code#">
			</cfif>
			<cfset msg_messages_table = "#client_abb#_msg_private_messages">
		<cfelse>
			<cfset msg_messages_table = "#client_abb#_msg_organization_messages">
		</cfif>
		
		<cfset text = xmlRequest.request.parameters.user_message.text.xmlText>
		<cfset color = xmlRequest.request.parameters.user_message.xmlAttributes.color>
		
		<cfquery datasource="#client_dsn#" name="insertNewMessage" result="insertNewMessageResult">
			INSERT INTO #msg_messages_table#
			(<cfif area_id NEQ "">area_id,</cfif><cfif conversation_id NEQ "">conversation_id,</cfif>
			user_id, text, color)
			VALUES(
			<cfif area_id NEQ ""><cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif conversation_id NEQ ""><cfqueryparam value="#conversation_id#" cfsqltype="cf_sql_integer">,</cfif>
			<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#text#" cfsqltype="cf_sql_longvarchar">,
			<cfqueryparam value="#color#" cfsqltype="cf_sql_varchar">
			)			
		</cfquery>
		
		<!---<cfset user_message_id = insertNewMessageResult.GENERATED_KEY>--->
		<cfquery name="getLastInsertId" datasource="#client_dsn#">
			SELECT LAST_INSERT_ID() AS last_insert_id FROM #msg_messages_table#;
		</cfquery>
		<cfset user_message_id = getLastInsertId.last_insert_id>
		
		<cfset xmlResponse = '<user_message id="#user_message_id#"></user_message>'>
	
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	<!--- ----------------------- disconnectFromConversation -------------------------------- --->
	
	<!---request:
	<request method=”disconnectFromOrganizationConversation” />
	
	<request method=”disconnectFromAreaConversation” >
		<parameters>
			<area id=””/>
		</parameters>
	</request>
	--->
	
	<!---response:
	<response status=”ok/error”/>--->
	
	<cffunction name="disconnectFromConversation" returntype="string" output="false" access="public">		
		<cfargument name="area_id" type="string" required="no" default="0"><!---0 is organization messenger--->
				
		<cfset var method = "disconnectFromConversation">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">
	
		<cfset var msg_users_table = "">
		
		<cfinclude template="includes/functionStart.cfm">
		
		<cfif arguments.area_id IS 0>
			<cfset msg_users_table = "#client_abb#_msg_organization_users">
		<cfelse>
			<cfset msg_users_table = "#client_abb#_msg_area_users">
		</cfif>
		
		<cfquery datasource="#client_dsn#" name="disconnectFromConversation">
			DELETE FROM #msg_users_table#
			WHERE user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
			<cfif arguments.area_id NEQ 0>
			AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
			</cfif>;
		</cfquery>
		
		<cfset xmlResponse = "">
	
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	<!--- ----------------------- getMyConversations -------------------------------- --->
	
	<!---request: 
		<request method="getMyConversations" />
	--->
	
	<!---response:
	<response status="ok/error" method="getMyConversations">
		<result>
			<conversations>
				<conversation id="" saved_date=""><content><![CDATA[]]></content></conversation>
			</conversations>		
		</result>
	</response>

	--->
	
	<cffunction name="getMyConversations" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getMyConversations">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">	
				
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfquery datasource="#client_dsn#" name="getConversations">
				SELECT *
				FROM #client_abb#_msg_saved_conversations
				WHERE user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;				
			</cfquery>
			
			
			<cfif getConversations.recordCount GT 0>
			
				<cfset xmlResult = "<conversations>">
			
				<cfloop query="getConversations">
				
					<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringSavedDate">
						<cfinvokeargument name="timestamp_date" value="#getConversations.saved_date#">
					</cfinvoke>
				
					<cfset xmlConversation = '<conversation id="#getConversations.id#" saved_date="#stringSavedDate#" type="#getConversations.type#"><name><![CDATA[#getConversations.name#]]></name></conversation>'>
				
					<!---<text><![CDATA[#getConversations.content#]]></text>--->
				
					<cfset xmlResult = xmlResult&xmlConversation>
				</cfloop>
				
				<cfset xmlResult = xmlResult&"</conversations>">				
				
			<cfelse>
			
				<cfset xmlResult = "<conversations/>">
			
			</cfif>		
			
			<cfset xmlResponseContent = xmlResult>
			
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- getConversation -------------------------------- --->
	
	<!---request: 
		<request method="getConversation">
			<conversation id="">
		</request>
	--->
	
	<!---response:
	<response status=”ok/error”>
		<result>
			<conversation />	
		</result>
	</response>
	--->
	
	<cffunction name="getConversation" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getConversation">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">	
				
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset conversation_id = xmlRequest.request.parameters.conversation.xmlAttributes.id>
			
			<cfquery datasource="#client_dsn#" name="getConversation">
				SELECT *
				FROM #client_abb#_msg_saved_conversations
				WHERE id = <cfqueryparam value="#conversation_id#" cfsqltype="cf_sql_integer">
				AND user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;			
			</cfquery>
			
			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringSavedDate">
				<cfinvokeargument name="timestamp_date" value="#getConversation.saved_date#">
			</cfinvoke>
			
			<cfset xmlConversation = '<conversation id="#getConversation.id#" saved_date="#stringSavedDate#" type="#getConversation.type#"><name><![CDATA[#getConversation.name#]]></name><text><![CDATA[#getConversation.content#]]></text></conversation>'>
				
			<cfset xmlResponseContent = xmlConversation>
			
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- saveConversation -------------------------------- --->
	
	<!---request: 
	<request>
		<parameters>
			<conversation  type="">
				<name></name>
				<text></text>
				</conversation >
		</parameters>
	</request>

	--->
	
	<!---response:
	<response method="saveConversation" status="ok/error">
		<result>
			<conversation id="" date=""/>
		</result>
	</response>
	--->
	
	<cffunction name="saveConversation" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "saveConversation">
		
		<cfset var xmlRequest = "">
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">	
		
		<cfset var name = "">
		<cfset var text = "">
		<cfset var type = "">
		<cfset var conversation_id = "">
		
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset name =  xmlRequest.request.parameters.conversation.name.xmlText>
			<cfset text = xmlRequest.request.parameters.conversation.text.xmlText>
			<cfset type = xmlRequest.request.parameters.conversation.xmlAttributes.type>
			
			<cfquery datasource="#client_dsn#" name="saveConversation" result="saveConversationResult">
				INSERT INTO #client_abb#_msg_saved_conversations
				(name, user_id, content, type)
				VALUES (
				<cfqueryparam value="#name#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">, 
				<cfqueryparam value="#text#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#type#" cfsqltype="cf_sql_varchar">
				);				
			</cfquery>
			
			<!---<cfset conversation_id = saveConversationResult.GENERATED_KEY>--->
			<cfquery name="getLastInsertId" datasource="#client_dsn#">
				SELECT LAST_INSERT_ID() AS last_insert_id FROM #client_abb#_msg_saved_conversations;
			</cfquery>
			<cfset conversation_id = getLastInsertId.last_insert_id>
			
			
			<cfset xmlConversation = '<conversation id="#conversation_id#" type="#type#"></conversation>'>
				
			<cfset xmlResponseContent = xmlConversation>
			
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	<!--- ----------------------- deleteConversation -------------------------------- --->
	
	<!---request: 
	<request>
		<parameters>
			<conversation id=""/>
		</parameters>
	</request>
	--->
	
	<!---response:
	<response method="deleteConversation" status="ok/error">
		<result>
			<conversation id=""/>
		</result>
	</response>
	--->
	
	<cffunction name="deleteConversation" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "deleteConversation">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">	
		
		<cfset var conversation_id = "">
		
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset conversation_id = xmlRequest.request.parameters.conversation.xmlAttributes.id>
			
			<cfquery datasource="#client_dsn#" name="deleteConversation">
				DELETE FROM #client_abb#_msg_saved_conversations
				WHERE id = <cfqueryparam value="#conversation_id#" cfsqltype="cf_sql_integer">
				AND user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;			
			</cfquery>
			
			<cfset xmlConversation = '<conversation id="#conversation_id#"></conversation>'>
				
			<cfset xmlResponseContent = xmlConversation>
			
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- checkIfUsersAreConnected -------------------------------- --->
	
	<!---Los métodos de obtener nuevos mensajes y ver si hay conexiones privadas llaman al método setLastRequest,
	que guarda el tiempo de la última petición.
	Esta función comprueba si hay usuarios conectados que su última petición tenga más de 5 minutos de antigüedad,
	si es así significa que no está conectado, y procede a desconectarlo (en la base de datos).---> 
	
	<cffunction name="checkIfUsersAreConnected" returntype="void" output="true" access="public">
	
		<cfset var method = "checkIfUsersAreConnected">
		
		<!---IMPORTANTE: ESTO SOLO FUNCIONA PARA EL CLIENTE ESPECIFICADO AQUÍ:--->	
		
		<cfset var client_abb = "asnc">
		<cfset var client_dsn = APPLICATION.identifier&"_"&client_abb>
		
		<cfset var users_table = "#client_abb#_users">
		<cfset var msg_organization_users_table = "#client_abb#_msg_organization_users">
		<cfset var msg_areas_users_table = "#client_abb#_msg_area_users">
		<cfset var msg_private_users_table = "#client_abb#_msg_private_conversations_users">
		
		<cfinvoke component="#APPLICATION.componentsPath#/DateManager" method="getCurrentDateTime" returnvariable="current_date">
		</cfinvoke>
		
		
		
		<cfquery datasource="#client_dsn#" name="getConnectedUsers">
			SELECT DISTINCT users.id AS user_id
			FROM  #users_table# AS users
			LEFT JOIN #msg_organization_users_table# AS users_organization ON users.id = users_organization.user_id
			LEFT JOIN #msg_areas_users_table# AS users_areas ON users.id = users_areas.user_id
			LEFT JOIN #msg_private_users_table# AS users_private ON users.id = users_private.user_id
			WHERE (users.connected = 1 
			OR users_private.connected = 1) AND (users.last_request < DATE_SUB(<cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">, INTERVAL #APPLICATION.messengerUserExpireTime# SECOND) OR users.last_request IS NULL);			
		</cfquery>
		
		<!---AND users.last_request > now() OR users;--->
		
		<cfloop query="getConnectedUsers">
			
			<cfinvoke component="LoginManager" method="logOutUserNotConnected">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="user_id" value="#getConnectedUsers.user_id#">
			</cfinvoke>
			<cfoutput>
			Usuario #client_abb# #getConnectedUsers.user_id# desconectado
			</cfoutput>
			
		</cfloop>
	
	</cffunction>
	
	
	<!---
	
	cfschedule
	
	
	SELECT DISTINCT users.id AS user_id
			FROM  vpnet_users AS users
			LEFT JOIN vpnet_msg_organization_users AS users_organization ON users.id = users_organization.user_id
			LEFT JOIN vpnet_msg_area_users AS users_areas ON users.id = users_areas.user_id
			LEFT JOIN vpnet_msg_private_conversations_users AS users_private ON users.id = users_private.user_id
			WHERE users.connected = 1 
			OR users_private.connected = 1;--->
	
	<!--- ----------------------- disconnectUser -------------------------------- --->
	
	<cffunction name="disconnectUser" returntype="void" output="false" access="public">	
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="user_id" type="numeric" required="true">
				
		<cfset var method = "disconnectUser">
		
		<cfset var client_dsn = APPLICATION.identifier&"_"&arguments.client_abb>
		
		<cfset var msg_organization_users_table = "">
		<cfset var msg_areas_users_table = "">
		<cfset var msg_private_users_table = "">
		
		<cfset msg_organization_users_table = "#arguments.client_abb#_msg_organization_users">
		<cfset msg_areas_users_table = "#arguments.client_abb#_msg_area_users">
		<cfset msg_private_users_table = "#arguments.client_abb#_msg_private_conversations_users">
		
		<!---disconnect from organization--->
		<cfquery datasource="#client_dsn#" name="disconnectFromOrganization">
			DELETE
			FROM #msg_organization_users_table#
			WHERE user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<!---disconnect from areas--->
		<cfquery datasource="#client_dsn#" name="disconnectFromAreas">
			DELETE
			FROM #msg_areas_users_table#
			WHERE user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<!---disconnect from private conversations--->
		<cfquery datasource="#client_dsn#" name="disconnectFromPrivateConversations">
			UPDATE #msg_private_users_table#
			SET connected = 0
			WHERE user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
	</cffunction>
	
	
</cfcomponent>
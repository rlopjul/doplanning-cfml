<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 16-01-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 11-03-2009
	
--->
<cfcomponent output="false">

	<cfset component = "MessengerArea">		
	
	<!--- ----------------------- connectToAreaConversation -------------------------------- --->
	
	<!---request:
	<request>
		<parameters>
			<area id=""/>
		</parameters>
	</request>--->

	<!---response:
	<response status="ok/error" method="connectToAreaConversation">
		<result>
			<users>
				<user id="" …/>
				…
			</users>
		</result>
	</response>--->
	
	<cffunction name="connectToAreaConversation" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "connectToAreaConversation">
		
		<cfset var xmlRequest = "">
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">
		
		<cfset var area_id = "">
		<cfset var msg_users_table = "">
						
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
			
			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">
			
			<cfset msg_users_table = "#client_abb#_msg_area_users">
			
			<cfquery datasource="#client_dsn#" name="getIfUserIsConnected">
				SELECT *
				FROM #msg_users_table#
				WHERE user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
				AND area_id = <cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif getIfUserIsConnected.recordCount GT 0>
				<cfinvoke component="MessengerManager" method="disconnectFromConversation" returnvariable="xmlResult">
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>		
			</cfif>
			
			<cfquery datasource="#client_dsn#" name="connectToConversation">
				INSERT INTO #msg_users_table#
				(area_id, user_id) 
				VALUES (
					<cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer">,			
					<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
					);			
			</cfquery>
			
			<cfinvoke component="MessengerManager" method="getConnectedUsers" returnvariable="xmlResult">
				<cfinvokeargument name="area_id" value="#area_id#">
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
	
	
	<!--- ----------------------- disconnectFromAreaConversation -------------------------------- --->
	
	<!---request:
	<request>
		<parameters>
			<area id=""/>
		</parameters>
	</request>--->

	<!---response:
	<response status="ok/error" method="disconnectFromAreaConversation"/>--->
	
	<cffunction name="disconnectFromAreaConversation" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "disconnectFromAreaConversation">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">
		
		<cfset var area_id = "">

		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
			
			<cfinvoke component="MessengerManager" method="disconnectFromConversation" returnvariable="xmlResult">
				<cfinvokeargument name="area_id" value="#area_id#">
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
	
	
	
	<!--- ----------------------- getAreaConversationMessages -------------------------------- --->
	
	<!---request: 
	--->
	
	<!---response:
	--->
	
	<cffunction name="getAreaConversationMessages" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getAreaConversationMessages">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">	
		
		<cfset var area_id = "">
				
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
			
			<cfinvoke component="MessengerManager" method="getNewMessages" returnvariable="xmlResult">
				<cfinvokeargument name="area_id" value="#area_id#">
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
	
	
	<!--- ----------------------- getAreaConversationUsers -------------------------------- --->
	<!---response:
	<response status=”ok/error”>
		<result>
				<users>
					<user  id=”” …/>
					…
				</users>	
		</result>
	</response>--->

	<cffunction name="getAreaConversationUsers" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getAreaConversationUsers">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">	
		
		<cfset var area_id = "">
		
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
			
			<cfinvoke component="MessengerManager" method="getConnectedUsers" returnvariable="xmlResult">
				<cfinvokeargument name="area_id" value="#area_id#">
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
	
	
	<!--- ----------------------- acknowledgeAreaConversationMessages -------------------------------- --->
	
	<!---request: 
	<request method="acknowledgeAreaConversationMessages">
		<parameters>
			<area id=""/>
			<user_messages>
				<user_message/>
			</usersmessages>		
		</parameters>
	</request>
	--->
	
	<!---response:
	<response status="ok/error"/>--->
	
	<cffunction name="acknowledgeAreaConversationMessages" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "acknowledgeAreaConversationMessages">
		
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
	
	<!--- ----------------------- sendAreaConversationMessage -------------------------------- --->
	
	<!---request: 
	--->
	
	<!---response:
	--->
	
	<cffunction name="sendAreaConversationMessage" returntype="xml" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "sendAreaConversationMessage">
		
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
<!---Copyright Era7 Information Technologies 2007-2013

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 13-05-2013

    24-06-2013 alucena: cambiada la ruta de jarPath
	
	
--->
<cfcomponent output="false">
	
	<cfset component = "MeetingManager">
	
	<cfset meetingsUserSessionTable = "meetings_users_sessions">
	
	<cfset apiKey = APPLICATION.openTokApiKey>
	<cfset apiSecret = APPLICATION.openTokApiSecret>
	<!---<cfset jarPath = "#APPLICATION.path#/app/WS/components/opentok-java-sdk-0.91.58-SNAPSHOT.jar">--->

	<cfset jarPath = "libs/opentok-java-sdk-0.91.58-SNAPSHOT.jar">
	
	
	<!--- ----------------------- getUserMeetingSession -------------------------------- --->
	<cffunction name="getUserMeetingSession" access="public" returntype="string">
		<cfargument name="user_a_id" type="numeric" required="yes">
		<cfargument name="user_b_id" type="numeric" required="yes">
		<cfargument name="database_only" type="boolean" required="no" default="false">
		
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">	
		
		<cfset var sessionId = "">
		<cfset var openTokSDK = "">
		
		<cfquery name="getUserSession" datasource="#client_dsn#">
			SELECT user_a_id, user_b_id, session_id
			FROM #client_abb#_#meetingsUserSessionTable# AS users_sessions
			WHERE (users_sessions.user_a_id = <cfqueryparam value="#arguments.user_a_id#" cfsqltype="cf_sql_integer">
			AND users_sessions.user_b_id = <cfqueryparam value="#arguments.user_b_id#" cfsqltype="cf_sql_integer">)
			OR (users_sessions.user_a_id = <cfqueryparam value="#arguments.user_b_id#" cfsqltype="cf_sql_integer">
			AND users_sessions.user_b_id = <cfqueryparam value="#arguments.user_a_id#" cfsqltype="cf_sql_integer">);		
		</cfquery>
		
		<cfif getUserSession.recordCount GT 0>
		
			<cfset sessionId = getUserSession.session_id>
		
		<cfelseif arguments.database_only IS false>
			
			<cfset openTokSDK = createObject("Java", "com.opentok.api.OpenTokSDK", jarPath)>
			<cfset openTokSDK.init(apiKey, apiSecret)>
								
			<cfset openTokSessionProperties = createObject("Java", "com.opentok.api.constants.SessionProperties", jarPath)>
			<cfset openTokSessionProperties.p2p_preference = "enabled">

			<cfset sessionId = openTokSDK.create_session(JavaCast("null", ""), openTokSessionProperties).session_id>
			
			<cftry>

				<cfquery name="saveUserSession" datasource="#client_dsn#">	
					INSERT INTO #client_abb#_#meetingsUserSessionTable#
					SET user_a_id = <cfqueryparam value="#arguments.user_a_id#" cfsqltype="cf_sql_integer">,
					user_b_id = <cfqueryparam value="#arguments.user_b_id#" cfsqltype="cf_sql_integer">,
					session_id = <cfqueryparam value="#sessionId#" cfsqltype="cf_sql_varchar">,
					creation_date = NOW();
				</cfquery>
		
				<cfcatch><!---Si da error se vuelve a pedir la sesion porque el otro usuario puede haberla pedido--->			
					<cfinvoke component="MeetingManager" method="getUserMeetingSession" returnvariable="sessionId">
						<cfinvokeargument name="user_a_id" value="#arguments.user_a_id#">
						<cfinvokeargument name="user_b_id" value="#arguments.user_b_id#">
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
						<cfinvokeargument name="database_only" value="true">
					</cfinvoke>
			
				</cfcatch>
			</cftry>
		
		<cfelse>
			
			<!---Unexpected error--->
			<cfthrow errorcode="1000">
		
		</cfif>
		
		
		<cfreturn sessionId>
	</cffunction>
	
	
	
	
	<!--- ----------------------- getSessionToken -------------------------------- --->
	<cffunction name="getSessionToken" access="public" returntype="string">
		<cfargument name="session_id" type="string" required="yes">

		<cfset var tokenId = "">
		<cfset var openTokSDK = "">
		
			<cfset openTokSDK = createObject("Java", "com.opentok.api.OpenTokSDK", jarPath)>
			<cfset openTokSDK.init(apiKey, apiSecret)>
								
			<cfset openTokRoleConstants = createObject("Java", "com.opentok.api.constants.RoleConstants", jarPath)>
			<cfset tokenId = openTokSDK.generate_token(arguments.session_id, openTokRoleConstants.PUBLISHER)>
		
		<cfreturn tokenId>
	</cffunction>
	

	
</cfcomponent>
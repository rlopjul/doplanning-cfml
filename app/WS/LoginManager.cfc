<!---Copyright Era7 Information Technologies 2007-2008

    File created by: ppareja
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 08-07-2009
	
--->
<cfcomponent output="false">

	<cfset component = "LoginManager">

	<!--- LOGIN USER --->
	
	<cffunction name="loginUser" returntype="string" output="false" access="remote">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "loginUser">
		
		<cfset var client_abb = "">
		<cfset var user_login = "">
		<cfset var password = "">
		
		<cftry>
		
			<cfinclude template="includes/functionStartNoSession.cfm">
			
			<cfset client_abb = xmlRequest.request.parameters.client_abb.xmlText>
			<cfset user_login = xmlRequest.request.parameters.user.xmlAttributes.email>
			<cfset password = xmlRequest.request.parameters.user.xmlAttributes.password>
			
			<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>
			
			<!---Get client data--->
			<cfquery name="getClient" datasource="#APPLICATION.dsn#">
				SELECT id, name, administrator_id, email_support
				FROM APP_clients
				WHERE abbreviation = <cfqueryparam value="#client_abb#" cfsqltype="cf_sql_varchar">;
			</cfquery>
			
			<cfif getClient.RecordCount IS 0><!---Client does not exist--->
		
				<cfset error_code = 301>
	
				<cfthrow errorcode="#error_code#">
		
			</cfif>
			
			<cfinvoke component="UserManager" method="objectUser" returnvariable="objectUser">
				<cfinvokeargument name="xml" value="#xmlRequest.request.parameters.user#">
				<cfinvokeargument name="return_type" value="object">
			</cfinvoke>
			
			<cfif isDefined("APPLICATION.moduleLdapUsers") AND APPLICATION.moduleLdapUsers EQ "enabled"><!---LDAP Login--->
				<cfset ldap_id = "default">
				<cfif isDefined("xmlRequest.request.parameters.ldap.xmlAttributes.id")><!---ldap id: default/diraya--->
					<cfset ldap_id = xmlRequest.request.parameters.ldap.xmlAttributes.id>				
				</cfif>
			
				<cfinvoke component="LoginLDAPManager" method="loginLDAPUser" returnvariable="xmlResponseContent">
					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="objectClient" value="#getClient#">
					<cfinvokeargument name="objectUser" value="#objectUser#">
					<cfinvokeargument name="ldap_id" value="#ldap_id#">
				</cfinvoke>
				
				<cfinclude template="includes/functionEndNoLog.cfm"><!---Aquí no se guarda log porque ya se ha guardado en el método anterior--->
			
			<cfelse><!---Default Login--->
			
				<cfset table = client_abb&"_users">			
			
				<!---  Checking if both user name and password are corrects   --->
				<cfquery name="loginQuery" datasource="#client_dsn#">			
					SELECT users.id, users.number_of_connections, users.language 
					FROM #table# AS users 
					<!---INNER JOIN #client_abb#_user_preferences AS preferences ON users.id = preferences.user_id --->
					WHERE users.email = <cfqueryparam value="#user_login#" cfsqltype="cf_sql_varchar"> AND password = <cfqueryparam value="#password#" cfsqltype="cf_sql_varchar">;
				</cfquery>		
				
				<!--- If at least one record is found, it means that the login is valid --->
				<cfif loginQuery.RecordCount GREATER THAN 0>
					
					<cfset objectUser.id = loginQuery.id>
					<cfset objectUser.language = loginQuery.language>
					<cfset objectUser.number_of_connections = loginQuery.number_of_connections>
				
					<cfinvoke component="LoginManager" method="loginUserInApplication" returnvariable="xmlResponseContent">
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="objectClient" value="#getClient#">
						<cfinvokeargument name="objectUser" value="#objectUser#">
					</cfinvoke>
					
					<cfinclude template="includes/functionEndNoLog.cfm"><!---Aquí no se guarda log porque ya se ha guardado en el método anterior--->
				
				<cfelse>
				
					<cfset login_message = "Usuario o contraseña incorrecta.">
			
					<cfsavecontent variable="xmlResponseContent">
						<cfoutput><login valid="false"><message><![CDATA[#login_message#]]></message></login></cfoutput>
					</cfsavecontent>
					
					<cfinclude template="includes/functionEndNoSession.cfm">
			
				</cfif>
			
			</cfif>
			
			
			<cfcatch>
				<cfset xmlResponseConent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
			
		</cftry>
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- loginUserInApplication --->
	
	<cffunction name="loginUserInApplication" returntype="string" output="false" access="public">
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="objectClient" type="any" required="yes">
		<cfargument name="objectUser" type="struct" required="yes">
		
		<cfset var method = "loginUserInApplication">
		
		<cfset var user_login = "">
		<cfset var password = "">
		<cfset var returnValue = "">
		
		
			<cfinclude template="includes/functionStartNoSession.cfm">
			
			<cfset user_login = objectUser.email>
			<cfset password = objectUser.password>
			
			<cfset role = "general">
			
			<cfif getAuthUser() NEQ "">			
				<cflogout>
				
				<!---Check if SESSION vars exists--->
				<cfif isDefined("SESSION.user_id")>
					<cfset StructDelete(SESSION, "user_id")>
				</cfif>
				<cfif isDefined("SESSION.client_abb")>
					<cfset StructDelete(SESSION, "client_abb")>
				</cfif>
				<cfif isDefined("SESSION.user_language")>
					<cfset StructDelete(SESSION, "user_language")>
				</cfif>
				<cfif isDefined("SESSION.client_id")>
					<cfset StructDelete(SESSION, "client_id")>
				</cfif>
				<cfif isDefined("SESSION.client_name")>
					<cfset StructDelete(SESSION, "client_name")>
				</cfif>
				<cfif isDefined("SESSION.client_administrator")>
					<cfset StructDelete(SESSION, "client_administrator")>
				</cfif>
				<cfif isDefined("SESSION.app_client_version")>
					<cfset StructDelete(SESSION, "app_client_version")>
				</cfif>
				<cfif isDefined("SESSION.client_email_support")>
					<cfset StructDelete(SESSION, "client_email_support")>
				</cfif>
				<cfif isDefined("SESSION.client_email_from")>
					<cfset StructDelete(SESSION, "client_email_from")>
				</cfif>
				<!---<cfset getPageContext().getSession().invalidate()>--->
			</cfif>	
			
			<!---  CFLOGIN   --->
			<cflogin>			
				
				<cfset user_id = arguments.objectUser.id>
				
				<!---Save user_id, client_abb and language in SESSION--->
				<cfset SESSION.user_id = #user_id#>
				<cfset SESSION.client_abb = arguments.client_abb>
				<!---Hay que obtener de las preferencias el idioma--->
				<cfset SESSION.user_language = objectUser.language>
					
				<cfset SESSION.client_id = objectClient.id>
				<cfset SESSION.client_name = objectClient.name>
				<cfset SESSION.client_administrator = objectClient.administrator_id>
				<cfset SESSION.client_email_support = objectClient.email_support>
				<cfset SESSION.client_email_from = """#APPLICATION.title#"" <#objectClient.email_support#>">
				
				<cfloginuser name="#user_login#" password="#password#" roles="#role#">				
					
				<!---  Managing user connections to the program --->
				<cfset connections = #objectUser.number_of_connections#+1>
				<!---<cfset lastConnection = '#DateFormat(Now())# #TimeFormat(Now())#'>--->
				<!--- Here we set the user's state to connected and update the number of connections he has alaready stablished as --->
				<!--- well as setting the time and date of the last connection of the user --->
				<cfquery datasource="#client_dsn#" name="beginQuery">
					BEGIN;
				</cfquery>	
				
				<cfset users_table = client_abb&"_users">
				
				<cfquery datasource="#client_dsn#" name="manageConnectionsQuery">
					UPDATE #users_table#
					SET connected=1,
					number_of_connections=#connections#,
					last_connection = now()
					WHERE id=<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;					
				</cfquery>
				
				<cfquery datasource="#client_dsn#" name="sessionQuery">
					UPDATE #users_table#
					SET session_id='#SESSION.SessionID#'
					WHERE id=<cfqueryparam value="#user_id#" cfsqltype="cf_sql_numeric">;
				</cfquery>
				
				<cfquery datasource="#client_dsn#" name="commitQuery">
					COMMIT;						
				</cfquery>
				
				<cfif APPLICATION.moduleMessenger EQ "enabled">
					<cfinvoke component="MessengerManager" method="disconnectUser">
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="user_id" value="#user_id#">
					</cfinvoke>
				</cfif>
								
				<cfset returnValue = "true">
									
			</cflogin>	
			
			<cfsavecontent variable="xmlResponse">
				<cfoutput>
					<login valid="#returnValue#"></login>
				</cfoutput>
			</cfsavecontent>
					
			<cfinclude template="includes/functionEndOnlyLog.cfm">
			
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- LOG OUT USER --->
	
	<cffunction name="logOutUser" returntype="string" output="false" access="remote">
		<!---<cfargument name="userName" type="string" required="true">--->
		
		<cfset var method = "logOutUser">

		<cftry>
		
			<cfinclude template="includes/functionStartNoSession.cfm">
			
			<!---<cfset userName = xmlRequest.request.parameters.user.xmlAttributes.id>--->
			
			<cfif isDefined("SESSION.user_id")>
				<cfset user_id = SESSION.user_id>
			</cfif>
			
			<cfif isDefined("SESSION.client_abb")>
				<cfset client_abb = SESSION.client_abb>
				<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>
			</cfif>
			
			<cfif isDefined("user_id") AND isDefined("client_abb")>
				<!---The log is saved here because it needs the SESSION vars, and later are deleted--->
				<cfinclude template="includes/logRecord.cfm">
				
				<cfif APPLICATION.moduleMessenger EQ "enabled">
					<cfinvoke component="MessengerManager" method="disconnectUser">
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="user_id" value="#user_id#">
					</cfinvoke>
				</cfif>
				
				<cfquery name="logoutQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users
					SET connected=<cfqueryparam value="0" cfsqltype="cf_sql_integer">
					WHERE id=<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
			
			</cfif>
			
			<cflogout>
			
			<!---Check if SESSION vars exists--->
			<cfif isDefined("SESSION.user_id")>
				<cfset StructDelete(SESSION, "user_id")>
			</cfif>
			<cfif isDefined("SESSION.client_abb")>
				<cfset StructDelete(SESSION, "client_abb")>
			</cfif>
			<cfif isDefined("SESSION.user_language")>
				<cfset StructDelete(SESSION, "user_language")>
			</cfif>
			<cfif isDefined("SESSION.client_id")>
				<cfset StructDelete(SESSION, "client_id")>
			</cfif>
			<cfif isDefined("SESSION.client_name")>
				<cfset StructDelete(SESSION, "client_name")>
			</cfif>
			<cfif isDefined("SESSION.client_administrator")>
				<cfset StructDelete(SESSION, "client_administrator")>
			</cfif>
			<cfif isDefined("SESSION.app_client_version")>
				<cfset StructDelete(SESSION, "app_client_version")>
			</cfif>
			<cfif isDefined("SESSION.client_email_support")>
				<cfset StructDelete(SESSION, "client_email_support")>
			</cfif>
			<cfif isDefined("SESSION.client_email_from")>
				<cfset StructDelete(SESSION, "client_email_from")>
			</cfif>
			
			<!---<cfreturn true>--->
			<cfset xmlResponseContent = "true">	

			<cfset status = "ok">
			<!---The log is saved before in this method--->
			<cfinclude template="includes/generateResponse.cfm">
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
	
		<cfreturn xmlResponse>
	
	</cffunction>
	
	
	<!--- LOG OUT USER NOT CONNECTED--->
	
	<cffunction name="logOutUserNotConnected" returntype="string" output="false" access="public">
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="user_id" type="string" required="true">
		
		<cfset var method = "logOutUserNotConnected">

		<cftry>
		
			<cfinclude template="includes/functionStartNoSession.cfm">
			
			<cfif APPLICATION.moduleMessenger EQ "enabled">
				<cfinvoke component="MessengerManager" method="disconnectUser">
					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="user_id" value="#arguments.user_id#">
				</cfinvoke>
			</cfif>
				
			<cfquery name="logoutQuery" datasource="#client_dsn#">
				UPDATE #arguments.client_abb#_users
				SET connected=<cfqueryparam value="0" cfsqltype="cf_sql_integer">
				WHERE id=<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<!---<cfreturn true>--->
			<cfset xmlResponseContent = "true">	

			<cfset status = "ok">
			<!---The log is saved before in this method--->
			<cfinclude template="includes/generateResponse.cfm">
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
	
		<cfreturn xmlResponse>
	
	</cffunction>


	<!--- ONE USER IS ALREADY LOGGED IN --->

	<cffunction name="oneUserIsAlreadyLoggedIn" returntype="String" output="false" access="remote">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "oneUserIsAlreadyLoggedIn">
		
		<cftry>
			<cfinclude template="includes/functionStartNoSession.cfm">			
			
			<cfset app_client_login_version = xmlRequest.request.parameters.app_client_version.xmlText>
			
			
			<cfif APPLICATION.clientLoginVersion NEQ app_client_login_version>
				
				<cfset error_code = 1004>
						
				<cfthrow errorcode="#error_code#">
				
			</cfif>
			
			<cfif getAuthUser() NEQ "">
			
				<cfset result = true>
			
			<cfelse>
				
				<cfset result = false>
				
			</cfif>
			
			<cfset xmlResponseContent = "<value><![CDATA[#result#]]></value>">
		
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = "">
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>


	<!--- GET USER LOGGED IN --->

	<cffunction name="getUserLoggedIn" returntype="String" access="remote">
			
		<cfset var method = "getUserLoggedIn">
		
		<cfset var xmlResponseContent = "">
		
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfif isDefined("SESSION.user_id")>
			
				<cfinvoke component="UserManager" method="getUser" returnvariable="xmlResponseContent">
					<cfinvokeargument name="get_user_id" value="#user_id#">
					<cfinvokeargument name="format_content" value="all">
				</cfinvoke>
				
				<cfinclude template="includes/functionEndNoLog.cfm">
				
			</cfif>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- --------------------------------- sendClientAppVersion --------------------------------- --->

	<cffunction name="sendClientAppVersion" returntype="String" access="remote">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "sendClientAppVersion">
		
		<cfset var xmlResponseContent = "">
		
		<cftry>
			
			<cfinclude template="includes/functionStartNoSession.cfm">
			
			<cfset app_client_version = xmlRequest.request.parameters.app_client_version.xmlText>
			
			<cfif APPLICATION.clientVersion NEQ app_client_version>
				
				<cfset error_code = 1004>
						
				<cfthrow errorcode="#error_code#">
			
			<cfelse>
				
				<cfset SESSION.app_client_version = app_client_version>
			
				<cfset xmlResponseContent = "<app_client_version><![CDATA["&app_client_version&"]]></app_client_version>">
			</cfif>
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	<!--- ----------------------- sendEmailToAdministrator -------------------------------- --->
	
	<cffunction name="sendEmailToAdministrator" returntype="String" output="false" access="remote">		
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "sendEmailToAdministrator">
		
		<cfset var client_abb = "">
		
		<cfset var from = "">
		<cfset var recipient = "">
		<cfset var subject = "">
		<cfset var text = "">
		<cfset var html = "">
						
		<cftry>
		
			<cfinclude template="includes/functionStartNoSession.cfm">
	
			<cfset client_abb = xmlRequest.request.parameters.client_abb.xmlText>
	
			<cfset from = xmlRequest.request.parameters.notification.xmlAttributes.from>
			<cfset subject = xmlRequest.request.parameters.notification.subject.xmlText>
			<cfset html_text = xmlRequest.request.parameters.notification.html_text.xmlText>
			
			<cfquery datasource="#APPLICATION.dsn#" name="getClient">
				SELECT *
				FROM APP_clients
				WHERE abbreviation = <cfqueryparam value="#client_abb#" cfsqltype="cf_sql_varchar">;
			</cfquery>
			
			<cfif getClient.RecordCount IS 0><!---Client does not exist--->
			
				<cfset error_code = 301>
	
				<cfthrow errorcode="#error_code#">
		
			</cfif>
			
			<cfset SESSION.client_email_support = getClient.email_support>
			
			<cfset recipient = getClient.email_support>
			
			<cfset email_type = "html">	
			<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">Este email ha sido enviado mediante la aplicación #APPLICATION.title# para contactar con el administrador de la organización.</p>'>			
						
			<cfset html_text = "<b>Asunto:</b> #subject#<br /> <b>Remitente:</b> #from#<br /><br/>"&html_text>
			
			<cfinvoke component="EmailManager" method="sendEmail">
				<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
				<cfinvokeargument name="to" value="#recipient#">
				<cfinvokeargument name="subject" value="Solicitud de ayuda de usuario de DoPlanning">
				<cfinvokeargument name="content" value="#html_text#">
				<cfinvokeargument name="foot_content" value="#foot_content#">
				<cfinvokeargument name="styles" value="false">
			</cfinvoke>			 
			
			<cfset xmlResponseContent = '<notification from="#from#"/>'>
		
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
		
	</cffunction>
	
	<!--- CHECK USER LOGGED IN AREA--->
	<!---ESTE MÉTODO NO SE USA, SE USA DIRECTAMENTE checkUserArea--->
	<!---<cffunction name="checkUserLoggedInArea" returntype="String" access="public">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "checkUserLoggedInArea">
		
		<cfset var area_id = "">
		
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
			
			<cfinvoke component="UserManager" method="checkUserArea" returnvariable="response">
				<cfinvokeargument name="request" value='<request><parameters><user id="#user_id#" /><area id="#area_id# /></parameters></request>'>
			</cfinvoke>
			
			<cfxml variable="xmlResponse">
			<cfoutput>
			#response#
			</cfoutput>
			</cfxml>
			
			<cfset xmlResponse.response.xmlAttributes.component = component>
			<cfset xmlResponse.response.xmlAttributes.method = method>
			
			<!---<cfinclude template="includes/functionEndNoLog.cfm">--->
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>--->
	
	<!--- LOGIN ADMINISTRATOR --->
	<!---ESTE MÉTODO NO SE USA--->
	
	
	<!--- LOG IN ERA7 CLIENT ADMINISTRATOR --->
	<!---ESTE MÉTODO NO SE USA--->
	

</cfcomponent>
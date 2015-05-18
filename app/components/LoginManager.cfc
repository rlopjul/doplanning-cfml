<!---Copyright Era7 Information Technologies 2007-2014

    File created by: ppareja
    ColdFusion version required: 8
    Last file change by: alucena
	
	17-01-2013 alucena: añadido generateNewPassword
	10-04-2013 alucena: en loginUser se borra la sesion y se hace logout lo primero (antes se hacía en loginUserInApplication)
	21-05-2013 alucena: no se añade el nombre de la dirección de correo en SESSION.client_email_from porque Mandrill no lo permite
	
--->
<cfcomponent output="true">

	<cfset component = "LoginManager">

	<!--- LOGIN USER --->
	
	<cffunction name="loginUser" returntype="struct" output="true" access="public">
		<cfargument name="login" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="password_encoded" type="boolean" required="false" default="true">
		<cfargument name="ldap_id" type="string" required="false" default="doplanning"><!---ldap id: asnc/diraya/dmsas/portalep_hcs--->
		<cfargument name="client_abb" type="string" required="true">

		<cfset var method = "loginUser">
			
		<cfset var response = structNew()>

		<cfset var client_dsn = "">
		<cfset var ldapLogin = false>
		
		<cftry>

			<cfinclude template="includes/functionStartNoSession.cfm">
			
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
				<cfif isDefined("SESSION.client_app_title")>
					<cfset StructDelete(SESSION, "client_app_title")>
				</cfif>
				<cfif isDefined("SESSION.client_administrator")>
					<cfset StructDelete(SESSION, "client_administrator")>
				</cfif>
				<!---<cfif isDefined("SESSION.app_client_version")>
					<cfset StructDelete(SESSION, "app_client_version")>
				</cfif>--->
				<cfif isDefined("SESSION.client_email_support")>
					<cfset StructDelete(SESSION, "client_email_support")>
				</cfif>
				<cfif isDefined("SESSION.client_email_from")>
					<cfset StructDelete(SESSION, "client_email_from")>
				</cfif>
				<!---<cfif isDefined("SESSION.client_force_notifications")>
					<cfset StructDelete(SESSION, "client_force_notifications")>					
				</cfif>--->
			</cfif>	
			
			<cfif APPLICATION.moduleLdapUsers IS false OR arguments.ldap_id EQ "doplanning">
				<cfif arguments.password_encoded NEQ true>
					<cfset arguments.password = lCase(hash(arguments.password))>
				</cfif>
			</cfif>

			<cfset client_dsn = APPLICATION.identifier&"_"&arguments.client_abb>
			
			<!---Get client data--->
			<!---
			<cfquery name="getClient" datasource="#APPLICATION.dsn#">
				SELECT id, name, administrator_id, email_support, force_notifications
				FROM app_clients
				WHERE abbreviation = <cfqueryparam value="#arguments.client_abb#" cfsqltype="cf_sql_varchar">;
			</cfquery>
			
			<cfif getClient.RecordCount IS 0><!---Client does not exist--->
		
				<cfset error_code = 301>
	
				<cfthrow errorcode="#error_code#">
		
			</cfif>--->

			<!--- getClient --->
			<cfinvoke component="#APPLICATION.componentsPath#/ClientManager" method="getClient" returnvariable="getClientResponse">
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			</cfinvoke>

			<cfset getClient = getClientResponse.client>
			
			<cfinvoke component="UserManager" method="objectUser" returnvariable="objectUser">
				<cfinvokeargument name="email" value="#arguments.login#"/>
				<cfinvokeargument name="password" value="#arguments.password#"/>
				<cfinvokeargument name="return_type" value="object"/>
			</cfinvoke>
			
			<cfif APPLICATION.moduleLdapUsers IS true><!---LDAP Login--->

				<cfif arguments.ldap_id EQ "doplanning">
					<cfset ldapLogin = false>
				<cfelse>
					<cfset ldapLogin = true>
				</cfif>

			<cfelse>
				<cfset ldapLogin = false>
			</cfif>


			<cfif ldapLogin IS true><!---LDAP Login--->				
			
				<cfinvoke component="LoginLDAPManager" method="loginLDAPUser" returnvariable="response">
					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="objectClient" value="#getClient#">
					<cfinvokeargument name="objectUser" value="#objectUser#">
					<cfinvokeargument name="ldap_id" value="#arguments.ldap_id#">
				</cfinvoke>
				
				<!---Aquí no se guarda log porque ya se ha guardado en el método anterior--->
			
			<cfelse><!---Default Login (DoPlanning)--->
			
				<cfset table = client_abb&"_users">			
			
				<!---  Checking if both user name and password are corrects   --->
				<cfquery name="loginQuery" datasource="#client_dsn#">			
					SELECT users.id, users.number_of_connections, users.language, users.enabled
					FROM #table# AS users 
					WHERE users.email = <cfqueryparam value="#arguments.login#" cfsqltype="cf_sql_varchar"> 
					AND password = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar">;
				</cfquery>		
				
				<!--- If at least one record is found, it means that the login is valid --->
				<cfif loginQuery.RecordCount GT 0>
					
					<cfif loginQuery.enabled IS true>
						
						<cfset objectUser.id = loginQuery.id>
						<cfset objectUser.language = loginQuery.language>
						<cfset objectUser.number_of_connections = loginQuery.number_of_connections>
					
						<cfinvoke component="LoginManager" method="loginUserInApplication" returnvariable="response">
							<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
							<cfinvokeargument name="objectClient" value="#getClient#">
							<cfinvokeargument name="objectUser" value="#objectUser#">
						</cfinvoke>
						
						<!---Aquí no se guarda log porque ya se ha guardado en el método anterior--->

					<cfelse>

						<cfset response_message = "Cuenta de usuario deshabilitada">
					
						<cfset response = {result=false, message=#response_message#}>

					</cfif>
				
				<cfelse>
				
					<cfset response_message = "Usuario o contraseña incorrecta.">
					
					<cfset response = {result=false, message=#response_message#}>

					<!---IMPORTANTE: aquí se guarda log del intento de login fallido--->
					<cfinclude template="includes/logRecordNoSession.cfm">
								
				</cfif>
			
			</cfif>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	
	
	<!--- loginUserInApplication --->
	
	<cffunction name="loginUserInApplication" returntype="struct" output="false" access="public">
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="objectClient" type="any" required="yes">
		<cfargument name="objectUser" type="struct" required="yes">
		
		<cfset var method = "loginUserInApplication">
		
		<cfset var response = structNew()>

		<cfset var user_login = "">
		<cfset var password = "">		
		
			<cfinclude template="includes/functionStartNoSession.cfm">
			
			<cfset user_login = objectUser.email>
			<cfset password = objectUser.password>
			
			<cfset role = "general">
			
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
				<cfset SESSION.client_app_title = objectClient.app_title>
				<cfset SESSION.client_administrator = objectClient.administrator_id>
				<cfset SESSION.client_email_support = objectClient.email_support>
				<!---<cfset SESSION.client_email_from = """#APPLICATION.title#"" <#objectClient.email_support#>">--->
				<!---No se incluye el nombre junto con la dirección porque Mandrill no lo permite--->
				<cfset SESSION.client_email_from = objectClient.email_support>
				<!---
				<cfset SESSION.client_force_notifications = objectClient.force_notifications><!--- Esta variable se almacena en sesion para evitar el error "can't use different connections inside a transaction" --->
				--->
				
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
				
				<cfif APPLICATION.moduleMessenger EQ true>
					<cfinvoke component="MessengerManager" method="disconnectUser">
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="user_id" value="#user_id#">
					</cfinvoke>
				</cfif>
																	
			</cflogin>	

			<cfinclude template="includes/functionEndOnlyLog.cfm">

			<cfset response = {result=true, message=""}>

		<cfreturn response>
		
	</cffunction>
	
	
	<!--- LOG OUT USER --->
	
	<cffunction name="logOutUser" returntype="struct" output="false" access="public">
		
		<cfset var method = "logOutUser">

		<cfset var response = structNew()>

		<cftry>
		
			<cfinclude template="includes/functionStartNoSession.cfm">
						
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
				
				<cfif APPLICATION.moduleMessenger EQ true>
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
			<cfif isDefined("SESSION.client_app_title")>
				<cfset StructDelete(SESSION, "client_app_title")>
			</cfif>
			<cfif isDefined("SESSION.client_administrator")>
				<cfset StructDelete(SESSION, "client_administrator")>
			</cfif>
			<!---<cfif isDefined("SESSION.app_client_version")>
				<cfset StructDelete(SESSION, "app_client_version")>
			</cfif>--->
			<cfif isDefined("SESSION.client_email_support")>
				<cfset StructDelete(SESSION, "client_email_support")>
			</cfif>
			<cfif isDefined("SESSION.client_email_from")>
				<cfset StructDelete(SESSION, "client_email_from")>
			</cfif>
			<!---<cfif isDefined("SESSION.client_force_notifications")>
				<cfset StructDelete(SESSION, "client_force_notifications")>					
			</cfif>--->

			<!---The log is saved before in this method--->

			<cfset response = {result=true, message=""}>
			
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
	
	</cffunction>
	
	
	<!--- LOG OUT USER NOT CONNECTED--->
	
	<cffunction name="logOutUserNotConnected" returntype="string" output="false" access="public">
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="user_id" type="string" required="true">
		
		<cfset var method = "logOutUserNotConnected">

		<cftry>
		
			<cfinclude template="includes/functionStartNoSession.cfm">
			
			<cfif APPLICATION.moduleMessenger EQ true>
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



	<!--- GET USER LOGGED IN --->
 
	<cffunction name="getUserLoggedIn" returntype="struct" access="public">
				
		<cfset var method = "getUserLoggedIn">
		
		<cfset var response = structNew()>

		<cftry>
						
			<cfif isDefined("SESSION.user_id")>
			
				<cfinvoke component="UserManager" method="getUser" returnvariable="userQuery">
					<cfinvokeargument name="get_user_id" value="#SESSION.user_id#">
					<cfinvokeargument name="format_content" value="all">
					<cfinvokeargument name="return_type" value="query">
				</cfinvoke>
				
				<cfset response = {result=true, user=userQuery}>
				
			<cfelse>

				<cfset error_code = 102>
				
				<cfthrow errorcode="#error_code#">

			</cfif>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
			
	</cffunction>
	
	
	
	<!--- --------------------------------- sendClientAppVersion --------------------------------- --->

	<!--- Este método DEBE DEJAR DE USARSE cuando se deshabilite la versión de Flex --->

	<!--- 
	<cffunction name="sendClientAppVersion" returntype="String" access="public">
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
		
	</cffunction> --->
	
	
	<!--- ----------------------- sendEmailToAdministrator -------------------------------- --->
	
	<cffunction name="sendEmailToAdministrator" returntype="String" output="false" access="public">		
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
				FROM app_clients
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
				<cfinvokeargument name="subject" value="Solicitud de ayuda de usuario de APPLICATION.title">
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
	
	
	
	<cffunction name="generateNewPassword" output="false" access="public" returntype="struct">
		<cfargument name="email_login" type="string" required="yes">
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="language" type="string" required="true"/>
		
		<cfset var method = "generateNewPassword">
		
		<cfset var message = "">
		<cfset var result = false>
				
		<cfset var user_email_login = Trim(arguments.email_login)>
		
		<cfset var client_dsn = APPLICATION.identifier&"_"&client_abb>
		
		<cftry>
		
			<cfif len(arguments.email_login) GT 0>
								
				<cfquery datasource="#client_dsn#" name="getUser">
					SELECT id, name, family_name, enabled
					FROM #client_abb#_users
					WHERE email = <cfqueryparam value="#user_email_login#" cfsqltype="cf_sql_varchar">;
				</cfquery>
				
				<cfif getUser.recordCount GT 0>

					<cfif getUser.enabled IS true>
						
						<!--- <cfset new_password = generatePassword(8)> --->

						<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="generatePassword" returnvariable="new_password">
							<cfinvokeargument name="numberofCharacters" value="8">
						</cfinvoke>
					
						<cfset new_password_encoded = hash(new_password)>
					
						<cfquery datasource="#client_dsn#" name="generateNewPassword">
							UPDATE #client_abb#_users
							SET password = <cfqueryparam value="#new_password_encoded#" cfsqltype="cf_sql_varchar">
							WHERE id = <cfqueryparam value="#getUser.id#" cfsqltype="cf_sql_integer">;
						</cfquery>
						
						<cfinvoke component="AlertManager" method="generateNewPassword">					
							<cfinvokeargument name="user_full_name" value="#getUser.family_name# #getUser.name#">
							<cfinvokeargument name="user_email" value="#user_email_login#">
							<cfinvokeargument name="user_password" value="#new_password#">
							<cfinvokeargument name="user_language" value="#arguments.language#"/>
							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>
						
						<cfset result = true>
						<cfset message = "Su nueva contraseña ha sido enviada a su dirección de email">

					<cfelse>

						<cfset result = false>
						<cfset message = "Cuenta de usuario deshabilitada">

					</cfif>
				
				<cfelse>
				
					<cfset result = false>
					<cfset message = "No existe ningún usuario con la dirección de email introducida">
				
				</cfif>
				
			<cfelse>
			
				<cfset result = false>
				<cfset message = "Por favor, introduzca su dirección de email">
			
			</cfif>
				
			<cfset response = {result=#result#, message=#message#}>		
			
			
			<!---saveLog--->
			<cfset log_content = arguments.email_login>

			<cfinvoke component="#APPLICATION.componentsPath#/LogManager" method="saveLog">
				<cfinvokeargument name="log_component" value="#component#" >
				<cfinvokeargument name="log_method" value="#method#">
				<cfinvokeargument name="log_content" value="#log_content#">
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			</cfinvoke>
			
			<cfcatch>
			
				<cfinclude template="#APPLICATION.componentsPath#/includes/errorHandlerStruct.cfm">
				
				<cfset message = "Ha ocurrido un error al generar la nueva contraseña. Disculpe las molestias.">
				
				<cfset response = {result=false, message=#message#}>
			
			</cfcatch>
		
		</cftry>
			
		<cfreturn response>
		
	</cffunction>	
	
	
</cfcomponent>
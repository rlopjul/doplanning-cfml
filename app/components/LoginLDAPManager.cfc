<!---Copyright Era7 Information Technologies 2007-2013

	Date of file creation: 09-03-2013
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 10-06-2013
	
--->
<cfcomponent output="false">

	<cfset component = "LoginLDAPManager">
	
	
	<cffunction name="loginLDAPUser" returntype="string" output="false" access="public">
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="objectClient" type="any" required="yes">
		<cfargument name="objectUser" type="struct" required="yes">
		<cfargument name="ldap_id" type="string" required="no" default="default">
		
		<cfset var method = "loginLDAPUser">
		
		<cfset var user_login = "">
		<cfset var password = "">
		<cfset var password_ldap = "">
		<cfset var login_ldap_column = "">
		<cfset var loginValid = false>
		
		
			<cfinclude template="includes/functionStartNoSession.cfm">
			
			<cfset user_login = arguments.objectUser.email>
			<cfset password = arguments.objectUser.password>
			
			<!---Importante:
			Para comparar con passwords codificados en MD5 en LDAP, es necesario hacer lo siguiente:
			1º Codificar en md5 el password y pasarlo a minúscula
			2º Decodificar el string generado de hexadecimal
			3º Codificar el string generado en binario base64
			4º Añadir el string {MD5} al principio del string generado
			
			Para obtener el string MD5 a partir del guardado en el LDAP, hay que repetir el proceso a la inversa
			--->
						
			<!---<cfset password_ldap = lCase(password)>
			<cfset password_ldap = binaryDecode(password_ldap,"Hex")>
			<cfset password_ldap = binaryEncode(password_ldap,"Base64")>
			<cfset password_ldap = "{MD5}"&password_ldap>--->
			<cfset password_ldap = password>

			<cfif arguments.ldap_id EQ "default"><!---Default LDAP--->
				
				<!---<cfldap server="#APPLICATION.ldapServer#" port="#APPLICATION.ldapServerPort#" username="#APPLICATION.ldapServerUserName#" password="#APPLICATION.ldapServerPassword#" action="query" name="getUser" start="#APPLICATION.ldapUsersPath#" scope="#APPLICATION.ldapScope#" attributes="#APPLICATION.ldapUsersLoginAtt#,#APPLICATION.ldapUsersPasswordAtt#" filter="(&(#APPLICATION.ldapUsersLoginAtt#=#user_login#)(#APPLICATION.ldapUsersPasswordAtt#=#password_ldap#))">--->
				<cftry>
					<cfldap	server="#APPLICATION.ldapServer#" port="#APPLICATION.ldapServerPort#" username="#user_login#@areanorte" password="#password_ldap#" action="query" name="getUser" start="#APPLICATION.ldapUsersPath#" scope="#APPLICATION.ldapScope#" attributes="#APPLICATION.ldapUsersLoginAtt#" filter="(#APPLICATION.ldapUsersLoginAtt#=#user_login#)">
					
					<cfset login_ldap_column = "login_ldap">
					
					<cfset loginValid = true>
					
					<cfcatch>
						<cfset loginValid = false>
					</cfcatch>
				</cftry>

			<cfelseif arguments.ldap_id EQ "dmsas"><!--- Dominio Corporativo del SAS --->

				<!--- <cfldap	server="10.201.79.21" username="DMSAS\lucenaalexis21K" password="allugi3946" action="query" scope="subtree" name="getUser" attributes="cn" start="DC=DMSAS" filter="(1=1)"> --->

				<cftry>

					<cfldap	server="10.201.79.21" username="DMSAS\#user_login#" password="#password_ldap#" action="query" scope="subtree" name="getUser" attributes="cn" start="DC=DMSAS" filter="(1=1)">

					<cfset login_ldap_column = "login_ldap">

					<cfset loginValid = true>

					<cfcatch>
						<cfset loginValid = false>
					</cfcatch>
				</cftry>

			<cfelseif arguments.ldap_id EQ "diraya">
			
				<!---<cfldap server="#APPLICATION.ldapServer#" port="#APPLICATION.ldapServerPort#" username="#APPLICATION.ldapServerUserName#" password="#APPLICATION.ldapServerPassword#" action="query" name="getUser" start="#APPLICATION.ldapUsersPath#" scope="#APPLICATION.ldapScope#" attributes="#APPLICATION.ldapUsersLoginAtt#,#APPLICATION.ldapUsersPasswordAtt#" filter="(&(#APPLICATION.ldapUsersLoginAtt#=#user_login#)(#APPLICATION.ldapUsersPasswordAtt#=#password_ldap#))">--->
								
				<cftry>
					<cfldap	server="10.75.2.64" username="#user_login#@diraya" password="#password_ldap#" action="query" name="getUser" start="dc=diraya.sspa.junta-andalucia.es" attributes="*" filter="(1=1)">
					
					<cfset login_ldap_column = "login_diraya">
					
					<cfset loginValid = true>
					
					<cfcatch>
						<cfset loginValid = false>
					</cfcatch>
				</cftry>
			
			</cfif>
			
			<cfif loginValid IS true><!---AND getUser.recordCount GT 0--->
					
					<cfset table = arguments.client_abb&"_users">			
				
					<!---  Checking if both user name and password are corrects   --->
					<cfquery name="loginQuery" datasource="#client_dsn#">			
						SELECT users.id, users.number_of_connections, users.language, users.enabled
						FROM #table# AS users 
						WHERE users.#login_ldap_column# = <cfqueryparam value="#user_login#" cfsqltype="cf_sql_varchar">;
					</cfquery>		
					
					<!--- If at least one record is found, it means that the login is valid --->
					<cfif loginQuery.RecordCount GT 0>

						<cfif loginQuery.enabled IS true>
						
							<cfset objectUser.id = loginQuery.id>
							<cfset objectUser.language = loginQuery.language>
							<cfset objectUser.number_of_connections = loginQuery.number_of_connections>
						
							<cfinvoke component="LoginManager" method="loginUserInApplication" returnvariable="loginResult">
								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="objectClient" value="#objectClient#">
								<cfinvokeargument name="objectUser" value="#objectUser#">
							</cfinvoke>

							<cfsavecontent variable="xmlResponse">
								<cfoutput><login valid="#loginResult.result#"></login></cfoutput>
							</cfsavecontent>
							
							<!---<cfinclude template="includes/functionEndNoLog.cfm">---><!---Aquí no se guarda log porque ya se ha guardado en el método anterior--->
							
							<!---En este método solo se guarda log cuando el login (usuario o password) no es correcto--->

						<cfelse>

							<cfset login_message = "Cuenta de usuario deshabilitada.">
						
							<cfsavecontent variable="xmlResponse">
								<cfoutput><login valid="false"><message><![CDATA[#login_message#]]></message></login></cfoutput>
							</cfsavecontent>

						</cfif>
						
					<cfelse>
					
						<cfset login_message = "Usuario no disponible en esta aplicación.">
				
						<cfsavecontent variable="xmlResponse">
							<cfoutput><login valid="false"><message><![CDATA[#login_message#]]></message></login></cfoutput>
						</cfsavecontent>
						
						<cfinclude template="includes/logRecordNoSession.cfm">
				
					</cfif>
				
			<cfelse>
			
				<cfset login_message = "Usuario o contraseña incorrecta.">
			
				<cfsavecontent variable="xmlResponse">
					<cfoutput><login valid="false"><message><![CDATA[#login_message#]]></message></login></cfoutput>
				</cfsavecontent>
				
				<cfinclude template="includes/logRecordNoSession.cfm">
				
			</cfif>
			

		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
</cfcomponent>
<!--- Copyright Era7 Information Technologies 2007-2014 --->

<cfcomponent output="false">

	<cfset component = "LoginLDAPManager">


	<cffunction name="loginLDAPUser" returntype="struct" output="false" access="package">
		<cfargument name="ldap_id" type="string" required="true">
		<cfargument name="objectClient" type="any" required="true">
		<cfargument name="user_login" type="string" required="true">
		<cfargument name="password" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">

		<cfset var method = "loginLDAPUser">

		<cfset var response = structNew()>

		<cfset var password_ldap = "">
		<cfset var login_ldap_column = "">
		<cfset var loginValid = false>
		<cfset var loginMessage = "">
		<cfset var name_ldap = "">
		<cfset var family_name_ldap = "">


			<cfinclude template="includes/functionStartNoSession.cfm">

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
			<cfset password_ldap = arguments.password>

			<cfif arguments.ldap_id EQ "asnc"><!---Default LDAP ASNC--->

				<cftry>
					<cfldap	server="#APPLICATION.ldapServer#" port="#APPLICATION.ldapServerPort#" username="#user_login#@areanorte" password="#password_ldap#" action="query" name="getUser" start="#APPLICATION.ldapUsersPath#" scope="#APPLICATION.ldapScope#" attributes="#APPLICATION.ldapUsersLoginAtt#" filter="(#APPLICATION.ldapUsersLoginAtt#=#user_login#)">

					<cfset login_ldap_column = "login_ldap">

					<cfset loginValid = true>

					<cfcatch>
						<cfset loginValid = false>
					</cfcatch>
				</cftry>

			<cfelseif arguments.ldap_id EQ "dmsas"><!--- Dominio Corporativo del SAS --->

				<!--- <cfldap server="10.201.79.21" username="DMSAS\lucenaalexis21K" password="" action="query" scope="subtree" name="getUser" attributes="cn" start="DC=DMSAS" filter="(1=1)"> --->

				<cftry>

					<cfldap	server="10.201.79.21" username="DMSAS\#user_login#" password="#password_ldap#" action="query" scope="subtree" name="getUser" attributes="cn" start="DC=DMSAS" filter="(1=1)">

					<cfset login_ldap_column = "login_ldap">

					<cfset loginValid = true>

					<cfcatch>
						<cfset loginValid = false>
					</cfcatch>
				</cftry>

			<cfelseif arguments.ldap_id EQ "dmsas_hvn">

				<cftry>

					<cfldap	server="#APPLICATION.ldapServer#" port="#APPLICATION.ldapServerPort#" username="DMSAS\#user_login#" password="#password_ldap#" action="query" scope="#APPLICATION.ldapScope#" name="getUser" start="DC=DMSAS" attributes="#APPLICATION.ldapUsersLoginAtt#" filter="(1=1)">

					<cfset login_ldap_column = "login_ldap">

					<cfset loginValid = true>

					<cfcatch>
						<cfset loginValid = false>
					</cfcatch>
				</cftry>

			<cfelseif arguments.ldap_id EQ "hvn">

				<cfhttp method="post" url="http://www.hvn.es/servicios/login.php" resolveurl="no" result="wsResponse" charset="utf-8">
					<cfhttpparam type="formfield" name="login" value="#user_login#">
					<cfhttpparam type="formfield" name="pass" value="#password_ldap#">
				</cfhttp>

				<cfset responseContent = xmlParse(wsResponse.filecontent)>

				<cfif isDefined("responseContent.usuario[1]")>

					<cfset usuarioXml = responseContent.usuario[1]>

					<cfif isDefined("usuarioXml.id") AND usuarioXml.id.xmlText NEQ "-1">

						<cfset login_ldap_column = "login_ldap">

						<cfset loginValid = true>

						<cfif isDefined("usuarioXml.email")>
							<cfset email_hvn = usuarioXml.email.xmlText>
						</cfif>
						<cfif isDefined("usuarioXml.nombre.xmlText")>
							<cfset name_ldap = usuarioXml.nombre.xmlText>
						</cfif>
						<cfif isDefined("usuarioXml.apellido1.xmlText")>
							<cfset family_name_ldap = usuarioXml.apellido1.xmlText>
						</cfif>
						<cfif isDefined("usuarioXml.apellido2.xmlText")>
							<cfset family_name_ldap = family_name_ldap&" "&usuarioXml.apellido2.xmlText>
						</cfif>

						<!---<cfset response = {result="true", message="", usuario_id=usuarioXml.id.xmlText, nombre=usuarioXml.nombre.xmlText, apellido1=usuarioXml.apellido1.xmlText, apellido2=usuarioXml.apellido2.xmlText}>--->

					</cfif>

				<cfelse>

					<cfthrow message="Ha ocurrido un error al realizar el login: respuesta de servicio de login incorrecta. #wsResponse.filecontent#">

				</cfif>

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

			<cfelseif arguments.ldap_id EQ "portalep_hcs">

				<cfhttp url="https://portalep.hcs.es/rrhh/HCS/valida-usr.asp" method="get" result="loginResponse">
					<cfhttpparam name="usr" type="URL" value="#user_login#">
					<cfhttpparam name="pwd" type="URL" value="#password_ldap#">
				</cfhttp>

				<cfif isDefined("loginResponse.status_code") AND loginResponse.status_code EQ 200>

					<cfset responseContent = loginResponse.filecontent>

					<cfif responseContent EQ "TRUE">

						<cfset login_ldap_column = "login_ldap">

						<cfset loginValid = true>

					</cfif>

				<cfelse>

					<cfthrow message="Error al acceder al servicio de login">

				</cfif>


			</cfif>

			<cfif loginValid IS true><!---AND getUser.recordCount GT 0--->

				<cfset table = arguments.client_abb&"_users">

				<!---  Checking if user is correct   --->
				<cfquery name="loginQuery" datasource="#client_dsn#">
					SELECT users.id, users.number_of_connections, users.language, users.enabled
					FROM #table# AS users
					WHERE users.#login_ldap_column# = <cfqueryparam value="#user_login#" cfsqltype="cf_sql_varchar">
					<cfif arguments.ldap_id EQ "hvn" AND isDefined("email_hvn") AND len(email_hvn) GT 0>
						OR users.email = <cfqueryparam value="#email_hvn#" cfsqltype="cf_sql_varchar">
					</cfif>;
				</cfquery>

				<!--- If at least one record is found, it means that the login is valid --->
				<cfif loginQuery.RecordCount GT 0>

					<cfif loginQuery.enabled IS true>

						<cfinvoke component="LoginManager" method="loginUserInApplication" returnvariable="loginResult">
							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="objectClient" value="#objectClient#">
							<cfinvokeargument name="user_id" value="#loginQuery.id#">
							<cfinvokeargument name="user_login" value="#arguments.login#">
							<cfinvokeargument name="password" value="#password_ldap#">
							<cfinvokeargument name="user_language" value="#loginQuery.language#">
						</cfinvoke>

						<!---<cfsavecontent variable="xmlResponse">
							<cfoutput><login valid="#loginResult.result#"></login></cfoutput>
						</cfsavecontent>--->

						<cfset response = {result=loginResult.result}>

						<!--- Aquí no se guarda log porque ya se ha guardado en el método anterior
						En este método solo se guarda log cuando el login (usuario o password) no es correcto --->

					<cfelse>

						<cfset loginMessage = "Cuenta de usuario deshabilitada.">

						<!---<cfsavecontent variable="xmlResponse">
							<cfoutput><login valid="false"><message><![CDATA[#login_message#]]></message></login></cfoutput>
						</cfsavecontent>--->
						<cfset response = {result=false, message=#loginMessage#}>

					</cfif>

				<cfelse>


					<cfif arguments.ldap_id EQ "hvn" AND isDefined("email_hvn") AND len(email_hvn) GT 0>

						<!--- createuserFromLdap --->

						<cfinvoke component="LoginLDAPManager" method="createuserFromLdap" returnvariable="createUserFromLdapResponse">
							<cfinvokeargument name="ldap_id" value="#arguments.ldap_id#">
							<cfinvokeargument name="email" value="#email_hvn#">
							<cfinvokeargument name="name" value="#family_name_ldap#">
							<cfinvokeargument name="family_name" value="#name_ldap#">

							<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

						<cfif createUserFromLdapResponse.result IS true>

							<cfinvoke component="LoginManager" method="loginUserInApplication" returnvariable="loginResult">
								<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
								<cfinvokeargument name="objectClient" value="#objectClient#">
								<cfinvokeargument name="user_id" value="#createUserFromLdapResponse.user_id#">
								<cfinvokeargument name="user_login" value="#arguments.user_login#">
								<cfinvokeargument name="password" value="#password_ldap#">
								<cfinvokeargument name="user_language" value="#createUserFromLdapResponse.language#">
							</cfinvoke>

						</cfif>

						<cfreturn loginResult>

					<cfelse>

						<cfset loginMessage = "Usuario no disponible en esta aplicación.">

					</cfif>


					<cfset response = {result=false, message=#loginMessage#}>

					<cfinclude template="includes/logRecordNoSession.cfm">

				</cfif>

			<cfelse>

				<cfset loginMessage = "Usuario o contraseña incorrecta.">

				<cfset response = {result=false, message=#loginMessage#}>

				<cfinclude template="includes/logRecordNoSession.cfm">

			</cfif>

		<cfreturn response>

	</cffunction>


	<!--- createuserFromLdap --->

	<cffunction name="createuserFromLdap" returntype="struct" output="false" access="package">
		<cfargument name="ldap_id" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="name" type="string" required="false" default="">
		<cfargument name="family_name" type="string" required="false" default="">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "createuserFromLdap">

		<cfset var response = structNew()>

			<!--- generatePassword --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="generatePassword" returnvariable="password">
				<cfinvokeargument name="numberOfCharacters" value="8">
			</cfinvoke>

			<!--- createUser --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="createUser" returnvariable="response">
				<cfinvokeargument name="email" value="#Trim(arguments.email)#">
				<cfinvokeargument name="name" value="#Trim(arguments.name)#">
				<cfinvokeargument name="family_name" value="#Trim(arguments.family_name)#">
				<cfinvokeargument name="internal_user" value="0">
				<cfinvokeargument name="enabled" value="1">
				<cfinvokeargument name="verified" value="1">
				<cfinvokeargument name="language" value="#APPLICATION.defaultLanguage#">
				<cfinvokeargument name="hide_not_allowed_areas" value="true">
				<cfinvokeargument name="user_administrator" value="false">
				<cfinvokeargument name="password" value="#password#">
				<cfinvokeargument name="password_confirmation" value="#password#">
				<cfinvokeargument name="notify_admin" value="false">
				<cfinvokeargument name="include_admin_fields" value="false">
				<cfinvokeargument name="notify_user" value="true">
				<cfinvokeargument name="notify_admin" value="true">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfif response.result NEQ true>
				<cfthrow message="#response.message#">
			</cfif>

			<cfset response.message = "Usuario dado de alta en la aplicación. Está pendiente la asignación de permisos por parte del administrador.">

		<cfreturn response>

	</cffunction>




</cfcomponent>

<!---Copyright Era7 Information Technologies 2007-2011

	Date of file creation: 10-03-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 22-11-2011

	19-06-2013 alucena: se guarda password en createUser si está definido
	
--->
<cfcomponent output="false">

	<cfset component = "UserLDAPManager">
	

	<!--- --------------------------GET LDAP USER ------------------------------ --->
	
	<cffunction name="getLDAPUser" returntype="any" output="true" access="public">
		<cfargument name="login_ldap" type="string" required="yes">
		<!---<cfargument name="format_content" type="string" required="no" default="default">--->
		<cfargument name="return_type" type="string" required="no" default="xml">
		
		<cfset var method = "getLDAPUser">
		
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">

		<cfset var objectUser = structNew()>
		
		
			<cfinclude template="includes/functionStart.cfm"> 
			
			<cfinclude template="includes/checkAdminAccess.cfm">
			
			<cfldap	server="#APPLICATION.ldapServer#" port="#APPLICATION.ldapServerPort#" username="#APPLICATION.ldapServerUserName#" password="#APPLICATION.ldapServerPassword#" action="query" name="getUserQuery" start="#APPLICATION.ldapUsersPath#" scope="#APPLICATION.ldapScope#" attributes="mail,telephonenumber,mobiletelephonenumber,givenName,sn,street" filter="(#APPLICATION.ldapUsersLoginAtt#=#arguments.login_ldap#)" maxrows="1">
			
			<cfif getUserQuery.recordCount GT 0>
				
				<cfinvoke component="UserManager" method="objectUser" returnvariable="objectUser">
						<cfinvokeargument name="login_ldap" value="#arguments.login_ldap#">
						<cfif isDefined("getUserQuery.mail")>
							<cfinvokeargument name="email" value="#getUserQuery.mail#">
						</cfif>
						<cfif isDefined("getUserQuery.telephoneNumber")>
							<cfinvokeargument name="telephone" value="#getUserQuery.telephoneNumber#">
							<cfinvokeargument name="telephone_ccode" value="34">
						</cfif>
						<cfif isDefined("getUserQuery.mobileTelephoneNumber")>
							<cfinvokeargument name="mobile_phone" value="#getUserQuery.mobileTelephoneNumber#">
							<cfinvokeargument name="mobile_phone_ccode" value="34">
						</cfif>
						<cfif isDefined("getUserQuery.givenName")>
							<cfinvokeargument name="family_name" value="#getUserQuery.givenName#">
						</cfif>
						<cfif isDefined("getUserQuery.sn")>
							<cfinvokeargument name="name" value="#getUserQuery.sn#">
						</cfif>
						<!---<cfif isDefined("getUserQuery.street")>
							<cfinvokeargument name="address" value="#getUserQuery.street#">
						</cfif>--->

						<cfinvokeargument name="return_type" value="#arguments.return_type#">
				</cfinvoke>	
								
			<cfelse><!---the user does not exist in LDAP--->
				
				<cfset error_code = 210>
				
				<cfthrow errorcode="#error_code#"> 
				
			</cfif>
			
		
		<cfreturn objectUser>
				
	</cffunction>
	
	
	<!--- --------------------------SELECT LDAP USER ------------------------------ --->
	
	<!---request:
	<request>
		<parameters>
			<user>
				<login_ldap><![CDATA[]]></login_ldap>
			</user>
		</parameters>
	</request>--->

	<!---response:
	<response status="ok/error" component="UserLDAPManager" method="selectLDAPUser">
		<result>
			<user email=""/>
		</result>
	</response>--->
	
	<cffunction name="selectLDAPUser" returntype="string" output="false" access="public">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "selectLDAPUser">
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">
			
		<cfset var xmlRequest = "">
		<cfset var xmlResponseContent = "">

		<cftry>
		
			<cfinclude template="includes/functionStart.cfm"> 
		
			<cfset select_user_login_ldap = xmlRequest.request.parameters.user.login_ldap.xmlText>
			
			<cfinvoke component="UserLDAPManager" method="getLDAPUser" returnvariable="xmlResponseContent">
				<cfinvokeargument name="login_ldap" value="#select_user_login_ldap#">
				<cfinvokeargument name="return_type" value="xml">
			</cfinvoke>	
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>	
		
		<cfreturn xmlResponse>
				
	</cffunction>
	
	
	
	<!---  -----------------------CREATE USER------------------------------------- --->

	
	<cffunction name="createUser" returntype="string" output="false" access="public">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "createUser">
		
		<cfset var user_id = "">
<cfset var client_abb = "">
<cfset var user_language = "">
	
<cfset var xmlRequest = "">
<cfset var xmlResponseContent = "">
	
		<!---<cftry>--->
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinclude template="includes/checkAdminAccess.cfm">
			
			
			<cfinvoke component="UserManager" method="objectUser" returnvariable="objectUser">
					<cfinvokeargument name="xml" value="#xmlRequest.request.parameters.user#">
					
					<cfinvokeargument name="return_type" value="object">
			</cfinvoke>	
			
			<cfif len(objectUser.whole_tree_visible) IS 0>
				<cfset objectUser.whole_tree_visible = "false">
			</cfif> 
			
			<cfif len(objectUser.sms_allowed) IS 0>
				<cfset objectUser.sms_allowed = "false">
			</cfif>
			
			<cfset objectUser.email = Trim(objectUser.email)>
			<cfset objectUser.login_ldap = Trim(objectUser.login_ldap)>
			<cfset objectUser.login_diraya = Trim(objectUser.login_diraya)>
			<cfset objectUser.mobile_phone = Trim(objectUser.mobile_phone)>
						
			<cfquery name="beginQuery" datasource="#client_dsn#">
				BEGIN;
			</cfquery>
			
			<cftry>
				
				<!---checkEmail--->
				<cfquery name="checkEmail" datasource="#client_dsn#">
					SELECT *
					FROM #client_abb#_users
					WHERE email=<cfqueryparam value="#objectUser.email#" cfsqltype="cf_sql_varchar">;
				</cfquery>
				
				<cfif checkEmail.recordCount GT 0><!---User email already used--->
					<cfset error_code = 205>
				
					<cfthrow errorcode="#error_code#">
				</cfif>
				
				<!---if login_ldap is defined--->
				<cfif len(objectUser.login_ldap) GT 0>
					<!---Check if login already used--->
					<cfquery name="checkLoginLdap" datasource="#client_dsn#">
						SELECT *
						FROM #client_abb#_users
						WHERE login_ldap=<cfqueryparam value="#objectUser.login_ldap#" cfsqltype="cf_sql_varchar">;
					</cfquery>
					
					<cfif checkLoginLdap.recordCount GT 0><!---User LDAP login already assigned to another user--->
						<cfset error_code = 211>
					
						<cfthrow errorcode="#error_code#">
					</cfif>					
					
					<!---Check if exist in LDAP (ONLY VPNET)--->
					<cfif APPLICATION.identifier EQ "vpnet">

						<cfinvoke component="UserLDAPManager" method="getLDAPUser" returnvariable="xmlResponseUser">
							<cfinvokeargument name="login_ldap" value="#objectUser.login_ldap#">
							<cfinvokeargument name="return_type" value="xml">
						</cfinvoke>

					</cfif>
					
				</cfif>
				
				<cfif len(objectUser.login_diraya) GT 0>
				
					<!---Check if login already used--->
					<cfquery name="checkLoginDiraya" datasource="#client_dsn#">
						SELECT *
						FROM #client_abb#_users
						WHERE login_diraya=<cfqueryparam value="#objectUser.login_diraya#" cfsqltype="cf_sql_varchar">;
					</cfquery>
					
					<cfif checkLoginDiraya.recordCount GT 0><!---User LDAP login already assigned to another user--->
						<cfset error_code = 211>
					
						<cfthrow errorcode="#error_code#">
					</cfif>					
				
				</cfif>
				<!--- 
				<cfif len(objectUser.login_diraya) GT 0><!---Check if exist in LDAP--->
					<cftry>
					
						No se puede chequear porque no disponemos de un usuario que tenga permisos para hacer consultas sobre el LDAP
						
						<cfcatch>
							<cfset error_code = 210>
				
							<cfthrow errorcode="#error_code#"> 
						</cfcatch>
					</cftry>
				</cfif> --->
				
				
				<cfinvoke component="DateManager" method="getCurrentDateTime" returnvariable="current_date">
				</cfinvoke>
				
				<cfset objectUser.language = APPLICATION.defaultLanguage>
				
				<!---Insert User in DataBase--->			
				<cfquery name="insertUserQuery" datasource="#client_dsn#" result="insertUserResult">
					INSERT INTO #client_abb#_users
					(email,name,family_name,telephone,address, internal_user, sms_allowed, mobile_phone, creation_date, telephone_ccode, mobile_phone_ccode, language, login_ldap, login_diraya, dni
						<cfif APPLICATION.identifier EQ "vpnet">
							, center_id, category_id, service_id, service, other_1, other_2 
						</cfif>
						<cfif len(objectUser.password) GT 0>
							, password
						</cfif>
						)
					VALUES(
						<cfqueryparam value="#objectUser.email#" cfsqltype="cf_sql_varchar">,
						<cfqueryPARAM value="#objectUser.name#" CFSQLType = "CF_SQL_varchar">,
						<cfqueryPARAM value="#objectUser.family_name#" CFSQLType = "CF_SQL_varchar">,
						<cfqueryPARAM value="#objectUser.telephone#" CFSQLType = "CF_SQL_varchar">,
						<cfqueryPARAM value="#objectUser.address#" CFSQLType = "CF_SQL_varchar">,
						<cfqueryPARAM value="#objectUser.whole_tree_visible#" CFSQLType = "CF_SQL_bit">,
						<cfqueryPARAM value="#objectUser.sms_allowed#" CFSQLType = "CF_SQL_bit">,
						<cfqueryPARAM value="#objectUser.mobile_phone#" CFSQLType = "CF_SQL_varchar">,
						<cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">,
						<cfif len(objectUser.telephone_ccode) GT 0>
							<cfqueryPARAM value="#objectUser.telephone_ccode#" cfsqltype="cf_sql_integer">,
						<cfelse>
							<cfqueryparam null="true" cfsqltype="cf_sql_numeric">,
						</cfif>
						<cfif len(objectUser.mobile_phone_ccode) GT 0>
							<cfqueryPARAM value="#objectUser.mobile_phone_ccode#" cfsqltype="cf_sql_integer">,
						<cfelse>
							<cfqueryparam null="true" cfsqltype="cf_sql_numeric">,
						</cfif>
						<cfqueryparam value="#objectUser.language#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#objectUser.login_ldap#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#objectUser.login_diraya#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#objectUser.dni#" cfsqltype="cf_sql_varchar">
						<cfif APPLICATION.identifier EQ "vpnet">
							, <cfqueryparam value="#objectUser.center_id#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#objectUser.category_id#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#objectUser.service_id#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#objectUser.service#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#objectUser.other_1#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#objectUser.other_2#" cfsqltype="cf_sql_varchar">
						</cfif>
						<cfif len(objectUser.password) GT 0>
						, <cfqueryparam value="#objectUser.password#" cfsqltype="cf_sql_varchar">
						</cfif>						
						);
				</cfquery>
				
				<!---Aquí se obtiene el id del usuario insertado en base de datos--->
				<cfquery name="getLastInsertId" datasource="#client_dsn#">
					SELECT LAST_INSERT_ID() AS last_insert_id FROM #client_abb#_users;
				</cfquery>
				<cfset objectUser.id = getLastInsertId.last_insert_id>
				
				<!---Insert User Root Folder--->
				<cfquery name="insertRootFolderQuery" datasource="#client_dsn#" result="insertRootFolderResult">
					INSERT INTO #client_abb#_folders
					(name, creation_date, user_in_charge, description)
					VALUES(
						'Mis documentos', 
						<cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">,
						<cfqueryPARAM value="#objectUser.id#" CFSQLType="cf_sql_integer">,
						'Directorio raiz'
						);
				</cfquery>	
				
				<!---<cfset root_folder_id = insertRootFolderResult.GENERATED_KEY>--->
				<cfquery name="getLastInsertId" datasource="#client_dsn#">
					SELECT LAST_INSERT_ID() AS last_insert_id FROM #client_abb#_folders;
				</cfquery>
				<cfset root_folder_id = getLastInsertId.last_insert_id>
				
				<cfquery name="insertRootFolderInUser" datasource="#client_dsn#">
					UPDATE #client_abb#_users
					SET root_folder_id = #root_folder_id#
					WHERE id = <cfqueryPARAM value="#objectUser.id#" CFSQLType="cf_sql_integer">;
				</cfquery>
			
				<cfquery name="commitQuery" datasource="#client_dsn#">
					COMMIT;
				</cfquery>
				
				<cfcatch>
					<cfquery name="rollBackQuery" datasource="#client_dsn#">
						ROLLBACK;
					</cfquery>
					
					<!---<cfset xmlResponseContent = arguments.request>
					<cfinclude template="includes/errorHandler.cfm">
					<cfreturn xmlResponse>--->
					
					<cfthrow object="#cfcatch#">
					
				</cfcatch>										
				
			</cftry>	
			
			<!---<cfset password_temp = xmlRequest.request.parameters.user.password_temp.xmlText>--->

			<cfinvoke component="AlertManager" method="newUser">
				<cfinvokeargument name="objectUser" value="#objectUser#">
				<cfif len(objectUser.password) GT 0 AND len(objectUser.password_temp) GT 0>
					<cfinvokeargument name="password_temp" value="#objectUser.password_temp#"/>
				</cfif>
			</cfinvoke>
			
			<cfinvoke component="UserManager" method="xmlUser" returnvariable="xmlResponseContent">
					<cfinvokeargument name="objectUser" value="#objectUser#">
			</cfinvoke>	
				
			
			
			<!---<cfinclude template="includes/functionEnd.cfm">--->
			<cfset xmlResponse = xmlResponseContent>
		
			<!---<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>--->
		
		<cfreturn xmlResponse>
			
	</cffunction>
	
	
	
</cfcomponent>
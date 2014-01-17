<!---Copyright Era7 Information Technologies 2007-2013

    File created by: ppareja
    ColdFusion version required: 8
    Last file change by: alucena
	
	22-05-2012 alucena: quitado BEGIN y COMMIT de updateUserDownloadedSpace y cambiada la posición de BEGIN del método createUser
	05-07-2012 alucena: modificados métodos para permitir preferencias de notificaciones de los nuevos elementos (entradas, enlaces, noticias y eventos).
	20-12-2012 alucena: añadido image_file e image_type
	06-03-2013 alucena: añadido area_member
	20-03-2013 alucena: añadido DNI en la versión DP (antes solo estaba en vpnet)
	15-04-2013 alucena: se borran todos los elementos de un usuario al eliminarlo
	07-05-2013 alucena: modificado getUsersToNotifyLists
	19-06-2013 alucena: añadido password_temp a xmlUser y objectUser
	18-09-2013 alucena: añadida comprobación de language para ver si es un valor válido
	
--->
<cfcomponent output="false">
	
	<cfset component = "UserManager">
	
	<cfinclude template="includes/functions.cfm">
	
	<!--- ----------------------- XML USER -------------------------------- --->
	
	<cffunction name="xmlUser" returntype="string" output="false" access="public">		
		<cfargument name="objectUser" type="struct" required="yes">
		
		<cfset var method = "xmlUser">
		
		<cftry>
		
			<cfprocessingdirective suppresswhitespace="true">
			<cfsavecontent variable="xmlResult"><cfoutput><user
				<cfif len(objectUser.id) NEQ 0>
					id="#objectUser.id#"
				</cfif>
				<cfif len(objectUser.email) NEQ 0>
					email="#xmlFormat(objectUser.email)#"
				</cfif>
				<cfif len(objectUser.language) NEQ 0>
					language="#objectUser.language#"
				</cfif>
				<cfif len(objectUser.client_abb) NEQ 0>
					client_abb="#objectUser.client_abb#"
				</cfif>
				<cfif len(objectUser.password) NEQ 0>
					password="#objectUser.password#"
				</cfif>
				<cfif len(objectUser.telephone) NEQ 0>			
					telephone="#objectUser.telephone#"
				</cfif>	
				<cfif len(objectUser.space_used_full) NEQ 0>
					space_used_full="#objectUser.space_used_full#"
				</cfif>	
				<cfif len(objectUser.space_used) NEQ 0>
					space_used="#objectUser.space_used#"
				</cfif>
				<cfif len(objectUser.number_of_connections) NEQ 0>
					number_of_connections="#objectUser.number_of_connections#"
				</cfif>
				<cfif len(objectUser.last_connection) NEQ 0>
					last_connection="#objectUser.last_connection#"
				</cfif>
				<cfif len(objectUser.connected) NEQ 0>
					connected="#objectUser.connected#"
				</cfif>
				<cfif len(objectUser.session_id) NEQ 0>
					session_id="#objectUser.session_id#"
				</cfif>
				<cfif len(objectUser.creation_date) NEQ 0>
					creation_date="#objectUser.creation_date#"
				</cfif>
				<cfif len(objectUser.whole_tree_visible) NEQ 0>
					whole_tree_visible="#objectUser.whole_tree_visible#"
				</cfif>
				<cfif len(objectUser.internal_user) NEQ 0>
					internal_user="#objectUser.internal_user#"
				</cfif>
				<cfif len(objectUser.root_folder_id) NEQ 0>
					root_folder_id="#objectUser.root_folder_id#"
				</cfif>
				<cfif len(objectUser.general_administrator) NEQ 0>
					general_administrator="#objectUser.general_administrator#"
				</cfif>
				<cfif len(objectUser.sms_allowed) NEQ 0>
					sms_allowed="#objectUser.sms_allowed#"
				</cfif>
				<cfif len(objectUser.mobile_phone) NEQ 0>
					mobile_phone="#objectUser.mobile_phone#"
				</cfif>
				<cfif len(objectUser.telephone_ccode) NEQ 0>
					telephone_ccode="#objectUser.telephone_ccode#"
				</cfif>
				<cfif len(objectUser.mobile_phone_ccode) NEQ 0>
					mobile_phone_ccode="#objectUser.mobile_phone_ccode#"
				</cfif>
				<cfif len(objectUser.area_id) GT 0>
					area_id="#objectUser.area_id#"
				</cfif>
				<cfif len(objectUser.user_in_charge) GT 0>
					user_in_charge="#objectUser.user_in_charge#"
				</cfif>	
				<cfif len(objectUser.image_file) GT 0>
					image_file="#objectUser.image_file#"
				</cfif>	
				<cfif len(objectUser.image_type) GT 0>
					image_type="#objectUser.image_type#"
				</cfif>
				<cfif len(objectUser.area_member) GT 0>
					area_member="#objectUser.area_member#"
				</cfif>		
				>
				<cfif len(objectUser.family_name) NEQ 0>
					<family_name><![CDATA[#objectUser.family_name#]]></family_name>
				</cfif>
				<cfif len(objectUser.name) NEQ 0>
					<name><![CDATA[#objectUser.name#]]></name>
				</cfif>
				<cfif len(objectUser.user_full_name) NEQ 0>
					<user_full_name><![CDATA[#objectUser.user_full_name#]]></user_full_name>
				</cfif>
				<cfif len(objectUser.address) NEQ 0>	
					<address><![CDATA[#objectUser.address#]]></address>
				</cfif>
				<cfif len(objectUser.perfil_cabecera) NEQ 0>
					<perfil_cabecera><![CDATA[#objectUser.perfil_cabecera#]]></perfil_cabecera>
				</cfif>
				<cfif len(objectUser.login_ldap) NEQ 0><!--- Provisional fuera del if --->
					<login_ldap><![CDATA[#objectUser.login_ldap#]]></login_ldap>
				</cfif>
				<cfif APPLICATION.moduleLdapUsers EQ true>
					<cfif len(objectUser.login_diraya) NEQ 0>
						<login_diraya><![CDATA[#objectUser.login_diraya#]]></login_diraya>
					</cfif>
				</cfif>
				<cfif APPLICATION.identifier EQ "vpnet">
					<cfif len(objectUser.center_id) GT 0>
						<center id="#objectUser.center_id#"/>
					</cfif>
					<cfif len(objectUser.category_id) GT 0>
						<category id="#objectUser.category_id#"/>
					</cfif>
					<cfif len(objectUser.service) GT 0 OR len(objectUser.service_id) GT 0>
						<service <cfif len(objectUser.service_id) GT 0>id="#objectUser.service_id#"</cfif>><cfif len(objectUser.service) GT 0><![CDATA[#objectUser.service#]]></cfif></service>
					</cfif>
					<cfif len(objectUser.other_1) GT 0>
						<other_1><![CDATA[#objectUser.other_1#]]></other_1>
					</cfif>
					<cfif len(objectUser.other_2) GT 0>
						<other_2><![CDATA[#objectUser.other_2#]]></other_2>
					</cfif>	
				</cfif>
				<cfif len(objectUser.dni) GT 0>
					<dni><![CDATA[#objectUser.dni#]]></dni>
				</cfif>
				<cfif len(objectUser.password_temp) NEQ 0>	
					<password_temp><![CDATA[#objectUser.password_temp#]]></password_temp>
				</cfif>	
				<cfif len(objectUser.areas_administration) NEQ 0>	
					#objectUser.areas_administration#
				</cfif>
					</user></cfoutput></cfsavecontent>
			</cfprocessingdirective>
			
			<cfreturn xmlResult>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
				<cfreturn null>
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	<!--- ----------------------- USER OBJECT -------------------------------- --->
	
	<cffunction name="objectUser" returntype="any" output="false" access="public">	
		
		<cfargument name="xml" type="string" required="no">
		
		<cfargument name="id" type="string" required="no" default="">
		<cfargument name="email" type="string" required="no" default="">
		<cfargument name="language" type="string" required="no" default="">		
		<cfargument name="client_abb" type="string" required="no" default="">		
		<cfargument name="password" type="string" required="no" default="">
		<cfargument name="password_temp" type="string" required="false" default=""/>
		<cfargument name="telephone" type="string" required="no" default="">
		<cfargument name="space_used" type="string" required="no" default="">
		<cfargument name="number_of_connections" type="string" required="no" default="">
		<cfargument name="last_connection" type="string" required="no" default="">
		<cfargument name="connected" type="string" required="no" default="">
		<cfargument name="session_id" type="string" required="no" default="">
		<cfargument name="creation_date" type="string" required="no" default="">
		<cfargument name="whole_tree_visible" type="string" required="no" default="">
		<cfargument name="internal_user" type="string" required="no" default="">
		<cfargument name="root_folder_id" type="string" required="no" default="">
		<cfargument name="general_administrator" type="string" required="no" default="">
		<cfargument name="sms_allowed" type="string" required="no" default="">
		<cfargument name="family_name" type="string" required="no" default="">
		<cfargument name="name" type="string" required="no" default="">
		<cfargument name="user_full_name" type="string" required="no" default="">
		<cfargument name="address" type="string" required="no" default="">
		<cfargument name="areas_administration" type="string" required="no" default="">
		<cfargument name="mobile_phone" type="string" required="no" default="">
		<cfargument name="telephone_ccode" type="string" required="no" default="">
		<cfargument name="mobile_phone_ccode" type="string" required="no" default="">
		<cfargument name="login_ldap" type="string" required="no" default="">
		<cfargument name="login_diraya" type="string" required="no" default="">
		<cfargument name="area_id" type="string" required="no" default="">
		<cfargument name="user_in_charge" type="string" required="no" default="">
		<cfargument name="image_file" type="string" required="no" default="">
		<cfargument name="image_type" type="string" required="no" default="">
		<cfargument name="area_member" type="string" required="no" default="">
		
		<cfargument name="center_id" type="string" required="no" default="">
		<cfargument name="category_id" type="string" required="no" default="">
		<cfargument name="service_id" type="string" required="no" default="">
		<cfargument name="service" type="string" required="no" default="">
		<cfargument name="other_1" type="string" required="no" default="">
		<cfargument name="other_2" type="string" required="no" default="">
		<cfargument name="dni" type="string" required="no" default="">

		<cfargument name="perfil_cabecera" type="string" required="no" default="">
		
		<cfargument name="return_type" type="string" required="no">
		
		<cfset var method = "objectUser">
		
		<cfset var object = StructNew()>
		
		
		<cftry>
			
			<cfif isDefined("arguments.xml")>
			
				<cfxml variable="xmlUser">
				<cfoutput>
				#arguments.xml#
				</cfoutput>
				</cfxml>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.id")>
					<cfset id=xmlUser.user.XmlAttributes.id>
				</cfif>	
				
				<cfif isDefined("xmlUser.user.XmlAttributes.email")>
					<cfset email=xmlUser.user.XmlAttributes.email>
				</cfif>	
					
				<cfif isDefined("xmlUser.user.XmlAttributes.language")>
					<cfset language=#xmlUser.user.XmlAttributes.language#>
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.client_abb")>
					<cfset client_abb="#xmlUser.user.XmlAttributes.client_abb#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.password")>
					<cfset password="#xmlUser.user.XmlAttributes.password#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.telephone")>
					<cfset telephone="#xmlUser.user.XmlAttributes.telephone#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.space_used_full")>
					<cfset space_used_full="#xmlUser.user.XmlAttributes.space_used_full#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.space_used")>
					<cfset space_used="#xmlUser.user.XmlAttributes.space_used#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.number_of_connections")>
					<cfset number_of_connections="#xmlUser.user.XmlAttributes.number_of_connections#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.last_connection")>
					<cfset last_connection="#xmlUser.user.XmlAttributes.last_connection#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.connected")>
					<cfset connected="#xmlUser.user.XmlAttributes.connected#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.session_id")>
					<cfset session_id="#xmlUser.user.XmlAttributes.session_id#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.creation_date")>
					<cfset creation_date="#xmlUser.user.XmlAttributes.creation_date#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.whole_tree_visible")>
					<cfset whole_tree_visible="#xmlUser.user.XmlAttributes.whole_tree_visible#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.internal_user")>
					<cfset internal_user="#xmlUser.user.XmlAttributes.internal_user#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.root_folder_id")>
					<cfset root_folder_id="#xmlUser.user.XmlAttributes.root_folder_id#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.general_administrator")>
					<cfset general_administrator="#xmlUser.user.XmlAttributes.general_administrator#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.sms_allowed")>
					<cfset sms_allowed="#xmlUser.user.XmlAttributes.sms_allowed#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.family_name.xmlText")>
					<cfset family_name="#xmlUser.user.family_name.xmlText#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.name.xmlText")>
					<cfset name="#xmlUser.user.name.xmlText#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.user_full_name")>
					<cfset user_full_name=xmlUser.user.user_full_name.xmlText>
				</cfif>
				
				<cfif isDefined("xmlUser.user.address.xmlText")>
					<cfset address="#xmlUser.user.address.xmlText#">
				</cfif>

				<cfif isDefined("xmlUser.user.areas_administration")>
					<cfset areas_administration="#xmlUser.user.areas_administration#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.mobile_phone")>
					<cfset mobile_phone="#xmlUser.user.XmlAttributes.mobile_phone#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.telephone_ccode")>
					<cfset telephone_ccode="#xmlUser.user.XmlAttributes.telephone_ccode#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.mobile_phone_ccode")>
					<cfset mobile_phone_ccode="#xmlUser.user.XmlAttributes.mobile_phone_ccode#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.area_id")>
					<cfset area_id=xmlUser.user.XmlAttributes.area_id>
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.user_in_charge")>
					<cfset user_in_charge=xmlUser.user.XmlAttributes.user_in_charge>
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.image_file")>
					<cfset image_file=xmlUser.user.XmlAttributes.image_file>
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.image_type")>
					<cfset image_type=xmlUser.user.XmlAttributes.image_type>
				</cfif>
				
				<cfif isDefined("xmlUser.user.XmlAttributes.area_member")>
					<cfset area_member=xmlUser.user.XmlAttributes.area_member>
				</cfif>
				
				<cfif isDefined("xmlUser.user.dni.xmlText")>
					<cfset dni="#xmlUser.user.dni.xmlText#">
				</cfif>
				
				<cfif isDefined("xmlUser.user.password_temp.xmlText")>
					<cfset password_temp="#xmlUser.user.password_temp.xmlText#">
				</cfif>

				<cfif isDefined("xmlUser.user.perfil_cabecera.xmlText")>
					<cfset perfil_cabecera="#xmlUser.user.perfil_cabecera.xmlText#">
				</cfif>

				<cfif isDefined("xmlUser.user.login_ldap.xmlText")>
					<cfset login_ldap="#xmlUser.user.login_ldap.xmlText#">
				</cfif>

				<cfif APPLICATION.moduleLdapUsers EQ true>					
					<cfif isDefined("xmlUser.user.login_diraya.xmlText")>
						<cfset login_diraya="#xmlUser.user.login_diraya.xmlText#">
					</cfif>
				</cfif>
				
				<cfif APPLICATION.identifier EQ "vpnet">
					<!---<cfif isDefined("xmlUser.user.center.xmlText")>
						<cfset center="#xmlUser.user.center.xmlText#">
					</cfif>
					
					<cfif isDefined("xmlUser.user.category.xmlText")>
						<cfset category="#xmlUser.user.category.xmlText#">
					</cfif>--->
					
					<cfif isDefined("xmlUser.user.center.xmlAttributes.id")>
						<cfset center_id="#xmlUser.user.center.xmlAttributes.id#">
					</cfif>
					
					<cfif isDefined("xmlUser.user.category.xmlAttributes.id")>
						<cfset category_id="#xmlUser.user.category.xmlAttributes.id#">
					</cfif>
					
					<cfif isDefined("xmlUser.user.service.xmlAttributes.id")>
						<cfset service_id="#xmlUser.user.service.xmlAttributes.id#">
					</cfif>
					
					<cfif isDefined("xmlUser.user.service.xmlText")>
						<cfset service="#xmlUser.user.service.xmlText#">
					</cfif>
					
					<cfif isDefined("xmlUser.user.other_1.xmlText")>
						<cfset other_1="#xmlUser.user.other_1.xmlText#">
					</cfif>
					
					<cfif isDefined("xmlUser.user.other_2.xmlText")>
						<cfset other_2="#xmlUser.user.other_2.xmlText#">
					</cfif>

				</cfif>
				
			</cfif>
		
			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringDateCreation">
				<cfinvokeargument name="timestamp_date" value="#creation_date#">
			</cfinvoke>
			<cfset creation_date = stringDateCreation>
			
			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringDateConnection">
				<cfinvokeargument name="timestamp_date" value="#last_connection#">
			</cfinvoke>
			<cfset last_connection = stringDateConnection>
			
			
			<!---space_used in megabytes--->
			<cfif NOT isDefined("space_used_full") AND len("#space_used#") GT 0>
			
				<cfset space_used_full = space_used><!---file_size_full is the file_size from database without parse to megabytes--->
				<cfset space_used = space_used/(1024*1024)>
				<cfset space_used = round(space_used*100)/100>
								
			<cfelse>
				<cfset space_used_full = "">
			</cfif>
			
			
			<cfset object = {
				id="#id#",
				email="#email#",
				language="#language#",
				client_abb="#client_abb#",
				password="#password#",				
				telephone="#telephone#",
				password="#password#",
				space_used_full="#space_used_full#",
				space_used="#space_used#",
				number_of_connections="#number_of_connections#",
				last_connection="#last_connection#",
				connected="#connected#",
				session_id="#session_id#",
				creation_date="#creation_date#",
				whole_tree_visible="#whole_tree_visible#",
				internal_user="#internal_user#",
				root_folder_id="#root_folder_id#",
				general_administrator="#general_administrator#",
				sms_allowed="#sms_allowed#",
				family_name="#family_name#",
				name="#name#",
				user_full_name="#user_full_name#",
				address="#address#",
				areas_administration="#areas_administration#",
				mobile_phone="#mobile_phone#",
				telephone_ccode="#telephone_ccode#",
				mobile_phone_ccode="#mobile_phone_ccode#",
				login_ldap="#login_ldap#",
				login_diraya="#login_diraya#",
				area_id="#area_id#",
				user_in_charge="#user_in_charge#",
				center_id="#center_id#",
				category_id="#category_id#",
				service_id="#service_id#",
				service="#service#",
				other_1="#other_1#",
				other_2="#other_2#",
				dni="#dni#",
				password_temp="#password_temp#",		
				image_file="#image_file#",
				image_type="#image_type#",
				area_member="#area_member#",
				perfil_cabecera="#perfil_cabecera#"
				}>
			
			
			<cfif isDefined("arguments.return_type")>
			
				<cfif arguments.return_type EQ "object">
				
					<cfreturn object>
					
				<cfelseif arguments.return_type EQ "xml">
				
					<cfinvoke component="UserManager" method="xmlUser" returnvariable="xmlResult">
						<cfinvokeargument name="objectUser" value="#object#">
					</cfinvoke>
					<cfreturn xmlResult>
					
				<cfelse>
				
					<cfreturn object>
									
				</cfif>
				
			<cfelse>
			
				<cfreturn object>
				
			</cfif>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	<!--- -------------------------- isInternalUser -------------------------------- --->
	<!---Obtiene si el usuario es interno o no--->
	
	<cffunction name="isInternalUser" returntype="boolean" access="public">
 		<cfargument name="get_user_id" type="numeric" required="true">
		
		<cfset var method = "isInternalUser">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfquery datasource="#client_dsn#" name="isIternalUserQuery">
			SELECT internal_user
			FROM #client_abb#_users AS users
			WHERE users.id = <cfqueryparam value="#arguments.get_user_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif isIternalUserQuery.internal_user IS 1>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>		
	
	</cffunction>
	
	
	<!--- -------------------------- isRootUser -------------------------------- --->
	<!---Obtiene si el usuario está en la raiz de la organización o no--->
	
	<cffunction name="isRootUser" returntype="boolean" access="public">
 		<cfargument name="get_user_id" type="numeric" required="yes">
		
		<cfset var method = "isInternalUser">
		
		<cfset var root_area_id = "">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfinvoke component="AreaManager" method="getRootAreaId" returnvariable="root_area_id">
		</cfinvoke>	

		<cfquery name="isRootUserQuery" datasource="#client_dsn#">
			SELECT user_id 
			FROM #client_abb#_areas_users
			WHERE user_id = <cfqueryparam value="#arguments.get_user_id#" cfsqltype="cf_sql_integer"> 
			AND area_id = <cfqueryparam value="#root_area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif isRootUserQuery.recordCount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>		
	
	</cffunction>
	
	
	<!---  ---------------------CREATE USER------------------------------------ --->
		
	<cffunction name="createUser" returntype="string" output="false" access="public">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "createUser">
		
		<cfset var user_id = "">
<cfset var client_abb = "">
<cfset var user_language = "">
	
<cfset var xmlRequest = "">
<cfset var xmlResponseContent = "">
	
		<cftry>
		
			<cfif APPLICATION.moduleLdapUsers NEQ true><!---Default User--->
			
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
				
				<cfif listFind(APPLICATION.languages, objectUser.language , ",") IS 0>
					<cfset objectUser.language = APPLICATION.defaultLanguage>
				</cfif>

				<cfset objectUser.email = Trim(objectUser.email)>
				<cfset objectUser.mobile_phone = Trim(objectUser.mobile_phone)>
				
				<cftry>
				
					<cfquery name="beginQuery" datasource="#client_dsn#">
						BEGIN;
					</cfquery>
					
					<!---checkEmail--->

					<!---Esto no puede estar habilitado hasta que se cambie la interfaz o la gestión de errores
					<cfif len(objectUser.email) IS 0 OR NOT isValid("email",objectUser.email)>
						<cfthrow message="Email incorrecto"/>
					</cfif>--->

					<cfquery name="checkEmail" datasource="#client_dsn#">
						SELECT id
						FROM #client_abb#_users
						WHERE email=<cfqueryparam value="#objectUser.email#" cfsqltype="cf_sql_varchar">;
					</cfquery>
					
					<cfif checkEmail.recordCount GT 0><!---User email already used--->
						<cfset error_code = 205>
					
						<cfthrow errorcode="#error_code#">
					</cfif>

					<cfif SESSION.client_id EQ "hcs">

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
							
						</cfif>

					</cfif>
					
					<!---<cfinvoke component="DateManager" method="getCurrentDateTime" returnvariable="current_date">
					</cfinvoke>--->
										
					<!---Insert User in DataBase--->			
					<cfquery name="insertUserQuery" datasource="#client_dsn#" result="insertUserResult">
						INSERT INTO #client_abb#_users
						SET email = <cfqueryparam value="#objectUser.email#" cfsqltype="cf_sql_varchar">,
						name = <cfqueryPARAM value="#objectUser.name#" CFSQLType = "CF_SQL_varchar">,
						family_name = <cfqueryPARAM value="#objectUser.family_name#" CFSQLType = "CF_SQL_varchar">,
						telephone = <cfqueryPARAM value="#objectUser.telephone#" CFSQLType = "CF_SQL_varchar">,
						address = <cfqueryPARAM value="#objectUser.address#" CFSQLType = "CF_SQL_varchar">,
						password = <cfqueryPARAM value="#objectUser.password#" CFSQLType = "CF_SQL_varchar">,
						internal_user = <cfqueryPARAM value="#objectUser.whole_tree_visible#" CFSQLType = "CF_SQL_bit">,
						sms_allowed = <cfqueryPARAM value="#objectUser.sms_allowed#" CFSQLType = "CF_SQL_bit">,
						mobile_phone = <cfqueryPARAM value="#objectUser.mobile_phone#" CFSQLType = "CF_SQL_varchar">,
						creation_date = NOW(),
						<cfif len(objectUser.telephone_ccode) GT 0>
							telephone_ccode = <cfqueryPARAM value="#objectUser.telephone_ccode#" cfsqltype="cf_sql_integer">,
						<cfelse>
							telephone_ccode = <cfqueryparam null="true" cfsqltype="cf_sql_numeric">,
						</cfif>
						<cfif len(objectUser.mobile_phone_ccode) GT 0>
							mobile_phone_ccode = <cfqueryPARAM value="#objectUser.mobile_phone_ccode#" cfsqltype="cf_sql_integer">
						<cfelse>
								mobile_phone_ccode = <cfqueryparam null="true" cfsqltype="cf_sql_numeric">
						</cfif>,
						language = <cfqueryparam value="#objectUser.language#" cfsqltype="cf_sql_varchar">,
						dni = <cfqueryparam value="#objectUser.dni#" cfsqltype="cf_sql_varchar">
						<cfif len(objectUser.login_ldap) GT 0>
						, login_ldap = <cfqueryparam value="#objectUser.login_ldap#" cfsqltype="cf_sql_varchar">
						</cfif>
						<cfif len(objectUser.perfil_cabecera) GT 0>
						, perfil_cabecera = <cfqueryparam value="#objectUser.perfil_cabecera#" cfsqltype="cf_sql_varchar">
						</cfif>
						;
					</cfquery>
					
					<!---Aquí se obtiene el id del usuario insertado en base de datos--->
					<!---<cfset objectUser.id = insertUserResult.GENERATED_KEY>--->
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
							NOW(),
							<cfqueryparam value="#objectUser.id#" cfsqltype="cf_sql_integer">,
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
						<cfset xmlResponseContent = arguments.request>
						<cfinclude template="includes/errorHandler.cfm">
						<cfreturn xmlResponse>
					</cfcatch>										
					
				</cftry>	
				
				<!---<cfset password_temp = xmlRequest.request.parameters.user.password_temp.xmlText>--->
				<cfset password_temp = objectUser.password_temp>

				<cfinvoke component="AlertManager" method="newUser">
					<cfinvokeargument name="objectUser" value="#objectUser#">
					<cfinvokeargument name="password_temp" value="#password_temp#">
				</cfinvoke>
				
				<cfinvoke component="UserManager" method="xmlUser" returnvariable="xmlResponseContent">
					<cfinvokeargument name="objectUser" value="#objectUser#">
				</cfinvoke>	
				
			
				
		
			<cfelse><!---LDAP User--->
			
				<cfinvoke component="UserLDAPManager" method="createUser" returnvariable="xmlResponseContent">
					<cfinvokeargument name="request" value="#arguments.request#">
				</cfinvoke>
			
			</cfif>
			
			<cfinclude template="includes/functionEnd.cfm">
		
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
			
	</cffunction>
	
	<!---  -----------------------UPDATE USER------------------------------------- --->

	<cffunction name="updateUser" returntype="string" output="false" access="public">
		<cfargument name="request" type="string" required="yes">	
		
		<cfset var method = "updateUser">
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">
			
		<cfset var xmlRequest = "">
		<cfset var xmlResponseContent = "">

		<cfset var updateUserId = "">
	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">	
			
			<cfxml variable="userXml">
				<cfoutput >
					#xmlRequest.request.parameters.user#
				</cfoutput>
			</cfxml>
			
			<cfset updateUserId = userXml.user.XmlAttributes.id>

			<cfif updateUserId IS NOT user_id>
				<cfinclude template="includes/checkAdminAccess.cfm">
			</cfif>

			<cfquery name="beginQuery" datasource="#client_dsn#">
				BEGIN;
			</cfquery>
			
			<cfif isDefined("userXml.user.XmlAttributes.email")>
				<!---checkEmail--->

				<!---
				Esto no puede estar habilitado hasta que se cambie la interfaz o la gestión de errores
				<cfif len(Trim(userXml.user.XmlAttributes.email)) IS 0 OR NOT isValid("email", Trim(userXml.user.XmlAttributes.email))>
					<cfthrow message="Email incorrecto"/>
				</cfif>--->

				<cfquery name="checkEmail" datasource="#client_dsn#">
					SELECT id
					FROM #client_abb#_users
					WHERE email=<cfqueryparam value="#Trim(userXml.user.XmlAttributes.email)#" cfsqltype="cf_sql_varchar">;
				</cfquery>
				
				<cfif checkEmail.recordCount GT 0><!---User email already used--->
					<cfif checkEmail.id NEQ updateUserId><!---This user is not the user who has this email--->
						<cfset error_code = 205>
					
						<cfthrow errorcode="#error_code#">
					</cfif>
				</cfif>
				
				<cfquery name="emailQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET email = <cfqueryPARAM value="#Trim(userXml.user.XmlAttributes.email)#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("userXml.user.name")>
				<cfquery name="nameQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET name = <cfqueryPARAM value = "#userXml.user.name.xmlText#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("userXml.user.family_name")>
				<cfquery name="familyNameQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET family_name = <cfqueryPARAM value = "#userXml.user.family_name.xmlText#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("userXml.user.address")>
				<cfquery name="addressQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET address = <cfqueryPARAM value = "#userXml.user.address.xmlText#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("userXml.user.XmlAttributes.password")>
				<cfquery name="passwordQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET password = <cfqueryPARAM value = "#userXml.user.XmlAttributes.password#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>			
			<cfif isDefined("userXml.user.XmlAttributes.telephone")>
				<cfquery name="telephoneQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET telephone = <cfqueryPARAM value = "#userXml.user.XmlAttributes.telephone#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("userXml.user.XmlAttributes.mobile_phone")>
				<cfquery name="mobilePhoneQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET mobile_phone = <cfqueryPARAM value = "#userXml.user.XmlAttributes.mobile_phone#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>	
			<cfif isDefined("userXml.user.XmlAttributes.whole_tree_visible")>
				<cfquery name="wholeTreeVisibleQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET internal_user = <cfqueryPARAM value = "#userXml.user.XmlAttributes.whole_tree_visible#" CFSQLType = "CF_SQL_bit">
					WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("userXml.user.XmlAttributes.sms_allowed")>
				<cfquery name="smsAllowedQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET sms_allowed = <cfqueryPARAM value = "#userXml.user.XmlAttributes.sms_allowed#" CFSQLType = "CF_SQL_bit">
					WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("userXml.user.XmlAttributes.telephone_ccode")>
				<cfquery name="telephoneCcodeQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET telephone_ccode = <cfqueryPARAM value = "#userXml.user.XmlAttributes.telephone_ccode#" cfsqltype="cf_sql_integer">
					WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("userXml.user.XmlAttributes.mobile_phone_ccode")>
				<cfquery name="mobilePhoneCcodeQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET mobile_phone_ccode = <cfqueryPARAM value = "#userXml.user.XmlAttributes.mobile_phone_ccode#" cfsqltype="cf_sql_integer">
					WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			
			<cfif APPLICATION.moduleLdapUsers EQ true>
				<cfif isDefined("userXml.user.login_ldap")>
					<cfquery name="loginLdapQuery" datasource="#client_dsn#">
						UPDATE #client_abb#_users SET login_ldap = <cfqueryparam value = "#userXml.user.login_ldap.xmlText#" cfsqltype="cf_sql_varchar">
						WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
					</cfquery>
				</cfif>
				<cfif isDefined("userXml.user.login_diraya")>
					<cfquery name="loginDirayaQuery" datasource="#client_dsn#">
						UPDATE #client_abb#_users SET login_diraya = <cfqueryparam value = "#userXml.user.login_diraya.xmlText#" cfsqltype="cf_sql_varchar">
						WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
					</cfquery>
				</cfif>
			</cfif>
			
			<cfif isDefined("userXml.user.dni")>
				<cfquery name="updateUserDni" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET dni = <cfqueryparam value="#userXml.user.dni.xmlText#" cfsqltype="cf_sql_varchar">
					WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			
			<cfif isDefined("userXml.user.XmlAttributes.language")>

				<cfset userLanguage = userXml.user.XmlAttributes.language>
				<cfif listFind(APPLICATION.languages, userLanguage) GT 0>

					<cfquery name="updateUserLanguage" datasource="#client_dsn#">
						UPDATE #client_abb#_users SET language = <cfqueryparam value="#userLanguage#" cfsqltype="cf_sql_varchar">
						WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<cfif SESSION.user_id EQ updateUserId>
						<!--- Set language in current user SESSION --->
						<cfset SESSION.user_language = userLanguage>
					</cfif>
					
				<cfelse><!---The application does not have this language--->
					
					<cfset error_code = 10000>
					
					<cfthrow errorcode="#error_code#" message="The application does not have defined this language: #userLanguage#">
					
				</cfif>
				
			</cfif>
			
			<cfif APPLICATION.identifier EQ "vpnet">
			
				<cfif isDefined("userXml.user.center.xmlAttributes.id")>
					<cfquery name="updateUserCenter" datasource="#client_dsn#">
						UPDATE #client_abb#_users SET center_id = <cfqueryparam value="#userXml.user.center.xmlAttributes.id#" cfsqltype="cf_sql_varchar">
						WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
					</cfquery>
				</cfif>
				<cfif isDefined("userXml.user.category.xmlAttributes.id")>
					<cfquery name="updateUserCategory" datasource="#client_dsn#">
						UPDATE #client_abb#_users SET category_id = <cfqueryparam value="#userXml.user.category.xmlAttributes.id#" cfsqltype="cf_sql_varchar">
						WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
					</cfquery>
				</cfif>
				<cfif isDefined("userXml.user.service.xmlAttributes.id")>
					<cfquery name="updateUserServiceId" datasource="#client_dsn#">
						UPDATE #client_abb#_users SET service_id = <cfqueryparam value="#userXml.user.service.xmlAttributes.id#" cfsqltype="cf_sql_varchar">
						WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
					</cfquery>
				</cfif>
				<cfif isDefined("userXml.user.service")>
					<cfquery name="updateUserService" datasource="#client_dsn#">
						UPDATE #client_abb#_users SET service = <cfqueryparam value="#userXml.user.service.xmlText#" cfsqltype="cf_sql_varchar">
						WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
					</cfquery>
				</cfif>
				<cfif isDefined("userXml.user.other_1")>
					<cfquery name="updateUserOther1" datasource="#client_dsn#">
						UPDATE #client_abb#_users SET other_1 = <cfqueryparam value="#userXml.user.other_1.xmlText#" cfsqltype="cf_sql_varchar">
						WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
					</cfquery>
				</cfif>
				<cfif isDefined("userXml.user.other_2")>
					<cfquery name="updateUserOther2" datasource="#client_dsn#">
						UPDATE #client_abb#_users SET other_2 = <cfqueryparam value="#userXml.user.other_2.xmlText#" cfsqltype="cf_sql_varchar">
						WHERE id = <cfqueryparam value="#updateUserId#" cfsqltype="cf_sql_integer">;
					</cfquery>
				</cfif>
			
			</cfif>
			
						
			<cfquery name="endQuery" datasource="#client_dsn#">
				COMMIT;
			</cfquery>
			
			
			<cfinvoke component="UserManager" method="getUser" returnvariable="xmlResult">
				<cfinvokeargument name="get_user_id" value="#updateUserId#">
				<cfinvokeargument name="format_content" value="all">
			</cfinvoke>	
							
			<cfset xmlResponseContent = xmlResult>
			
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
		
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	<!--------------------------------------------------------------------------------->
		
	<!--- ----------------------- DELETE USER -------------------------------- --->
	
	<cffunction name="deleteUser" returntype="string" output="false" access="public">
		<cfargument name="delete_user_id" type="numeric" required="yes">
		
		<cfset var method = "deleteUser">

		<cfset var response = structNew()>

		<cfset var user_id = "">
		<cfset var client_abb = "">
		
		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinclude template="includes/checkAdminAccess.cfm">
						
			<cfquery name="getUserQuery" datasource="#client_dsn#">		
				SELECT id, root_folder_id, image_file
				FROM #client_abb#_users
				WHERE id=<cfqueryparam value="#arguments.delete_user_id#" cfsqltype="cf_sql_integer">;		
			</cfquery>
			
			<cfif getUserQuery.recordCount GT 0>
				
				<cfquery name="beginQuery" datasource="#client_dsn#">		
					BEGIN;		
				</cfquery>
								
				<!---REMOVE USER FROM AREAS IN CHARGE--->
				<!---Se quita al usuario de las áreas que tiene a su cargo y se pone al administrador de la organización--->
				<cfquery name="changeUserAreasInCharge" datasource="#client_dsn#">
					UPDATE #client_abb#_areas 
					SET user_in_charge=<cfqueryparam value="#SESSION.client_administrator#" cfsqltype="cf_sql_integer">
					WHERE user_in_charge=<cfqueryparam value="#getUserQuery.id#" cfsqltype="cf_sql_integer">;
				</cfquery>		
				
				<!--- DELETE USER AREAS LINKS --->
				<cfquery name="deleteUserAreasQuery" datasource="#client_dsn#">	
					DELETE FROM #client_abb#_areas_users
					WHERE user_id = <cfqueryparam value="#getUserQuery.id#" cfsqltype="cf_sql_integer">;
				</cfquery>
				
				<!---DELETE USER CONTACTS--->
				<!---All the user contacts are deleted in the database when the user is deleted--->
				
				<!--- -----------------DELETE USER MESSAGES------------------------- --->
				<cfinvoke component="AreaItemManager" method="deleteUserItems">
					<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
					<cfinvokeargument name="itemTypeId" value="1">
				</cfinvoke>	
				
				<cfif APPLICATION.moduleWeb EQ true>
				
					<!--- -----------------DELETE USER ENTRIES------------------------- --->
					<cfinvoke component="AreaItemManager" method="deleteUserItems">
						<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
						<cfinvokeargument name="itemTypeId" value="2">
					</cfinvoke>
					
					<cfif APPLICATION.identifier EQ "vpnet">
					
						<!--- -----------------DELETE USER LINKS------------------------- --->
						<cfinvoke component="AreaItemManager" method="deleteUserItems">
							<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
							<cfinvokeargument name="itemTypeId" value="3">
						</cfinvoke>
					
					</cfif>
					
					<!--- -----------------DELETE USER NEWS------------------------- --->
					<cfinvoke component="AreaItemManager" method="deleteUserItems">
						<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
						<cfinvokeargument name="itemTypeId" value="4">
					</cfinvoke>

					<!--- -----------------DELETE USER IMAGES------------------------- --->
					<cfinvoke component="AreaItemManager" method="deleteUserItems">
						<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
						<cfinvokeargument name="itemTypeId" value="9">
					</cfinvoke>
				
				</cfif>
				
				
				<cfif APPLICATION.moduleWeb EQ true OR APPLICATION.identifier NEQ "vpnet">
				
					<!--- -----------------DELETE USER EVENTS------------------------- --->
					<cfinvoke component="AreaItemManager" method="deleteUserItems">
						<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
						<cfinvokeargument name="itemTypeId" value="5">
					</cfinvoke>
					
				</cfif>
				
				<cfif APPLICATION.identifier NEQ "vpnet">
				
					<!--- -----------------DELETE USER TASKS------------------------- --->
					<cfinvoke component="AreaItemManager" method="deleteUserItems">
						<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
						<cfinvokeargument name="itemTypeId" value="6">
					</cfinvoke>
				
				</cfif>
				
				<cfif APPLICATION.moduleConsultations IS true>
				
					<!--- -----------------DELETE USER CONSULTATIONS------------------------- --->
					<cfinvoke component="AreaItemManager" method="deleteUserItems">
						<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
						<cfinvokeargument name="itemTypeId" value="7">
					</cfinvoke>
				
				</cfif>	

				<cfif APPLICATION.modulePubMedComments IS true>
				
					<!--- -----------------DELETE USER PUBMEDS------------------------- --->
					<cfinvoke component="AreaItemManager" method="deleteUserItems">
						<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
						<cfinvokeargument name="itemTypeId" value="8">
					</cfinvoke>

				</cfif>

				<!---

				Esto deshabilitado porque las listas y formularios son elementos que TIENEN REGISTROS DE OTROS USUARIOS

				UNA SOLUCIÓN PARA ESTO PODRÍA SER PONER EL ADMINISTRADOR GENERAL DE PROPIETARIO DE LOS ELEMENTOS QUE NO SE DEBEN ELIMINAR

				<cfif APPLICATION.moduleLists IS true>
					
					<!--- -----------------DELETE USER LISTS------------------------- --->
					<cfinvoke component="AreaItemManager" method="deleteUserItems">
						<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
						<cfinvokeargument name="itemTypeId" value="11">
					</cfinvoke>

				</cfif>

				<cfif APPLICATION.moduleForms IS true>
					
					<!--- -----------------DELETE USER FORMS------------------------- --->
					<cfinvoke component="AreaItemManager" method="deleteUserItems">
						<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
						<cfinvokeargument name="itemTypeId" value="12">
					</cfinvoke>

				</cfif>

				--->					
				
				<!---DELETE USER FOLDERS AND FILES--->
				<cfinvoke component="FolderManager" method="deleteFolder" returnvariable="deleteFolderResult">
					<cfinvokeargument name="request" value='<request><parameters><folder id="#getUserQuery.root_folder_id#"/></parameters></request>'>
				</cfinvoke>
				
				<cfxml variable="xmlDeleteFolderResult">
					<cfoutput>
					#deleteFolderResult#
					</cfoutput>
				</cfxml>
				
				<cfif xmlDeleteFolderResult.response.xmlAttributes.status EQ "error"><!---Delete folder failed--->
					<!--- RollBack the transaction --->
					<cfquery name="rollBackTransaction" datasource="#client_dsn#">
						ROLLBACK;
					</cfquery>
					
					<cfset error_code = 709>
			
					<cfthrow errorcode="#error_code#">
											
				</cfif>

				<!--- DELETE USER FILES --->
				<!---En las versiones más recientes de la aplicación los archivos ya no se añaden a un directorio del usuario--->
				<cfquery name="filesQuery" datasource="#client_dsn#">
					SELECT id 
					FROM #client_abb#_files 
					WHERE user_in_charge = <cfqueryparam value="#arguments.delete_user_id#" cfsqltype="cf_sql_integer">
					AND status = 'ok'
					AND file_type_id = 1;
				</cfquery>

				<cfloop query="filesQuery">
					
					<cfinvoke component="FileManager" method="deleteFile" returnvariable="deleteFileResult">
						<cfinvokeargument name="file_id" value="#filesQuery.id#">
					</cfinvoke>

					<cfif deleteFileResult.result IS false>

						<!--- RollBack the transaction --->
						<cfquery name="rollBackTransaction" datasource="#client_dsn#">
							ROLLBACK;
						</cfquery>
							
						<cfthrow message="#deleteFileResult.message#">

					</cfif>

				</cfloop>
				
				
				<!---DELETE USER IMAGE--->
				<cfif len(getUserQuery.image_file) GT 0>
					<cfinvoke component="#APPLICATION.coreComponentsPath#/UserImageFile" method="deleteUserImage">
						<cfinvokeargument name="user_id" value="#arguments.delete_user_id#">
						<cfinvokeargument name="client_abb" value="#client_abb#">
					</cfinvoke>
				</cfif>	
				
				
				<!--- ------------------DELETE OTHER FILES (PENDING/CANCELED FILES)---------------------------- --->
				<cfquery name="otherFilesQuery" datasource="#client_dsn#">
					DELETE
					FROM #client_abb#_files 
					WHERE user_in_charge = <cfqueryparam value="#getUserQuery.id#" cfsqltype="cf_sql_integer">
					AND file_type_id = 1;
				</cfquery>
				
				<!--- --------------------------------------------------------------------------------- --->
				
								
				<!--- DELETE USER DETAILS --->
				<cfquery name="deleteUserQuery" datasource="#client_dsn#">	
					DELETE FROM #client_abb#_users 
					WHERE id=#getUserQuery.id#;
				</cfquery>				
				
				<cfquery name="commitQuery" datasource="#client_dsn#">		
					COMMIT;		
				</cfquery>

				<cfinclude template="includes/functionEndOnlyLog.cfm">
		
				<cfset response = {result=true, message="", user_id=#arguments.delete_user_id#}>				
								
			
			<cfelse><!---The user id is not found, user does not exist--->
				
				<cfset error_code = 204>
				
				<cfthrow errorcode="#error_code#">
				
			</cfif>			
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>
	
	<!--- ----------------------------------------------------------------------- --->
			
	

	<!------------------------ IS USER ASSOCIATED TO AREA-------------------------------------->	
	<cffunction name="isUserAssociatedToArea" returntype="struct" output="false" access="public">
		<cfargument name="area_id" type="numeric" required="true"/>
		<cfargument name="check_user_id" type="numeric" required="true"/>

		<cfset var method = "isUserAssociatedToArea">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!---isUserInArea--->
			<cfquery name="isUserInArea" datasource="#client_dsn#">
				SELECT user_id
				FROM #client_abb#_areas_users
				WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer"> 
				AND user_id = <cfqueryparam value="#arguments.check_user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif isUserInArea.recordCount GT 0><!--- The user is in the area  --->
				<cfset response = {result=true, isUserInArea=true}>
			<cfelse>
				<cfset response = {result=true, isUserInArea=false}>
			</cfif>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>


		
	<!------------------------ ASSIGN USER TO AREA-------------------------------------->	
	<cffunction name="assignUserToArea" returntype="struct" output="false" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="add_user_id" type="numeric" required="true">
		
		<cfset var method = "assignUserToArea">

		<cfset response = structNew()>

		<cfset var user_id = "">
		<cfset var client_abb = "">	
			
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
						
			<cfinclude template="includes/checkAreaAdminAccess.cfm">
		
			<!---checkIfExist--->
			<!---<cfquery name="checkIfExistQuery" datasource="#client_dsn#">
				SELECT user_id
				FROM #client_abb#_areas_users
				WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer"> 
				AND user_id = <cfqueryparam value="#arguments.add_user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>--->
			<cfinvoke component="UserManager" method="isUserAssociatedToArea" returnvariable="isUserInAreaResponse">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="check_user_id" value="#arguments.add_user_id#">
			</cfinvoke>	
			<cfif isUserInAreaResponse.result IS false>
				<cfreturn isUserInAreaResponse>
			</cfif>
			
			<cfif isUserInAreaResponse.isUserInArea IS true><!--- The user already is in the area  --->
				<cfset error_code = 408>
			
				<cfthrow errorcode="#error_code#">
			</cfif>
		
			<cfquery name="assignUser" datasource="#client_dsn#">
				INSERT INTO #client_abb#_areas_users (area_id, user_id)
				VALUES(<cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#arguments.add_user_id#" cfsqltype="cf_sql_integer">);
			</cfquery>	
			
			<cfinvoke component="UserManager" method="getUser" returnvariable="objectUser">
				<cfinvokeargument name="get_user_id" value="#arguments.add_user_id#">
				<cfinvokeargument name="return_type" value="query"/>
			</cfinvoke>	
			
			<!---<cfinvoke component="UserManager" method="objectUser" returnvariable="objectUser">
				<cfinvokeargument name="xml" value="#xmlResponseContent#">
					
				<cfinvokeargument name="return_type" value="object">
			</cfinvoke>--->		
		
			<cfinvoke component="AlertManager" method="assignUserToArea">
				<cfinvokeargument name="objectUser" value="#objectUser#">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="new_area" value="false">
			</cfinvoke>
			
			<cfinclude template="includes/functionEndOnlyLog.cfm">
			
			<cfset response = {result=true, area_id=#arguments.area_id#, user_id=#arguments.add_user_id#}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
				
	</cffunction>
	
	
	<!------------------------ ASSIGN USERS TO AREA-------------------------------------->	
	<cffunction name="assignUsersToArea" returntype="struct" output="false" access="public">
		<cfargument name="area_id" type="numeric" required="true"/>
		<cfargument name="users_id" type="list" required="true"/>
		
		<cfset var method = "assignUsersToArea">

		<cfset var response = structNew()>

		<cfset var user_id = "">
		<cfset var client_abb = "">
			
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<!---<cfxml variable="xmlUsers">
				<cfoutput>
					#xmlRequest.request.parameters.users#
				</cfoutput>
			</cfxml>--->
			
			<cfinclude template="includes/checkAreaAdminAccess.cfm">
		
			<cfloop index="cur_user_index" list="#arguments.users_id#">
				<cfset cur_user_id = cur_user_index>
				
				<cfinvoke component="UserManager" method="assignUserToArea" returnvariable="responseAssignUser">
					<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
					<cfinvokeargument name="add_user_id" value="#cur_user_id#"/>
				</cfinvoke>
				
				<!--- <cfxml variable="xmlResultAssignUser">
					<cfoutput>
						#resultAssignUser#
					</cfoutput>
				</cfxml> --->
				
				<cfif responseAssignUser.result IS false><!---User assign failed--->
					
					<cfreturn responseAssignUser>
				
				</cfif>

			</cfloop>	
			
			<cfinclude template="includes/functionEndOnlyLog.cfm">
			
			<cfset response = {result=true, message="", area_id=#arguments.area_id#}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>	
				
	</cffunction>


	<!--- -------------------DISSOCIATE USER FROM AREA------------------------------------ --->
	
	<cffunction name="dissociateUserFromArea" returntype="struct" output="true" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="dissociate_user_id" type="numeric" required="true">
		
		<cfset var method = "dissociateUserFromArea">

		<cfset var response = structNew()>

		<cfset var user_id = "">
		<cfset var client_abb = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
						
			<cfinclude template="includes/checkAreaAdminAccess.cfm">
			
			<cfquery name="getArea" datasource="#client_dsn#">
				SELECT user_in_charge
				FROM #client_abb#_areas AS areas
				WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
						
			<cfif getArea.recordCount GT 0>

				<cfinvoke component="UserManager" method="isUserAssociatedToArea" returnvariable="isUserInAreaResponse">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="check_user_id" value="#arguments.dissociate_user_id#">
				</cfinvoke>	
				<cfif isUserInAreaResponse.result IS false>
					<cfreturn isUserInAreaResponse>
				</cfif>
				
				<cfif isUserInAreaResponse.isUserInArea IS false><!--- The user is not associated  --->
					<cfthrow message="Este usuario no está asociado directamente a esta área">
				</cfif>

				<!---check if the user is the user_in_charge of the area--->
				<cfif getArea.user_in_charge EQ arguments.dissociate_user_id>
					
					<cfset error_code = 411>
					
					<cfthrow errorcode="#error_code#">
					
				</cfif>
			
				<cfquery name="dissociateUser" datasource="#client_dsn#">
					DELETE FROM #client_abb#_areas_users
					WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer"> AND user_id = <cfqueryparam value="#arguments.dissociate_user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
			
			<cfelse><!---The area does not exist--->
				
				<cfset error_code = 401>
				
				<cfthrow errorcode="#error_code#">
			
			</cfif>

			<cfinclude template="includes/functionEndOnlyLog.cfm">
			
			<cfset response = {result=true, message="", area_id=#arguments.area_id#}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>	
				
				
	</cffunction>


	<!--- --------------------------SELECT USER ------------------------------ --->
	
	<cffunction name="selectUser" returntype="string" output="false" access="public">
		<cfargument name="request" type="string" required="yes">
		<!---<cfargument name="id" type="string" required="true">--->
		
		<cfset var method = "selectUser">
		<cfset var user_id = "">
<cfset var client_abb = "">
<cfset var user_language = "">
	
<cfset var xmlRequest = "">
<cfset var xmlResponseContent = "">

		
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm"> 
		
			<cfset select_user_id = xmlRequest.request.parameters.user.xmlAttributes.id>
			
			<cfinvoke component="UserManager" method="getUser" returnvariable="xmlResponseContent">
				<cfinvokeargument name="get_user_id" value="#select_user_id#">
			</cfinvoke>	
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>	
		
		<cfreturn xmlResponse>
				
	</cffunction>
	
	
	<!--- --------------------------SELECT USER ADMIN------------------------------ --->
	
	<cffunction name="selectUserAdmin" returntype="string" output="false" access="public">
		<cfargument name="request" type="string" required="yes">
		<!---<cfargument name="id" type="string" required="true">--->
		
		<cfset var method = "selectUserAdmin">
		<cfset var user_id = "">
<cfset var client_abb = "">
<cfset var user_language = "">
	
<cfset var xmlRequest = "">
<cfset var xmlResponseContent = "">

		
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm"> 
		
			<cfset select_user_id = xmlRequest.request.parameters.user.xmlAttributes.id>
			
			<cfinvoke component="UserManager" method="getUser" returnvariable="xmlResponseContent">
				<cfinvokeargument name="get_user_id" value="#select_user_id#">
				<cfinvokeargument name="format_content" value="all">
			</cfinvoke>	
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>	
		
		<cfreturn xmlResponse>
				
	</cffunction>
	
	
	<!--- --------------------------GET USER ------------------------------ --->
	
	<cffunction name="getUser" returntype="any" output="false" access="public">
		<cfargument name="get_user_id" type="numeric" required="yes">
		<cfargument name="format_content" type="string" required="no" default="default">
		<cfargument name="return_type" type="string" required="no" default="xml"><!---xml/object/query--->
		
		<cfset var method = "getUser">
		
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">

		<cfset var objectUser = structNew()>

		<cfset var response = "">
		
			<cfinclude template="includes/functionStartOnlySession.cfm"> 
		
			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="selectUserQuery">
				<cfinvokeargument name="user_id" value="#arguments.get_user_id#">
				<cfinvokeargument name="format_content" value="#arguments.format_content#">
				<cfinvokeargument name="with_ldap" value="#APPLICATION.moduleLdapUsers#">
				<cfif APPLICATION.identifier EQ "vpnet">
					<cfinvokeargument name="with_vpnet" value="true">
				</cfif>

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfif selectUserQuery.recordCount GT 0>

				<cfquery name="checkClientAdministrator" datasource="#APPLICATION.dsn#">
					SELECT id 
					FROM APP_clients				
					WHERE abbreviation = <cfqueryparam value="#client_abb#" cfsqltype="cf_sql_varchar">
					AND administrator_id = <cfqueryparam value="#arguments.get_user_id#" cfsqltype="cf_sql_integer">;			
				</cfquery>
				
				<cfif checkClientAdministrator.recordCount GT 0>
					<!---<cfset general_administrator = true>--->
					<cfset general_administrator = 1>
				<cfelse>
					<!---<cfset general_administrator = false>--->
					<cfset general_administrator = 0>
					
					<cfquery name="checkAreaAdministrator" datasource="#client_dsn#">
						SELECT user_id, area_id 
						FROM #client_abb#_areas_administrators		
						WHERE user_id = <cfqueryparam value="#arguments.get_user_id#" cfsqltype="cf_sql_integer">;			
					</cfquery>
					
				</cfif>

				<cfif arguments.return_type EQ "query">
                    
                    <cfset response = selectUserQuery>
				
				<cfelse>

					<cfsavecontent variable="areasUser">
						<cfif isDefined("checkAreaAdministrator") AND checkAreaAdministrator.recordCount GT 0>
							<areas_administration>
								<cfoutput>
									<cfloop query="checkAreaAdministrator">
										<area id="#area_id#"/>
									</cfloop>
								</cfoutput>
							</areas_administration>
						<cfelse>
							<areas_administration />
						</cfif>
					</cfsavecontent>	
					
					<cfinvoke component="UserManager" method="objectUser" returnvariable="objectUser">
						<cfinvokeargument name="id" value="#selectUserQuery.id#">
						<cfinvokeargument name="email" value="#selectUserQuery.email#">
						<cfinvokeargument name="telephone" value="#selectUserQuery.telephone#">
						<cfinvokeargument name="telephone_ccode" value="#selectUserQuery.telephone_ccode#">
						<cfinvokeargument name="family_name" value="#selectUserQuery.family_name#">
						<cfinvokeargument name="name" value="#selectUserQuery.name#">
						<cfinvokeargument name="address" value="#selectUserQuery.address#">
						<cfinvokeargument name="mobile_phone" value="#selectUserQuery.mobile_phone#">
						<cfinvokeargument name="mobile_phone_ccode" value="#selectUserQuery.mobile_phone_ccode#">
						<cfinvokeargument name="whole_tree_visible" value="#selectUserQuery.internal_user#">
						
						<cfinvokeargument name="image_file" value="#selectUserQuery.image_file#">
						<cfinvokeargument name="image_type" value="#selectUserQuery.image_type#">
						<cfinvokeargument name="dni" value="#selectUserQuery.dni#">
						<cfinvokeargument name="language" value="#selectUserQuery.language#">

						<cfif arguments.format_content EQ "all">	
							<cfinvokeargument name="client_abb" value="#client_abb#">		
							<cfinvokeargument name="areas_administration" value="#areasUser#">
							<cfinvokeargument name="space_used" value="#selectUserQuery.space_used#">
							<cfinvokeargument name="number_of_connections" value="#selectUserQuery.number_of_connections#">
							<cfinvokeargument name="last_connection" value="#selectUserQuery.last_connection#">
							<cfinvokeargument name="connected" value="#selectUserQuery.connected#">
							<cfinvokeargument name="session_id" value="#selectUserQuery.session_id#">
							<cfinvokeargument name="creation_date" value="#selectUserQuery.creation_date#">
							<cfinvokeargument name="root_folder_id" value="#selectUserQuery.root_folder_id#">
							<cfinvokeargument name="general_administrator" value="#general_administrator#">
							<cfinvokeargument name="sms_allowed" value="#selectUserQuery.sms_allowed#">
							<cfif APPLICATION.moduleLdapUsers EQ true>
								<cfinvokeargument name="login_ldap" value="#selectUserQuery.login_ldap#">
								<cfinvokeargument name="login_diraya" value="#selectUserQuery.login_diraya#">
							</cfif>
							<cfif APPLICATION.identifier EQ "vpnet">
								<cfinvokeargument name="center_id" value="#selectUserQuery.center_id#">
								<cfinvokeargument name="category_id" value="#selectUserQuery.category_id#">
								<cfinvokeargument name="service_id" value="#selectUserQuery.service_id#">
								<cfinvokeargument name="service" value="#selectUserQuery.service#">
								<cfinvokeargument name="other_1" value="#selectUserQuery.other_1#">
								<cfinvokeargument name="other_2" value="#selectUserQuery.other_2#">
							</cfif>
						</cfif>
						
						
						<cfinvokeargument name="return_type" value="object">
					</cfinvoke>
					
					<cfif arguments.return_type EQ "object">
	                    
	                    <cfset response = objectUser>
	                    
	                <cfelse>
	                
	                	<cfinvoke component="UserManager" method="xmlUser" returnvariable="xmlResponseContent">
	                        <cfinvokeargument name="objectUser" value="#objectUser#">
	                    </cfinvoke>
	                    
	                    <cfset response = xmlResponseContent>
	                
	                </cfif>	

	            </cfif>				
						
			<cfelse><!---the user does not exist--->
				
				<cfset error_code = 204>
				
				<cfthrow errorcode="#error_code#"> 
				
			</cfif>
		
		<cfreturn response>
				
	</cffunction>
	
	
	<!--- ---------------------------- updateUserDownloadedSpace ------------------------------- --->
	
	<cffunction name="updateUserDownloadedSpace" access="public">	
		<cfargument name="add_space" type="numeric" required="true">
		
		<cfset var method = "updateUserDownloadedSpace">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
		<!---
		ESTO SE COMENTA AQUÍ PARA VER SI SE SOLUCIONAN LOS PROBLEMAS QUE HAY CON LAS
		TRANSACCIONES QUE SE QUEDAN BLOQUEADAS EN LA TABLA users
		<cfquery datasource="#client_dsn#" name="beginQuery">
			BEGIN;
		</cfquery>--->
		<cfquery name="updateUserDownloadedSpace" datasource="#client_dsn#">
			UPDATE #client_abb#_users
			SET space_downloaded = space_downloaded+<cfqueryparam value="#add_space#" cfsqltype="cf_sql_integer">
			WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		<!---<cfquery datasource="#client_dsn#" name="commitQuery">
			COMMIT;
		</cfquery>--->
			
	
	</cffunction>
		
	
	<!--- ----------------------- GET NUMBER OF USERS -------------------------------- --->
	
	<cffunction name="getNumberOfUsers" returntype="string" output="false" access="public">
		
		<cfset var method = "getNumberOfUsers">
		<cfset var user_id = "">
<cfset var client_abb = "">
<cfset var user_language = "">
	
<cfset var xmlRequest = "">
<cfset var xmlResponseContent = "">
	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
		
			<cfquery name="getUsersCountQuery" datasource="#client_dsn#">
				SELECT count(*) 
				FROM #client_abb#_users
			</cfquery>		
			<!---<cfreturn #getUsersCountQuery.count#>--->
		
		
			<cfset xmlResponseContent = '<number_users>#getUsersCountQuery.count#</number_users>'>
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
	</cffunction>

	
	<!--- ---------------------------- getAreaUsers ------------------------------- --->
	
	<cffunction name="getAreaUsers" returntype="struct" output="false" access="public">
		<!---<cfargument name="area_id" type="string" required="yes">
		<cfargument name="areasArray" type="array" required="yes">
		<cfargument name="include_user_log_in" type="boolean" required="no" default="false">
		<cfargument name="get_orientation" type="string" required="no" default="desc">
		
		<cfargument name="notify_new_message" type="string" required="no" default="">
		<cfargument name="notify_new_file" type="string" required="no" default="">
		<cfargument name="notify_replace_file" type="string" required="no" default="">
		<cfargument name="notify_new_area" type="string" required="no" default="">
		
		<cfargument name="notify_new_entry" type="string" required="no" default="">
		<cfargument name="notify_new_link" type="string" required="no" default="">
		<cfargument name="notify_new_news" type="string" required="no" default="">
		<cfargument name="notify_new_event" type="string" required="no" default="">
		<cfargument name="notify_new_task" type="string" required="no" default="">
		<cfargument name="notify_new_consultation" type="string" required="no" default="">

		<cfargument name="notify_new_image" type="string" required="false" default="">
		<cfargument name="notify_new_typology" type="string" required="false" default="">
		<cfargument name="notify_new_list" type="string" required="false" default="">
		<cfargument name="notify_new_form" type="string" required="false" default="">
		<cfargument name="notify_new_pubmed" type="string" required="false" default="">
		
		<cfargument name="with_external" type="string" required="no" default="true">--->
        
		<cfset var method = "getAreaUsers">
		
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="getAreaUsers" argumentcollection="#arguments#" returnvariable="response">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
						
			<!---<cfinvoke component="UserManager" method="getAreaUsersIds" returnvariable="usersIdsResult">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="areasArray" value="#arguments.areasArray#">
				<!---<cfinvokeargument name="include_user_log_in" value="#arguments.include_user_log_in#">--->
				<cfinvokeargument name="get_orientation" value="#arguments.get_orientation#">			
			</cfinvoke>
			
			<cfset usersList = usersIdsResult.usersList>
			<cfset areasArray = usersIdsResult.areasArray>
			<cfset areaMembersList = usersIdsResult.areaMembersList>
					
			<cfset usersArray = arrayNew(1)>
			
			<cfif listLen(usersList) GT 0>
			
				<cfquery name="areaUsersQuery" datasource="#client_dsn#">
					SELECT id, email, telephone, space_used, number_of_connections, last_connection, connected, session_id, creation_date, internal_user, root_folder_id, family_name, name, address, mobile_phone, telephone_ccode, mobile_phone_ccode, image_type, language
					FROM #client_abb#_users AS u
					WHERE u.id IN (#usersList#)
					<cfif isDefined("arguments.include_user_log_in") AND arguments.include_user_log_in NEQ true>
					AND u.id != #user_id#
					</cfif>
					<cfif notify_new_message NEQ "">
					AND u.notify_new_message = <cfqueryparam value="#notify_new_message#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif notify_new_file NEQ "">
					AND u.notify_new_file = <cfqueryparam value="#notify_new_file#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif notify_replace_file NEQ "">
					AND u.notify_replace_file = <cfqueryparam value="#notify_replace_file#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif notify_new_area NEQ "">
					AND u.notify_new_area = <cfqueryparam value="#notify_new_area#" cfsqltype="cf_sql_bit">
					</cfif>
					
					<cfif arguments.notify_new_entry NEQ "">
					AND u.notify_new_entry = <cfqueryparam value="#arguments.notify_new_entry#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_link NEQ "">
					AND u.notify_new_link = <cfqueryparam value="#arguments.notify_new_link#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_news NEQ "">
					AND u.notify_new_news = <cfqueryparam value="#arguments.notify_new_news#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_event NEQ "">
					AND u.notify_new_event = <cfqueryparam value="#arguments.notify_new_event#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_task NEQ "">
					AND u.notify_new_task = <cfqueryparam value="#arguments.notify_new_task#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_consultation NEQ "">
					AND u.notify_new_consultation = <cfqueryparam value="#arguments.notify_new_consultation#" cfsqltype="cf_sql_bit">
					</cfif>

					<cfif arguments.notify_new_image NEQ "">
					AND u.notify_new_image = <cfqueryparam value="#arguments.notify_new_image#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_typology NEQ "">
					AND u.notify_new_typology = <cfqueryparam value="#arguments.notify_new_typology#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_list NEQ "">
					AND u.notify_new_list = <cfqueryparam value="#arguments.notify_new_list#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_form NEQ "">
					AND u.notify_new_form = <cfqueryparam value="#arguments.notify_new_form#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_pubmed NEQ "">
					AND u.notify_new_pubmed = <cfqueryparam value="#arguments.notify_new_pubmed#" cfsqltype="cf_sql_bit">
					</cfif>
					
					<cfif arguments.with_external EQ "false">
					AND u.internal_user = true
					</cfif>;
				</cfquery>
				
				<cfif areaUsersQuery.recordCount GT 0>
						
					<cfloop query="areaUsersQuery">
						<cfinvoke component="UserManager" method="objectUser" returnvariable="user">
							<cfinvokeargument name="id" value="#areaUsersQuery.id#">
							<cfinvokeargument name="email" value="#areaUsersQuery.email#">	
							<cfinvokeargument name="telephone" value="#areaUsersQuery.telephone#">
							<cfinvokeargument name="space_used" value="#areaUsersQuery.space_used#">
							<cfinvokeargument name="number_of_connections" value="#areaUsersQuery.number_of_connections#">
							<cfinvokeargument name="last_connection" value="#areaUsersQuery.last_connection#">
							<cfinvokeargument name="connected" value="#areaUsersQuery.connected#">
							<cfinvokeargument name="session_id" value="#areaUsersQuery.session_id#">
							<cfinvokeargument name="creation_date" value="#areaUsersQuery.creation_date#">
							<cfinvokeargument name="whole_tree_visible" value="#areaUsersQuery.internal_user#">
							<cfinvokeargument name="root_folder_id" value="#areaUsersQuery.root_folder_id#">
							<!---<cfinvokeargument name="general_administrator" value="">--->
							<cfinvokeargument name="family_name" value="#areaUsersQuery.family_name#">
							<cfinvokeargument name="name" value="#areaUsersQuery.name#">
							<cfinvokeargument name="address" value="#areaUsersQuery.address#">
							<cfinvokeargument name="areas_administration" value="">
							<cfinvokeargument name="mobile_phone" value="#areaUsersQuery.mobile_phone#">
							<cfinvokeargument name="telephone_ccode" value="#areaUsersQuery.telephone_ccode#">
							<cfinvokeargument name="mobile_phone_ccode" value="#areaUsersQuery.mobile_phone_ccode#">
							<cfinvokeargument name="image_type" value="#areaUsersQuery.image_type#">
							<cfinvokeargument name="language" value="#areaUsersQuery.language#">
							
							<cfif listFind(areaMembersList, areaUsersQuery.id) GT 0>
								<cfinvokeargument name="area_member" value="1">
							<cfelse>
								<cfinvokeargument name="area_member" value="0">
							</cfif>
							
							<cfinvokeargument name="return_type" value="object">
						</cfinvoke>
						
						<cfinvoke component="UserManager" method="appendUser" returnvariable="usersArrayUpdated">
							<cfinvokeargument name="usersArray" value="#usersArray#">
							<cfinvokeargument name="objectUser" value="#user#">
						</cfinvoke>
						
						<cfset usersArray = usersArrayUpdated>
					
					</cfloop>
									
				</cfif>	
			
			</cfif>
			
			<cfset response = {usersArray=usersArray, areasArray=areasArray}>--->
			<cfreturn response>
	
	</cffunction>
	
	
	<!--- ---------------------------- getAreaUsersIds ------------------------------- --->
	
	<cffunction name="getAreaUsersIds" returntype="struct" output="false" access="public">
		<cfargument name="area_id" type="string" required="yes">
		<cfargument name="usersList" type="string" required="no" default="">
		<cfargument name="areasArray" type="array" required="yes">
		<!---<cfargument name="include_user_log_in" type="boolean" required="no" default="false">--->
		<cfargument name="get_orientation" type="string" required="no" default="desc"><!---desc/asc/both---><!---both: obtiene los usuarios de las áreas superiores e inferiores--->
        
		<cfset var method = "getAreaUsersIds">
		<cfset var areaMembersList = "">
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="getAreaUsersIds" argumentcollection="#arguments#" returnvariable="response">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<!---
			<cfif arrayFindCustom(areasArray, "#arguments.area_id#") IS 0><!---The area IS NOT searched before--->
				
				<cfquery name="membersQuery" datasource="#client_dsn#">
					SELECT user_id
					FROM #client_abb#_areas_users AS a
					WHERE a.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
				
				<cfif membersQuery.recordCount GT 0>
					
					<cfloop query="membersQuery">
						
						<cfif listFind(usersList, membersQuery.user_id) IS 0>
						
							<cfset usersList = listAppend(usersList, membersQuery.user_id)>
							<cfset areaMembersList = listAppend(areaMembersList, membersQuery.user_id)>
						
						</cfif>
					
					</cfloop>
					
				</cfif>
				
				<cfset ArrayAppend(areasArray,"#arguments.area_id#")>
				
				<!--- Get Descendeant Areas --->
				<cfif arguments.get_orientation EQ "desc" OR arguments.get_orientation EQ "both">
				
					<cfquery datasource="#client_dsn#" name="getDescendantAreas">
						SELECT id AS area_id
						FROM #client_abb#_areas
						WHERE parent_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<cfif getDescendantAreas.recordCount GT 0>
						
						<cfloop query="getDescendantAreas">
							
							<cfinvoke component="UserManager" method="getAreaUsersIds" returnvariable="usersIdsResult">
								<cfinvokeargument name="area_id" value="#getDescendantAreas.area_id#">
								<cfinvokeargument name="usersList" value="#usersList#">
								<cfinvokeargument name="areasArray" value="#areasArray#">
								<!---<cfinvokeargument name="include_user_log_in" value="#include_user_log_in#">--->
								<cfinvokeargument name="get_orientation" value="desc">
														
							</cfinvoke>
							<cfset usersList = usersIdsResult.usersList>
							<cfset areasArray = usersIdsResult.areasArray>
							
						</cfloop>
						
					</cfif>
				</cfif>

				<!--- Get Ascendant Areas --->
				<cfif arguments.get_orientation EQ "asc" OR arguments.get_orientation EQ "both">
				
					<cfquery datasource="#client_dsn#" name="getAscendantAreas">
						SELECT parent_id
						FROM #client_abb#_areas
						WHERE id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<cfif getAscendantAreas.recordCount GT 0 AND isNumeric(getAscendantAreas.parent_id)>
							
						<cfinvoke component="UserManager" method="getAreaUsersIds" returnvariable="usersIdsResult">
							<cfinvokeargument name="area_id" value="#getAscendantAreas.parent_id#">
							<cfinvokeargument name="usersList" value="#usersList#">
							<cfinvokeargument name="areasArray" value="#areasArray#">
							<!---<cfinvokeargument name="include_user_log_in" value="#include_user_log_in#">	--->
							<cfinvokeargument name="get_orientation" value="asc">
									
						</cfinvoke>
						<cfset usersList = usersIdsResult.usersList>
						<cfset areasArray = usersIdsResult.areasArray>
						
					</cfif>
				
				</cfif>
			
			</cfif>
			
			
			<cfset response = {usersList=usersList, areasArray=areasArray, areaMembersList=areaMembersList}>--->
			<cfreturn response>
	
	</cffunction>
	
	
	<!--- ---------------------------- GET USERS -------------------------------- --->
	<!---Devuelve la lista de todos los usuarios según el usuario sea interno o externo--->
	
	<cffunction name="getUsers" returntype="struct" output="false" access="public">
		<cfargument name="xmlUser" type="xml" required="true"/>
		<cfargument name="with_external" type="boolean" required="false" default="true"/>
		<cfargument name="search_text" type="string" required="false"/>
		<cfargument name="order_by" type="string" required="false"/>
		<cfargument name="order_type" type="string" required="false"/>
		<cfargument name="limit" type="numeric" required="false"/>
		
		<cfset var method = "getUsers">

		<cfset var response = structNew()>

		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">
			
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinvoke component="UserManager" method="isRootUser" returnvariable="root_user">
				<cfinvokeargument name="get_user_id" value="#user_id#"> 
			</cfinvoke>	
			
			<cfinvoke component="UserManager" method="isInternalUser" returnvariable="internal_user">
				<cfinvokeargument name="get_user_id" value="#user_id#"> 
			</cfinvoke>			
			
			
			<!---Si el usuario esta en la raiz o whole_tree_visible=true se le pasa la lista de todos los usuarios--->
			<cfif root_user EQ true OR internal_user EQ true>
				
				<cfinvoke component="UserManager" method="getAllUsers" returnvariable="response" argumentcollection="#arguments#">
				</cfinvoke>
				
			<cfelse><!---The user is not root user AND not has whole_tree_visible--->
				
				<cfinvoke component="UserManager" method="getUsersExternal" returnvariable="response" argumentcollection="#arguments#">
				</cfinvoke>
			
			</cfif>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>
	
	
	<!--- ---------------------------- getUsersExternal------------------------------- --->
	
	<!---Obtiene todos los usuarios que tienen acceso a las áreas de un usuario externo que no está en la raiz--->
	
	<cffunction name="getUsersExternal" returntype="struct" output="false" access="public">
		<cfargument name="xmlUser" type="xml" required="true"/>
		<cfargument name="with_external" type="boolean" required="false" default="true"/>
		<cfargument name="search_text" type="string" required="false"/>
		<cfargument name="order_by" type="string" required="false"/>
		<cfargument name="order_type" type="string" required="false"/>
		<cfargument name="limit" type="numeric" required="false"/>
		
		<cfset var method = "getUsersExternal">

		<cfset var response = structNew()>
		
		<!---<cfset var get_orientation = "desc">--->
		<cfset var usersList = "">
		<cfset var areasArray = arrayNew(1)>
		<cfset var usersArray = arrayNew(1)>
		
		<cfset var search_text_re = "">
		
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
					
			<!--- ORDER --->
			<cfinclude template="includes/usersOrderParameters.cfm">
			
			<!---SEARCH--->
			<cfif isDefined("arguments.search_text") AND len(arguments.search_text) GT 0>
				<cfinvoke component="#APPLICATION.coreComponentsPath#/SearchManager" method="generateSearchText" returnvariable="search_text_re">
					<cfinvokeargument name="text" value="#arguments.search_text#">
				</cfinvoke>
			</cfif>
			
			<!---Obtiene las áreas del usuario--->		
			<cfquery name="getUserAreas" datasource="#client_dsn#">
				SELECT area_id
				FROM #client_abb#_areas_users
				WHERE user_id = <cfqueryPARAM value = "#user_id#" CFSQLType = "CF_SQL_varchar">;
			</cfquery>			
			
			
			<cfloop query="getUserAreas">
				
				<!---Obtiene los usuarios de las áreas hacia abajo y hacia arriba--->
				<!---En versiones anteriores de la aplicación sólo se mostraban los usuarios de las áreas inferiores, ya que los usuarios externos sólo podían ver los usuarios que estaban directamente asociados a las áreas a las que tienen acceso y sus áreas inferiores.--->
				<cfinvoke component="UserManager" method="getAreaUsersIds" returnvariable="usersIdsResult">
					<cfinvokeargument name="area_id" value="#getUserAreas.area_id#">
					<cfinvokeargument name="usersList" value="#usersList#">
					<cfinvokeargument name="areasArray" value="#areasArray#">
			
					<cfinvokeargument name="get_orientation" value="both">
				</cfinvoke>

				<cfset usersList = usersIdsResult.usersList>
				<cfset areasArray = usersIdsResult.areasArray>

				<!---Obtiene los usuarios de las áreas hacia arriba--->
				<!---<cfinvoke component="UserManager" method="getAreaUsersIds" returnvariable="usersIdsAscResult">
					<cfinvokeargument name="area_id" value="#getUserAreas.area_id#">
					<cfinvokeargument name="usersList" value="#usersList#">
					<cfinvokeargument name="areasArray" value="#areasAscArray#">
			
					<cfinvokeargument name="get_orientation" value="asc">	
				</cfinvoke>
				
				<cfset usersList = usersIdsAscResult.usersList>
				<cfset areasAscArray = usersIdsAscResult.areasArray>--->
			
			</cfloop>
			
			<!---<cfset xmlUsersResult = "<users>">--->
			
			<cfif listLen(usersList) GT 0>
			
				<cfquery name="membersQuery" datasource="#client_dsn#">
					SELECT id, email, telephone, space_used, number_of_connections, last_connection, connected, session_id, creation_date, internal_user, root_folder_id, family_name, name, address, mobile_phone, telephone_ccode, mobile_phone_ccode, image_type
					FROM #client_abb#_users AS u
					WHERE u.id IN (#usersList#)
					<cfif len(search_text_re) GT 0>
						AND	(u.name REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
						OR u.family_name REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
						OR u.email REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
						OR u.address REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
						OR u.dni REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">)
					</cfif>
					<cfif isDefined("arguments.limit")>
					LIMIT #arguments.limit#
					</cfif>;
				</cfquery>
				
				<cfif membersQuery.recordCount GT 0>
						
					<cfloop query="membersQuery">
						
						<cfinvoke component="UserManager" method="objectUser" returnvariable="objectUser">
							<cfif isDefined("xmlUser.user.xmlAttributes.id")>
								<cfinvokeargument name="id" value="#membersQuery.id#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.email")>
								<cfinvokeargument name="email" value="#membersQuery.email#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.language")>
								<cfinvokeargument name="language" value="#membersQuery.language#">
							</cfif>		
							<cfif isDefined("xmlUser.user.xmlAttributes.password")>
								<cfinvokeargument name="password" value="#membersQuery.password#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.telephone")>
								<cfinvokeargument name="telephone" value="#membersQuery.telephone#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.space_used")>
								<cfinvokeargument name="space_used" value="#membersQuery.space_used#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.number_of_connections")>
								<cfinvokeargument name="number_of_connections" value="#membersQuery.number_of_connections#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.last_connection")>
								<cfinvokeargument name="last_connection" value="#membersQuery.last_connection#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.connected")>
								<cfinvokeargument name="connected" value="#membersQuery.connected#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.session_id")>
								<cfinvokeargument name="session_id" value="#membersQuery.session_id#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.creation_date")>
								<cfinvokeargument name="creation_date" value="#membersQuery.creation_date#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.whole_tree_visible")>
								<cfinvokeargument name="whole_tree_visible" value="#membersQuery.whole_tree_visible#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.root_folder_id")>
								<cfinvokeargument name="root_folder_id" value="#membersQuery.root_folder_id#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.general_administrator")>
								<cfinvokeargument name="general_administrator" value="">
							</cfif>
							<cfif isDefined("xmlUser.user.family_name")>
								<cfinvokeargument name="family_name" value="#membersQuery.family_name#">
							</cfif>
							<cfif isDefined("xmlUser.user.name")>
								<cfinvokeargument name="name" value="#membersQuery.name#">
							</cfif>
							<cfif isDefined("xmlUser.user.address")>
								<cfinvokeargument name="address" value="#membersQuery.address#">
							</cfif>
							<cfif isDefined("xmlUser.user.areas_administration")>
								<cfinvokeargument name="areas_administration" value="">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.mobile_phone")>
								<cfinvokeargument name="mobile_phone" value="#membersQuery.mobile_phone#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.telephone_ccode")>
								<cfinvokeargument name="telephone_ccode" value="#membersQuery.telephone_ccode#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.mobile_phone_ccode")>
								<cfinvokeargument name="mobile_phone_ccode" value="#membersQuery.mobile_phone_ccode#">
							</cfif>
							<cfif isDefined("xmlUser.user.xmlAttributes.image_type")>
								<cfinvokeargument name="image_type" value="#membersQuery.image_type#">
							</cfif>
							
							<cfinvokeargument name="return_type" value="object">
						</cfinvoke>
						
						<!---<cfset xmlUsersResult = xmlUsersResult&xmlUserResult>--->
						
						<cfset arrayAppend(usersArray, objectUser)>

					</cfloop>
									
				</cfif>	
			
			</cfif>
			
			<!---<cfset xmlUsersResult = xmlUsersResult&"</users>">--->
			
			<cfset response = {result=true, users=#usersArray#}><!---usersXml=#xmlUsersResult#--->	

		<cfreturn response>
			
	
	</cffunction>
	
	
	
	<!--- --------------------------- GET ALL USERS -------------------------------- --->
	
	<cffunction name="getAllUsers" returntype="struct" output="false" access="public">
		<cfargument name="xmlUser" type="xml" required="true"/>
		<cfargument name="with_external" type="boolean" required="false" default="true"/>
		<cfargument name="search_text" type="string" required="false"/>
		<cfargument name="order_by" type="string" required="false"/>
		<cfargument name="order_type" type="string" required="false"/>
		
		<cfset var method = "getAllUsers">

		<cfset var response = structNew()>

		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">
			
		<cfset var search_text_re = "">

		<cfset var usersArray = arrayNew(1)>
	
		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<!---<cfxml variable="xmlUser">
				<cfoutput>
					#xmlRequest.request.parameters.user#
				</cfoutput>
			</cfxml>
			<!--- with external users --->
			<cfif isDefined("xmlRequest.request.parameters.with_external")>
				<cfset with_external = xmlRequest.request.parameters.with_external.xmlText>
			<cfelse>
				<cfset with_external = "true">
			</cfif>--->
			
			<!--- ORDER --->
			<cfinclude template="includes/usersOrderParameters.cfm">
			
			<!---SEARCH--->
			<!---<cfif isDefined("xmlRequest.request.parameters.search_text") AND len(xmlRequest.request.parameters.search_text.xmlText) GT 0>
				<cfinvoke component="SearchManager" method="generateSearchText" returnvariable="search_text_re">
					<cfinvokeargument name="text" value="#xmlRequest.request.parameters.search_text.xmlText#">
				</cfinvoke>
			</cfif>--->

			<cfif isDefined("arguments.search_text") AND len(arguments.search_text) GT 0>
				<cfinvoke component="#APPLICATION.coreComponentsPath#/SearchManager" method="generateSearchText" returnvariable="search_text_re">
					<cfinvokeargument name="text" value="#arguments.search_text#">
				</cfinvoke>
			</cfif>

            <cfif isDefined("xmlUser.user.xmlAttributes.space_used") OR isDefined("xmlUser.user.xmlAttributes.number_of_connections")>
                <cfquery name="getTotals" datasource="#client_dsn#">
                    SELECT
                    <cfif isDefined("xmlUser.user.xmlAttributes.space_used")>
                    SUM(space_used) AS total_space_used
                    </cfif>
                    <cfif isDefined("xmlUser.user.xmlAttributes.number_of_connections")>
                    	 <cfif isDefined("xmlUser.user.xmlAttributes.space_used")>
                         ,
                         </cfif>
                    	SUM(number_of_connections) AS total_connections
                    </cfif>
                    FROM #client_abb#_users AS u
                    <cfif with_external EQ "false">
					WHERE u.internal_user = true				
					</cfif>
					
					<cfif len(search_text_re) GT 0>
						<cfif with_external EQ "false">
						AND
						<cfelse>
						WHERE
						</cfif>
						(u.name REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
						OR u.family_name REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
						OR u.email REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
						OR u.address REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
						OR u.dni REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">)
					</cfif>

					<cfif isDefined("arguments.limit")>
					LIMIT #arguments.limit#
					</cfif>;
                </cfquery>
                
            </cfif>
             
            <cfquery name="getAllUsersQuery" datasource="#client_dsn#">
                SELECT id, email, telephone, space_used, number_of_connections, last_connection, connected, session_id, creation_date, internal_user, root_folder_id, family_name, name, address, mobile_phone, telephone_ccode, mobile_phone_ccode, image_type
                FROM #client_abb#_users AS u				
				<cfif with_external EQ "false">
					WHERE u.internal_user = true				
				</cfif>
				<cfif len(search_text_re) GT 0>
					<cfif with_external EQ "false">
					AND
					<cfelse>
					WHERE
					</cfif>
					(u.name REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
					OR u.family_name REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
					OR u.email REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
					OR u.address REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
					OR u.dni REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">)
				</cfif>
                ORDER BY #order_by# #order_type#

                <cfif isDefined("arguments.limit")>
				LIMIT #arguments.limit#
				</cfif>;
            </cfquery>
             		
			<!---<cfset usersXml = '<users'>
			<cfif isDefined("xmlUser.user.xmlAttributes.space_used")>
				<!---Parse total_space_used to megabytes--->
				<cfset total_space_used = getTotals.total_space_used><!---file_size_full is the file_size from database without parse to megabytes--->
				<cfset total_space_used = total_space_used/(1024*1024)>
				<cfset total_space_used = round(total_space_used*100)/100>
				<cfset usersXml = usersXml&' total_space_used="#total_space_used#"'>
			</cfif>
			<cfif isDefined("xmlUser.user.xmlAttributes.number_of_connections")>
				<cfset usersXml = usersXml&' total_connections="#getTotals.total_connections#"'>
			</cfif>--->

			<cfloop query="getAllUsersQuery">
				<cfinvoke component="UserManager" method="objectUser" returnvariable="objectUser">
					<cfif isDefined("xmlUser.user.xmlAttributes.id")>
						<cfinvokeargument name="id" value="#getAllUsersQuery.id#">
					</cfif>
					<cfif isDefined("xmlUser.user.xmlAttributes.email")>
						<cfinvokeargument name="email" value="#getAllUsersQuery.email#">
					</cfif>
					<!---<cfif isDefined("xmlUser.user.xmlAttributes.language")>
						<cfinvokeargument name="language" value="#getAllUsersQuery.language#">
					</cfif>--->
					<cfif isDefined("xmlUser.user.xmlAttributes.telephone")>
						<cfinvokeargument name="telephone" value="#getAllUsersQuery.telephone#">
					</cfif>
					<cfif isDefined("xmlUser.user.xmlAttributes.space_used")>
						<cfinvokeargument name="space_used" value="#getAllUsersQuery.space_used#">
					</cfif>
					<cfif isDefined("xmlUser.user.xmlAttributes.number_of_connections")>
						<cfinvokeargument name="number_of_connections" value="#getAllUsersQuery.number_of_connections#">
					</cfif>
					<cfif isDefined("xmlUser.user.xmlAttributes.last_connection")>
						<cfinvokeargument name="last_connection" value="#getAllUsersQuery.last_connection#">
					</cfif>
					<cfif isDefined("xmlUser.user.xmlAttributes.connected")>
						<cfinvokeargument name="connected" value="#getAllUsersQuery.connected#">
					</cfif>
					<cfif isDefined("xmlUser.user.xmlAttributes.session_id")>
						<cfinvokeargument name="session_id" value="#getAllUsersQuery.session_id#">
					</cfif>
					<cfif isDefined("xmlUser.user.xmlAttributes.creation_date")>
						<cfinvokeargument name="creation_date" value="#getAllUsersQuery.creation_date#">
					</cfif>
					<cfif isDefined("xmlUser.user.xmlAttributes.whole_tree_visible")>
						<cfinvokeargument name="whole_tree_visible" value="#getAllUsersQuery.internal_user#">
					</cfif>
					<cfif isDefined("xmlUser.user.xmlAttributes.root_folder_id")>
						<cfinvokeargument name="root_folder_id" value="#getAllUsersQuery.root_folder_id#">
					</cfif>
					<cfif isDefined("xmlUser.user.xmlAttributes.general_administrator")>
						<cfinvokeargument name="general_administrator" value="">
					</cfif>
					<cfif isDefined("xmlUser.user.family_name")>
						<cfinvokeargument name="family_name" value="#getAllUsersQuery.family_name#">
					</cfif>
					<cfif isDefined("xmlUser.user.name")>
						<cfinvokeargument name="name" value="#getAllUsersQuery.name#">
					</cfif>
					<cfif isDefined("xmlUser.user.address")>
						<cfinvokeargument name="address" value="#getAllUsersQuery.address#">
					</cfif>
					<cfif isDefined("xmlUser.user.areas_administration")>
						<cfinvokeargument name="areas_administration" value="">
					</cfif>
					<cfif isDefined("xmlUser.user.xmlAttributes.mobile_phone")>
						<cfinvokeargument name="mobile_phone" value="#getAllUsersQuery.mobile_phone#">
					</cfif>
					<cfif isDefined("xmlUser.user.user_full_name")>
						<cfinvokeargument name="user_full_name" value="#getAllUsersQuery.family_name# #getAllUsersQuery.name#">
					</cfif>
					<cfif isDefined("xmlUser.user.xmlAttributes.telephone_ccode")>
						<cfinvokeargument name="telephone_ccode" value="#getAllUsersQuery.telephone_ccode#">
					</cfif>
					<cfif isDefined("xmlUser.user.xmlAttributes.mobile_phone_ccode")>
						<cfinvokeargument name="mobile_phone_ccode" value="#getAllUsersQuery.mobile_phone_ccode#">
					</cfif>
					<cfif isDefined("xmlUser.user.xmlAttributes.image_type")>
						<cfinvokeargument name="image_type" value="#getAllUsersQuery.image_type#">
					</cfif>
					
					<cfinvokeargument name="return_type" value="object">
				</cfinvoke>
				
				<cfset arrayAppend(usersArray, objectUser)>
					
			</cfloop>
		
			<cfset response = {result=true, users=#usersArray#}><!---usersXml=#usersXml#--->
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>
	
	
	
	<!--- ---------------------------- GET USERS TO NOTIFY  ------------------------------- --->
	
	<!---
	<cffunction name="getUsersToNotify" returntype="array" output="false" access="public">	
		<cfargument name="request" type="string" required="yes">
	
		<cfset var method = "getUsersToNotify">
		
		<cfset var xmlUser = "">
		<cfset var init_area_id = "">

		<cfset var usersArray = ArrayNew(1)>
		<cfset var areasArray = ArrayNew(1)>
		
		<!---PREFERENCES--->
		<cfset var notify_new_message = "">
		<cfset var notify_new_file = "">
		<cfset var notify_replace_file = "">
		<cfset var notify_new_area = "">
		
		<cfset var notify_new_entry = "">
		<cfset var notify_new_link = "">
		<cfset var notify_new_news = "">
		<cfset var notify_new_event = "">
		<cfset var notify_new_task = "">
		<cfset var notify_new_consultation = "">

		<cfset var notify_new_image = "">
		<cfset var notify_new_typology = "">
		<cfset var notify_new_list = "">
		<cfset var notify_new_form = "">
		<cfset var notify_new_pubmed = "">


		<!---<cfinclude template="includes/initVars.cfm">--->	
			
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfxml variable="xmlUser">
				<cfoutput>
					#xmlRequest.request.parameters.user#
				</cfoutput>
			</cfxml>
			
			<cfset init_area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
			
			
			<!--- ORDER --->
			<cfinclude template="includes/usersOrder.cfm">
			
			
			<cfif isDefined("xmlRequest.request.parameters.preferences")>				
				
				<cfxml variable="xmlPreferences">
					<cfoutput>
					#xmlRequest.request.parameters.preferences#
					</cfoutput>
				</cfxml>
				
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_message")>
					<cfset notify_new_message = xmlPreferences.preferences.xmlAttributes.notify_new_message>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_file")>
					<cfset notify_new_file = xmlPreferences.preferences.xmlAttributes.notify_new_file>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_replace_file")>
					<cfset notify_replace_file = xmlPreferences.preferences.xmlAttributes.notify_replace_file>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_area")>
					<cfset notify_new_area = xmlPreferences.preferences.xmlAttributes.notify_new_area>
				</cfif>
				
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_entry")>
					<cfset notify_new_entry = xmlPreferences.preferences.xmlAttributes.notify_new_entry>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_link")>
					<cfset notify_new_link = xmlPreferences.preferences.xmlAttributes.notify_new_link>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_news")>
					<cfset notify_new_news = xmlPreferences.preferences.xmlAttributes.notify_new_news>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_event")>
					<cfset notify_new_event = xmlPreferences.preferences.xmlAttributes.notify_new_event>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_task")>
					<cfset notify_new_task = xmlPreferences.preferences.xmlAttributes.notify_new_task>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_consultation")>
					<cfset notify_new_consultation = xmlPreferences.preferences.xmlAttributes.notify_new_consultation>
				</cfif>

				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_image")>
					<cfset notify_new_image = xmlPreferences.preferences.xmlAttributes.notify_new_image>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_typology")>
					<cfset notify_new_typology = xmlPreferences.preferences.xmlAttributes.notify_new_typology>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_list")>
					<cfset notify_new_list = xmlPreferences.preferences.xmlAttributes.notify_new_list>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_form")>
					<cfset notify_new_form = xmlPreferences.preferences.xmlAttributes.notify_new_form>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_pubmed")>
					<cfset notify_new_pubmed = xmlPreferences.preferences.xmlAttributes.notify_new_pubmed>
				</cfif>
				
			</cfif>
			
			<cfinvoke component="UserManager" method="getAreaUsers" returnvariable="returnArrays">
				<cfinvokeargument name="area_id" value="#init_area_id#">
				<cfinvokeargument name="areasArray" value="#areasArray#">
				<cfinvokeargument name="include_user_log_in" value="true">
				<cfinvokeargument name="get_orientation" value="asc">
				<cfinvokeargument name="notify_new_message" value="#notify_new_message#">
				<cfinvokeargument name="notify_new_file" value="#notify_new_file#">
				<cfinvokeargument name="notify_replace_file" value="#notify_replace_file#">
				<cfinvokeargument name="notify_new_area" value="#notify_new_area#">
				
				<cfinvokeargument name="notify_new_entry" value="#notify_new_entry#">
				<cfinvokeargument name="notify_new_link" value="#notify_new_link#">	
				<cfinvokeargument name="notify_new_news" value="#notify_new_news#">
				<cfinvokeargument name="notify_new_event" value="#notify_new_event#">
				<cfinvokeargument name="notify_new_task" value="#notify_new_task#">	
				<cfinvokeargument name="notify_new_consultation" value="#notify_new_consultation#">

				<cfinvokeargument name="notify_new_image" value="#notify_new_image#">
				<cfinvokeargument name="notify_new_typology" value="#notify_new_typology#">
				<cfinvokeargument name="notify_new_list" value="#notify_new_list#">
				<cfinvokeargument name="notify_new_form" value="#notify_new_form#">
				<cfinvokeargument name="notify_new_pubmed" value="#notify_new_pubmed#">
			</cfinvoke>
			
			<cfset usersArray = returnArrays.usersArray>
			<!---<cfset areasArray = returnArrays.areasArray>--->

			<cfif arrayLen(usersArray) GT 0>
							
				<cfset usersArray = arrayOfStructsSort(usersArray, "#order_by#", "#order_type#", "textnocase")>
							
			</cfif>
			
		<cfreturn usersArray>
			
	
	</cffunction>--->
	
    
    <!--- ---------------------------- GET USERS TO NOTIFY LISTS ------------------------------- --->
	
	<cffunction name="getUsersToNotifyLists" returntype="struct" output="false" access="public">	
		<cfargument name="request" type="string" required="yes">
	
		<cfset var method = "getUsersToNotifyLists">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="getUsersToNotifyLists" returnvariable="structResponse">
			<cfinvokeargument name="request" value="#arguments.request#"/>

			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<!---
		<cfset var internalUsersEmails = structNew()>
		<cfset var externalUsersEmails = structNew()>
		
		<cfset var internalUsersPhones = structNew()>
		<cfset var externalUsersPhones = structNew()>
		
        <cfset var structResponse = structNew()>
		
        <cfinvoke component="UserManager" method="getUsersToNotify" returnvariable="arrayUsersToNotify">
			<cfinvokeargument name="request" value="#arguments.request#"/>
		</cfinvoke>
		
		<cfloop list="#APPLICATION.languages#" index="curLang">
			
			<cfset internalUsersEmails[curLang] = "">
			<cfset externalUsersEmails[curLang] = "">
			
			<cfset internalUsersPhones[curLang] = "">
			<cfset externalUsersPhones[curLang] = "">
			
		</cfloop>
		
		<cfloop index="curUser" array="#arrayUsersToNotify#">
							
			<cfset curr_val = curUser.email>
			
			<cfset curr_phone = curUser.mobile_phone>
			<cfset curr_phone_ccode = curUser.mobile_phone_ccode>

			<cfif curUser.whole_tree_visible IS true>
				<!---<cfset listInternalUsers = ListAppend(listInternalUsers,curr_val,";")>--->
				<cfset internalUsersEmails[curUser.language] = ListAppend(internalUsersEmails[curUser.language],curr_val,";")>
				<cfif len(curr_phone) GT 0>
					<cfif APPLICATION.identifier EQ "dp">
						<cfset internalUsersPhones[curUser.language] = ListAppend(internalUsersPhones[curUser.language],curr_phone_ccode&curr_phone,";")>
					<cfelse><!---vpnet--->
						<cfset internalUsersPhones[curUser.language]  = ListAppend(internalUsersPhones[curUser.language],curr_phone,";")>
					</cfif>	
				</cfif>
			<cfelse>
				<!---<cfset listExternalUsers = ListAppend(listExternalUsers,curr_val,";")>--->
				<cfset externalUsersEmails[curUser.language] = ListAppend(externalUsersEmails[curUser.language],curr_val,";")>
				<cfif len(curr_phone) GT 0>
					<cfif APPLICATION.identifier EQ "dp">
						<cfset externalUsersPhones[curUser.language] = ListAppend(externalUsersPhones[curUser.language],curr_phone_ccode&curr_phone,";")>
					<cfelse><!---vpnet--->
						<cfset externalUsersPhones[curUser.language] = ListAppend(externalUsersPhones[curUser.language],curr_phone,";")>
					</cfif>
				</cfif>
			</cfif>	
			
		</cfloop>
		
				
        <cfset structResponse.structInternalUsersEmails = internalUsersEmails>
        <cfset structResponse.structExternalUsersEmails = externalUsersEmails>
		
		<cfset structResponse.structInternalUsersPhones = internalUsersPhones>
		<cfset structResponse.structExternalUsersPhones = externalUsersPhones>--->
		
		<cfreturn structResponse>
	
	</cffunction>
	
	
	
	
	
	
	<!--- ---------------------------- GET ALL AREA USERS  ------------------------------- --->

	<cffunction name="getAllAreaUsers" returntype="struct" output="false" access="public">
		<cfargument name="area_id" type="numeric" required="true"/>	
		<cfargument name="xmlUser" type="xml" required="true"/>
		<cfargument name="order_by" type="string" required="false"/>
		<cfargument name="order_type" type="string" required="false"/>

		<cfset var method = "getAllAreaUsers">
		
		<cfset var init_area_id = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
				
		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfset init_area_id = arguments.area_id>
			
			<!--- ORDER --->
			<cfinclude template="includes/usersOrderParameters.cfm">
			
			<cfset areasArray = ArrayNew(1)>
			
			<cfinvoke component="UserManager" method="getAreaUsers" returnvariable="returnArrays">
				<cfinvokeargument name="area_id" value="#init_area_id#">
				<cfinvokeargument name="areasArray" value="#areasArray#">
				<cfinvokeargument name="include_user_log_in" value="true">
				<cfinvokeargument name="get_orientation" value="asc">			
			</cfinvoke>
			
			<cfset usersArray = returnArrays.usersArray>
			<!---<cfset areasArray = returnArrays.areasArray>--->

			<!--- ORDER --->
			<cfif arrayLen(usersArray) GT 0>
				<cfset usersArray = arrayOfStructsSort(usersArray, "#order_by#", "#order_type#", "textnocase")>
			</cfif>
			<!---<cfprocessingdirective suppresswhitespace="yes">
			<cfsavecontent variable="usersXml">
				<users>
					<cfif arrayLen(usersArray) GT 0>
						
						<!--- ORDER --->
						<cfset usersArray = arrayOfStructsSort(usersArray, "#order_by#", "#order_type#", "textnocase")>
						
						<cfloop index="arrUser" array="#usersArray#">
							<cfinvoke component="UserManager" method="objectUser" returnvariable="xmlUserResult">
								<cfif isDefined("xmlUser.user.xmlAttributes.id")>
									<cfinvokeargument name="id" value="#arrUser.id#">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.email")>
									<cfinvokeargument name="email" value="#arrUser.email#">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.language")>
									<cfinvokeargument name="language" value="#arrUser.language#">
								</cfif>		
								<cfif isDefined("xmlUser.user.xmlAttributes.password")>
									<cfinvokeargument name="password" value="#arrUser.password#">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.telephone")>
									<cfinvokeargument name="telephone" value="#arrUser.telephone#">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.space_used")>
									<cfinvokeargument name="space_used" value="#arrUser.space_used#">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.number_of_connections")>
									<cfinvokeargument name="number_of_connections" value="#arrUser.number_of_connections#">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.last_connection")>
									<cfinvokeargument name="last_connection" value="#arrUser.last_connection#">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.connected")>
									<cfinvokeargument name="connected" value="#arrUser.connected#">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.session_id")>
									<cfinvokeargument name="session_id" value="#arrUser.session_id#">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.creation_date")>
									<cfinvokeargument name="creation_date" value="#arrUser.creation_date#">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.whole_tree_visible")>
									<cfinvokeargument name="whole_tree_visible" value="#arrUser.whole_tree_visible#">
								</cfif>
								<!---<cfif isDefined("xmlUser.user.xmlAttributes.root_folder_id")>
									<cfinvokeargument name="root_folder_id" value="#arrUser.root_folder_id#">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.general_administrator")>
									<cfinvokeargument name="general_administrator" value="">
								</cfif>--->
								<cfif isDefined("xmlUser.user.family_name")>
									<cfinvokeargument name="family_name" value="#arrUser.family_name#">
								</cfif>
								<cfif isDefined("xmlUser.user.name")>
									<cfinvokeargument name="name" value="#arrUser.name#">
								</cfif>
								<cfif isDefined("xmlUser.user.address")>
									<cfinvokeargument name="address" value="#arrUser.address#">
								</cfif>
								<cfif isDefined("xmlUser.user.areas_administration")>
									<cfinvokeargument name="areas_administration" value="">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.mobile_phone")>
									<cfinvokeargument name="mobile_phone" value="#arrUser.mobile_phone#">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.mobile_phone_ccode")>
									<cfinvokeargument name="mobile_phone_ccode" value="#arrUser.mobile_phone_ccode#">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.image_type")>
									<cfinvokeargument name="image_type" value="#arrUser.image_type#">
								</cfif>
								<cfif isDefined("xmlUser.user.xmlAttributes.area_member")>
									<cfinvokeargument name="area_member" value="#arrUser.area_member#">
								</cfif>
								
								<cfinvokeargument name="return_type" value="xml">
							</cfinvoke>
							<cfoutput>
							#xmlUserResult#
							</cfoutput>
						</cfloop>
					</cfif>
				</users>
			</cfsavecontent>
			</cfprocessingdirective>--->

			<cfset response = {result=true, users=#usersArray#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>		
				
	</cffunction>
	
	
	
	
	
	

	<!--- ****************************************************************************************** --->
	<!--- ********************************  USER PREFERENCES   ************************************* --->
	<!--- ****************************************************************************************** --->
	
	
	<!--- ----------------------- GET USER PREFERENCES -------------------------------- --->
	<cffunction name="getUserPreferences" returntype="struct" output="false" access="public">		
		
		<cfset var method = "getUserPreferences">

		<cfset var response = structNew()>	
			
		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">
		
			<cfquery name="getUserPreferencesQuery" datasource="#client_dsn#">
				SELECT id, notify_new_message, notify_new_file, notify_replace_file, notify_new_area,
				notify_new_event, notify_new_task
				, notify_delete_file <!---, notify_dissociate_file--->
				<cfif APPLICATION.moduleAreaFilesLite IS true>
				, notify_lock_file
				</cfif>
				<cfif APPLICATION.moduleConsultations IS true>
				, notify_new_consultation
				</cfif>
				<cfif APPLICATION.modulePubMedComments IS true>
				, notify_new_pubmed
				</cfif>
				<cfif APPLICATION.modulefilesWithTables IS true>
				, notify_new_typology	
				</cfif>
				<cfif APPLICATION.moduleLists IS true>
				, notify_new_list
				, notify_new_list_row
				</cfif>
				<cfif APPLICATION.moduleForms IS true>
				, notify_new_form
				, notify_new_form_row
				</cfif>
				<cfif APPLICATION.moduleWeb IS true>
					<cfif APPLICATION.identifier EQ "vpnet">
					, notify_new_link
					</cfif>
					, notify_new_entry, notify_new_news, notify_new_image
				</cfif>

				FROM #client_abb#_users		
				WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;			
			</cfquery>
			
			<cfif getUserPreferencesQuery.recordCount GT 0>

				<cfset response = {result=true, preferences=#getUserPreferencesQuery#}>

			<cfelse><!---The user does not exist--->
				
				<cfset error_code = 204>
				
				<cfthrow errorcode="#error_code#"> 
				
			</cfif>		
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>		
				
	</cffunction>
	
	
	
	<!--- ------------------- UPDATE USER PREFERENCES -------------------------------- --->
	<cffunction name="updateUserPreferences" returntype="struct" output="true" access="public">
		<cfargument name="notify_new_message" type="boolean" required="false" default="false">
		<cfargument name="notify_new_file" type="boolean" required="false" default="false">
		<cfargument name="notify_replace_file" type="boolean" required="false" default="false">
		<cfargument name="notify_new_area" type="boolean" required="false" default="false">
		<cfargument name="notify_new_link" type="boolean" required="false" default="false">
		<cfargument name="notify_new_entry" type="boolean" required="false" default="false">
		<cfargument name="notify_new_news" type="boolean" required="false" default="false">
		<cfargument name="notify_new_event" type="boolean" required="false" default="false">
		<cfargument name="notify_new_task" type="boolean" required="false" default="false">
		<cfargument name="notify_new_consultation" type="boolean" required="false" default="false">

		<cfargument name="notify_new_image" type="boolean" required="false" default="false">
		<cfargument name="notify_new_typology" type="boolean" required="false" default="false">
		<cfargument name="notify_new_list" type="boolean" required="false" default="false">
		<cfargument name="notify_new_list_row" type="boolean" required="false" default="false">
		<cfargument name="notify_new_form" type="boolean" required="false" default="false">
		<cfargument name="notify_new_form_row" type="boolean" required="false" default="false">
		<cfargument name="notify_new_pubmed" type="boolean" required="false" default="false">

		<!--- <cfargument name="notify_dissociate_file" type="boolean" required="false" default="false"> --->
		<cfargument name="notify_delete_file" type="boolean" required="false" default="false">
		<cfargument name="notify_lock_file" type="boolean" required="false" default="false">

		<cfset var method = "updateUserPreferences">
		
		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfquery name="selectQuery" datasource="#client_dsn#">
				SELECT id
				FROM #client_abb#_users
				WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>	
			
			<cfif selectQuery.recordCount GT 0>

				<cfquery name="updateUserPreferences" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET 
					notify_new_message = <cfqueryparam value="#arguments.notify_new_message#" cfsqltype="cf_sql_bit">
					, notify_new_file = <cfqueryparam value="#arguments.notify_new_file#" cfsqltype="cf_sql_bit">
					, notify_replace_file = <cfqueryparam value="#arguments.notify_replace_file#" cfsqltype="cf_sql_bit">
					<!--- , notify_dissociate_file = <cfqueryparam value="#arguments.notify_dissociate_file#" cfsqltype="cf_sql_bit"> --->
					, notify_delete_file = <cfqueryparam value="#arguments.notify_delete_file#" cfsqltype="cf_sql_bit">
					<cfif APPLICATION.moduleAreaFilesLite IS true>
					, notify_lock_file = <cfqueryparam value="#arguments.notify_lock_file#" cfsqltype="cf_sql_bit">
					</cfif>
					, notify_new_area = <cfqueryparam value="#arguments.notify_new_area#" cfsqltype="cf_sql_bit">
					, notify_new_event = <cfqueryparam value="#arguments.notify_new_event#" cfsqltype="cf_sql_bit">
					, notify_new_task = <cfqueryparam value="#arguments.notify_new_task#" cfsqltype="cf_sql_bit">
					<cfif APPLICATION.moduleWeb IS true>
						, notify_new_entry = <cfqueryparam value="#arguments.notify_new_entry#" cfsqltype="cf_sql_bit">
						<cfif APPLICATION.identifier EQ "vpnet">
						, notify_new_link = <cfqueryparam value="#arguments.notify_new_link#" cfsqltype="cf_sql_bit">
						</cfif>
						, notify_new_news = <cfqueryparam value="#arguments.notify_new_news#" cfsqltype="cf_sql_bit">
						, notify_new_image = <cfqueryparam value="#arguments.notify_new_image#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif APPLICATION.moduleConsultations IS true>
					, notify_new_consultation = <cfqueryparam value="#arguments.notify_new_consultation#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif APPLICATION.modulePubMedComments IS true>
					, notify_new_pubmed = <cfqueryparam value="#arguments.notify_new_pubmed#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif APPLICATION.modulefilesWithTables IS true>
					, notify_new_typology = <cfqueryparam value="#arguments.notify_new_typology#" cfsqltype="cf_sql_bit">	
					</cfif>
					<cfif APPLICATION.moduleLists IS true>
					, notify_new_list = <cfqueryparam value="#arguments.notify_new_list#" cfsqltype="cf_sql_bit">
					, notify_new_list_row = <cfqueryparam value="#arguments.notify_new_list_row#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif APPLICATION.moduleForms IS true>
					, notify_new_form = <cfqueryparam value="#arguments.notify_new_form#" cfsqltype="cf_sql_bit">
					, notify_new_form_row = <cfqueryparam value="#arguments.notify_new_form_row#" cfsqltype="cf_sql_bit">
					</cfif>
					WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

			<cfelse><!---The user does not exist--->
				
				<cfset error_code = 204>
				
				<cfthrow errorcode="#error_code#"> 
				
			</cfif>	
			
			<!---<cfxml variable="preferencesXml">
				<cfoutput >
					#xmlRequest.request.parameters.preferences#
				</cfoutput>
			</cfxml>
						
			<cftransaction>
			
			<cfif isDefined("preferencesXml.preferences.XmlAttributes.notify_new_message")>
				<cfquery name="notifyNewMessageQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET notify_new_message = 
						<cfqueryparam value="#preferencesXml.preferences.XmlAttributes.notify_new_message#" cfsqltype="cf_sql_bit">
					WHERE id = <cfqueryparam value="#preferencesXml.preferences.XmlAttributes.user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("preferencesXml.preferences.XmlAttributes.notify_new_file")>
				<cfquery name="notifyNewFileQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET notify_new_file = 
						<cfqueryPARAM value = "#preferencesXml.preferences.XmlAttributes.notify_new_file#" CFSQLType = "CF_SQL_bit">
					WHERE id = <cfqueryPARAM value = "#preferencesXml.preferences.XmlAttributes.user_id#" CFSQLType = "cf_sql_integer">;
				</cfquery>
			</cfif>
			
			<cfif isDefined("preferencesXml.preferences.XmlAttributes.notify_replace_file")>
				<cfquery name="notifyNewFileQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET notify_replace_file = 
						<cfqueryPARAM value = "#preferencesXml.preferences.XmlAttributes.notify_replace_file#" CFSQLType = "CF_SQL_bit">
					WHERE id = <cfqueryPARAM value = "#preferencesXml.preferences.XmlAttributes.user_id#" CFSQLType = "cf_sql_integer">;
				</cfquery>
			</cfif>
            
            <cfif isDefined("preferencesXml.preferences.XmlAttributes.notify_new_area")>
				<cfquery name="notifyNewFileQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET notify_new_area = 
						<cfqueryPARAM value = "#preferencesXml.preferences.XmlAttributes.notify_new_area#" CFSQLType = "CF_SQL_bit">
					WHERE id = <cfqueryPARAM value = "#preferencesXml.preferences.XmlAttributes.user_id#" CFSQLType = "cf_sql_integer">;
				</cfquery>
			</cfif>
			
			<cfif isDefined("preferencesXml.preferences.XmlAttributes.notify_new_entry")>
				<cfquery name="notifyNewEntryQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET notify_new_entry = 
						<cfqueryparam value="#preferencesXml.preferences.XmlAttributes.notify_new_entry#" cfsqltype="cf_sql_bit">
					WHERE id = <cfqueryparam value="#preferencesXml.preferences.XmlAttributes.user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			
			<cfif isDefined("preferencesXml.preferences.XmlAttributes.notify_new_link")>
				<cfquery name="notifyNewLinkQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET notify_new_link = 
						<cfqueryparam value="#preferencesXml.preferences.XmlAttributes.notify_new_link#" cfsqltype="cf_sql_bit">
					WHERE id = <cfqueryparam value="#preferencesXml.preferences.XmlAttributes.user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			
			<cfif isDefined("preferencesXml.preferences.XmlAttributes.notify_new_news")>
				<cfquery name="notifyNewNewsQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET notify_new_news = 
						<cfqueryparam value="#preferencesXml.preferences.XmlAttributes.notify_new_news#" cfsqltype="cf_sql_bit">
					WHERE id = <cfqueryparam value="#preferencesXml.preferences.XmlAttributes.user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			
			<cfif isDefined("preferencesXml.preferences.XmlAttributes.notify_new_event")>
				<cfquery name="notifyNewEventQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET notify_new_event = 
						<cfqueryparam value="#preferencesXml.preferences.XmlAttributes.notify_new_event#" cfsqltype="cf_sql_bit">
					WHERE id = <cfqueryparam value="#preferencesXml.preferences.XmlAttributes.user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			
			<cfif isDefined("preferencesXml.preferences.XmlAttributes.notify_new_task")>
				<cfquery name="notifyNewEventQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_users SET notify_new_task = 
						<cfqueryparam value="#preferencesXml.preferences.XmlAttributes.notify_new_task#" cfsqltype="cf_sql_bit">
					WHERE id = <cfqueryparam value="#preferencesXml.preferences.XmlAttributes.user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			
			<cfif APPLICATION.moduleConsultations IS true>
				<cfif isDefined("preferencesXml.preferences.XmlAttributes.notify_new_consultation")>
					<cfquery name="notifyNewEventQuery" datasource="#client_dsn#">
						UPDATE #client_abb#_users SET notify_new_consultation = 
							<cfqueryparam value="#preferencesXml.preferences.XmlAttributes.notify_new_consultation#" cfsqltype="cf_sql_bit">
						WHERE id = <cfqueryparam value="#preferencesXml.preferences.XmlAttributes.user_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
				</cfif>
			</cfif>
			
			</cftransaction>
			
			<cfquery name="selectQuery" datasource="#client_dsn#">
				SELECT id, notify_new_message, notify_new_file, notify_replace_file, notify_new_area,
				notify_new_entry, notify_new_news, notify_new_event, notify_new_task
				<cfif APPLICATION.moduleConsultations IS true>
				, notify_new_consultation
				</cfif>
				<cfif APPLICATION.identifier EQ "vpnet">
				, notify_new_link
				</cfif>
				FROM #client_abb#_users
				WHERE id = <cfqueryPARAM value = "#preferencesXml.preferences.XmlAttributes.user_id#" CFSQLType="CF_SQL_varchar">;
			</cfquery>	
			
			<cfif selectQuery.recordCount GT 0>
			
				<cfsavecontent variable="xmlResult">
					<cfoutput>
						<preferences user_id="#selectQuery.id#"
							notify_new_message="#selectQuery.notify_new_message#"
							notify_new_file="#selectQuery.notify_new_file#"
							notify_replace_file="#selectQuery.notify_replace_file#"
							notify_new_area="#selectQuery.notify_new_area#"
							
							notify_new_entry="#selectQuery.notify_new_entry#"
							<cfif APPLICATION.identifier EQ "vpnet">
							notify_new_link="#selectQuery.notify_new_link#"
							</cfif>
							notify_new_news="#selectQuery.notify_new_news#"
							notify_new_event="#selectQuery.notify_new_event#"
							notify_new_task="#selectQuery.notify_new_task#"
							<cfif APPLICATION.moduleConsultations IS true>
							notify_new_consultation="#selectQuery.notify_new_consultation#"
							</cfif>/>
					</cfoutput>
				</cfsavecontent>	
			
			<cfelse><!---The user does not exist--->
				
				<cfset error_code = 204>
				
				<cfthrow errorcode="#error_code#"> 
				
			</cfif>	
				
			<cfset xmlResponseContent = xmlResult>--->
		
			<cfinclude template="includes/logRecord.cfm">
			
			<cfset response = {result=true}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>		
		
	</cffunction>
	
		


	<!--- ****************************************************************************************** --->
	<!--- ********************************   USER CONTACTS    ************************************** --->
	<!--- ****************************************************************************************** --->


	<!--- ------------------------- GET USER CONTACTS ------------------------------------- --->
	<cffunction name="getUserContacts" returntype="string" output="true" access="public">
		<cfargument name="request" type="string" required="yes">
		<!---<cfargument name="userFormat" type="string" required="true">--->
		
		<cfset var method = "getUserContacts">
		<cfset var user_format = "">
		<cfset var user_id = "">
<cfset var client_abb = "">
<cfset var user_language = "">
	
<cfset var xmlRequest = "">
<cfset var xmlResponseContent = "">
	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfif isDefined("xmlRequest.request.parameters.contact")>
				<cfxml variable="xmlContact">
					<cfoutput>
						#xmlRequest.request.parameters.contact#
					</cfoutput>
				</cfxml>
			<cfelse><!---if contact is undefined in xml--->
				<cfxml variable="xmlContact">
					 <contact id="" mobile_phone="" email="" mobile_phone_ccode="">
					  <name/>
					  <family_name/>
					  <address/>
					</contact>
				</cfxml>
			</cfif>
						
			<cfset user_format = xmlRequest.request.parameters.user_format.xmlText>
			
			<!--- ORDER --->
			<cfinclude template="includes/usersOrder.cfm">
		
			<cfquery name="getContactsQuery" datasource="#client_dsn#">
				SELECT * 
				FROM #client_abb#_contacts
				WHERE user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
				ORDER BY #order_by# #order_type#;			
			</cfquery>		
			
			<cfif #getContactsQuery.recordCount# GT 0>
				
				<cfif "#user_format#" EQ "true" OR "#user_format#" EQ "1">
					<cfset xmlResult = '<contacts>'>
							<cfloop query="getContactsQuery">
								<cfinvoke component="UserManager" method="objectUser" returnvariable="xmlResultContact">
										<cfif isDefined("xmlContact.contact.xmlAttributes.id")>
											<cfinvokeargument name="id" value="#getContactsQuery.id#">
										</cfif>
										<cfif isDefined("xmlContact.contact.xmlAttributes.email")>
											<cfinvokeargument name="email" value="#getContactsQuery.email#">
										</cfif>
										<cfif isDefined("xmlContact.contact.xmlAttributes.telephone")>
											<cfinvokeargument name="telephone" value="#getContactsQuery.telephone#">
										</cfif>
										<cfif isDefined("xmlContact.contact.xmlAttributes.mobile_phone")>
											<cfinvokeargument name="mobile_phone" value="#getContactsQuery.mobile_phone#">
										</cfif>
										<cfif isDefined("xmlContact.contact.family_name")>
											<cfinvokeargument name="family_name" value="#getContactsQuery.family_name#">
										</cfif>
										<cfif isDefined("xmlContact.contact.name")>
											<cfinvokeargument name="name" value="#getContactsQuery.name#">
										</cfif>
										<cfif isDefined("xmlContact.contact.address")>
											<cfinvokeargument name="address" value="#getContactsQuery.address#">
										</cfif>										
										<cfif isDefined("xmlContact.contact.xmlAttributes.telephone_ccode")>
										<cfinvokeargument name="telephone_ccode" value="#getContactsQuery.telephone_ccode#">
										</cfif>
										<cfif isDefined("xmlContact.contact.xmlAttributes.mobile_phone_ccode")>
											<cfinvokeargument name="mobile_phone_ccode" value="#getContactsQuery.mobile_phone_ccode#">
										</cfif>
										
										<cfinvokeargument name="return_type" value="xml">
								</cfinvoke>
								
								<cfset xmlResult = xmlResult & xmlResultContact>
								
							</cfloop>
					<cfset xmlResult = xmlResult&'</contacts>'>
					
				<cfelse>
					
					<cfset xmlResult = '<contacts>'>
							<cfloop query="getContactsQuery">
							
								<cfinvoke component="ContactManager" method="objectContact" returnvariable="contact">
									<cfif isDefined("xmlContact.contact.xmlAttributes.id")>
										<cfinvokeargument name="id" value="#getContactsQuery.id#">
									</cfif>
									<cfif isDefined("xmlContact.contact.xmlAttributes.email")>
										<cfinvokeargument name="email" value="#getContactsQuery.email#">
									</cfif>
									<cfif isDefined("xmlContact.contact.xmlAttributes.user_id")>
										<cfinvokeargument name="user_id" value="#getContactsQuery.user_id#">
									</cfif>
									<cfif isDefined("xmlContact.contact.xmlAttributes.telephone")>
										<cfinvokeargument name="telephone" value="#getContactsQuery.telephone#">
									</cfif>
									<cfif isDefined("xmlContact.contact.family_name")>
										<cfinvokeargument name="family_name" value="#getContactsQuery.family_name#">
									</cfif>
									<cfif isDefined("xmlContact.contact.name")>
										<cfinvokeargument name="name" value="#getContactsQuery.name#">
									</cfif>
									<cfif isDefined("xmlContact.contact.address")>
										<cfinvokeargument name="address" value="#getContactsQuery.address#">
									</cfif>
									<cfif isDefined("xmlContact.contact.xmlAttributes.mobile_phone")>
										<cfinvokeargument name="mobile_phone" value="#getContactsQuery.mobile_phone#">
									</cfif>
									<cfif isDefined("xmlContact.contact.organization")>
										<cfinvokeargument name="organization" value="#getContactsQuery.organization#">
									</cfif>
									<cfif isDefined("xmlContact.contact.xmlAttributes.telephone_ccode")>
										<cfinvokeargument name="telephone_ccode" value="#getContactsQuery.telephone_ccode#">
									</cfif>
									<cfif isDefined("xmlContact.contact.xmlAttributes.mobile_phone_ccode")>
										<cfinvokeargument name="mobile_phone_ccode" value="#getContactsQuery.mobile_phone_ccode#">
									</cfif>
								</cfinvoke>
						
								<cfinvoke component="ContactManager" method="xmlContact" returnvariable="xmlResultContact">
									<cfinvokeargument name="objectContact" value="#contact#">
								</cfinvoke>
								
								<cfset xmlResult = xmlResult & xmlResultContact>
								
							</cfloop>
					<cfset xmlResult = xmlResult&'</contacts>'>
						
				</cfif>
				
				<cfset xmlResponseContent = xmlResult>
				
			<cfelse>
				<cfsavecontent variable="emptyContacts">
					<contacts/>
				</cfsavecontent>

				<cfset xmlResponseContent = emptyContacts>
			</cfif>
		
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>		
		
	</cffunction>


	<!--- ----------------------- GET USERS AND CONTACTS -------------------------------- --->
	<cffunction name="getUsersAndContacts" returntype="string" output="false" access="public">
	
		<cfset var method = "getUsersAndContacts">
		<cfset var user_id = "">
<cfset var client_abb = "">
<cfset var user_language = "">
	
<cfset var xmlRequest = "">
<cfset var xmlResponseContent = "">
	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
		
			<cfinvoke component="UserManager" method="getUsers" returnvariable="usersResult">				
				<cfinvokeargument name="request" value='<request><parameters><user id="" email="" telephone="" mobile_phone="" telephone_ccode="" mobile_phone_ccode=""><name/><family_name/></user></parameters></request>'>
			</cfinvoke>
			<cfinvoke component="UserManager" method="getUserContacts" returnvariable="contactsResult">
				<cfinvokeargument name="request" value='<request><parameters><user_format><![CDATA[true]]></user_format></parameters></request>'>
				<!---<cfinvokeargument name="userFormat" value="true">--->
			</cfinvoke>
			
			<cfxml variable="xmlUsers">
				<cfoutput>
				#usersResult#
				</cfoutput>
			</cfxml>
			<cfxml variable="xmlContacts">
				<cfoutput>
				#contactsResult#
				</cfoutput>
			</cfxml>
			
			<cfprocessingdirective suppresswhitespace="yes">
			<cfsavecontent variable="xmlResult">
				<cfoutput>
				<users_and_contacts>
					#xmlUsers.response.result.users#
					#xmlContacts.response.result.contacts#
				</users_and_contacts>
				</cfoutput>
			</cfsavecontent>
			</cfprocessingdirective>
			<!---<cfreturn "#xmlResult#">--->
		
			<cfset xmlResponseContent = xmlResult>
		
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>		
		
	</cffunction>
	
	
</cfcomponent>
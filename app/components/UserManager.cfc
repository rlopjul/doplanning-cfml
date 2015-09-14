<!---Copyright Era7 Information Technologies 2007-2014

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

	<cfset typologyTableTypeId = 4>

	<cfset LAST_UPDATE_TYPE_ITEM = "item">

	<cfinclude template="includes/functions.cfm">

	<!--- ----------------------- XML USER -------------------------------- --->

	<cffunction name="xmlUser" returntype="string" output="false" access="public">
		<cfargument name="objectUser" type="struct" required="yes">

		<cfset var method = "xmlUser">

		<cftry>

			<cfprocessingdirective suppresswhitespace="true">
			<cfxml variable="xmlResult"><cfoutput><user
				<cfif len(objectUser.id) NEQ 0>
					id="#objectUser.id#"</cfif>
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
				<cfif APPLICATION.moduleLdapUsers EQ true>
					<cfif len(objectUser.login_ldap) NEQ 0>
						<login_ldap><![CDATA[#objectUser.login_ldap#]]></login_ldap>
					</cfif>
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
				</user></cfoutput></cfxml>
			</cfprocessingdirective>

			<!--- Remove xml declaration --->
			<cfset xmlResult = REReplace( ToString(xmlResult), "<\?xml[^>]*>", "", "one" )>

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

		<cfset var method = "isRootUser">

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<!---<cfinvoke component="AreaManager" method="getRootAreaId" returnvariable="root_area_id">
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
		</cfif>--->

		<cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="isRootUser" returnvariable="root_user">
			<cfinvokeargument name="get_user_id" value="#user_id#">

			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<cfreturn root_user>

	</cffunction>


	<!---  ---------------------CREATE USER------------------------------------ --->

	<cffunction name="createUser" returntype="struct" output="false" access="public">

		<cfargument name="family_name" type="string" required="true">
		<cfargument name="email" type="string" required="false" default="">
		<cfargument name="dni" type="string" required="true">
		<cfargument name="mobile_phone" type="string" required="true">
		<cfargument name="mobile_phone_ccode" type="string" required="true">
		<cfargument name="telephone" type="string" required="true">
		<cfargument name="telephone_ccode" type="string" required="true">
		<cfargument name="address" type="string" required="true">
		<cfargument name="language" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="password_temp" type="string" required="true">
		<cfargument name="files" type="array" required="false"/>
		<cfargument name="hide_not_allowed_areas" type="boolean" default="false">

		<cfargument name="linkedin_url" type="string" required="true">
		<cfargument name="twitter_url" type="string" required="true">
		<cfargument name="start_page" type="string" required="true">
		<cfargument name="information" type="string" required="true">
		<cfargument name="internal_user" type="boolean" required="false" default="false">
		<cfargument name="enabled" type="boolean" required="false" default="false">

		<cfargument name="login_ldap" type="string" required="false">
		<cfargument name="login_diraya" type="string" required="false">
		<cfargument name="perfil_cabecera" type="string" required="false">

		<cfargument name="center_id" type="numeric" required="false">
		<cfargument name="category_id" type="numeric" required="false">
		<cfargument name="service_id" type="numeric" required="false">
		<cfargument name="service" type="string" required="false">
		<cfargument name="other_1" type="string" required="false">
		<cfargument name="other_2" type="string" required="false">

		<cfargument name="typology_id" type="string" required="false">

		<cfset var method = "createUser">

		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">

		<cfset var new_user_id = "">

		<cftry>

			<!---<cfif APPLICATION.moduleLdapUsers NEQ true>---><!---Default User--->

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="includes/checkAdminAccess.cfm">

			<cfif listFind(APPLICATION.languages, arguments.language , ",") IS 0>
				<!--- <cfset arguments.language = APPLICATION.defaultLanguage> --->
				<cfset response = {result=false, message="Idioma no válido"}>
				<cfreturn response>
			</cfif>

			<cfset arguments.email = Trim(arguments.email)>
			<cfset arguments.mobile_phone = Trim(arguments.mobile_phone)>


			<cftransaction>

				<cfif APPLICATION.userEmailRequired IS true OR len(arguments.email) GT 0>

					<!---checkEmail--->
					<cfif len(arguments.email) IS 0 OR NOT isValid("email",arguments.email)>
						<cfset response = {result=false, message="Email incorrecto"}>
						<cfreturn response>
					</cfif>

					<cfquery name="checkEmail" datasource="#client_dsn#">
						SELECT id
						FROM #client_abb#_users
						WHERE email=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">;
					</cfquery>

					<cfif checkEmail.recordCount GT 0><!---User email already used--->
						<!---<cfset error_code = 205>
						<cfthrow errorcode="#error_code#">--->
						<cfset response = {result=false, message="La dirección de email introducida ya está asociada a otro usuario de la aplicación"}>
						<cfreturn response>
					</cfif>

				</cfif>

				<cfif APPLICATION.moduleLdapUsers EQ true>

					<!---if login_ldap is defined--->
					<cfif len(arguments.login_ldap) GT 0>

						<!---Check if login already used--->
						<cfquery name="checkLoginLdap" datasource="#client_dsn#">
							SELECT *
							FROM #client_abb#_users
							WHERE login_ldap=<cfqueryparam value="#arguments.login_ldap#" cfsqltype="cf_sql_varchar">;
						</cfquery>

						<cfif checkLoginLdap.recordCount GT 0><!---User LDAP login already assigned to another user--->
							<!---<cfset error_code = 211>
							<cfthrow errorcode="#error_code#">--->
							<cfset response = {result=false, message="El login introducido ya está asociado a otro usuario de la aplicación"}>
							<cfreturn response>
						</cfif>

						<!---Check if exist in LDAP (ONLY VPNET)--->
						<cfif APPLICATION.identifier EQ "vpnet">

							<cfinvoke component="UserLDAPManager" method="getLDAPUser" returnvariable="xmlResponseUser">
								<cfinvokeargument name="login_ldap" value="#arguments.login_ldap#">
								<cfinvokeargument name="return_type" value="xml">
							</cfinvoke>

						</cfif>

					</cfif>

					<cfif isDefined("arguments.login_diraya") AND len(arguments.login_diraya) GT 0>

						<!---Check if login already used--->
						<cfquery name="checkLoginDiraya" datasource="#client_dsn#">
							SELECT *
							FROM #client_abb#_users
							WHERE login_diraya = <cfqueryparam value="#arguments.login_diraya#" cfsqltype="cf_sql_varchar">;
						</cfquery>

						<cfif checkLoginDiraya.recordCount GT 0><!---User LDAP login already assigned to another user--->
							<!---<cfset error_code = 211>
							<cfthrow errorcode="#error_code#">--->
							<cfset response = {result=false, message="El login de Diraya introducido ya está asociado a otro usuario de la aplicación"}>
							<cfreturn response>
						</cfif>

					</cfif>

				</cfif>

				<!---Insert User in DataBase--->
				<cfquery name="insertUserQuery" datasource="#client_dsn#" result="insertUserResult">
					INSERT INTO #client_abb#_users
					SET email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
					name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
					family_name = <cfqueryparam value="#arguments.family_name#" cfsqltype="cf_sql_varchar">,
					telephone = <cfqueryparam value="#arguments.telephone#" cfsqltype="cf_sql_varchar">,
					address = <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">,
					password = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar">,
					sms_allowed = <cfqueryparam value="false" cfsqltype="cf_sql_bit">,
					mobile_phone = <cfqueryparam value="#arguments.mobile_phone#" cfsqltype="cf_sql_varchar">,
					creation_date = NOW(),
					<cfif len(arguments.telephone_ccode) GT 0>
						telephone_ccode = <cfqueryparam value="#arguments.telephone_ccode#" cfsqltype="cf_sql_integer">,
					<cfelse>
						telephone_ccode = <cfqueryparam null="true" cfsqltype="cf_sql_numeric">,
					</cfif>
					<cfif len(arguments.mobile_phone_ccode) GT 0>
						mobile_phone_ccode = <cfqueryparam value="#arguments.mobile_phone_ccode#" cfsqltype="cf_sql_integer">
					<cfelse>
						mobile_phone_ccode = <cfqueryparam null="true" cfsqltype="cf_sql_numeric">
					</cfif>,
					language = <cfqueryparam value="#arguments.language#" cfsqltype="cf_sql_varchar">,
					dni = <cfqueryparam value="#arguments.dni#" cfsqltype="cf_sql_varchar">,
					hide_not_allowed_areas = <cfqueryparam value="#arguments.hide_not_allowed_areas#" cfsqltype="cf_sql_bit">,
					information = <cfqueryparam value="#arguments.information#" cfsqltype="cf_sql_longvarchar">,
					internal_user = <cfqueryparam value="#arguments.internal_user#" cfsqltype="cf_sql_bit">,
					enabled = <cfqueryparam value="#arguments.enabled#" cfsqltype="cf_sql_bit">,
					linkedin_url = <cfqueryparam value="#arguments.linkedin_url#" cfsqltype="cf_sql_varchar">,
					twitter_url = <cfqueryparam value="#arguments.twitter_url#" cfsqltype="cf_sql_varchar">,
					start_page = <cfqueryparam value="#arguments.start_page#" cfsqltype="cf_sql_varchar">
					<cfif APPLICATION.moduleLdapUsers EQ true>
						<cfif isDefined("arguments.login_ldap") AND len(arguments.login_ldap) GT 0>
						, login_ldap = <cfqueryparam value="#arguments.login_ldap#" cfsqltype="cf_sql_varchar">
						</cfif>
						<cfif isDefined("arguments.login_diraya") AND len(arguments.login_diraya) GT 0>
						, login_diraya = <cfqueryparam value="#arguments.login_diraya#" cfsqltype="cf_sql_varchar">
						</cfif>
					</cfif>
					<cfif isDefined("arguments.perfil_cabecera")>
					, perfil_cabecera = <cfqueryparam value="#arguments.perfil_cabecera#" cfsqltype="cf_sql_varchar">
					</cfif>

					<cfif APPLICATION.identifier EQ "vpnet">
						, center_id = <cfqueryparam value="#arguments.center_id#" cfsqltype="cf_sql_integer">
						, category_id = <cfqueryparam value="#arguments.category_id#" cfsqltype="cf_sql_integer">
						, service_id = <cfqueryparam value="#arguments.service_id#" cfsqltype="cf_sql_integer">
						, service = <cfqueryparam value="#arguments.service#" cfsqltype="cf_sql_varchar">
						, other_1 = <cfqueryparam value="#arguments.other_1#" cfsqltype="cf_sql_varchar">
						, other_2 = <cfqueryparam value="#arguments.other_2#" cfsqltype="cf_sql_varchar">
					</cfif>
					;
				</cfquery>

				<!---Aquí se obtiene el id del usuario insertado en base de datos--->
				<!---<cfset arguments.id = insertUserResult.GENERATED_KEY>--->
				<cfquery name="getLastInsertId" datasource="#client_dsn#">
					SELECT LAST_INSERT_ID() AS last_insert_id FROM #client_abb#_users;
				</cfquery>
				<cfset new_user_id = getLastInsertId.last_insert_id>

				<!---Insert User Root Folder--->
				<cfquery name="insertRootFolderQuery" datasource="#client_dsn#" result="insertRootFolderResult">
					INSERT INTO #client_abb#_folders
					(name, creation_date, user_in_charge, description)
					VALUES(
						'Mis documentos',
						NOW(),
						<cfqueryparam value="#new_user_id#" cfsqltype="cf_sql_integer">,
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
					WHERE id = <cfqueryparam value="#new_user_id#" CFSQLType="cf_sql_integer">;
				</cfquery>


				<!--- setUserTypology --->
				<cfif isDefined("arguments.typology_id") AND isNumeric(arguments.typology_id)>

					<cfinvoke component="UserManager" method="setUserTypology" argumentcollection="#arguments#" returnvariable="setUserTypologyResponse">
						<cfinvokeargument name="update_user_id" value="#new_user_id#"/>
					</cfinvoke>

					<cfif setUserTypologyResponse.result IS false>

						<cfthrow message="#setUserTypologyResponse.message#">

					</cfif>

				</cfif>


			</cftransaction>

			<cfif isDefined("arguments.files")>

				<!---Subida de imagen--->

				<cfinvoke component="#APPLICATION.coreComponentsPath#/UserImageFile" method="uploadUserImage">
					<cfinvokeargument name="files" value="#arguments.files#">
					<cfinvokeargument name="user_id" value="#new_user_id#">
					<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				</cfinvoke>

				<!---FIN subida de imagen--->

			</cfif>


			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="selectUserQuery">
				<cfinvokeargument name="user_id" value="#new_user_id#">
				<cfinvokeargument name="with_ldap" value="#APPLICATION.moduleLdapUsers#">
				<cfif APPLICATION.identifier EQ "vpnet">
					<cfinvokeargument name="with_vpnet" value="true">
				</cfif>

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif selectUserQuery.recordCount IS 0><!---the user does not exist--->

				<cfset error_code = 204>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfif arguments.enabled IS true AND len(arguments.email) GT 0>

				<cfinvoke component="AlertManager" method="newUser">
					<cfinvokeargument name="objectUser" value="#selectUserQuery#">
					<cfinvokeargument name="password_temp" value="#arguments.password_temp#">
				</cfinvoke>

			</cfif>


			<!---
			<cfelse><!---LDAP User--->

				<cfinvoke component="UserLDAPManager" method="createUser" returnvariable="xmlResponseContent">
					<cfinvokeargument name="request" value="#arguments.request#">
				</cfinvoke>

			</cfif>--->

			<cfinclude template="includes/functionEndOnlyLog.cfm">

			<cfset response = {result=true, user_id=new_user_id}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>


	<!---  -----------------------UPDATE USER------------------------------------- --->

	<cffunction name="updateUser" returntype="struct" output="false" access="public">
		<cfargument name="update_user_id" type="numeric" required="true">
		<cfargument name="family_name" type="string" required="true">
		<cfargument name="email" type="string" required="false" default="">
		<cfargument name="dni" type="string" required="true">
		<cfargument name="mobile_phone" type="string" required="true">
		<cfargument name="mobile_phone_ccode" type="string" required="true">
		<cfargument name="telephone" type="string" required="true">
		<cfargument name="telephone_ccode" type="string" required="true">
		<cfargument name="address" type="string" required="true">
		<cfargument name="language" type="string" required="true">
		<cfargument name="password" type="string" required="false">
		<cfargument name="files" type="array" required="false"/>
		<cfargument name="hide_not_allowed_areas" type="boolean" default="false">

		<cfargument name="linkedin_url" type="string" required="true">
		<cfargument name="twitter_url" type="string" required="true">
		<cfargument name="start_page" type="string" required="true">
		<cfargument name="information" type="string" required="false">
		<cfargument name="internal_user" type="boolean" required="false" default="false">
		<cfargument name="enabled" type="boolean" required="false" default="false">

		<cfargument name="login_ldap" type="string" required="false">
		<cfargument name="login_diraya" type="string" required="false">
		<cfargument name="perfil_cabecera" type="string" required="false">

		<cfargument name="center_id" type="numeric" required="false">
		<cfargument name="category_id" type="numeric" required="false">
		<cfargument name="service_id" type="numeric" required="false">
		<cfargument name="service" type="string" required="false">
		<cfargument name="other_1" type="string" required="false">
		<cfargument name="other_2" type="string" required="false">

		<cfargument name="adminFields" type="boolean" required="false" default="false">


		<cfset var method = "updateUser">

		<cfset var response = structNew()>

		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfif arguments.update_user_id NEQ SESSION.user_id>
				<cfinclude template="includes/checkAdminAccess.cfm">
			</cfif>

			<cfinvoke component="UserManager" method="getUser" returnvariable="userQuery">
				<cfinvokeargument name="get_user_id" value="#arguments.update_user_id#">
				<cfinvokeargument name="return_type" value="query"/>
			</cfinvoke>

			<cfif APPLICATION.userEmailRequired IS true OR len(arguments.email) GT 0>

				<!---checkEmail--->
				<cfif len(arguments.email) IS 0 OR NOT isValid("email", Trim(arguments.email))>
					<cfthrow message="Email incorrecto"/>
				</cfif>

				<cfquery name="checkEmail" datasource="#client_dsn#">
					SELECT id
					FROM #client_abb#_users
					WHERE email = <cfqueryparam value="#Trim(arguments.email)#" cfsqltype="cf_sql_varchar">;
				</cfquery>

				<cfif checkEmail.recordCount GT 0><!---User email already used--->

					<cfif checkEmail.id NEQ arguments.update_user_id><!---This user is not the user who has this email--->
						<cfset response = {result=false, message="La dirección de email introducida ya está asociada a otro usuario de la aplicación"}>

						<cfreturn response>
					</cfif>

				</cfif>

			</cfif>

			<cftransaction>

				<cfquery name="updateUser" datasource="#client_dsn#">
					UPDATE #client_abb#_users
					SET email = <cfqueryparam value="#Trim(arguments.email)#" cfsqltype="cf_sql_varchar">,
					name = <cfqueryparam value = "#arguments.name#" cfsqltype="cf_sql_varchar">,
					family_name = <cfqueryparam value = "#arguments.family_name#" cfsqltype="cf_sql_varchar">,
					address = <cfqueryparam value = "#arguments.address#" cfsqltype="cf_sql_varchar">,
					telephone = <cfqueryparam value = "#arguments.telephone#" cfsqltype="cf_sql_varchar">,
					mobile_phone = <cfqueryparam value = "#arguments.mobile_phone#" cfsqltype="cf_sql_varchar">,
					telephone_ccode = <cfqueryparam value = "#arguments.telephone_ccode#" cfsqltype="cf_sql_integer">,
					mobile_phone_ccode = <cfqueryparam value = "#arguments.mobile_phone_ccode#" cfsqltype="cf_sql_integer">,
					dni = <cfqueryparam value="#arguments.dni#" cfsqltype="cf_sql_varchar">,
					hide_not_allowed_areas = <cfqueryparam value="#arguments.hide_not_allowed_areas#" cfsqltype="cf_sql_bit">,
					linkedin_url = <cfqueryparam value="#arguments.linkedin_url#" cfsqltype="cf_sql_varchar">,
					twitter_url = <cfqueryparam value="#arguments.twitter_url#" cfsqltype="cf_sql_varchar">,
					start_page = <cfqueryparam value="#arguments.start_page#" cfsqltype="cf_sql_varchar">,
					last_update_date = NOW(),
					last_update_user_id = <cfqueryparam value="#SESSION.user_id#" cfsqltype="cf_sql_integer">,
					last_update_type = <cfqueryparam value="#LAST_UPDATE_TYPE_ITEM#" cfsqltype="cf_sql_varchar">
					<cfif isDefined("arguments.password") AND len(arguments.password) GT 0>
						, password = <cfqueryparam value = "#arguments.password#" cfsqltype="cf_sql_varchar">
					</cfif>
					<cfif APPLICATION.moduleLdapUsers EQ true>
						<cfif isDefined("arguments.login_ldap")>
							, login_ldap = <cfqueryparam value = "#arguments.login_ldap#" cfsqltype="cf_sql_varchar">
						</cfif>
						<cfif isDefined("arguments.login_diraya")>
							, login_diraya = <cfqueryparam value = "#arguments.login_diraya#" cfsqltype="cf_sql_varchar">
						</cfif>
					</cfif>

					<cfif arguments.adminFields IS true AND SESSION.client_administrator EQ SESSION.user_id>
						, information = <cfqueryparam value="#arguments.information#" cfsqltype="cf_sql_longvarchar">
						, internal_user = <cfqueryparam value="#arguments.internal_user#" cfsqltype="cf_sql_bit">
						, enabled = <cfqueryparam value="#arguments.enabled#" cfsqltype="cf_sql_bit">
						<cfif isDefined("arguments.perfil_cabecera")>
						, perfil_cabecera = <cfqueryparam value="#arguments.perfil_cabecera#" cfsqltype="cf_sql_varchar">
						</cfif>
					</cfif>
					WHERE id = <cfqueryparam value="#arguments.update_user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfif APPLICATION.identifier EQ "vpnet">

					<cfquery name="updateUserOtherData" datasource="#client_dsn#">
						UPDATE #client_abb#_users
						SET center_id = <cfqueryparam value="#arguments.center_id#" cfsqltype="cf_sql_integer">
						SET category_id = <cfqueryparam value="#arguments.category_id#" cfsqltype="cf_sql_integer">
						SET service_id = <cfqueryparam value="#arguments.service_id#" cfsqltype="cf_sql_integer">
						SET service = <cfqueryparam value="#arguments.service#" cfsqltype="cf_sql_varchar">
						SET other_1 = <cfqueryparam value="#arguments.other_1#" cfsqltype="cf_sql_varchar">
						SET other_2 = <cfqueryparam value="#arguments.other_2#" cfsqltype="cf_sql_varchar">
						WHERE id = <cfqueryparam value="#arguments.update_user_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

				</cfif>


				<!--- setUserTypology --->
				<cfif isDefined("arguments.typology_id")>

					<cfif userQuery.typology_id NEQ arguments.typology_id AND isNumeric(userQuery.typology_row_id)><!---File typology was changed--->

						<!--- Delete old row --->
						<cfinvoke component="RowManager" method="deleteRow" returnvariable="deleteRowResponse">
							<cfinvokeargument name="row_id" value="#userQuery.typology_row_id#"/>
							<cfinvokeargument name="table_id" value="#userQuery.typology_id#"/>
							<cfinvokeargument name="tableTypeId" value="#typologyTableTypeId#"/>
						</cfinvoke>

						<cfif deleteRowResponse.result IS false>
							<cfthrow message="#deleteRowResponse.message#">
						</cfif>

					</cfif>

					<cfif isNumeric(arguments.typology_id)><!--- Typology selected --->

						<cfinvoke component="UserManager" method="setUserTypology" argumentcollection="#arguments#" returnvariable="setUserTypologyResponse">
						</cfinvoke>

						<cfif setUserTypologyResponse.result IS false>
							<cfthrow message="#setUserTypologyResponse.message#">
						</cfif>

					<cfelse><!--- Clear user typology --->

						<cfinvoke component="UserManager" method="clearUserTypology" argumentcollection="#arguments#" returnvariable="clearUserTypologyResponse">
						</cfinvoke>

						<cfif clearUserTypologyResponse.result IS false>
							<cfthrow message="#clearUserTypologyResponse.message#">
						</cfif>

					</cfif>

				</cfif>

			</cftransaction>

			<cfif userQuery.hide_not_allowed_areas NEQ arguments.hide_not_allowed_areas OR (arguments.adminFields IS true AND SESSION.client_administrator EQ SESSION.user_id AND userQuery.internal_user NEQ arguments.internal_user)>

				<!--- deleteUserCacheTree --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/CacheQuery" method="deleteUserCacheTree">
					<cfinvokeargument name="user_id" value="#arguments.update_user_id#">
					<cfinvokeargument name="tree_type" value="default">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>

			<cfinvoke component="UserManager" method="updateUserLanguage" returnvariable="updateUserResponse">
				<cfinvokeargument name="update_user_id" value="#arguments.update_user_id#">
				<cfinvokeargument name="language" value="#arguments.language#">
			</cfinvoke>

			<cfif updateUserResponse.result IS false>

				<cfreturn updateUserResponse>

			</cfif>

			<cfif isDefined("arguments.files")>

				<!---Subida de imagen--->

				<cfinvoke component="#APPLICATION.coreComponentsPath#/UserImageFile" method="uploadUserImage">
					<cfinvokeargument name="files" value="#arguments.files#">
					<cfinvokeargument name="user_id" value="#arguments.update_user_id#">
					<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				</cfinvoke>

				<!---FIN subida de imagen--->

			</cfif>

			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, user_id=#arguments.update_user_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>

	<!--------------------------------------------------------------------------------->


	<!---  -----------------------UPDATE USER LANGUAGE------------------------------------- --->

	<cffunction name="updateUserLanguage" returntype="struct" output="false" access="public">
		<cfargument name="update_user_id" type="numeric" required="true">
		<cfargument name="language" type="string" required="true">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfif arguments.update_user_id NEQ SESSION.user_id>
				<cfinclude template="includes/checkAdminAccess.cfm">
			</cfif>

			<cfif listFind(APPLICATION.languages, arguments.language) GT 0>

				<cfquery name="updateUserLanguage" datasource="#client_dsn#">
					UPDATE #client_abb#_users
					SET language = <cfqueryparam value="#arguments.language#" cfsqltype="cf_sql_varchar">,
					last_update_date = NOW(),
					last_update_user_id = <cfqueryparam value="#SESSION.user_id#" cfsqltype="cf_sql_integer">,
					last_update_type = <cfqueryparam value="#LAST_UPDATE_TYPE_ITEM#" cfsqltype="cf_sql_varchar">
					WHERE id = <cfqueryparam value="#arguments.update_user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfif SESSION.user_id EQ arguments.update_user_id>
					<!--- Set language in current user SESSION --->
					<cfset SESSION.user_language = arguments.language>
				</cfif>

				<cfset response = {result=true, user_id=#arguments.update_user_id#}>

			<cfelse><!---The application does not have this language--->

				<cfset error_code = 10000>

				<cfthrow errorcode="#error_code#" message="The application does not have defined this language: #arguments.language#">

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
	</cffunction>


	<!--- ------------------- UPDATE USER PREFERENCES -------------------------------- --->

	<cffunction name="updateUserPreferences" returntype="struct" output="true" access="public">
		<cfargument name="update_user_id" type="numeric" required="false" default="#SESSION.user_id#">

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
		<cfargument name="notify_new_list_view" type="boolean" required="false" default="false">
		<cfargument name="notify_new_form" type="boolean" required="false" default="false">
		<cfargument name="notify_new_form_row" type="boolean" required="false" default="false">
		<cfargument name="notify_new_form_view" type="boolean" required="false" default="false">
		<cfargument name="notify_new_pubmed" type="boolean" required="false" default="false">

		<cfargument name="notify_delete_file" type="boolean" required="false" default="false">
		<cfargument name="notify_lock_file" type="boolean" required="false" default="false">

		<cfargument name="notify_new_user_in_area" type="boolean" required="false" default="false">
		<cfargument name="notify_been_associated_to_area" type="boolean" required="false" default="false">

		<cfargument name="notify_app_news" type="boolean" required="false" default="false">
		<cfargument name="notify_app_features" type="boolean" required="false" default="false">

		<cfargument name="no_notifications" type="boolean" required="false" default="false">

		<cfargument name="notifications_digest_type_id" type="string" required="true">
		<cfargument name="notifications_web_digest_type_id" type="string" required="true">

		<cfset var method = "updateUserPreferences">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfquery name="selectQuery" datasource="#client_dsn#">
				SELECT id
				FROM #client_abb#_users
				WHERE id = <cfqueryparam value="#arguments.update_user_id#" cfsqltype="cf_sql_integer">;
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
					, notify_new_list_view = <cfqueryparam value="#arguments.notify_new_list_view#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif APPLICATION.moduleForms IS true>
					, notify_new_form = <cfqueryparam value="#arguments.notify_new_form#" cfsqltype="cf_sql_bit">
					, notify_new_form_row = <cfqueryparam value="#arguments.notify_new_form_row#" cfsqltype="cf_sql_bit">
					, notify_new_form_view = <cfqueryparam value="#arguments.notify_new_form_view#" cfsqltype="cf_sql_bit">
					</cfif>
					, notify_new_user_in_area = <cfqueryparam value="#arguments.notify_new_user_in_area#" cfsqltype="cf_sql_bit">
					, notify_been_associated_to_area = <cfqueryparam value="#arguments.notify_been_associated_to_area#" cfsqltype="cf_sql_bit">
					, notify_app_news = <cfqueryparam value="#arguments.notify_app_news#" cfsqltype="cf_sql_bit">
					, notify_app_features = <cfqueryparam value="#arguments.notify_app_features#" cfsqltype="cf_sql_bit">
					, no_notifications = <cfqueryparam value="#arguments.no_notifications#" cfsqltype="cf_sql_bit">
					<cfif NOT isNumeric(arguments.notifications_digest_type_id)>
						, notifications_digest_type_id = <cfqueryparam null="true" cfsqltype="cf_sql_integer">
					<cfelse>
						, notifications_digest_type_id = <cfqueryparam value="#arguments.notifications_digest_type_id#" cfsqltype="cf_sql_integer">
					</cfif>
					<cfif NOT isNumeric(arguments.notifications_web_digest_type_id)>
						, notifications_web_digest_type_id = <cfqueryparam null="true" cfsqltype="cf_sql_integer">
					<cfelse>
						, notifications_web_digest_type_id = <cfqueryparam value="#arguments.notifications_web_digest_type_id#" cfsqltype="cf_sql_integer">
					</cfif>
					, last_update_date = NOW()
					, last_update_user_id = <cfqueryparam value="#SESSION.user_id#" cfsqltype="cf_sql_integer">
					, last_update_type = <cfqueryparam value="#LAST_UPDATE_TYPE_ITEM#" cfsqltype="cf_sql_varchar">
					WHERE id = <cfqueryparam value="#arguments.update_user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>


				<!--- deleteUserNotificationsCategoriesDisable --->
				<cfinvoke component="UserManager" method="deleteUserNotificationsCategoriesDisabled">
					<cfinvokeargument name="update_user_id" value="#arguments.update_user_id#">
				</cfinvoke>

				<!--- setUserNotificationsCategoriesDisabled --->
				<cfinvoke component="UserManager" method="setUserNotificationsCategoriesDisabled" argumentcollection="#arguments#">
				</cfinvoke>


			<cfelse><!---The user does not exist--->

				<cfset error_code = 204>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ----------------------------------- deleteUserNotificationsCategoriesDisabled -------------------------------------- --->

	<cffunction name="deleteUserNotificationsCategoriesDisabled" output="false" returntype="void" access="public">
		<cfargument name="update_user_id" type="numeric" required="true">

		<cfset var method = "deleteUserNotificationsCategoriesDisabled">

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfquery datasource="#client_dsn#" name="deleteUserNotificationsCategoriesDisabled">
				DELETE
				FROM `#client_abb#_users_notifications_categories_disabled`
				WHERE user_id = <cfqueryparam value="#arguments.update_user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

	</cffunction>



	<!--- ----------------------------------- setUserNotificationsCategoriesDisabled -------------------------------------- --->

	<cffunction name="setUserNotificationsCategoriesDisabled" output="false" returntype="void" access="public">
		<cfargument name="update_user_id" type="numeric" required="true">

		<cfset var method = "setUserNotificationsCategoriesDisabled">

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
			</cfinvoke>

			<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

			<!--- getAreaItemTypesOptions --->
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItemType" method="getAreaItemTypesOptions" returnvariable="getItemTypesOptionsResponse">
			</cfinvoke>

			<cfset itemsTypesQuery = getItemTypesOptionsResponse.query>

			<cfloop array="#itemTypesArray#" index="itemTypeId">

				<cfset itemTypeName = itemTypesStruct[itemTypeId].name>

				<cfif itemTypeId NEQ 13 AND itemTypeId NEQ 14 AND itemTypeId NEQ 15 AND itemTypeId NEQ 16>

					<cfquery dbtype="query" name="itemTypeQuery">
						SELECT *
						FROM itemsTypesQuery
						WHERE item_type_id = <cfqueryparam value="#itemTypeId#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<cfif itemTypeQuery.recordCount GT 0 AND isNumeric(itemTypeQuery.category_area_id)>

						<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreas" returnvariable="subAreas">
							<cfinvokeargument name="area_id" value="#itemTypeQuery.category_area_id#">
							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

						<cfif subAreas.recordCount GT 0>

							<cfloop query="subAreas">

								<cfif NOT isDefined("arguments.categories_#itemTypeName#_ids") OR ArrayFind(arguments['categories_#itemTypeName#_ids'], subAreas.id) IS 0>

									<cfquery name="addUserCategoryDisabled" datasource="#client_dsn#">
										INSERT INTO `#client_abb#_users_notifications_categories_disabled` (user_id, item_type_id, area_id)
										VALUES ( <cfqueryparam value="#arguments.update_user_id#" cfsqltype="cf_sql_integer">,
											<cfqueryparam value="#itemTypeId#" cfsqltype="cf_sql_integer">,
											<cfqueryparam value="#subAreas.id#" cfsqltype="cf_sql_integer">);
									</cfquery>

								</cfif>

							</cfloop>

						</cfif>

					</cfif>

				</cfif>

			</cfloop>

	</cffunction>



	<!--- ----------------------------------- setUserTypology -------------------------------------- --->

	<cffunction name="setUserTypology" output="false" returntype="struct" access="public">
		<cfargument name="update_user_id" type="numeric" required="true">
		<cfargument name="table_id" type="numeric" required="true"><!---Este parámetro viene incluído junto con el resto de campos de la tabla en el método outputRowFormInputs en RowHtml--->
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="action" type="string" required="true">

		<cfset var method = "setUserTypology">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="RowManager" method="saveRow" argumentcollection="#arguments#" returnvariable="response">
				<cfinvokeargument name="with_transaction" value="false">
			</cfinvoke>

			<cfif response.result IS true AND arguments.action IS "create">

				<cfquery datasource="#client_dsn#" name="setUserTypology">
					UPDATE #client_abb#_users
					SET typology_id = <cfqueryparam value="#response.table_id#" cfsqltype="cf_sql_integer">,
					typology_row_id = <cfqueryparam value="#response.row_id#" cfsqltype="cf_sql_integer">
					WHERE id = <cfqueryparam value="#arguments.update_user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ----------------------------------- clearUserTypology -------------------------------------- --->

	<cffunction name="clearUserTypology" output="false" returntype="struct" access="public">
		<cfargument name="update_user_id" type="numeric" required="true">

		<cfset var method = "clearUserTypology">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfquery datasource="#client_dsn#" name="clearUserTypology">
				UPDATE #client_abb#_users
				SET typology_id = <cfqueryparam null="true" cfsqltype="cf_sql_integer">,
				typology_row_id = <cfqueryparam null="true" cfsqltype="cf_sql_integer">
				WHERE id = <cfqueryparam value="#arguments.update_user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfset response = {result=true, user_id=#arguments.update_user_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>




	<!--- ----------------------- DELETE USER -------------------------------- --->

	<cffunction name="deleteUser" returntype="struct" output="false" access="public">
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

				<cftransaction>

					<!---REMOVE USER FROM AREAS IN CHARGE--->
					<!---Se quita al usuario de las áreas que tiene a su cargo y se pone al administrador de la organización--->
					<cfquery name="changeUserAreasInCharge" datasource="#client_dsn#">
						UPDATE #client_abb#_areas
						SET user_in_charge = <cfqueryparam value="#SESSION.client_administrator#" cfsqltype="cf_sql_integer">
						WHERE user_in_charge = <cfqueryparam value="#getUserQuery.id#" cfsqltype="cf_sql_integer">;
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

					<cfif APPLICATION.moduleDPDocuments IS true>

						<!--- -----------------DELETE DPDOCUMENTS ------------------------- --->
						<cfinvoke component="AreaItemManager" method="deleteUserItems">
							<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
							<cfinvokeargument name="itemTypeId" value="20">
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
						<cfinvokeargument name="with_transaction" value="false"/>
					</cfinvoke>

					<cfxml variable="xmlDeleteFolderResult">
						<cfoutput>
						#deleteFolderResult#
						</cfoutput>
					</cfxml>

					<cfif xmlDeleteFolderResult.response.xmlAttributes.status EQ "error"><!---Delete folder failed--->
						<!--- RollBack the transaction --->
						<!---<cfquery name="rollBackTransaction" datasource="#client_dsn#">
							ROLLBACK;
						</cfquery>--->
						<cftransaction action="rollback"/>

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
							<cfinvokeargument name="with_transaction" value="false">
						</cfinvoke>

						<cfif deleteFileResult.result IS false>

							<!--- RollBack the transaction --->
							<!---<cfquery name="rollBackTransaction" datasource="#client_dsn#">
								ROLLBACK;
							</cfquery>--->
							<cftransaction action="rollback"/>

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

				</cftransaction>

				<cfinclude template="includes/functionEndOnlyLog.cfm">

				<cfset response = {result=true, user_id=#arguments.delete_user_id#}>


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
		<cfargument name="send_alert" type="boolean" required="false" default="true">

		<cfset var method = "assignUserToArea">

		<cfset var response = structNew()>

		<cfset var user_id = "">
		<cfset var client_abb = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="includes/checkAreaAdminAccess.cfm">

			<!---checkIfExist--->
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

			<!---<cfquery name="assignUser" datasource="#client_dsn#">
				INSERT INTO #client_abb#_areas_users (area_id, user_id, association_date)
				VALUES(<cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#arguments.add_user_id#" cfsqltype="cf_sql_integer">,
					NOW());
			</cfquery>--->

			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="assignUserToArea">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="user_id" value="#arguments.add_user_id#"/>

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfinvoke component="UserManager" method="getUser" returnvariable="objectUser">
				<cfinvokeargument name="get_user_id" value="#arguments.add_user_id#">
				<cfinvokeargument name="return_type" value="query"/>
			</cfinvoke>

			<cfif arguments.send_alert IS true>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="assignUserToArea">
					<cfinvokeargument name="objectUser" value="#objectUser#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="new_area" value="false">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>


			<!--- deleteUserCacheTree --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/CacheQuery" method="deleteUserCacheTree">
				<cfinvokeargument name="user_id" value="#arguments.add_user_id#">
				<cfinvokeargument name="tree_type" value="default">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
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
		<cfargument name="users_ids" type="string" required="true"/>

		<cfset var method = "assignUsersToArea">

		<cfset var response = structNew()>

		<cfset var cur_user_id = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="includes/checkAreaAdminAccess.cfm">

			<cfloop index="cur_user_id" list="#arguments.users_ids#">

				<cfinvoke component="UserManager" method="assignUserToArea" returnvariable="responseAssignUser">
					<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
					<cfinvokeargument name="add_user_id" value="#cur_user_id#"/>
				</cfinvoke>

				<cfif responseAssignUser.result IS false><!---User assign failed--->

					<cfreturn responseAssignUser>

				</cfif>

			</cfloop>

			<cfinclude template="includes/functionEndOnlyLog.cfm">

			<cfset response = {result=true, area_id=#arguments.area_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>


	<!------------------------ ASSIGN USER TO AREAS-------------------------------------->

	<cffunction name="assignUserToAreas" returntype="struct" output="false" access="public">
		<cfargument name="areas_ids" type="string" required="true"/>
		<cfargument name="add_user_id" type="numeric" required="true"/>

		<cfset var method = "assignUserToAreas">

		<cfset var response = structNew()>

		<cfset var curAreaId = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfloop index="curAreaId" list="#arguments.areas_ids#">

				<cfinvoke component="UserManager" method="assignUserToArea" returnvariable="responseAssignUser">
					<cfinvokeargument name="area_id" value="#curAreaId#"/>
					<cfinvokeargument name="add_user_id" value="#arguments.add_user_id#"/>
				</cfinvoke>

				<cfif responseAssignUser.result IS false><!---User assign failed--->

					<cfreturn responseAssignUser>

				</cfif>

			</cfloop>

			<cfinclude template="includes/functionEndOnlyLog.cfm">

			<cfset response = {result=true, user_id=#arguments.add_user_id#}>

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
					<cfset response = {result=false, message="Este usuario no está asociado directamente a esta área"}>
					<cfreturn response>
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

				<!--- deleteUserCacheTree --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/CacheQuery" method="deleteUserCacheTree">
					<cfinvokeargument name="user_id" value="#arguments.dissociate_user_id#">
					<cfinvokeargument name="tree_type" value="default">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

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


	<!---    --------------------SET AREA ADMINISTRATOR-------------------------------------  --->

	<cffunction name="associateAreaAdministrator" output="false" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="add_user_id" type="numeric" required="true">

		<cfset var method = "associateAreaAdministrator">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="includes/checkAdminAccess.cfm">

			<!---checkIfExist--->
			<cfquery name="checkIfExist" datasource="#client_dsn#">
				SELECT *
				FROM #client_abb#_areas_administrators
				WHERE user_id = <cfqueryparam value="#arguments.add_user_id#" cfsqltype="cf_sql_integer">
				AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif checkIfExist.recordCount GT 0><!---The user already is an administrator of the area  --->
				<!---<cfset error_code = 409>
				<cfthrow errorcode="#error_code#">--->
				<cfset response = {result=false, message="El usuario ya estaba asociado como administrador del área"}>
				<cfreturn response>
			</cfif>

			<cfquery name="getArea" datasource="#client_dsn#">
				SELECT id, name
				FROM #client_abb#_areas AS areas
				WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif getArea.recordCount GT 0>

				<cfquery name="getUser" datasource="#client_dsn#">
					SELECT id, name, family_name
					FROM #client_abb#_users
					WHERE id = <cfqueryparam value="#arguments.add_user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfif getUser.recordCount GT 0>

					<cfquery name="insertAreaAdministratorQuery" datasource="#client_dsn#"  >
						INSERT INTO #client_abb#_areas_administrators
						SET user_id = <cfqueryparam value="#arguments.add_user_id#" cfsqltype="cf_sql_integer">,
						area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<!--- deleteUserCacheTree --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/CacheQuery" method="deleteUserCacheTree">
						<cfinvokeargument name="user_id" value="#arguments.add_user_id#">
						<cfinvokeargument name="tree_type" value="admin">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				<cfelse><!---the user does not exist--->

					<cfset error_code = 204>

					<cfthrow errorcode="#error_code#">

				</cfif>

			<cfelse><!---The area does not exist--->

				<cfset error_code = 401>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfinclude template="includes/functionEndOnlyLog.cfm">

			<cfset response = {result=true, area_id=#arguments.area_id#, user_id=#arguments.add_user_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!--- -----------------------------------------------------------------------  --->



	<!---    --------------------DISSOCIATE AREA ADMINISTRATOR-------------------------------------  --->

	<cffunction name="dissociateAreaAdministrator" output="false" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="dissociate_user_id" type="numeric" required="true">

		<cfset var method = "dissociateAreaAdministrator">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="includes/checkAdminAccess.cfm">

			<cfquery name="getArea" datasource="#client_dsn#">
				SELECT user_in_charge
				FROM #client_abb#_areas AS areas
				WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif getArea.recordCount GT 0>

				<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="isUserAssociatedAsAdministrator" returnvariable="isAdministratorResponse">
					<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
					<cfinvokeargument name="check_user_id" value="#arguments.dissociate_user_id#"/>
				</cfinvoke>

				<cfif isAdministratorResponse.result IS false>
					<cfreturn isAdministratorResponse>
				</cfif>

				<cfif isAdministratorResponse.isUserAdministrator IS false><!--- The user is not associated  --->
					<cfset response = {result=false, message="Este usuario no está asociado directamente a esta área como administrador"}>
					<cfreturn response>
				</cfif>

				<cfquery name="deleteQuery" datasource="#client_dsn#">
					DELETE FROM #client_abb#_areas_administrators
					WHERE user_id = <cfqueryparam value = "#arguments.dissociate_user_id#" cfsqltype="cf_sql_integer">
					AND area_id = <cfqueryparam value = "#arguments.area_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<!--- deleteUserCacheTree --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/CacheQuery" method="deleteUserCacheTree">
					<cfinvokeargument name="user_id" value="#arguments.dissociate_user_id#">
					<cfinvokeargument name="tree_type" value="admin">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			<cfelse><!---The area does not exist--->

				<cfset error_code = 401>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfinclude template="includes/functionEndOnlyLog.cfm">

			<cfset response = {result=true, area_id=#arguments.area_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>


	</cffunction>
	<!--- -----------------------------------------------------------------------  --->



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
				<cfif arguments.format_content EQ "all">
					<cfinvokeargument name="parse_dates" value="true">
				</cfif>
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif selectUserQuery.recordCount GT 0>

				<cfquery name="checkClientAdministrator" datasource="#APPLICATION.dsn#">
					SELECT id
					FROM app_clients
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
								<cfif APPLICATION.moduleLdapDiraya EQ true>
									<cfinvokeargument name="login_diraya" value="#selectUserQuery.login_diraya#">
								</cfif>
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


	<!--- ------------------------------------- getEmptyUser -------------------------------------  --->

	<cffunction name="getEmptyUser" output="false" access="public" returntype="struct">

		<cfset var method = "getEmptyUser">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfquery name="getEmptyUserQuery" datasource="#client_dsn#">
				SELECT *, id AS user_id
				FROM #client_abb#_users
				WHERE id = -1;
			</cfquery>

			<!--- getClient --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			</cfinvoke>

			<!--- generatePassword --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="generatePassword" returnvariable="newPassword">
				<cfinvokeargument name="numberofCharacters" value="6">
			</cfinvoke>

			<cfset queryAddRow(getEmptyUserQuery, 1)>

			<cfset querySetCell(getEmptyUserQuery, "enabled", true)>
			<!---<cfset querySetCell(getEmptyUserQuery, "mobile_phone_ccode", "34")>
			<cfset querySetCell(getEmptyUserQuery, "telephone_ccode", "34")>--->
			<cfset querySetCell(getEmptyUserQuery, "hide_not_allowed_areas", 1)>
			<cfset querySetCell(getEmptyUserQuery, "language", clientQuery.default_language)>

			<cfset queryAddColumn(getEmptyUserQuery, "new_password")>
			<cfset querySetCell(getEmptyUserQuery, "new_password", newPassword)>

			<cfset response = {result=true, user=#getEmptyUserQuery#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>

	<!--- ---------------------------- updateUserDownloadedSpace ------------------------------- --->

	<cffunction name="updateUserDownloadedSpace" access="public">
		<cfargument name="add_space" type="numeric" required="true">

		<cfset var method = "updateUserDownloadedSpace">

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfquery name="updateUserDownloadedSpace" datasource="#client_dsn#">
			UPDATE #client_abb#_users
			SET space_downloaded = space_downloaded+<cfqueryparam value="#add_space#" cfsqltype="cf_sql_integer">
			WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
		</cfquery>

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

		<cfset var method = "getAreaUsers">

		<cfset var access_result = false>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!--- checkAreaAccess --->
			<cfinvoke component="AreaManager" method="canUserAccessToArea" returnvariable="access_result">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>

			<cfif access_result IS NOT true>

				<!--- checkAreaAdminAccess --->
				<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAreaAdminAccess">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="getAreaUsers" argumentcollection="#arguments#" returnvariable="response">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

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
		<cfargument name="users_ids" type="string" required="false">

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

				<cfinvoke component="UserManager" method="getAllUsers" argumentcollection="#arguments#" returnvariable="response">
				</cfinvoke>

			<cfelse><!---The user is not root user AND not has whole_tree_visible--->

				<cfinvoke component="UserManager" method="getUsersExternal" argumentcollection="#arguments#" returnvariable="response">
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
		<!--- <cfargument name="xmlUser" type="xml" required="true"/> --->
		<cfargument name="with_external" type="boolean" required="false" default="true"/>
		<cfargument name="search_text" type="string" required="false"/>
		<cfargument name="order_by" type="string" required="false"/>
		<cfargument name="order_type" type="string" required="false"/>
		<cfargument name="limit" type="numeric" required="false"/>

		<cfset var method = "getUsersExternal">

		<cfset var response = structNew()>

		<!---<cfset var get_orientation = "desc">--->
		<cfset var usersList = "">
		<cfset var usersArray = arrayNew(1)>

		<cfset var search_text_re = "">


			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!---
			<!--- ORDER --->
			<cfinclude template="includes/usersOrderParameters.cfm">

			<!---SEARCH--->
			<cfif isDefined("arguments.search_text") AND len(arguments.search_text) GT 0>
				<cfinvoke component="#APPLICATION.coreComponentsPath#/SearchManager" method="generateSearchText" returnvariable="search_text_re">
					<cfinvokeargument name="text" value="#arguments.search_text#">
				</cfinvoke>
			</cfif>--->

			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="getUserVisibleUsers" returnvariable="getUserVisibleUsers">
				<cfinvokeargument name="user_id" value="#SESSION.user_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset usersList = getUserVisibleUsers.usersList>

			<cfif listLen(usersList) GT 0>

				<cfinvoke component="UserManager" method="getAllUsers" argumentcollection="#arguments#" returnvariable="response">
					<cfinvokeargument name="users_ids" value="#usersList#">
				</cfinvoke>

			<cfelse>

				<cfset response = {result=true, users=#usersArray#}>

			</cfif>


		<cfreturn response>


	</cffunction>



	<!--- --------------------------- GET ALL USERS -------------------------------- --->

	<cffunction name="getAllUsers" returntype="struct" output="false" access="public">
		<cfargument name="xmlUser" type="xml" required="true"/>
		<cfargument name="with_external" type="boolean" required="false" default="true"/>
		<cfargument name="search_text" type="string" required="false"/>
		<cfargument name="order_by" type="string" required="false"/>
		<cfargument name="order_type" type="string" required="false"/>
		<cfargument name="limit" type="numeric" required="false">
		<cfargument name="users_ids" type="string" required="false">

		<cfset var method = "getAllUsers">

		<cfset var response = structNew()>

		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">

		<cfset var search_text_re = "">

		<cfset var usersArray = arrayNew(1)>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!--- ORDER --->
			<cfinclude template="includes/usersOrderParameters.cfm">

			<cfif isDefined("arguments.search_text") AND len(arguments.search_text) GT 0>
				<cfinvoke component="#APPLICATION.coreComponentsPath#/SearchManager" method="generateSearchText" returnvariable="search_text_re">
					<cfinvokeargument name="text" value="#arguments.search_text#">
				</cfinvoke>
			</cfif>

            <!---<cfif isDefined("xmlUser.user.xmlAttributes.space_used") OR isDefined("xmlUser.user.xmlAttributes.number_of_connections")>

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
						OR u.dni REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
						<cfif SESSION.client_abb EQ "hcs">
							OR u.information REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
							OR u.perfil_cabecera REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
						</cfif>)
					</cfif>

					<cfif isDefined("arguments.users_ids")>

						<cfif arguments.with_external EQ false OR len(arguments.search_text_re) GT 0>
							AND
						<cfelse>
							WHERE
						</cfif>
						u.id IN (<cfqueryparam value="#arguments.users_ids#" cfsqltype="cf_sql_varchar" list="true">)

					</cfif>

					<cfif isDefined("arguments.limit")>
					LIMIT #arguments.limit#
					</cfif>;
                </cfquery>

            </cfif>--->

            <!--- getAllUsers --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getAllUsers" argumentcollection="#arguments#" returnvariable="getAllUsersQuery">
				<cfinvokeargument name="search_text_re" value="#search_text_re#">
				<cfinvokeargument name="order_by" value="#order_by#">
				<cfinvokeargument name="order_type" value="#order_type#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="queryToArray" returnvariable="usersArray">
				<cfinvokeargument name="data" value="#getAllUsersQuery#">
			</cfinvoke>

			<cfset response = {result=true, users=#usersArray#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



    <!--- ---------------------------- GET USERS TO NOTIFY LISTS ------------------------------- --->

	<cffunction name="getUsersToNotifyLists" returntype="struct" output="false" access="public">
		<!---<cfargument name="request" type="string" required="yes">--->
		<cfargument name="area_id" type="numeric" required="true"/>

		<cfset var method = "getUsersToNotifyLists">

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="getUsersToNotifyLists" argumentcollection="#arguments#" returnvariable="structResponse">
			<!---<cfinvokeargument name="request" value="#arguments.request#"/>--->

			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

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

			<cfset response = {result=true, users=#usersArray#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ---------------------------- GET ALL AREA ADMINISTRATORS  ------------------------------- --->

	<cffunction name="getAllAreaAdministrators" returntype="struct" output="false" access="public">
		<cfargument name="area_id" type="numeric" required="true"/>
		<cfargument name="xmlUser" type="xml" required="true"/>
		<cfargument name="order_by" type="string" required="false"/>
		<cfargument name="order_type" type="string" required="false"/>

		<cfset var method = "getAllAreaAdministrators">

		<cfset var init_area_id = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfset init_area_id = arguments.area_id>

			<!--- ORDER --->
			<cfinclude template="includes/usersOrderParameters.cfm">

			<cfset areasArray = ArrayNew(1)>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="getAreaAdministrators" returnvariable="returnArrays">
				<cfinvokeargument name="area_id" value="#init_area_id#">
				<cfinvokeargument name="areasArray" value="#areasArray#">
				<cfinvokeargument name="include_user_log_in" value="true">
				<cfinvokeargument name="get_orientation" value="asc">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset usersArray = returnArrays.usersArray>
			<!---<cfset areasArray = returnArrays.areasArray>--->

			<!--- ORDER --->
			<cfif arrayLen(usersArray) GT 0>
				<cfset usersArray = arrayOfStructsSort(usersArray, "#order_by#", "#order_type#", "textnocase")>
			</cfif>

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
		<cfargument name="get_user_id" type="numeric" required="false" default="#SESSION.user_id#">

		<cfset var method = "getUserPreferences">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUserPreferences" returnvariable="getUserPreferencesQuery">
				<cfinvokeargument name="user_id" value="#arguments.get_user_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

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



	<!--- ------------------------------------- exportUsers -------------------------------------  --->

	<cffunction name="exportUsers" output="false" access="public" returntype="struct">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="delimiter" type="string" required="true">
		<cfargument name="ms_excel_compatibility" type="boolean" required="false" default="false">

		<cfset var method = "exportUsers">

		<cfset var response = structNew()>

		<cfset var fieldsNames = "">
		<cfset var fieldsLabels = "">
		<cfset var exportContent = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!--- checkAdminAccess --->
			<cfinclude template="includes/checkAdminAccess.cfm">

			<!--- getAllUsers --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getAllUsers" returnvariable="getAllUsersQuery">
				<cfinvokeargument name="with_external" value="true">
				<cfinvokeargument name="order_by" value="creation_date">
				<cfinvokeargument name="order_type" value="ASC">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif getAllUsersQuery.recordCount GT 0>

				<!--- getUser --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="selectUserQuery">
					<cfinvokeargument name="user_id" value="#SESSION.user_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfset fieldsNames = "email, family_name, name, address, telephone_ccode, telephone, mobile_phone_ccode, mobile_phone, internal_user, enabled, id, creation_date, number_of_connections, last_connection">

				<cfif selectUserQuery.language EQ "es">
					<cfset fieldsLabels = "Email, Nombre, Apellidos, Dirección, Código País Teléfono, Teléfono, Código País Móvil, Móvil, Usuario interno, Activo, ID, Fecha de alta, Nº de conexiones, Última conexión">
				<cfelse>
					<cfset fieldsLabels = "Email, Name, Family name, Address, Phone Country Code, Phone, Mobile Country Code, Mobile, Internal user, Active, ID, Registration date, Number of connections, Last connection">
				</cfif>

				<cfif client_abb EQ "hcs">
					<cfset fieldsNames = listAppend(fieldsNames, "perfil_cabecera")>
					<cfset fieldsLabels = listAppend(fieldsLabels, "Perfil de cabecera")>
				</cfif>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="queryToCSV" returnvariable="exportContent">
					<cfinvokeargument name="query" value="#getAllUsersQuery#">
					<cfinvokeargument name="fields" value="#fieldsNames#">
					<cfinvokeargument name="fieldsLabels" value="#fieldsLabels#">
					<cfinvokeargument name="createHeaderRow" value="true">
					<cfif arguments.delimiter EQ "tab">
						<cfinvokeargument name="delimiter" value="	">
					<cfelse>
						<cfinvokeargument name="delimiter" value="#arguments.delimiter#">
					</cfif>
				</cfinvoke>

				<cfif arguments.ms_excel_compatibility IS true>

					<cfset exportContent = "sep=;#chr(10)#"&exportContent>

				</cfif>

			</cfif>

			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, content=#exportContent#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

				<cfset response = {result=false, message=cfcatch.message}>

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- -------------------------- GET LAST ACTIVITY USERS -------------------------------- --->

	<cffunction name="getLastActivityUsers" returntype="struct" access="public">
		<cfargument name="limit" type="numeric" required="false">

		<cfset var method = "getLastActivityUsers">

		<cfset var response = structNew()>

		<cfset var usersArray = arrayNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="AreaManager" method="getAllUserAreasList" returnvariable="userAreasIds">
				<cfinvokeargument name="get_user_id" value="#SESSION.user_id#">
			</cfinvoke>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="listAllAreaItems" returnvariable="getAreaItemsResult">
				<cfinvokeargument name="areas_ids" value="#userAreasIds#">
				<cfinvokeargument name="limit" value="#arguments.limit#">

				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="withConsultations" value="#APPLICATION.moduleConsultations#">
				<cfinvokeargument name="withPubmedsComments" value="#APPLICATION.modulePubMedComments#">
				<cfinvokeargument name="withLists" value="#APPLICATION.moduleLists#">
				<cfinvokeargument name="withForms" value="#APPLICATION.moduleForms#">
				<cfinvokeargument name="withDPDocuments" value="#APPLICATION.moduleDPDocuments#">

				<cfinvokeargument name="onlyUsers" value="true">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="queryToArray" returnvariable="usersArray">
				<cfinvokeargument name="data" value="#getAreaItemsResult.query#">
			</cfinvoke>

			<cfset response = {result=true, query=#getAreaItemsResult.query#, users=#usersArray#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>


	</cffunction>



</cfcomponent>

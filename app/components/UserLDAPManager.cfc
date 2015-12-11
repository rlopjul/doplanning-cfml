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


</cfcomponent>

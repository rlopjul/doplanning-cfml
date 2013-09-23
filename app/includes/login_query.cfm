<cfif isDefined("FORM.client_abb") AND isDefined("FORM.email") AND isDefined("FORM.password")>
	
	<!--- 
	<cfinvoke component="#APPLICATION.htmlPath#/login/Login" method="loginUser" returnvariable="loginUserResult">
		<cfif isDefined("FORM.encoded")>
		<cfinvokeargument name="encoded" value="#FORM.encoded#">
		</cfif>
		<cfinvokeargument name="email" value="#FORM.email#">
		<cfinvokeargument name="password" value="#FORM.password#">
		<cfinvokeargument name="client_abb" value="#FORM.client_abb#">
		<cfif isDefined("FORM.ldap_id")>
		<cfinvokeargument name="ldap_id" value="#FORM.ldap_id#">
		</cfif>
	</cfinvoke> --->
	
	<cfinvoke component="#APPLICATION.componentsPath#/LoginManager" method="loginUser" returnvariable="loginResponse">
		<cfinvokeargument name="login" value="#FORM.email#"/>
		<cfinvokeargument name="password" value="#FORM.password#"/>
		<cfif isDefined("FORM.encoded")>
		<cfinvokeargument name="password_encoded" value="#FORM.encoded#">
		</cfif>
		<cfinvokeargument name="client_abb" value="#FORM.client_abb#"/>
		<cfif isDefined("FORM.ldap_id")>
			<cfinvokeargument name="ldap_id" value="#FORM.ldap_id#"/>
		</cfif>
	</cfinvoke>
	
	<cfset res = loginResponse.result>

	<cfif res IS true>
		<cfif isDefined("FORM.destination_page")>
			<cflocation url="#FORM.destination_page#" addtoken="no">
		<cfelse>
			<cflocation url="#APPLICATION.path#/html/" addtoken="no">
		</cfif>
	<cfelse>

		<!---<cfif isDefined("URL.logo")>
			<cfset show_logo = URL.logo>
		<cfelse>
			<cfset show_logo = true>
		</cfif>

		<cfif isDefined("URL.banner")>
			<cfset show_banner = URL.banner>
		<cfelse>
			<cfset show_banner = true>
		</cfif>

		<cfif isDefined("URL.help")>
			<cfset show_help = URL.help>
		<cfelse>
			<cfset show_help = true>
		</cfif>

		<cfif isDefined("URL.title")>
			<cfset show_title = URL.title>
		<cfelse>
			<cfset show_title = true>
		</cfif>--->

		<cfset msg = urlEncodedFormat(loginResponse.message)>
		<cflocation url="#CGI.SCRIPT_NAME#?client_abb=#FORM.client_abb#&res=#res#&msg=#URLEncodedFormat(msg)#" addtoken="no"><!---&logo=#show_logo#&banner=#show_banner#&help=#show_help#&title=#show_title#---->
	</cfif>
	
</cfif>
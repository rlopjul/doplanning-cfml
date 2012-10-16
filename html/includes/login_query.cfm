<cfif isDefined("FORM.client_abb") AND isDefined("FORM.email") AND isDefined("FORM.password")>
	
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
	</cfinvoke>
	<cfset res = loginUserResult.result>
	
	
	<cfif res IS true>
		<cfif isDefined("FORM.destination_page")>
			<cflocation url="#FORM.destination_page#" addtoken="no">
		<cfelse>
			<cflocation url="#APPLICATION.path#/html/" addtoken="no">
		</cfif>
	<cfelse>
		<cfset msg = urlEncodedFormat(loginUserResult.message)>
		<cflocation url="#CGI.SCRIPT_NAME#?client_abb=#FORM.client_abb#&res=#res#&msg=#URLEncodedFormat(msg)#" addtoken="no">
	</cfif>
	
</cfif>
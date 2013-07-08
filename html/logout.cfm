<cfif isDefined("SESSION.client_abb")>
	<cfset client_abb = SESSION.client_abb>
</cfif>

<!--- <cfinvoke component="login/Login" method="logOutUser">
</cfinvoke> --->

<cfinvoke component="#APPLICATION.componentsPath#/LoginManager" method="logOutUser" returnvariable="logOutResponse">
</cfinvoke>

<cfif logOutResponse.result IS true>

	<cfif isDefined("client_abb")>
		<cflocation url="#APPLICATION.htmlPath#/login/?client_abb=#client_abb#" addtoken="no">
	<cfelse>
		<cflocation url="#APPPLICATION.mainUrl#" addtoken="no">
	</cfif>

<cfelse>		

	<cfif isDefined("client_abb")>
		<cfset msg = logOutResponse.message>
		<cflocation url="#APPLICATION.htmlPath#/login/?client_abb=#client_abb#&res=0&msg=#URLEncodedFormat(msg)#" addtoken="no">
	<cfelse>
		<cfoutput>
			#msg#
		</cfoutput>
	</cfif>

</cfif>


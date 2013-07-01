<cfset encrypt_key = "OxiNHGx581234bKxg-aUN_haf">

<cfif isDefined("FORM.client_abb") AND isDefined("FORM.email") AND isDefined("FORM.captcha_text") AND isDefined("FORM.captcha_text_enc")>

	<cfset captcha_text_arg_enc = encrypt(FORM.captcha_text,encrypt_key,"CFMX_COMPAT","HEX")>
			
	<cfif captcha_text_arg_enc EQ FORM.captcha_text_enc>
	
		<cfinvoke component="#APPLICATION.htmlPath#/login/Login" method="generateNewPassword" returnvariable="loginUserResult">
			<cfinvokeargument name="email" value="#FORM.email#">
			<cfinvokeargument name="client_abb" value="#FORM.client_abb#">
			<cfinvokeargument name="language" value="#FORM.language#"/>
		</cfinvoke>
		<cfset res = loginUserResult.result>
		
		<cfset msg = urlEncodedFormat(loginUserResult.message)>
		
		<cfif res IS true>
			<cflocation url="index.cfm?client_abb=#FORM.client_abb#&res=#res#&msg=#URLEncodedFormat(msg)#" addtoken="no">
		<cfelse>
			<cflocation url="#CGI.SCRIPT_NAME#?client_abb=#FORM.client_abb#&res=#res#&msg=#URLEncodedFormat(msg)#" addtoken="no">
		</cfif>
	
	<cfelse>
	
		<cfset msg = urlEncodedFormat("Los números de la imagen no son correctos, inténtelo de nuevo")>
		
		<cflocation url="#CGI.SCRIPT_NAME#?client_abb=#FORM.client_abb#&res=0&msg=#URLEncodedFormat(msg)#" addtoken="no">
	
	</cfif>
	
</cfif>
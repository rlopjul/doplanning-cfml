<!---Comprobar que existen las variables en sesion y si no existen hacer algo (lanzar un error)--->
<cfif isDefined("SESSION.user_id") AND isDefined("SESSION.client_abb") AND isDefined("SESSION.user_language") AND isDefined("SESSION.client_email_support") AND isDefined("SESSION.client_email_from")>
	<cfset user_id = #SESSION.user_id#>
	<cfset client_abb = #SESSION.client_abb#>
	<cfset user_language = #SESSION.user_language#>
	<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>
	
<cfelse><!---Session parameters are undefined--->
				
	<cfset status = "error">
	<cfset error_code = 102>
	
	<cfthrow errorcode="#error_code#">

</cfif>
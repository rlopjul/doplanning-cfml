<cfoutput>

<div class="div_login_form">

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<form action="#CGI.SCRIPT_NAME#" method="post" onsubmit="return codificarForm(this)">
	<noscript>
   	<input name="encoded" type="hidden" value="false" />     
	</noscript>  
	<input name="client_abb" type="hidden" value="#client_abb#" />
	<div class="div_login_input">Usuario:</div>
	<input name="email" type="text" class="input_login" />
	<div class="div_login_input">Contraseña:</div>
	<input name="password" type="password" class="input_login" />
	<cfif len(destination_page) GT 0>
		<input name="destination_page" type="hidden" value="#destination_page#" />
	</cfif>	
	<cfif isDefined("APPLICATION.moduleLdapUsers") AND APPLICATION.moduleLdapUsers EQ "enabled">
	<div class="div_login_input">Identificar con:</div>
	<input type="radio" name="ldap_id" value="default" checked="checked"/>&nbsp;ASNC&nbsp;&nbsp;&nbsp;
	<input type="radio" name="ldap_id" value="diraya" />&nbsp;Diraya
	</cfif>
	<!---<br/><input type="checkbox" name="remember" value="true" />&nbsp;Recordar--->
	<!---<div class="div_login_input">Acceder a versión:</div>
	<input type="radio" name="version_id" value="default" checked="checked"/>&nbsp;Estándar&nbsp;&nbsp;&nbsp
	<input type="radio" name="version_id" value="mobile" />&nbsp;Móvil&nbsp;&nbsp;&nbsp;
	<input type="radio" name="version_id" value="flash" />&nbsp;Flash--->
	<div class="div_login_submit">
	<input name="login" type="submit" class="input_login_submit" value="Entrar" />
	</div>
</form>
</div>
<!---<cfif isDefined("URL.message") AND NOT isNumeric(URL.message)>
	<div class="div_message_login">#URLDecode(URL.message)#</div>
</cfif>--->
</cfoutput>
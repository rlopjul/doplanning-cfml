<cfoutput>

<div class="div_login_form">

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<form action="#CGI.SCRIPT_NAME#" method="post" onsubmit="return codificarForm(this)">
	<noscript>
   	<input name="encoded" type="hidden" value="false" />     
	</noscript>  
	<input name="client_abb" type="hidden" value="#client_abb#" />
	<cfif len(destination_page) GT 0>
		<input name="destination_page" type="hidden" value="#destination_page#" />
	</cfif>	
	
	<cfif APPLICATION.identifier EQ "dp">
	<label for="email" lang="es">Email:</label>
	<cfelse>
	<label for="email" lang="es">Usuario:</label>
	</cfif>
	<input name="email" type="email" id="email" required="true" autofocus="true" class="input-block-level"/>
	<label for="password" lang="es">Contraseña:</label>
	<input name="password" type="password" id="password" required="true" class="input-block-level" />
	
	<cfif isDefined("APPLICATION.moduleLdapUsers") AND APPLICATION.moduleLdapUsers EQ "enabled">
	<label lang="es">Identificar con:</label>
	<input type="radio" name="ldap_id" value="default" checked="checked"/>&nbsp;ASNC&nbsp;&nbsp;&nbsp;
	<input type="radio" name="ldap_id" value="diraya" />&nbsp;Diraya
	</cfif>

	<div style="height:5px;"></div>
	<input name="login" type="submit" class="btn btn-primary" value="Entrar" data-loading-text="Entrar" autocomplete="off" title="Acceder a la aplicación" lang="es"/>
	<!---<button type="submit" class="btn btn-primary" data-loading-text="Enviando">Entrar</button>--->
	
	<cfif APPLICATION.identifier EQ "dp">
	
	<a href="remember_password.cfm?client_abb=#client_abb#" class="btn" title="¿Olvidó su contraseña?" lang="es"><span lang="es">Resetear contraseña</span></a>
	
	</cfif>
</form>
</div>

</cfoutput>
<cfoutput>

<div class="div_login_form">

<cfinclude template="#APPLICATION.corePath#/includes/alert_message.cfm">

<script type="text/javascript">
function codificarForm(form) { 	
	$('.btn-primary').button('loading');
	
	form.password.readonly = true;
	<cfif APPLICATION.moduleLdapUsers IS false>
		var password = form.password.value;
		form.password.value = "";
		var passwordcod = MD5.hex_md5(password);
		form.password.value = passwordcod;
	</cfif>
	return (true);
}
</script>

<form action="#CGI.SCRIPT_NAME#" method="post" onsubmit="return codificarForm(this)">
	
	<cfif APPLICATION.moduleLdapUsers IS true><!--- LDAP --->
		<input name="encoded" type="hidden" value="false" /> 
	<cfelse>
		<noscript>
   		<input name="encoded" type="hidden" value="false" />     
		</noscript>    
	</cfif>  
	<input name="client_abb" type="hidden" value="#client_abb#" />
	<cfif len(destination_page) GT 0>
		<input name="destination_page" type="hidden" value="#destination_page#" />
	</cfif>	
	
	<cfif APPLICATION.moduleLdapUsers NEQ true>
	<label for="email" lang="es">Email:</label>
	<cfelse><!--- LDAP --->
	<label for="email" lang="es">Usuario:</label>
	</cfif>
	<cfif APPLICATION.moduleLdapUsers NEQ true>
		<input name="email" type="email" id="email" required="true" autofocus="true" class="input-block-level"/>
	<cfelse><!--- LDAP --->
		<input name="email" type="text" id="email" required="true" autofocus="true" class="input-block-level"/>
	</cfif>
	<label for="password" lang="es">Contraseña:</label>
	<input name="password" type="password" id="password" required="true" class="input-block-level" />
	
	<cfif APPLICATION.moduleLdapUsers EQ true><!--- LDAP --->
	<small lang="es">Identificar con usuario y contraseña de:</small>

		<cfif APPLICATION.identifier EQ "vpnet">
			<input type="radio" name="ldap_id" value="default" checked="checked"/>&nbsp;ASNC&nbsp;&nbsp;&nbsp;
			<input type="radio" name="ldap_id" value="diraya" />&nbsp;Diraya
		<cfelse>
			<label class="radio" for="ldap_doplanning"> 
				<input type="radio" name="ldap_id" value="doplanning" id="ldap_doplanning" checked="checked" />DoPlanning
			</label>
			<label class="radio" for="ldap_dmsas"> 
				<input type="radio" name="ldap_id" value="dmsas" id="ldap_dmsas" /> DMSAS
			</label>
			<label class="radio" for="ldap_diraya">
				<input type="radio" name="ldap_id" value="diraya" id="ldap_diraya" /> Diraya
			</label>
		</cfif>
	
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
<cfoutput>
  
  <cfinclude template="#APPLICATION.corePath#/includes/alert_message.cfm">
  
  <form id="login_form" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" onsubmit="return codificarForm(this)" class="form-horizontal">
    
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
  
    <div class="form-group">    
      <label for="email" lang="es" class="col-sm-3 control-label"><cfif APPLICATION.moduleLdapUsers NEQ true>Email:<cfelse><!--- LDAP --->Usuario:</cfif></label>
      <div class="col-sm-9">
        <cfif APPLICATION.moduleLdapUsers NEQ true>
        <input name="email" type="email" id="email" required="true" autofocus="true" class="form-control"/>
        <cfelse><!--- LDAP --->
        <input name="email" type="text" id="email" required="true" autofocus="true" class="form-control"/>
        </cfif>
      </div>
    </div>
    
    <div class="form-group">
      <label for="password" lang="es" class="col-sm-3 control-label">Contraseña:</label>
      <div class="col-sm-9">
        <input name="password" type="password" id="password" required="true" class="form-control"/>
      </div>
    </div>
    
    <cfif APPLICATION.moduleLdapUsers EQ true><!--- LDAP --->
    <div class="form-group">
      <div class="col-md-offset-3 col-sm-9">
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
        </div>
    </div>
    </cfif>
    
    <div class="form-group">
        <div class="col-md-offset-3 col-sm-9">
          <input name="login" type="submit" class="btn btn-primary" value="Entrar" data-loading-text="Entrar" autocomplete="off" title="Acceder a la aplicación" lang="es"/>
          <!---<button type="submit" class="btn btn-primary" data-loading-text="Enviando">Entrar</button>--->
        
          <cfif APPLICATION.identifier EQ "dp">
            <a href="remember_password.cfm?client_abb=#client_abb#" title="¿Olvidó su contraseña?" class="btn btn-default" lang="es"><!---<button type="button" class="btn btn-default">--->Resetear contraseña<!---</button>---></a>
          </cfif>
        </div>
    </div>
</form>
  
</cfoutput>

<script type="text/javascript">
	<!--- 
	Esto se ha implementado sin jQuery porque daba problemas en IE ya que en un iframe no se cargan los scripts por restricciones de IE con las cookies
	$(document).ready(function () {

		if (window.self !== window.top) { <!---Is in a frame--->
			$('##login_form').attr('target', '_parent');
			$('##remember_button').attr('target', '_blank');
		}

	});--->

	if (window.self !== window.top) { <!---Is in a frame--->
		document.getElementById('login_form').target = '_parent';
		document.getElementById('remember_button').target = '_blank';
	}

	function codificarForm(form) { 	
		
		form.password.readonly = true;
		<cfif APPLICATION.moduleLdapUsers IS false>
			var password = form.password.value;
			form.password.value = "";
			var passwordcod = MD5.hex_md5(password);
			form.password.value = passwordcod;
		</cfif>

		$('.btn-primary').button('loading');

		return (true);
	}
</script>

<cfinclude template="#APPLICATION.corePath#/includes/login_md5_js.cfm">
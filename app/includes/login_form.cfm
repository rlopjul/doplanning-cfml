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
      <!---<cfif APPLICATION.hideInputLabels IS false>--->
        <label for="email" id="emailLabel" lang="es" class="col-sm-5 col-md-4 control-label" style="color:##458DB8;font-size:22px;font-weight:100;">Email</label>
      <!---<cfelse>
        <label for="email" id="emailLabel" lang="es" class="sr-only">Email:</label>
      </cfif>--->
      <!---<cfif APPLICATION.hideInputLabels IS false>--->
      <div class="col-sm-7 col-md-8">
      <!---<cfelse>
      <div class="col-sm-offset-3 col-sm-9">
      </cfif>--->        <cfif APPLICATION.moduleLdapUsers NEQ true>
        <input name="email" type="email" id="email" required autofocus class="form-control" lang="es"/>
        <cfelse><!--- LDAP --->
        <input name="email" type="text" id="email" required autofocus class="form-control" lang="es"/>
        </cfif>
      </div>
    </div>

    <div class="form-group">

      <!---<cfif APPLICATION.hideInputLabels IS false>--->
        <label for="password" lang="es" class="col-sm-5 col-md-4 control-label" style="color:##458DB8;font-size:22px;font-weight:100;">Contraseña</label>
      <!---<cfelse>
        <label for="password" lang="es" class="sr-only">Contraseña:</label>
      </cfif>--->

      <!---<cfif APPLICATION.hideInputLabels IS false>--->
      <div class="col-sm-7 col-md-8">
      <!---<cfelse>
      <div class="col-sm-offset-3 col-sm-9">
      </cfif>--->
        <input name="password" type="password" id="password" required class="form-control" lang="es"/>
      </div>
    </div>

    <cfif APPLICATION.moduleLdapUsers EQ true><!--- LDAP --->
    <div class="form-group">

      <div class="col-sm-5 col-md-4">

      </div>
      <div class="col-sm-7 col-md-8">

        <small lang="es">Identificar con usuario y contraseña de:</small>

        <cfif client_abb EQ "omars" OR client_abb EQ "era7_fibao">
          <div class="radio">
            <label for="ldap_hvn">
              <input type="radio" name="ldap_id" value="hvn" id="ldap_hvn" onclick="onLdapChange(this)" checked="checked" /> Hospital / DMSAS <cfif client_abb EQ "omars">/ Web OMARS</cfif>
            </label>
          </div>
          <!---<div class="radio">
            <label for="ldap_dmsas_hvn">
              <input type="radio" name="ldap_id" value="dmsas_hvn" id="ldap_dmsas_hvn" onclick="onLdapChange(this)" /> #APPLICATION.ldapName#
            </label>
          </div>--->
        </cfif>

        <cfif APPLICATION.identifier EQ "vpnet">
          <div class="radio">
            <label for="ldap_asnc">
              <input type="radio" name="ldap_id" value="asnc" id="ldap_asnc" onclick="onLdapChange(this)" checked="checked"/> ASNC
            </label>
          </div>
          <!--- <input type="radio" name="ldap_id" value="diraya" />&nbsp;Diraya --->
        <cfelse>
          <div class="radio">
            <label for="ldap_doplanning">
              <input type="radio" name="ldap_id" value="doplanning" id="ldap_doplanning" onclick="onLdapChange(this)" <cfif client_abb NEQ "omars" AND client_abb NEQ "era7_fibao">checked="checked"</cfif> /> DoPlanning <cfif client_abb EQ "omars" OR client_abb EQ "era7_fibao">(email)</cfif>
            </label>
          </div>
        </cfif>

        <cfif client_abb EQ "agsna">
          <div class="radio">
            <label for="ldap_dmsas">
              <input type="radio" name="ldap_id" value="dmsas" id="ldap_dmsas" onclick="onLdapChange(this)" /> #APPLICATION.ldapName#
            </label>
          </div>
        </cfif>

        <cfif client_abb EQ "hcs">
          <div class="radio">
            <label for="ldap_portalep_hcs">
              <input type="radio" name="ldap_id" value="portalep_hcs" id="ldap_portalep_hcs" onclick="onLdapChange(this)" /> #APPLICATION.ldapName#
            </label>
          </div>
        </cfif>

        <!---<cfif APPLICATION.identifier EQ "vpnet" OR client_abb EQ "agsna">--->
        <cfif APPLICATION.moduleLdapDiraya EQ true>
          <div class="radio">
            <label for="ldap_diraya">
              <input type="radio" name="ldap_id" value="diraya" id="ldap_diraya" onclick="onLdapChange(this)" /> Diraya
            </label>
          </div>
        </cfif>

      </div>
    </div>
    </cfif>

    <div class="form-group">
        <div class="col-sm-offset-3 col-sm-9">
          <div class="pull-right">
            <cfif APPLICATION.identifier EQ "dp">
              <a href="remember_password.cfm?client_abb=#client_abb#" title="¿Olvidó su contraseña?" class="btn btn-default" lang="es"><span lang="es">Resetear contraseña</span></a>
            </cfif>

            <input name="login" type="submit" class="btn btn-info" value="Entrar" data-loading-text="Loading" title="Acceder a la aplicación" lang="es"/>
            <!---<button type="submit" class="btn btn-primary" data-loading-text="Enviando">Entrar</button>--->
          </div>
        </div>
    </div>
</form>


<!---<cfif find("intranet", CGI.SCRIPT_NAME) GT 0>
  <br/>
  IP: #CGI.REMOTE_ADDR#
</cfif>--->
</cfoutput>

<cfinclude template="#APPLICATION.corePath#/includes/login_md5_js.cfm">

<script>

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

  <cfif APPLICATION.moduleLdapUsers EQ true>

  function onLdapChange(radio){
    setSelectedLdap(radio.value);
  }

  function setSelectedLdap(value) {

    if(value == "doplanning")
      document.getElementById('emailLabel').innerHTML = "Email";
    else
      document.getElementById('emailLabel').innerHTML = "Usuario";

  }

  var ldapInputs = document.getElementsByName('ldap_id');

  for(var i = 0; i < ldapInputs.length; i++){
    if(ldapInputs[i].checked){
      ldapValue = ldapInputs[i].value;
      setSelectedLdap(ldapValue);
      break;
    }
  }

  </cfif>

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

</script>

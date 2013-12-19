<!---required var:
encrypt_key (remember_password_query.cfm)
--->

<cfoutput>

<div class="div_login_form">

<cfinclude template="#APPLICATION.corePath#/includes/alert_message.cfm">

<script type="text/javascript">
	function getNewPasswordOnSubmit(form){
		$("##languageInput").val(window.lang.convert("es")); 
		return true;
	}
</script>

<cfform action="#CGI.SCRIPT_NAME#" method="post" onsubmit="return getNewPasswordOnSubmit(this);">

	<input name="client_abb" type="hidden" value="#client_abb#" />
	<input name="language" type="hidden" id="languageInput" value="es" />
	
	<label for="email" lang="es">Email:</label>
	<cfinput name="email" type="text" id="email" autofocus="true" required="true" validate="email" message="Introduzca un email válido" class="form-control" />
	
	<cfset captcha_text = RandRange(100, 999)>
	<cfset captcha_text_enc = encrypt(captcha_text,encrypt_key,"CFMX_COMPAT","HEX")>
	
	<input name="captcha_text_enc" type="hidden" value="#captcha_text_enc#">
	
	<label for="captcha_text" lang="es">Introduzca los siguientes números:</label>
	
	<cfimage action="captcha" difficulty="medium" fontSize="26" width="103" height="45" text="#captcha_text#" fonts="Arial,Verdana,Courier New"><br/>
	
	<cfinput name="captcha_text" id="captcha_text" type="text" value="" required="yes" message="Introduzca los números que aparecen en la imagen" style="margin-top:3px;" class="input-sm">
	
	
	<div style="height:5px;"></div>
	<input name="send" type="submit" class="btn btn-primary" value="Enviar" data-loading-text="Enviar nueva contraseña" autocomplete="off" lang="es"/>
	<a href="index.cfm?client_abb=#client_abb#" class="btn btn-default" lang="es">Cancelar</a>
	
</cfform>

</div>

</cfoutput>
<!---required var:
encrypt_key (remember_password_query.cfm)
--->

<cfoutput>

<div class="div_login_form">

<cfinclude template="#APPLICATION.corePath#/includes/alert_message.cfm">

<script>
	function getNewPasswordOnSubmit(form){
		$("##languageInput").val(window.lang.convert("es")); 
		return true;
	}
</script>

<cfform action="#CGI.SCRIPT_NAME#" method="post" onsubmit="return getNewPasswordOnSubmit(this);" class="form-horizontal">

	<input name="client_abb" type="hidden" value="#client_abb#" />
	<input name="language" type="hidden" id="languageInput" value="es" />
	
	<div class="row">
		<div class="col-sm-2">
			<label for="email" class="control-label" lang="es">Email:</label>
		</div>
		<div class="col-sm-9">
			<input name="email" type="email" id="email" autofocus required class="form-control" />
		</div>
	</div>
	
	<cfset captcha_text = RandRange(100, 999)>
	<cfset captcha_text_enc = encrypt(captcha_text,encrypt_key,"CFMX_COMPAT","HEX")>
	
	<input name="captcha_text_enc" type="hidden" value="#captcha_text_enc#">
	
 	<div class="row">
 		<div class="col-sm-12">
			<label for="captcha_text" class="control-label" lang="es">Introduzca los siguientes números:</label>
		</div>
	</div>

	<div class="row">
		<div class="col-sm-offset-2 col-sm-4">
			<cfimage action="captcha" difficulty="medium" fontSize="26" width="103" height="45" text="#captcha_text#" fonts="Arial,Verdana,Courier New">
		</div>
	</div>

	<div class="row">
		<div class="col-sm-offset-2 col-sm-4">
			<cfinput name="captcha_text" id="captcha_text" type="text" value="" required="yes" message="Introduzca los números que aparecen en la imagen" style="margin-top:3px;" class="form-control">
		</div>
	</div>
	
	<div class="row">
		<div class="col-sm-offset-2 col-sm-10">
			<div style="height:5px;"></div>
			<input name="send" type="submit" class="btn btn-primary" value="Enviar" data-loading-text="Loading" lang="es"/>
			<a href="index.cfm?client_abb=#client_abb#" class="btn btn-default" lang="es">Cancelar</a>
		</div>
	</div>
	
</cfform>

</div>

</cfoutput>
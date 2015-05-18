<!---required var:
encrypt_key (remember_password_query.cfm)
--->

<cfoutput>

<cfinclude template="#APPLICATION.corePath#/includes/alert_message.cfm">

<script>
	function getNewPasswordOnSubmit(form){
		$("##languageInput").val(window.lang.translate("es")); 
		return true;
	}
</script>

<cfform action="#CGI.SCRIPT_NAME#" method="post" onsubmit="return getNewPasswordOnSubmit(this);" class="form-horizontal">

	<input name="client_abb" type="hidden" value="#client_abb#" />
	<input name="language" type="hidden" id="languageInput" value="es" />


    <div class="form-group">
        <label for="email" id="emailLabel" lang="es" class="col-sm-5 col-md-4 control-label" style="color:##458DB8;font-size:22px;font-weight:100;">Email</label>
    
		<div class="col-sm-7 col-md-8">
			<input name="email" type="email" id="email" autofocus required class="form-control" />
		</div>
    </div>
	
	<cfset captcha_text = RandRange(100, 999)>
	<cfset captcha_text_enc = encrypt(captcha_text,encrypt_key,"CFMX_COMPAT","HEX")>

	<input name="captcha_text_enc" type="hidden" value="#captcha_text_enc#">
	
 	<div class="form-group">
 		<div class="col-sm-12">
			<label for="captcha_text" class="control-label" lang="es" style="color:##458DB8;font-size:20px;font-weight:100;">Introduzca los siguientes números</label>
		</div>
	</div>

	<div class="form-group">
		<div class="col-sm-offset-5 col-sm-7 col-sm-offset-4 col-md-8">
			<cfimage action="captcha" difficulty="medium" fontSize="26" width="103" height="45" text="#captcha_text#" fonts="Arial,Verdana,Courier New">
		</div>
	</div>

	<div class="form-group">
		<div class="col-sm-offset-5 col-sm-7 col-sm-offset-4 col-md-8">
			<cfinput name="captcha_text" id="captcha_text" type="text" value="" required="yes" message="Introduzca los números que aparecen en la imagen" style="margin-top:3px;" class="form-control">
		</div>
	</div>
	
	<div class="form-group">
		<div class="col-sm-offset-3 col-sm-9">
			<div style="height:10px;"></div>
			<div class="pull-right">
				<a href="index.cfm?client_abb=#client_abb#" class="btn btn-default">Cancelar</a>
				<input name="send" type="submit" class="btn btn-primary" value="Enviar" data-loading-text="Loading" lang="es"/>
			</div>
		</div>
	</div>
	
</cfform>


</cfoutput>
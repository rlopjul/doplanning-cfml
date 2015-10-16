<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfset return_page = "preferences.cfm">

<cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="getEmptyUser" returnvariable="objectUser">
  <cfinvokeargument name="client_abb" value="#client_abb#">
  <cfinvokeargument name="client_dsn" value="#client_dsn#">
</cfinvoke>

<cfoutput>

<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/vendor/jquery.ui.widget.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.iframe-transport.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.fileupload.js"></script>

<script src="#APPLICATION.path#/jquery/jquery-mask/jquery.mask.min.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-validate/jquery.validate.min.js"></script>

<script>

	/*function setLanguageBeforeSend() {

		var selectedLanguage = $("##language").val();

		window.lang.change(selectedLanguage);

		return true;
	}*/

	function postUserDataForm(requestUrl) {

		showLoadingPage(true);

		//setLanguageBeforeSend();

		var updateUserFormId = "##updateUserData";

		<!---if( $('##file').val().length == 0) { //Sin archivo --->

			$.ajax({
				  type: "POST",
				  url: requestUrl,
				  data: $(updateUserFormId).serialize(),
				  success: function(data, status) {

				  	if(status == "success"){
				  		//alert(JSON.stringify(data));
				  		var message = data.message;
              if(data.result == 1)
				  		    openUrl("#CGI.SCRIPT_NAME#?res="+data.result+"&msg="+encodeURIComponent(message)+"&abb="+data.client_abb);
              else {

                bootbox.alert(message, function() { });

                showLoadingPage(false);

              }

				  	}else
						  openUrl("#CGI.SCRIPT_NAME#?res=0&msg="+encodeURIComponent(status)+"&abb="+data.client_abb);

				  },
				  dataType: "json"
				});

		<!---} else {

			$(updateUserFormId).fileupload('send', {fileInput: $('##file'), url: requestUrl})
				.success(function ( data, status, jqXHR ) {

					if(status == "success"){

						//console.log(jqXHR);

				  		var result = $.parseJSON(data);
				  		var message = result.message;

				  		openUrl("#CGI.SCRIPT_NAME#?res="+result.result+"&msg="+encodeURIComponent(message));

				  	}else
				  		openUrl("#CGI.SCRIPT_NAME#?res=0&msg="+encodeURIComponent(status));

				}).error(function ( data, status )  {

					alert("Error: "+status);

				}).complete(function ( data, status )  { });

		}--->

		return false;

	}


	$(function () {

		<cfinclude template="#APPLICATION.corePath#/includes/jquery_validate_bootstrap_scripts.cfm">

		$("##updateUserData").validate({

			submitHandler: function(form) {

				postUserDataForm("#APPLICATION.componentsPath#/LoginManager.cfc?method=registerUser");

			}

		});


	});

</script>

</cfoutput>

<legend lang="es">Datos del usuario registrante/persona de contacto</legend>

<cfset page_type = 3>
<cfinclude template="#APPLICATION.corePath#/includes/user_data_form.cfm"/>

<div class="container">
	<div class="row">
		<div class="col-sm-offset-4 col-sm-3 col-md-2">
			<button type="button" class="btn btn-primary btn-block" id="saveUserData" onclick="$('#updateUserData').submit()" lang="es" style="margin-top:25px;margin-bottom:2px;">Registrarse</button>
		</div>
	</div>
</div>

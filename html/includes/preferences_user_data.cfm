
<!---<div class="div_head_subtitle">
Datos Personales
</div>--->
<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<!---<cfset return_page = "preferences.cfm">--->

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Login" method="getUserLoggedIn" returnvariable="objectUser">
</cfinvoke>

<cfoutput>

<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/vendor/jquery.ui.widget.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.iframe-transport.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.fileupload.js"></script>

<script src="#APPLICATION.path#/jquery/jquery-mask/jquery.mask.min.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-validate/jquery.validate.min.js"></script>

<script>

	function setLanguageBeforeSend() {

		var selectedLanguage = $("##language").val();

		window.lang.change(selectedLanguage);

		return true;
	}

	function postUserDataForm(requestUrl) {

		showLoadingPage(true);

		setLanguageBeforeSend();

		var updateUserFormId = "##updateUserData";

		if( $('##file').val().length == 0) { //Sin archivo

			$.ajax({
				  type: "POST",
				  url: requestUrl,
				  data: $(updateUserFormId).serialize(),
				  success: function(data, status) {

				  	if(status == "success"){
				  		//alert(JSON.stringify(data));
				  		var message = data.message;
				  		openUrl("#CGI.SCRIPT_NAME#?res="+data.result+"&msg="+encodeURIComponent(message));
				  	}else
						openUrl("#CGI.SCRIPT_NAME#?res=0&msg="+encodeURIComponent(status));

				  },
				  dataType: "json"
				});

		} else {

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

		}

		return false;

	}


	$(function () {

		$("##deleteImageButton").click(function() {

			if(confirmAction('eliminar')) {

				showLoadingPage(true);

				var requestUrl = "#APPLICATION.htmlComponentsPath#/User.cfc?method=deleteUserImage&user_id=#objectUser.user_id#";

				$.ajax({
				  type: "POST",
				  url: requestUrl,
				  success: function(data, status) {

				  	if(status == "success"){
				  		var message = data.message;

				  		//var userId = data.user_id;
				  		openUrl("#CGI.SCRIPT_NAME#?res="+data.result+"&msg="+encodeURIComponent(message));

				  	}else
						alert(status);

				  },
				  dataType: "json"
				});

			}

		});

		<cfinclude template="#APPLICATION.corePath#/includes/jquery_validate_bootstrap_scripts.cfm">

		$("##updateUserData").validate({

			submitHandler: function(form) {

				postUserDataForm("#APPLICATION.htmlComponentsPath#/User.cfc?method=updateUser");

			}

		});


	});

</script>

</cfoutput>

<cfset client_abb = SESSION.client_abb>
<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>

<cfset page_type = 2>
<cfinclude template="#APPLICATION.corePath#/includes/user_form_scripts.cfm">
<cfinclude template="#APPLICATION.corePath#/includes/user_data_form.cfm"/>

<div class="container">
	<div class="row">
		<div class="col-sm-offset-4 col-sm-3 col-md-2">
			<button type="button" class="btn btn-primary btn-block" id="saveUserData" onclick="$('#updateUserData').submit()" lang="es" style="margin-top:25px;margin-bottom:2px;">Guardar</button>
		</div>
	</div>
</div>

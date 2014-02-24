<cfoutput>
<script src="#APPLICATION.htmlPath#/language/user_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<!---<div class="div_head_subtitle">
Datos Personales
</div>--->
<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfset return_page = "preferences.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Login" method="getUserLoggedIn" returnvariable="objectUser">
</cfinvoke>

<!--- 
<cfxml variable="xmlUser">
	<cfoutput>
	#xmlResponse.response.result.user#
	</cfoutput>
</cfxml>
<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="objectUser">
	<cfinvokeargument name="xml" value="#xmlUser.user#">
	<cfinvokeargument name="return_type" value="object">
</cfinvoke> --->

<cfoutput>

<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/vendor/jquery.ui.widget.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.iframe-transport.js"></script>
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.fileupload.js"></script>

<script>
	
	function setLanguageBeforeSend() {
		
		var selectedLanguage = $("##language").val();
		
		window.lang.change(selectedLanguage);
		
		return true;	
	}

	function postUserDataForm(requestUrl) {

		showLoadingPage(true);

		setLanguageBeforeSend();

		var formId = "##updateUserData";

		if( $('##file').val().length == 0) { //Sin archivo

			$.ajax({
				  type: "POST",
				  url: requestUrl,
				  data: $(formId).serialize(),
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
	
			$(formId).fileupload('send', {fileInput: $('##file'), url: requestUrl})
				.success(function ( data, status ) {

					if(status == "success"){

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

	});

	function submitUserModifyModal(){

		postUserDataForm("#APPLICATION.htmlComponentsPath#/User.cfc?method=updateUser");

	}

</script>

</cfoutput>

<div class="container">
	<cfset page_type = 2>
	<cfinclude template="#APPLICATION.htmlPath#/includes/user_data_form.cfm"/>
</div>

<button type="button" class="btn btn-primary" id="saveUserData" onclick="submitUserModifyModal()" lang="es" style="margin-bottom:2px;">Guardar</button>
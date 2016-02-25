
<cfinclude template="alert_message.cfm">

<cfoutput>

<script src="#APPLICATION.path#/jquery/jquery-validate/jquery.validate.min.js"></script>

<script>

	function postUserAlertPreferencesForm(requestUrl) {

		showLoadingPage(true);

		var updateUserFormId = "##updateUserAlertPreferences";

		$.ajax({
			  type: "POST",
			  url: requestUrl,
			  data: $(updateUserFormId).serialize(),
			  success: function(data, status) {

			  	if(status == "success"){

			  		var message = data.message;
			  		openUrl("#CGI.SCRIPT_NAME#?res="+data.result+"&msg="+encodeURIComponent(message));

			  	}else
						openUrl("#CGI.SCRIPT_NAME#?res=0&msg="+encodeURIComponent(status));

			  },
			  dataType: "json"
			});

		return false;

	}


	$(function () {

		<cfinclude template="#APPLICATION.corePath#/includes/jquery_validate_bootstrap_scripts.cfm">

		$("##updateUserAlertPreferences").validate({

			submitHandler: function(form) {

				postUserAlertPreferencesForm("#APPLICATION.htmlComponentsPath#/User.cfc?method=updateUserPreferences");

			}

		});


	});

</script>

</cfoutput>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUserPreferences" returnvariable="preferences">
	<cfinvokeargument name="get_user_id" value="#SESSION.user_id#">
</cfinvoke>

<div class="row">
	<div class="col-sm-offset-1 col-sm-3 col-md-2">

		<button type="button" class="btn btn-primary btn-block" lang="es" onclick="$('#updateUserAlertPreferences').submit()">Guardar</button>

	</div>
</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/user_preferences_alerts_form.cfm">

<div class="row">
	<div class="col-sm-12">
		<div style="height:30px"></div>
	</div>
</div>


<div class="row">
	<div class="col-sm-offset-1 col-sm-3 col-md-2">

		<button type="button" class="btn btn-primary btn-block" lang="es" onclick="$('#updateUserAlertPreferences').submit()">Guardar</button>

	</div>
</div>

<div class="row">
	<div class="col-sm-12">
		<div style="height:30px"></div>
	</div>
</div>

function postUserDataForm(requestUrl) {

	$('body').modalmanager('loading');

	var formId = "#updateUserData";

	if( $('#file').val().length == 0) { //Sin archivo

		$.ajax({
			  type: "POST",
			  //url: $(formId).attr("action"),
			  url: requestUrl,
			  data: $(formId).serialize(),
			  success: function(data, status) {

			  	if(status == "success"){		
			  		var message = data.message;

			  		$('body').modalmanager('removeLoading');

			  		if(data.result == true) {
						var userId = data.user_id;
			  			//openUrl("all_users.cfm?user="+userId, "allUsersIframe");
			  			openUrl("user.cfm?user="+userId, "userAdminIframe");

			  			hideDefaultModal();	
			  			showAlertMessage(message, data.result);	  			
			  		} else {
			  			$("#errorMessageModal").modal();	
			  			$("#modalErrorMessage").text(message);		  			
			  		}
			  			
			  	}else
					alert(status);
				
			  },
			  dataType: "json"
			});

	} else {

		$(formId).fileupload('send', {fileInput: $('#file'), url: requestUrl})
			.success(function ( data, status ) {

				if(status == "success"){
			  		var result = $.parseJSON(data);
			  		var message = result.message;

			  		$('body').modalmanager('removeLoading');

			  		if(result.result == true) {
			  			var userId = result.user_id;
			  			//openUrl("all_users.cfm?user="+userId, "allUsersIframe");
			  			openUrl("user.cfm?user="+userId, "userAdminIframe");

			  			hideDefaultModal();
			  			showAlertMessage(message, result.result);
			  		} else {
						$("#errorMessageModal").modal();	
			  			$("#modalErrorMessage").text(message);					  			
			  		}			  		

			  	}else
			  		alert(status);

			}).error(function ( data, status )  {

				alert("Error: "+status);

			}).complete(function ( data, status )  { });

	}
	
	return false;

}
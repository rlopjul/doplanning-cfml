function clearFieldSelectedItem(fieldName) {

	document.getElementById(fieldName).value = "";
	document.getElementById(fieldName+"_title").value = "";
}

function setSelectedItem(itemId, itemTitle, fieldName) {

	document.getElementById(fieldName).value = itemId;
	document.getElementById(fieldName+"_title").value = itemTitle;
	$("#"+fieldName).trigger("change");

}

var selectUserType = "";

function setSelectedUser(userId, userName, fieldName) {

	if(selectUserType == "reviser" || selectUserType == "approver"){
		document.getElementById(selectUserType+"_user").value = userId;
		document.getElementById(selectUserType+"_user_full_name").value = userName;
	}else{
		document.getElementById(fieldName).value = userId;
		document.getElementById(fieldName+"_user_full_name").value = userName;
	}

	selectUserType = "";
}

function clearFieldSelectedUser(fieldName) {

	document.getElementById(fieldName).value = "";
	document.getElementById(fieldName+"_user_full_name").value = "";
}

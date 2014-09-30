function clearFieldSelectedItem(fieldName) {

	document.getElementById(fieldName).value = "";
	document.getElementById(fieldName+"_title").value = "";
}

function setSelectedItem(itemId, itemTitle, fieldName) {

	document.getElementById(fieldName).value = itemId;
	document.getElementById(fieldName+"_title").value = itemTitle;
}
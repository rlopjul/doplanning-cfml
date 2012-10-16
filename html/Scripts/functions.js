function submitForm(formName)
{
	var form = eval("document.forms."+formName);
	form.submit();
}
/*function showDiv(divName)
{
	Spry.$(divName).style.display = "block";
}*/
function showHideDiv(divName){
	var element = document.getElementById(divName);
	
	if(element.style.display == "none" || element.style.display == "")
		element.style.display = "block";	
	else
		element.style.display = "none";
}

function goToUrl(url){
	window.location.href = url;
}

/*function goBack(){
	history.go(-1);
	return false;
}*/

function openAreaInfo(){
	var openElement = document.getElementById('openAreaImg');
	var closeElement = document.getElementById('closeAreaImg');
	
	if(closeElement.style.display == "none" || closeElement.style.display == ""){
		openElement.style.display = "none";
		closeElement.style.display = "block";	
	}else {
		openElement.style.display = "block";
		closeElement.style.display = "none";	
	}
	
	showHideDiv('areaInfo');
}

function toggleCheckboxChecked(checkboxId) {
	$(checkboxId).attr('checked',!($(checkboxId).attr('checked')=="checked"));
}

function confirmAction(actionText) {
	
	var message = '¿Seguro que desea '+actionText+'?.';
	
	var resultado = confirm(message);
	if(resultado)
		return true;
	else
		return false;
	
}
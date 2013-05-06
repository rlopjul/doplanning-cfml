function submitForm(formName){
	var form = eval("document.forms."+formName);
	form.submit();
}

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

function confirmAction(actionText) {
	
	var message = window.lang.convert('¿Seguro que desea ')+window.lang.convert(actionText)+window.lang.convert('?. Esta acción no es reversible.');
	
	var resultado = confirm(message);
	if(resultado)
		return true;
	else
		return false;
	
}

function toggleCheckboxChecked(checkboxId) {
	$(checkboxId).attr('checked',!($(checkboxId).attr('checked')=="checked"));
}

var showLoading = true;

function downloadFile(url,event){
	if(event.preventDefault)
		event.preventDefault();
	//event.stopPropagation();
	
	showLoading = false;
	
	goToUrl(url);
	
	return false;
}
	

var showLoading = true;

function onUnloadPage(){
	if(showLoading)
		showLoadingPage(true);
	
	showLoading = true;
}

function onLoadPage(){
	showLoadingPage(false);
}

function showLoadingPage(value){

	if(value)
		document.getElementById("pageLoadingContainer").style.display = "block";
	else
		document.getElementById("pageLoadingContainer").style.display = "none";
}

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
	
	var message = window.lang.translate('¿Seguro que desea ')+window.lang.translate(actionText)+window.lang.translate('?. Esta acción no es reversible.');
	
	var resultado = confirm(message);
	if(resultado)
		return true;
	else
		return false;
	
}

function confirmReversibleAction(actionText) {
	
	var message = window.lang.translate('¿Seguro que desea ')+window.lang.translate(actionText)+'?';
	
	var resultado = confirm(message);
	if(resultado)
		return true;
	else
		return false;
	
}

function toggleCheckboxChecked(checkboxId) {
	//$(checkboxId).attr('checked',!($(checkboxId).attr('checked')=="checked"));
	$(checkboxId).prop("checked",!($(checkboxId).is(":checked")));
}
		
function toggleCheckboxesChecked(checked) {
	//$("input:checkbox").prop("checked",checked); 
	$("input:checkbox").each( function() {
		if($(this).hasClass("checkbox_locked") == false)	
			$(this).prop("checked",checked); 
	})
}

/**
Esta función no se debe usar porque no funciona en los accesos externos del SAS
Se mantiene para cuando no se puede incluir un <a> y se tiene que utilizar un <span> (AreaItemTree.cfc)
*/
function downloadFile(url,event){
	if(event.preventDefault)
		event.preventDefault();
	//event.stopPropagation();
	
	showLoading = false;
	
	goToUrl(url);
	
	return false;
}

/**
Esta función se utiliza para acceder a la descarga de archivos a partir de la URL especificada en el href
Es necesario usar esta función para webs en las que se reescriben las URLs (accesos externos del SAS),
ya que si la URL no se incluye en el href, no funciona correctamente
*/
function downloadFileLinked(anchor,event){

	/*if(event.preventDefault)
		event.preventDefault();*/
	preventEventDefault(event);

	showLoading = false;

	//goToUrl(event.target.href);
	goToUrl(anchor.href);
	
	return false;

}

function openPopUp(url) {
	window.open(url, "popup_id", "scrollbars,resizable,width=580,height=500,location=no ");
	return false;
}
	
function enableDatePicker(selector){

	$(selector).datepicker({
	  format: 'dd-mm-yyyy', 
	  autoclose: true,
	  weekStart: 1,
	  language: 'es',
	  todayBtn: 'linked'
	});
}

function stopEvent(event){

	preventEventDefault(event);
	
	stopPropagation(event);

	return false;
}

function preventEventDefault(event){

	if(event.preventDefault) //event.preventDefault() da error en IE
		event.preventDefault();
	else
		event.returnValue = false;
}

function stopPropagation(event) {
	event = event || window.event; // cross-browser event
    if (event.stopPropagation) {
        // W3C standard variant
        event.stopPropagation();
    } else {
        // IE variant
        event.cancelBubble = true;
    }
    return false;		
}

function hasLocalStorage() {

	//http://mathiasbynens.be/notes/localstorage-pattern

  	var uid = new Date,
          result;
          
    try {

        localStorage.setItem(uid, uid);
        result = localStorage.getItem(uid) == uid;
        localStorage.removeItem(uid);

        return result && localStorage;

    } catch(e) {}

}
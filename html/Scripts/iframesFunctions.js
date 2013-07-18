function onUnloadPage(){
	if(showLoading)
		document.getElementById("areaLoading").style.display = "block";
	
	showLoading = true;
}

function onLoadPage(){
	document.getElementById("areaLoading").style.display = "none";
}

function openUrlLite(url,target){
	
	if(target == "_self")
		window.location.href = url;
	else {
	
		if(target == "_blank")
			window.open(url);
		else
			parent.openUrl(url,target);
		
	}
}

function openUrl(url,target,event){
	
	if(event.preventDefault) //event.preventDefault() da error en IE
		event.preventDefault();
	else
		event.returnValue = false;
	
	if(event.stopPropagation) //event.stopPropagation() da error en IE
		event.stopPropagation();

	openUrlLite(url,target);

	return false;
}

function openUrlHtml2(url,target){
	
	var parentPage = parent.location.href.split('/').pop();
		
	if(parentPage.search("main.cfm") != -1) { //Esto debe cambiarse si se cambia la página de main.cfm o acmin/
		openUrlLite(url,target);		
	}
	
}
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
	
	stopEvent(event);
	
	openUrlLite(url,target);

	return false;
}

function openUrlHtml2(url,target){
	
	var parentPage = parent.location.href.split('/').pop();
		
	if(parentPage.search("main.cfm") != -1) { //Esto debe cambiarse si se cambia la página de main.cfm o acmin/
		openUrlLite(url,target);		
	}
	
}

function showAlertMessage(msg, res){

	parent.showAlertMessage(msg, res);
}
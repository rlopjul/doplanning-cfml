/*Required vars
clientAbb
selectAreaId
iframePage
*/
var curAreaId = 0;
var areaWithLink = false;
var currentTab = "#tab1";
var disableNextTabChange = false;

function windowHeight() {
	var de = document.documentElement;
	return de.clientHeight;
}	

function getURLParameterFromPath(name, path) {
    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec( path )||[,""])[1].replace(/\+/g, '%20'))||null;
}

function getFilename(url) {
   return url.substring(url.lastIndexOf('/')+1);
}

function showAlertMessage(msg, res){

	//if($("#alertContainer").is(":visible"))
	if($("#alertContainer span").length != 0)
		$("#alertContainer span").remove();

	if(res == true)
		$("#alertContainer").attr("class", "alert alert-success");
	else
		$("#alertContainer").attr("class", "alert alert-danger");
	
	$("#alertContainer button").after('<span>'+msg+'</span>');

	$("#alertContainer").fadeIn('slow');


	setTimeout(function(){
		    
	    hideAlertMessage();

	    }, 9500);	
}

function hideAlertMessage(){

	$("#alertContainer").fadeOut('slow');

}

function loadModal(url){
 
	$('body').modalmanager('loading');

	$modal.load(url, '', function(){
	  $modal.modal({width:740});/*680*/
	});
}


function hideModal(modalId){

	$(modalId).modal('hide');
}

function hideDefaultModal(){

	 $modal.modal('hide');
}


function postModalForm(formId, requestUrl, responseUrl, responseTarget){

	$('body').modalmanager('loading');

	$.ajax({
		  type: "POST",
		  url: requestUrl,
		  data: $(formId).serialize(),
		  success: function(data, status) {

		  	if(status == "success"){
		  		var message = data.message;

		  		//openUrl(responseUrl+"&msg="+message+"&res="+data.result,responseTarget);
		  		openUrl(responseUrl, responseTarget);

		  		hideDefaultModal();

		  		$('body').modalmanager('removeLoading');
		  		
		  		showAlertMessage(message, data.result);

		  	}else
				alert(status);
			
		  },
		  dataType: "json"
		});

}


/*function postModalFormMain(formId, requestUrl){

	$('body').modalmanager('loading');

	$.ajax({
		  type: "POST",
		  url: requestUrl,
		  data: $(formId).serialize(),
		  success: function(data, status) {

		  	if(status == "success"){
		  		var message = data.message;

		  		//openUrl(responseUrl+"&msg="+message+"&res="+data.result,responseTarget);*
		  		hideDefaultModal();

		  		$('body').modalmanager('removeLoading');

		  		showAlertMessage(message, data.result);

		  	}else
				alert(status);
			
		  },
		  dataType: "json"
		});
}*/


function postModalFormTree(formId, requestUrl){

	$('body').modalmanager('loading');

	$.ajax({
		  type: "POST",
		  url: requestUrl,
		  data: $(formId).serialize(),
		  success: function(data, status) {

		  	if(status == "success"){
		  		//alert(JSON.stringify(data));
		  		var message = data.message;

		  		hideDefaultModal();

		  		if(formId != "#deleteAreaForm") {

		  			disableNextTabChange = true;
		  			updateTreeWithSelectedArea(data.area_id);

		  		} else {

		  			updateTree();
		  		}
		  		

		  		$('body').modalmanager('removeLoading');

		  		showAlertMessage(message, data.result);

		  	}else
				alert(status);
			
		  },
		  dataType: "json"
		});
}

function openUrl(url,target){ 

	/*En iframesFunctions.js hay un método que se llama igual que este, pero que recibe 3 parámetros. Habría que modificar uno de los dos para que no tuviesen el mismo nombre y así evitar confusiones. main.js e iframesFunctions.js no se usan y no se deben usar en la misma página*/
	
	if(target == "itemIframe"){
		
		if(currentTab == "#tab3")
			loadIframeSearchItemPage(url);
		else
			loadIframeItemPage(url);
	
	}else if(target == "userAreaIframe" || target == "userAdminIframe" || target == "allUsersIframe" || target == "logItemIframe"){

		$("#"+target).attr('src', "iframes/"+getFilename(url));

	}else{
		if(target == "areaIframe"){

			if(currentTab != "#tab2") //No está en el tab de área
				$('#dpTab a[href="#tab2"]').tab('show');

			var urlAreaId = getURLParameterFromPath("area",url);

			if($.isNumeric(urlAreaId) && urlAreaId != curAreaId){

				iframePage = url; //Para que cargue esta url tras seleccionar el área en el árbol

				selectTreeNode(urlAreaId);

			}else
				loadIframePage(url);				
			
		}else
			loadIframePage(url);
	}
}

function loadIframePage(page) {
	page = addClientAbbToPage(page);

	$("#areaIframe").attr('src', "iframes/"+getFilename(page));
}

function loadIframeItemPage(page) {
	page = addClientAbbToPage(page);

	$("#itemIframe").attr('src', "iframes2/"+getFilename(page));		
}

function loadIframeSearchItemPage(page) {
	page = addClientAbbToPage(page);

	$("#searchItemIframe").attr('src', "iframes2/"+getFilename(page));		
}


function addClientAbbToPage(page) {

	var hashContent = "";
	var hashIndex = page.indexOf("#");
	if(hashIndex != -1){
		hashContent = page.substring(hashIndex, page.length);
		page = page.substring(0, hashIndex);
	}
		
	if(page.indexOf("?") == -1)
		page = page+"?abb="+clientAbb;
	else
		page = page+"&abb="+clientAbb;

	if(hashIndex != -1){
		page = page+hashContent;
	}

	return page;
}

function areaIframeLoaded() {
	//setLoadingArea(false);
}

function setWithLink(value) {
	
	areaWithLink = value;
	if(value == true)
		$("#areaImageAnchor").css("cursor","pointer");
	else
		$("#areaImageAnchor").css("cursor","default");
}

function loadTree() {
	
	curAreaId = "undefined";

	$("#loadingContainer").show();
	$("#treeContainer").css('visibility', 'hidden');

	var noCacheNumber = Math.floor(Math.random()*1001);
	$("#treeContainer").load("html_content/tree.cfm?n="+noCacheNumber, function() {
		showTree(true);	  
	});
}

function updateTree() {
	loadTree();	
}

function updateTreeWithSelectedArea(areaId){

	selectAreaId = areaId;
	loadTree();

}

function selectTreeNode(nodeId) {

	$("#areasTreeContainer").jstree("deselect_all");
	$("#areasTreeContainer").jstree("select_node", nodeId); 
}

function areaSelected(areaId, areaUrl, withLink)  {
	
	curAreaId = areaId;

	loadAreaImage(areaId);
	setWithLink(withLink);
	
	if(iframePage.length > 0){ //Hay página para cargar
		loadIframePage(iframePage);
		iframePage = ""; //Se borra el contenido del iframePage para que no vuelva a cargarse al recargar el árbol.
	} else {

		loadIframePage(areaUrl);
	}

	if(disableNextTabChange){
		disableNextTabChange = false;
	} else if(!$('#changeTabDisabled').is(':checked'))
		$('#dpTab a[href="#tab2"]').tab('show'); 
	 
	/*if($("#areaContainer").is(":hidden"))
		restoreTree();*/
	
}

function searchTextInTree(){
	searchInTree(document.getElementById('searchText').value);	
}

/*function maximizeTree() {
	$("#areaContainer").hide();
	$("#treeWrapper").width("100%");
	$("#maximizeTree").hide();
	$("#restoreTree").show();	
}

function restoreTree() {
	$("#treeWrapper").width(treeDefaultWidth);
	$("#areaContainer").show();
	$("#maximizeTree").show();
	$("#restoreTree").hide();	
}

function maximizeArea() {
	$("#treeWrapper").hide();
	$("#areaContainer").width("100%");
	$("#maximizeArea").hide();
	$("#restoreArea").show();
}

function restoreArea() {
	$("#areaContainer").width(areaDefaultWidth);
	$("#treeWrapper").show();
	$("#maximizeArea").show();
	$("#restoreArea").hide();
}*/
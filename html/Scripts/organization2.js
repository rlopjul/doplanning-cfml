var curAreaId = 0;
var areaWithLink = false;
var currentTab = "#tab1";

function windowHeight() {
	var de = document.documentElement;
	return de.clientHeight;
}	

function getURLParameterFromPath(name, path) {
    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec( path )||[,""])[1].replace(/\+/g, '%20'))||null;
}

function openUrl(url,target){
	
	if(target == "itemIframe"){
		
		if(currentTab == "#tab3")
			loadIframeSearchItemPage(url);
		else
			loadIframeItemPage(url)
	
	
	}else{
		if(target == "areaIframe"){
			
			if(currentTab != "#tab2"){ //No está en el tab de área
			
				$('#dpTab a[href="#tab2"]').tab('show');
				
				iframePage = url; //Para que cargue esta url tras seleccionar el área en el árbol
				
				var urAreaId = getURLParameterFromPath("area",url);
				selectTreeNode(urAreaId);
				
			}else
				loadIframePage(url);
			
		}else
			loadIframePage(url);
	}
}

function getFilename(url) {
   return url.substring(url.lastIndexOf('/')+1);
}

function loadIframePage(page) {
	$("#areaIframe").attr('src', "iframes/"+getFilename(page));
}

function loadIframeItemPage(page) {
	$("#itemIframe").attr('src', "iframes2/"+getFilename(page));		
}

function loadIframeSearchItemPage(page) {
	$("#searchItemIframe").attr('src', "iframes2/"+getFilename(page));		
}


function areaIframeLoaded() {
	//setLoadingArea(false);
}

function loadAreaImage(areaId) {
	if(applicationId != "vpnet") { //Esto solo está habilitado para DP ya que en la otra versión no se utiliza y carga la aplicación
		$("#areaImage").attr('src', "../app/downloadAreaImage.cfm?id="+areaId);
	}
}

function setWithLink(value) {
	
	areaWithLink = value;
	if(value == true)
		$("#areaImageAnchor").css("cursor","pointer");
	else
		$("#areaImageAnchor").css("cursor","default");
}

function goToAreaLink() {
	
	if(areaWithLink == true) {
		window.open("../app/goToAreaLink.cfm?id="+curAreaId, "_blank");
	}
}

function loadTree(areaId) {
		
	$("#loadingContainer").show();
	$("#mainContainer").hide();
	
	var noCacheNumber = Math.floor(Math.random()*1001);
	$("#treeContainer").load("html_content/tree.cfm?n="+noCacheNumber, function() {
		showTree(true);/*areaId*/	  
	});
}

function updateTree() {
	loadTree("");	
}

function selectTreeNode(nodeId) {

	$("#areasTreeContainer").jstree("select_node", "#"+nodeId, true); 

}

function areaSelected(areaId, areaUrl, withLink)  {
	
	curAreaId = areaId;

	loadAreaImage(areaId);
	setWithLink(withLink);
	
	if(iframePage.length > 0){ //Hay página para cargar
		loadIframePage(iframePage);
		//loadIframeItemPage(iframePage);
		iframePage = ""; //Se borra el contenido del iframePage para que no vuelva a cargarse al recargar el árbol.
	}else
	   loadIframePage(areaUrl);
	   
	 
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
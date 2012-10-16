var curAreaId = 0;
var areaWithLink = false;

function getFilename(url)
{
   return url.substring(url.lastIndexOf('/')+1);
}

function loadIframePage(page) {
	//$("#areaIframe").attr('src', applicationPath+"/html/iframes/"+page);
	$("#areaIframe").attr('src', "iframes/"+getFilename(page));
	
	//setLoadingArea(true);
}

function areaIframeLoaded() {
	//setLoadingArea(false);
}

/*function setLoadingArea(value) {
	
	if(value){
		$("#areaIframe").hide();
		$("#areaLoading").show();
	} else {
		$("#areaLoading").hide();
		$("#areaIframe").show();
	}
}*/

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
	
	$("#treeContainer").load("html_content/tree.cfm", function() {
		showTree(true,areaId);	  
	});
}

function updateTree() {
	loadTree("");	
}

function selectTreeNode(nodeId) {

	$("#areasTreeContainer").jstree("select_node", "#"+nodeId); 

}

function areaSelected(areaId, areaUrl, withLink)  {
	
	curAreaId = areaId;

	loadAreaImage(areaId);
	setWithLink(withLink);
	
	if(iframePage.length > 0){ //Hay página para cargar
		loadIframePage(iframePage);
		iframePage = ""; //Se borra el contenido del iframePage para que no vuelva a cargarse al recargar el árbol.
	}else
	   loadIframePage(areaUrl);
	   
	   
	if($("#areaContainer").is(":hidden"))
		restoreTree();
	
}


function treeLoaded(event, data) { //JStree loaded
	
	$("#areasTreeContainer").bind("select_node.jstree", function (e, data) {
	   var $obj = data.rslt.obj; // this will be a jquery object representing the <li> you've clicked
	   areaSelected($obj.attr("id"),$obj.children("a").attr("href"),$obj.attr("with_link")=="true");
	});
	
	if ( !isNaN(selectAreaId) ) { //Hay área para cargar
	
		selectTreeNode(selectAreaId);
		
	}else if(isNaN(selectAreaId)) { //No hay area para cargar
	
		$("#areaIframe").attr('src', applicationPath+"/html/iframes/area.cfm");
		
	}

	$("#loadingContainer").hide();
	$("#mainContainer").show();
}


function maximizeTree() {
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
}
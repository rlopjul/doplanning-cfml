<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- TemplateBeginEditable name="doctitle" -->
<title></title>
<!-- TemplateEndEditable -->
<script type="text/javascript" src="../html/Scripts/functions.js"></script>
<script type="text/javascript">

var showLoading = true;

function onUnloadPage(){
	if(showLoading)
		document.getElementById("areaLoading").style.display = "block";
	
	showLoading = true;
}
function onLoadPage(){
	document.getElementById("areaLoading").style.display = "none";
}
</script>
<link href="../html/styles.css" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "vpnet">
<link href="../html/styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="../html/styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<style>
	body {
		font-family:Verdana, Arial;
	}
</style>
<!-- TemplateBeginEditable name="head" -->
<!-- TemplateEndEditable -->
</head>

<body onbeforeunload="onUnloadPage()" onload="onLoadPage()">
<!---divLoading--->
<div style="position:absolute; width:100%; text-align:center; padding-top:160px;" id="areaLoading">
	<cfoutput>
	<img src="#APPLICATION.htmlPath#/assets/icons/loading.gif" alt="Loading" title="Loading" style="text-align:center;" /> 
	</cfoutput>
</div>
<!-- TemplateBeginEditable name="content" -->
<!-- TemplateEndEditable -->
</body>
</html>

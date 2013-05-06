<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es" xmlns:spry="http://ns.adobe.com/spry"><!-- InstanceBegin template="/Templates/plantilla_app_messenger.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2008 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#-Messenger general</title>
<!-- InstanceEndEditable -->
</cfoutput>
<script type="text/javascript" src="../SpryAssets/includes/xpath.js"></script>
<script type="text/javascript" src="../SpryAssets/includes/SpryData.js"></script>
<script type="text/javascript" src="../SpryAssets/includes/SpryXML.js"></script>
<script type="text/javascript" src="../SpryAssets/includes/SpryDOMUtils.js"></script>
<script type="text/javascript" src="../app/scripts/App.js"></script>
<script type="text/javascript" src="Scripts/MessengerControl.js"></script>
<script type="text/javascript" src="Scripts/Messenger.js"></script>
<link href="styles.min.css" rel="stylesheet" type="text/css" media="all" />
<link href="styles_messenger.css" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier NEQ "dp">
<link href="styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<link href="styles_screen.css" rel="stylesheet" type="text/css" media="screen" />
<link href="styles_mobiles.css" rel="stylesheet" type="text/css" media="handheld" />
<link href="styles_iphone.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 480px)" />
<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
</head>

<body class="body_messenger">
<cfif APPLICATION.identifier NEQ "dp">
	<div class="div_header">
		<a href="index.cfm"><div class="div_header_content"><!-- --></div></a>
		<div class="div_separador_header"><!-- --></div>
	</div>
</cfif>
<!-- InstanceBeginEditable name="header" -->

<!-- InstanceEndEditable -->
<div style="padding-top:5px; padding-left:3px; padding-right:3px;">
<!-- InstanceBeginEditable name="contenido" -->
<div class="div_head_title">
<cfoutput>
<div class="icon_title">
<span><img src="assets/icons_#APPLICATION.identifier#/messenger_general.png" alt="Messenger general"/></span></div>
<div class="head_title" style="padding-top:10px;"><span>Messenger general</span></div>
</cfoutput>
</div>

<cfinclude template="includes/messenger_content.cfm">

<script>
	Messenger.Organization.connectToConversation();
	
	function onWindowExit()
	{
		Messenger.Organization.disconnectFromConversation();
		/*if(confirm("Seguro que quiere salir"))
			return true;
		else
		{
			window.event.cancelBubble = true;
			window.event.returnValue = "Advertencia";
			return false;
		}*/
	}
	window.onbeforeunload = onWindowExit;
	
	function onSendButtonClicked(event)
	{
		Messenger.Organization.sendMessage(Messenger.prepareMessage());	
	}
	function onSaveButtonClicked(event)
	{
		Messenger.Organization.saveConversation();	
	}
	//Spry.Utils.addEventListener("sendButton", "mouseover", onSendButtonClicked, false);
</script>
<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
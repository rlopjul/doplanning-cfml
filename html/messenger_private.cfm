<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es" xmlns:spry="http://ns.adobe.com/spry"><!-- InstanceBegin template="/Templates/plantilla_app_messenger.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2008 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#</title>
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
<!-- InstanceBeginEditable name="header" --><!-- InstanceEndEditable -->
<div style="padding-top:5px; padding-left:3px; padding-right:3px;">
<!-- InstanceBeginEditable name="contenido" -->
<div class="div_head_title">
<cfoutput>
<div class="icon_title">
<a href="messenger_private.cfm"><img src="assets/icons_#APPLICATION.identifier#/messenger_private.png" alt="Messenger Privado"/></a></div>

<div class="head_title" style="padding-top:10px;"><a href="messenger_private.cfm">Messenger privado</a></div>
</cfoutput>
</div>
<div style="height:10px;"><!-- --></div>
<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
</cfinvoke>
<cfoutput>
<script type="text/javascript">
	Messenger.setConnectedUser("#objectUser.id#","#objectUser.family_name# #objectUser.name#")
</script>
</cfoutput>
	
<cfif NOT isDefined("FORM.user_selected") AND NOT (isDefined("URL.user") AND isValid("integer",URL.user))>

	<form action="messenger_private.cfm" method="post">
		<div style="width:100%; clear:both">
			<div class="texto_normal" style="padding-top:5px; padding-bottom:8px;">Seleccione un usuario y haga click en Iniciar conversación.</div>
			<div style="padding-bottom:3px;" class="msg_users_list">Usuarios:</div>
			<div spry:region="xmlUsers" id="usersList">
			
				<div spry:state="loading">Cargando...</div>
				<div spry:state="error">Ha ocurrido un error al cargar los usuarios</div>
				<div spry:state="ready">
					<div class="div_users_header">
							<div class="div_user_right">		
							<div class="div_text_user_name" style="padding-top:1px;"><span class="texto_normal" style="font-weight:bold;">Ordenar por:</span> <span spry:sort="family_name" class="texto_normal" style="cursor:pointer;">Nombre</span> <span spry:sort="name" class="texto_normal" style="cursor:pointer">Apellido</span></div>
							<div class="div_text_user_email"></div><div class="div_text_user_mobile"></div>
						</div>
					</div>		
				<select spry:repeatchildren="xmlUsers" size="30" style="width:100%; height:330px;" class="msg_users_list" name="user_selected">	
					<option value="{@id}" spry:if="{@id} == connected_user_id" disabled="disabled">{family_name} {name}</option>
					<option value="{@id}" spry:if="{@id} != connected_user_id">{family_name} {name}</option>	
				</select>
				</div>
				
			</div>
		</div>
		<input type="submit" class="btn btn-primary" name="submit" class="msg_button" value="Iniciar conversación" />
	</form>
	
	<script type="text/javascript">
		Messenger.Private.getAllUsers();
	</script>

<cfelse>

	<cfif isDefined("FORM.user_selected")>
		<cfset conversation_user_id = FORM.user_selected>
	<cfelseif isDefined("URL.user")>
		<cfset conversation_user_id = URL.user>
	</cfif>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
		<cfinvokeargument name="user_id" value="#conversation_user_id#">
	</cfinvoke>
	
	<cfset conversation_user_name = objectUser.family_name&" "&objectUser.name>
	
	<cfoutput>
	<div class="div_user_page_title">#objectUser.family_name# #objectUser.name#</div>
	</cfoutput>
	
	<div class="msg_div_loading" id="loadingContainer">
	Conectando...
	</div>
	<div style="clear:both;display:none;" id="messengerContainer">
		<div style="clear:both">
			<div style="float:left; width:100%">
				<cfinclude template="includes/messenger_conversation.cfm">
			</div>
		</div>
		<cfinclude template="includes/messenger_controls.cfm">	
	</div>
	
	<script type="text/javascript">
	<cfoutput>
	var conversation_user_id = #conversation_user_id#;
	var conversation_user_name = "#conversation_user_name#";
	</cfoutput>
	Messenger.Private.setConversationUserName(conversation_user_name);
	Messenger.Private.connectToConversation(conversation_user_id);
	
	function onWindowExit()
	{
		Messenger.Private.disconnectFromConversation(current_conversation_id);
	}
	window.onbeforeunload = onWindowExit;
	
	
	function onSendButtonClicked(event)
	{
		Messenger.Private.sendMessage(Messenger.prepareMessage(),current_conversation_id);	
	}
	
	function onSaveButtonClicked(event)
	{
		Messenger.Private.saveConversation();	
	}
	</script>

</cfif>


<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
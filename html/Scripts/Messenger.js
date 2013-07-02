
/*VARS*/
var updateMessagesInterval = 2000; //2 segundos
var updateUsersInterval = 15000; //15 segundos
var xmlUsers = new Spry.Data.XMLDataSet(null, "response/result/users/user", {distinctOnLoad: true, useCache: false});

var currentStatus = "loading";

var connected_user_name = "";
var connected_user_id = "";
var current_conversation_id;
var current_conversation_name;

//Spry.Data.Region.debug = true;

var Messenger; if (!Messenger) Messenger = {};

Messenger.Message = function(messageText, messageColor, messageDate, messageUser)
{	
	this.text = messageText;
	this.color = messageColor;
	this.sent_date = messageDate;
	this.user_full_name = messageUser;
}
Messenger.Message.prototype.constructor = Messenger.Message;
Messenger.Message.prototype.toXMLString = function()
{
	var xmlMessage = '<user_message color="'+this.color+'"><text><![CDATA['+this.text+']]></text></user_message>';
	
	return xmlMessage;
	
}
Messenger.Message.prototype.toHTMLOutput = function()
{
	//Aquí antes había "&nbsp;", pero esto daba error en las peticiones
	var htmlMessage = '<div><div><span class="msg_message_date">'+this.sent_date+'</span> <span class="msg_message_user">'+this.user_full_name+'</span></div><div style="color:#'+this.color+'">'+this.text+'</div></div>';
	
	return htmlMessage;
	
}

Messenger.setCurrentStatus = function(status)
{
	if(status != currentStatus)
	{
		switch(status)
		{
			case "ready":
				Spry.$("messengerContainer").style.display = "block";
				Spry.$("loadingContainer").style.display = "none";
				currentStatus = status;
			break;
			
			default:
				Messenger.showErrorMessage("Estado no controlado");
			break;
		}
	}
}

Messenger.setConnectedUser = function(user_id, user_name)
{
	connected_user_id = user_id;
	connected_user_name = user_name;
}
Messenger.setConversationName = function(name)
{
	current_conversation_name = name;
}

Messenger.prepareMessage = function()
{
	var messageSendText = Spry.$("messageTextArea").value;
	var messageSendDate = Messenger.getDateTime();
	var messageSendColor = "000000";
	var messageSendUser = connected_user_name;
	var messageSend = new Messenger.Message(messageSendText,messageSendColor,messageSendDate,messageSendUser);
	Spry.$("messageTextArea").value = "";
	
	return messageSend;
	
}

Messenger.addMessageToConversation = function(message)
{
	Spry.$("conversationTextArea").innerHTML = Spry.$("conversationTextArea").innerHTML+message.toHTMLOutput();
	
	Spry.$("conversationTextArea").scrollTop = Spry.$("conversationTextArea").scrollHeight;
}

Messenger.addMessagesToConversation = function(xmlMessages)
{
	
	//Si solo hay un elemento xmlMessages.user_message.length devuelve undefined

	if(xmlMessages.user_message.length != null)
	{
		var numMessages = xmlMessages.user_message.length;
			
		for(var i=0; i<numMessages; i++)
		{
			var messageAddText = xmlMessages.user_message[i].text._value();
			var messageAddColor = xmlMessages.user_message[i]["@color"];
			var messageAddDate = xmlMessages.user_message[i]["@sent_date"];
			var messageAddUser = xmlMessages.user_message[i].user_full_name._value();
			var messageAdd = new Messenger.Message(messageAddText, messageAddColor, messageAddDate, messageAddUser);
			Messenger.addMessageToConversation(messageAdd);
		}
	}
	else
	{
		var messageAddText = xmlMessages.user_message.text._value();
		var messageAddColor = xmlMessages.user_message["@color"];
		var messageAddDate = xmlMessages.user_message["@sent_date"];
		var messageAddUser = xmlMessages.user_message.user_full_name._value();
		var messageAdd = new Messenger.Message(messageAddText, messageAddColor, messageAddDate, messageAddUser);
		Messenger.addMessageToConversation(messageAdd);
	}
}

Messenger.saveConversation = function(type, name)
{
	Spry.$("saveContainer").style.display = "none";
	Spry.$("loadingSaveContainer").style.display = "block";
	
	var text = Spry.$("conversationTextArea").innerHTML;
	//text = "HOOOLA";
	var parameters = '<conversation type="'+type+'"><name><![CDATA['+name+']]></name><text><![CDATA['+text+']]></text></conversation>';
	//alert("Parameters: "+parameters);
	var requestUrl = new App.UrlRequest("MessengerManager", "saveConversation", parameters);
	Messenger.doRequest(requestUrl);
}

Messenger.notifyParent = function()
{
	//window.opener.alert("Nuevos mensajes");	
}

Messenger.onTextAreaKeyPressed = function (event)
{
	var keyCode = 0;
	
	if(!event)
		event = window.event;
	if(event.keyCode)
		keyCode = event.keyCode;
	else
		keyCode = event.which;
	if(keyCode == 13)
	{
		onSendButtonClicked(event);	
		return false;
	}
	else	
		return true;
}

Messenger.getDateTime = function ()
{
	var date = new Date();
	var d  = date.getDate();
	var day = (d < 10) ? '0' + d : d;
	var m = date.getMonth() + 1;
	var month = (m < 10) ? '0' + m : m;
	var yy = date.getYear();
	var year = (yy < 1000) ? yy + 1900 : yy;
	
	var h = date.getHours();
	var mi = date.getMinutes();
	var s = date.getSeconds();
	
	var dateTime = day+"-"+month+"-"+year+" "+h+":"+mi+":"+s;
	
	return dateTime;
}

//////////////////////////////////////////// ORGANIZATION \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

if (!Messenger.Organization) Messenger.Organization = {};

Messenger.Organization.connectToConversation = function()
{
	var requestUrlC = new App.UrlRequest("MessengerOrganization", "connectToOrganizationConversation", "");
	Messenger.doRequest(requestUrlC);

}

Messenger.Organization.disconnectFromConversation = function()
{
	var requestUrlD = new App.UrlRequest("MessengerOrganization", "disconnectFromOrganizationConversation", "");
	Messenger.doRequest(requestUrlD);
}

Messenger.Organization.initLoadMessages = function()
{
	Messenger.Organization.getLastMessages();
	var loadIntervalID = setInterval(Messenger.Organization.getLastMessages, updateMessagesInterval);
}

Messenger.Organization.getLastMessages = function()
{
	var requestUrlM = new App.UrlRequest("MessengerOrganization", "getOrganizationConversationMessages", "");
	Messenger.doRequest(requestUrlM);
}

Messenger.Organization.initLoadUsers = function()
{
	//Messenger.Organization.getLastUsers();
	var loadUsersIntervalID = setInterval(Messenger.Organization.getLastUsers, updateUsersInterval);
}

Messenger.Organization.getLastUsers = function()
{
	var requestUrlU = new App.UrlRequest("MessengerOrganization", "getOrganizationConversationUsers", "");
	Messenger.doRequest(requestUrlU);
}

Messenger.Organization.acknowledgeMessages = function(xmlMessages)
{
	//alert("Mensajes recibidos");
	
	var xmlResult = "<user_messages>";

	if(xmlMessages.user_message.length != null)
	{
		var numMessages = xmlMessages.user_message.length;
			
		for(var i=0; i<numMessages; i++)
		{
			var messageId = xmlMessages.user_message[i]["@id"];
		
			xmlResult = xmlResult+'<user_message id="'+messageId+'"/>';
		}
	}
	else
	{
		var messageId = xmlMessages.user_message["@id"];
		
		xmlResult = xmlResult+'<user_message id="'+messageId+'"/>';
	}
			

	xmlResult = xmlResult+"</user_messages>";
	
	var requestUrlA = new App.UrlRequest("MessengerOrganization", "acknowledgeOrganizationConversationMessages", xmlResult);
	Messenger.doRequest(requestUrlA);
}

Messenger.Organization.sendMessage = function(message)
{
	if(message.text.length > 0)
	{
		var requestUrlS = new App.UrlRequest("MessengerOrganization", "sendOrganizationConversationMessage", message.toXMLString());
		Messenger.addMessageToConversation(message);
		Messenger.doRequest(requestUrlS);
	}
}

Messenger.Organization.getConversationName = function()
{
	return "Conversación general ";
}

Messenger.Organization.saveConversation = function()
{
	Messenger.saveConversation("organization",Messenger.Organization.getConversationName());		
}


//////////////////////////////////////////// AREA \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

if (!Messenger.Area) Messenger.Area = {};

Messenger.Area.connectToConversation = function(area_id)
{
	var requestUrlC = new App.UrlRequest("MessengerArea", "connectToAreaConversation", '<area id="'+area_id+'"/>');
	Messenger.doRequest(requestUrlC);
}

Messenger.Area.disconnectFromConversation = function(area_id)
{
	var requestUrlD = new App.UrlRequest("MessengerArea", "disconnectFromAreaConversation", '<area id="'+area_id+'"/>');
	Messenger.doRequest(requestUrlD);
}

Messenger.Area.setConversationAreaName = function(area_name)
{
	Messenger.setConversationName(area_name);
}


Messenger.Area.initLoadMessages = function(area_id)
{
	Messenger.Area.getLastMessages(area_id);
	if(window.ActiveXObject) //IE
	{
		var loadIntervalID = setInterval(function(){Messenger.Area.getLastMessages(area_id)}, updateMessagesInterval); 
	}
	else //Others
	{
		var loadIntervalID = setInterval(Messenger.Area.getLastMessages, updateMessagesInterval, area_id);
	}
}

Messenger.Area.getLastMessages = function(area_id)
{
	var requestUrlM = new App.UrlRequest("MessengerArea", "getAreaConversationMessages", '<area id="'+area_id+'"/>');
	Messenger.doRequest(requestUrlM);
}

Messenger.Area.initLoadUsers = function(area_id)
{
	//Messenger.Area.getLastUsers();
	if(window.ActiveXObject) //IE
	{
		var loadUsersIntervalID = setInterval(function(){Messenger.Area.getLastUsers(area_id)}, updateUsersInterval); 
	}
	else //Others
	{
		var loadUsersIntervalID = setInterval(Messenger.Area.getLastUsers, updateUsersInterval, area_id);
	}
}

Messenger.Area.getLastUsers = function(area_id)
{
	var requestUrlU = new App.UrlRequest("MessengerArea", "getAreaConversationUsers", '<area id="'+area_id+'"/>');
	Messenger.doRequest(requestUrlU);
}

Messenger.Area.acknowledgeMessages = function(xmlMessages, area_id)
{
	//alert("Mensajes recibidos");
	
	var xmlResult = '<area id="'+area_id+'"/><user_messages>';

	if(xmlMessages.user_message.length != null)
	{
		var numMessages = xmlMessages.user_message.length;
			
		for(var i=0; i<numMessages; i++)
		{
			var messageId = xmlMessages.user_message[i]["@id"];
		
			xmlResult = xmlResult+'<user_message id="'+messageId+'"/>';
		}
	}
	else
	{
		var messageId = xmlMessages.user_message["@id"];
		
		xmlResult = xmlResult+'<user_message id="'+messageId+'"/>';
	}
			

	xmlResult = xmlResult+"</user_messages>";
	
	var requestUrlA = new App.UrlRequest("MessengerArea", "acknowledgeAreaConversationMessages", xmlResult);
	Messenger.doRequest(requestUrlA);
}

Messenger.Area.sendMessage = function(message, area_id)
{
	if(message.text.length > 0)
	{
		var requestUrlS = new App.UrlRequest("MessengerArea", "sendAreaConversationMessage", '<area id="'+area_id+'"/>'+message.toXMLString());
		Messenger.addMessageToConversation(message);
		Messenger.doRequest(requestUrlS);
	}
}

Messenger.Area.getConversationName = function()
{
	return "Conversación del área "+current_conversation_name;
}

Messenger.Area.saveConversation = function()
{
	Messenger.saveConversation("area",Messenger.Area.getConversationName());		
}

///////////////


//////////////////////////////////////////// PRIVATE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

if (!Messenger.Private) Messenger.Private = {};

Messenger.Private.connectToConversation = function(user_id)
{
	var requestUrlC = new App.UrlRequest("MessengerPrivate", "connectToPrivateConversation", '<user id="'+user_id+'"/>');
	Messenger.doRequest(requestUrlC);
}

Messenger.Private.disconnectFromConversation = function(conversation_id)
{
	var requestUrlD = new App.UrlRequest("MessengerPrivate", "disconnectFromPrivateConversation", '<conversation id="'+conversation_id+'"/>');
	Messenger.doRequest(requestUrlD);
}

Messenger.Private.setConversationUserName = function(user_name)
{
	Messenger.setConversationName(user_name);
}

Messenger.Private.getAllUsers = function()
{
	var parameters = '<user id="" connected=""><family_name/><name/></user><order parameter="connected" order_type="DESC"/>';
	var requestUrlU = new App.UrlRequest("MessengerManager", "getAllUsers", parameters);
	Messenger.doRequest(requestUrlU);
}

Messenger.Private.initLoadMessages = function(conversation_id)
{
	Messenger.Private.getLastMessages(conversation_id);
	
	if(window.ActiveXObject) //IE
	{
		var loadIntervalID = setInterval(function(){Messenger.Private.getLastMessages(conversation_id)}, updateMessagesInterval); 
	}
	else //Others
	{
		var loadIntervalID = setInterval(Messenger.Private.getLastMessages, updateMessagesInterval, conversation_id);
	}
}

Messenger.Private.getLastMessages = function(conversation_id)
{
	var requestUrlM = new App.UrlRequest("MessengerPrivate", "getPrivateConversationMessages", '<conversation id="'+conversation_id+'"/>');
	Messenger.doRequest(requestUrlM);
}


Messenger.Private.acknowledgeMessages = function(xmlMessages, conversation_id)
{
	
	var xmlResult = '<conversation id="'+conversation_id+'"/><user_messages>';

	if(xmlMessages.user_message.length != null)
	{
		var numMessages = xmlMessages.user_message.length;
			
		for(var i=0; i<numMessages; i++)
		{
			var messageId = xmlMessages.user_message[i]["@id"];
		
			xmlResult = xmlResult+'<user_message id="'+messageId+'"/>';
		}
	}
	else
	{
		var messageId = xmlMessages.user_message["@id"];
		
		xmlResult = xmlResult+'<user_message id="'+messageId+'"/>';
	}
			

	xmlResult = xmlResult+"</user_messages>";
	
	var requestUrlA = new App.UrlRequest("MessengerPrivate", "acknowledgePrivateConversationMessages", xmlResult);
	Messenger.doRequest(requestUrlA);
}

Messenger.Private.sendMessage = function(message, conversation_id)
{
	if(message.text.length > 0)
	{
		var requestUrlS = new App.UrlRequest("MessengerPrivate", "sendPrivateConversationMessage", '<conversation id="'+conversation_id+'"/>'+message.toXMLString());
		Messenger.addMessageToConversation(message);
		Messenger.doRequest(requestUrlS);
	}
}

Messenger.Private.getConversationName = function()
{
	return "Conversación privada con "+current_conversation_name;
}

Messenger.Private.saveConversation = function()
{
	Messenger.saveConversation("private",Messenger.Private.getConversationName());		
}
/////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

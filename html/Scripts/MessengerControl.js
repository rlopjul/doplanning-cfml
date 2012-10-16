var updateConversationsInterval = 12000; //12 segundos
var connectionErrors = 0;

var Messenger; if (!Messenger) Messenger = {};

Messenger.doRequest = function(urlRequest)
{
	//alert("PETICIÓN: "+urlRequest.url);
	Spry.Utils.loadURL("POST", urlRequest.url, false, Messenger.onDoRequestComplete, {postData: urlRequest.parameters, headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" }, errorCallback: Messenger.onDoRequestFail});
}

Messenger.onDoRequestFail = function (request) 
{
	connectionErrors++;
	if(connectionErrors < 2)
	{
		Messenger.showErrorMessage("Ha ocurrido un error.\n Compruebe que dispone de conexión a internet, y que su navegador no tiene bloqueadas las ventanas emergentes (Pop-ups)");
	}
	else
		Messenger.showConnectionErrorMessage("No se puede conectar correctamente con el servidor. Compruebe que dispone de conexión a internet, y que no tiene cortes de conexión.");
}

Messenger.onDoRequestComplete = function(request) 
{
	var response = request.xhRequest.responseText;
	response = App.trim(response);
	var responseDoc = Spry.Utils.stringToXMLDoc(response);
	if (!responseDoc || !responseDoc.firstChild)
	{
		Messenger.showErrorMessage("Fallo al obtener el XML");
		return;
	}

	// Convert the XML DOM document to a JS object.
	var xmlResponseObj = Spry.XML.documentToObject(responseDoc);
   
	//document.write("<textarea rows='8'>Response: "+response+"</textarea>");
	if(xmlResponseObj.response)
	{
		if(xmlResponseObj.response["@status"]=="ok")
		{
			onMessengerRequestComplete(xmlResponseObj, responseDoc);
		}
		else//Gestion de errores
		{
			var mensaje = "Ha ocurrido un error";
			/*if(xmlResponseObj.response["@status"]=="error" && xmlResponseObj.response.error.title)
				mensaje = xmlResponseObj.response.error.title._value();*/
			Messenger.showErrorMessage(mensaje);
		}
	}

}

Messenger.showErrorMessage = function(message)
{
	alert(message);
}

Messenger.showConnectionErrorMessage = function(message)
{
	Spry.$("errorMessage").innerHTML = message;
}

Messenger.showInformationMessage= function(message)
{
	alert(message);
}

function onMessengerRequestComplete(xmlResponse, responseDoc)
{
	/*var object = new Spry.Data.XMLDataSet(null, "/response", {distinctOnLoad: true, useCache: false});
	object.setDataFromDoc(xmlResponse);
	object.loadData();*/
	var requestMethod = xmlResponse.response["@method"];
	//document.write("<textarea>"+requestMethod+"</textarea>");
	if(connectionErrors > 0) //Si hay errores de conexión, le resta uno para indicar que se ha llevado a cabo una petición correctamente
	{
		connectionErrors--;
		if(connectionErrors == 0)
			Spry.$("errorMessage").innerHTML = "";
			
	}

	switch(requestMethod)
	{
		case "saveConversation":
			
			Spry.$("saveContainer").style.display = "block";
			Spry.$("loadingSaveContainer").style.display = "none";
	
			Messenger.showInformationMessage("Conversación guardada correctamente");			
		break;
		
		////////////////////////ORGANIZATION\\\\\\\\\\\\\\\\\\\\\
		case "connectToOrganizationConversation":
			if(xmlResponse.response.result.users)
			{
				xmlUsers.setDataFromDoc(responseDoc);
				
				//Spry.$("usersList").style.display = "block";
				
				Messenger.Organization.initLoadMessages();
				Messenger.Organization.initLoadUsers();
				
				//alert("Se ha conectado a la conversación");
			}
			else
				Messenger.showErrorMessage("XML incorrecto");		
		break;
		
		case "disconnectFromOrganizationConversation":
			
		break;	
		
		case "getOrganizationConversationMessages":
			if(xmlResponse.response.result.user_messages)
			{
				//alert("Se han obtenido los mensajes")
				if(xmlResponse.response.result.user_messages.user_message)
				{
					Messenger.addMessagesToConversation(xmlResponse.response.result.user_messages);
					Messenger.Organization.acknowledgeMessages(xmlResponse.response.result.user_messages);
					
				}
				
				Messenger.setCurrentStatus("ready");
				
			}
			else
				Messenger.showErrorMessage("XML incorrecto");
		break;	
		
		case "acknowledgeOrganizationConversationMessages":
			//alert("mensajes notificados");
		break;	
		
		
		case "getOrganizationConversationUsers":
			if(xmlResponse.response.result.users.user)
			{
				xmlUsers.setDataFromDoc(responseDoc);
				
				//Messenger.setCurrentStatus("ready");	
			}
			else
				Messenger.showErrorMessage("XML incorrecto");
		break;
		
		
		case "sendOrganizationConversationMessage":
			
		break;	
		
		/////////////////////////////////////
		
		
		////////////////////////AREA\\\\\\\\\\\\\\\\\\\\\
		case "connectToAreaConversation":
			if(xmlResponse.response.result.users)
			{
				xmlUsers.setDataFromDoc(responseDoc);
					
				var current_area_id = xmlResponse.response.result.area["@id"];
				
				Messenger.Area.initLoadMessages(current_area_id);
				Messenger.Area.initLoadUsers(current_area_id);
				
				//alert("Se ha conectado a la conversación");

			}
			else
				Messenger.showErrorMessage("XML incorrecto");		
		break;
		
		case "disconnectFromAreaConversation":
			
		break;	
		
		case "getAreaConversationMessages":
			if(xmlResponse.response.result.user_messages)
			{
				//alert("Se han obtenido los mensajes")
				if(xmlResponse.response.result.user_messages.user_message)
				{
					var current_area_id = xmlResponse.response.result.area["@id"];
					
					Messenger.addMessagesToConversation(xmlResponse.response.result.user_messages);
					Messenger.Area.acknowledgeMessages(xmlResponse.response.result.user_messages,current_area_id);
					
				}
				
				Messenger.setCurrentStatus("ready");
				
			}
			else
				Messenger.showErrorMessage("XML incorrecto");
		break;	
		
		case "acknowledgeAreaConversationMessages":
			//alert("mensajes notificados");
		break;	
		
		case "getAreaConversationUsers":
			if(xmlResponse.response.result.users.user)
			{
				xmlUsers.setDataFromDoc(responseDoc);
				
				//Messenger.setCurrentStatus("ready");	
			}
			else
				Messenger.showErrorMessage("XML incorrecto");
		break;
		
		case "sendAreaConversationMessage":
			
		break;	
		
		/////////////////////////////////////
		
		
		////////////////////////PRIVATE\\\\\\\\\\\\\\\\\\\\\
		
		case "getAllUsers":
			if(xmlResponse.response.result.users)
			{
				xmlUsers.setDataFromDoc(responseDoc);
					
				/*var current_area_id = xmlResponse.response.result.area["@id"];
				
				Messenger.Area.initLoadMessages(current_area_id);*/
				
				//Messenger.setCurrentStatus("ready");
					
			}
			else
				Messenger.showErrorMessage("XML incorrecto");	
		break;
		
		case "getNewPrivateConversations":
		
			if(xmlResponse.response.result.conversations)
			{
				if(xmlResponse.response.result.conversations.conversation)
				{
					Messenger.showInformationMessage("Tiene una o varias conversaciones privadas nuevas. Se le abrirán en ventanas aparte. Compruebe que su navegador no las bloquea.");
					Messenger.Private.openNewConversations(xmlResponse.response.result.conversations);
				}
				/*else
					Messenger.showErrorMessage("No hay nuevas conversaciones");*/
			}
			else
				Messenger.showErrorMessage("XML incorrecto");
		break;
		
		case "connectToPrivateConversation":
			if(xmlResponse.response.result.conversation)
			{
				//xmlUsers.setDataFromDoc(responseDoc);
					
				current_conversation_id = xmlResponse.response.result.conversation["@id"];
				
				Messenger.Private.initLoadMessages(current_conversation_id);
				
				//alert("Se ha conectado a la conversación");
					
			}
			else
				Messenger.showErrorMessage("XML incorrecto");		
		break;
		
		case "disconnectFromPrivateConversation":
			
		break;	
		
		case "getPrivateConversationMessages":
			if(xmlResponse.response.result.user_messages)
			{
				//alert("Se han obtenido los mensajes")
				if(xmlResponse.response.result.user_messages.user_message)
				{
					//var conversation_id = xmlResponse.response.result.conversation["@id"];
					
					//alert("Mensajes recibidos "+xmlResponse.response.result.user_messages.length);
					
					Messenger.addMessagesToConversation(xmlResponse.response.result.user_messages);
					Messenger.Private.acknowledgeMessages(xmlResponse.response.result.user_messages,current_conversation_id);
					
				}
				
				Messenger.setCurrentStatus("ready");
				
			}
			else
				Messenger.showErrorMessage("XML incorrecto");
		break;	
		
		case "acknowledgePrivateConversationMessages":
			//alert("mensajes notificados");
		break;	
		
		case "sendPrivateConversationMessage":
			
		break;	
		
		//////////////////////////////////////////////		
		
		default:
			Messenger.showErrorMessage("Respuesta del servidor no controlada");
		break;
		
	}
}


if (!Messenger.Private) Messenger.Private = {};

Messenger.Private.getNewConversations = function()
{
	var requestUrlC = new App.UrlRequest("MessengerPrivate", "getNewPrivateConversations", "");
	Messenger.doRequest(requestUrlC);
}

Messenger.Private.initGetNewConversations = function()
{
	Messenger.Private.getNewConversations();
	var loadConversationsIntervalID = setInterval(Messenger.Private.getNewConversations, updateConversationsInterval);	
}

Messenger.Private.openNewConversations = function (xmlConversations)
{
	if(xmlConversations.conversation.length != null)
	{
		var numConversations = xmlConversations.conversation.length;
			
		for(var i=0; i<numConversations; i++)
		{
			var conversationUserId = xmlConversations.conversation[i].user["@id"];
			
			Messenger.Private.openNewConversation(conversationUserId);
		}
	}
	else
	{
		var conversationUserId = xmlConversations.conversation.user["@id"];
		
		Messenger.Private.openNewConversation(conversationUserId);
	}	
}

Messenger.Private.openNewConversation = function (userId)
{
	App.openMessenger("messenger_private.cfm?user="+userId);
}
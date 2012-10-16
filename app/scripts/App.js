var App; if (!App) App = {};

App.encodeUtf8 = function( s )
{
  return unescape( encodeURIComponent( s ) );
}

App.decodeUtf8 = function( s )
{
  return decodeURIComponent( escape( s ) );
}

App.trim = function (s){
	//s = s.replace(/\s+/gi, ‘ ‘); //sacar espacios repetidos dejando solo uno
	s = s.replace(/^\s+|\s+$/gi, ''); //sacar espacios blanco principio y final
	return s;
}

App.openMessenger = function(page)
{
	var pageName = page.replace(".cfm", '');
	pageName = pageName.replace("../", ''); //Esto se quita porque en el título de la página da error en IE
	pageName = pageName.replace("?",'');
	pageName = pageName.replace("=",'');
	if(page == "messenger_private.cfm")
	{
		var num = new Date().getTime().toString();
		pageName = pageName+num;	
	}
	
	var mes = window.open(page, pageName, "width=480,height=550,scrollbars=no");
	mes.focus();

}

App.logoutUser = function()
{
	var requestUrl = new App.UrlRequest("LoginManager", "logOutUser", "");
	App.doRequest(requestUrl);
}

App.UrlRequest = function(component, method, params)
{	
	this.url = new String();
	var pathUrl = "../app/WS/";
	var xmlRequestObj = App.encodeUtf8('<?xml version="1.0" encoding="UTF-8"?><request method="'+method+'"><parameters>'+params+'</parameters></request>');
	this.url = pathUrl+component+".cfc?method="+method;
	this.parameters = 'request='+xmlRequestObj;
	this.url = encodeURI(this.url); //Encodes the URL
	//this.url = "prueba.xml";
}
App.UrlRequest.prototype.constructor = App.UrlRequest;

App.doRequest = function(urlRequest)
{
	Spry.Utils.loadURL("POST", urlRequest.url, false, App.onDoRequestComplete, {postData: urlRequest.parameters, headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" }, errorCallback: App.onDoRequestFail});
}

App.onDoRequestFail = function (request) 
{
	/*connectionErrors++;
	if(connectionErrors < 2)
	{
		Messenger.showErrorMessage("Ha ocurrido un error conectando con el servidor. Compruebe que dispone de conexión a internet.");
	}
	else
		Messenger.showConnectionErrorMessage("No se puede conectar correctamente con el servidor. Compruebe que dispone de conexión a internet, y que no tiene cortes de conexión.");*/
}

App.onDoRequestComplete = function(request) 
{
	var response = request.xhRequest.responseText;
	response = App.trim(response);
	var responseDoc = Spry.Utils.stringToXMLDoc(response);
	if (!responseDoc || !responseDoc.firstChild)
	{
		//Messenger.showErrorMessage("Fallo al obtener el XML");
		return;
	}

	// Convert the XML DOM document to a JS object.
	var xmlResponseObj = Spry.XML.documentToObject(responseDoc);
   
	//document.write("<textarea rows='8'>Response: "+response+"</textarea>");
	if(xmlResponseObj.response)
	{
		if(xmlResponseObj.response["@status"]=="ok")
		{
			onAppRequestComplete(xmlResponseObj, responseDoc);
		}
		else//Gestion de errores
		{
			var mensaje = "Ha ocurrido un error";

			//App.showErrorMessage(mensaje);
		}
	}

}

function onAppRequestComplete(xmlResponse, responseDoc)
{

	var requestMethod = xmlResponse.response["@method"];
	/*if(connectionErrors > 0) //Si hay errores de conexión, le resta uno para indicar que se ha llevado a cabo una petición correctamente
	{
		connectionErrors--;
		if(connectionErrors == 0)
			Spry.$("errorMessage").innerHTML = "";
			
	}*/

	switch(requestMethod)
	{
		case "logOutUser":
			
		break;	
		
		default:
		
		break;
		
	}
	
}
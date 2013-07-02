
var publisherWidth = 220;
var publisherHeight = 165;
var subscriberWidth = 640;
var subscriberHeight = 480;
	
var apiKey = null;
var publisher = null;
var session = null;
var publisherName = null;

function initOpenTokUserMeeting(publicApiKey, sessionId, token, publisherFullName){
	
	apiKey = publicApiKey;
	publisherName = publisherFullName;
	
	TB.addEventListener("exception", exceptionHandler);
	
	session = TB.initSession(sessionId); 
	session.addEventListener("sessionConnected", sessionConnectedHandler);
	session.addEventListener("streamCreated", streamCreatedHandler);
	session.addEventListener("streamDestroyed", streamDestroyedHandler);
	
	session.addEventListener("connectionCreated", connectionCreatedHandler);
	session.addEventListener("connectionDestroyed", connectionDestroyedHandler);
	
	session.connect(apiKey, token);
}

///////////////////////////////////////////// HANDLERS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

function exceptionHandler(event) {
	alert(event.message);
}

function sessionConnectedHandler(event) {
	
	if(event.connections.length > 1) { //Ya hay un usuario suscrito a la sesión
		$("#subscriberConnectionWaitingAlert").hide();	
		$("#subscriberStreamWaitingAlert").show();		
	}
	
	subscribeToStreams(event.streams);
	
	//Se crea el publisher para poder definir sus propiedades
	var publisherProperties = {width:publisherWidth, height:publisherHeight, name:publisherName, style:{nameDisplayMode:"auto"}};
	
	publisher = TB.initPublisher(apiKey, "publisherStream", publisherProperties);
	
	session.publish(publisher);
}

function streamCreatedHandler(event) {
	subscribeToStreams(event.streams);
}


// A esta función se llama cuando un usuario deja de publicar
function streamDestroyedHandler(event) {
	
	event.preventDefault();
	
	for (var i = 0; i < event.streams.length; i++) {
		var stream = event.streams[i];
		
		//alert("Stream " + stream.name + " ended. " + event.reason);
		
		//unsubscribe(stream);
		
		var subscribers = session.getSubscribersForStream(stream);
		for (var i = 0; i < subscribers.length; i++) {
			
			if(subscribers[i] != null) {
						
				if(subscribers[i].stream.connection.connectionId != session.connection.connectionId){
					session.unsubscribe(subscribers[i]);
					
					$("#subscriberStreamWaitingAlert").show();	
				}
			}
		}
		
	}
}

function connectionCreatedHandler(event) {

   var connections = event.connections;
   
   for (var i = 0; i < connections.length; i++) {
			
		if(connections[i] != null) {
					
			if(connections[i].connectionId != session.connection.connectionId){
				$("#subscriberConnectionWaitingAlert").hide();	
				$("#subscriberStreamWaitingAlert").show();	
			}
		}
	}
   
}

function connectionDestroyedHandler(event) {
	
	var connections = event.connections;
   
	for (var i = 0; i < connections.length; i++) {
			
		if(connections[i] != null) {
					
			if(connections[i].connectionId != session.connection.connectionId){
				$("#subscriberConnectionWaitingAlert").show();	
				$("#subscriberStreamWaitingAlert").hide();	
			}
		}
	}
}

/////////////////////////////////////////// END  HANDLERS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

function subscribeToStreams(streams) {
	
	for (var i = 0; i < streams.length; i++) {
		var stream = streams[i];
		if (stream.connection.connectionId != session.connection.connectionId) {
			displaySubscriberStream(stream);
		}
	}
}

function displaySubscriberStream(stream) {
	
	//alert("displayPublisherSream");		
	$("#subscriberStreamWaitingAlert").hide();
	$("#subscriberConnectionWaitingAlert").hide();	
	
	//Se definen las propiedades del subscriber
	var subscriberProps = {width:subscriberWidth, height:subscriberHeight, subscribeToAudio: true};
	//session.subscribe(stream, "subscriberStream", subscriberProps);
	
	var div = document.createElement('div');
	div.setAttribute('id', 'stream' + stream.streamId);

	var streamsContainer = document.getElementById('streamsContainer');
	streamsContainer.appendChild(div);

	session.subscribe(stream, 'stream' + stream.streamId, subscriberProps);		
}



function unpublish(){
	$("#unpublishButton").hide();
	$("#publishButton").show();
	
	session.unpublish(publisher);
}

function publish(){
	$("#publishButton").hide();
	$("#unpublishButton").show();
	
	session.publish(publisher);
}

function stopPublishVideo(){
	$("#stopVideoButton").hide();
	$("#startVideoButton").show();		
	
	publisher.publishVideo(false);
	
	$("#publisherNoStreamAlert").show();
	$("#publisherStream").hide();
}

function startPublishVideo(){
	$("#startVideoButton").hide();
	$("#stopVideoButton").show();		
	
	$("#publisherStream").show();
	$("#publisherNoStreamAlert").hide();
	
	publisher.publishVideo(true);
}

function stopPublishAudio(){
	$("#stopAudioButton").hide();
	$("#startAudioButton").show();		
	
	publisher.publishAudio(false);
}

function startPublishAudio(){
	$("#startAudioButton").hide();
	$("#stopAudioButton").show();		
	
	publisher.publishAudio(true);
	
}
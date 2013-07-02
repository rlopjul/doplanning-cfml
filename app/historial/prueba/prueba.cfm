<!DOCTYPE HTML>
<html>
<head>
<title>Prueba OpentTok</title>
<meta http-equiv="X-UA-Compatible" content="chrome=1">
<!---<script src="http://static.opentok.com/webrtc/v2.0/js/TB.min.js" type="text/javascript" charset="utf-8"></script>--->
<script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js"></script>
<script src="https://swww.tokbox.com/webrtc/v2.0/js/TB.min.js"></script>
<script type="text/javascript" charset="utf-8">
	
	var apiKey = "28563472"; 
	var sessionId = "1_MX4yODU2MzQ3Mn4xMjcuMC4wLjF-VGh1IE1heSAwOSAwMDo1NzoxNCBQRFQgMjAxM34wLjU0NDYyOTJ-"; 
	var token = "T1==cGFydG5lcl9pZD0yODU2MzQ3MiZzZGtfdmVyc2lvbj10YnJ1YnktdGJyYi12MC45MS4yMDExLTAyLTE3JnNpZz03YTllM2E2OTMwNGNmYmJjYzQ1YmQ5YzJiZDU3OTEzYWU3ZTdhZTEyOnJvbGU9cHVibGlzaGVyJnNlc3Npb25faWQ9MV9NWDR5T0RVMk16UTNNbjR4TWpjdU1DNHdMakYtVkdoMUlFMWhlU0F3T1NBd01EbzFOem94TkNCUVJGUWdNakF4TTM0d0xqVTBORFl5T1RKLSZjcmVhdGVfdGltZT0xMzY4MTczMTcwJm5vbmNlPTAuOTE4NzU1MzAwOTM5ODEzNiZleHBpcmVfdGltZT0xMzcwNzY1MTY1JmNvbm5lY3Rpb25fZGF0YT0=";
	
	var publisherWidth = 220;
	var publisherHeight = 165;
	var subscriberWidth = 640;
	var subscriberHeight = 480;
	
	var publisher = null;

	TB.addEventListener("exception", exceptionHandler);
	
	var session = TB.initSession(sessionId); 
	session.addEventListener("sessionConnected", sessionConnectedHandler);
	session.addEventListener("streamCreated", streamCreatedHandler);
	session.addEventListener("streamDestroyed", streamDestroyedHandler);
	
	session.connect(apiKey, token); 

	function sessionConnectedHandler(event) {
		 subscribeToStreams(event.streams);
		 
		 //Se inicia el publisher para poder definir sus propiedades
		 var publisherProperties = {width:publisherWidth, height:publisherHeight, name:"Usuario", style:{nameDisplayMode:"auto"}};
		 
		 publisher = TB.initPublisher(apiKey, "publisherStream", publisherProperties);
		 
		 session.publish(publisher);
	}
	
	function streamCreatedHandler(event) {
		subscribeToStreams(event.streams);
	}
	
	
	function subscribeToStreams(streams) {
		
		for (var i = 0; i < streams.length; i++) {
			var stream = streams[i];
			if (stream.connection.connectionId != session.connection.connectionId) {
				//session.subscribe(stream, "receiverStream", subscriberProps);
				displaySubscriberStream(stream);
			}
		}
	}
	
	function exceptionHandler(event) {
		alert(event.message);
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
							
					if(subscribers[i].stream.connection.connectionId != session.connection.connectionId)
						session.unsubscribe(subscribers[i]);
				}
			}
			
		}
	}
	
	/*function unsubscribe(stream) {
		var subscribers = session.getSubscribersForStream(stream);
		for (var i = 0; i < subscribers.length; i++) {
			
			if(subscribers[i] != null) {
						
				//alert("Connection id desconectado: "+subscribers[i].stream.connection.connectionId+" Connection id conectado: "+session.connection.connectionId);
			
				if(subscribers[i].stream.connection.connectionId != session.connection.connectionId){
					session.unsubscribe(subscribers[i]);
				}
			}
		}
	}*/
	
	function displaySubscriberStream(stream) {
		
		//alert("displayPublisherSream");
		
		//Se definen las propiedades del subscriber
		//var subscriberProps = {width:220, height: 165, subscribeToAudio: true};
		
		var subscriberProps = {width:subscriberWidth, height:subscriberHeight, subscribeToAudio: true};
		session.subscribe(stream, "subscriberStream", subscriberProps);
		
		/*var div = document.createElement('div');
		div.setAttribute('id', 'stream' + stream.streamId);
		
		var streamsContainer = document.getElementById('streamsContainer');
		streamsContainer.appendChild(div);
		
		var divProps = {width: 400, height:300, audioEnabled:true};			
		subscriber = session.subscribe(stream, 'stream' + stream.streamId, divProps);*/
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
	
</script>
</head>

<body>
<div style="float:left;" id="subscriberStream"></div>

<div style="float:right; text-align:right">
	<div id="publisherStream"></div>
	<button onClick="unpublish()" id="unpublishButton">Dejar de publicar</button>
	<button onClick="publish()" id="publishButton" style="display:none">Publicar</button>
</div>

</body>
</html>

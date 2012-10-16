<cfswitch expression="#itemTypeId#"> 
	
	<cfcase value="1"><!---messages--->

		<cfset itemTypeName = "message">
		<cfset itemTypeNameU = "Message">
		<cfset itemTypeNameP = "messages">
		
		<cfset itemTypeNameEs = "Mensaje">
		<cfset itemTypeNameEsP = "Mensajes">

		<cfset itemTypeGender = "male">
	
   	</cfcase> 
	
	<cfcase value="2"><!---entries--->

		<cfset itemTypeName = "entry">
		<cfset itemTypeNameU = "Entry">
		<cfset itemTypeNameP = "entries">
		
		<cfset itemTypeNameEs = "Entrada">
		<cfset itemTypeNameEsP = "Entradas">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 
	
	<cfcase value="3"><!---links--->

		<cfset itemTypeName = "link">
		<cfset itemTypeNameU = "Link">
		<cfset itemTypeNameP = "links">
		
		<cfset itemTypeNameEs = "Enlace">
		<cfset itemTypeNameEsP = "Enlaces">

		<cfset itemTypeGender = "male">
	
   	</cfcase>
	
	<cfcase value="4"><!---news--->

		<cfset itemTypeName = "news">
		<cfset itemTypeNameU = "News">
		<cfset itemTypeNameP = "newss">
		
		<cfset itemTypeNameEs = "Noticia">
		<cfset itemTypeNameEsP = "Noticias">

		<cfset itemTypeGender = "female">
	
   	</cfcase>
	
	<cfcase value="5"><!---events--->

		<cfset itemTypeName = "event">
		<cfset itemTypeNameU = "Event">
		<cfset itemTypeNameP = "Events">
		
		<cfset itemTypeNameEs = "Evento">
		<cfset itemTypeNameEsP = "Eventos">

		<cfset itemTypeGender = "male">
	
   	</cfcase> 
	
	<cfcase value="6"><!---tasks--->

		<cfset itemTypeName = "task">
		<cfset itemTypeNameU = "Task">
		<cfset itemTypeNameP = "Tasks">
		
		<cfset itemTypeNameEs = "Tarea">
		<cfset itemTypeNameEsP = "Tareas">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 
	
</cfswitch>
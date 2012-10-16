<cfswitch expression="#itemTypeId#"> 
	
	<cfcase value="1"><!---messages--->
		
		<cfset itemTypeName = "message">
		<cfset itemTypeNameU = "Message">
		<cfset itemTypeNameP = "messages">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Mensaje">
		
		<cfset itemTypeGender = "male">
	
   	</cfcase> 
	
	<cfcase value="2"><!---entries--->

		<cfset itemTypeName = "entry">
		<cfset itemTypeNameU = "Entry">
		<cfset itemTypeNameP = "entries">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Entrada">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 
	
	<cfcase value="3"><!---links--->

		<cfset itemTypeName = "link">
		<cfset itemTypeNameU = "Link">
		<cfset itemTypeNameP = "links">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Enlace">

		<cfset itemTypeGender = "male">
	
   	</cfcase> 
	
	<cfcase value="4"><!---news--->

		<cfset itemTypeName = "news">
		<cfset itemTypeNameU = "News">
		<cfset itemTypeNameP = "newss">
		<cfset itemTypeTable = "news">
		
		<cfset itemTypeNameEs = "Noticia">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 

	<cfcase value="5"><!---events--->

		<cfset itemTypeName = "event">
		<cfset itemTypeNameU = "Event">
		<cfset itemTypeNameP = "events">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Evento">

		<cfset itemTypeGender = "male">
	
   	</cfcase>
	
	<cfcase value="6"><!---tasks--->

		<cfset itemTypeName = "task">
		<cfset itemTypeNameU = "Tarea">
		<cfset itemTypeNameP = "tasks">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Tarea">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 

</cfswitch>
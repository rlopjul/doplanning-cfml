<cfswitch expression="#itemTypeId#"> 
	
	<cfcase value="1"><!---messages--->
		
		<cfset itemTypeName = "message">
		<!---<cfset itemTypeNameU = "Message">--->
		<cfset itemTypeNameP = "messages">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Mensaje">
		
		<cfset itemTypeGender = "male">
	
   	</cfcase> 
	
	<cfcase value="2"><!---entries--->

		<cfset itemTypeName = "entry">
		<!---<cfset itemTypeNameU = "Entry">--->
		<cfset itemTypeNameP = "entries">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Elemento de contenido web">

		<cfset itemTypeGender = "male">
	
   	</cfcase> 
	
	<cfcase value="3"><!---links--->

		<cfset itemTypeName = "link">
		<!---<cfset itemTypeNameU = "Link">--->
		<cfset itemTypeNameP = "links">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Enlace">

		<cfset itemTypeGender = "male">
	
   	</cfcase> 
	
	<cfcase value="4"><!---news--->

		<cfset itemTypeName = "news">
		<!---<cfset itemTypeNameU = "News">--->
		<cfset itemTypeNameP = "newss">
		<cfset itemTypeTable = "news">
		
		<cfset itemTypeNameEs = "Noticia">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 

	<cfcase value="5"><!---events--->

		<cfset itemTypeName = "event">
		<!---<cfset itemTypeNameU = "Event">--->
		<cfset itemTypeNameP = "events">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Evento">

		<cfset itemTypeGender = "male">
	
   	</cfcase>
	
	<cfcase value="6"><!---tasks--->

		<cfset itemTypeName = "task">
		<!---<cfset itemTypeNameU = "Task">--->
		<cfset itemTypeNameP = "tasks">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Tarea">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 
	
	<cfcase value="7"><!---consultations--->

		<cfset itemTypeName = "consultation">
		<!---<cfset itemTypeNameU = "Consultation">--->
		<cfset itemTypeNameP = "consultations">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Interconsulta">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 



   	<cfcase value="11"><!---lists--->

		<cfset itemTypeName = "list">
		<cfset itemTypeNameP = "lists">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Listas">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 

   	<cfcase value="12"><!---attributes--->

		<cfset itemTypeName = "attribute">
		<cfset itemTypeNameP = "attributes">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Tipología">

		<cfset itemTypeGender = "female">
	
   	</cfcase>

</cfswitch>
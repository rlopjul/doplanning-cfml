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
		<cfset itemTypeNameP = "tasks">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Tarea">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 
	
	<cfcase value="7"><!---consultations--->

		<cfset itemTypeName = "consultation">
		<cfset itemTypeNameP = "consultations">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Interconsulta">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 


   	<cfcase value="8"><!---pubmed article--->

		<cfset itemTypeName = "pubmed">
		<cfset itemTypeNameP = "pubmeds">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Comentario de artículo PubMed">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 
	
	<cfcase value="9"><!---images--->

		<cfset itemTypeName = "image">
		<cfset itemTypeNameP = "images">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Image">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 


   	<cfcase value="11"><!---lists--->

		<cfset itemTypeName = "list">
		<cfset itemTypeNameP = "lists">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Lista">

		<cfset itemTypeGender = "female">

		<cfset tableTypeId = 1>
	
   	</cfcase> 

   	<cfcase value="12"><!---forms--->

		<cfset itemTypeName = "form">
		<cfset itemTypeNameP = "forms">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Formulario">

		<cfset itemTypeGender = "male">

		<cfset tableTypeId = 2>
	
   	</cfcase>

   	 <cfcase value="13"><!---typologies (files)--->

		<cfset itemTypeName = "typology">
		<cfset itemTypeNameP = "typologies">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Tipología">

		<cfset itemTypeGender = "female">

		<cfset tableTypeId = 3>
	
   	</cfcase>

</cfswitch>
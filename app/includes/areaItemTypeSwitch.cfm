<cfswitch expression="#itemTypeId#"> 
	
	<cfcase value="1"><!---messages--->
		
		<cfset itemTypeName = "message">
		<cfset itemTypeNameP = "messages">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Mensaje">
		
		<cfset itemTypeGender = "male">
		<cfset itemTypeWeb = false>

   	</cfcase> 
	
	<cfcase value="2"><!---entries--->

		<cfset itemTypeName = "entry">
		<cfset itemTypeNameP = "entries">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Elemento de contenido web">

		<cfset itemTypeGender = "male">
		<cfset itemTypeWeb = true>
	
   	</cfcase> 
	
	<cfcase value="3"><!---links--->

		<cfset itemTypeName = "link">
		<cfset itemTypeNameP = "links">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Enlace">

		<cfset itemTypeGender = "male">
		<cfset itemTypeWeb = true>
	
   	</cfcase> 
	
	<cfcase value="4"><!---news--->

		<cfset itemTypeName = "news">
		<cfset itemTypeNameP = "newss">
		<cfset itemTypeTable = "news">
		
		<cfset itemTypeNameEs = "Noticia">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = true>
	
   	</cfcase> 

	<cfcase value="5"><!---events--->

		<cfset itemTypeName = "event">
		<cfset itemTypeNameP = "events">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Evento">

		<cfset itemTypeGender = "male">	
		<cfset itemTypeWeb = true>
	
   	</cfcase>
	
	<cfcase value="6"><!---tasks--->

		<cfset itemTypeName = "task">
		<cfset itemTypeNameP = "tasks">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Tarea">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = false>
	
   	</cfcase> 
	
	<cfcase value="7"><!---consultations--->

		<cfset itemTypeName = "consultation">
		<cfset itemTypeNameP = "consultations">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Interconsulta">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = false>
	
   	</cfcase> 

   	<cfcase value="8"><!---pubmed article--->

		<cfset itemTypeName = "pubmed">
		<cfset itemTypeNameP = "pubmeds">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Comentario de artículo PubMed">

		<cfset itemTypeGender = "male">
		<cfset itemTypeWeb = true>
	
   	</cfcase> 
	
	<cfcase value="9"><!---images--->

		<cfset itemTypeName = "image">
		<cfset itemTypeNameP = "images">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Imagen">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = true>

   	</cfcase> 

	<cfcase value="10"><!---files--->

		<cfset itemTypeName = "file">
		<cfset itemTypeNameP = "files">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Archivo">

		<cfset itemTypeGender = "male">
	
   	</cfcase> 

   	<cfcase value="11"><!---lists--->

		<cfset itemTypeName = "list">
		<cfset itemTypeNameP = "lists">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Lista">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = true>

		<cfset tableTypeId = 1>
	
   	</cfcase> 

   	<cfcase value="12"><!---forms--->

		<cfset itemTypeName = "form">
		<cfset itemTypeNameP = "forms">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Formulario">

		<cfset itemTypeGender = "male">
		<cfset itemTypeWeb = true>

		<cfset tableTypeId = 2>
	
   	</cfcase>

   	<cfcase value="13"><!---typologies (files)--->

		<cfset itemTypeName = "typology">
		<cfset itemTypeNameP = "typologies">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Tipología">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = false>

		<cfset tableTypeId = 3>

   	</cfcase>

   	<!---
   	<cfcase value="15"><!---Files edited--->

		<cfset itemTypeName = "file_edited">
		<cfset itemTypeNameP = "files_edited">
		<cfset itemTypeTable = itemTypeNameP&"_edited">
		
		<cfset itemTypeNameEs = "Archivo en edición">

		<cfset itemTypeGender = "male">
	
   	</cfcase>--->

</cfswitch>
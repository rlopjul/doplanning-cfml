<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

<!---
<cfswitch expression="#itemTypeId#"> 
	
	<cfcase value="1"><!---messages--->

		<cfset itemTypeName = "message">
		<!--- <cfset itemTypeNameU = "Message"> --->
		<cfset itemTypeNameP = "messages">
		
		<cfset itemTypeNameEs = "Mensaje">
		<cfset itemTypeNameEsP = "Mensajes">

		<cfset itemTypeGender = "male">
	
   	</cfcase> 
	
	<cfcase value="2"><!---entries--->

		<cfset itemTypeName = "entry">
		<!--- <cfset itemTypeNameU = "Entry"> --->
		<cfset itemTypeNameP = "entries">
		
		<cfset itemTypeNameEs = "Elemento de contenido genérico">
		<cfset itemTypeNameEsP = "Elementos de contenido genérico">

		<cfset itemTypeGender = "male">
	
   	</cfcase> 
	
	<cfcase value="3"><!---links--->

		<cfset itemTypeName = "link">
		<!--- <cfset itemTypeNameU = "Link"> --->
		<cfset itemTypeNameP = "links">
		
		<cfset itemTypeNameEs = "Enlace">
		<cfset itemTypeNameEsP = "Enlaces">

		<cfset itemTypeGender = "male">
	
   	</cfcase>
	
	<cfcase value="4"><!---news--->

		<cfset itemTypeName = "news">
		<!--- <cfset itemTypeNameU = "News"> --->
		<cfset itemTypeNameP = "newss">
		
		<cfset itemTypeNameEs = "Noticia">
		<cfset itemTypeNameEsP = "Noticias">

		<cfset itemTypeGender = "female">
	
   	</cfcase>
	
	<cfcase value="5"><!---events--->

		<cfset itemTypeName = "event">
		<!--- <cfset itemTypeNameU = "Event"> --->
		<cfset itemTypeNameP = "events">
		
		<cfset itemTypeNameEs = "Evento">
		<cfset itemTypeNameEsP = "Eventos">

		<cfset itemTypeGender = "male">
	
   	</cfcase> 
	
	<cfcase value="6"><!---tasks--->

		<cfset itemTypeName = "task">
		<!--- <cfset itemTypeNameU = "Task"> --->
		<cfset itemTypeNameP = "tasks">
		
		<cfset itemTypeNameEs = "Tarea">
		<cfset itemTypeNameEsP = "Tareas">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 
	
	<cfcase value="7"><!---consultations--->

		<cfset itemTypeName = "consultation">
		<!--- <cfset itemTypeNameU = "Consultation"> --->
		<cfset itemTypeNameP = "consultations">
		
		<cfset itemTypeNameEs = "Interconsulta">
		<cfset itemTypeNameEsP = "Interconsultas">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 

   	<cfcase value="8"><!---pubmed article--->

		<cfset itemTypeName = "pubmed">
		<!--- <cfset itemTypeNameU = "PubMed"> --->
		<cfset itemTypeNameP = "pubmeds">
		
		<cfset itemTypeNameEs = "Comentario de artículo PubMed">
		<cfset itemTypeNameEsP = "Comentarios de artículos PubMed">

		<cfset itemTypeGender = "male">
	
   	</cfcase> 
	
	<cfcase value="9"><!---images--->

		<cfset itemTypeName = "image">
		<!--- <cfset itemTypeNameU = "Image"> --->
		<cfset itemTypeNameP = "images">
		
		<cfset itemTypeNameEs = "Imagen">
		<cfset itemTypeNameEsP = "Imágenes">

		<cfset itemTypeGender = "female">
	
   	</cfcase> 

	<cfcase value="10"><!---files--->

		<cfset itemTypeName = "file">
		<!--- <cfset itemTypeNameU = "File"> --->
		<cfset itemTypeNameP = "files">
		
		<cfset itemTypeNameEs = "Archivo">
		<cfset itemTypeNameEsP = "Archivos">

		<cfset itemTypeGender = "male">
	
   	</cfcase> 

   	<cfcase value="11"><!---lists--->

		<cfset itemTypeName = "list">
		<!---<cfset itemTypeNameU = "List">--->
		<cfset itemTypeNameP = "lists">
		
		<cfset itemTypeNameEs = "Lista">
		<cfset itemTypeNameEsP = "Listas">

		<cfset itemTypeGender = "female">
		
		<cfset tableTypeId = 1>

   	</cfcase> 

   	<cfcase value="12"><!---forms--->

		<cfset itemTypeName = "form">
		<!---<cfset itemTypeNameU = "Form">--->
		<cfset itemTypeNameP = "forms">
		
		<cfset itemTypeNameEs = "Formulario">
		<cfset itemTypeNameEsP = "Formularios">

		<cfset itemTypeGender = "male">

		<cfset tableTypeId = 2>
	
   	</cfcase> 

   	<cfcase value="13"><!---typologies--->

		<cfset itemTypeName = "typology">
		<!---<cfset itemTypeNameU = "Typology">--->
		<cfset itemTypeNameP = "typologies">
		
		<cfset itemTypeNameEs = "Tipología">
		<cfset itemTypeNameEsP = "Tipologías">

		<cfset itemTypeGender = "female">

		<cfset tableTypeId = 3>
	
   	</cfcase> 


   	<!---
   	<cfcase value="15"><!---files edited--->

		<cfset itemTypeName = "file_edited">
		<cfset itemTypeNameP = "files_edited">
		
		<cfset itemTypeNameEs = "Archivo en edición">
		<cfset itemTypeNameEsP = "Archivos en edición">

		<cfset itemTypeGender = "male">
	
   	</cfcase>---> 

</cfswitch>--->
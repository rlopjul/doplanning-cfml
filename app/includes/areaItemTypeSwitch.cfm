<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypeStruct" returnvariable="itemTypeStruct">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>

<cfset itemTypeName = itemTypeStruct.name>
<cfset itemTypeNameP = itemTypeStruct.namePlural>
<cfset itemTypeTable = itemTypeStruct.table>

<cfset itemTypeNameEs = itemTypeStruct.label>
<cfset itemTypeNameEsP = itemTypeStruct.labelPlural>

<cfset itemTypeGender = itemTypeStruct.gender>
<cfset itemTypeWeb = itemTypeStruct.web>
<cfset itemTypeNoWeb = itemTypeStruct.noWeb>

<cfif itemTypeId GT 10 AND itemTypeId LT 17>
	<cfset tableTypeId = itemTypeStruct.tableTypeId>
	<cfif itemTypeId IS 14 OR itemTypeId IS 15>
		<cfset tableTypeName = itemTypeStruct.tableTypeName>
	</cfif>
</cfif>

<!---
<cfswitch expression="#itemTypeId#"> 
	
	<cfcase value="1"><!---messages--->
		
		<cfset itemTypeName = "message">
		<cfset itemTypeNameP = "messages">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Mensaje">
		<cfset itemTypeNameEsP = "Mensajes">
		
		<cfset itemTypeGender = "male">
		<cfset itemTypeWeb = false>
		<cfset itemTypeNoWeb = true>

   	</cfcase> 
	
	<cfcase value="2"><!---entries--->

		<cfset itemTypeName = "entry">
		<cfset itemTypeNameP = "entries">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Elemento web">
		<cfset itemTypeNameEsP = "Elementos de contenido genérico">

		<cfset itemTypeGender = "male">
		<cfset itemTypeWeb = true>
		<cfset itemTypeNoWeb = false>
	
   	</cfcase> 
	
	<cfcase value="3"><!---links--->

		<cfset itemTypeName = "link">
		<cfset itemTypeNameP = "links">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Enlace">
		<cfset itemTypeNameEsP = "Enlaces">

		<cfset itemTypeGender = "male">
		<cfset itemTypeWeb = true>
		<cfset itemTypeNoWeb = false>
	
   	</cfcase> 
	
	<cfcase value="4"><!---news--->

		<cfset itemTypeName = "news">
		<cfset itemTypeNameP = "newss">
		<cfset itemTypeTable = "news">
		
		<cfset itemTypeNameEs = "Noticia">
		<cfset itemTypeNameEsP = "Noticias">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = true>
		<cfset itemTypeNoWeb = false>
	
   	</cfcase> 

	<cfcase value="5"><!---events--->

		<cfset itemTypeName = "event">
		<cfset itemTypeNameP = "events">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Evento">
		<cfset itemTypeNameEsP = "Eventos">

		<cfset itemTypeGender = "male">	
		<cfset itemTypeWeb = true>
		<cfset itemTypeNoWeb = true>
	
   	</cfcase>
	
	<cfcase value="6"><!---tasks--->

		<cfset itemTypeName = "task">
		<cfset itemTypeNameP = "tasks">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Tarea">
		<cfset itemTypeNameEsP = "Tareas">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = false>
		<cfset itemTypeNoWeb = true>
	
   	</cfcase> 
	
	<cfcase value="7"><!---consultations--->

		<cfset itemTypeName = "consultation">
		<cfset itemTypeNameP = "consultations">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Consulta">
		<cfset itemTypeNameEsP = "Consultas">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = false>
		<cfset itemTypeNoWeb = true>
	
   	</cfcase> 

   	<cfcase value="8"><!---pubmed article--->

		<cfset itemTypeName = "pubmed">
		<cfset itemTypeNameP = "pubmeds">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Publicación">
		<cfset itemTypeNameEsP = "Publicaciones">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = true>
		<cfset itemTypeNoWeb = true>
	
   	</cfcase> 
	
	<cfcase value="9"><!---images--->

		<cfset itemTypeName = "image">
		<cfset itemTypeNameP = "images">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Imagen">
		<cfset itemTypeNameEsP = "Imágenes">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = true>
		<cfset itemTypeNoWeb = false>

   	</cfcase> 

	<cfcase value="10"><!---files--->

		<cfset itemTypeName = "file">
		<cfset itemTypeNameP = "files">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Archivo">
		<cfset itemTypeNameEsP = "Archivos">

		<cfset itemTypeGender = "male">
		<cfset itemTypeWeb = true>
		<cfset itemTypeNoWeb = true>
	
   	</cfcase> 

   	<cfcase value="11"><!---lists--->

		<cfset itemTypeName = "list">
		<cfset itemTypeNameP = "lists">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Lista">
		<cfset itemTypeNameEsP = "Listas">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = true>
		<cfset itemTypeNoWeb = true>

		<cfset tableTypeId = 1>
	
   	</cfcase> 

   	<cfcase value="12"><!---forms--->

		<cfset itemTypeName = "form">
		<cfset itemTypeNameP = "forms">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Formulario">
		<cfset itemTypeNameEsP = "Formularios">

		<cfset itemTypeGender = "male">
		<cfset itemTypeWeb = true>
		<cfset itemTypeNoWeb = true>

		<cfset tableTypeId = 2>
	
   	</cfcase>

   	<cfcase value="13"><!---typologies (files)--->

		<cfset itemTypeName = "typology">
		<cfset itemTypeNameP = "typologies">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Tipología">
		<cfset itemTypeNameEsP = "Tipologías">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = false>
		<cfset itemTypeNoWeb = true>

		<cfset tableTypeId = 3>

   	</cfcase>


   	<cfcase value="14"><!---lists views--->

		<cfset itemTypeName = "list_view">
		<cfset itemTypeNameP = "lists_views">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Vista de Lista">
		<cfset itemTypeNameEsP = "Vistas de Listas">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = true>
		<cfset itemTypeNoWeb = true>

		<cfset tableTypeId = 1>
		<cfset tableTypeName = "list">
	
   	</cfcase> 

   	<cfcase value="15"><!---forms views--->

		<cfset itemTypeName = "form_view">
		<cfset itemTypeNameP = "forms_views">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Vista de Formulario">
		<cfset itemTypeNameEsP = "Vistas de Formularios">

		<cfset itemTypeGender = "male">
		<cfset itemTypeWeb = true>
		<cfset itemTypeNoWeb = true>

		<cfset tableTypeId = 2>
		<cfset tableTypeName = "form">
	
   	</cfcase>

   	<!--- 
   	<cfcase value="16"><!---typologies views--->
   	
		<cfset itemTypeName = "typology_view">
		<cfset itemTypeNameP = "typologies_views">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Vista de Tipología">
		<cfset itemTypeNameEsP = "Vistas de Tipologías">

		<cfset itemTypeGender = "female">
		<cfset itemTypeWeb = false>
		<cfset itemTypeNoWeb = true>

		<cfset tableTypeId = 3>
		<cfset tableTypeName = "typology">
   	
   	</cfcase> --->

   	<cfcase value="20"><!---DoPlanning Document--->
   	
		<cfset itemTypeName = "dp_document">
		<cfset itemTypeNameP = "dp_documents">
		<cfset itemTypeTable = itemTypeNameP>
		
		<cfset itemTypeNameEs = "Documento DoPlanning">
		<cfset itemTypeNameEsP = "Documentos DoPlanning">

		<cfset itemTypeGender = "male">
		<cfset itemTypeWeb = false>
		<cfset itemTypeNoWeb = true>
   	
   	</cfcase>

</cfswitch>

--->
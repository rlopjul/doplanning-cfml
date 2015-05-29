<cfset curElement = "">

<cfset curPage = getFileFromPath(CGI.SCRIPT_NAME)>

<cfswitch expression="#curPage#">
	<cfcase value="messages_search.cfm">
		<cfset curElement = "messages">
		<cfset curTitle = "Mensajes">
	</cfcase>
	
	<cfcase value="entries_search.cfm">
		<cfset curElement = "entries">
		<cfset curTitle = "Elementos de contenido genérico">
	</cfcase>
	
	<cfcase value="links_search.cfm">
		<cfset curElement = "links">
		<cfset curTitle = "Enlaces">
	</cfcase>
	
	<cfcase value="newss_search.cfm">
		<cfset curElement = "news">
		<cfset curTitle = "Noticias">
	</cfcase>
	
	<cfcase value="events_search.cfm">
		<cfset curElement = "events">
		<cfset curTitle = "Eventos">
	</cfcase>
	
	<cfcase value="tasks_search.cfm">
		<cfset curElement = "tasks">
		<cfset curTitle = "Tareas">
	</cfcase>
	
	<cfcase value="files_search.cfm">
		<cfset curElement = "files">
		<cfset curTitle = "Archivos">
	</cfcase>
	
	<cfcase value="users_search.cfm">
		<cfset curElement = "users">
		<cfset curTitle = "Usuarios">
	</cfcase>
	
	<cfcase value="consultations_search.cfm">
		<cfset curElement = "consultations">
		<cfset curTitle = "Consultas">
	</cfcase>

	<cfcase value="pubmeds_search.cfm">
		<cfset curElement = "pubmeds">
		<cfset curTitle = "Publicaciones">
	</cfcase>

	<cfcase value="images_search.cfm">
		<cfset curElement = "images">
		<cfset curTitle = "Imágenes">
	</cfcase>

	<cfcase value="lists_search.cfm">
		<cfset curElement = "lists">
		<cfset curTitle = "Listas">
	</cfcase>

	<cfcase value="forms_search.cfm">
		<cfset curElement = "forms">
		<cfset curTitle = "Formularios">
	</cfcase>
	
	<cfcase value="dp_documents_search.cfm">
		<cfset curElement = "dp_documents">
		<cfset curTitle = "Documentos de Doplanning">
	</cfcase>

	<cfcase value="areas_search.cfm">
		<cfset curElement = "areas">
		<cfset curTitle = "Áreas">
	</cfcase>

</cfswitch>

<cfoutput>
<!---<div style="clear:both"></div>--->
<div style="height:4px; clear:both;"><!-- --></div>
</cfoutput>
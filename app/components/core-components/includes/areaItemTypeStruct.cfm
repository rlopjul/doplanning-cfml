<!---Este include NO se debe usar directamente, se debe usar sólo el método getAreaItemTypes del componente AreaItemManager--->

<!---messages--->
<cfset structInsert(itemTypesStruct, 1, {id=1, position=1, name="message", namePlural="messages", table="messages", label="Mensaje", labelPlural="Mensajes", gender="male", web=false, noWeb=true, showInSelect=true})>

<!---entries--->
<cfset structInsert(itemTypesStruct, 2, {id=2, position=2, name="entry", namePlural="entries", table="entries", label="Elemento web", labelPlural="Elementos web", gender="male", web=true, noWeb=false, showInSelect=true})>

<cfif APPLICATION.identifier EQ "vpnet">
	<!---links--->
	<cfset structInsert(itemTypesStruct, 3, {id=3, position=4, name="link", namePlural="links", table="links", label="Enlace", labelPlural="Enlaces", gender="male", web=true, noWeb=false, showInSelect=true})>
</cfif>

<!---news--->
<cfset structInsert(itemTypesStruct, 4, {id=4, position=3, name="news", namePlural="newss", table="news", label="Noticia", labelPlural="Noticias", gender="female", web=true, noWeb=false, showInSelect=true})>

<!---events--->
<cfset structInsert(itemTypesStruct, 5, {id=5, position=8, name="event", namePlural="events", table="events", label="Evento", labelPlural="Eventos", gender="male", web=true, noWeb=true, showInSelect=true})>

<!---tasks--->
<cfset structInsert(itemTypesStruct, 6, {id=6, position=9, name="task", namePlural="tasks", table="tasks",  label="Tarea", labelPlural="Tareas", gender="female", web=false, noWeb=true, showInSelect=true})>

<!---consultations--->
<cfset structInsert(itemTypesStruct, 7, {id=7, position=13, name="consultation", namePlural="consultations", table="consultations", label="Consulta", labelPlural="Consultas", gender="female", web=false, noWeb=true, showInSelect=true})>

<cfif APPLICATION.modulePubMedComments IS true>
	<!---publications--->
	<cfset structInsert(itemTypesStruct, 8, {id=8, position=14, name="pubmed", namePlural="pubmeds", table="pubmeds", label="Publicación", labelPlural="Publicaciones", gender="female", web=true, noWeb=true, showInSelect=true})>
</cfif>

<!---images--->
<cfset structInsert(itemTypesStruct, 9, {id=9, position=5, name="image", namePlural="images", table="images", label="Imagen", labelPlural="Imágenes", gender="female", web=true, noWeb=false, showInSelect=true})>

<!---files--->
<cfset structInsert(itemTypesStruct, 10, {id=10, position=6, name="file", namePlural="files", table="files", label="Archivo", labelPlural="Archivos", gender="male", web=true, noWeb=true, showInSelect=true})>

<!---lists--->
<cfset structInsert(itemTypesStruct, 11, {id=11, position=10, name="list", namePlural="lists", table="lists", label="Lista", labelPlural="Listas", gender="female", web=true, noWeb=true, showInSelect=true, tableTypeId=1})>

<!---forms--->
<cfset structInsert(itemTypesStruct, 12, {id=12, position=11, name="form", namePlural="forms", table="forms", label="Formulario", labelPlural="Formularios", gender="male", web=true, noWeb=true, showInSelect=true, tableTypeId=2})>

<!---typologies (files)--->
<cfset structInsert(itemTypesStruct, 13, {id=13, position=12, name="typology", namePlural="typologies", table="typologies", label="Tipología de archivo", labelPlural="Tipologías de archivos", gender="female", web=true, noWeb=true, showInSelect=false, tableTypeId=3})>

<!---lists views--->
<cfset structInsert(itemTypesStruct, 14, {id=14, position=15, name="list_view", namePlural="lists_views", table="lists_views", label="Vista de Lista", labelPlural="Vistas de Listas", gender="female", web=true, noWeb=true, showInSelect=false, tableTypeId=1, tableTypeName="list"})>

<!---form views--->
<cfset structInsert(itemTypesStruct, 15, {id=15, position=16, name="form_view", namePlural="forms_views", table="forms_views", label="Vista de Formulario", labelPlural="Vistas de Formularios", gender="female", web=true, noWeb=true, showInSelect=false, tableTypeId=2, tableTypeName="form"})>

<!---typologies (users)--->
<cfset structInsert(itemTypesStruct, 16, {id=16, position=17, name="user_typology", namePlural="users_typologies", table="users_typologies", label="Tipología de usuario", labelPlural="Tipologías de usuarios", gender="female", web=false, noWeb=false, showInSelect=false, tableTypeId=4})>

<cfif APPLICATION.moduleMailing IS true>
	<cfset structInsert(itemTypesStruct, 17, {id=17, position=18, name="mailing", namePlural="mailings", table="mailings", label="Boletín", labelPlural="Boletines", gender="male", web=true, noWeb=true, showInSelect=true})>
</cfif>

<!---DoPlanning Documents--->
<cfif APPLICATION.moduleDPDocuments IS true>
	<cfset structInsert(itemTypesStruct, 20, {id=20, position=7, name="dp_document", namePlural="dp_documents", table="dp_documents", label="Documento DoPlanning", labelPlural="Documentos DoPlanning", gender="male", web=false, noWeb=true, showInSelect=false})>
</cfif>

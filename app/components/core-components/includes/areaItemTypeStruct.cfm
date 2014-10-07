<!---Este include NO se debe usar directamente, se debe usar sólo el método getAreaItemTypes del componente AreaItemManager--->

<!---messages--->
<cfset structInsert(itemTypesStruct, 1, {id=1, position=1, name="message", label="Mensaje", label_plural="Mensajes", gender="male", web=false, no_web=true})>

<!---entries--->
<cfset structInsert(itemTypesStruct, 2, {id=2, position=6, name="entry", label="Elemento de contenido genérico", label_plural="Elementos de contenido genérico", gender="female", web=true, no_web=false})>

<cfif APPLICATION.identifier EQ "vpnet">
	<!---links--->
	<cfset structInsert(itemTypesStruct, 3, {id=3, position=3, name="link", label="Enlace", label_plural="Enlaces", gender="male", web=true, no_web=false})>
</cfif>

<!---news--->
<cfset structInsert(itemTypesStruct, 4, {id=4, position=7, name="news", label="Noticia", label_plural="Noticias", gender="female", web=true, no_web=true})>

<!---events--->
<cfset structInsert(itemTypesStruct, 5, {id=5, position=4, name="event", label="Evento", label_plural="Eventos", gender="male", web=true, no_web=true})>

<!---tasks--->
<cfset structInsert(itemTypesStruct, 6, {id=6, position=5, name="task", label="Tarea", label_plural="Tareas", gender="female", web=false, no_web=true})>

<!---consultations--->
<cfset structInsert(itemTypesStruct, 7, {id=7, position=11, name="consultation", label="Interconsulta", label_plural="Interconsultas", gender="female", web=false, no_web=true})>

<cfif arguments.client_abb NEQ "hcs">
	<!---publications--->
	<cfset structInsert(itemTypesStruct, 8, {id=8, position=12, name="publications", label="Publicación", label_plural="Publicaciones", gender="female", web=true, no_web=true})>
</cfif>

<!---images--->
<cfset structInsert(itemTypesStruct, 9, {id=9, position=8, name="image", label="Imagen", label_plural="Imágenes", gender="female", web=true, no_web=false})>

<!---files--->
<cfset structInsert(itemTypesStruct, 10, {id=10, position=2, name="file", label="Archivo", label_plural="Interconsultas", gender="male", web=true, no_web=true})>

<!---lists--->
<cfset structInsert(itemTypesStruct, 11, {id=11, position=9, name="list", label="Lista", label_plural="Listas", gender="female", web=true, no_web=true})>

<!---forms--->
<cfset structInsert(itemTypesStruct, 12, {id=12, position=10, name="form", label="Formulario", label_plural="Formularios", gender="male", web=true, no_web=true})>
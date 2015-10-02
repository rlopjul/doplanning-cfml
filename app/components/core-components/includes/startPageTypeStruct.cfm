<!---Este include NO se debe usar directamente, se debe usar sólo el método getAreaItemTypes del componente StartPageManager--->

<!---last_items--->
<cfset structInsert(startPageTypesStruct, 1, {id=1, position=1, page="last_items.cfm", label="Lo último"})>

<!---tree--->
<cfset structInsert(startPageTypesStruct, 2, {id=2, position=2, page="tree.cfm", label="Árbol"})>

<!---areas search--->
<cfset structInsert(startPageTypesStruct, 3, {id=3, position=3, page="last_items.cfm?filter=area&limit=20", label="Últimas 20 áreas con actividad reciente"})>

<!---areas search--->
<cfset structInsert(startPageTypesStruct, 4, {id=4, position=4, page="areas_search.cfm", label="Búsqueda de áreas"})>

<!---messages search--->
<cfset structInsert(startPageTypesStruct, 5, {id=5, position=5, page="messages_search.cfm", label="Búsqueda de mensajes"})>

<cfset structInsert(startPageTypesStruct, 6, {id=6, position=6, page="messages_search.cfm?limit=100&search=", label="Búsqueda de mensajes mostrando 100 últimos"})>

<cfset structInsert(startPageTypesStruct, 7, {id=7, position=7, page="files_search.cfm", label="Búsqueda de archivos"})>

<cfset structInsert(startPageTypesStruct, 8, {id=8, position=8, page="files_search.cfm?limit=100&search=", label="Búsqueda de archivos mostrando 100 últimos"})>

<cfset structInsert(startPageTypesStruct, 9, {id=9, position=9, page="events_search.cfm", label="Búsqueda de eventos"})>

<cfset structInsert(startPageTypesStruct, 10, {id=10, position=10, page="events_search.cfm?limit=100&search=", label="Búsqueda de eventos mostrando 100 últimos"})>

<cfset structInsert(startPageTypesStruct, 11, {id=11, position=11, page="tasks_search.cfm", label="Búsqueda de tareas"})>

<cfset structInsert(startPageTypesStruct, 12, {id=12, position=12, page="tasks_search.cfm?limit=100&search=", label="Búsqueda de tareas mostrando 100 próximas tareas asignadas a mi"})>

<cfset structInsert(startPageTypesStruct, 13, {id=13, position=13, page="lists_search.cfm", label="Búsqueda de listas"})>

<cfset structInsert(startPageTypesStruct, 14, {id=14, position=14, page="lists_search.cfm?limit=100&search=", label="Búsqueda de listas mostrando 100 últimas"})>

<cfset structInsert(startPageTypesStruct, 15, {id=15, position=15, page="forms_search.cfm", label="Búsqueda de formularios"})>

<cfset structInsert(startPageTypesStruct, 16, {id=16, position=16, page="forms_search.cfm?limit=100&search=", label="Búsqueda de formularios mostrando 100 últimos"})>

<cfset structInsert(startPageTypesStruct, 17, {id=17, position=17, page="consultations_search.cfm", label="Búsqueda de consultas"})>

<cfset structInsert(startPageTypesStruct, 18, {id=18, position=18, page="consultations_search.cfm?limit=100&search=", label="Búsqueda de consultas mostrando 100 últimas"})>

<cfset structInsert(startPageTypesStruct, 19, {id=19, position=19, page="pubmeds_search.cfm", label="Búsqueda de publicaciones"})>

<cfset structInsert(startPageTypesStruct, 20, {id=20, position=20, page="pubmeds_search.cfm?limit=100&search=", label="Búsqueda de publicaciones mostrando 100 últimas"})>

<cfset structInsert(startPageTypesStruct, 21, {id=21, position=21, page="preferences_user_data.cfm", label="Datos personales y preferencias del usuario"})>

<cfset structInsert(startPageTypesStruct, 22, {id=22, position=22, page="preferences_alerts.cfm", label="Preferencias de notificaciones"})>

<cfset structInsert(startPageTypesStruct, 23, {id=23, position=23, page="admin/", label="Administración"})>

<cfset structInsert(startPageTypesStruct, 24, {id=24, position=24, page="intranet/", label="Intranet"})>

<!---Este include NO se debe usar directamente, se debe usar sólo el método getAreaItemTypes del componente AreaItemManager--->

<!---title--->
<cfset itemTypesFields.title = {position=1, label="Título", import=true, notIncludedIn=""}>

<!---description--->
<cfset itemTypesFields.description = {position=4, label="Contenido", import=true, notIncludedIn=""}>

<!---creation_date--->
<cfset itemTypesFields.creation_date = {position=2, label="Fecha de creación", import=true, notIncludedIn=""}>

<!---link--->
<cfset itemTypesFields.link = {position=5, label="Enlace más información", import=true, notIncludedIn=""}>

<!---link_target--->
<cfset itemTypesFields.link_target = {position=4, label="Abrir enlace en (target)", import=false, default="_blank", notIncludedIn=""}>

<!---start_date--->
<cfset itemTypesFields.start_date = {position=5, label="Fecha de inicio", import=true, notIncludedIn="1,2,3,4"}>

<!---end_date--->
<cfset itemTypesFields.end_date = {position=6, label="Fecha de fin", import=true, notIncludedIn="1,2,3,4"}>

<!---place--->
<cfset itemTypesFields.place = {position=7, label="Lugar", import=true, notIncludedIn="1,2,3,4"}>

<!---iframe_url--->
<cfset itemTypesFields.iframe_url = {position=8, label="Iframe URL", import=false, default="", notIncludedIn="1"}>

<!---iframe_display_type_id--->
<cfset itemTypesFields.iframe_display_type_id = {position=9, label="Tamaño contenido incrustado", import=false, default="1", notIncludedIn="1"}>

<!---display_type_id--->
<cfset itemTypesFields.display_type_id = {position=10, label="Tipo de visualización", import=false, default="1", notIncludedIn="1,3,4,5"}>

<cfif APPLICATION.publicationRestricted IS true>

  <!---publication_restricted--->
  <cfset itemTypesFields.publication_restricted = {position=3, label="Visible sólo para usuarios registrados", import=true, notIncludedIn="1"}>

</cfif>

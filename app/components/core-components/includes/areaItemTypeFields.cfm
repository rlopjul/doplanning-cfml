<!---Este include NO se debe usar directamente, se debe usar sólo el método getAreaItemTypes del componente AreaItemManager--->

<!---title--->
<cfset itemTypesFields.title = {position=1, label="Título", notIncludedIn=""}>

<!---description--->
<cfset itemTypesFields.description = {position=2, label="Contenido", notIncludedIn=""}>

<!---creation_date--->
<cfset itemTypesFields.creation_date = {position=3, label="Fecha de creación", notIncludedIn=""}>

<!---start_date--->
<cfset itemTypesFields.start_date = {position=4, label="Fecha de inicio", notIncludedIn="1,2,3,4"}>

<!---end_date--->
<cfset itemTypesFields.end_date = {position=5, label="Fecha de fin", notIncludedIn="1,2,3,4"}>

<!---place--->
<cfset itemTypesFields.place = {position=5, label="Lugar", notIncludedIn="1,2,3,4"}>

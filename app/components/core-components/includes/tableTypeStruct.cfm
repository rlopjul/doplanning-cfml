<!---Este include NO se debe usar directamente, se debe usar sólo el método getAreaItemTypes del componente AreaItemManager--->

<!---lists--->
<cfset structInsert(tableTypesStruct, 1, {id=1, position=1, name="list", namePlural="lists", table="lists", label="Lista", labelPlural="Listas", gender="female", itemTypeId=11, viewTypeId=14, attachedFileTypeId=5})>

<!---forms--->
<cfset structInsert(tableTypesStruct, 2, {id=2, position=2, name="form", namePlural="forms", table="forms", label="Formulario", labelPlural="Formularios", gender="male", itemTypeId=12, viewTypeId=15, attachedFileTypeId=6})>

<!---typologies (files)--->
<cfset structInsert(tableTypesStruct, 3, {id=3, position=3, name="typology", namePlural="typologies", table="typologies", label="Tipología", labelPlural="Tipologías", gender="female", itemTypeId=13, viewTypeId=0, attachedFileTypeId=7})>

<!---typologies (users)--->
<cfset structInsert(tableTypesStruct, 4, {id=4, position=4, name="user_typology", namePlural="users_typologies", table="users_typologies", label="Tipología de usuario", labelPlural="Tipologías de usuarios", gender="female", itemTypeId=16, viewTypeId=0, attachedFileTypeId=8})>

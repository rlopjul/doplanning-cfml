<!---Este include NO se debe usar directamente, se debe usar sólo el método getAreaItemTypes del componente AreaItemManager--->

<!---lists--->
<cfset structInsert(tableTypesStruct, 1, {id=1, position=1, name="list", namePlural="lists", table="lists", label="Lista", labelPlural="Listas", gender="female", itemTypeId=11, viewTypeId=14})>

<!---forms--->
<cfset structInsert(tableTypesStruct, 2, {id=2, position=2, name="form", namePlural="forms", table="forms", label="Formulario", labelPlural="Formularios", gender="male", itemTypeId=12, viewTypeId=15})>

<!---typologies (files)--->
<cfset structInsert(tableTypesStruct, 3, {id=3, position=3, name="typology", namePlural="typologies", table="typologies", label="Tipología", labelPlural="Tipologías", gender="female", itemTypeId=13, viewTypeId=16})>

<!---<cfswitch expression="#tableTypeId#"> 
	
	<cfcase value="1"><!---lists--->
		
		<cfset tableTypeName = "list">
		<cfset tableTypeNameP = "lists">
		<cfset tableTypeTable = tableTypeNameP>
		
		<cfset tableTypeNameEs = "Lista">
		
		<cfset tableTypeGender = "female">

		<cfset itemTypeId = 11>
		<cfset viewTypeId = 14>
	
   	</cfcase> 
	
	<cfcase value="2"><!---forms--->

		<cfset tableTypeName = "form">
		<cfset tableTypeNameP = "forms">
		<cfset tableTypeTable = tableTypeNameP>
		
		<cfset tableTypeNameEs = "Formulario">

		<cfset tableTypeGender = "male">

		<cfset itemTypeId = 12>
		<cfset viewTypeId = 15>
	
   	</cfcase> 

   	<cfcase value="3"><!---typologies (files)--->

		<cfset tableTypeName = "typology">
		<cfset tableTypeNameP = "typologies">
		<cfset tableTypeTable = tableTypeNameP>
		
		<cfset tableTypeNameEs = "Tipología">

		<cfset tableTypeGender = "female">

		<cfset itemTypeId = 13>
		<cfset viewTypeId = 16>
	
   	</cfcase> 

</cfswitch>---->


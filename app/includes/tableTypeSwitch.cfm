
<cfinvoke component="#APPLICATION.coreComponentsPath#/TableManager" method="getTableTypeStruct" returnvariable="tableTypeStruct">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<cfset tableTypeName = tableTypeStruct.name>
<cfset tableTypeNameP = tableTypeStruct.namePlural>
<cfset tableTypeTable = tableTypeStruct.table>

<cfset tableTypeNameEs = tableTypeStruct.label>

<cfset tableTypeGender = tableTypeStruct.gender>

<cfset itemTypeId = tableTypeStruct.itemTypeId>
<cfset viewTypeId = tableTypeStruct.viewTypeId>

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

</cfswitch>--->
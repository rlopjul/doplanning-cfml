<cfswitch expression="#tableTypeId#"> 
	
	<cfcase value="1"><!---lists--->
		
		<cfset tableTypeName = "list">
		<cfset tableTypeNameP = "lists">
		<cfset tableTypeTable = tableTypeNameP>
		
		<cfset tableTypeNameEs = "Lista">
		
		<cfset tableTypeGender = "female">

		<cfset itemTypeId = 11>
	
   	</cfcase> 
	
	<cfcase value="2"><!---forms--->

		<cfset tableTypeName = "form">
		<cfset tableTypeNameP = "forms">
		<cfset tableTypeTable = tableTypeNameP>
		
		<cfset tableTypeNameEs = "Formulario">

		<cfset tableTypeGender = "male">

		<cfset itemTypeId = 12>
	
   	</cfcase> 

   	<cfcase value="3"><!---typologies (files)--->

		<cfset tableTypeName = "typology">
		<cfset tableTypeNameP = "typologies">
		<cfset tableTypeTable = tableTypeNameP>
		
		<cfset tableTypeNameEs = "Tipología">

		<cfset tableTypeGender = "female">

		<cfset itemTypeId = 13>
	
   	</cfcase> 

</cfswitch>
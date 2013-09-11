<cfswitch expression="#tableTypeId#"> 
	
	<cfcase value="1"><!---lists--->
		
		<cfset tableTypeName = "list">
		<cfset tableTypeNameP = "lists">
		<cfset tableTypeTable = "tb_"&tableTypeNameP>
		
		<!---<cfset tableTypeNameEs = "Lista">--->
		
		<cfset tableTypeGender = "female">

		<cfset itemTypeId = 11>
	
   	</cfcase> 
	
	<cfcase value="2"><!---files--->

		<cfset tableTypeName = "file">
		<cfset tableTypeNameP = "files">
		<cfset tableTypeTable = "tb_"&tableTypeNameP>
		
		<!---<cfset tableTypeNameEs = "Tipología">--->

		<cfset tableTypeGender = "male">

		<cfset itemTypeId = 12>
	
   	</cfcase> 
	
	<cfcase value="3"><!---forms--->

		<cfset tableTypeName = "form">
		<cfset tableTypeNameP = "forms">
		<cfset tableTypeTable = "tb_"&tableTypeNameP>
		
		<!---<cfset tableTypeNameEs = "Formulario">--->

		<cfset tableTypeGender = "male">

		<cfset itemTypeId = 13>
	
   	</cfcase> 

</cfswitch>
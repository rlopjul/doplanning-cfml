<cfswitch expression="#fileTypeId#"> 
	
	<cfcase value="1"><!---user files--->
		
		<cfset fileTypeNameP = "files">
		<cfset fileTypeTable = fileTypeNameP>
			
   	</cfcase> 
	
	<cfcase value="2"><!---area files--->

		<cfset fileTypeNameP = "files">
		<cfset fileTypeTable = fileTypeNameP>
	
   	</cfcase> 

   	<cfcase value="3"><!---area files edited--->

		<cfset fileTypeNameP = "files_edited">
		<cfset fileTypeTable = fileTypeNameP>
	
   	</cfcase>

</cfswitch>
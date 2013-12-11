<cfswitch expression="#fileTypeId#"> 
	
	<cfcase value="1"><!---user files--->
		
		<cfset fileTypeName  = "file">
		<cfset fileTypeNameP = "files">
		<cfset fileTypeTable = fileTypeNameP>
		<cfset fileTypeDirectory = fileTypeNameP>
			
   	</cfcase> 
	
	<cfcase value="2"><!---area files--->

		<cfset fileTypeName  = "file">
		<cfset fileTypeNameP = "files">
		<cfset fileTypeTable = fileTypeNameP>
		<cfset fileTypeDirectory = fileTypeNameP>
	
   	</cfcase> 

   	<cfcase value="3"><!---area files edited--->

   		<cfset fileTypeName  = "file">
		<cfset fileTypeNameP = "files">
		<cfset fileTypeTable = fileTypeNameP>
		<cfset fileTypeDirectory = "files_edited">
	
   	</cfcase>

   	<!---
   	<cfcase value="4"><!---area files edited version--->

   		<cfset fileTypeName  = "file_version">
		<cfset fileTypeNameP = "files_versions">
		<cfset fileTypeTable = "files_edited_versions">
		<cfset fileTypeDirectory = "files_edited">
	
   	</cfcase>--->

</cfswitch>
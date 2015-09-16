<!---
1 user files
2 area files
3 area files edited
4 areas images
5 list row files
6 form row files
7 file typology row files
8 user typology row files
--->

<cfswitch expression="#fileTypeId#">

	<cfcase value="1,2,5,6,7,8">

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

  <cfcase value="4"><!---areas images--->

   	<cfset fileTypeName  = "file">
		<cfset fileTypeNameP = "files">
		<cfset fileTypeTable = "areas_images">
		<cfset fileTypeDirectory = "areas_images">

  </cfcase>

</cfswitch>

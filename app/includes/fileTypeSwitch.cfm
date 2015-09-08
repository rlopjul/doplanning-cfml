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

  <cfcase value="4"><!---areas images--->

   	<cfset fileTypeName  = "file">
		<cfset fileTypeNameP = "files">
		<cfset fileTypeTable = "areas_images">
		<cfset fileTypeDirectory = "areas_images">

  </cfcase>

	<cfcase value="5"><!---list row files--->

   	<cfset fileTypeName  = "file">
		<cfset fileTypeNameP = "files">
		<cfset fileTypeTable = "">
		<cfset fileTypeDirectory = "lists">

  </cfcase>

	<cfcase value="6"><!---form row files--->

		<cfset fileTypeName  = "file">
		<cfset fileTypeNameP = "files">
		<cfset fileTypeTable = "">
		<cfset fileTypeDirectory = "forms">

	</cfcase>

</cfswitch>

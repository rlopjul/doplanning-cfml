<cfcomponent output="false">

	<cfset component = "UploadManager">


	<cffunction name="uploadFile" output="false" returntype="struct" returnformat="json" access="remote">
		
		<cfset var method = "uploadFile">

		<cfset var response = structNew()>
		<cfset var filesData = arrayNew(1)>

		<cfif structkeyexists(arguments,"files")>
						
			<cfset directory = GetTempDirectory()>

		    <cffile action="upload" fileField="files[]" destination="#directory#" nameConflict="makeUnique" result="upload"><!---destination="#ExpandPath('/files/uploads')#"--->

			<cfset fileData = {
				    "name": upload.serverfile,
				    "size": upload.filesize,
				    "url": "http://doplanning.net/",
				    "thumbnailUrl": "http:\/\/example.org\/files\/thumbnail\/picture1.jpg",
				    "deleteUrl": "http://doplanning.net/",
				    "deleteType": "DELETE"
				  }>

			<cfset arrayAppend(filesData, fileData)>


			<!---<cfset response = {"files": [
				  {
				    "name": upload.serverfile,
				    "size": upload.filesize,
				    "url": "http://doplanning.net/",
				    "thumbnailUrl": "http:\/\/example.org\/files\/thumbnail\/picture1.jpg",
				    "deleteUrl": "http://doplanning.net/",
				    "deleteType": "DELETE"
				  }
				  ]}>--->

		  	<!--- 
		  	<cfset response = {
		  					"name":			upload.serverfile,
		  					"size":			upload.filesize,
		  					"url":			"http://doplanning.net/",
		  					"deleteurl":	"http://doplanning.net/",
		  					"deletetype":	"DELETE"
		  				}> --->
		  	
		  	<cfset response.files = filesData>

		</cfif>
		
		<cfreturn response>
			
	</cffunction>


</cfcomponent>
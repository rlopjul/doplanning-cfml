<cfif isDefined("URL.folder")><!---Si se le pasa folder_id por URL--->

	<cfset folder_id = URL.folder>
	
<cfelse><!---Si no se le pasa area_id por URL, está en la raiz--->

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Folder" method="getUserRootFolderId" returnvariable="result_folder_id">
	</cfinvoke>
	
	<cfset folder_id = result_folder_id>
	
</cfif>
<!---page_types
1 Create new file
2 Modify file
3 Publish area file
--->

<cfif isDefined("URL.area") AND isValid("integer",URL.area)>
	<cfset area_id = URL.area>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>

<cfif isDefined("FORM.fileTypeId") AND isNumeric(FORM.fileTypeId)>
	<cfset fileTypeId = FORM.fileTypeId>
<cfelseif isDefined("URL.fileTypeId") AND isNumeric(URL.fileTypeId)>
	<cfset fileTypeId = URL.fileTypeId>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>

<cfif isDefined("FORM.page")>

	<cfif page_type IS 1>
		<cfset methodAction = "createFile">
	<cfelseif page_type IS 2>
		<cfset methodAction = "updateFile">
	<cfelseif page_type IS 3>
		<cfset methodAction = "publishFileVersion">
	</cfif>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="#methodAction#" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>	

	<cfif actionResponse.result IS true>

		<cfset file_id = actionResponse.file_id>
		
		<cfset msg = URLEncodedFormat(actionResponse.message)>
		
		<cfif isDefined("URL.return_page") AND URL.return_page EQ "file.cfm">
			<cflocation url="file.cfm?area=#area_id#&file=#file_id#&res=1&msg=#msg#" addtoken="no">
		<cfelse>
			<cflocation url="area_items.cfm?area=#area_id#&file=#file_id#&res=1&msg=#msg#" addtoken="no">
		</cfif>
	
			
	<cfelse>
		
		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset file = FORM>

		<cfif page_type IS 3>
			<cfset publicationArea = FORM>
		</cfif>

	</cfif>

<cfelse>

	<cfif page_type IS 1><!--- New file --->
		
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getEmptyFile" returnvariable="file">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="userQuery">
			<cfinvokeargument name="user_id" value="#SESSION.user_id#">
			<cfinvokeargument name="format_content" value="default">
			<cfinvokeargument name="return_type" value="query">
		</cfinvoke>

		<cfset file.reviser_user = userQuery.id>
		<cfset file.reviser_user_full_name = userQuery.user_full_name>
		<cfset file.approver_user = userQuery.id>
		<cfset file.approver_user_full_name = userQuery.user_full_name>

	<cfelse>

		<cfif isDefined("URL.file") AND isNumeric(URL.file)>
			<cfset file_id = URL.file>
		<cfelse>
			<cflocation url="empty.cfm" addtoken="no">
		</cfif>

		<cfif page_type IS 3>
			<cfif isDefined("URL.version") AND isNumeric(URL.version)>
				<cfset version_id = URL.version>
			<cfelse>
				<cflocation url="empty.cfm" addtoken="no">				
			</cfif>
		</cfif>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="file">
			<cfinvokeargument name="file_id" value="#file_id#">
			<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
		</cfinvoke>

		<cfif page_type IS 3>
			
			<cfset publicationArea = structNew()>
			<cfset publicationArea.publication_area_id = "">
			<cfset publicationArea.publication_area_name = "">

			<cfset curDateTime = DateFormat(now(), APPLICATION.dateFormat)&" "&timeFormat(now(), "HH:mm:ss")>
			<cfset queryAddColumn(file, "publication_date")>
			<cfset queryAddColumn(file, "publication_validated")>
			<cfset querySetCell(file, "publication_date", curDateTime)>
			<cfset querySetCell(file, "publication_validated", true)>

		</cfif>

	</cfif>

</cfif>

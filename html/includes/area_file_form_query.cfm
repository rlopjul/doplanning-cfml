<!---page_types
1 Create new file
2 Modify file
--->

<cfif isDefined("URL.area") AND isValid("integer",URL.area)>
	<cfset area_id = URL.area>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>
	
<cfif isDefined("FORM.page")>

	<cfif page_type IS 1>
		<cfset methodAction = "createFile">
	<cfelse>
		<cfset methodAction = "updateFile">
	</cfif>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="#methodAction#" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>	

	<cfif actionResponse.result IS true>

		<cfset file_id = actionResponse.file_id>
		
		<cfset msg = URLEncodedFormat(actionResponse.message)>
		
		<cflocation url="area_items.cfm?area=#area_id#&file=#file_id#&res=1&msg=#msg#" addtoken="no">
			
	<cfelse>
		
		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset file = FORM>

	</cfif>

<cfelse>

	<cfif page_type IS 1><!--- New file --->

		<!---<cfset return_page = "files.cfm?area=#area_id#">--->
		
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

		<!---<cfset return_page = "file.cfm?area=#area_id#&file=#file_id#">--->

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="file">
			<cfinvokeargument name="file_id" value="#file_id#">
		</cfinvoke>


	</cfif>

</cfif>

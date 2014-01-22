<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	<cfset area_id = URL.area>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>
	
<cfif isDefined("FORM.page")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="changeFileUser" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>	

	<cfif actionResponse.result IS true>

		<cfset file_id = actionResponse.file_id>
		
		<cfset msg = URLEncodedFormat(actionResponse.message)>
		
		<cflocation url="area_items.cfm?area=#area_id#&file=#file_id#&res=1&msg=#msg#" addtoken="no">
			
	<cfelse>
		
		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset newUser = FORM>

	</cfif>

<cfelse>

	<cfif isDefined("URL.file") AND isNumeric(URL.file)>
		<cfset file_id = URL.file>
	<cfelse>
		<cflocation url="empty.cfm" addtoken="no">
	</cfif>

	<cfset newUser = structNew()>
	<cfset newUser.new_user_in_charge = "">
	<cfset newUser.new_user_full_name = "">

</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="file">
	<cfinvokeargument name="file_id" value="#file_id#">
</cfinvoke>
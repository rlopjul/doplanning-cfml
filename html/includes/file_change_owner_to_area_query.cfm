<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	<cfset area_id = URL.area>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>
	
<cfif isDefined("FORM.page")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="changeFileOwnerToArea" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>	

	<cfif actionResponse.result IS true>

		<cfset file_id = actionResponse.file_id>

		<cfset msg = URLEncodedFormat(actionResponse.message)>
		
		<cflocation url="area_items.cfm?area=#area_id#&file=#file_id#&res=1&msg=#msg#" addtoken="no">
			
	<cfelse>
		
		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset ownerArea = FORM>

	</cfif>

<cfelse>

	<cfif isDefined("URL.file") AND isNumeric(URL.file)>
		<cfset file_id = URL.file>
	<cfelse>
		<cflocation url="empty.cfm" addtoken="no">
	</cfif>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="fileArea">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

	<cfset ownerArea = structNew()>
	<cfset ownerArea.new_area_id = area_id>
	<cfset ownerArea.new_area_name = fileArea.name>

</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="file">
	<cfinvokeargument name="file_id" value="#file_id#">
</cfinvoke>

<!---<cfif file.file_type_id IS 1>
	<cfset file_area_id = area_id>
<cfelse>
	<cfset file_area_id = file.area_id>
</cfif>--->

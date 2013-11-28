<!---page_types
1 Create new table
2 Modify table
--->

<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfif page_type IS 1>
	<cfset methodAction = "createTable">
<cfelse>
	<cfset methodAction = "updateTable">
</cfif>

<cfif isDefined("FORM.page")>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="#methodAction#" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>

	<cfif actionResponse.result IS true>
		
		<cfif page_type IS 1>
			<cfset return_page = "#tableTypeName#_fields.cfm?">	
		<cfelse>
			<cfset return_page = "#tableTypeNameP#.cfm?area=#actionResponse.area_id#&">	
		</cfif>

		<cfset msg = urlEncodedFormat(actionResponse.message)>

		<cflocation url="#return_page##tableTypeName#=#actionResponse.table_id#&res=#actionResponse.result#&msg=#msg#" addtoken="no">

	<cfelse>
		
		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset table = FORM>

		<!---<cfset area_id = FORM.area_id>--->
		
	</cfif> 

<cfelse>

	<cfif page_type IS 1><!--- NEW --->

		<cfif isDefined("URL.area") AND isNumeric(URL.area)>
			<cfset area_id = URL.area>
		<cfelse>
			<cflocation url="empty.cfm" addtoken="no">
		</cfif>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getEmptyTable" returnvariable="table">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<cfset queryAddRow(table, 1)>
		<cfset table.area_id = area_id>
		
	<cfelse><!--- MODIFY --->

		<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
			<cfset table_id = URL[tableTypeName]>
		<cfelse>
			<cflocation url="empty.cfm" addtoken="no">
		</cfif>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
			<cfinvokeargument name="table_id" value="#table_id#"/>
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<!---<cfset area_id = table.area_id>--->

	</cfif>

</cfif>
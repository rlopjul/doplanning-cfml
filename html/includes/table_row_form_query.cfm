<!---page_types
1 Create new row
2 Modify row
--->

<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfif isDefined("FORM.page")>

	<cfif page_type IS 1>
		<cfset methodAction = "createRow">
	<cfelse>
		<cfset methodAction = "updateRow">
	</cfif>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="#methodAction#" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>

	<cfif actionResponse.result IS true>
		
		<cfset return_page = "#tableTypeName#_rows.cfm?#tableTypeName#=#actionResponse.table_id#">	

		<cfset msg = urlEncodedFormat(actionResponse.message)>

		<cflocation url="#return_page#&row=#actionResponse.row_id#&res=#actionResponse.result#&msg=#msg#" addtoken="no">

	<cfelse><!--- Error --->
		
		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset row = FORM>

		<cfset area_id = FORM.area_id>
		<cfset table_id = FORM.table_id>

		<!---Table fields--->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			<cfinvokeargument name="with_types" value="true"/>
		</cfinvoke>
		<cfset fields = fieldsResult.tableFields>
		
	</cfif> 

<cfelse>

	<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
		<cfset table_id = URL[tableTypeName]>
	<cfelse>
		<cflocation url="empty.cfm" addtoken="no">
	</cfif>

	<!---Table fields--->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
		<cfinvokeargument name="table_id" value="#table_id#">
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		<cfinvokeargument name="with_types" value="true"/>
	</cfinvoke>
	<cfset fields = fieldsResult.tableFields>

	<cfif page_type IS 1><!--- NEW --->

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getEmptyRow" returnvariable="emptyRow">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="fillEmptyRow" returnvariable="row">
			<cfinvokeargument name="emptyRow" value="#emptyRow#">
			<cfinvokeargument name="fields" value="#fields#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<cfset area_id = table.area_id>

	<cfelse><!--- MODIFY --->

		<cfif isDefined("URL.row") AND isNumeric(URL.row)>
			<cfset row_id = URL.row>
		<cfelse>
			<cflocation url="empty.cfm" addtoken="no">
		</cfif>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getRow" returnvariable="getRowResponse">
			<cfinvokeargument name="table_id" value="#table_id#"/>
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			<cfinvokeargument name="row_id" value="#row_id#">
		</cfinvoke>

		<cfset row = getRowResponse.row>

		<cfset area_id = getRowResponse.table.area_id>

	</cfif>

</cfif>
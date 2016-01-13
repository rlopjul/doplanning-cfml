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

		<cfset return_page = "#tableTypeName#_rows.cfm?#tableTypeName#=#actionResponse.table_id#&area=#FORM.area_id#">

		<cfset msg = urlEncodedFormat(actionResponse.message)>

		<cflocation url="#return_page#&row=#actionResponse.row_id#&res=#actionResponse.result#&msg=#msg#" addtoken="no">

	<cfelse><!--- Error --->

		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset row = FORM>

		<cfset area_id = FORM.area_id>
		<cfset table_id = FORM.table_id>

		<!--- isUserAreaResponsible --->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="isUserAreaResponsible" returnvariable="is_user_area_responsible">
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfinvoke>

		<!---Table fields--->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			<cfinvokeargument name="with_types" value="true"/>
			<cfinvokeargument name="with_separators" value="true"/>
			<cfif page_type IS 1>
				<cfinvokeargument name="include_in_new_row" value="true">
			<cfelse>
				<cfinvokeargument name="include_in_update_row" value="true">
			</cfif>
			<cfif is_user_area_responsible IS true>
				<cfinvokeargument name="include_in_all_users" value="true">
			<cfelse>
				<cfinvokeargument name="include_in_all_users" value="false">
			</cfif>
		</cfinvoke>
		<cfset fields = fieldsResult.tableFields>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

	</cfif>

<cfelse>

	<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
		<cfset table_id = URL[tableTypeName]>
	<cfelse>
		<cflocation url="empty.cfm" addtoken="no">
	</cfif>

	<cfif page_type IS 1><!--- NEW --->

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

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

		<cfset table = getRowResponse.table>

	</cfif>

	<cfif isDefined("URL.area") AND isNumeric(URL.area)>
		<cfset area_id = URL.area>
	<cfelse>
		<cfset area_id = table.area_id>
	</cfif>

	<!--- isUserAreaResponsible --->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="isUserAreaResponsible" returnvariable="is_user_area_responsible">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

	<!---Table fields--->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
		<cfinvokeargument name="table_id" value="#table_id#">
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		<cfinvokeargument name="with_types" value="true"/>
		<cfinvokeargument name="with_separators" value="true"/>
		<cfif page_type IS 1>
			<cfinvokeargument name="include_in_new_row" value="true">
		<cfelse>
			<cfinvokeargument name="include_in_update_row" value="true">
		</cfif>
		<cfif is_user_area_responsible NEQ true>
			<cfinvokeargument name="include_in_all_users" value="true">
		</cfif>
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

	</cfif>


</cfif>

<cftry>

	<cfif isDefined("URL.typology") AND isNumeric(URL.typology)>

		<cfset table_id = URL.typology>

		<!---Table fields--->
		<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTableFields" returnvariable="getFieldsResponse">
			<cfinvokeargument name="table_id" value="#table_id#"/>
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#"/>
			<cfinvokeargument name="with_types" value="true"/>
			<cfinvokeargument name="with_separators" value="true"/>
		</cfinvoke>

		<cfif getFieldsResponse.result IS false>
			<cfthrow message="#getFieldsResponse.message#">
		</cfif>

		<cfset fields = getFieldsResponse.tableFields>

		<cfset area_id = fields.area_id>

		<cfif isDefined("URL.row") AND isNumeric(URL.row)>

			<cfset row_id = URL.row>

			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="getRow" returnvariable="getRowResponse">
				<cfinvokeargument name="table_id" value="#table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="row_id" value="#row_id#">
			</cfinvoke>

			<cfif getRowResponse.result IS false>
				<cfthrow message="#getRowResponse.message#">
			</cfif>

			<cfset row = getRowResponse.row>

			<!---<cfoutput>
				<input type="hidden" name="typology_row_id" value="#row.row_id#"/>
			</cfoutput>--->

		<cfelse><!--- NEW ROW --->

			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="getEmptyRow" returnvariable="getEmptyRowResponse">
				<cfinvokeargument name="table_id" value="#table_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			</cfinvoke>

			<cfif getEmptyRowResponse.result IS false>
				<cfthrow message="#getEmptyRowResponse.message#">
			</cfif>

			<cfset emptyRow = getEmptyRowResponse.row>

			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="fillEmptyRow" returnvariable="fillEmptyRowResponse">
				<cfinvokeargument name="emptyRow" value="#emptyRow#">
				<cfinvokeargument name="fields" value="#fields#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			</cfinvoke>

			<cfif fillEmptyRowResponse.result IS false>
				<cfthrow message="#fillEmptyRowResponse.message#">
			</cfif>

			<cfset row = fillEmptyRowResponse.row>

		</cfif>

		<!--- outputRowFormInputs --->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="outputRowFormInputs">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			<cfinvokeargument name="row" value="#row#">
			<cfinvokeargument name="fields" value="#fields#">
			<cfif tableTypeId IS 4>
				<cfinvokeargument name="displayType" value="horizontal">
			</cfif>
		</cfinvoke>

	</cfif>


	<cfcatch>

		<cfoutput>
			<div class="alert alert-danger">
				<i class="icon-warning-sign"></i> <span lang="es">#cfcatch.message#</span>
			</div>
		</cfoutput>

		<cfinclude template="#APPLICATION.htmlPath#/components/includes/errorHandlerNoRedirect.cfm">

	</cfcatch>

</cftry>

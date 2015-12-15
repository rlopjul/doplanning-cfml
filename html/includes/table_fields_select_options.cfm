<cftry>

	<cfif isDefined("URL.itemTypeId") AND isNumeric(URL.itemTypeId)>

		<cfset itemTypeId = URL.itemTypeId>

		<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

		<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

		<cfif isDefined("URL.table") AND isNumeric(URL.table)>

			<cfset table_id = URL.table>

			<!---Table fields--->
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTableFields" returnvariable="getTableFieldsResponse">
				<cfinvokeargument name="table_id" value="#table_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="with_types" value="true">
			</cfinvoke>

			<cfif getTableFieldsResponse.result IS false>
				<cfthrow message="#getTableFieldsResponse.message#">
			</cfif>

			<cfset fields = getTableFieldsResponse.tableFields>

			<cfoutput>
			<cfif fields.recordCount GT 0>

				<cfloop query="fields">
					<option value="#fields.field_id#">#fields.label#</option>
				</cfloop>

			<cfelse>

				<option val="" lang="es">No hay campos</option>

			</cfif>
			</cfoutput>

		</cfif><!--- END isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName]) --->


	</cfif><!--- END isDefined("URL.tableTypeId") --->

	<cfcatch>

		<cfoutput>
			<option val="">#cfcatch.message#</option>
		</cfoutput>

		<cfinclude template="#APPLICATION.htmlPath#/components/includes/errorHandlerNoRedirect.cfm">

	</cfcatch>

</cftry>

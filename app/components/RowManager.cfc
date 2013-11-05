<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">
	
	<cfset component = "RowManager">

	<cfset dateFormat = "%d-%m-%Y">

	<!--- ------------------------------------- saveRow -------------------------------------  --->
	
	<cffunction name="saveRow" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="false">
		<cfargument name="position" type="numeric" required="false">

		<cfargument name="action" type="string" required="true"><!---create/modify--->

		<cfset var method = "saveRow">

		<cfset var response = structNew()>

		<cfset var row_id = "">

		<cfset var field_value = "">
		<cfset var selectFields = false>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="TableManager" method="getTable" returnvariable="getTableResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>
			
			<cfif getTableResponse.result IS false>
				<cfreturn getTableResponse>
			</cfif>

			<cfset table = getTableResponse.table>

			<!---canUserModifyRow--->
			<cfinvoke component="RowManager" method="canUserModifyRow" returnvariable="canUserModifyRow">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="table" value="#table#">
			</cfinvoke>
			<cfif canUserModifyRow IS false>
				<cfthrow message="No tiene permiso para acceder a editar esta #tableTypeNameEs#">
			</cfif>			

			<!---Table fields--->
			<cfinvoke component="TableManager" method="getTableFields" returnvariable="fieldsResult">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="with_types" value="true"/>
			</cfinvoke>
			<cfset fields = fieldsResult.tableFields>

			<cftransaction>

				<cfif arguments.action IS "create">

					<cfset sqlAction = "INSERT INTO">

					<cfif NOT isDefined("arguments.position") OR NOT isNumeric(arguments.position)>
				
						<!---getRowLastPosition--->
						<cfinvoke component="RowManager" method="getRowLastPosition" returnvariable="rowLastPosition">
							<cfinvokeargument name="table_id" value="#table_id#">
							<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
						</cfinvoke>
						
						<cfset arguments.position = rowLastPosition+1>
						
					</cfif>

				<cfelse>
						
					<cfset sqlAction = "UPDATE">

				</cfif>

				<cfset selectFields = false>

				<cfquery name="saveRow" datasource="#client_dsn#">
					#sqlAction# `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` 
					SET 
					<cfif arguments.action IS "create">
						insert_user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
						position = <cfqueryparam value="#arguments.position#" cfsqltype="cf_sql_integer">,
						creation_date = NOW(),
					<cfelse>
						last_update_user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
					</cfif>
					last_update_date = NOW()

					<cfloop query="fields">

						<cfif fields.field_type_id NEQ 9 AND fields.field_type_id NEQ 10><!--- SELECT --->

							<cfset field_name = "field_#fields.field_id#">
							<cfset field_value = arguments[field_name]>

							, field_#fields.field_id# = 	

							<cfif fields.mysql_type IS "DATE"><!--- DATE --->
								<cfif len(field_value) GT 0>
									STR_TO_DATE('#field_value#','#dateFormat#')
								<cfelse>
									<cfqueryparam cfsqltype="#fields.cf_sql_type#" null="true">
								</cfif>
							<cfelseif fields.field_type_id IS 7 AND len(field_value) IS 0><!--- BOOLEAN --->	
								<cfqueryparam cfsqltype="#fields.cf_sql_type#" null="true">
							<cfelse>														
								<cfqueryparam value="#field_value#" cfsqltype="#fields.cf_sql_type#">
							</cfif>

						<cfelse><!---SELECT FIELDS--->
							<cfset selectFields = true>
						</cfif>

					</cfloop>

					<cfif arguments.action NEQ "create">
						WHERE row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">
					</cfif>;
				</cfquery>

				<cfif arguments.action IS "create">

					<cfquery name="getLastInsertId" datasource="#client_dsn#">
						SELECT LAST_INSERT_ID() AS last_insert_id FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`;
					</cfquery>

					<cfset row_id = getLastInsertId.last_insert_id>

				<cfelse>

					<cfset row_id = arguments.row_id>

				</cfif>

				<cfif selectFields IS true><!--- Select fields values ---->
					
					<cfloop query="fields">

						<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- SELECT --->

							<cfif arguments.action NEQ "create">
								
								<!--- Delete old values --->
								<cfquery name="deleteEntitySectors" datasource="#client_dsn#">
									DELETE FROM `#client_abb#_#tableTypeTable#_rows_areas`
									WHERE #tableTypeName#_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
									AND row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">
									AND field_id = <cfqueryparam value="#fields.field_id#" cfsqltype="cf_sql_integer">;
								</cfquery>

							</cfif>

							<cfset field_name = "field_#fields.field_id#">
							
							<cfif isDefined("arguments.#field_name#")>
								
								<cfset field_values = arguments[field_name]>

								<!--- Save new values --->
								<cfloop array="#field_values#" index="select_value">

									<cfif isNumeric(select_value)>
										
										<cfquery name="addValueToTable" datasource="#client_dsn#">
											INSERT INTO `#client_abb#_#tableTypeTable#_rows_areas` (#tableTypeName#_id, row_id, field_id, area_id)
											VALUES (<cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">,
												<cfqueryparam value="#row_id#" cfsqltype="cf_sql_integer">,
												<cfqueryparam value="#fields.field_id#" cfsqltype="cf_sql_integer">,
												<cfqueryparam value="#select_value#" cfsqltype="cf_sql_integer">);
										</cfquery>

									</cfif>

								</cfloop>

							<cfelseif fields.required IS true>
								<cfthrow message="Campo lista sin valor requerido seleccionado">
							</cfif>

						</cfif>

					</cfloop>

				</cfif>
				
			</cftransaction>
			
			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, row_id=#row_id#, table_id=#arguments.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>
	

	<!--- --------------------------------- canUserModifyRow ---------------------------------  --->
	
	<cffunction name="canUserModifyRow" output="false" access="private" returntype="boolean">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="table" type="query" required="true">

		<cfset var method = "canUserModifyRow">

		<cfset var area_id = "">

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfif arguments.tableTypeId NEQ 3 OR arguments.table.general IS NOT true><!---IS NOT typology OR IS NOT general typology--->

			<cfset area_id = table.area_id>

			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">

		</cfif>

		<!---checkListPermissions--->
		<cfif tableTypeId IS 1 AND APPLICATION.moduleListsWithPermissions IS true><!---IS List and list permissions is enabled--->
			
			<cfinvoke component="TableManager" method="isUserInTable" returnvariable="isUserInTableResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="check_user_id" value="#user_id#">
			</cfinvoke>	
			<cfif isUserInTableResponse.result IS false>
				<cfreturn isUserInTableResponse>
			</cfif>

			<cfif isUserInTableResponse.isUserInTable IS false><!--- The user is not in the table  --->

				<!---checkAreaResponsibleAccess--->
				<cfinvoke component="AreaManager" method="isUserAreaResponsible" returnvariable="isAreaResponsible">
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>
				<cfif isAreaResponsible IS false>
					<cfreturn false>
				</cfif>
				
			</cfif>

		</cfif>

		<cfreturn true>

	</cffunction>

	<!---  ---------------------- getRowLastPosition -------------------------------- --->
	
	<cffunction name="getRowLastPosition" returntype="numeric" access="public">
		<cfargument name="table_id" type="numeric" required="yes">
		<cfargument name="tableTypeId" type="numeric" required="yes">
		
		<cfset var method = "getRowLastPosition">
		
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getRowLastPosition" returnvariable="getLastPositionResult">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
		
		<cfif isNumeric(getLastPositionResult.position)>
			<cfreturn getLastPositionResult.position>
		<cfelse>
			<cfreturn 0>
		</cfif>
		
	</cffunction>
	<!---  ------------------------------------------------------------------------ --->



	<!--- ------------------------------------- deleteRow -------------------------------------  --->
	
	<cffunction name="deleteRow" output="false" access="public" returntype="struct">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "deleteRow">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="TableManager" method="getTable" returnvariable="getTableResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>
			
			<cfif getTableResponse.result IS false>
				<cfreturn getTableResponse>
			</cfif>

			<cfset table = getTableResponse.table>

			<!---canUserModifyRow--->
			<cfinvoke component="RowManager" method="canUserModifyRow" returnvariable="canUserModifyRow">
				<cfinvokeargument name="table_id" value="#table_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="table" value="#table#">
			</cfinvoke>
			<cfif canUserModifyRow IS false>
				<cfthrow message="No tiene permiso para acceder a editar esta #tableTypeNameEs#">
			</cfif>

			<!--- getRow --->
			<cfinvoke component="RowManager" method="getRow" returnvariable="getRowResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="row_id" value="#arguments.row_id#">
			</cfinvoke>

			<cfif getRowResponse.result IS false>
				<cfreturn getRowResponse>
			</cfif>

			<cfset row = getRowResponse.row>

			<cfquery name="deleteRow" datasource="#client_dsn#">
				DELETE FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`
				WHERE row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfinclude template="includes/logRecord.cfm">
			
			<cfset response = {result=true, row_id=#arguments.row_id#, table_id=#arguments.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------ deleteTableRowsInDatabase -----------------------------------  --->
	
	<cffunction name="deleteTableRowsInDatabase" output="false" access="package" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "deleteTableRowsInDatabase">

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfquery name="deleteRow" datasource="#client_dsn#">
				DELETE FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`;
			</cfquery>
			
	</cffunction>


	<!--- ------------------------------------- getTableRows -------------------------------------  --->
	
	<cffunction name="getTableRows" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="false">

		<cfset var method = "getRow">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="TableManager" method="getTable" returnvariable="getTableResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>
			
			<cfif getTableResponse.result IS false>
				<cfreturn getTableResponse>
			</cfif>

			<cfset table = getTableResponse.table>

			<cfset area_id = table.area_id>

			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="getRowsQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfif isDefined("arguments.row_id")>
				<cfinvokeargument name="row_id" value="#arguments.row_id#">
				</cfif>
				<!---<cfinvokeargument name="parse_dates" value="true"/>--->
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfif getRowsQuery.recordCount GT 0>

				<cfset response = {result=true, rows=#getRowsQuery#, table=#table#}>

			<cfelse><!---Item does not exist--->
			
				<cfset error_code = 501>
			
				<cfthrow errorcode="#error_code#">

			</cfif>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- getRow -------------------------------------  --->
	
	<cffunction name="getRow" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="true">

		<cfset var method = "getRow">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinvoke component="RowManager" method="getTableRows" returnvariable="getTableRowsResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="row_id" value="#arguments.row_id#">
			</cfinvoke>
			
			<cfif getTableRowsResponse.result IS true>
				<cfset response = {result=true, row=#getTableRowsResponse.rows#, table=#getTableRowsResponse.table#}>
			<cfelse>
				<cfreturn getTableRowsResponse>
			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- getRowSelectedAreas -------------------------------------  --->
	
	<cffunction name="getRowSelectedAreas" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="field_id" type="numeric" required="false">
		<cfargument name="row_id" type="numeric" required="false">

		<cfset var method = "getRowSelectedAreas">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getRowSelectedAreas" returnvariable="getRowAreasQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="field_id" value="#arguments.field_id#">
				<cfinvokeargument name="row_id" value="#arguments.row_id#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfset response = {result=true, areas=#getRowAreasQuery#}>
			
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- getEmptyRow -------------------------------------  --->
	
	<cffunction name="getEmptyRow" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getEmptyRow">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfquery name="getRowQuery" datasource="#client_dsn#">
				SELECT *
				FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`
				WHERE row_id = -1;
			</cfquery>

			<cfset response = {result=true, row=#getRowQuery#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------ fillEmptyRow -------------------------------------  --->
	
	<cffunction name="fillEmptyRow" output="false" access="public" returntype="struct">
		<cfargument name="emptyRow" type="query" required="true">
		<cfargument name="fields" type="query" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "fillEmptyRow">

		<cfset var response = structNew()>

		<cftry>

			<cfset queryAddRow(emptyRow, 1)>
			
			<cfloop query="fields">

				<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- IS SELECT --->
					<!---Se crean los campos para poder definir en ellos los valores por defecto--->
					<cfset queryAddColumn(emptyRow, "field_#fields.field_id#")>
				</cfif>
				
				<cfset querySetCell(emptyRow, "field_#fields.field_id#", fields.default_value, 1)>

			</cfloop>

			<cfset response = {result=true, row=#emptyRow#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


</cfcomponent>
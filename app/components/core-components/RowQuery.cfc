<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">

	<cfset component = "RowQuery">	

	<cfset dateFormat = "%d-%m-%Y"><!---%H:%i:%s---><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset datetimeFormat = "%d-%m-%Y %H:%i:%s">

	<!---saveRow--->
		
	<cffunction name="saveRow" output="false" returntype="numeric" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="false">
		<cfargument name="position" type="numeric" required="false">

		<cfargument name="action" type="string" required="true"><!---create/modify--->

		<cfargument name="fields" type="query" required="false">
		<cfargument name="user_id" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "saveRow">

		<cfset var row_id = "">

		<cfset var field_value = "">
		<cfset var selectFields = false>


			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfif NOT isDefined("arguments.fields")>
				
				<cfinvoke component="FieldQuery" method="getTableFields" returnvariable="fields">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="with_types" value="#arguments.with_types#">
					<cfinvokeargument name="with_table" value="false">
					
					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>

			<cftransaction>

				<cfif arguments.action IS "create">

					<cfset sqlAction = "INSERT INTO">

					<cfif NOT isDefined("arguments.position") OR NOT isNumeric(arguments.position)>
				
						<!---getRowLastPosition--->
						<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getRowLastPosition" returnvariable="rowLastPosition">
							<cfinvokeargument name="table_id" value="#arguments.table_id#">
							<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
							
							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>
						
						<cfset arguments.position = rowLastPosition+1>
						
					</cfif>

					<cfif NOT isDefined("arguments.user_id") AND ( arguments.tableTypeId IS NOT 2 OR arguments.action IS "update" )><!---User IS NOT defined AND IS NOT forms--->
						<cfthrow message="Usuario requerido para guardar un registro">						
					</cfif>

				<cfelse>
						
					<cfset sqlAction = "UPDATE">

				</cfif>

				<cfset selectFields = false>

				<cfquery name="saveRow" datasource="#client_dsn#">
					#sqlAction# `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` 
					SET 
					<cfif arguments.action IS "create">
						insert_user_id = 
						<cfif isDefined("arguments.user_id")>
							<cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">
						<cfelse>
							<cfqueryparam null="true" cfsqltype="cf_sql_integer">
						</cfif>,
						position = <cfqueryparam value="#arguments.position#" cfsqltype="cf_sql_integer">,
						creation_date = NOW(),
					<cfelse>
						last_update_user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">,
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
			
		
		<cfreturn row_id>
		
	</cffunction>


	<!---getEmptyRow--->
		
	<cffunction name="getEmptyRow" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
	
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getEmptyRow">
			
			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfquery name="getRowQuery" datasource="#client_dsn#">
				SELECT *
				FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`
				WHERE row_id = -1;
			</cfquery>
		
		<cfreturn getRowQuery>
		
	</cffunction>


	<!---fillEmptyRow--->
		
	<cffunction name="fillEmptyRow" output="false" returntype="query" access="public">
		<cfargument name="emptyRow" type="query" required="true">
		<cfargument name="fields" type="query" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
				
		<cfset var method = "fillEmptyRow">
			
			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfset queryAddRow(emptyRow, 1)>
			
			<cfloop query="fields">

				<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- IS SELECT --->
					<!---Se crean los campos para poder definir en ellos los valores por defecto--->
					<cfset queryAddColumn(emptyRow, "field_#fields.field_id#")>
				</cfif>
				
				<cfset querySetCell(emptyRow, "field_#fields.field_id#", fields.default_value, 1)>

			</cfloop>
		
		<cfreturn emptyRow>
		
	</cffunction>


	<!---getTableRows--->
		
	<cffunction name="getTableRows" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="false">
		<!---<cfargument name="parse_dates" type="boolean" required="false" default="false">--->

		<cfargument name="with_types" type="boolean" required="false" default="false">
		<cfargument name="with_table" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getTableRow">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfquery name="getTableRow" datasource="#client_dsn#">
				SELECT table_row.*,
				<!---<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(table_row.creation_date, '#datetimeFormat#') AS creation_date 
				</cfif>--->
				CONCAT_WS(' ', insert_users.family_name, insert_users.name) AS insert_user_full_name, insert_users.image_type AS insert_user_image_type,
				CONCAT_WS(' ', update_users.family_name, update_users.name) AS update_user_full_name, update_users.image_type AS update_user_image_type
				FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` AS table_row
				INNER JOIN #client_abb#_users AS insert_users ON table_row.insert_user_id = insert_users.id
				LEFT JOIN #client_abb#_users AS update_users ON table_row.last_update_user_id = update_users.id
				<cfif isDefined("arguments.row_id")>
					WHERE table_row.row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">
				<cfelse>
					ORDER BY position ASC
				</cfif>;
			</cfquery>
		
		<cfreturn getTableRow>
		
	</cffunction>


	<!---getRowLastPosition--->
	
	<cffunction name="getRowLastPosition" output="false" returntype="numeric" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
		
		<cfset var method = "getRowLastPosition">
		<cfset var position = 0>
					
			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
						
				<cfquery name="rowPositionQuery" datasource="#client_dsn#">
					SELECT MAX(position) AS max_position					
					FROM #client_abb#_#tableTypeTable#_fields AS tables_fields
					WHERE tables_fields.table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
				
				<cfif isNumeric(rowPositionQuery.max_position)>
					<cfset position = rowPositionQuery.max_position>
				<cfelse>
					<cfset position = 0>
				</cfif>				
		
		<cfreturn position>
		
	</cffunction>
	

	<!---getRowSelectedAreas--->
		
	<cffunction name="getRowSelectedAreas" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="field_id" type="numeric" required="false">
		<cfargument name="row_id" type="numeric" required="false">

		<cfargument name="with_types" type="boolean" required="false" default="false">
		<cfargument name="with_table" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getRowSelectedAreas">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfquery name="getTableRowAreas" datasource="#client_dsn#">
				SELECT row_areas.*,	areas.name
				FROM `#client_abb#_#tableTypeTable#_rows_areas` AS row_areas
				INNER JOIN #client_abb#_areas AS areas ON row_areas.area_id = areas.id
				AND	row_areas.#tableTypeName#_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
				<cfif isDefined("arguments.field_id")>
					AND row_areas.field_id = <cfqueryparam value="#arguments.field_id#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif isDefined("arguments.row_id")>
					AND row_areas.row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">
				</cfif>;
			</cfquery>
		
		<cfreturn getTableRowAreas>
		
	</cffunction>

</cfcomponent>
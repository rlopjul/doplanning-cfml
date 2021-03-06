<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "RowQuery">

	<cfset dateFormat = APPLICATION.dbDateFormat><!---%H:%i:%s---><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset datetimeFormat = APPLICATION.dbDateTimeFormat>

	<cfset CREATE_ROW = "create">
	<cfset MODIFY_ROW = "modify">

	<cfset LIST_TEXT_VALUES_DELIMITER = "#chr(13)##chr(10)#">

	<cfset LAST_UPDATE_TYPE_ROW = "row">

	<!---saveRow--->

	<cffunction name="saveRow" output="false" returntype="numeric" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="false">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="position" type="numeric" required="false">

		<cfargument name="action" type="string" required="true"><!---create/modify--->

		<cfargument name="fields" type="query" required="false">
		<cfargument name="user_id" type="numeric" required="false">
		<cfargument name="send_alert" type="boolean" required="false" default="true">
		<cfargument name="with_transaction" type="boolean" required="false" default="true">
		<cfargument name="include_admin_fields" type="boolean" required="false" default="false">
		<cfargument name="import" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "saveRow">

		<cfset var row_id = "">

		<cfset var field_value = "">
		<cfset var selectFields = false>
		<cfset var attachedFileFields = false>

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTable" returnvariable="tableQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="parse_dates" value="false">
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif NOT isDefined("arguments.area_id")>

				<cfset area_id = tableQuery.area_id>

			</cfif>

			<cfif NOT isDefined("arguments.fields")>

				<cfinvoke component="FieldQuery" method="getTableFields" returnvariable="fields">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="with_types" value="true">
					<cfinvokeargument name="with_table" value="false">
					<cfif arguments.action IS CREATE_ROW>
						<cfif arguments.import IS false>
							<cfinvokeargument name="include_in_new_row" value="true">
						</cfif>
					<cfelse>
						<cfinvokeargument name="include_in_update_row" value="true">
					</cfif>
					<cfif arguments.include_admin_fields IS false>
						<cfinvokeargument name="include_in_all_users" value="true">
					</cfif>

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

			</cfif>

			<cfif arguments.with_transaction IS true>
				<!--- <cftransaction> --->
				<cfquery datasource="#client_dsn#" name="startTransaction">
					START TRANSACTION;
				</cfquery>
			</cfif>

			<cftry>

				<cfif arguments.action IS CREATE_ROW>

					<cfset sqlAction = "INSERT INTO">

					<cfif NOT isDefined("arguments.position") OR NOT isNumeric(arguments.position)>

						<!---getRowLastPosition--->
						<cfinvoke component="RowQuery" method="getRowLastPosition" returnvariable="rowLastPosition">
							<cfinvokeargument name="table_id" value="#arguments.table_id#">
							<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

						<cfset arguments.position = rowLastPosition+1>

					</cfif>

					<cfif NOT isDefined("arguments.user_id") AND ( arguments.tableTypeId IS NOT 2 OR arguments.action IS MODIFY_ROW )><!---User IS NOT defined AND IS NOT forms--->
						<cfthrow message="Usuario requerido para guardar un registro">
					</cfif>

				<cfelse>

					<cfset sqlAction = "UPDATE">

					<cfif NOT isDefined("arguments.row_id") OR NOT isNumeric(arguments.row_id)>

						<cfthrow message="Error al obtener el registro a modificar">

					</cfif>

				</cfif>

				<cfset selectFields = false>

				<cfquery name="saveRow" datasource="#client_dsn#">
					#sqlAction# `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`
					SET
					<cfif arguments.action IS CREATE_ROW>
						insert_user_id =
						<cfif isDefined("arguments.user_id")>
							<cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">
						<cfelse>
							<cfqueryparam null="true" cfsqltype="cf_sql_integer">
						</cfif>,
						position = <cfqueryparam value="#arguments.position#" cfsqltype="cf_sql_integer">,
						<cfif tableQuery.general IS true AND (tableTypeId IS 1 OR tableTypeId IS 2)><!--- Global Lists AND Forms --->
							area_id = <cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer">,
						</cfif>
						creation_date = NOW(),
					<cfelse>
						last_update_user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">,
					</cfif>
					last_update_date = NOW()

					<cfloop query="fields">

						<cfset field_name = "field_#fields.field_id#">

						<cfif fields.field_type_id NEQ 9 AND fields.field_type_id NEQ 10 AND fields.field_type_id NEQ 18><!--- IS NOT SELECT OR ATTACHED FILES--->

							<cfif fields.field_type_id IS 7 AND fields.required IS false AND NOT isDefined("arguments[field_name]")><!--- EMPTY BOOLEAN --->

								<cfif fields.field_input_type EQ "checkbox">
									<cfset field_value = 0>
								<cfelse>
									<cfset field_value = "">
								</cfif>

							<cfelseif fields.field_type_id IS 15 OR fields.field_type_id IS 16><!---List text values with multiple--->

								<cfif fields.required IS false AND NOT isDefined("arguments[field_name]")><!--- EMPTY CHECKBOX SELECTION --->
									<cfset field_value = "">
								<cfelse>
									<cfset field_values = arguments[field_name]>
									<cfset field_value = arrayToList(field_values, LIST_TEXT_VALUES_DELIMITER)>
								</cfif>

							<cfelse>
								<cfset field_value = arguments[field_name]>
							</cfif>


							, field_#fields.field_id# =

							<cfif fields.mysql_type IS "DATE"><!--- DATE --->
								<cfif len(field_value) GT 0 AND validateDate(field_value)>
									STR_TO_DATE('#field_value#','#dateFormat#')
								<cfelse>
									<cfqueryparam cfsqltype="#fields.cf_sql_type#" null="true">
								</cfif>
							<cfelseif fields.field_type_id IS 7 AND len(field_value) IS 0><!--- EMPTY BOOLEAN --->
								<cfqueryparam cfsqltype="#fields.cf_sql_type#" null="true">
							<cfelse>
								<cfqueryparam value="#field_value#" cfsqltype="#fields.cf_sql_type#">
							</cfif>


						<cfelseif fields.field_type_id IS 18><!---ATTACHED FILE--->

							<cfif isDefined("arguments[field_name]") AND len(arguments[field_name]) GT 0>

								<cfset attachedFileFields = true>
								<cfset fileName = GetPageContext().formScope().getUploadResource(field_name).getName()>
								<cfset acceptFileTypes = fields.list_values>
								<cfset fileType = "."&ListLast(fileName, ".")>
								<cfif len(acceptFileTypes) GT 0>
									<cfif ListFindNoCase(acceptFileTypes, fileType, LIST_TEXT_VALUES_DELIMITER) IS 0>
										<cfthrow message="#fileType# no válido para #fields.name#">
									</cfif>
								</cfif>

							</cfif>

						<cfelse><!---SELECT FIELDS--->
							<cfset selectFields = true>
						</cfif>

					</cfloop>

					<cfif arguments.action NEQ CREATE_ROW>
						WHERE row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">
					</cfif>;
				</cfquery>

				<cfif arguments.action IS CREATE_ROW>

					<!--- Get inserted id --->
					<cfquery name="getLastInsertId" datasource="#client_dsn#">
						SELECT LAST_INSERT_ID() AS last_insert_id FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`;
					</cfquery>

					<cfset row_id = getLastInsertId.last_insert_id>

				<cfelse>

					<cfset row_id = arguments.row_id>

				</cfif>

				<cfif selectFields IS true OR attachedFileFields IS true><!--- Select fields values OR Attached files values---->

					<cfloop query="fields">

						<cfset field_name = "field_#fields.field_id#">

						<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- SELECT --->


							<cfif arguments.action NEQ CREATE_ROW>

								<!--- Delete old selected values --->
								<cfquery name="deleteRowAreas" datasource="#client_dsn#">
									DELETE FROM `#client_abb#_#tableTypeTable#_rows_areas`
									WHERE #tableTypeName#_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
									AND row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">
									AND field_id = <cfqueryparam value="#fields.field_id#" cfsqltype="cf_sql_integer">;
								</cfquery>

							</cfif>

							<cfif isDefined("arguments.#field_name#")>

								<cfset field_values = arguments[field_name]>

								<!--- Save new selected values --->
								<cfloop array="#field_values#" index="select_value">

									<cfif isNumeric(select_value)>

										<cfquery name="addRowAreas" datasource="#client_dsn#">
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


						<cfelseif fields.field_type_id IS 18><!---Attached file--->


							<cfif isDefined("arguments[field_name]") AND len(arguments[field_name]) GT 0>

								<cfif arguments.action NEQ CREATE_ROW>

									<cfinvoke component="#APPLICATION.coreComponentsPath#/RowAttachedFile" method="deleteRowAttachedFileIfExist">
										<cfinvokeargument name="table_id" value="#arguments.table_id#">
										<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
										<cfinvokeargument name="row_id" value="#arguments.row_id#">
										<cfinvokeargument name="field_id" value="#fields.field_id#">
										<cfinvokeargument name="user_id" value="#arguments.user_id#">

										<cfinvokeargument name="client_abb" value="#client_abb#">
										<cfinvokeargument name="client_dsn" value="#client_dsn#">
									</cfinvoke>

								</cfif>

								<cfinvoke component="#APPLICATION.coreComponentsPath#/RowAttachedFile" method="uploadRowAttachedFile" returnvariable="file_id">
									<cfinvokeargument name="table_id" value="#arguments.table_id#">
									<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
									<cfinvokeargument name="row_id" value="#row_id#">
									<cfinvokeargument name="field_id" value="#fields.field_id#">
									<cfinvokeargument name="field_name" value="#field_name#">
									<cfinvokeargument name="user_id" value="#arguments.user_id#">

									<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
									<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
								</cfinvoke>

								<cfquery name="saveRow" datasource="#client_dsn#">
									UPDATE `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`
									SET field_#fields.field_id# = <cfqueryparam value="#file_id#" cfsqltype="#fields.cf_sql_type#">
									WHERE row_id = <cfqueryparam value="#row_id#" cfsqltype="cf_sql_integer">;
								</cfquery>

							</cfif>


						</cfif>

					</cfloop>

				</cfif><!---END selectFields IS true--->


				<!--- setTableLastUpdate --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="setTableLastUpdate">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeTable" value="#tableTypeTable#">
					<cfinvokeargument name="last_update_type" value="#LAST_UPDATE_TYPE_ROW#">
					<cfinvokeargument name="user_id" value="#arguments.user_id#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

				<cfcatch>

					<cfif arguments.with_transaction IS true>
						<cfquery datasource="#client_dsn#" name="rollbackTransaction">
							ROLLBACK;
						</cfquery>
					</cfif>

					<cfrethrow/>

				</cfcatch>

			</cftry>

			<cfif arguments.with_transaction IS true>
				<!--- </cftransaction> --->
				<cfquery datasource="#client_dsn#" name="endTransaction">
					COMMIT;
				</cfquery>
			</cfif>

			<cfif ( arguments.tableTypeId IS 1 OR arguments.tableTypeId IS 2 ) AND arguments.send_alert IS true><!--- IS NOT typology --->

				<!--- getRow --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="rowQuery">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="row_id" value="#row_id#">
					<cfinvokeargument name="fields" value="#fields#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<!--- Alert --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newTableRow">
					<cfinvokeargument name="row_id" value="#row_id#">
					<cfinvokeargument name="rowQuery" value="#rowQuery#">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="user_id" value="#arguments.user_id#">
					<cfinvokeargument name="action" value="#arguments.action#">
					<cfinvokeargument name="fields" value="#fields#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

			</cfif>

			<cfif arguments.tableTypeId IS 1 OR arguments.tableTypeId IS 2>

				<cfif arguments.action IS CREATE_ROW>
					<cfset actionEventTypeId = 1><!--- New row --->
				<cfelse>
					<cfset actionEventTypeId = 2><!--- Update row --->
				</cfif>

				<!--- Action --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/ActionManager" method="throwAction">
					<cfinvokeargument name="row_id" value="#row_id#">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="action_event_type_id" value="#actionEventTypeId#">
					<cfinvokeargument name="user_id" value="#arguments.user_id#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

			</cfif>

		<cfreturn row_id>

	</cffunction>


	<!--- validateDate --->

	<cffunction name="validateDate" returntype="boolean" output="false" access="public">
		<cfargument name="strDate" type="string" required="yes">

		<cfinvoke component="DateManager" method="validateDate" returnvariable="result">
			<cfinvokeargument name="strDate" value="#arguments.strDate#">
		</cfinvoke>

		<cfreturn result>

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
		<cfargument name="withDefaultValues" type="boolean" required="false" default="true">
		<cfargument name="withSearchValues" type="boolean" required="false" default="false">

		<cfset var method = "fillEmptyRow">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfset queryAddRow(emptyRow, 1)>

			<cfloop query="fields">

				<cfif fields.field_type_id NEQ 20><!--- IS NOT SEPARATOR --->

					<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- IS SELECT --->
						<!---Se crean los campos para poder definir en ellos los valores por defecto--->
						<cfset queryAddColumn(emptyRow, "field_#fields.field_id#")>
					</cfif>

					<cfif arguments.withDefaultValues IS true>
						<cfset querySetCell(emptyRow, "field_#fields.field_id#", fields.default_value, 1)>
					<cfelseif arguments.withSearchValues IS true>
						<cfset querySetCell(emptyRow, "field_#fields.field_id#", fields.search_value, 1)>
					</cfif>

				</cfif>

			</cfloop>

		<cfreturn emptyRow>

	</cffunction>


	<!---getTableRows--->

	<cffunction name="getTableRows" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="false">
		<cfargument name="fields" type="query" required="false"><!--- Required to order by fields or search--->
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="areas_ids" type="string" required="false">
		<cfargument name="search" type="string" required="false">
		<cfargument name="categoriesFilter" type="boolean" required="false" default="false">

		<cfargument name="from_date" type="string" required="no">
		<cfargument name="end_date" type="string" required="no">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getTableRows">

		<cfset var subAreasIds = "">
		<cfset var orderBy = "">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfif isDefined("arguments.search") AND NOT isDefined("arguments.fields")>

				<cfinvoke component="FieldQuery" method="getTableFields" returnvariable="fields">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="with_types" value="true">
					<cfinvokeargument name="with_table" value="false">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>

			<cfif isDefined("arguments.area_id")>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreasIds" returnvariable="subAreasIds">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfset subAreasIds = listAppend(subAreasIds, arguments.area_id)>

			</cfif>

			<cfquery name="getTableRows" datasource="#client_dsn#">
				SELECT table_row.*,
				CONCAT_WS(' ', insert_users.family_name, insert_users.name) AS insert_user_full_name, insert_users.image_type AS insert_user_image_type,
				CONCAT_WS(' ', update_users.family_name, update_users.name) AS update_user_full_name, update_users.image_type AS update_user_image_type
				FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` AS table_row
				LEFT JOIN #client_abb#_users AS insert_users ON table_row.insert_user_id = insert_users.id
				LEFT JOIN #client_abb#_users AS update_users ON table_row.last_update_user_id = update_users.id
				<cfif isDefined("arguments.row_id")>
					WHERE table_row.row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">
				<cfelse>

					WHERE 1=1

					<cfif len(subAreasIds) GT 0>

						AND area_id IN (<cfqueryparam value="#subAreasIds#" cfsqltype="cf_sql_integer" list="true">)

					</cfif>

					<cfif isDefined("arguments.areas_ids")>

						AND area_id IN (<cfqueryparam value="#arguments.areas_ids#" cfsqltype="cf_sql_integer" list="true">)

					</cfif>

					<cfif isDefined("arguments.from_date")>
						AND ( table_row.creation_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#dateFormat#')
								OR table_row.last_update_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#dateFormat#')
							)
					</cfif>
					<cfif isDefined("arguments.end_date")>
						AND ( table_row.creation_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#dateTimeFormat#')
							AND IF( table_row.last_update_date IS NULL, true, table_row.last_update_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#dateTimeFormat#') )
							)
					</cfif>

					<cfif isDefined("arguments.search") OR arguments.categoriesFilter IS true>
						<cfinclude template="#APPLICATION.coreComponentsPath#/includes/tableRowsSearchFields.cfm">
					</cfif>

					<cfif isDefined("arguments.fields")>

						<cfloop query="fields">
							<cfif fields.field_type_id NEQ 20><!--- IS NOT SEPARATOR --->

								<cfif isNumeric(fields.field_id) AND len(fields.sort_by_this) GT 0 AND fields.field_type_id NEQ 9 AND fields.field_type_id NEQ 10><!---No se puede ordenar aquí por los campos tipo lista porque no se dispone de sus valores en esta consulta--->
									<cfif len(orderBy) GT 0>
										<cfset orderBy = orderBy&",">
									</cfif>
									<cfset orderBy = orderBy&"field_#fields.field_id# #fields.sort_by_this#">
								</cfif>

							</cfif>
						</cfloop>

					</cfif>

					<cfif len(orderBy) GT 0>
						ORDER BY #orderBy#
					<cfelse>
						ORDER BY table_row.row_id DESC
					</cfif>
				</cfif>;
			</cfquery>

		<cfreturn getTableRows>

	</cffunction>


	<!---getTableRowCount--->

	<cffunction name="getTableRowCount" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="areas_ids" type="string" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getTableRowCount">

		<cfset var subAreasIds = "">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfif isDefined("arguments.area_id")>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreasIds" returnvariable="subAreasIds">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfset subAreasIds = listAppend(subAreasIds, arguments.area_id)>

			</cfif>

			<cfquery name="getTableRows" datasource="#client_dsn#">
				SELECT count(*) AS count

				FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` AS table_row

				<cfif len(subAreasIds) GT 0>

					WHERE area_id IN (<cfqueryparam value="#subAreasIds#" cfsqltype="cf_sql_integer" list="true">)

				</cfif>

				<cfif isDefined("arguments.areas_ids")>

					WHERE area_id IN (<cfqueryparam value="#arguments.areas_ids#" cfsqltype="cf_sql_integer" list="true">)

				</cfif>;
			</cfquery>

		<cfreturn getTableRows>

	</cffunction>



	<!---getTableRowsSearch--->

	<!---
	<cffunction name="getTableRowsSearch" output="false" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="area_id" type="numeric" required="no">
		<cfargument name="areas_ids" type="string" required="no">

		<cfargument name="name" type="string" required="false">
		<cfargument name="file_name" type="string" required="false">
		<cfargument name="description" type="string" required="false">
		<cfargument name="user_in_charge" type="numeric" required="false">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="limit" type="numeric" required="false">

		<cfargument name="from_date" type="string" required="no">
		<cfargument name="end_date" type="string" required="no">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getTableRowsSearch">

		<cfset var count = 0>
		<cfset var name_re = "">
		<cfset var file_name_re = "">
		<cfset var description_re = "">

		<cfset var selectFields = false>

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">


			<cfinvoke component="FieldQuery" method="getTableFields" returnvariable="fields">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="with_types" value="true">
				<cfinvokeargument name="with_table" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<!---<cfquery dbtype="query" name="selectFieldsCount">
				SELECT field_id
				FROM fields
				WHERE field_type_id = 9 OR field_type_id = 10;
			</cfquery>
			<cffif selectFieldsCount.recordCount GT 0>
				<cfset selectFields = true>
			</cffif>--->

			<cftransaction>

				<cfquery name="getTableRowsSearch" datasource="#client_dsn#">
					SELECT table_row.*,
					CONCAT_WS(' ', insert_users.family_name, insert_users.name) AS insert_user_full_name, insert_users.image_type AS insert_user_image_type,
					CONCAT_WS(' ', update_users.family_name, update_users.name) AS update_user_full_name, update_users.image_type AS update_user_image_type
					FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` AS table_row
					LEFT JOIN #client_abb#_users AS insert_users ON table_row.insert_user_id = insert_users.id
					LEFT JOIN #client_abb#_users AS update_users ON table_row.last_update_user_id = update_users.id
					FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` AS table_row
					<!---LEFT JOIN #client_abb#_users AS insert_users ON table_row.insert_user_id = insert_users.id
					LEFT JOIN #client_abb#_users AS update_users ON table_row.last_update_user_id = update_users.id--->

					<!---INNER JOIN #client_abb#_users AS users ON files.user_in_charge = users.id--->

					<cfinclude template="#APPLICATION.coreComponentsPath#/includes/tableRowsSearchFields.cfm">

					<cfif isDefined("arguments.limit")>
					LIMIT #arguments.limit#
					</cfif>;
				</cfquery>

				<cfif isDefined("arguments.limit")>
					<cfquery datasource="#client_dsn#" name="getCount">
						SELECT FOUND_ROWS() AS count;
					</cfquery>
					<cfset count = getCount.count>
				</cfif>

			</cftransaction>

		<cfreturn {query=getTableRowsSearch, count=count}>

	</cffunction>--->



	<!---getTypologiesRowsSearch--->

	<cffunction name="getTypologiesRowsSearch" output="false" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="area_id" type="numeric" required="no">
		<cfargument name="areas_ids" type="string" required="no">

		<cfargument name="name" type="string" required="false">
		<cfargument name="file_name" type="string" required="false">
		<cfargument name="description" type="string" required="false">
		<cfargument name="user_in_charge" type="numeric" required="false">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="limit" type="numeric" required="false">

		<cfargument name="from_date" type="string" required="no">
		<cfargument name="end_date" type="string" required="no">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getTypologiesRowsSearch">

		<cfset var count = 0>
		<cfset var name_re = "">
		<cfset var file_name_re = "">
		<cfset var description_re = "">

		<cfset var selectFields = false>

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">


			<cfinvoke component="FieldQuery" method="getTableFields" returnvariable="fields">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="with_types" value="true">
				<cfinvokeargument name="with_table" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<!---<cfquery dbtype="query" name="selectFieldsCount">
				SELECT field_id
				FROM fields
				WHERE field_type_id = 9 OR field_type_id = 10;
			</cfquery>
			<cffif selectFieldsCount.recordCount GT 0>
				<cfset selectFields = true>
			</cffif>--->

			<cfif isDefined("arguments.name") AND len(arguments.name) GT 0>
				<cfinvoke component="#APPLICATION.coreComponentsPath#/SearchManager" method="generateSearchText" returnvariable="name_re">
					<cfinvokeargument name="text" value="#arguments.name#">
				</cfinvoke>
			</cfif>

			<cfif isDefined("arguments.file_name") AND len(arguments.file_name) GT 0>
				<cfinvoke component="#APPLICATION.coreComponentsPath#/SearchManager" method="generateSearchText" returnvariable="file_name_re">
					<cfinvokeargument name="text" value="#arguments.file_name#">
				</cfinvoke>
			</cfif>

			<cfif isDefined("arguments.description") AND len(arguments.description) GT 0>
				<cfinvoke component="#APPLICATION.coreComponentsPath#/SearchManager" method="generateSearchText" returnvariable="description_re">
					<cfinvokeargument name="text" value="#arguments.description#">
				</cfinvoke>
			</cfif>

			<cftransaction>

				<cfquery name="getTableRows" datasource="#client_dsn#">
					SELECT table_row.row_id
					, files.id, files.file_name, files.user_in_charge, files.file_size, files.file_type, files.name, files.file_name, files.description, files.file_type_id,
					IF( replacement_date IS NULL, IF(association_date IS NULL, uploading_date, association_date), replacement_date ) AS last_version_date,
					IF( a.area_id IS NULL, files.area_id, a.area_id ) AS area_id
					, DATE_FORMAT(files.uploading_date, '#dateTimeFormat#') AS uploading_date
					, DATE_FORMAT(files.replacement_date, '#dateTimeFormat#') AS replacement_date
					, DATE_FORMAT(a.association_date, '#dateTimeFormat#') AS association_date
					, users.family_name, users.name AS user_name, users.image_type AS user_image_type,
					CONCAT_WS(' ', users.family_name, users.name) AS user_full_name
					, areas.name AS area_name
					FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` AS table_row
					<!---LEFT JOIN #client_abb#_users AS insert_users ON table_row.insert_user_id = insert_users.id
					LEFT JOIN #client_abb#_users AS update_users ON table_row.last_update_user_id = update_users.id--->
					INNER JOIN #client_abb#_files AS files ON table_row.row_id = files.typology_row_id
					AND files.typology_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
					INNER JOIN #client_abb#_areas_files AS a ON files.id = a.file_id
					<cfif isDefined("arguments.areas_ids")>
						AND a.area_id IN (<cfqueryparam value="#arguments.areas_ids#" cfsqltype="cf_sql_varchar" list="yes">)
					<cfelse>
						AND a.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					</cfif>
					INNER JOIN #client_abb#_users AS users ON files.user_in_charge = users.id
					INNER JOIN #client_abb#_areas AS areas ON a.area_id = areas.id
					WHERE files.status = 'ok'
					<cfif isDefined("arguments.user_in_charge")>
						AND files.user_in_charge = <cfqueryparam value="#arguments.user_in_charge#" cfsqltype="cf_sql_integer">
					</cfif>

					<cfif isDefined("arguments.categories_ids")>

						<cfloop array="#arguments.categories_ids#" index="category_id">
							<cfif isNumeric(category_id)>
							AND files.id IN ( SELECT item_id FROM `#client_abb#_items_categories`
								WHERE item_type_id = 10
								AND area_id = <cfqueryparam value="#category_id#" cfsqltype="cf_sql_integer"> )
							</cfif>
						</cfloop>

					</cfif>

					<cfif isDefined("arguments.from_date") AND len(arguments.from_date) GT 0>
						AND ( files.uploading_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#dateFormat#')
							OR files.replacement_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#dateFormat#') )
					</cfif>
					<cfif isDefined("arguments.end_date") AND len(arguments.end_date) GT 0>
						AND ( files.uploading_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#dateTimeFormat#')
							OR files.replacement_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#dateTimeFormat#') )
					</cfif>
					<cfif len(name_re) GT 0>
						AND	files.name REGEXP <cfqueryparam value="#name_re#" cfsqltype="cf_sql_varchar">
					</cfif>
					<cfif len(file_name_re) GT 0>
						AND	files.file_name REGEXP <cfqueryparam value="#file_name_re#" cfsqltype="cf_sql_varchar">
					</cfif>
					<cfif len(description_re) GT 0>
						AND	files.description REGEXP <cfqueryparam value="#description_re#" cfsqltype="cf_sql_varchar">
					</cfif>

					<cfinclude template="#APPLICATION.coreComponentsPath#/includes/tableRowsSearchFields.cfm">

					ORDER BY last_version_date DESC
					<cfif isDefined("arguments.limit")>
					LIMIT #arguments.limit#
					</cfif>;
				</cfquery>

				<cfif isDefined("arguments.limit")>
					<cfquery datasource="#client_dsn#" name="getCount">
						SELECT FOUND_ROWS() AS count;
					</cfquery>
					<cfset count = getCount.count>
				</cfif>

			</cftransaction>

		<cfreturn {query=getTableRows, count=count}>

	</cffunction>




	<!---getTableRowAttachedFiles--->

	<cffunction name="getTableRowAttachedFiles" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="false">
		<cfargument name="area_id" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getTableRowAttachedFiles">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfquery name="getRowAttachedFile" datasource="#client_dsn#">
				SELECT files.*
				FROM `#client_abb#_files` AS files
				<cfif isDefined("arguments.area_id")>
					INNER JOIN `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` AS table_rows ON table_rows.row_id = files.row_id
					AND table_rows.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfif>
				WHERE files.item_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
				AND files.item_type_id = <cfqueryparam value="#itemTypeId#" cfsqltype="cf_sql_integer">
				<cfif isDefined("arguments.row_id")>
					AND files.row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">
				</cfif>;
			</cfquery>

		<cfreturn getRowAttachedFile>

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
					FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` AS tables_rows;
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


	<!--- ------------------------------------- deleteRow -------------------------------------  --->

	<cffunction name="deleteRow" output="false" access="public" returntype="void">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteRow">

		<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

		<!--- getTableRowAttachedFiles --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRowAttachedFiles" returnvariable="rowAttachedFilesQuery">
			<cfinvokeargument name="table_id" value="#arguments.table_id#">
			<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			<cfinvokeargument name="row_id" value="#arguments.row_id#">

			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
		</cfinvoke>

		<cftransaction>

			<cfif rowAttachedFilesQuery.recordCount GT 0>

				<cfloop query="rowAttachedFilesQuery">

					<cfinvoke component="#APPLICATION.coreComponentsPath#/RowAttachedFile" method="deleteRowAttachedFile">
						<cfinvokeargument name="file_id" value="#rowAttachedFilesQuery.id#">
						<cfinvokeargument name="table_id" value="#arguments.table_id#">
						<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
						<cfinvokeargument name="row_id" value="#arguments.row_id#">
						<cfinvokeargument name="field_id" value="#rowAttachedFilesQuery.field_id#">
						<cfinvokeargument name="user_id" value="#arguments.user_id#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

				</cfloop>

			</cfif>

			<!---Delete selected areas--->
			<cfquery name="deleteSelectedAreasQuery" datasource="#client_dsn#">
				DELETE FROM `#client_abb#_#tableTypeTable#_rows_areas`
				WHERE #tableTypeName#_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
				AND row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<!---Delete row--->
			<cfquery name="deleteRow" datasource="#client_dsn#">
				DELETE FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`
				WHERE row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<!--- setTableLastUpdate --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="setTableLastUpdate">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeTable" value="#tableTypeTable#">
				<cfinvokeargument name="last_update_type" value="#LAST_UPDATE_TYPE_ROW#">
				<cfinvokeargument name="user_id" value="#arguments.user_id#">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

		</cftransaction>

		<!--- saveLog --->
		<cfinclude template="includes/logRecord.cfm">


	</cffunction>


	<!--- ------------------------------------ deleteTableRows -----------------------------------  --->

	<cffunction name="deleteTableRows" output="false" access="public" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="resetAutoIncrement" type="boolean" required="false" default="false">
		<cfargument name="user_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteTableRows">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<!--- getTableRowAttachedFiles --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRowAttachedFiles" returnvariable="rowAttachedFilesQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfif rowAttachedFilesQuery.recordCount GT 0>

				<cfloop query="rowAttachedFilesQuery">

					<cfinvoke component="#APPLICATION.coreComponentsPath#/RowAttachedFile" method="deleteRowAttachedFile">
						<cfinvokeargument name="file_id" value="#rowAttachedFilesQuery.id#">
						<cfinvokeargument name="table_id" value="#arguments.table_id#">
						<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
						<cfinvokeargument name="row_id" value="#rowAttachedFilesQuery.row_id#">
						<cfinvokeargument name="field_id" value="#rowAttachedFilesQuery.field_id#">
						<cfinvokeargument name="user_id" value="#arguments.user_id#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

				</cfloop>

			</cfif>

			<!---Delete rows--->
			<cfquery name="deleteRows" datasource="#client_dsn#">
				DELETE FROM `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`
				<cfif isDefined("arguments.area_id")>
					WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfif>;
			</cfquery>

			<!---Delete selected areas--->
			<cfquery name="deleteSelectedAreasQuery" datasource="#client_dsn#">
				DELETE FROM `#client_abb#_#tableTypeTable#_rows_areas`
				WHERE #tableTypeName#_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif arguments.resetAutoIncrement IS true>
				<!--- Reset auto increment --->
				<cfquery name="resetAutoIncrement" datasource="#client_dsn#">
					ALTER TABLE `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` AUTO_INCREMENT = 1;
				</cfquery>
			</cfif>

	</cffunction>



	<!--- ------------------------------------ deleteAreaGeneralTablesRows -----------------------------------  --->

	<cffunction name="deleteAreaGeneralTablesRows" output="false" access="public" returntype="void">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteAreaGeneralTablesRows">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getAllTables" returnvariable="getGeneralTablesResult">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

				<cfinvokeargument name="general" value="true"/>

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset generalTables = getGeneralTablesResult.query>

			<cfloop query="generalTables">

				<cfinvoke component="#APPLICATION.coreComponentsPath#/TableManager" method="hasTableRowsInThisArea" returnvariable="hasTableRowsInThisArea">
					<cfinvokeargument name="table_id" value="#generalTables.id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif hasTableRowsInThisArea.rowsInThisArea IS true>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="deleteTableRows">
						<cfinvokeargument name="table_id" value="#generalTables.id#">
						<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
						<cfinvokeargument name="resetAutoIncrement" value="false">
						<cfinvokeargument name="user_id" value="#arguments.user_id#">
						<cfinvokeargument name="area_id" value="#arguments.area_id#">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>

			</cfloop>

	</cffunction>


</cfcomponent>

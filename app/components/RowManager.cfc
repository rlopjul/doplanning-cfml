<!--- Copyright Era7 Information Technologies 2007-2014 --->

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

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTable" returnvariable="tableQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="parse_dates" value="false">
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif tableQuery.recordCount IS 0><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfif arguments.tableTypeId IS 2 AND arguments.action EQ "modify"><!--- Modify Form --->
				<cfthrow message="No se puede modificar un registro de #tableTypeNameEs#">
			</cfif>

			<!---canUserModifyRow--->
			<cfinvoke component="RowManager" method="canUserModifyRow" returnvariable="canUserModifyRow">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="table" value="#tableQuery#">
				<cfif isDefined("arguments.row_id")>
						<cfinvokeargument name="row_id" value="#arguments.row_id#">
				</cfif>
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

			<!--- saveRow --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="saveRow" argumentcollection="#arguments#" returnvariable="row_id">

				<cfinvokeargument name="fields" value="#fields#">
				<cfinvokeargument name="user_id" value="#user_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, row_id=#row_id#, table_id=#arguments.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ------------------------------------- importRows -------------------------------------  --->

	<cffunction name="importRows" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="file" type="string" required="true">
		<cfargument name="delimiter" type="string" required="true">
		<cfargument name="start_row" type="numeric" required="false" default="2">
		<cfargument name="delete_rows" type="boolean" required="false" default="false">
		<cfargument name="cancel_on_error" type="boolean" required="false" default="true">
		<cfargument name="decimals_with_mask" type="boolean" required="false" default="false">

		<cfset var method = "importRows">

		<cfset var response = structNew()>

		<cfset var destination = "">
		<cfset var fileContent = "">
		<cfset var fileArray = arrayNew(1)>
		<cfset var rowValues = structNew()>
		<cfset var fieldValue = "">

		<cfset var errorMessages = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTable" returnvariable="tableQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="parse_dates" value="false">
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif tableQuery.recordCount IS 0><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<!---canUserModifyRow--->
			<cfinvoke component="RowManager" method="canUserModifyRow" returnvariable="canUserModifyRow">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="table" value="#tableQuery#">
			</cfinvoke>
			<cfif canUserModifyRow IS false>
				<cfthrow message="No tiene permiso para acceder a editar esta #tableTypeNameEs#">
			</cfif>

			<!---Table fields--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getTableFields" returnvariable="fields">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="with_types" value="true">
				<cfinvokeargument name="with_table" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset destination = "#APPLICATION.filesPath#/#client_abb#/">

			<!--- Upload and read file --->
			<cffile action="upload" filefield="file" destination="#destination#" nameconflict="makeunique" result="fileResult" charset="Windows-1252" accept="text/plain,text/csv,text/comma-separated-values,text/tab-separated-values,application/csv,application/vnd.ms-excel"><!--- application/vnd.ms-excel es necesario para IE ---><!---charset usado anteriormente: iso-8859-1--->

			<cfset destinationFile = destination&fileResult.serverFile>

			<cffile action="read" file="#destinationFile#" variable="fileContent" charset="Windows-1252">
			<cffile action="delete" file="#destinationFile#">

			<cfset fileContentStart = left(fileContent, 6)>

			<cfif fileContentStart EQ "sep=;#chr(10)#">

				<!---Borra el código de compatibilidad añadido en la exportación para versiones de Office desde 2010--->

				<cfset fileContent = right(fileContent, len(fileContent)-6)>

			</cfif>

			<!--- CSV to array --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="CSVToArray" returnvariable="fileArray">
				<cfinvokeargument name="CSV" value="#trim(#fileContent#)#">
				<cfif arguments.delimiter EQ "tab">
					<cfinvokeargument name="delimiter" value="#chr(9)#">
				<cfelse>
					<cfinvokeargument name="delimiter" value="#arguments.delimiter#">
				</cfif>
			</cfinvoke>

			<cfset numFileColumns = arrayLen(fileArray[1])>

			<cfif fields.recordCount NEQ numFileColumns>

				<cfset response = {result=false, fileArray=fileArray, message="El número de columnas del archivo (#numFileColumns#) no corresponde con las necesarias para la importación (#fields.recordCount#)"}>

				<cfreturn response>

			</cfif>


			<!--- getFieldMaskTypes --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldManager" method="getFieldMaskTypesStruct" returnvariable="maskTypesStruct">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			</cfinvoke>

			<cfif arguments.cancel_on_error IS true>
				<cfquery datasource="#client_dsn#" name="startTransaction">
					START TRANSACTION;
				</cfquery>
			</cfif>

			<cftry>

				<!--- Delete Rows --->
				<cfif arguments.delete_rows IS true>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="deleteTableRows">
						<cfinvokeargument name="table_id" value="#arguments.table_id#">
						<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
						<cfinvokeargument name="resetAutoIncrement" value="true">
						<cfinvokeargument name="user_id" value="#SESSION.user_id#">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>

				<cfset areasQueries = structNew()>

				<cfloop query="fields">

					<cfif fields.field_type_id EQ 9 OR fields.field_type_id EQ 10><!--- LISTS --->

						<!--- Load field areas --->

						<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreas" returnvariable="areasQuery">
							<cfinvokeargument name="area_id" value="#fields.list_area_id#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

						<cfset areasQueries[fields.field_id] = areasQuery>

					</cfif>

				</cfloop>

				<cfloop from="#arguments.start_row#" to="#ArrayLen(fileArray)#" step="1" index="curRow"><!--- loop Rows --->

					<cfset error = false>

					<cfset curColumn = 1>

					<cfloop query="fields"><!--- loop Columns --->

						<cfset errorMessage = "">
						<cfset errorMessagePrefix = "Error en fila #curRow#, columna #curColumn#: ">

						<cfset fieldName = "field_#fields.field_id#">

						<cfset fieldValue = trim(fileArray[curRow][curColumn])>

						<cfif fields.field_type_id IS 5><!---DECIMAL--->

							<cfif isNumeric(fields.mask_type_id) AND arguments.decimals_with_mask IS true><!---Hay máscara seleccionada en el campo y los datos importados del archivo están especificados como en la máscara--->

								<cfset cf_prefix = maskTypesStruct[fields.mask_type_id].cf_prefix>
								<cfset cf_sufix = maskTypesStruct[fields.mask_type_id].cf_sufix>
								<cfset cf_prefix_len = len(cf_prefix)>
								<cfset cf_sufix_len = len(cf_sufix)>
								<cfset decimal_delimiter = maskTypesStruct[fields.mask_type_id].decimal_delimiter>

								<cfif cf_prefix_len GT 0 AND cf_prefix EQ left(fieldValue, cf_prefix_len)>
									<!---Se borra el prefijo--->
									<cfset fieldValue = right(fieldValue, len(fieldValue)-cf_prefix_len)>

								</cfif>

								<cfif decimal_delimiter EQ "."><!---Decimales separados por punto--->

									<!---Se borran las comas que puede haber en los millares--->
									<cfset fieldValue = replace(fieldValue, ",", "", "ALL")>

								<cfelseif decimal_delimiter EQ ","><!---Decimales separados por coma--->

									<!---Se borran los puntos que puede haber en los millares---->
									<cfset fieldValue = replace(fieldValue, ".", "", "ALL")>

									<!---Se sustituyen las comas por puntos--->
									<cfset fieldValue = replace(fieldValue, ",", ".", "ALL")>

								</cfif>

								<cfif cf_sufix_len GT 0 AND cf_sufix EQ right(fieldValue, cf_sufix_len)>
									<!---Se borra el sufijo--->
									<cfset fieldValue = left(fieldValue, len(fieldValue)-cf_sufix_len)>
								</cfif>


							</cfif>

						<cfelseif fields.field_type_id IS 6><!--- DATE --->

							<cfif len(fieldValue) GT 0>

								<cfif findOneOf("/", fieldValue) GT 0>

									<cfset fieldValue = replace(fieldValue, "/", "-", "all")>

								</cfif>

								<cfinvoke component="#APPLICATION.coreComponentsPath#/DateManager" method="validateDate" returnvariable="result">
									<cfinvokeargument name="strDate" value="#fieldValue#">
								</cfinvoke>

							</cfif>

						<cfelseif fields.field_type_id IS 7><!--- BOOLEAN --->

							<cfif len(fieldValue) GT 0>

								<cfif fieldValue EQ "Sí" OR fieldValue EQ "Si" OR fieldValue EQ "Yes" OR fieldValue EQ true OR fieldValue EQ 1>
									<cfset fieldValue = 1>
								<cfelseif fieldValue EQ "No" OR fieldValue EQ false OR fieldValue EQ 0>
									<cfset fieldValue = 0>
								<cfelse>
									<!--- Error --->
									<cfset errorMessage = errorMessagePrefix&"Valor incorrecto (#fieldValue#) para campo Sí/No">
								</cfif>

							</cfif>

						<cfelseif fields.field_type_id EQ 9 OR fields.field_type_id EQ 10><!--- AREAS LISTS --->

							<cfset fieldAreasQuery = areasQueries[fields.field_id]>

							<cfif fields.field_type_id IS 10><!--- Multiple areas selection --->

								<cfif listLen(fieldValue, ";") GT 0>

									<cfset newFieldValue = arrayNew(1)>

									<cfloop list="#fieldValue#" index="curFieldValue" delimiters=";">

										<!---
										De esta forma dan problemas algunos caracteres especiales porque al hacer la comparación con el LIKE no concuerdan
										<cfquery dbtype="query" name="getAreaValue">
											SELECT id
											FROM fieldAreasQuery
											WHERE name LIKE <cfqueryparam value="#curFieldValue#" cfsqltype="cf_sql_varchar">;
										</cfquery>

										<cfif getAreaValue.recordCount GT 0>
											<cfset arrayAppend(newFieldValue, getAreaValue.id)>
										</cfif>--->

										<cfloop query="fieldAreasQuery">

											<cfif fieldAreasQuery.name EQ curFieldValue>

												<cfset arrayAppend(newFieldValue, getAreaValue.id)>

											</cfif>

										</cfloop>

									</cfloop>

									<cfset fieldValue = newFieldValue>

								<cfelse>
									<cfset fieldValue = arrayNew(1)>
								</cfif>

							<cfelse>

								<!---
								De esta forma dan problemas algunos caracteres especiales porque al hacer la comparación con el LIKE no concuerdan
								<cfquery dbtype="query" name="getAreaValue">
									SELECT id
									FROM fieldAreasQuery
									WHERE name LIKE <cfqueryparam value="#fieldValue#" cfsqltype="cf_sql_varchar">;
								</cfquery>

								<cfif getAreaValue.recordCount GT 0>
									<!--- List values required array --->
									<cfset fieldValue = [getAreaValue.id]>
								<cfelse>
									<cfset fieldValue = arrayNew(1)>
								</cfif>
								--->
								<cfset fieldValueText = fieldValue>
								<cfset fieldValue = arrayNew(1)>

								<cfloop query="fieldAreasQuery">

									<cfif fieldAreasQuery.name EQ fieldValueText>

										<!--- List values required array --->
										<cfset fieldValue = [fieldAreasQuery.id]>

									</cfif>

								</cfloop>


							</cfif>

						<cfelseif fields.field_type_id EQ 15 OR fields.field_type_id EQ 16><!--- LISTS TEXT VALUES --->


							<cfif fields.field_type_id IS 16><!--- Multiple areas selection --->

								<cfif listLen(fieldValue, ";") GT 0>

									<cfset fieldValue = listToArray(fieldValue,";")>

								<cfelse>
									<cfset fieldValue = arrayNew(1)>
								</cfif>

							<cfelse>

								<cfif len(fieldValue) GT 0>
									<!--- List values required array --->
									<cfset fieldValue = [fieldValue]>
								<cfelse>
									<cfset fieldValue = arrayNew(1)>
								</cfif>

							</cfif>


						<cfelse>

							<cfif fields.field_type_id EQ 3 OR fields.field_type_id EQ 11><!--- LONG TEXT --->

								<!--- INSERT <br> --->
								<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="insertBR" returnvariable="fieldValue">
									<cfinvokeargument name="string" value="#fieldValue#">
								</cfinvoke>

							</cfif>

							<cfset fieldValueLen = len(fieldValue)>

							<cfif len(errorMessage) IS 0 AND fieldValueLen GT fields.max_length>

								<!--- Error --->
								<cfset errorMessage = errorMessagePrefix&"El número de caracteres (#fieldValueLen#) es mayor del permitido para esa columna (#fields.max_length#)">

							</cfif>

						</cfif>

						<cfif len(errorMessage) GT 0><!--- Errors --->

							<cfset error = true>

							<cfif arguments.cancel_on_error IS true>

								<!--- Se lanza un error con cthrow para que se haga ROLLBACK --->
								<cfthrow message="#errorMessage#">

							<cfelse>

								<cfif len(errorMessages) GT 0>
									<cfset errorMessages = errorMessages&"<br>"&errorMessage>
								<cfelse>
									<cfset errorMessages = errorMessage>
								</cfif>

							</cfif>

						</cfif>

						<cfset rowValues[fieldName] = fieldValue>

						<cfset curColumn = curColumn+1>

					</cfloop>

					<cfif error IS false><!--- No error --->

						<cftry>

							<!--- saveRow --->
							<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="saveRow" argumentcollection="#rowValues#" returnvariable="row_id">
								<cfinvokeargument name="table_id" value="#arguments.table_id#">
								<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

								<cfinvokeargument name="action" value="create">

								<cfinvokeargument name="fields" value="#fields#">
								<cfinvokeargument name="user_id" value="#user_id#">
								<cfinvokeargument name="send_alert" value="false">
								<cfif arguments.cancel_on_error IS true>
									<cfinvokeargument name="with_transaction" value="false">
								<cfelse>
									<cfinvokeargument name="with_transaction" value="true">
								</cfif>

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

							<cfcatch>

								<cfset errorMessagePrefix = "Error en fila #curRow#: ">
								<cfset errorMessage = errorMessagePrefix&cfcatch.message>

								<cfif arguments.cancel_on_error IS true>

									<!--- Se lanza un error con cthrow para que se haga ROLLBACK --->
									<cfthrow message="#errorMessage#">

								<cfelse>

									<cfif len(errorMessages) GT 0>
										<cfset errorMessages = errorMessages&"<br>"&errorMessage>
									<cfelse>
										<cfset errorMessages = errorMessage>
									</cfif>

								</cfif>

							</cfcatch>

						</cftry>

					</cfif>

				</cfloop>

				<cfcatch>

					<cfif arguments.cancel_on_error IS true>
						<cfquery datasource="#client_dsn#" name="rollbackTransaction">
							ROLLBACK;
						</cfquery>
					</cfif>

					<cfrethrow/>

				</cfcatch>

			</cftry>

			<cfif arguments.cancel_on_error IS true>
				<cfquery datasource="#client_dsn#" name="endTransaction">
					COMMIT;
				</cfquery>
			</cfif>

			<cfinclude template="includes/logRecord.cfm">

			<cfif len(errorMessages) GT 0>
				<cfset response = {result=false, message=errorMessages, fileArray=fileArray}>
			<cfelse>
				<cfset response = {result=true, table_id=arguments.table_id}>
			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

				<cfset response = {result=false, message=cfcatch.message, fileArray=fileArray}>

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ------------------------------------- generateRowsQuery -------------------------------------  --->

	<cffunction name="generateRowsQuery" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="include_creation_date" type="boolean" required="false" default="false">
		<cfargument name="include_last_update_date" type="boolean" required="false" default="false">
		<cfargument name="include_insert_user" type="boolean" required="false" default="false">
		<cfargument name="include_update_user" type="boolean" required="false" default="false">
		<cfargument name="decimals_with_mask" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true"/>
		<cfargument name="client_dsn" type="string" required="true"/>

		<cfset var method = "exportRows">

		<cfset var response = structNew()>

		<cfset var rowsQuery = "">
		<cfset var listFields = false>
		<cfset var fieldsNames = "">
		<cfset var fieldsLabels = "">


			<!---Table fields--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getTableFields" returnvariable="fields">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="with_types" value="true">
				<cfinvokeargument name="with_table" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<!--- Table rows --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="rowsQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif rowsQuery.recordCount GT 0>

				<cfif arguments.include_creation_date IS true>
					<cfset fieldsNames = listAppend(fieldsNames, "creation_date", ",")>
					<cfset fieldsLabels = listAppend(fieldsLabels, "Fecha de creación",  ",")>
				</cfif>

				<cfif arguments.include_last_update_date IS true>
					<cfset fieldsNames = listAppend(fieldsNames, "last_update_date", ",")>
					<cfset fieldsLabels = listAppend(fieldsLabels, "Última modificación",  ",")>
				</cfif>

				<cfif arguments.include_insert_user IS true>
					<cfset fieldsNames = listAppend(fieldsNames, "insert_user_full_name", ",")>
					<cfset fieldsLabels = listAppend(fieldsLabels, "Creado por",  ",")>
				</cfif>

				<cfif arguments.include_update_user IS true>
					<cfset fieldsNames = listAppend(fieldsNames, "update_user_full_name", ",")>
					<cfset fieldsLabels = listAppend(fieldsLabels, "Modificado por",  ",")>
				</cfif>

				<!---<cfif arguments.include_creation_date IS true>
					<cfset fieldsLabels = fieldsLabels&"Fecha de creación,">
				</cfif>

				<cfif arguments.include_last_update_date IS true>
					<cfset fieldsLabels = fieldsLabels&"Última modificación,">
				</cfif>

				<cfif arguments.include_insert_user IS true>
					<cfset fieldsLabels = fieldsLabels&"Creado por,">
				</cfif>

				<cfif arguments.include_update_user IS true>
					<cfset fieldsLabels = fieldsLabels&"Modificado por,">
				</cfif>

				<cfset fieldsLabels = fieldsLabels&valueList(fields.label, ",")>--->

				<cfloop query="fields">

					<cfset fieldName = "field_#fields.field_id#">
					<cfset fieldsNames = listAppend(fieldsNames, fieldName, ",")>

					<cfif fields.field_type_id EQ 9 OR fields.field_type_id IS 10><!--- LISTS --->

						<cfset listFields = true>
						<cfset queryAddColumn(rowsQuery, fieldName, "VarChar", arrayNew(1))>

					</cfif>

					<cfif len(fields.label) GT 0>
						<cfset fieldsLabels = listAppend(fieldsLabels, replace(fields.label, ",", " ", "ALL"), ",")>
					<cfelse>
						<cfset fieldsLabels = listAppend(fieldsLabels, " ", ",")>
					</cfif>

				</cfloop>

				<cfif arguments.decimals_with_mask IS true OR listFields IS true>

					<cfif arguments.decimals_with_mask IS true>

						<!--- getFieldMaskTypes --->
						<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldManager" method="getFieldMaskTypesStruct" returnvariable="maskTypesStruct">
							<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
						</cfinvoke>

					</cfif>

					<cfif listFields IS true>

						<!--- Get selected areas --->
						<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getRowSelectedAreas" returnvariable="selectedAreasQuery">
							<cfinvokeargument name="table_id" value="#arguments.table_id#">
							<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

					</cfif>


					<cfif arguments.decimals_with_mask IS true OR selectedAreasQuery.recordCount GT 0>

						<cfloop query="rowsQuery">

							<cfset curRow = rowsQuery.currentRow>

							<cfloop query="fields">

								<cfset fieldName = "field_#fields.field_id#">

								<cfif arguments.decimals_with_mask IS true AND fields.field_type_id IS 5><!--- DECIMAL --->

									<cfif isNumeric(fields.mask_type_id)>

										<cfset fieldValue = rowsQuery[fieldName]>

										<cfif len(fieldValue) GT 0>

											<cfset field_mask_type_id = fields.mask_type_id>

											<cfset cf_data_mask = maskTypesStruct[field_mask_type_id].cf_data_mask>
											<cfset cf_prefix = maskTypesStruct[field_mask_type_id].cf_prefix>
											<cfset cf_sufix = maskTypesStruct[field_mask_type_id].cf_sufix>
											<cfset cf_locale = maskTypesStruct[field_mask_type_id].cf_locale>
											<cfset fieldValue = cf_prefix&LSnumberFormat(fieldValue, cf_data_mask, cf_locale)&cf_sufix>

											<cfset querySetCell(rowsQuery, fieldName, fieldValue, curRow)>

										</cfif>

									</cfif>

								<cfelseif listFields IS true AND ( fields.field_type_id EQ 9 OR fields.field_type_id IS 10 )><!--- LISTS --->

									<cfset fieldValue = "">

									<cfquery dbtype="query" name="rowSelectedAreas">
										SELECT name
										FROM selectedAreasQuery
										WHERE field_id = <cfqueryparam value="#fields.field_id#" cfsqltype="cf_sql_integer">
										AND row_id = <cfqueryparam value="#rowsQuery.row_id#" cfsqltype="cf_sql_integer">;
									</cfquery>

									<cfif rowSelectedAreas.recordCount GT 0>
										<cfset fieldValue = valueList(rowSelectedAreas.name, ";")><!--- , --->
									</cfif>

									<!--- <cfset rowValues[fieldName] = fieldValue> --->
									<cfset querySetCell(rowsQuery, fieldName, fieldValue, curRow)>

								</cfif>

							</cfloop>

						</cfloop>

					</cfif>

				</cfif>

			</cfif>

			<cfset response = {result=true, table_id=arguments.table_id, rowsQuery=#rowsQuery#, fieldsNames=#fieldsNames#, fieldsLabels=#fieldsLabels# }>

		<cfreturn response>


	</cffunction>


	<!--- ------------------------------------- exportRows -------------------------------------  --->

	<cffunction name="exportRows" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="delimiter" type="string" required="true">
		<cfargument name="include_creation_date" type="boolean" required="false" default="false">
		<cfargument name="include_last_update_date" type="boolean" required="false" default="false">
		<cfargument name="include_insert_user" type="boolean" required="false" default="false">
		<cfargument name="include_update_user" type="boolean" required="false" default="false">
		<cfargument name="decimals_with_mask" type="boolean" required="false" default="false">
		<cfargument name="ms_excel_compatibility" type="boolean" required="false" default="false">

		<cfset var method = "exportRows">

		<cfset var response = structNew()>

		<cfset var rowsQuery = "">
		<cfset var fieldsNames = "">
		<cfset var fieldsLabels = "">
		<cfset var exportContent = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<!---checkAreaAccess in getTable--->
			<cfinvoke component="TableManager" method="getTable" returnvariable="getTableResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>

			<cfif getTableResponse.result IS false>
				<cfreturn getTableResponse>
			</cfif>

			<!---<cfset tableQuery = getTableResponse.table>--->

			<cfinvoke component="RowManager" method="generateRowsQuery" returnvariable="generateRowsQueryResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="include_creation_date" value="#arguments.include_creation_date#">
				<cfinvokeargument name="include_last_update_date" value="#arguments.include_last_update_date#">
				<cfinvokeargument name="include_insert_user" value="#arguments.include_insert_user#">
				<cfinvokeargument name="include_update_user" value="#arguments.include_update_user#">
				<cfinvokeargument name="decimals_with_mask" value="#arguments.decimals_with_mask#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset rowsQuery = generateRowsQueryResponse.rowsQuery>
			<cfset fieldsNames = generateRowsQueryResponse.fieldsNames>
			<cfset fieldsLabels = generateRowsQueryResponse.fieldsLabels>

			<cfif rowsQuery.recordCount GT 0>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="queryToCSV" returnvariable="exportContent">
					<cfinvokeargument name="query" value="#rowsQuery#">
					<cfinvokeargument name="fields" value="#fieldsNames#">
					<cfinvokeargument name="fieldsLabels" value="#fieldsLabels#">
					<cfinvokeargument name="createHeaderRow" value="true">
					<cfif arguments.delimiter EQ "tab">
						<cfinvokeargument name="delimiter" value="	">
					<cfelse>
						<cfinvokeargument name="delimiter" value="#arguments.delimiter#">
					</cfif>
				</cfinvoke>

				<cfif arguments.ms_excel_compatibility IS true>

					<cfset exportContent = "sep=;#chr(10)#"&exportContent>

				</cfif>

			</cfif>

			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, table_id=arguments.table_id, content=#exportContent#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

				<cfset response = {result=false, message=cfcatch.message}>

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- --------------------------------- canUserModifyRow ---------------------------------  --->

	<cffunction name="canUserModifyRow" output="false" access="private" returntype="boolean">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="table" type="query" required="true">
		<cfargument name="row_id" type="numeric" required="false">

		<cfset var method = "canUserModifyRow">

		<cfset var area_id = table.area_id>

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfif arguments.tableTypeId IS 3 AND APPLICATION.filesTablesInheritance IS true><!--- Typologies with inheritante --->

			<!--- checkTableWithInheritanceAccess --->
			<cfinvoke component="TableManager" method="checkTableWithInheritanceAccess">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

				<cfinvokeargument name="table_area_id" value="#area_id#">
			</cfinvoke>

		<cfelseif arguments.tableTypeId IS 4><!---User typology--->

			<cfif SESSION.client_administrator NEQ user_id>

				<cfif isDefined("arguments.row_id")>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="selectUserQuery">
						<cfinvokeargument name="user_id" value="#user_id#">
						<cfinvokeargument name="parse_dates" value="false">
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfif selectUserQuery.recordCount GT 0 AND selectUserQuery.typology_row_id EQ arguments.row_id>
						<cfreturn true>
					<cfelse>
						<cfreturn false>
					</cfif>

				<cfelse>
					<cfreturn false>
				</cfif>

			</cfif>

		<cfelseif arguments.tableTypeId IS NOT 3 OR arguments.table.general IS NOT true><!---IS NOT typology OR IS NOT general typology--->

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

	<!---<cffunction name="getRowLastPosition" returntype="numeric" access="public">
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

	</cffunction>--->
	<!---  ------------------------------------------------------------------------ --->



	<!--- ------------------------------------- deleteRow -------------------------------------  --->

	<cffunction name="deleteRow" output="false" access="public" returntype="struct">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "deleteRow">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var rowQuery = "">
		<cfset var itemCategories = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTable" returnvariable="tableQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="parse_dates" value="false">
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif tableQuery.recordCount IS 0><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfif arguments.tableTypeId IS 2><!--- Form --->

				<cfset area_id = tableQuery.area_id>

				<!---checkAreaResponsibleAccess--->
				<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>

			<cfelse>

				<!---canUserModifyRow--->
				<cfinvoke component="RowManager" method="canUserModifyRow" returnvariable="canUserModifyRow">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="table" value="#tableQuery#">
				</cfinvoke>
				<cfif canUserModifyRow IS false>
					<cfthrow message="No tiene permiso para acceder a editar esta #tableTypeNameEs#">
				</cfif>

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

			<cfset rowQuery = getRowResponse.row>

			<cfif arguments.tableTypeId IS 1 OR arguments.tableTypeId IS 2><!--- IS NOT typology --->

				<!--- getItemCategories --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItemCategories" returnvariable="itemCategories">
					<cfinvokeargument name="item_id" value="#arguments.table_id#">
					<cfinvokeargument name="itemTypeId" value="#itemTypeId#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>

			<!--- Delete Row --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="deleteRow">
				<cfinvokeargument name="row_id" value="#arguments.row_id#">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="user_id" value="#SESSION.user_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif arguments.tableTypeId IS 1 OR arguments.tableTypeId IS 2><!--- IS NOT typology --->

				<!--- Alert --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newTableRow">
					<cfinvokeargument name="row_id" value="#arguments.row_id#">
					<cfinvokeargument name="rowQuery" value="#rowQuery#">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="itemCategories" value="#itemCategories#">
					<cfinvokeargument name="action" value="delete">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfset actionEventTypeId = 3><!--- Delete row --->

				<!--- Action --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/ActionManager" method="throwAction">
					<cfinvokeargument name="row_id" value="#arguments.row_id#">
					<cfinvokeargument name="rowQuery" value="#rowQuery#"/>
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="action_event_type_id" value="#actionEventTypeId#">
					<cfinvokeargument name="user_id" value="#SESSION.user_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>

			<cfset response = {result=true, row_id=#arguments.row_id#, table_id=#arguments.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ------------------------------------- deleteRowAttachedFile -------------------------------------  --->

	<cffunction name="deleteRowAttachedFile" output="false" access="public" returntype="struct">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "deleteRowAttachedFile">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var rowQuery = "">
		<cfset var field_name = "">
		<cfset var file_id = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTable" returnvariable="tableQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="parse_dates" value="false">
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif tableQuery.recordCount IS 0><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfif arguments.tableTypeId IS 2><!--- Form --->

				<cfset area_id = tableQuery.area_id>

				<!---checkAreaResponsibleAccess--->
				<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>

			<cfelse>

				<!---canUserModifyRow--->
				<cfinvoke component="RowManager" method="canUserModifyRow" returnvariable="canUserModifyRow">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="table" value="#tableQuery#">
				</cfinvoke>
				<cfif canUserModifyRow IS false>
					<cfthrow message="No tiene permiso para acceder a editar esta #tableTypeNameEs#">
				</cfif>

			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="rowQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="row_id" value="#arguments.row_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset field_name = 'field_#arguments.field_id#'>
			<cfset file_id = rowQuery[field_name]>

			<cfif rowQuery.recordCount GT 0 AND isNumeric(file_id)>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/RowAttachedFile" method="deleteRowAttachedFile">
					<cfinvokeargument name="file_id" value="#file_id#">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="row_id" value="#arguments.row_id#">
					<cfinvokeargument name="field_id" value="#arguments.field_id#">
					<cfinvokeargument name="user_id" value="#SESSION.user_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			<cfelse><!--- Not found --->

				<cfset error_code = 601>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfset response = {result=true, row_id=#arguments.row_id#, table_id=#arguments.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ------------------------------------- getTableRows -------------------------------------  --->

	<cffunction name="getTableRows" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="false">
		<cfargument name="fields" type="query" required="false">
		<cfargument name="file_id" type="numeric" required="false"><!--- Only for typology row --->

		<cfset var method = "getTableRows">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfif arguments.tableTypeId IS 3 AND isDefined("arguments.row_id") AND isDefined("arguments.file_id")><!---Only one row of Typology (file)--->

				<!---checkAreaFileAccess--->
				<cfinvoke component="FileManager" method="checkAreaFileAccess" returnvariable="checkAreaFileAccessResponse">
					<cfinvokeargument name="file_id" value="#arguments.file_id#">
				</cfinvoke>

				<cfif checkAreaFileAccessResponse.result IS false>
					<cfset error_code = 104>
					<cfthrow errorcode="#error_code#">
				<cfelse>
					<cfset file = checkAreaFileAccessResponse.file>
					<cfset file_typology_id = file.typology_id>
					<cfset file_typology_row_id = file.typology_row_id>

					<cfif file_typology_id NEQ arguments.table_id OR file_typology_row_id NEQ arguments.row_id>
						<cfset error_code = 104>
						<cfthrow errorcode="#error_code#">
					</cfif>
				</cfif>

				<!--- getTable --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTable" returnvariable="table">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="parse_dates" value="true">
					<cfinvokeargument name="published" value="false">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			<cfelseif arguments.tableTypeId IS 4 AND isDefined("arguments.row_id")><!---Only one row of user typology--->
				
				<!--- getTable --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTable" returnvariable="table">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="parse_dates" value="true">
					<cfinvokeargument name="published" value="false">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			<cfelse>

				<!---checkAreaAccess in getTable--->
				<cfinvoke component="TableManager" method="getTable" returnvariable="getTableResponse">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				</cfinvoke>

				<cfif getTableResponse.result IS false>
					<cfreturn getTableResponse>
				</cfif>

				<cfset table = getTableResponse.table>

			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="getRowsQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfif isDefined("arguments.row_id")>
				<cfinvokeargument name="row_id" value="#arguments.row_id#">
				</cfif>
				<cfinvokeargument name="fields" value="#arguments.fields#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif getRowsQuery.recordCount GT 0 OR NOT isDefined("arguments.row_id")>

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


	<!--- ------------------------------------- getViewRows -------------------------------------  --->

	<cffunction name="getViewRows" output="false" access="public" returntype="struct">
		<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="false">

		<cfset var method = "getViewRows">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<!---checkAreaAccess in getView--->
			<cfinvoke component="ViewManager" method="getView" returnvariable="getViewResponse">
				<cfinvokeargument name="view_id" value="#arguments.view_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>

			<cfif getViewResponse.result IS false>
				<cfreturn getTableResponse>
			</cfif>

			<cfset view = getViewResponse.view>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="getRowsQuery">
				<cfinvokeargument name="table_id" value="#view.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfif isDefined("arguments.row_id")>
				<cfinvokeargument name="row_id" value="#arguments.row_id#">
				</cfif>

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif getRowsQuery.recordCount GT 0 OR NOT isDefined("arguments.row_id")>

				<cfset response = {result=true, rows=#getRowsQuery#}>

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


	<!--- ------------------------------------- getTypologiesRowsSearch -------------------------------------  --->

	<cffunction name="getTypologiesRowsSearch" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="name" type="string" required="false">
		<cfargument name="file_name" type="string" required="false">
		<cfargument name="description" type="string" required="false">
		<cfargument name="user_in_charge" type="string" required="no">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="limit" type="numeric" required="true">

		<cfargument name="areas_ids" type="string" required="true">

		<cfset var method = "getTypologiesRowsSearch">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<!---checkAreaAccess in getTable--->
			<cfinvoke component="TableManager" method="getTable" returnvariable="getTableResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>

			<cfif getTableResponse.result IS false>
				<cfreturn getTableResponse>
			</cfif>

			<cfset table = getTableResponse.table>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTypologiesRowsSearch" argumentcollection="#arguments#" returnvariable="getRowsQuery">
				<cfinvokeargument name="with_files" value="true">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, rows=#getRowsQuery.query#, table=#table#}>

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
		<cfargument name="file_id" type="numeric" required="false">

		<cfset var method = "getRow">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="RowManager" method="getTableRows" returnvariable="getTableRowsResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="row_id" value="#arguments.row_id#">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
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


	<!--- ------------------------------------- getViewRow -------------------------------------  --->

	<cffunction name="getViewRow" output="false" access="public" returntype="struct">
		<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="true">

		<cfset var method = "getViewRow">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="RowManager" method="getViewRows" returnvariable="getTableRowsResponse">
				<cfinvokeargument name="view_id" value="#arguments.view_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="row_id" value="#arguments.row_id#">
			</cfinvoke>

			<cfif getTableRowsResponse.result IS true>
				<cfset response = {result=true, row=#getTableRowsResponse.rows#}>
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

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getEmptyRow" returnvariable="getEmptyRowQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, row=#getEmptyRowQuery#}>

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
		<cfargument name="withDefaultValues" type="boolean" required="false">

		<cfset var method = "fillEmptyRow">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="fillEmptyRow" returnvariable="emptyRow">
				<cfinvokeargument name="emptyRow" value="#arguments.emptyRow#">
				<cfinvokeargument name="fields" value="#arguments.fields#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="withDefaultValues" value="#arguments.withDefaultValues#">
			</cfinvoke>

			<cfset response = {result=true, row=#emptyRow#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ------------------------------------- getRowJSON -------------------------------------  --->

	<cffunction name="getRowJSON" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="view_id" type="numeric" required="false">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="rowQuery" type="query" required="false">
		<cfargument name="file_id" type="numeric" required="false"><!---Only for typology--->
		<cfargument name="fields" type="query" required="false">

		<cfargument name="client_abb" type="string" required="true"/>
		<cfargument name="client_dsn" type="string" required="true"/>

		<cfset var method = "getRowJSON">

		<cfset var response = structNew()>

			<cfif NOT isDefined("arguments.rowQuery")>

				<!--- getRow --->
				<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="getRow" returnvariable="getRowResponse">
					<cfinvokeargument name="table_id" value="#table_id#"/>
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#"/>
					<cfinvokeargument name="row_id" value="#arguments.row_id#"/>
					<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				</cfinvoke>
				<cfset table = getRowResponse.table>
				<cfset rowQuery = getRowResponse.row>

			</cfif>

			<cfif NOT isDefined("arguments.fields")>

				<!---Table fields--->
				<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTableFields" returnvariable="fieldsResult">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="with_types" value="true"/>
					<cfinvokeargument name="file_id" value="#file_id#"/>
				</cfinvoke>

				<cfset fields = fieldsResult.tableFields>

			</cfif>

			<!---generateRowJSON--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowManager" method="generateRowJSON" returnvariable="rowJSON">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="view_id" value="#arguments.view_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="rowQuery" value="#rowQuery#">
				<cfinvokeargument name="fields" value="#fields#">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">


				<cfinvokeargument name="client_abb" value="#client_abb#"/>
				<cfinvokeargument name="client_dsn" value="#client_dsn#"/>
			</cfinvoke>

		<cfset response = {result=true, rowJSON=#rowJSON#}>

		<cfreturn response>

	</cffunction>



</cfcomponent>

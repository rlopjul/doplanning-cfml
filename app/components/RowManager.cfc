<!--- Copyright Era7 Information Technologies 2007-2014 --->

<cfcomponent output="false">

	<cfset component = "RowManager">

	<cfset dateFormat = "%d-%m-%Y">

	<cfset CREATE_ROW = "create">
	<cfset MODIFY_ROW = "modify">

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

			<cfif arguments.tableTypeId IS 2 AND arguments.action EQ MODIFY_ROW><!--- Modify Form --->
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
				<cfif arguments.action IS CREATE_ROW>
					<cfinvokeargument name="include_in_new_row" value="true">
				<cfelse>
					<cfinvokeargument name="include_in_update_row" value="true">
				</cfif>
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
		<cfset var importedRows = 0>

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

				<cfloop from="#arguments.start_row#" to="#ArrayLen(fileArray)#" step="1" index="curRowIndex"><!--- loop Rows --->

					<cfset rowValues = structNew()>

					<cfset curColumn = 1>

					<cfinclude template="#APPLICATION.componentsPath#/includes/tableRowImport.cfm">

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
								<cfinvokeargument name="import" value="true">
								<cfif arguments.cancel_on_error IS true>
									<cfinvokeargument name="with_transaction" value="false">
								<cfelse>
									<cfinvokeargument name="with_transaction" value="true">
								</cfif>

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

							<cfset importedRows = importedRows+1>

							<cfcatch>

								<cfset errorMessagePrefix = "Error en fila #curRowIndex#: ">
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
				<cfset response = {result=false, message=errorMessages, fileArray=fileArray, importedRows=importedRows}>
			<cfelse>
				<cfset response = {result=true, table_id=arguments.table_id, importedRows=importedRows}>
			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

				<cfset response = {result=false, message=cfcatch.message, fileArray=fileArray}>

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ------------------------------------- importRowsXml -------------------------------------  --->

	<cffunction name="importRowsXml" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="file" type="string" required="true">
		<cfargument name="delete_rows" type="boolean" required="false" default="false">
		<cfargument name="cancel_on_error" type="boolean" required="false" default="true">
		<cfargument name="decimals_with_mask" type="boolean" required="false" default="false">

		<cfset var method = "importRowsXml">

		<cfset var response = structNew()>

		<cfset var destination = "">
		<cfset var fileContent = "">
		<cfset var fileArray = arrayNew(1)>
		<cfset var rowLabelValues = structNew()>
		<cfset var rowValues = structNew()>
		<cfset var fieldValue = "">

		<cfset var errorMessages = "">
		<cfset var uniqueFields = false>

		<!---<cftry>--->

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
			<cffile action="upload" filefield="file" destination="#destination#" nameconflict="makeunique" result="fileResult" charset="utf-8" accept="text/plain,text/xml,application/xml"><!--- application/vnd.ms-excel es necesario para IE --->

			<cfset destinationFile = destination&fileResult.serverFile>

			<cffile action="read" file="#destinationFile#" variable="fileContent" charset="utf-8">
			<cffile action="delete" file="#destinationFile#">

			<cfset importXml = xmlParse(fileContent)>

			<cfset curRowIndex = 1>

			<!---<cfif isDefined("importXml.xmlRoot.xmlChildren[1].xmlChildren")>--->

				<!---<cftransaction>--->

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

				<cfelse>

					<!--- Are unique fields --->
					<cfquery name="checkUniqueFields" dbtype="query">
						SELECT *
						FROM fields
						WHERE unique = 1;
					</cfquery>

					<cfif checkUniqueFields.recordCount GT 0>

						<cfset uniqueFields = true>

						<!--- Table rows --->
						<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="rowsQuery">
							<cfinvokeargument name="table_id" value="#arguments.table_id#">
							<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

					</cfif>

				</cfif>

				<cfloop index="xmlParent" array="#importXml.xmlRoot.xmlChildren#">

					<cfset error = false>
					<cfset rowLabelValues = structNew()>
					<cfset rowValues = structNew()>

					<cfloop index="xmlNode" array="#xmlParent.xmlChildren#">

						<!---<cfdump var="#xmlNode#">--->

						<cfset tagName = xmlNode.xmlName>

						<cfset textFieldLabel = tagName>

						<cfset xmlNodeText = trim(xmlNode.xmlText)>

						<cfif xmlNodeText NEQ "">

							<cfset rowLabelValues[textFieldLabel] = xmlNodeText>

						</cfif>

						<cfif arrayLen(xmlNode.xmlChildren) GT 0>

							<cfset elementFieldLabel = tagName&"_xml">

							<cfset rowLabelValues[elementFieldLabel] = toString(trim(xmlNode))>

						</cfif>

						<cfif structCount(xmlNode.xmlAttributes) GT 0>

							<cfloop collection="#xmlNode.xmlAttributes#" item="attribute">

								<cfset attFieldLabel = tagName&"_att_"&attribute>

								<cfset rowLabelValues[attFieldLabel] = trim(xmlNode.xmlAttributes[attribute])>

							</cfloop>

						</cfif>

					</cfloop>

					<!---<cfdump var="#rowLabelValues#">--->

					<cfloop collection="#rowLabelValues#" item="fieldLabel">

						<cfquery name="checkField" dbtype="query">
							SELECT *
							FROM fields
							WHERE import_name = <cfqueryparam value="#fieldLabel#" cfsqltype="cf_sql_varchar">;
						</cfquery>

						<cfset fieldValue = rowLabelValues[fieldLabel]>

						<cfif checkField.recordCount IS 0>

							<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="createFieldInDatabase" returnvariable="field_id">
								<cfinvokeargument name="table_id" value="#arguments.table_id#">
								<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
								<cfinvokeargument name="label" value="#fieldLabel#">
								<cfinvokeargument name="import_name" value="#fieldLabel#">
								<cfinvokeargument name="description" value="">
								<cfinvokeargument name="required" value="false">
								<cfinvokeargument name="sort_by_this" value="">
								<cfinvokeargument name="default_value" value="">
								<cfif find("_att_", fieldLabel) GT 0 OR isNumeric(fieldValue) OR isDate(fieldValue) OR isBoolean(fieldValue)>
									<cfinvokeargument name="field_type_id" value="1">
									<cfinvokeargument name="mysql_type" value="VARCHAR(255)">
								<cfelse>
									<cfinvokeargument name="field_type_id" value="2">
									<cfinvokeargument name="mysql_type" value="TEXT">
								</cfif>
							</cfinvoke>

							<cfset rowValues["field_"&field_id] = fieldValue>

							<!---Table fields--->
							<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getTableFields" returnvariable="fields">
								<cfinvokeargument name="table_id" value="#arguments.table_id#">
								<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
								<cfinvokeargument name="with_types" value="true">
								<cfinvokeargument name="with_table" value="false">

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

						<cfelse>

							<cfset rowValues["field_"&checkField.field_id] = fieldValue>

							<!--- DELETE EXISTING ROWS WITH REPEATED UNIQUE FIELD --->
							<cfif uniqueFields IS true AND checkField.unique IS true>

								<cfquery name="getRepeatedRows" dbtype="query">
									SELECT *
									FROM rowsQuery
									WHERE field_#checkField.field_id# = <cfqueryparam value="#fieldValue#" cfsqltype="#checkField.cf_sql_type#">;
								</cfquery>


								<cfif getRepeatedRows.recordCount GT 0>

									<cfloop query="#getRepeatedRows#">

										<!--- Delete Row --->
										<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="deleteRow">
											<cfinvokeargument name="row_id" value="#getRepeatedRows.row_id#">
											<cfinvokeargument name="table_id" value="#arguments.table_id#">
											<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
											<cfinvokeargument name="user_id" value="#SESSION.user_id#">

											<cfinvokeargument name="client_abb" value="#client_abb#">
											<cfinvokeargument name="client_dsn" value="#client_dsn#">
										</cfinvoke>

									</cfloop>

									<!--- Table rows --->
									<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="rowsQuery">
										<cfinvokeargument name="table_id" value="#arguments.table_id#">
										<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

										<cfinvokeargument name="client_abb" value="#client_abb#">
										<cfinvokeargument name="client_dsn" value="#client_dsn#">
									</cfinvoke>

								</cfif>


							</cfif><!---END uniqueFields IS true AND checkField.unique IS true--->


						</cfif><!---END checkField.recordCount IS 0--->

					</cfloop>


					<cfloop query="#fields#">

						<cfif NOT structKeyExists(rowValues, "field_"&fields.field_id)>

								<cfset rowValues["field_"&fields.field_id] = "">

						</cfif>

					</cfloop>


					<cfif error IS false><!--- No error --->

						<!---<cftry>--->

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

							<!---<cfcatch>

								<cfset errorMessagePrefix = "Error en fila #curRowIndex#: ">
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

						</cftry>--->

					</cfif>

					<cfset curRowIndex = curRowIndex+1>


				</cfloop><!--- END xmlParent loop --->


				<!---</cftransaction>--->

			<!---<cfelse>

				<cfset response = {result=false, files=fileData, message="Archivo vacío o con formato incorrecto"}>
				<cfreturn response>

			</cfif>--->

			<cfif len(errorMessages) GT 0>
				<cfset response = {result=false, message=errorMessages, fileArray=fileArray}>
			<cfelse>
				<cfset response = {result=true, table_id=arguments.table_id}>
			</cfif>

			<!---<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

				<cfset response = {result=false, message=cfcatch.message, fileArray=fileArray}>

			</cfcatch>
		</cftry>--->

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

		<cfset var method = "generateRowsQuery">

		<cfset var response = structNew()>

		<cfset var rowsQuery = "">
		<cfset var listFields = false>
		<cfset var attachedItemFields = false>
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

				<cfloop query="fields">

					<cfset fieldName = "field_#fields.field_id#">
					<cfset fieldsNames = listAppend(fieldsNames, fieldName, ",")>

					<cfif fields.field_type_id EQ 9 OR fields.field_type_id IS 10><!--- LISTS --->

						<cfset listFields = true>
						<cfset queryAddColumn(rowsQuery, fieldName, "VarChar", arrayNew(1))>

					<cfelseif fields.field_type_group IS "doplanning_item" OR fields.field_type_id IS 18><!--- AREA ITEMS OR ATTACHED FILE --->

						<cfset attachedItemFields = true>

					</cfif>

					<cfif len(fields.label) GT 0>
						<cfset fieldsLabels = listAppend(fieldsLabels, replace(fields.label, ",", " ", "ALL"), ",")>
					<cfelse>
						<cfset fieldsLabels = listAppend(fieldsLabels, " ", ",")>
					</cfif>

				</cfloop>

				<cfif arguments.decimals_with_mask IS true OR attachedItemFields IS true OR listFields IS true>

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


					<cfif arguments.decimals_with_mask IS true OR attachedItemFields IS true OR selectedAreasQuery.recordCount GT 0>

						<cfloop query="rowsQuery">

							<cfset curRowIndex = rowsQuery.currentRow>

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

											<cfset querySetCell(rowsQuery, fieldName, fieldValue, curRowIndex)>

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

									<cfset querySetCell(rowsQuery, fieldName, fieldValue, curRowIndex)>


								<cfelseif fields.field_type_group IS "doplanning_item" OR fields.field_type_id IS 18><!--- AREA ITEMS OR ATTACHED FILE --->

									<cfset fieldValue = rowsQuery[fieldName]>

									<cfif isNumeric(fieldValue)>

										<cfif fields.item_type_id IS 10 OR fields.field_type_id IS 18><!--- FILE --->

											<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
												<cfinvokeargument name="file_id" value="#fieldValue#">
												<cfinvokeargument name="parse_dates" value="false"/>
												<cfinvokeargument name="published" value="false"/>

												<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
												<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
											</cfinvoke>

											<cfif fileQuery.recordCount GT 0>
												<cfif fields.item_type_id IS 10>
													<cfif len(fileQuery.name) GT 0>
														<cfset fieldValue = fileQuery.name>
													<cfelse>
														<cfset fieldValue = "ARCHIVO SELECCIONADO SIN TÍTULO">
													</cfif>
												<cfelse>
													<cfset fieldValue = fileQuery.file_name>
												</cfif>
											<cfelse>
												<cfset fieldValue = "ARCHIVO NO DISPONIBLE">
											</cfif>

											<cfset querySetCell(rowsQuery, fieldName, fieldValue, curRowIndex)>


										<cfelse><!--- ITEM --->

											<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
												<cfinvokeargument name="item_id" value="#fieldValue#">
												<cfinvokeargument name="itemTypeId" value="#fields.item_type_id#">
												<cfinvokeargument name="parse_dates" value="false"/>
												<cfinvokeargument name="published" value="false"/>

												<cfinvokeargument name="client_abb" value="#client_abb#">
												<cfinvokeargument name="client_dsn" value="#client_dsn#">
											</cfinvoke>

											<cfif itemQuery.recordCount GT 0>
												<cfif len(itemQuery.title) GT 0>
													<cfset fieldValue = itemQuery.title>
												<cfelse>
													<cfset fieldValue = "ELEMENTO SELECCIONADO SIN TÍTULO">
												</cfif>
											<cfelse>
												<cfset fieldValue = "ELEMENTO NO DISPONIBLE">
											</cfif>

											<cfset querySetCell(rowsQuery, fieldName, fieldValue, curRowIndex)>

										</cfif>

									</cfif><!--- END isNumeric(fieldValue) --->


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

		<cfif arguments.tableTypeId IS 3 AND APPLICATION.filesTablesInheritance IS true AND arguments.table.general IS false><!--- Typologies with inheritante --->

			<!--- checkTableWithInheritanceAccess --->
			<cfinvoke component="TableManager" method="checkTableWithInheritanceAccess">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

				<cfinvokeargument name="table_area_id" value="#area_id#">
			</cfinvoke>

		<cfelseif arguments.tableTypeId IS 4><!---User typology--->

			<cfif SESSION.client_administrator NEQ SESSION.user_id>

				<cfif isDefined("arguments.row_id")>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="selectUserQuery">
						<cfinvokeargument name="user_id" value="#SESSION.user_id#">
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
					<cfinvokeargument name="row_id" value="#arguments.row_id#">
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
		<cfargument name="area_id" type="numeric" required="false">

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
				<cfinvokeargument name="area_id" value="#arguments.area_id#">

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


	<!--- ------------------------------------- getTableRowsSearch -------------------------------------  --->

	<cffunction name="getTableRowsSearch" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="fields" type="query" required="false">
		<cfargument name="search" type="string" required="false" default="true">

		<cfset var method = "getTableRowsSearch">

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

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" argumentcollection="#arguments#" returnvariable="getRowsQuery">
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
		<cfargument name="withSearchValues" type="boolean" required="false">

		<cfset var method = "fillEmptyRow">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="fillEmptyRow" returnvariable="emptyRow">
				<cfinvokeargument name="emptyRow" value="#arguments.emptyRow#">
				<cfinvokeargument name="fields" value="#arguments.fields#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="withDefaultValues" value="#arguments.withDefaultValues#">
				<cfinvokeargument name="withSearchValues" value="#arguments.withSearchValues#">
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

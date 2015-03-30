<!--- Copyright Era7 Information Technologies 2007-2014 --->

<cfcomponent output="false">
	
	<cfset component = "FieldManager">


	<!--- ------------------------------------- createField -------------------------------------  --->
	
	<cffunction name="createField" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="field_type_id" type="numeric" required="true">
		<cfargument name="label" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="required" type="boolean" required="false" default="false">
		<cfargument name="sort_by_this" type="string" required="true">
        <cfargument name="default_value" type="string" required="true">
        <cfargument name="position" type="numeric" required="false">
        <cfargument name="list_area_id" type="numeric" required="false">
        <cfargument name="field_input_type" type="string" required="false">
        <cfargument name="item_type_id" type="numeric" required="false">
        <cfargument name="mask_type_id" type="string" required="false">
        <cfargument name="list_values" type="string" required="false">

		<cfset var method = "createField">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var field_id = "">

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

			<!---checkAreaResponsibleAccess--->
			<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>

			<cfinvoke component="FieldManager" method="getFieldType" returnvariable="getFieldResponse">
				<cfinvokeargument name="field_type_id" value="#arguments.field_type_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>
			
			<cfif getFieldResponse.result IS false>
				<cfreturn getFieldResponse>
			</cfif>

			<cfset fieldType = getFieldResponse.fieldType>

			<cfset arguments.label = trim(arguments.label)>

			<cftransaction>

				<cfinvoke component="FieldManager" method="createFieldInDatabase" returnvariable="field_id">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="field_type_id" value="#arguments.field_type_id#">
					<cfinvokeargument name="label" value="#arguments.label#">
					<cfinvokeargument name="description" value="#arguments.description#">
					<cfinvokeargument name="required" value="#arguments.required#">
					<cfinvokeargument name="sort_by_this" value="#arguments.sort_by_this#">
					<cfinvokeargument name="default_value" value="#arguments.default_value#">
					<cfinvokeargument name="position" value="#arguments.position#">
					<cfinvokeargument name="list_area_id" value="#arguments.list_area_id#">
					<cfinvokeargument name="mysql_type" value="#fieldType.mysql_type#">
					<cfinvokeargument name="field_input_type" value="#arguments.field_input_type#">
					<cfinvokeargument name="item_type_id" value="#arguments.item_type_id#">
					<cfinvokeargument name="mask_type_id" value="#arguments.mask_type_id#">
					<cfinvokeargument name="list_values" value="#arguments.list_values#">
				</cfinvoke>

			</cftransaction>


			<cfinclude template="includes/logRecord.cfm">
			
			<cfset response = {result=true, field_id=#field_id#, table_id=#arguments.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- createFieldInDatabase -------------------------------------  --->

	<!---IMPORTANTE: La llamada a esta función tiene que hacerse dentro de una transacción <cftransaction>--->
	
	<cffunction name="createFieldInDatabase" output="false" access="package" returntype="numeric">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="field_type_id" type="numeric" required="true">
		<cfargument name="label" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="required" type="boolean" required="false" default="false">
		<cfargument name="sort_by_this" type="string" required="true">
        <cfargument name="default_value" type="string" required="true">
        <cfargument name="position" type="numeric" required="false">
        <cfargument name="list_area_id" type="numeric" required="false">
        <cfargument name="mysql_type" type="string" required="true">
        <cfargument name="field_input_type" type="string" required="false">
        <cfargument name="item_type_id" type="numeric" required="false">
        <cfargument name="mask_type_id" type="string" required="false">
        <cfargument name="list_values" type="string" required="false">

		<cfset var method = "createFieldInDatabase">

		<cfset var field_id = "">

		<cfset var fieldLastPosition = "">

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfif arguments.field_type_id IS 9 OR arguments.field_type_id IS 10><!--- IS SELECT --->

				<cfif NOT isDefined("arguments.list_area_id")>
					
					<cfthrow message="No hay área seleccionada para la lista">

				</cfif>

			</cfif>

			<cfif NOT isDefined("arguments.position") OR NOT isNumeric(arguments.position)>
				
				<!---getFieldLastPosition--->
				<cfinvoke component="FieldManager" method="getFieldLastPosition" returnvariable="fieldLastPosition">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				</cfinvoke>
				
				<cfset arguments.position = fieldLastPosition+1>
				
			</cfif>

			<cfquery name="createField" datasource="#client_dsn#">
				INSERT INTO `#client_abb#_#tableTypeTable#_fields`
				SET table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">,
				field_type_id = <cfqueryparam value="#arguments.field_type_id#" cfsqltype="cf_sql_integer">,
				label = <cfqueryparam value="#arguments.label#" cfsqltype="cf_sql_varchar">,
				description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">,
				required = <cfqueryparam value="#arguments.required#" cfsqltype="cf_sql_bit">,
				sort_by_this = <cfqueryparam value="#arguments.sort_by_this#" cfsqltype="cf_sql_varchar">,
				default_value = <cfqueryparam value="#arguments.default_value#" cfsqltype="cf_sql_longvarchar">,
				position = <cfqueryparam value="#arguments.position#" cfsqltype="cf_sql_integer">
				<cfif arguments.field_type_id IS 9 OR arguments.field_type_id IS 10 OR arguments.field_type_id IS 7 OR arguments.field_type_id IS 15 OR arguments.field_type_id IS 16><!--- IS SELECT OR BOOLEAN--->
					, field_input_type = <cfqueryparam value="#arguments.field_input_type#" cfsqltype="cf_sql_varchar">
				<cfelse>
					, field_input_type = <cfqueryparam null="true" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.field_type_id IS 9 OR arguments.field_type_id IS 10><!--- IS SELECT --->
					, list_area_id = <cfqueryparam value="#arguments.list_area_id#" cfsqltype="cf_sql_integer">
				<cfelse>
					, list_area_id = <cfqueryparam null="true" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif arguments.field_type_id IS 13><!---DoPlanning Item--->
					, item_type_id = <cfqueryparam value="#arguments.item_type_id#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif isDefined("arguments.mask_type_id") AND isNumeric(arguments.mask_type_id)>
					, mask_type_id = <cfqueryparam value="#arguments.mask_type_id#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif isDefined("arguments.list_values")>
					, list_values = <cfqueryparam value="#arguments.list_values#" cfsqltype="cf_sql_varchar">
				</cfif>
				;
			</cfquery>

			<cfquery name="getLastInsertId" datasource="#client_dsn#">
				SELECT LAST_INSERT_ID() AS last_insert_id FROM `#client_abb#_#tableTypeTable#_fields`;
			</cfquery>

			<cfset field_id = getLastInsertId.last_insert_id>

			<cfif arguments.field_type_id NEQ 9 AND arguments.field_type_id NEQ 10><!--- IS NOT SELECT --->

				<cfquery name="insertFieldInTable" datasource="#client_dsn#">
					ALTER TABLE `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` 
					ADD COLUMN `field_#field_id#` #arguments.mysql_type# 
					<cfif arguments.required IS true>
						NOT NULL
						<cfif len(arguments.default_value) GT 0>
							DEFAULT '#arguments.default_value#'
						</cfif>
					</cfif>;
				</cfquery>

			</cfif>

			<cfreturn field_id>
			
	</cffunction>


	<!--- ------------------------------------- updateField -------------------------------------  --->
	
	<cffunction name="updateField" output="false" access="public" returntype="struct">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="label" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="required" type="boolean" required="false" default="false">
		<cfargument name="sort_by_this" type="string" required="true">
        <cfargument name="default_value" type="string" required="true">
        <cfargument name="position" type="numeric" required="false">
        <cfargument name="list_area_id" type="numeric" required="false">
        <cfargument name="field_input_type" type="string" required="false">
        <cfargument name="item_type_id" type="numeric" required="false">
        <cfargument name="mask_type_id" type="string" required="false">
        <cfargument name="list_values" type="string" required="false">

		<cfset var method = "updateField">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="FieldManager" method="getField" returnvariable="getFieldResponse">
				<cfinvokeargument name="field_id" value="#arguments.field_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="with_type" value="true"/>
			</cfinvoke>

			<cfif getFieldResponse.result IS false>
				<cfreturn getFieldResponse>
			</cfif>

			<cfset field = getFieldResponse.field>

			<cfset area_id = field.area_id>

			<!---checkAreaResponsibleAccess--->
			<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>

			<cfif field.field_type_id IS 9 OR field.field_type_id IS 10><!--- IS SELECT --->

				<cfif NOT isDefined("arguments.list_area_id")>
					
					<cfthrow message="No hay área seleccionada para la lista">

				</cfif>

			</cfif>

			<cfset arguments.label = trim(arguments.label)>

			<cftransaction>

				<cfquery name="updateField" datasource="#client_dsn#">
					UPDATE `#client_abb#_#tableTypeTable#_fields`
					SET
					label = <cfqueryparam value="#arguments.label#" cfsqltype="cf_sql_varchar">,
					description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">,
					required = <cfqueryparam value="#arguments.required#" cfsqltype="cf_sql_bit">,
					sort_by_this = <cfqueryparam value="#arguments.sort_by_this#" cfsqltype="cf_sql_varchar">,
					default_value = <cfqueryparam value="#arguments.default_value#" cfsqltype="cf_sql_longvarchar">
					<cfif isDefined("arguments.position")>
						, position = <cfqueryparam value="#arguments.position#" cfsqltype="cf_sql_integer">
					</cfif>
					<cfif arguments.field_type_id IS 9 OR arguments.field_type_id IS 10 OR arguments.field_type_id IS 7 OR arguments.field_type_id IS 15 OR arguments.field_type_id IS 16><!--- IS SELECT OR BOOLEAN--->
						, field_input_type = <cfqueryparam value="#arguments.field_input_type#" cfsqltype="cf_sql_varchar">
					<cfelse>
						, field_input_type = <cfqueryparam null="true" cfsqltype="cf_sql_varchar">
					</cfif>
					<cfif isDefined("arguments.list_area_id")>
						, list_area_id = <cfqueryparam value="#arguments.list_area_id#" cfsqltype="cf_sql_integer">
					<cfelse>
						, list_area_id = <cfqueryparam null="true" cfsqltype="cf_sql_integer">
					</cfif>
					<cfif arguments.field_type_id IS 13><!---DoPlanning Item--->
						, item_type_id = <cfqueryparam value="#arguments.item_type_id#" cfsqltype="cf_sql_integer">
					</cfif>
					<cfif isDefined("arguments.mask_type_id")>
						<cfif isNumeric(arguments.mask_type_id)>
							, mask_type_id = <cfqueryparam value="#arguments.mask_type_id#" cfsqltype="cf_sql_integer">
						<cfelse>
							, mask_type_id = <cfqueryparam null="true" cfsqltype="cf_sql_integer">
						</cfif>
					</cfif>
					<cfif isDefined("arguments.list_values")>
						, list_values = <cfqueryparam value="#arguments.list_values#" cfsqltype="cf_sql_varchar">
					</cfif>
					WHERE field_id = <cfqueryparam value="#arguments.field_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfif field.field_type_id NEQ 9 AND field.field_type_id NEQ 10><!--- IS NOT SELECT --->

					<cfquery name="updateFieldInTable" datasource="#client_dsn#">
						ALTER TABLE `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` 
						MODIFY COLUMN `field_#field_id#` #field.mysql_type# 
						<cfif arguments.required IS true>
						NOT NULL	
						</cfif>;
					</cfquery>

				</cfif>

			</cftransaction>

			<cfinclude template="includes/logRecord.cfm">
		
			<cfset response = {result=true, field_id=#arguments.field_id#, table_id=#field.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ------------------------------------- copyTableFields -------------------------------------  --->
	
	<cffunction name="copyTableFields" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="copy_from_table_id" type="numeric" required="true">
		<cfargument name="fields_ids" type="array" required="true">

		<cfset var method = "copyTableFields">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var fields = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<!---Table--->
			<cfinvoke component="TableManager" method="getTable" returnvariable="getTableResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>
			
			<cfif getTableResponse.result IS false>
				<cfreturn getTableResponse>
			</cfif>

			<cfset area_id = getTableResponse.table.area_id>

			<!---checkAreaResponsibleAccess--->
			<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>

			<!---Table fields to copy--->
			<cfinvoke component="TableManager" method="getTableFields" returnvariable="getFieldsResponse">
				<cfinvokeargument name="table_id" value="#arguments.copy_from_table_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="with_types" value="true">
			</cfinvoke>

			<cfif getFieldsResponse.result IS false>
				<cfreturn getFieldsResponse>
			</cfif>

			<cfset fields = getFieldsResponse.tableFields>

			<cftransaction>

				<cfloop query="fields">

					<cfif arrayFind(arguments.fields_ids, fields.field_id)>
						
						<cfinvoke component="FieldManager" method="createFieldInDatabase" returnvariable="field_id">
							<cfinvokeargument name="table_id" value="#arguments.table_id#">
							<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
							<cfinvokeargument name="field_type_id" value="#fields.field_type_id#">
							<cfinvokeargument name="label" value="#fields.label#">
							<cfinvokeargument name="description" value="#fields.description#">
							<cfinvokeargument name="required" value="#fields.required#">
							<cfinvokeargument name="sort_by_this" value="#fields.sort_by_this#">
							<cfinvokeargument name="default_value" value="#fields.default_value#">
							<cfinvokeargument name="mysql_type" value="#fields.mysql_type#">
							<cfif isNumeric(fields.list_area_id)>
								<cfinvokeargument name="list_area_id" value="#fields.list_area_id#"/>
							</cfif>
							<cfinvokeargument name="field_input_type" value="#fields.field_input_type#">
							<cfif isNumeric(fields.item_type_id)>
								<cfinvokeargument name="item_type_id" value="#fields.item_type_id#">
							</cfif>
							<cfif len(fields.list_values) GT 0>
								<cfinvokeargument name="list_values" value="#fields.list_values#">
							</cfif>
						</cfinvoke>

					</cfif>
					
				</cfloop>

			</cftransaction>
			
			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, table_id=#arguments.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!---  ---------------------- getFieldLastPosition -------------------------------- --->
	
	<cffunction name="getFieldLastPosition" returntype="numeric" access="package">
		<cfargument name="table_id" type="numeric" required="yes">
		<cfargument name="tableTypeId" type="numeric" required="yes">
		
		<cfset var method = "getFieldLastPosition">
		
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getFieldLastPosition" returnvariable="getLastPositionResult">
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


	<!---  ---------------------- changeFieldPosition -------------------------------- --->

	<cffunction name="changeFieldPosition" returntype="struct" access="public">
		<cfargument name="a_field_id" type="numeric" required="true">
		<cfargument name="b_field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="action" type="string" required="true"><!---increase/decrease--->
		
		<cfset var method = "changeFieldPosition">

		<cfset var response = structNew()>

		<cfset var table_id = "">
		<cfset var area_id = "">
		
		<cfset var a_fieldNewPosition = "">
		<cfset var b_fieldNewPosition = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
						
			<cfquery name="getField" datasource="#client_dsn#">		
				SELECT fields.position, fields.table_id
				FROM #client_abb#_#tableTypeTable#_fields AS fields
				WHERE fields.field_id = <cfqueryparam value="#arguments.a_field_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif getField.recordCount GT 0>

				<cfset table_id = getField.table_id>
				
				<!---Table--->
				<cfinvoke component="TableManager" method="getTable" returnvariable="getTableResponse">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				</cfinvoke>
				
				<cfif getTableResponse.result IS false>
					<cfreturn getTableResponse>
				</cfif>

				<cfset area_id = getTableResponse.table.area_id>

				<!---checkAreaResponsibleAccess--->
				<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>

				<cfset b_fieldNewPosition = getField.position>

				<cfquery name="getOtherField" datasource="#client_dsn#">		
					SELECT fields.field_id, fields.position
					FROM #client_abb#_#tableTypeTable#_fields AS fields
					WHERE fields.field_id = <cfqueryparam value="#arguments.b_field_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
					
				<cfif getOtherField.recordCount GT 0>

					<cfset a_fieldNewPosition = getOtherField.position>
					
					<cftransaction>
						
						<cfquery name="updateOtherFieldQuery" datasource="#client_dsn#">		
							UPDATE #client_abb#_#tableTypeTable#_fields
							SET position = <cfqueryparam value="#b_fieldNewPosition#" cfsqltype="cf_sql_integer">
							WHERE field_id = <cfqueryparam value="#arguments.b_field_id#" cfsqltype="cf_sql_integer">;
						</cfquery>
						
						<cfquery name="updateFieldQuery" datasource="#client_dsn#">		
							UPDATE #client_abb#_#tableTypeTable#_fields
							SET position = <cfqueryparam value="#a_fieldNewPosition#" cfsqltype="cf_sql_integer">
							WHERE field_id = <cfqueryparam value="#arguments.a_field_id#" cfsqltype="cf_sql_integer">;
						</cfquery>
					
					</cftransaction>
					
				<cfelse>
				
					<cfset response = {result=false, message="Error, no se ha encontrado el campo por el que hay que cambiar el orden"}>
					
					<cfreturn response>
					
				</cfif>
				
				<cfinclude template="includes/logRecord.cfm">
				
				<cfset response = {result=true, table_id=table_id}>
			
			<cfelse>
			
				<cfset response = {result=false, message="Error, no se ha encontrado el elemento"}>
			
			</cfif>
			
		<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>


	<!--- ------------------------------------- deleteField -------------------------------------  --->
	
	<cffunction name="deleteField" output="false" access="public" returntype="struct">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "deleteField">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="FieldManager" method="getField" returnvariable="getFieldResponse">
				<cfinvokeargument name="field_id" value="#arguments.field_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="with_table" value="true"/>
			</cfinvoke>

			<cfif getFieldResponse.result IS false>
				<cfreturn getFieldResponse>
			</cfif>

			<cfset field = getFieldResponse.field>

			<cfset area_id = field.area_id>

			<!---checkAreaResponsibleAccess--->
			<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>

			<cftransaction>

				<cfquery name="deleteField" datasource="#client_dsn#">
					DELETE FROM `#client_abb#_#tableTypeTable#_fields`
					WHERE field_id = <cfqueryparam value="#arguments.field_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfif field.field_type_id NEQ 9 AND field.field_type_id NEQ 10><!--- IS NOT SELECT --->

					<cfquery name="deleteFieldFromTable" datasource="#client_dsn#">
						ALTER TABLE `#client_abb#_#tableTypeTable#_rows_#field.table_id#` 
						DROP COLUMN `field_#arguments.field_id#`;
					</cfquery>

				</cfif>

			</cftransaction>
			
			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, field_id=#arguments.field_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>



	<!--- ------------------------------------ deleteTableFields -----------------------------------  --->
		
	<cffunction name="deleteTableFields" output="false" access="package" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "deleteTableFields">
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldManager" method="deleteTableFields">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<!---
			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getTableFields" returnvariable="fields">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="with_types" value="false">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfloop query="fields">

				<cfquery name="deleteField" datasource="#client_dsn#">
					DELETE FROM `#client_abb#_#tableTypeTable#_fields`
					WHERE field_id = <cfqueryparam value="#fields.field_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfif fields.field_type_id NEQ 9 AND fields.field_type_id NEQ 10><!--- IS NOT SELECT --->

					<cfquery name="deleteFieldFromTable" datasource="#client_dsn#">
						ALTER TABLE `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` 
						DROP COLUMN `field_#fields.field_id#`;
					</cfquery>

				</cfif>

			</cfloop>
			--->
			
	</cffunction>



	<!--- ------------------------------------- getField -------------------------------------  --->
	
	<cffunction name="getField" output="false" access="public" returntype="struct">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_type" type="boolean" required="false">

		<cfset var method = "getField">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getField" returnvariable="getFieldQuery">
				<cfinvokeargument name="field_id" value="#arguments.field_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="with_table" value="true"/>
				<cfif isDefined("arguments.with_type")>
					<cfinvokeargument name="with_type" value="#arguments.with_type#"/>		
				</cfif>
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfif getFieldQuery.recordCount GT 0>

				<cfset area_id = getFieldQuery.area_id>

				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

				<cfset response = {result=true, field=#getFieldQuery#}>

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


	<!--- ------------------------------------- getEmptyField -------------------------------------  --->
	
	<cffunction name="getEmptyField" output="false" access="public" returntype="struct">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getEmptyField">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfquery name="getFieldQuery" datasource="#client_dsn#">
				SELECT *
				FROM #client_abb#_#tableTypeTable#_fields
				WHERE field_id = -1;
			</cfquery>

			<cfset response = {result=true, field=#getFieldQuery#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>




	<!--- ------------------------------------- getFieldTypes -------------------------------------  --->
	
	<cffunction name="getFieldTypes" output="false" access="public" returntype="struct">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getFieldTypes">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getFieldTypes" returnvariable="getFieldTypesQuery">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, fieldTypes=getFieldTypesQuery}>
								
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>



	<!--- ------------------------------------- getFieldMaskTypes -------------------------------------  --->
	
	<cffunction name="getFieldMaskTypes" output="false" access="public" returntype="struct">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getFieldMasks">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldManager" method="getFieldMaskTypesStruct" returnvariable="maskTypesStruct">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
			</cfinvoke>

			<cfset response = {result=true, maskTypesStruct=maskTypesStruct}>
								
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>



	<!--- ------------------------------------- getFieldType -------------------------------------  --->
	
	<cffunction name="getFieldType" output="false" access="public" returntype="struct">
		<cfargument name="field_type_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getFieldType">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getFieldType" returnvariable="getFieldTypeQuery">
				<cfinvokeargument name="field_type_id" value="#arguments.field_type_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfif getFieldTypeQuery.recordCount GT 0>

				<cfset response = {result=true, fieldType=#getFieldTypeQuery#}>

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


</cfcomponent>
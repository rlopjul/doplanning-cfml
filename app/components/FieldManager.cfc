<!--- Copyright Era7 Information Technologies 2007-2013 --->

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
        <cfargument name="default_value" type="string" required="true">
        <cfargument name="position" type="numeric" required="false">

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
					default_value = <cfqueryparam value="#arguments.default_value#" cfsqltype="cf_sql_longvarchar">,
					position = <cfqueryparam value="#arguments.position#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfquery name="getLastInsertId" datasource="#client_dsn#">
					SELECT LAST_INSERT_ID() AS last_insert_id FROM `#client_abb#_#tableTypeTable#_fields`;
				</cfquery>

				<cfset field_id = getLastInsertId.last_insert_id>

				<cfquery name="insertFieldInTable" datasource="#client_dsn#">
					ALTER TABLE `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` 
					ADD COLUMN `field_#field_id#` #fieldType.mysql_type# NOT NULL;
				</cfquery>

			</cftransaction>

			
			<cfset response = {result=true, field_id=#field_id#, table_id=#arguments.table_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>



	<!--- ------------------------------------- updateField -------------------------------------  --->
	
	<cffunction name="updateField" output="false" access="public" returntype="struct">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="label" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="required" type="boolean" required="false" default="false">
        <cfargument name="default_value" type="string" required="true">
        <cfargument name="position" type="numeric" required="false">

		<cfset var method = "updateField">

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

			<cfset arguments.label = trim(arguments.label)>

			<cftransaction>

				<cfquery name="updateField" datasource="#client_dsn#">
					UPDATE `#client_abb#_#tableTypeTable#_fields`
					SET
					label = <cfqueryparam value="#arguments.label#" cfsqltype="cf_sql_varchar">,
					description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">,
					required = <cfqueryparam value="#arguments.required#" cfsqltype="cf_sql_bit">,
					default_value = <cfqueryparam value="#arguments.default_value#" cfsqltype="cf_sql_longvarchar">
					<cfif isDefined("arguments.position")>
						, position = <cfqueryparam value="#arguments.position#" cfsqltype="cf_sql_integer">
					</cfif>
					WHERE field_id = <cfqueryparam value="#arguments.field_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

			</cftransaction>
		
			<cfset response = {result=true, field_id=#arguments.field_id#, table_id=#field.table_id#}>

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

				<cfquery name="deleteFieldFromTable" datasource="#client_dsn#">
					ALTER TABLE `#client_abb#_#tableTypeTable#_rows_#field.table_id#` 
					DROP COLUMN `field_#arguments.field_id#`;
				</cfquery>

			</cftransaction>
		
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

				<cfquery name="deleteFieldFromTable" datasource="#client_dsn#">
					ALTER TABLE `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` 
					DROP COLUMN `field_#fields.field_id#`;
				</cfquery>

			</cfloop>
			
	</cffunction>



	<!--- ------------------------------------- getField -------------------------------------  --->
	
	<cffunction name="getField" output="false" access="public" returntype="struct">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

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
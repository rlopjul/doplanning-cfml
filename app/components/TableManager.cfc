<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">
	
	<cfset component = "TableManager">


	<!--- ------------------------------------- createTableInDatabase -------------------------------------  --->
	
	<cffunction name="createTableInDatabase" output="false" access="package" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "createTableInDatabase">

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfquery name="createTable" datasource="#client_dsn#">
				CREATE TABLE `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#` (
				  `row_id` int(20) unsigned NOT NULL AUTO_INCREMENT,
				  `insert_user_id` int(11) NOT NULL,
				  `last_update_user_id` int(11) DEFAULT NULL,
				  `creation_date` datetime NOT NULL,
				  `last_update_date` datetime DEFAULT NULL,
				  `position` int(10) unsigned NOT NULL,
				  PRIMARY KEY (`row_id`) USING BTREE,
				  KEY `FK_#client_abb#_#tableTypeTable#_rows_#arguments.table_id#_1` (`insert_user_id`),
				  KEY `FK_#client_abb#_#tableTypeTable#_rows_#arguments.table_id#_2` (`last_update_user_id`),
				  CONSTRAINT `FK_#client_abb#_#tableTypeTable#_rows_#arguments.table_id#_2` FOREIGN KEY (`last_update_user_id`) REFERENCES `#client_abb#_users` (`id`),
				  CONSTRAINT `FK_#client_abb#_#tableTypeTable#_rows_#arguments.table_id#_1` FOREIGN KEY (`insert_user_id`) REFERENCES `#client_abb#_users` (`id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8;
			</cfquery>
			
	</cffunction>



	<!--- ------------------------------------ deleteTableInDatabase -----------------------------------  --->
		
	<cffunction name="deleteTableInDatabase" output="false" access="package" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "deleteTableFields">
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="RowManager" method="deleteTableRowsInDatabase">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>

			<cfinvoke component="FieldManager" method="deleteTableFields">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>

			<cfquery name="deleteTable" datasource="#client_dsn#">
				DROP TABLE `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`;
			</cfquery>	
			
	</cffunction>



	<!--- ------------------------------------- getTable -------------------------------------  --->
	
	<cffunction name="getTable" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getTable">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTable" returnvariable="getTableQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">		
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif getTableQuery.recordCount GT 0>

				<cfset area_id = getTableQuery.area_id>

				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

				<cfset response = {result=true, table=#getTableQuery#}>

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



	<!--- ------------------------------------- getEmptyTable -------------------------------------  --->
	
	<cffunction name="getEmptyTable" output="false" access="public" returntype="struct">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getEmptyTable">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfquery name="getTableQuery" datasource="#client_dsn#">
				SELECT *
				FROM #client_abb#_#tableTypeTable#
				WHERE table_id = -1;
			</cfquery>

			<cfset response = {result=true, field=#getTableQuery#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>



	<!--- ------------------------------------- getAreaTables -------------------------------------  --->
	
	<cffunction name="getAreaTables" output="false" access="public" returntype="struct">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="user_in_charge" type="numeric" required="false">
		<cfargument name="limit" type="numeric" required="false">

		<cfset var method = "getAreaTables">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<!---<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">--->
	
			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getAreaItems" returnvariable="getAreaTablesResult">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfif isDefined("arguments.user_in_charge")>
					<cfinvokeargument name="user_in_charge" value="#arguments.user_in_charge#">
				</cfif>
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
				<cfinvokeargument name="listFormat" value="true">
				<cfinvokeargument name="format_content" value="default">
				<cfinvokeargument name="with_user" value="false">
				<cfinvokeargument name="parse_dates" value="true"/>
				<cfif isDefined("arguments.limit")>
					<cfinvokeargument name="limit" value="#arguments.limit#">
				</cfif>		
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
						
			<cfset areaTablesQuery = getAreaTablesResult.query>

			<cfset response = {result=true, areaTables=#areaTablesQuery#}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>
	
	



	<!---    createTable     --->
	<!--- 
	<cffunction name="createTable" output="false" access="public" returntype="struct">
			<cfargument name="table_type_id" type="numeric" required="yes">
			<cfargument name="user_in_charge" type="numeric" required="yes">
			<cfargument name="area_id" type="numeric" required="yes">
			<cfargument name="title" type="string" required="yes">
			<cfargument name="description" type="string" required="yes">
			<cfargument name="structure_available" type="boolean" required="no" default="false">
			<cfargument name="general" type="boolean" required="no" default="false">
					
			<cfset var method = "createTable">
	
			<cfset var response = structNew()>
			
			<cfset var table_id = "">
	
			<cftry>
				
				<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
	
				<cfset arguments.title = trim(arguments.title)>
				
				<cftransaction>
							
					<cfquery datasource="#dsn#" name="createTable">
						INSERT INTO #tables_tb# 
						SET 
						creation_date = UTC_TIMESTAMP(),
						table_type_id = <cfqueryparam value="#arguments.table_type_id#" cfsqltype="cf_sql_varchar">,
						user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_varchar">,
						title = <cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
						description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">,
						fields_number = <cfqueryparam value="#arguments.fields_number#" cfsqltype="cf_sql_integer">,
						public = <cfqueryparam value="#arguments.public#" cfsqltype="cf_sql_bit">,
						nuhsa_field = <cfqueryparam value="#arguments.nuhsa_field#" cfsqltype="cf_sql_bit">,
						email_notification = <cfqueryparam value="#arguments.email_notification#" cfsqltype="cf_sql_varchar">,
						enabled = 0;		
					</cfquery>
					
					<cfquery datasource="#dsn#" name="getLastInsertId">
						SELECT LAST_INSERT_ID() AS last_insert_id FROM #tables_tb#;
					</cfquery>
				
				</cftransaction>
				
				<cfset table_id = getLastInsertId.last_insert_id>
	
				<cfinclude template="includes/functionEndOnlyLog.cfm">
				
				<cfset response = {result="true", table_id=#table_id#}>
				
				<cfreturn response>
				
				<cfcatch>
	
					<cfinclude template="includes/errorHandlerStruct.cfm">
	
				</cfcatch>
	
			</cftry>
	
			<cfreturn response>	
			
		</cffunction> --->
	


	<!--- ------------------------------------- getTableFields -------------------------------------  --->
	
	<cffunction name="getTableFields" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_types" type="boolean" required="false" default="false">

		<cfset var method = "getTableFields">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
	
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getTableFields" returnvariable="getTableFieldsQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="with_types" value="#arguments.with_types#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, tableFields=getTableFieldsQuery}>
								
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

		<cfset var method = "getTableRows">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
	
			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="getTableRowsQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<!---<cfinvokeargument name="parse_dates" value="false"/>--->
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, tableRows=getTableRowsQuery}>
								
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>



</cfcomponent>

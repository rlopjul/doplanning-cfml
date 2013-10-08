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

				<cfif arguments.tableTypeId IS NOT 3 OR getTableQuery.general IS NOT true><!---No es tipología general--->
					
					<cfset area_id = getTableQuery.area_id>

					<!---checkAreaAccess--->
					<cfinclude template="includes/checkAreaAccess.cfm">

				</cfif>

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
				WHERE id = -1;
			</cfquery>

			<cfset response = {result=true, table=#getTableQuery#}>

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
		<cfargument name="structure_available" type="boolean" required="false">

		<cfset var method = "getAreaTables">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
	
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
				<cfif isDefined("arguments.structure_available") AND arguments.structure_available IS true>
					<cfinvokeargument name="structure_available" value="true"/>
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



	<!--- -------------------------------- getTablesWithStructureAvailable -------------------------------  --->
	
	<cffunction name="getTablesWithStructureAvailable" output="false" access="public" returntype="struct">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getTablesWithStructureAvailable">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
	
			<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getAllTables" returnvariable="getTablesResult">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			
				<cfinvokeargument name="structure_available" value="true"/>

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
						
			<cfset response = {result=true, tables=#getTablesResult.query#}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>
	



	<!--- ------------------------------------- getTableFields -------------------------------------  --->
	
	<cffunction name="getTableFields" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_types" type="boolean" required="false" default="false">

		<cfset var method = "getTableFields">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getTableFields" returnvariable="getTableFieldsQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="with_types" value="#arguments.with_types#">
				<cfinvokeargument name="with_table" value="true">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif getTableFieldsQuery.recordCount GT 0>
				<cfif getTableFieldsQuery.structure_available IS false AND getTableFieldsQuery.general IS false>

					<cfset area_id = getTableFieldsQuery.area_id>

					<!---checkAreaAccess--->
					<cfinclude template="includes/checkAreaAccess.cfm">

				</cfif>
			</cfif>

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

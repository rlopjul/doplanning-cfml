<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">
	
	<cfset component = "TableManager">
	
	<cfset listTypeId = 1>
	<cfset fileTypeId = 2>
	<cfset formTypeId = 3>



	<!--- ------------------------------------- getMainTree -------------------------------------  --->
	
	<cffunction name="getAreaTables" output="false" access="public" returntype="struct">
		<cfargument name="tableTypeId" type="numeric" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="user_in_charge" type="numeric" required="no">
		<cfargument name="limit" type="numeric" required="no">

		<cfset var method = "getAreaTables">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">
	
			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getAreaItems" returnvariable="getAreaTablesResult">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfif isDefined("arguments.user_in_charge")>
					<cfinvokeargument name="user_in_charge" value="#arguments.user_in_charge#">
				</cfif>
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="listFormat" value="#arguments.listFormat#">
				<cfinvokeargument name="format_content" value="#arguments.format_content#">
				<cfinvokeargument name="with_user" value="true">
				<cfif isDefined("arguments.limit")>
					<cfinvokeargument name="limit" value="#arguments.limit#">
				</cfif>
				<cfif isDefined("arguments.done")>
				<cfinvokeargument name="done" value="#arguments.done#">
				</cfif>				
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
						
			<cfset areaTablesQuery = getAreaTablesResult.query>

			<cfset response = {result=true, message="", tablesQuery=#areaTablesQuery#}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>
	



	<!---    createTable     --->
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
		
	</cffunction>





</cfcomponent>

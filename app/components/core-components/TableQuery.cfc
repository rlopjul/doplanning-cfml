<!--- Copyright Era7 Information Technologies 2007-2014 --->

<cfcomponent output="false">

	<cfset component = "TableQuery">	
	
	<cfset dateFormat = "%d-%m-%Y"><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset dateTimeFormat = "%d-%m-%Y %H:%i:%s">
	<cfset timeZoneTo = "+1:00">


	<!---getTable--->
		
	<cffunction name="getTable" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">
		<cfargument name="published" type="boolean" required="false" default="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getTable">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfquery name="selectTableQuery" datasource="#client_dsn#">
				SELECT tables.id, tables.id AS table_id, tables.user_in_charge, tables.title, tables.description, tables.attached_file_id, tables.attached_file_name, tables.area_id, tables.link, 
				users.name AS user_name, users.family_name, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name, users.image_type AS user_image_type
				, tables.attached_image_id, tables.attached_image_name
				, tables.link_target
				<cfif tableTypeId IS 3><!---Typologies--->
				, tables.general
				</cfif>
				, tables.structure_available <!---files.file_type, --->
				<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(tables.creation_date, '#dateTimeFormat#') AS creation_date 
					, DATE_FORMAT(tables.last_update_date, '#dateTimeFormat#') AS last_update_date 
				<cfelse>
					, tables.creation_date, tables.last_update_date
				</cfif>
				<cfif APPLICATION.publicationScope IS true AND tableTypeId IS NOT 3>
					<!--- Si se pone tables.publication_scope_id NO devuelve el valor correcto de esa columna (siempre devuelve 1) --->
					, scopes.scope_id AS publication_scope_id, scopes.name AS publication_scope_name
				</cfif>
				<cfif tableTypeId IS NOT 3>
					<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(CONVERT_TZ(tables.publication_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS publication_date
					<cfelse>
					, tables.publication_date
					</cfif>
					, tables.publication_validated
				</cfif>
				FROM #client_abb#_#tableTypeTable# AS tables
				INNER JOIN #client_abb#_users AS users ON tables.user_in_charge = users.id
				<!--- LEFT JOIN #client_abb#_files AS files ON files.id = tables.attached_file_id --->
				<cfif APPLICATION.publicationScope IS true AND tableTypeId IS NOT 3>
					LEFT JOIN #client_abb#_scopes AS scopes ON tables.publication_scope_id = scopes.scope_id
				</cfif>
				WHERE tables.id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
				<cfif arguments.published IS true AND  tableTypeId IS NOT 3>
					AND ( tables.publication_date IS NULL OR tables.publication_date <= NOW() )
					<cfif APPLICATION.publicationValidation IS true>
					AND ( tables.publication_validated IS NULL OR tables.publication_validated = true )
					</cfif>
				</cfif>; 
			</cfquery>
			
		<cfreturn selectTableQuery>
		
	</cffunction>



	<!---getAllTables--->
	
	<cffunction name="getAllTables" output="false" returntype="struct" access="public">
		<cfargument name="tableTypeId" type="numeric" required="yes">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">
		<cfargument name="with_user" type="boolean" required="no" default="false">
		<cfargument name="with_area" type="boolean" required="no" default="false">
		<cfargument name="user_in_charge" type="numeric" required="no">
		<cfargument name="structure_available" type="boolean" required="false">
		<cfargument name="limit" type="numeric" required="no">		
		
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">	
				
		<cfset var method = "getAllTables">

		<cfset var count = 0>
							
			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cftransaction>
			
				<cfquery name="tablesQuery" datasource="#client_dsn#">
					SELECT items.id, items.title, items.user_in_charge
					<cfif arguments.parse_dates IS true>
						, DATE_FORMAT(items.creation_date, '#datetime_format#') AS creation_date 
					<cfelse>
						, items.creation_date
					</cfif>
					, items.attached_file_name, items.attached_file_id, items.area_id
					<cfif arguments.with_user IS true>
					, users.family_name, users.name AS user_name, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name, users.image_type AS user_image_type				
					</cfif>		
					, items.structure_available
					<cfif arguments.tableTypeId IS 3><!---Typologies--->
					, items.general
					</cfif>
					<cfif arguments.with_area IS true>
					, areas.name AS area_name
					</cfif>
					FROM #client_abb#_#tableTypeTable# AS items
					<cfif arguments.with_user IS true>
						INNER JOIN #client_abb#_users AS users ON items.user_in_charge = users.id 
					</cfif>
					<cfif arguments.with_area IS true>
						INNER JOIN #client_abb#_areas AS areas ON items.area_id = areas.id
					</cfif>
					<!---<cfif isDefined("arguments.area_id")>
					LEFT JOIN #client_abb#_items_position AS items_position
					ON items.id = items_position.item_id AND items_position.item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">
					AND items.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					</cfif>--->
					WHERE 
					status='ok' 
					<!---(<cfif isDefined("arguments.areas_ids")>
					items.area_id IN (<cfqueryparam value="#arguments.areas_ids#" cfsqltype="cf_sql_varchar" list="yes">)
					<cfelse>
					items.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					</cfif>
					<cfif itemTypeId IS 13><!---Typologies--->
						OR items.general = 1
					</cfif>
					)--->
					<cfif isDefined("arguments.user_in_charge")>
					AND items.user_in_charge = <cfqueryparam value="#arguments.user_in_charge#" cfsqltype="cf_sql_integer">
					</cfif>
					<!---
					<cfif len(search_text_re) GT 0><!---Search--->
					AND (items.title REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
					OR items.description REGEXP <cfqueryparam value=">.*#search_text_re#.*<" cfsqltype="cf_sql_varchar">
					OR items.attached_file_name REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
					OR items.link REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
					<cfif arguments.itemTypeId IS NOT 1>
					OR items.attached_image_name REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
					</cfif>
					)
					</cfif>--->
					
					<cfif isDefined("arguments.structure_available")>
					AND items.structure_available = <cfqueryparam value="#arguments.structure_available#" cfsqltype="cf_sql_bit">
					</cfif>

					<!---<cfif isDefined("arguments.area_id")>
						ORDER BY items_position.position DESC, items.creation_date DESC
					<cfelse>--->
						ORDER BY items.creation_date DESC		
					<!---</cfif>--->		
					
					<cfif isDefined("arguments.limit")>
					LIMIT <cfif isDefined("arguments.offset")>#arguments.offset#, </cfif>#arguments.limit#	
					</cfif>;
				</cfquery>
				
				<cfif isDefined("arguments.limit")>
					<cfquery datasource="#client_dsn#" name="getCount">
						SELECT FOUND_ROWS() AS count;
					</cfquery>
					<cfset count = getCount.count>
				</cfif>
			
			</cftransaction>
		
		<cfreturn {query=tablesQuery, count=count}>
		
	</cffunction>


	<!---getTableUsers--->
		
	<cffunction name="getTableUsers" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_table" type="boolean" required="no" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getTableUsers">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">		
							
			<cfquery name="getTableUsersQuery" datasource="#client_dsn#">
				SELECT table_users.user_id, users.id, users.family_name, users.name, users.email, users.image_file, users.image_type,
				CONCAT_WS(' ', users.family_name, users.name) AS user_full_name
				<cfif arguments.with_table IS true>
					, tables.area_id
				</cfif>
				FROM `#client_abb#_#tableTypeTable#_users` AS table_users
				INNER JOIN `#client_abb#_users` AS users ON users.id = table_users.user_id
				AND table_users.#tableTypeName#_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
				<cfif arguments.with_table IS true>
					INNER JOIN `#client_abb#_#tableTypeTable#` AS tables ON tables.id = table_users.#tableTypeName#_id 
				</cfif>
				ORDER BY users.name ASC;
			</cfquery>
				
		<cfreturn getTableUsersQuery>
				
	</cffunction>
	

</cfcomponent>	

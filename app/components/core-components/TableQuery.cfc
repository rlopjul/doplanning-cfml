<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">

	<cfset component = "TableQuery">	
	
	<cfset dateFormat = "%d-%m-%Y"><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset dateTimeFormat = "%d-%m-%Y %H:%i:%s">


	<!---getTable--->
		
	<cffunction name="getTable" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getTable">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfquery name="selectItemQuery" datasource="#client_dsn#">
				SELECT items.id, items.id AS table_id, items.user_in_charge, items.title, items.description, items.attached_file_id, items.attached_file_name, files.file_type, items.area_id, items.link, 
				users.name AS user_name, users.family_name, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name, users.image_type AS user_image_type
				, items.attached_image_id, items.attached_image_name
				, items.link_target
				<cfif tableTypeId IS 3><!---Typologies--->
				, items.general
				</cfif>
				, items.structure_available
				<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(items.creation_date, '#dateTimeFormat#') AS creation_date 
					, DATE_FORMAT(items.last_update_date, '#dateTimeFormat#') AS last_update_date 
				<cfelse>
					, items.creation_date, items.last_update_date
				</cfif>
				FROM #client_abb#_#tableTypeTable# AS items
				INNER JOIN #client_abb#_users AS users ON items.user_in_charge = users.id
				LEFT JOIN #client_abb#_files AS files ON files.id = items.attached_file_id
				WHERE items.id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">; 
			</cfquery>
			
		<cfreturn selectItemQuery>
		
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

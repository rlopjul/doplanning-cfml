<!--- Copyright Era7 Information Technologies 2007-2014 --->

<cfcomponent output="false">

	<cfset component = "TableQuery">

	<cfset dateFormat = APPLICATION.dbDateFormat><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset dateTimeFormat = APPLICATION.dbDateTimeFormat>
	<!--- <cfset timeZoneTo = "+1:00"> --->
	<cfset timeZoneTo = APPLICATION.dbTimeZoneTo>


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
				<cfif APPLICATION.publicationScope IS true AND (tableTypeId IS 1 OR tableTypeId IS 2)>
					<!--- Antes si se ponía tables.publication_scope_id NO devolvía el valor correcto de esa columna (siempre devolvía 1) --->
					, tables.publication_scope_id, scopes.name AS publication_scope_name
				</cfif>
				<cfif tableTypeId IS 1 OR tableTypeId IS 2>
					, tables.list_rows_by_default
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
				<cfif APPLICATION.publicationScope IS true AND (tableTypeId IS 1 OR tableTypeId IS 2)>
					LEFT JOIN #client_abb#_scopes AS scopes ON tables.publication_scope_id = scopes.scope_id
				</cfif>
				WHERE tables.id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
				<cfif arguments.published IS true AND (tableTypeId IS 1 OR tableTypeId IS 2)>
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


	<!--- ------------------------------------- getAllTypologies -------------------------------------  --->

	<cffunction name="getAllTypologies" output="false" access="public" returntype="query">
		<cfargument name="tableTypeId" type="string" required="true">
		<cfargument name="with_area" type="boolean" required="false" default="false">
		<cfargument name="parse_dates" type="boolean" required="false" default="true">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getAllTypologies">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfquery name="typologiesQuery" datasource="#client_dsn#">
				SELECT tables.id, tables.title, tables.user_in_charge
				, tables.attached_file_name, tables.attached_file_id, tables.area_id
				, tables.structure_available, tables.general
				<cfif arguments.with_area IS true>
				, areas.name AS area_name
				</cfif>
				<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(tables.creation_date, '#APPLICATION.dbDateTimeFormat#') AS creation_date
					, DATE_FORMAT(tables.last_update_date, '#APPLICATION.dbDateTimeFormat#') AS last_update_date
				<cfelse>
					, tables.creation_date, tables.last_update_date
				</cfif>

				FROM #client_abb#_#tableTypeTable# AS tables
				<cfif arguments.with_area IS true>
					INNER JOIN #client_abb#_areas AS areas ON tables.area_id = areas.id
				</cfif>
				WHERE tables.status = 'ok'
				ORDER BY id ASC;
			</cfquery>

		<cfreturn typologiesQuery>

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


	<!--- ------------------------------------ deleteTableInDatabase -----------------------------------  --->

	<cffunction name="deleteTableInDatabase" output="false" access="public" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="send_alert" type="boolean" required="false" default="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteTableInDatabase">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="deleteTableRows">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="user_id" value="#arguments.user_id#">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="deleteTableFields">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<!--- Las acciones se deben borrar de forma automática en MySQL --->

			<cfif tableTypeId IS 1 OR tableTypeId IS 2><!--- IS NOT Typology --->

				<cfinvoke component="#APPLICATION.coreComponentsPath#/ViewManager" method="deleteTableViews">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

					<cfinvokeargument name="user_id" value="#arguments.user_id#">

					<cfinvokeargument name="send_alert" value="#arguments.send_alert#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

			</cfif>

			<cfquery name="deleteTable" datasource="#client_dsn#">
				DROP TABLE `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`;
			</cfquery>

			<cfinclude template="includes/logRecord.cfm">

	</cffunction>


	<!--- ------------------------------------ setTableLastUpdate -----------------------------------  --->

	<cffunction name="setTableLastUpdate" output="false" access="public" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeTable" type="string" required="true">
		<cfargument name="last_update_type" type="string" required="true"><!---item,row,field--->
		<cfargument name="user_id" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">


			<cfquery name="updateTableLastUpdate" datasource="#client_dsn#">
				UPDATE `#client_abb#_#tableTypeTable#`
				SET last_update_date = NOW(),
				last_update_type = <cfqueryparam value="#arguments.last_update_type#" cfsqltype="cf_sql_varchar">,
				<cfif isDefined("arguments.user_id")>
				last_update_user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">
				<cfelse>
				last_update_user_id = <cfqueryparam cfsqltype="cf_sql_integer" null="true">
				</cfif>
				WHERE id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">;
			</cfquery>


	</cffunction>


	<!--- ------------------------------------ getTablePublicationAreas -----------------------------------  --->

	<cffunction name="getTablePublicationAreas" output="false" access="public" returntype="query">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeTable" type="string" required="true">
		<cfargument name="field_id" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">


			<cfquery name="getTablePublicationAreas" datasource="#client_dsn#">
				(	SELECT tables.area_id
					FROM `#client_abb#_#tableTypeTable#` AS tables
					WHERE tables.id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">

				) UNION ALL

				( SELECT views.area_id
					FROM `#client_abb#_#tableTypeTable#_views` AS views
				  <cfif isDefined("arguments.field_id")>
						INNER JOIN `#client_abb#_#tableTypeTable#_views_fields` AS views_fields
						ON views_fields.view_id = views.id
						AND views_fields.field_id = <cfqueryparam value="#arguments.field_id#" cfsqltype="cf_sql_integer">
					</cfif>
					WHERE views.table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
				);
			</cfquery>

		<cfreturn getTablePublicationAreas>

	</cffunction>



	<!--- ------------------------------------ getTableSearchs -----------------------------------  --->

	<cffunction name="getTableSearchs" output="false" access="public" returntype="query">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfquery name="getTableSearchs" datasource="#client_dsn#">
				SELECT searchs.*
				FROM `#client_abb#_#tableTypeTable#_searchs` AS searchs
				WHERE searchs.table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

		<cfreturn getTableSearchs>

	</cffunction>


	<!--- ------------------------------------ getTableSpecialCategories -----------------------------------  --->

	<cffunction name="getTableSpecialCategories" output="false" access="public" returntype="query">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

			<cfquery name="getTableSpecialCategories" datasource="#client_dsn#">
				SELECT categories.*
				FROM `#client_abb#_tables_special_categories` AS categories
				WHERE categories.table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
				AND categories.table_type_id = <cfqueryparam value="#arguments.tableTypeId#" cfsqltype="cf_sql_integer">
				ORDER BY categories.table_position ASC, categories.position ASC;
			</cfquery>

		<cfreturn getTableSpecialCategories>

	</cffunction>


	<!--- ------------------------------------ getAllTableSpecialCategories -----------------------------------  --->

	<cffunction name="getAllTableSpecialCategories" output="false" access="public" returntype="query">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

			<cfquery name="getAllTableSpecialCategories" datasource="#client_dsn#">
				SELECT categories.*
				FROM `#client_abb#_tables_special_categories` AS categories;
			</cfquery>

		<cfreturn getAllTableSpecialCategories>

	</cffunction>






</cfcomponent>

<!---Copyright Era7 Information Technologies 2007-2013

	Date of file creation: 25-04-2012
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 26-12-2012

	27-09-2012 alucena: añadidos campos de iframe para entradas, noticias y eventos
	02-10-2012 alucena: los enlaces y documentos solo se listan en vpnet
	26-11-2012 alucena: añadido position a noticias
	09-04-2013 alucena: getItem devuelve valores de iframes_display_types
	21-06-2013 alucena: areaItemTypeSwitch.cfm cambiado de directorio

--->
<cfcomponent output="false">

	<cfset component = "AreaItemQuery">

	<cfset dateFormat = APPLICATION.dbDateFormat><!---%H:%i:%s---><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset dateTimeFormat = APPLICATION.dbDateTimeFormat>
	<!---<cfset timeZoneTo = "+1:00">--->
	<cfset timeZoneTo = APPLICATION.dbTimeZoneTo>


	<!---getItem--->

	<cffunction name="getItem" output="false" returntype="query" access="public">
		<cfargument name="item_id" type="numeric" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">
		<cfargument name="published" type="boolean" required="false" default="true">
		<cfargument name="with_lock" type="boolean" required="false" default="false">
		<cfargument name="with_categories" type="boolean" required="false" default="false">
		<cfargument name="status" type="string" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getItem">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfquery name="selectItemQuery" datasource="#client_dsn#">
				SELECT items.id, items.id AS item_id, items.parent_id, items.parent_kind, items.user_in_charge,  items.title, items.description, items.attached_file_id, items.attached_file_name, files.file_type, items.area_id, items.link, items.status,
				users.name AS user_name, users.family_name, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name, users.image_type AS user_image_type
				<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(CONVERT_TZ(items.creation_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS creation_date
				<cfelse>
					, items.creation_date
				</cfif>
				<cfif arguments.itemTypeId IS NOT 1><!---Is not Messages--->
					<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(CONVERT_TZ(items.last_update_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS last_update_date
					<cfelse>
					, items.last_update_date
					</cfif>
					, items.attached_image_id, items.attached_image_name
					<cfif arguments.itemTypeId IS NOT 7><!---Is not Consultations--->
						, items.last_update_user_id
						, CONCAT_WS(' ', last_update_users.family_name, last_update_users.name) AS last_update_user_full_name, last_update_users.image_type AS last_update_user_image_type
					</cfif>
				</cfif>
				<cfif itemTypeId IS NOT 1 AND itemTypeId IS NOT 6 AND itemTypeId IS NOT 7>
					, items.link_target
				</cfif>
				<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->
					<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(CONVERT_TZ(items.start_date,'SYSTEM','#timeZoneTo#'), '#dateFormat#') AS start_date
					, DATE_FORMAT(CONVERT_TZ(items.end_date,'SYSTEM','#timeZoneTo#'), '#dateFormat#') AS end_date
					<cfelse>
					, items.start_date, items.end_date
					</cfif>
					<cfif itemTypeId IS 5><!---Events--->
						, items.start_time, items.end_time
						, items.place
					<cfelse><!---Tasks--->
						, items.recipient_user, items.done, items.estimated_value, items.real_value
						, CONCAT_WS(' ', recipient_users.family_name, recipient_users.name) AS recipient_user_full_name, recipient_users.image_type AS recipient_user_image_type
					</cfif>
				</cfif>
				<cfif itemTypeId IS 5 OR itemTypeId IS 8><!---Events, Publications--->
					, items.price
				</cfif>
				<cfif itemTypeId IS 17><!--- Mailings --->
					, items.email_addresses
				</cfif>
				<cfif itemTypeWeb IS true><!---WEB--->

					<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(CONVERT_TZ(items.publication_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS publication_date
					<cfelse>
					, items.publication_date
					</cfif>
					, items.publication_validated

					<cfif arguments.itemTypeId IS 2 OR arguments.itemTypeId IS 4 OR arguments.itemTypeId IS 5><!---Entries, News, Events--->
						, items.iframe_url, items.iframe_display_type_id, iframes_display_types.width AS iframe_width, iframes_display_types.width_unit AS iframe_width_unit, iframes_display_types.height AS iframe_height, iframes_display_types.height_unit AS iframe_height_unit
						<cfif itemTypeId IS 2><!---Entries--->
							, items.display_type_id
						</cfif>
					</cfif>

				</cfif><!--- END WEB --->
				<cfif arguments.itemTypeId IS 7 OR itemTypeId IS 8><!---Consultations, Publications--->
					, items.identifier
				</cfif>
				<cfif arguments.itemTypeId IS 8><!---Publications--->
					, items.sub_type_id
				</cfif>
				<cfif arguments.itemTypeId IS 7><!---Consultation--->
					, items.state, items.read_date
				</cfif>
				<cfif arguments.itemTypeId IS 13><!--- Typology --->
					, items.general
				</cfif>
				<cfif APPLICATION.publicationScope IS true AND ( arguments.itemTypeId IS 11 OR arguments.itemTypeId IS 12 )>
					, items.publication_scope_id, scopes.name AS publication_scope_name
				</cfif>
				<cfif arguments.itemTypeId IS 20><!--- DoPlanning document --->
					, items.area_editable, items.locked
					<cfif arguments.with_lock IS true>
					, locks.user_id AS lock_user_id, locks.lock_user_full_name
						<cfif arguments.parse_dates IS true>
						, DATE_FORMAT(CONVERT_TZ(locks.lock_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS lock_date
						<cfelse>
						, locks.lock_date
						</cfif>
					</cfif>
				</cfif>
				<!---<cfif isDefined("arguments.with_categories")>
					, items_categories.area_id AS category_id
				</cfif>--->
				FROM #client_abb#_#itemTypeTable# AS items
				INNER JOIN #client_abb#_users AS users ON items.user_in_charge = users.id
				LEFT JOIN #client_abb#_files AS files ON files.id = items.attached_file_id
				<cfif arguments.itemTypeId IS 2 OR arguments.itemTypeId IS 4 OR arguments.itemTypeId IS 5>
					INNER JOIN #client_abb#_iframes_display_types AS iframes_display_types ON items.iframe_display_type_id = iframes_display_types.iframe_display_type_id
				</cfif>
				<cfif arguments.itemTypeId IS NOT 1 AND arguments.itemTypeId IS NOT 7><!--- IS NOT Messages and Consultations --->
					LEFT JOIN #client_abb#_users AS last_update_users ON items.last_update_user_id = last_update_users.id
				</cfif>
				<cfif arguments.itemTypeId IS 6><!--- Task --->
					INNER JOIN #client_abb#_users AS recipient_users ON items.recipient_user = recipient_users.id
				</cfif>
				<cfif APPLICATION.publicationScope IS true AND ( arguments.itemTypeId IS 11 OR arguments.itemTypeId IS 12 )>
					LEFT JOIN #client_abb#_scopes AS scopes ON items.publication_scope_id = scopes.scope_id
				</cfif>
				<cfif arguments.itemTypeId IS 20 AND arguments.with_lock IS true>
				LEFT JOIN (
					SELECT items_locks.item_id, items_locks.lock_date, items_locks.lock, items_locks.user_id,
					CONCAT_WS(' ', users_locks.family_name, users_locks.name) AS lock_user_full_name
					FROM #client_abb#_#itemTypeTable#_locks AS items_locks
					INNER JOIN #client_abb#_users AS users_locks ON items_locks.item_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer"> AND items_locks.user_id = users_locks.id
					ORDER BY lock_date DESC
					LIMIT 1
				) AS locks ON locks.item_id = items.id
				</cfif>
				<!---<cfif isDefined("arguments.with_categories")>
					LEFT JOIN #client_abb#_items_categories AS items_categories
					ON items.id = items_categories.item_id
					AND items.item_type_id = items_categories.item_type_id
				</cfif>--->
				WHERE items.id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">
				<cfif itemTypeWeb IS true><!--- WEB --->
					<cfif arguments.published IS true>
						AND ( items.publication_date IS NULL OR items.publication_date <= NOW() )
						<cfif APPLICATION.publicationValidation IS true>
						AND ( items.publication_validated IS NULL OR items.publication_validated = true )
						</cfif>
					</cfif>
				</cfif>
				<cfif isDefined("arguments.status")>
					AND items.status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
				</cfif>;
			</cfquery>
			<!---AND status='ok'???? Esto no se pone por si se necesitan obtener mensajes desde la aplicación con el status pending--->

		<cfreturn selectItemQuery>

	</cffunction>


	<!---getAreaItems--->

	<cffunction name="getAreaItems" output="false" returntype="struct" access="public">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="format_content" type="string" required="false" default="default">
		<cfargument name="listFormat" type="string" required="yes">
		<cfargument name="area_id" type="string" required="no">
		<cfargument name="areas_ids" type="string" required="no">
		<cfargument name="all_areas" type="boolean" required="false" default="false">
		<cfargument name="search_text" type="string" required="no">
		<cfargument name="user_in_charge" type="numeric" required="no">
		<cfargument name="recipient_user" type="numeric" required="no">
		<cfargument name="with_user" type="boolean" required="no" default="false">
		<cfargument name="with_area" type="boolean" required="no" default="false">
		<cfargument name="with_position" type="boolean" required="false" default="true">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">
		<cfargument name="limit" type="numeric" required="no"><!---Limita el número de elementos a mostrar. Solo debe usarse si listFormat es true--->
		<cfargument name="done" type="boolean" required="no">
		<cfargument name="state" type="string" required="no">
		<cfargument name="offset" type="numeric" required="no">
		<!---<cfargument name="init_item" type="string" required="no">
		<cfargument name="items_page" type="string" required="no">--->
		<cfargument name="structure_available" type="boolean" required="false">
		<cfargument name="published" type="boolean" required="false" default="true">
		<cfargument name="identifier" type="string" required="false">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="categories_condition" type="string" required="false" default="AND">

		<cfargument name="from_date" type="string" required="no">
		<cfargument name="end_date" type="string" required="no">

		<!---<cfargument name="from_last_update_date" type="string" required="false">
		<cfargument name="to_last_update_date" type="string" required="false">--->

		<cfargument name="from_start_date" type="string" required="no">
		<cfargument name="to_end_date" type="string" required="no">

		<cfargument name="order_by" type="string" required="false">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getAreaItems">
		<cfset var count = 0>

		<cfset var search_text_re = "">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfif isDefined("arguments.search_text") AND len(arguments.search_text) GT 0>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/SearchManager" method="generateSearchText" returnvariable="search_text_re">
					<cfinvokeargument name="text" value="#arguments.search_text#">
				</cfinvoke>

			</cfif>

			<cftransaction>

				<cfquery name="areaItemsQuery" datasource="#client_dsn#">
					SELECT <cfif isDefined("arguments.limit")>SQL_CALC_FOUND_ROWS</cfif>
					items.id, items.title, items.user_in_charge
					<cfif arguments.itemTypeId IS 11 OR arguments.itemTypeId IS 12 OR arguments.itemTypeId IS 13><!--- Tables --->
						, items.description
					</cfif>
					<cfif arguments.itemTypeId IS NOT 1 AND arguments.itemTypeId IS NOT 7>, items.last_update_user_id</cfif>
					<cfif isDefined("arguments.area_id") AND arguments.with_position IS true>
					, items_position.position
					</cfif>
					<cfif arguments.parse_dates IS true>
						, DATE_FORMAT(items.creation_date, '#dateTimeFormat#') AS creation_date
						<cfif arguments.itemTypeId IS NOT 1>, DATE_FORMAT(items.last_update_date, '#dateTimeFormat#') AS last_update_date</cfif>
					<cfelse>
						, items.creation_date
						<cfif arguments.itemTypeId IS NOT 1 AND itemTypeId IS NOT 7>, items.last_update_date</cfif>
					</cfif>
					, items.area_id
					<cfif arguments.with_user IS true>
					, users.family_name, users.name AS user_name, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name, users.image_type AS user_image_type
						<cfif arguments.itemTypeId IS 6><!---Tasks--->
						, items.done, items.estimated_value, items.real_value
						, items.recipient_user, recipient_users.family_name AS recipient_user_family_name, recipient_users.name AS recipient_user_name, CONCAT_WS(' ', recipient_users.family_name, recipient_users.name) AS recipient_user_full_name, recipient_users.image_type AS recipient_user_image_type
						</cfif>
					</cfif>
					<cfif arguments.itemTypeId NEQ 14 AND arguments.itemTypeId NEQ 15><!--- IS NOT Views --->
						, items.attached_file_name, items.attached_file_id
					</cfif>
					<cfif arguments.itemTypeId IS NOT 1 AND arguments.itemTypeId NEQ 14 AND arguments.itemTypeId NEQ 15>
					, items.attached_image_id, items.attached_image_name, items.link
					</cfif>
					<cfif itemTypeId IS NOT 1 AND itemTypeId IS NOT 6 AND itemTypeId IS NOT 7 AND arguments.itemTypeId NEQ 14 AND arguments.itemTypeId NEQ 15>
					, items.link_target
					</cfif>
					<cfif (itemTypeId IS 5 OR itemTypeId IS 6)><!---Events, Tasks--->
						<cfif arguments.parse_dates IS true>
							, DATE_FORMAT(items.start_date, '#dateFormat#') AS start_date, DATE_FORMAT(items.end_date, '#dateFormat#') AS end_date
						<cfelse>
							<!---
							Si parse_dates está a false, NO debe realizar ninguna trasnformación sobre la fecha, deve devolverse tal y como está en base de datos
							, CONVERT_TZ(items.start_date,'SYSTEM','#timeZoneTo#') AS start_date
							, CONVERT_TZ(items.end_date,'SYSTEM','#timeZoneTo#') AS end_date--->
							, items.start_date, end_date
						</cfif>
					</cfif>
					<cfif itemTypeId IS 5><!---Events--->
					, items.start_time, items.end_time, items.place
					</cfif>
					<cfif arguments.itemTypeId IS 2 OR arguments.itemTypeId IS 3 OR arguments.itemTypeId IS 4><!---Entries, Links, News--->
						, items.position
						<cfif itemTypeId IS 2><!---Entries--->
						, items.display_type_id
						</cfif>
					</cfif>
					<cfif arguments.itemTypeId IS 2 OR arguments.itemTypeId IS 4 OR arguments.itemTypeId IS 5><!---Entries, News, Events--->
					, items.iframe_url, items.iframe_display_type_id, iframes_display_types.width AS iframe_width, iframes_display_types.width_unit AS iframe_width_unit, iframes_display_types.height AS iframe_height, iframes_display_types.height_unit AS iframe_height_unit
					</cfif>
					<cfif arguments.itemTypeId IS 7 OR arguments.itemTypeId IS 8><!---Consultations, Publications--->
					, items.identifier
						<cfif arguments.itemTypeId IS 7><!---Consultations--->
						, items.state
						</cfif>
					</cfif>
					<cfif itemTypeId IS 11 OR itemTypeId IS 12 OR itemTypeId IS 13><!---Lists, Forms, Typologies--->
					, items.structure_available
						<cfif itemTypeId IS 13><!---Typologies--->
						, items.general
						</cfif>
					</cfif>
					<cfif format_content EQ "all"><!---format_content EQ all--->
					, items.parent_id, items.parent_kind, items.description
					</cfif>
					<cfif arguments.with_area IS true>
					, areas.name AS area_name
					</cfif>
					FROM #client_abb#_#itemTypeTable# AS items
					<cfif arguments.with_user IS true>
						INNER JOIN #client_abb#_users AS users ON items.user_in_charge = users.id
						<cfif arguments.itemTypeId IS 6><!---Tasks--->
						INNER JOIN #client_abb#_users AS recipient_users ON items.recipient_user = recipient_users.id
						</cfif>
					</cfif>
					<cfif arguments.with_area IS true>
						INNER JOIN #client_abb#_areas AS areas ON items.area_id = areas.id
					</cfif>
					<cfif arguments.itemTypeId IS 2 OR arguments.itemTypeId IS 4 OR arguments.itemTypeId IS 5>
						INNER JOIN #client_abb#_iframes_display_types AS iframes_display_types ON items.iframe_display_type_id = iframes_display_types.iframe_display_type_id
					</cfif>
					<cfif isDefined("arguments.area_id") AND arguments.with_position IS true>
						LEFT JOIN #client_abb#_items_position AS items_position
						ON items.id = items_position.item_id AND items_position.item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">
						<!---AND items.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">--->
					</cfif>
					<!---
					<cfif isDefined("arguments.categories_ids")>

						Para incluir en el resultado los elementos con al menos una de las categorías seleccionadas

						INNER JOIN #client_abb#_items_categories AS categories
						ON categories.item_id = items.id
						AND categories.item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">
						AND (
						<cfset categoryCount = 1>
						<cfloop array="#arguments.categories_ids#" index="category_id">
							<cfif isNumeric(category_id)>
								<cfif categoryCount GT 1>
								OR
								</cfif>
								categories.area_id = <cfqueryparam value="#category_id#" cfsqltype="cf_sql_integer">
								<cfset categoryCount = categoryCount+1>
							</cfif>
						</cfloop>
						)
					</cfif>
					--->
					WHERE
					<cfif arguments.all_areas IS false>
						(<cfif isDefined("arguments.areas_ids")>
						items.area_id IN (<cfqueryparam value="#arguments.areas_ids#" cfsqltype="cf_sql_varchar" list="yes">)
						<cfelse>
						items.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
						</cfif>
						<cfif itemTypeId IS 13><!---Typologies--->
							OR items.general = 1
						</cfif>
						)
					<cfelse>
						1 = 1
					</cfif>
					<cfif isDefined("arguments.user_in_charge")>
					AND items.user_in_charge = <cfqueryparam value="#arguments.user_in_charge#" cfsqltype="cf_sql_integer">
					</cfif>
					<cfif arguments.itemTypeId IS 6 AND isDefined("arguments.recipient_user")>
					AND items.recipient_user = <cfqueryparam value="#arguments.recipient_user#" cfsqltype="cf_sql_integer">
					</cfif>
					<cfif isDefined("arguments.categories_ids") and arrayLen(arguments.categories_ids) GT 0>
						AND (
						<cfset categoryCount = 1>
						<cfloop array="#arguments.categories_ids#" index="category_id">
							<cfif isNumeric(category_id)>
								<cfif categoryCount GT 1>
									#arguments.categories_condition#
								</cfif>
									items.id IN ( SELECT item_id FROM `#client_abb#_items_categories`
									WHERE item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">
									AND area_id = <cfqueryparam value="#category_id#" cfsqltype="cf_sql_integer"> )
								<cfset categoryCount = categoryCount+1>
							</cfif>
						</cfloop>
						)
					</cfif>
					<cfif len(search_text_re) GT 0><!---Search--->
					AND (items.title REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
					OR items.description REGEXP <cfqueryparam value=">.*#search_text_re#.*<" cfsqltype="cf_sql_varchar">
					OR items.attached_file_name REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
					OR items.link REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
					<cfif arguments.itemTypeId IS NOT 1>
					OR items.attached_image_name REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
					</cfif>
					)
					</cfif>
					<cfif arguments.itemTypeId NEQ 14 AND arguments.itemTypeId NEQ 15>
					AND status='ok'
					</cfif>
					<cfif arguments.listFormat NEQ "true">
					AND parent_kind='area'
					</cfif>
					<cfif isDefined("arguments.done")>
					AND items.done = <cfqueryparam value="#arguments.done#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif isDefined("arguments.state")>
					AND items.state = <cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">
					</cfif>

					<!---<cfif isDefined("arguments.from_date")>
					AND items.creation_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#dateFormat#')
					</cfif>
					<cfif isDefined("arguments.end_date")>
					AND items.creation_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#dateTimeFormat#')
					</cfif>--->
					<cfif isDefined("arguments.from_date")>
						AND ( items.creation_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#dateFormat#')
								<cfif arguments.itemTypeId IS NOT 1 AND itemTypeId IS NOT 7>
								OR items.last_update_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#dateFormat#')
								</cfif>
							)
					</cfif>
					<cfif isDefined("arguments.end_date")>
						AND ( items.creation_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#dateTimeFormat#')
							<cfif arguments.itemTypeId IS NOT 1 AND itemTypeId IS NOT 7>
							AND IF( items.last_update_date IS NULL, true, items.last_update_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#dateTimeFormat#') )
							</cfif>
							)
					</cfif>
					<cfif isDefined("arguments.from_start_date")>
					AND items.start_date <= STR_TO_DATE(<cfqueryparam value="#arguments.from_start_date#" cfsqltype="cf_sql_varchar">,'#dateFormat#')
					</cfif>
					<cfif isDefined("arguments.to_end_date")>
					AND items.end_date >= STR_TO_DATE(<cfqueryparam value="#arguments.to_end_date#" cfsqltype="cf_sql_varchar">,'#dateFormat#')
					</cfif>
					<cfif isDefined("arguments.structure_available")>
					AND items.structure_available = <cfqueryparam value="#arguments.structure_available#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif isDefined("arguments.identifier")>
					AND items.identifier LIKE <cfqueryparam value="%#arguments.identifier#%" cfsqltype="cf_sql_varchar">
					</cfif>
					<cfif itemTypeWeb IS true><!--- WEB --->
						<cfif arguments.published IS true>
							AND ( items.publication_date IS NULL OR items.publication_date <= NOW() )
							<cfif APPLICATION.publicationValidation IS true>
							AND ( items.publication_validated IS NULL OR items.publication_validated = true )
							</cfif>
						</cfif>
					</cfif>

					<!--- Forma anterior de ordenar elementos
					<cfif (arguments.itemTypeId IS 2 OR arguments.itemTypeId IS 3) AND NOT isDefined("arguments.areas_ids")><!---Entries, Links--->
					ORDER BY items.position ASC, items.creation_date ASC
					<cfelseif arguments.itemTypeId IS 4 AND NOT isDefined("arguments.areas_ids")><!---News--->
					ORDER BY items.position DESC
					<cfelse>--->

					<cfif NOT isDefined("arguments.order_by")>

						<cfif arguments.itemTypeId IS NOT 6>
							<cfif isDefined("arguments.area_id") AND arguments.with_position IS true>
								ORDER BY items_position.position DESC, items.creation_date DESC
							<cfelse>
								ORDER BY items.creation_date DESC
							</cfif>
						<cfelse><!--- Tasks --->
							<cfif isDefined("arguments.area_id")>
								ORDER BY items.end_date DESC
							<cfelse>
								ORDER BY items.end_date ASC
							</cfif>
						</cfif>

					<cfelse>

						ORDER BY #arguments.order_by#

					</cfif>

					<cfif isDefined("arguments.limit")>
					LIMIT <cfif isDefined("arguments.offset")>#arguments.offset#, </cfif>#arguments.limit#
					<!---<cfelseif isDefined("arguments.init_item") AND isDefined("arguments.items_page")>
					LIMIT #init_item#, #items_page#--->
					</cfif>;
				</cfquery>

				<cfif isDefined("arguments.limit")>
					<cfquery datasource="#client_dsn#" name="getCount">
						SELECT FOUND_ROWS() AS count;
					</cfquery>
					<cfset count = getCount.count>
				</cfif>

			</cftransaction>

		<cfreturn {query=areaItemsQuery, count=count}>

	</cffunction>


	<!---getMonthItemsByDays --->

	<cffunction name="getMonthItemsByDays" output="false" returntype="struct" access="public">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="format_content" type="string" required="false" default="default">
		<cfargument name="area_id" type="string" required="no">
		<cfargument name="areas_ids" type="string" required="no">
		<cfargument name="all_areas" type="boolean" required="false" default="false">
		<cfargument name="user_in_charge" type="numeric" required="no">
		<cfargument name="recipient_user" type="numeric" required="no">
		<cfargument name="with_user" type="boolean" required="no" default="false">
		<cfargument name="with_area" type="boolean" required="no" default="false">


		<cfargument name="done" type="boolean" required="no">

		<cfargument name="published" type="boolean" required="false" default="true">

		<cfargument name="year" type="string" required="true">
		<cfargument name="month" type="string" required="true">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var days = arrayNew(1)>


		<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getAreaItems" returnvariable="getAreaItemsResult">
			<cfinvokeargument name="area_id" value="#arguments.area_id#">
			<cfinvokeargument name="areas_ids" value="#arguments.areas_ids#">
			<cfinvokeargument name="user_in_charge" value="#arguments.user_in_charge#">
			<cfinvokeargument name="recipient_user" value="#arguments.recipient_user#">
			<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
			<cfinvokeargument name="listFormat" value="true">
			<cfinvokeargument name="format_content" value="#arguments.format_content#">
			<cfinvokeargument name="with_user" value="#arguments.with_user#">
			<cfinvokeargument name="with_area" value="#arguments.with_area#"/>

			<cfinvokeargument name="with_position" value="false">
			<cfinvokeargument name="parse_dates" value="false"/>

			<cfinvokeargument name="done" value="#arguments.done#">
			<cfinvokeargument name="published" value="#arguments.published#">

			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
		</cfinvoke>
		<cfset areaItemsQuery = getAreaItemsResult.query>

		<cfset month_date = CreateDate(arguments.year, arguments.month, 1)>
		<cfset month_days = DaysInMonth(month_date)>

		<cfquery dbtype="query" name="itemsByMonth">
			SELECT id, title, start_date, end_date
			FROM areaItemsQuery
			WHERE ( MONTH(start_date) = <cfqueryparam value="#arguments.month#" cfsqltype="cf_sql_integer"> AND YEAR(start_date) = <cfqueryparam value="#arguments.year#" cfsqltype="cf_sql_integer"> )
			OR ( MONTH(end_date) = <cfqueryparam value="#arguments.month#" cfsqltype="cf_sql_integer"> AND YEAR(end_date) = <cfqueryparam value="#arguments.year#" cfsqltype="cf_sql_integer"> );
		</cfquery>


		<cfloop index="d" from="1" to="#month_days#" step="1">


			<cfset select_date = CreateDate(arguments.year, arguments.month, #d#)>
			<cfset day = arrayNew(1)>
			<cfset day_with_event = false>


			<cfloop query="itemsByMonth" startrow="1" endrow="#itemsByMonth.recordCount#">
				<cfset title_event = itemsByMonth.title>
				<cfset start_date_event = itemsByMonth.start_date>
				<cfset end_date_event = itemsByMonth.end_date>

				<cfif ((DateCompare(start_date_event, select_date ) IS 0) OR (DateCompare(start_date_event, select_date ) IS -1))
					AND ((DateCompare(end_date_event, select_date ) IS 0) OR (DateCompare(end_date_event, select_date ) IS 1))>

					<cfset event = structNew()>
					<cfset event.title = title_event>
					<cfset arrayAppend(day, event)>
					<cfset day_with_event = true>

				</cfif>

			</cfloop>

			<cfif day_with_event IS true>
				<cfset days[d] = day>
			</cfif>


		</cfloop>

		<cfreturn {days=days}>

	</cffunction>



	<!---  -------------------GET ITEM PARENT----------------------   --->
	<cffunction name="getItemParent" returntype="struct" output="false" access="public">
		<cfargument name="item_id" required="yes" type="numeric">
		<cfargument name="itemTypeId" required="yes" type="numeric">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getItemParent">

		<cfset var parent_area_id = "">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfquery name="getParent" datasource="#client_dsn#">
				SELECT parent_kind, area_id
				<cfif itemTypeId IS 7><!---Consultations--->
				, state
				</cfif>
				FROM #client_abb#_#itemTypeTable#
				WHERE id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif getParent.recordCount GT 0>

				<cfset parent_area_id = getParent.area_id>

				<cfif itemTypeId IS NOT 7>
					<cfreturn {parent_area_id=parent_area_id}>
				<cfelse>
					<cfreturn {parent_area_id=parent_area_id, state=getParent.state}>
				</cfif>

			<cfelse><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#" detail="item_id: #arguments.item_id#">

			</cfif>


	</cffunction>


	<!---  -------------------GET ITEM ROOT----------------------   --->
	<cffunction name="getItemRoot" returntype="query" output="false" access="public">
		<cfargument name="item_id" required="yes" type="numeric">
		<cfargument name="itemTypeId" required="yes" type="numeric">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getItemRoot">

		<cfset var parent_area_id = "">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfquery name="getParentQuery" datasource="#client_dsn#">
				SELECT id, parent_id, parent_kind, area_id, user_in_charge
				<cfif itemTypeId IS 7><!---Consultations--->
				, state
				</cfif>
				FROM #client_abb#_#itemTypeTable#
				WHERE id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif getParentQuery.recordCount GT 0>

				<cfif getParentQuery.parent_kind EQ "area">

					<cfreturn getParentQuery>

				<cfelse>

					<cfinvoke component="AreaItemQuery" method="getItemRoot" returnvariable="getItemRootResult">
						<cfinvokeargument name="item_id" value="#getParentQuery.parent_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfreturn getItemRootResult>

				</cfif>

			<cfelse><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#" detail="item_id: #arguments.item_id#">

			</cfif>


	</cffunction>


	<!---  -------------------GET ITEM CATEGORIES----------------------   --->

	<cffunction name="getItemCategories" returntype="query" output="false" access="public">
		<cfargument name="item_id" required="yes" type="numeric">
		<cfargument name="itemTypeId" required="yes" type="numeric">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getItemCategories">

			<!---<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">--->

			<cfquery name="getItemCategories" datasource="#client_dsn#">
				SELECT items_categories.*, items_categories.area_id AS category_id, areas.name AS category_name
				FROM #client_abb#_items_categories AS items_categories
				INNER JOIN #client_abb#_areas AS areas
				ON items_categories.item_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">
				AND items_categories.item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">
				AND areas.id = items_categories.area_id
				ORDER BY category_name ASC;
			</cfquery>

		<cfreturn getItemCategories>

	</cffunction>


	<!--- getColumsWithTable --->

	<cffunction name="getColumsWithTable" output="false" returntype="string" access="package">
		<cfargument name="colums" type="string" required="true">
		<cfargument name="table" type="string" required="true">

		<cfset var = columsWithTable = "">

		<cfloop list="#arguments.colums#" index="col" delimiters=",">

			<cfset column = trim(col)>

			<!--- Como las columnas se delimitan por comas, hay que añadir lo siguiente para cuando no son columnas normales --->
			<cfif find("IFNULL(last_update_date", column) GT 0><!--- last_update_date column --->
				<cfset columsWithTable = listAppend(columsWithTable, "IFNULL(#arguments.table#.last_update_date,#arguments.table#.creation_date) AS last_update_date", ",")>
			<cfelseif find("IFNULL(last_update_user_id", column) GT 0><!---Esto se usa solo para usersOnly = true--->
				<cfset columsWithTable = listAppend(columsWithTable, "IFNULL(#arguments.table#.last_update_user_id,#arguments.table#.user_in_charge) AS user_in_charge", ",")>
			<cfelseif find("creation_date) AS last_update_date", column) GT 0 OR find("user_in_charge) AS user_in_charge", column) GT 0>
				<!---Este campo ya se ha definido en el anterior--->
			<cfelseif find("NULL", column) IS 0>
				<cfset columsWithTable = listAppend(columsWithTable, "#arguments.table#.#column#", ",")>
			<cfelse>
				<cfset columsWithTable = listAppend(columsWithTable, "NULL", ",")>
			</cfif>

		</cfloop>

		<cfreturn columsWithTable>

	</cffunction>



	<!---listAllAreaItems--->

	<cffunction name="listAllAreaItems" output="false" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="areas_ids" type="string" required="false">
		<cfargument name="area_type" type="string" required="false">
		<cfargument name="limit" type="numeric" required="false">
		<cfargument name="full_content" type="boolean" required="false" default="false">

		<cfargument name="withConsultations" type="boolean" required="false" default="false">
		<cfargument name="withPubmedsComments" type="boolean" required="false" default="false">
		<cfargument name="withMailings" type="boolean" required="false" default="false">
		<cfargument name="withLists" type="boolean" required="false" default="false">
		<cfargument name="withForms" type="boolean" required="false" default="false">
		<cfargument name="withFilesTypologies" type="boolean" required="false" default="false">
		<cfargument name="withUsersTypologies" type="boolean" required="false" default="false">
		<cfargument name="withDPDocuments" type="boolean" required="false" default="false">
		<cfargument name="withArea" type="boolean" required="false" default="false">

		<cfargument name="onlyAreas" type="boolean" required="false" default="false">
		<cfargument name="onlyUsers" type="boolean" required="false" default="false">

		<cfargument name="published" type="boolean" required="false" default="true">

		<cfargument name="delete_user_id" type="numeric" required="false">
		<cfargument name="status" type="string" required="false" default="ok"><!--- ok / deleted --->

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "listAllAreaItems">

			<cfif NOT isDefined("arguments.area_id") AND NOT isDefined("arguments.areas_ids") AND NOT isDefined("arguments.delete_user_id")>

				<cfif NOT isDefined("SESSION.client_administrator") OR NOT isDefined("SESSION.user_id") OR SESSION.client_administrator NEQ SESSION.user_id>

					<cfthrow message="Área o usuario requerido">

				</cfif>

			</cfif>

			<cfset var commonColums = "id, title, creation_date, IFNULL(last_update_date,creation_date) AS last_update_date, description, user_in_charge, last_update_user_id, area_id, NULL AS file_type_id">
			<cfset var commonColumsWithoutLastUpdate = "id, title, creation_date, creation_date AS last_update_date, description, user_in_charge, NULL AS last_update_user_id, area_id, NULL AS file_type_id">

			<cfset var fileCommonColums = "id, name, uploading_date AS creation_date, IFNULL(replacement_date, uploading_date) AS last_update_date, description, user_in_charge, replacement_user, area_files.area_id, file_type_id"><!---IFNULL(replacement_date, uploading_date) AS creation_date--->

			<cfif isDefined("arguments.area_type") AND len(arguments.area_type) GT 0><!--- WEB --->
				<cfset commonColumsWebAdd = ", publication_date, publication_validated">
				<cfset commonColums = commonColums&commonColumsWebAdd>
				<cfset commonColumsWithoutLastUpdate = commonColumsWithoutLastUpdate&commonColumsWebAdd>
				<cfset fileCommonColums = fileCommonColums&", publication_date, publication_validated">
			</cfif>

			<cfset var commonColumsNull = "NULL AS end_date, NULL AS done, NULL AS locked, NULL AS area_editable">

			<cfset var attachedFileColum = "attached_file_id">
			<cfset var attachedFileColumNull = "NULL AS attached_file_id">

			<cfset var eventColums = "end_date, NULL AS done, NULL AS locked, NULL AS area_editable">
			<cfset var taskColums = "end_date, done, NULL AS locked, NULL AS area_editable">
			<cfset var pubmedColums = "NULL AS end_date, NULL AS done, NULL AS locked, NULL AS area_editable">
			<cfset var consultationColums = "NULL AS end_date, NULL AS done, NULL AS locked, NULL AS area_editable">
			<cfset var dpDocumentColums = "NULL AS end_date, NULL AS done, locked, area_editable">
			<cfset var fileColumns = "NULL AS end_date, NULL AS done, locked, NULL AS area_editable">

			<cfset var webColums = "attached_image_id">
			<cfset var webColumsNull = "NULL AS attached_image_id">

			<cfset var iframeColums = "">
			<cfset var iframeColumsNull = "">

			<cfset var displayColums = "">
			<cfset var displayColumsNull = "">

			<cfif arguments.full_content IS true>

				<cfset commonColumsFullAdd = ", NULL AS file_size, NULL AS file_type, NULL AS file_name"><!---, attached_file_name, link, --->
				<cfset commonColums = commonColums&commonColumsFullAdd>
				<cfset commonColumsWithoutLastUpdate = commonColumsWithoutLastUpdate&commonColumsFullAdd>
				<cfset commonColumsNull = commonColumsNull&", NULL AS place, NULL AS start_date, NULL AS identifier, NULL AS sub_type_id, NULL AS state, NULL AS recipient_user">

				<cfset eventColums = eventColums&", place, start_date, NULL AS identifier, NULL AS sub_type_id, NULL AS state, NULL AS recipient_user">
				<cfset taskColums = taskColums&", NULL AS place, start_date, NULL AS identifier, NULL AS sub_type_id, NULL AS state, recipient_user">
				<cfset pubmedColums = pubmedColums&", NULL AS place, NULL AS start_date, identifier, sub_type_id, NULL AS state, NULL AS recipient_user">
				<cfset consultationColums = consultationColums&", NULL AS place, NULL AS start_date, NULL AS identifier, NULL sub_type_id, state, NULL AS recipient_user">
				<cfset dpDocumentColums = dpDocumentColums&", NULL AS place, NULL AS start_date, NULL AS identifier, NULL sub_type_id, NULL AS state, NULL AS recipient_user">
				<cfset fileColumns = fileColumns&", NULL AS place, NULL AS start_date, NULL AS identifier, NULL sub_type_id, NULL AS state, NULL AS recipient_user">

				<cfset fileCommonColums = fileCommonColums&", file_size, file_type, file_name"><!---, NULL AS attached_file_name, NULL AS link--->

				<cfset attachedFileColum = attachedFileColum&", attached_file_name, link">
				<cfset attachedFileColumNull = attachedFileColumNull&", NULL AS attached_file_name, NULL AS link">

				<cfset webColums = webColums&", attached_image_name, link_target">
				<cfset webColumsNull = webColumsNull&", NULL AS attached_image_name, NULL AS link_target">

				<cfset iframeColums = "iframe_url, iframe_display_type_id, ">
				<cfset iframeColumsNull = "NULL AS iframe_url, NULL AS iframe_display_type_id, ">

				<cfset displayColums = "display_type_id, ">
				<cfset displayColumsNull = "NULL AS display_type_id, ">

			<cfelseif arguments.onlyAreas IS true>

				<cfset var commonColums = "id, IFNULL(last_update_date,creation_date) AS last_update_date, area_id">
				<cfset var commonColumsWithoutLastUpdate = "id, creation_date AS last_update_date, area_id">

				<cfset var fileCommonColums = "id, IFNULL(replacement_date, uploading_date) AS last_update_date, area_files.area_id">

			<cfelseif arguments.onlyUsers IS true>

				<cfset var commonColums = "id, IFNULL(last_update_date,creation_date) AS last_update_date, area_id, IFNULL(last_update_user_id, user_in_charge) AS user_in_charge">
				<cfset var commonColumsWithoutLastUpdate = "id, creation_date AS last_update_date, area_id, user_in_charge">

				<cfset var fileCommonColums = "id, IFNULL(replacement_date, uploading_date) AS last_update_date, area_files.area_id, IFNULL(replacement_user, user_in_charge) AS user_in_charge">

			</cfif>

			<cfquery name="areaItemsQuery" datasource="#client_dsn#">
				SELECT

					<cfif arguments.onlyAreas IS true>

						areas.id AS area_id, areas.name AS area_name, MAX(items.last_update_date) AS last_update_date

					<cfelseif arguments.onlyUsers IS true>

						users.*, users.id AS user_id, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name, users.image_type AS user_image_type
						<!---, items.id AS item_id, itemTypeId, areas.id AS area_id, areas.name AS area_name--->, MAX(items.last_update_date) AS last_update_date

					<cfelse>

						items.*, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name, users.image_type AS user_image_type
						<cfif isDefined("arguments.area_type") AND len(arguments.area_type) GT 0><!--- WEB --->
						, items_position.position
							<cfif arguments.full_content IS true>
								, iframes_display_types.width AS iframe_width, iframes_display_types.width_unit AS iframe_width_unit, iframes_display_types.height AS iframe_height, iframes_display_types.height_unit AS iframe_height_unit
							</cfif>
						</cfif>
						<cfif arguments.withArea IS true>
						, areas.name AS area_name, areas.read_only AS area_read_only
						</cfif>
						<cfif arguments.status EQ "deleted">
						, items_deleted.delete_date, items_deleted.delete_area_id
						</cfif>

					</cfif>

				FROM (
				<cfif NOT isDefined("arguments.area_type") OR len(arguments.area_type) IS 0><!--- IS NOT WEB --->


					<!--- Messages --->
					( SELECT #commonColumsWithoutLastUpdate#, #attachedFileColum#, #webColumsNull#, #commonColumsNull#, #iframeColumsNull# #displayColumsNull# 1 AS itemTypeId
					FROM #client_abb#_messages AS messages
					WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
					<cfif isDefined("arguments.area_id")>
					AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					</cfif>
					)
					<cfif arguments.withConsultations IS true>
					UNION ALL <!--- Consultations --->
					( SELECT #commonColumsWithoutLastUpdate#, #attachedFileColum#, #webColumsNull#, #consultationColums#, #iframeColumsNull# #displayColumsNull# 7 AS itemTypeId
					FROM #client_abb#_consultations AS consultations
					WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
					<cfif isDefined("arguments.area_id")>
					AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					</cfif>
					)
					</cfif>

					UNION ALL <!--- Tasks --->
					( SELECT #commonColums#, #attachedFileColum#, #webColumsNull#, #taskColums#, #iframeColumsNull# #displayColumsNull# 6 AS itemTypeId
					FROM #client_abb#_tasks AS tasks
					WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
					<cfif isDefined("arguments.area_id")>
					AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					</cfif>
					)

					<cfif arguments.withDPDocuments IS true>
					UNION ALL <!--- DoPlanning Documents --->
					( SELECT #commonColums#, #attachedFileColum#, #webColumsNull#, #dpDocumentColums#, #iframeColumsNull# #displayColumsNull# 20 AS itemTypeId
					FROM #client_abb#_dp_documents AS dp_documents
					WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
					<cfif isDefined("arguments.area_id")>
					AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					</cfif>
					)
					</cfif>


				</cfif>
				<cfif NOT isDefined("arguments.area_type")>
					UNION ALL
				</cfif>
				<cfif NOT isDefined("arguments.area_type") OR len(arguments.area_type) GT 0><!--- WEB --->
					<!--- Entries --->
					( SELECT #commonColums#, #attachedFileColum#, #webColums#, #commonColumsNull#, #iframeColums# #displayColums# 2 AS itemTypeId
					FROM #client_abb#_entries AS entries
					WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
					<cfif isDefined("arguments.area_id")>
					AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					</cfif>
					)
					<cfif APPLICATION.identifier EQ "vpnet">
					UNION ALL <!--- Links --->
					( SELECT #commonColums#, #attachedFileColum#, #webColums#, #commonColumsNull#, #iframeColumsNull# #displayColumsNull# 3 AS itemTypeId
					FROM #client_abb#_links AS links
					WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
					<cfif isDefined("arguments.area_id")>
					AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					</cfif>
					)
					</cfif>
					UNION ALL <!--- News --->
					( SELECT #commonColums#, #attachedFileColum#, #webColums#, #commonColumsNull#, #iframeColums# #displayColumsNull# 4 AS itemTypeId
					FROM #client_abb#_news AS news
					WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
					<cfif isDefined("arguments.area_id")>
					AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					</cfif>
					)
					UNION ALL <!--- Images --->
					( SELECT #commonColums#, #attachedFileColum#, #webColums#, #commonColumsNull#, #iframeColumsNull# #displayColumsNull# 9 AS itemTypeId
					FROM #client_abb#_images AS images
					WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
					<cfif isDefined("arguments.area_id")>
					AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					</cfif>
					)
				</cfif>
				UNION ALL <!--- Events --->
				( SELECT #commonColums#, #attachedFileColum#, #webColums#, #eventColums#, #iframeColums# #displayColumsNull# 5 AS itemTypeId
				FROM #client_abb#_events AS events
				WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
				<cfif isDefined("arguments.area_id")>
				AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfif>
				)
				<!--- <cfif APPLICATION.modulePubMedComments IS true> --->
				<cfif arguments.withPubmedsComments IS true><!--- Pubmeds --->
				UNION ALL
				( SELECT #commonColums#, #attachedFileColum#, #webColums#, #pubmedColums#, #iframeColumsNull# #displayColumsNull# 8 AS itemTypeId
				FROM #client_abb#_pubmeds AS pubmeds
				WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
				<cfif isDefined("arguments.area_id")>
				AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfif>
				)
				</cfif>

				<cfif arguments.withMailings IS true><!--- Mailing --->
				UNION ALL
				( SELECT #commonColums#, #attachedFileColum#, #webColums#, #commonColumsNull#, #iframeColumsNull# #displayColumsNull# 17 AS itemTypeId
				FROM #client_abb#_mailings AS mailings
				WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
				<cfif isDefined("arguments.area_id")>
				AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfif>
				)
				</cfif>

				<!--- <cfif APPLICATION.moduleLists IS true> --->
				<cfif arguments.withLists IS true><!--- Lists --->
				UNION ALL
				( SELECT #commonColums#, #attachedFileColumNull#, #webColumsNull#, #commonColumsNull#, #iframeColumsNull# #displayColumsNull# 11 AS itemTypeId
				FROM #client_abb#_lists AS lists
				WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
				<cfif isDefined("arguments.area_id")>
				AND lists.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfif>
				)
				UNION ALL <!--- List Views --->
				( SELECT #getColumsWithTable(commonColums, "lists_views")#, #attachedFileColumNull#, #webColumsNull#, #commonColumsNull#, #iframeColumsNull# #displayColumsNull# 14 AS itemTypeId
				FROM #client_abb#_lists_views AS lists_views
				INNER JOIN `#client_abb#_lists` AS lists_v ON lists_views.table_id = lists_v.id
				<cfif arguments.published IS true>
					AND ( lists_views.publication_date IS NULL OR lists_views.publication_date <= NOW() )
					AND ( lists_v.publication_date IS NULL OR lists_v.publication_date <= NOW() )
					<cfif APPLICATION.publicationValidation IS true>
					AND ( lists_views.publication_validated IS NULL OR lists_views.publication_validated = true )
					AND ( lists_v.publication_validated IS NULL OR lists_v.publication_validated = true )
					</cfif>
				</cfif>
				WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
				<cfif isDefined("arguments.area_id")>
				AND lists_views.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfif>)
				</cfif>

				<!---<cfif APPLICATION.moduleForms IS true>--->
				<cfif arguments.withForms IS true><!--- Forms --->
				UNION ALL
				( SELECT #commonColums#, #attachedFileColumNull#, #webColumsNull#, #commonColumsNull#, #iframeColumsNull# #displayColumsNull# 12 AS itemTypeId
				FROM #client_abb#_forms AS forms
				WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
				<cfif isDefined("arguments.area_id")>
				AND forms.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfif>
				)
				UNION ALL <!--- Form Views --->
				( SELECT #getColumsWithTable(commonColums, "forms_views")#, #attachedFileColumNull#, #webColumsNull#, #commonColumsNull#, #iframeColumsNull# #displayColumsNull# 15 AS itemTypeId
				FROM #client_abb#_forms_views AS forms_views
				INNER JOIN `#client_abb#_forms` AS forms_v ON forms_views.table_id = forms_v.id
				<cfif arguments.published IS true>
					AND ( forms_views.publication_date IS NULL OR forms_views.publication_date <= NOW() )
					AND ( forms_v.publication_date IS NULL OR forms_v.publication_date <= NOW() )
					<cfif APPLICATION.publicationValidation IS true>
					AND ( forms_views.publication_validated IS NULL OR forms_views.publication_validated = true )
					AND ( forms_v.publication_validated IS NULL OR forms_v.publication_validated = true )
					</cfif>
				</cfif>
				WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
				<cfif isDefined("arguments.area_id")>
				AND forms_views.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfif>)
				</cfif>

				<cfif arguments.withFilesTypologies IS true><!--- Typologies --->
				UNION ALL
				( SELECT #commonColums#, #attachedFileColumNull#, #webColumsNull#, #commonColumsNull#, #iframeColumsNull# #displayColumsNull# 13 AS itemTypeId
				FROM #client_abb#_typologies AS typologies
				WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
				<cfif isDefined("arguments.area_id")>
				AND typologies.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfif>
				)
				</cfif>

				<cfif arguments.withUsersTypologies IS true><!--- Users Typologies --->
				UNION ALL
				( SELECT #commonColums#, #attachedFileColumNull#, #webColumsNull#, #commonColumsNull#, #iframeColumsNull# #displayColumsNull# 16 AS itemTypeId
				FROM #client_abb#_users_typologies AS users_typologies
				WHERE status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
				<cfif isDefined("arguments.area_id")>
				AND users_typologies.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfif>
				)
				</cfif>

				<!--- Files --->
				UNION ALL
				( SELECT #fileCommonColums#, #attachedFileColumNull#, #webColumsNull#, #fileColumns#, #iframeColumsNull# #displayColumsNull# 10 AS itemTypeId
				FROM #client_abb#_files AS files

				INNER JOIN #client_abb#_areas_files AS area_files ON files.id = area_files.file_id
					<cfif isDefined("arguments.area_id")>
					AND area_files.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					</cfif>
					AND files.status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">)
				) AS items

				<cfif arguments.withArea IS true OR isDefined("arguments.areas_ids")><!--- AREAS --->

					INNER JOIN #client_abb#_areas AS areas
					ON items.area_id = areas.id
					<cfif isDefined("arguments.areas_ids")>
						AND items.area_id IN (<cfqueryparam value="#arguments.areas_ids#" cfsqltype="cf_sql_integer" list="true">)
					</cfif>

				</cfif>


				<cfif arguments.onlyAreas IS false>
					INNER JOIN #client_abb#_users AS users
					ON items.user_in_charge = users.id
				</cfif>


				<cfif arguments.status EQ "deleted">

					INNER JOIN #client_abb#_items_deleted AS items_deleted
					ON items_deleted.in_bin = <cfqueryparam value="true" cfsqltype="cf_sql_bit">
					AND items.id = items_deleted.item_id
					AND items.itemTypeId = items_deleted.item_type_id

					<cfif isDefined("arguments.delete_user_id")>

						AND items_deleted.delete_user_id = <cfqueryparam value="#arguments.delete_user_id#" cfsqltype="cf_sql_integer">

					</cfif>

				</cfif>

				<cfif isDefined("arguments.area_type") AND len(arguments.area_type) GT 0><!---WEB--->
					LEFT JOIN #client_abb#_items_position AS items_position
					ON items.id = items_position.item_id AND itemTypeId = items_position.item_type_id
					AND items_position.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					<cfif arguments.full_content IS true>
						LEFT JOIN #client_abb#_iframes_display_types AS iframes_display_types
						ON items.iframe_display_type_id = iframes_display_types.iframe_display_type_id
					</cfif>

					<cfif arguments.published IS true>
						WHERE ( items.publication_date IS NULL OR items.publication_date <= NOW() )
						<cfif APPLICATION.publicationValidation IS true>
						AND ( items.publication_validated IS NULL OR items.publication_validated = true )
						</cfif>
					</cfif>

					ORDER BY items_position.position DESC, items.creation_date DESC
				<cfelse>
					<cfif arguments.onlyAreas IS true>
						GROUP BY areas.id
					<cfelseif arguments.onlyUsers IS true>
						GROUP BY users.id
					</cfif>
					ORDER BY last_update_date DESC
				</cfif>

				<cfif isDefined("arguments.limit")>
				LIMIT #arguments.limit#
				</cfif>;
			</cfquery>


		<cfreturn {query=areaItemsQuery}>

	</cffunction>



	<!---listAllAreaWebItems--->
	<!---Esta función DEBE DEJAR DE USARSE, sólo se mantiene por retrocompatibilidad--->
	<cffunction name="listAllAreaWebItems" output="false" returntype="query" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="limit" type="numeric" required="no">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "listAllAreaWebItems">

			<cfquery name="areaWebItemsQuery" datasource="#client_dsn#">
				(SELECT id, title, creation_date, description, 2 AS type_id, #area_id# AS area_id
				FROM #client_abb#_entries AS entries
				WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				AND status='ok')
				<cfif APPLICATION.identifier EQ "vpnet">
				UNION ALL
				(SELECT id, title, creation_date, description, 3 AS type_id, #area_id# AS area_id
				FROM #client_abb#_links AS links
				WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				AND status='ok')
				</cfif>
				UNION ALL
				(SELECT id, title, creation_date, description, 4 AS type_id, #area_id# AS area_id
				FROM #client_abb#_news AS news
				WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				AND status='ok')
				UNION ALL
				(SELECT id, title, creation_date, description, 5 AS type_id, #area_id# AS area_id
				FROM #client_abb#_events AS events
				WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				AND status='ok')
				<cfif APPLICATION.identifier EQ "vpnet">
				<!---Files--->
				UNION ALL
				(SELECT id, name, association_date, description, 10 AS type_id, #area_id# AS area_id
				FROM #client_abb#_files AS files
				INNER JOIN #client_abb#_areas_files AS area_files ON files.id = area_files.file_id
				WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				AND status='ok')
				</cfif>
				ORDER BY creation_date DESC
				<cfif isDefined("arguments.limit")>
				LIMIT #arguments.limit#
				</cfif>;
			</cfquery>

		<cfreturn areaWebItemsQuery>

	</cffunction>


	<!---  ---------------------- addReadToItem -------------------------------- --->

	<cffunction name="addReadToItem" returntype="void" access="public">
		<cfargument name="item_id" type="numeric" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="user_id" type="numeric" required="yes">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "addReadToItem">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfquery name="addReadToItem" datasource="#client_dsn#">
				INSERT INTO `#client_abb#_#itemTypeTable#_readings`
				SET #itemTypeName#_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">,
				user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">,
				date = NOW();
			</cfquery>

	</cffunction>
	<!---  ------------------------------------------------------------------------ --->


	<!---  ---------------------- updateItemState -------------------------------- --->

	<cffunction name="updateItemState" returntype="void" access="public">
		<cfargument name="item_id" type="numeric" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="state" type="string" required="yes">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "updateItemState">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfquery name="addReadToItem" datasource="#client_dsn#">
				UPDATE #client_abb#_#itemTypeTable#
				SET	state = <cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">,
				last_update_date = NOW()
				<cfswitch expression="#arguments.state#">
					<cfcase value="read">
						, read_date = NOW()
					</cfcase>
					<cfcase value="answered">
						, answer_date = NOW()
					</cfcase>
					<cfcase value="closed">
						, close_date = NOW()
					</cfcase>
				</cfswitch>
				WHERE
				id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
			</cfquery>


	</cffunction>
	<!---  ------------------------------------------------------------------------ --->



	<!---  ---------------------- setItemReadDate -------------------------------- --->

	<cffunction name="setItemReadDate" returntype="void" access="public">
		<cfargument name="item_id" type="numeric" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "setItemReadDate">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

				<cfquery name="setReadDateQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_#itemTypeTable#
					SET read_date = NOW()
					WHERE id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

	</cffunction>
	<!---  ------------------------------------------------------------------------ --->



	<!---  ---------------------- changeItemsState -------------------------------- --->

	<cffunction name="changeItemsState" returntype="void" access="public">
		<cfargument name="item_id" type="numeric" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="state" type="string" required="yes">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "changeItemsState">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfinvoke component="AreaItemQuery" method="updateItemState">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="state" value="#arguments.state#">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<!---Get sub item--->
			<cfquery name="getSubItem" datasource="#client_dsn#">
				SELECT id, state
				FROM #client_abb#_#itemTypeTable#
				WHERE parent_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">
				AND parent_kind = <cfqueryparam value="#itemTypeName#" cfsqltype="cf_sql_varchar">;
			</cfquery>

			<cfif getSubItem.recordCount GT 0>

				<cfinvoke component="AreaItemQuery" method="changeItemsState" returnvariable="changeItemStateResult">
					<cfinvokeargument name="item_id" value="#getSubItem.id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="state" value="#arguments.state#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

			</cfif>

	</cffunction>
	<!---  ------------------------------------------------------------------------ --->


	<!---  ---------------------- deleteItemPosition -------------------------------- --->

	<cffunction name="deleteItemPosition" returntype="void" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteItemPosition">

			<cfquery name="deleteItemPosition" datasource="#client_dsn#">
				DELETE FROM #client_abb#_items_position
				WHERE item_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">
				AND item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">
				<cfif isDefined("arguments.area_id")>
					AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfif>;
			</cfquery>

	</cffunction>

</cfcomponent>

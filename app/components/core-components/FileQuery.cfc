<!---Copyright Era7 Information Technologies 2007-2015

	Date of file creation: 16-05-2012
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 14-01-2013

--->
<cfcomponent output="false">

	<cfset component = "FileQuery">

	<cfset dateFormat = "%d-%m-%Y"><!---%H:%i:%s---><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset dateTimeFormat = "%d-%m-%Y %H:%i:%s">
	<!--- <cfset timeZoneTo = "+1:00"> --->
	<cfset timeZoneTo = "Europe/Madrid">


	<!---getFile--->

	<cffunction name="getFile" output="false" returntype="query" access="public">
		<cfargument name="file_id" type="numeric" required="false">
		<cfargument name="file_public_id" type="string" required="false">
		<cfargument name="fileTypeId" type="numeric" required="false">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="with_lock" type="boolean" required="false" default="false">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">
		<cfargument name="status" type="string" required="false" default="ok"><!--- ok --->
		<cfargument name="ignore_status" type="boolean" required="false" default="false">
		<cfargument name="published" type="boolean" required="false" default="true">
		<cfargument name="with_owner_area" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getFile">

		<cfif arguments.fileTypeId IS NOT 4>

			<cfset fileTypeTable = "files">

			<cfquery name="selectFileQuery" datasource="#client_dsn#">
				SELECT files.id, files.id AS file_id, physical_name, files.user_in_charge, file_size, file_type, files.name, file_name, files.description, files.status, users.image_type AS user_image_type, files.typology_id, files.typology_row_id, files.file_type_id, files.locked, files.area_id, files.reviser_user, files.approver_user, files.in_approval, files.replacement_user, files.public, files.file_public_id, files.item_id, files.item_type_id, files.row_id, files.field_id
					, users.name AS user_name, users.family_name, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name
				<cfif isDefined("arguments.area_id")>
					, areas_files.association_date
					<cfif arguments.parse_dates IS true>
						, DATE_FORMAT(CONVERT_TZ(areas_files.publication_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS publication_date
					<cfelse>
						, areas_files.publication_date
					</cfif>
					, areas_files.publication_validated
				</cfif>
				<cfif arguments.with_owner_area IS true><!--- Only for fileTypes 2 OR 3 --->
					, areas.name AS area_name
				</cfif>
				<cfif arguments.with_lock IS true>
				, locks.user_id AS lock_user_id, locks.lock_user_full_name
				</cfif>
				<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(CONVERT_TZ(files.uploading_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS uploading_date
					, DATE_FORMAT(CONVERT_TZ(files.replacement_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS replacement_date
					<cfif arguments.with_lock IS true>
					, DATE_FORMAT(CONVERT_TZ(locks.lock_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS lock_date
					</cfif>
				<cfelse>
					, files.uploading_date
					, files.replacement_date
					<cfif arguments.with_lock IS true>
					, locks.lock_date
					</cfif>
				</cfif>
				<cfif APPLICATION.publicationScope IS true>
					, files.publication_scope_id, scopes.name AS publication_scope_name
				</cfif>
				<cfif isDefined("APPLICATION.moduleAntiVirus") AND APPLICATION.moduleAntiVirus IS true>
					, files.anti_virus_check, files.anti_virus_check_result
				</cfif>
				, IF(files.replacement_user IS NOT NULL, CONCAT_WS(' ', users_replacement.family_name, users_replacement.name), '' ) AS replacement_user_full_name
				, users_replacement.image_type AS replacement_user_image_type
				, IF(files.reviser_user IS NOT NULL, CONCAT_WS(' ', users_reviser.family_name, users_reviser.name), '' ) AS reviser_user_full_name
				, IF(files.approver_user IS NOT NULL, CONCAT_WS(' ', users_approver.family_name, users_approver.name), '' ) AS approver_user_full_name
				FROM #client_abb#_#fileTypeTable# AS files
				LEFT JOIN #client_abb#_users AS users
				ON files.user_in_charge = users.id
				<cfif arguments.ignore_status IS false>
					AND status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
				</cfif>
				LEFT JOIN #client_abb#_users AS users_replacement
				ON files.replacement_user = users_replacement.id
				LEFT JOIN #client_abb#_users AS users_reviser
				ON files.reviser_user = users_reviser.id
				LEFT JOIN #client_abb#_users AS users_approver
				ON files.approver_user = users_approver.id
				<cfif arguments.with_lock IS true>
				LEFT JOIN (
					SELECT files_locks.file_id, files_locks.lock_date, files_locks.lock, files_locks.user_id,
					CONCAT_WS(' ', users_locks.family_name, users_locks.name) AS lock_user_full_name
					FROM #client_abb#_#fileTypeTable#_locks AS files_locks
					INNER JOIN #client_abb#_users AS users_locks ON files_locks.file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer"> AND files_locks.user_id = users_locks.id
					ORDER BY lock_date DESC
					LIMIT 1
				) AS locks ON locks.file_id = files.id
				</cfif>

				<cfif arguments.with_owner_area IS true><!--- Only for fileTypes 2 OR 3 --->
					LEFT JOIN #client_abb#_areas AS areas
					ON files.area_id = areas.id
				</cfif>

				<cfif isDefined("arguments.area_id")>
					INNER JOIN #client_abb#_areas_files AS areas_files
					ON files.id = areas_files.file_id
					AND areas_files.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					<cfif arguments.published IS true>
						AND ( areas_files.publication_date IS NULL OR areas_files.publication_date <= NOW() )
						<cfif APPLICATION.publicationValidation IS true>
						AND ( areas_files.publication_validated IS NULL OR areas_files.publication_validated = true )
						</cfif>
					</cfif>
				</cfif>

				<cfif APPLICATION.publicationScope IS true>
					LEFT JOIN #client_abb#_scopes AS scopes ON files.publication_scope_id = scopes.scope_id
				</cfif>
				WHERE
				<cfif isDefined("arguments.file_public_id")>
					files.file_public_id = <cfqueryparam value="#arguments.file_public_id#" cfsqltype="cf_sql_varchar">
				<cfelse>
					files.id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">
				</cfif>
				;
			</cfquery>

		<cfelse><!---AREA IMAGES--->

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfquery name="selectFileQuery" datasource="#client_dsn#">
				SELECT *
				FROM #client_abb#_#fileTypeTable# AS files
				WHERE files.id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

		</cfif>

		<cfreturn selectFileQuery>

	</cffunction>


	<!--- ------------------------------------- createFileInDatabase -------------------------------------  --->

	<cffunction name="createFileInDatabase" output="false" access="public" returntype="numeric">
		<cfargument name="fileTypeId" type="numeric" required="true"/>
		<cfargument name="name" type="string" required="false"/>
		<cfargument name="file_name" type="string" required="true"/>
		<cfargument name="file_size" type="numeric" required="true"/>
		<cfargument name="file_type" type="string" required="true"/>
		<cfargument name="description" type="string" required="false"/>
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="reviser_user" type="numeric" required="false">
		<cfargument name="approver_user" type="numeric" required="false">
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="version_index" type="string" required="false">
		<cfargument name="public" type="boolean" required="false">
		<cfargument name="file_public_id" type="numeric" required="false">
		<cfargument name="user_id" type="numeric" required="false">
		<cfargument name="status" type="string" required="true">
		<cfargument name="anti_virus_check" type="boolean" required="false">
		<cfargument name="anti_virus_check_result" type="string" required="false">
		<cfargument name="item_id" type="numeric" required="false">
		<cfargument name="itemTypeId" type="numeric" required="false">
		<cfargument name="row_id" type="numeric" required="false">
		<cfargument name="field_id" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "createFileInDatabase">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfquery name="createFileQuery" datasource="#client_dsn#" result="createFileResult">
				INSERT INTO `#client_abb#_#fileTypeTable#`
				SET
				file_name = <cfqueryparam value="#arguments.file_name#" cfsqltype="cf_sql_varchar">,
				file_size = <cfqueryparam value="#arguments.file_size#" cfsqltype="cf_sql_integer">,
				file_type = <cfqueryparam value="#arguments.file_type#" cfsqltype="cf_sql_varchar">,
				uploading_date = NOW(),
				status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
				<cfif arguments.fileTypeId IS NOT 4><!---IS NOT area image--->
					, file_type_id = <cfqueryparam value="#arguments.fileTypeId#" cfsqltype="cf_sql_integer">
					<cfif isDefined("arguments.name")>
						, name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">
					</cfif>
					<cfif isDefined("arguments.user_id")>
						, user_in_charge = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">
					</cfif>
					<cfif isDefined("arguments.description")>
						, description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
					</cfif>
				</cfif>
				<cfif arguments.fileTypeId IS 2 OR arguments.fileTypeId IS 3 OR arguments.fileTypeId IS 4><!--- Area file --->
					, area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif arguments.fileTypeId IS 3>
					, reviser_user = <cfqueryparam value="#arguments.reviser_user#" cfsqltype="cf_sql_integer">
					, approver_user = <cfqueryparam value="#arguments.approver_user#" cfsqltype="cf_sql_integer">
				<cfelse>
					<cfif isDefined("arguments.publication_scope_id")>
					, publication_scope_id = <cfqueryparam value="#arguments.publication_scope_id#" cfsqltype="cf_sql_integer">
					</cfif>
					<cfif ( arguments.fileTypeId IS 1 OR arguments.fileTypeId IS 2 ) AND arguments.public IS true>
						, public = <cfqueryparam value="#arguments.public#" cfsqltype="cf_sql_bit">
						, file_public_id = <cfqueryparam value="#arguments.file_public_id#" cfsqltype="cf_sql_varchar">
					</cfif>
				</cfif>
				<cfif isDefined("arguments.anti_virus_check") AND isDefined("arguments.anti_virus_check_result")>
				, anti_virus_check = <cfqueryparam value="#arguments.anti_virus_check#" cfsqltype="cf_sql_bit">
				, anti_virus_check_result = <cfqueryparam value="#arguments.anti_virus_check_result#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined("arguments.item_id") AND isDefined("arguments.itemTypeId")>
					, item_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">
					, item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif isDefined("arguments.row_id") AND isDefined("arguments.field_id")>
					, row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">
					, field_id = <cfqueryparam value="#arguments.field_id#" cfsqltype="cf_sql_integer">
				</cfif>
				;
			</cfquery>

			<cfquery name="getLastInsertId" datasource="#client_dsn#">
				SELECT LAST_INSERT_ID() AS insert_file_id FROM #client_abb#_#fileTypeTable#;
			</cfquery>
			<cfset file_id = getLastInsertId.insert_file_id>

			<cfreturn file_id>

	</cffunction>


	<!---getFileLocks--->

	<cffunction name="getFileLocks" output="false" returntype="query" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getFileLocks">

		<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

		<cfquery name="getFileLocksQuery" datasource="#client_dsn#">
			SELECT files_locks.file_id, files_locks.user_id, files_locks.lock
			, DATE_FORMAT(files.date, '#dateTimeFormat#') AS date
			, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name
			FROM `#client_abb#_#fileTypeTable#_locks` AS files_locks
			INNER JOIN `#client_abb#_users` AS users
			ON files_locks.file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer"> AND files_locks.user_id = users.id
			ORDER BY date DESC;
		</cfquery>

		<cfreturn getFileLocksQuery>

	</cffunction>



	<!---getAreaFiles--->

	<cffunction name="getAreaFiles" output="false" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="no">
		<cfargument name="areas_ids" type="string" required="no">
		<cfargument name="search_text" type="string" required="no">
		<cfargument name="user_in_charge" type="numeric" required="no">
		<cfargument name="typology_id" type="numeric" required="false">
		<cfargument name="name" type="string" required="false">
		<cfargument name="file_name" type="string" required="false">
		<cfargument name="description" type="string" required="false">
		<cfargument name="limit" type="numeric" required="false">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">
		<cfargument name="with_user" type="boolean" required="true" default="false">
		<cfargument name="with_area" type="boolean" required="false" default="false">
		<cfargument name="with_typology" type="boolean" required="false" default="false">
		<cfargument name="with_null_typology" type="boolean" required="false" default="false">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="categories_condition" type="string" required="false" default="AND">
		<cfargument name="published" type="boolean" required="false">

		<cfargument name="from_date" type="string" required="no">
		<cfargument name="end_date" type="string" required="no">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getAreaFiles">
		<cfset var count = 0>

		<cfset var search_text_re = "">
		<cfset var name_re = "">
		<cfset var file_name_re = "">
		<cfset var description_re = "">

		<cfif isDefined("arguments.search_text") AND len(arguments.search_text) GT 0>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/SearchManager" method="generateSearchText" returnvariable="search_text_re">
				<cfinvokeargument name="text" value="#arguments.search_text#">
			</cfinvoke>

		</cfif>

		<cfif isDefined("arguments.name") AND len(arguments.name) GT 0>
			<cfinvoke component="#APPLICATION.coreComponentsPath#/SearchManager" method="generateSearchText" returnvariable="name_re">
				<cfinvokeargument name="text" value="#arguments.name#">
			</cfinvoke>
		</cfif>

		<cfif isDefined("arguments.file_name") AND len(arguments.file_name) GT 0>
			<cfinvoke component="#APPLICATION.coreComponentsPath#/SearchManager" method="generateSearchText" returnvariable="file_name_re">
				<cfinvokeargument name="text" value="#arguments.file_name#">
			</cfinvoke>
		</cfif>

		<cfif isDefined("arguments.description") AND len(arguments.description) GT 0>
			<cfinvoke component="#APPLICATION.coreComponentsPath#/SearchManager" method="generateSearchText" returnvariable="description_re">
				<cfinvokeargument name="text" value="#arguments.description#">
			</cfinvoke>
		</cfif>

		<cftransaction>

			<cfquery name="areaFilesQuery" datasource="#client_dsn#">
				SELECT <cfif isDefined("arguments.limit")>SQL_CALC_FOUND_ROWS</cfif>
				files.id, files.physical_name, files.user_in_charge, files.file_size, files.file_type, files.name, files.file_name, files.description, files.file_type_id,
					IF( replacement_date IS NULL, IF(association_date IS NULL, uploading_date, association_date), replacement_date ) AS last_version_date,
					IF( a.area_id IS NULL, files.area_id, a.area_id ) AS area_id
				<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(files.uploading_date, '#dateTimeFormat#') AS uploading_date
					, DATE_FORMAT(files.replacement_date, '#dateTimeFormat#') AS replacement_date
					, DATE_FORMAT(a.association_date, '#dateTimeFormat#') AS association_date
				<cfelse>
					, files.uploading_date
					, files.replacement_date
					, a.association_date
				</cfif>
				<cfif arguments.with_user IS true>
					, users.family_name, users.name AS user_name, users.image_type AS user_image_type,
					CONCAT_WS(' ', users.family_name, users.name) AS user_full_name
				</cfif>
				<cfif arguments.with_area IS true>
					, areas.name AS area_name
				</cfif>
				<cfif arguments.with_typology IS true>
					, files.typology_id, typologies.title AS typology_title
				</cfif>
				FROM #client_abb#_areas_files AS a
				INNER JOIN #client_abb#_files AS files ON a.file_id = files.id
				<cfif isDefined("arguments.areas_ids")>
					AND a.area_id IN (<cfqueryparam value="#arguments.areas_ids#" cfsqltype="cf_sql_varchar" list="yes">)
				<cfelse>
					AND a.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif arguments.with_user IS true>
					INNER JOIN #client_abb#_users AS users ON files.user_in_charge = users.id
				</cfif>
				<cfif isDefined("arguments.user_in_charge")>
					AND files.user_in_charge = <cfqueryparam value="#arguments.user_in_charge#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif arguments.with_area IS true>
					INNER JOIN #client_abb#_areas AS areas ON a.area_id = areas.id
				</cfif>
				<cfif arguments.with_typology IS true>
					INNER JOIN #client_abb#_typologies AS typologies ON files.typology_id = typologies.id
					<cfif isDefined("arguments.typology_id")>
						AND files.typology_id = <cfqueryparam value="#arguments.typology_id#" cfsqltype="cf_sql_integer">
					</cfif>
				</cfif>

				WHERE files.status = 'ok'
				<cfif isDefined("arguments.published") AND arguments.published IS true>
					AND ( a.publication_date IS NULL OR a.publication_date <= NOW() )
					<cfif isDefined("arguments.from_date") AND len(arguments.from_date) GT 0><!---getUserDiaryAlert--->
						AND ( a.publication_date IS NULL OR a.publication_date <= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#dateFormat#') )
					</cfif>
					<cfif APPLICATION.publicationValidation IS true>
					AND ( a.publication_validated IS NULL OR a.publication_validated = true )
					</cfif>
				</cfif>
				<cfif arguments.with_typology IS false AND isDefined("arguments.typology_id")>
					AND files.typology_id = <cfqueryparam value="#arguments.typology_id#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif isDefined("arguments.with_null_typology") AND arguments.with_null_typology IS true>
					AND files.typology_id IS NULL
				</cfif>
				<cfif isDefined("arguments.categories_ids") and arrayLen(arguments.categories_ids) GT 0>
					AND (
					<cfset categoryCount = 1>
					<cfloop array="#arguments.categories_ids#" index="category_id">
						<cfif isNumeric(category_id)>
							<cfif categoryCount GT 1>
								#arguments.categories_condition#
							</cfif>
								files.id IN ( SELECT item_id FROM `#client_abb#_items_categories`
								WHERE item_type_id = <cfqueryparam value="10" cfsqltype="cf_sql_integer">
								AND area_id = <cfqueryparam value="#category_id#" cfsqltype="cf_sql_integer"> )
							<cfset categoryCount = categoryCount+1>
						</cfif>
					</cfloop>
					)
				</cfif>
				<cfif len(search_text_re) GT 0><!---Search--->
				AND (files.name REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
				OR files.file_name REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
				OR files.description REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
				)
				</cfif>
				<cfif len(name_re) GT 0>
					AND	files.name REGEXP <cfqueryparam value="#name_re#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif len(file_name_re) GT 0>
					AND	files.file_name REGEXP <cfqueryparam value="#file_name_re#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif len(description_re) GT 0>
					AND	files.description REGEXP <cfqueryparam value="#description_re#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif isDefined("arguments.from_date") AND len(arguments.from_date) GT 0>
				AND ( files.uploading_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#dateFormat#')
					OR files.replacement_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#dateFormat#') )
				</cfif>
				<cfif isDefined("arguments.end_date") AND len(arguments.end_date) GT 0>
				AND ( files.uploading_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#dateTimeFormat#')
					<!---OR files.replacement_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#dateTimeFormat#')--->
					AND IF( files.replacement_date IS NULL, true, files.replacement_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#dateTimeFormat#') ) )
				</cfif>
				ORDER BY last_version_date DESC
				<cfif isDefined("arguments.limit")>
				LIMIT #arguments.limit#
				</cfif>;
			</cfquery>

			<cfif isDefined("arguments.limit")>
				<cfquery datasource="#client_dsn#" name="getCount">
					SELECT FOUND_ROWS() AS count;
				</cfquery>
				<cfset count = getCount.count>
			</cfif>

		</cftransaction>

		<!---<cfreturn areaFilesQuery>--->

		<cfreturn {query=areaFilesQuery, count=count}>

	</cffunction>


	<!---getFileVersion--->

	<cffunction name="getFileVersion" output="false" returntype="query" access="public">
		<cfargument name="version_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getFileVersion">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfquery name="getFileVersionsQuery" datasource="#client_dsn#">
				SELECT files.version_id, files.file_id, files.physical_name, files.user_in_charge, files.file_size, files.file_type, files.file_name, files.version_index, files.description, files.revision_request_user, files.revised, files.revision_result, files.revision_user, files.approved, files.approval_user, files.publication_user, files.publication_date, files.publication_file_id, files.publication_area_id
					, files.revision_result_reason, files.approval_result_reason
					, DATE_FORMAT(CONVERT_TZ(files.uploading_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS uploading_date
					, DATE_FORMAT(CONVERT_TZ(files.revision_request_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS revision_request_date
					, DATE_FORMAT(CONVERT_TZ(files.approval_request_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS approval_request_date
					, DATE_FORMAT(CONVERT_TZ(files.revision_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS revision_date
					, DATE_FORMAT(CONVERT_TZ(files.approval_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS approval_date
					, users.family_name, users.name AS user_name, users.image_type AS user_image_type,
					CONCAT_WS(' ', users.family_name, users.name) AS user_full_name
				FROM #client_abb#_#fileTypeTable#_versions AS files
				INNER JOIN #client_abb#_users AS users ON files.user_in_charge = users.id
				WHERE version_id = <cfqueryparam value="#arguments.version_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

		<cfreturn getFileVersionsQuery>

	</cffunction>


	<!---getFileVersions--->

	<cffunction name="getFileVersions" output="false" returntype="query" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="limit" type="numeric" required="false">

		<cfargument name="parse_dates" type="boolean" required="false" default="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getFileVersions">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfquery name="getFileVersionsQuery" datasource="#client_dsn#">
				SELECT files.version_id, files.file_id, files.physical_name, files.user_in_charge, files.file_size, files.file_type, files.file_name, files.version_index, files.description, files.revision_request_user, files.revised, files.revision_result, files.revision_user, files.approved, files.approval_user, files.publication_user, files.publication_date, files.publication_file_id, files.publication_area_id
					, files.revision_result_reason, files.approval_result_reason
					<cfif arguments.parse_dates IS true>
						, DATE_FORMAT(CONVERT_TZ(files.uploading_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS uploading_date
						, DATE_FORMAT(CONVERT_TZ(files.revision_request_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS revision_request_date
						, DATE_FORMAT(CONVERT_TZ(files.approval_request_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS approval_request_date
						, DATE_FORMAT(CONVERT_TZ(files.revision_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS revision_date
						, DATE_FORMAT(CONVERT_TZ(files.approval_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS approval_date
					<cfelse>
						, uploading_date, revision_request_date, approval_request_date, revision_date, approval_date
					</cfif>
					, users.family_name, users.name AS user_name, users.image_type AS user_image_type,
					CONCAT_WS(' ', users.family_name, users.name) AS user_full_name
					, users_revision.image_type AS revision_user_image_type,
					CONCAT_WS(' ', users_revision.family_name, users_revision.name) AS revision_user_full_name
					, users_approval.image_type AS approval_user_image_type,
					CONCAT_WS(' ', users_approval.family_name, users_approval.name) AS approval_user_full_name
				FROM #client_abb#_#fileTypeTable#_versions AS files
				INNER JOIN #client_abb#_users AS users ON files.user_in_charge = users.id
				LEFT JOIN #client_abb#_users AS users_revision ON files.revision_user = users_revision.id
				LEFT JOIN #client_abb#_users AS users_approval ON files.approval_user = users_approval.id
				WHERE file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">
				ORDER BY files.version_id DESC
				<cfif isDefined("arguments.limit")>
				LIMIT #arguments.limit#
				</cfif>;
			</cfquery>

		<cfreturn getFileVersionsQuery>

	</cffunction>


	<!---isFileApproved--->

	<cffunction name="isFileApproved" output="false" returntype="boolean" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "isFileApproved">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfquery name="isFileApproved" datasource="#client_dsn#">
				SELECT versions.version_id
				FROM #client_abb#_#fileTypeTable#_versions AS versions
				WHERE versions.file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">
				AND versions.approved = true;
			</cfquery>

		<cfif isFileApproved.recordCount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>

	</cffunction>


	<!---getFileAreas--->

	<cffunction name="getFileAreas" output="false" returntype="query" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="with_names" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getFileAreas">

		<cfquery name="getFileAreasQuery" datasource="#client_dsn#">
			SELECT files.area_id<cfif arguments.with_names IS true>, areas.name, DATE_FORMAT(files.association_date, '#dateTimeFormat#') AS association_date</cfif>
			FROM #client_abb#_areas_files AS files
			<cfif arguments.with_names IS true>
				INNER JOIN #client_abb#_areas AS areas ON files.area_id = areas.id
				AND files.file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">
			<cfelse>
				WHERE files.file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">
			</cfif>;
		</cfquery>

		<cfreturn getFileAreasQuery>

	</cffunction>



	<!---getImage--->

	<cffunction name="getImage" output="false" returntype="query" access="public">
		<cfargument name="image_id" type="numeric" required="yes">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getImage">

		<cfquery name="selectImageQuery" datasource="#client_dsn#">
			SELECT images.*, file_size AS file_size_full
			FROM #client_abb#_areas_images AS images
			WHERE images.id = <cfqueryparam value="#arguments.image_id#" cfsqltype="cf_sql_integer">
			AND status = 'ok';
		</cfquery>

		<cfreturn selectImageQuery>

	</cffunction>


	<!---getFilesDownloads--->

	<cffunction name="getFilesDownloads" output="false" returntype="query" access="public">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">
		<cfargument name="from_date" type="string" required="false">
		<cfargument name="end_date" type="string" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getFilesDownloads">

		<cfquery name="getFilesDownloads" datasource="#client_dsn#">
			SELECT files.file_name, files.name, files.file_type, files.item_id, files.item_type_id, files.row_id, files.field_id, files_downloads.area_id, files_downloads.file_id, count(*) AS downloads
			<cfif arguments.parse_dates IS true>
				, DATE_FORMAT(CONVERT_TZ(files.uploading_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS uploading_date
				, DATE_FORMAT(CONVERT_TZ(files.replacement_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS replacement_date
			<cfelse>
				, files.uploading_date
				, files.replacement_date
			</cfif>
			FROM #client_abb#_files_downloads AS files_downloads
			INNER JOIN #client_abb#_files AS files
			ON files.id = files_downloads.file_id
			<cfif isDefined("arguments.from_date")>
				AND download_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateFormat#')
			</cfif>
			<cfif isDefined("arguments.end_date")>
				AND download_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateTimeFormat#')
			</cfif>
			GROUP BY file_id
			ORDER BY downloads DESC, download_date DESC;
		</cfquery>

		<cfreturn getFilesDownloads>

	</cffunction>


</cfcomponent>

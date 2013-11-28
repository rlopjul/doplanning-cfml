<!---Copyright Era7 Information Technologies 2007-2012

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
	
	
	<!---getFile--->
	
	<cffunction name="getFile" output="false" returntype="query" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="with_lock" type="boolean" required="false" default="false">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">
		<cfargument name="status" type="string" required="false" default="ok"><!--- ok --->

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
		
		<cfset var method = "getFile">
					

		<cfquery name="selectFileQuery" datasource="#client_dsn#">		
			SELECT files.id, files.id AS file_id, physical_name, user_in_charge, file_size, file_type, files.name, file_name, files.description, files.status, users.image_type AS user_image_type, files.typology_id, files.typology_row_id, files.file_type_id, files.locked, files.area_id
				, users.name AS user_name, users.family_name, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name
			<cfif isDefined("arguments.area_id")>
			, areas_files.association_date
			</cfif>
			<cfif arguments.with_lock IS true>
			, locks.user_id AS lock_user_id, locks.lock_user_full_name
			</cfif>
			<cfif arguments.parse_dates IS true>
				, DATE_FORMAT(files.uploading_date, '#dateTimeFormat#') AS uploading_date 
				, DATE_FORMAT(files.replacement_date, '#dateTimeFormat#') AS replacement_date
				<cfif arguments.with_lock IS true> 
				, DATE_FORMAT(locks.lock_date, '#dateTimeFormat#') AS lock_date
				</cfif>
			<cfelse>
				, files.uploading_date
				, files.replacement_date
				<cfif arguments.with_lock IS true> 
				, locks.lock_date, 
				</cfif>
			</cfif>
			FROM #client_abb#_files AS files
			INNER JOIN #client_abb#_users AS users 
			ON files.id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer"> AND files.user_in_charge = users.id
			AND status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
			<cfif arguments.with_lock IS true>
			LEFT JOIN (
				SELECT files_locks.file_id, files_locks.lock_date, files_locks.lock, files_locks.user_id,
				CONCAT_WS(' ', users_locks.family_name, users_locks.name) AS lock_user_full_name 
				FROM #client_abb#_files_locks AS files_locks
				INNER JOIN #client_abb#_users AS users_locks ON files_locks.file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer"> AND files_locks.user_id = users_locks.id
				ORDER BY lock_date DESC
				LIMIT 1
			) AS locks ON locks.file_id = files.id
			</cfif>
			<cfif isDefined("arguments.area_id")>
			LEFT JOIN #client_abb#_areas_files AS areas_files 
			ON files.id = areas_files.file_id
			WHERE areas_files.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer"> OR files.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer"> 
			</cfif>;
		</cfquery>	
			
		
		<cfreturn selectFileQuery>
		
	</cffunction>


	<!---getFileLocks--->
	
	<cffunction name="getFileLocks" output="false" returntype="query" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
		
		<cfset var method = "getFileLocks">
					
		<cfquery name="getFileLocksQuery" datasource="#client_dsn#">		
			SELECT files_locks.file_id, files_locks.user_id, files_locks.lock
			, DATE_FORMAT(files.date, '#dateTimeFormat#') AS date 
			, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name 
			FROM `#client_abb#_files_locks` AS files_locks
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
				<cfif arguments.with_typology IS false AND isDefined("arguments.typology_id")>
					AND files.typology_id = <cfqueryparam value="#arguments.typology_id#" cfsqltype="cf_sql_integer">
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
					OR files.replacement_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#dateTimeFormat#') )
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
  
</cfcomponent>
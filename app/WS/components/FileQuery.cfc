<!---Copyright Era7 Information Technologies 2007-2012

	Date of file creation: 16-05-2012
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 18-05-2012
	
--->
<cfcomponent output="false">

	<cfset component = "FileQuery">	
	
	
	<!---getFile--->
	
	<cffunction name="getFile" output="false" returntype="query" access="public">
		<cfargument name="file_id" type="numeric" required="yes">
		<cfargument name="area_id" type="numeric" required="no">
		
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">		
		
		<cfset var method = "getFile">
					
		
		<cfquery name="selectFileQuery" datasource="#client_dsn#">		
			SELECT physical_name, user_in_charge, file_size, file_type, files.name, file_name, uploading_date, replacement_date, files.description, files.status, users.family_name, files.id AS file_id, users.name AS user_name
			<cfif isDefined("arguments.area_id")>
			, areas_files.association_date
			</cfif>
			FROM #client_abb#_files AS files
			INNER JOIN #client_abb#_users AS users 
			ON files.id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer"> AND files.user_in_charge = users.id
			<cfif isDefined("arguments.area_id")>
			INNER JOIN #client_abb#_areas_files AS areas_files 
			ON areas_files.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer"> AND files.id = areas_files.file_id
			</cfif>
			AND status = 'ok';
		</cfquery>	
			
		
		<cfreturn selectFileQuery>
		
	</cffunction>
	
	
	
	<!---getAreaFiles--->
	
	<cffunction name="getAreaFiles" output="false" returntype="query" access="public">
		<cfargument name="area_id" type="numeric" required="no">
		<cfargument name="areas_ids" type="string" required="no">
		<cfargument name="limit" type="numeric" required="no">
		
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">		
		
		<cfset var method = "getAreaFiles">
					
		
		<cfquery name="areaFilesQuery" datasource="#client_dsn#">
			SELECT files.id, files.physical_name, files.user_in_charge, files.file_size, files.file_type, a.association_date, files.replacement_date, files.name, files.file_name, files.description, users.family_name, a.area_id, users.name AS user_name, IF(replacement_date IS NULL,association_date,replacement_date) AS last_version_date
			FROM #client_abb#_areas_files AS a
			INNER JOIN #client_abb#_files AS files ON a.file_id = files.id
			INNER JOIN #client_abb#_users AS users ON files.user_in_charge = users.id
			WHERE 
			<cfif isDefined("arguments.areas_ids")>
			a.area_id IN (<cfqueryparam value="#arguments.areas_ids#" cfsqltype="cf_sql_varchar" list="yes">)
			<cfelse>
			a.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
			</cfif>
			AND files.status = 'ok'
			ORDER BY last_version_date DESC
			<cfif isDefined("arguments.limit")>
			LIMIT #arguments.limit#
			</cfif>;
		</cfquery>
			
		
		<cfreturn areaFilesQuery>
		
	</cffunction>
	
	
	
  
</cfcomponent>
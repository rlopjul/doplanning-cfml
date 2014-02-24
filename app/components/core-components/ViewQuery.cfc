<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">

	<cfset component = "ViewQuery">

	<cfset dateTimeFormat = "%d-%m-%Y %H:%i:%s">
	<cfset timeZoneTo = "+1:00">


	<!---getView--->
		
	<cffunction name="getView" output="false" returntype="query" access="public">
		<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_type" type="boolean" required="false" default="false">
		<cfargument name="with_table" type="boolean" required="false" default="false">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">
		<cfargument name="published" type="boolean" required="false" default="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getView">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
			
			<cfquery name="getView" datasource="#client_dsn#">
				SELECT table_views.id, table_views.id AS view_id, table_views.user_in_charge, table_views.title, table_views.description, table_views.area_id, table_views.table_id,
				table_views.include_creation_date, table_views.include_last_update_date, table_views.include_insert_user, table_views.include_update_user, table_views.creation_date_position, table_views.last_update_date_position, table_views.insert_user_position, table_views.update_user_position, 
				users.name AS user_name, users.family_name, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name, users.image_type AS user_image_type
				<cfif arguments.parse_dates IS true>
				, DATE_FORMAT(CONVERT_TZ(table_views.creation_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS creation_date 
				, DATE_FORMAT(CONVERT_TZ(table_views.last_update_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS last_update_date 
				<cfelse>
					, table_views.creation_date, table_views.last_update_date
				</cfif>
				<cfif arguments.with_table IS true>
				, tables.area_id AS table_area_id, tables.title AS table_title
					<cfif APPLICATION.publicationScope IS true AND tableTypeId IS NOT 3>
					, tables.publication_scope_id AS table_publication_scope_id
					</cfif>
				</cfif>
				<cfif tableTypeId IS NOT 3>
					<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(CONVERT_TZ(table_views.publication_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS publication_date
					<cfelse>
					, table_views.publication_date
					</cfif>
					, table_views.publication_validated
				</cfif>
				FROM `#client_abb#_#tableTypeTable#_views` AS table_views
				INNER JOIN #client_abb#_users AS users ON table_views.user_in_charge = users.id
				<!--- <cfif arguments.with_table IS true> --->
					INNER JOIN `#client_abb#_#tableTypeTable#` AS tables ON table_views.table_id = tables.id
				<!--- </cfif> --->
				WHERE table_views.id = <cfqueryparam value="#arguments.view_id#" cfsqltype="cf_sql_integer">
				<cfif arguments.published IS true AND  tableTypeId IS NOT 3>
					AND ( tables.publication_date IS NULL OR tables.publication_date <= NOW() )
					AND ( table_views.publication_date IS NULL OR tables.publication_date <= NOW() )
					<cfif APPLICATION.publicationValidation IS true>
					AND ( tables.publication_validated IS NULL OR tables.publication_validated = true )
					AND ( table_views.publication_validated IS NULL OR table_views.publication_validated = true )
					</cfif>
				</cfif>;
			</cfquery>
		
		<cfreturn getView>
		
	</cffunction>


	<!---getTableViews--->
		
	<cffunction name="getTableViews" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_table" type="boolean" required="false" default="false">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getTableViews">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">		
							
			<cfquery name="getTableViewsQuery" datasource="#client_dsn#">
				SELECT table_views.id as view_id, table_views.title, table_views.area_id, areas.name AS area_name
				, users.name AS user_name, users.family_name, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name, users.image_type AS user_image_type
				<cfif arguments.parse_dates IS true>
				, DATE_FORMAT(CONVERT_TZ(table_views.creation_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS creation_date 
				, DATE_FORMAT(CONVERT_TZ(table_views.last_update_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS last_update_date 
				</cfif>
				<cfif arguments.with_table IS true>
				, tables.area_id, tables.general <!--- , tables.structure_available--->
				</cfif>
				FROM `#client_abb#_#tableTypeTable#_views` AS table_views
				INNER JOIN #client_abb#_users AS users ON table_views.user_in_charge = users.id
				INNER JOIN `#client_abb#_areas` AS areas ON table_views.area_id = areas.id
				<cfif arguments.with_table IS true>
					INNER JOIN `#client_abb#_#tableTypeTable#` AS tables ON table_views.table_id = tables.id
				</cfif>
				WHERE table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
				ORDER BY view_id DESC;
			</cfquery>
				
		<cfreturn getTableViewsQuery>
		
	</cffunction>

</cfcomponent>
<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "StatisticQuery">


	<!--- getGeneralStatistics --->

	<cffunction name="getGeneralStatistics" output="false" returntype="query" access="public">
		<cfargument name="from_date" type="string" required="false">
		<cfargument name="end_date" type="string" required="false">
		<cfargument name="from_user" type="numeric" required="false">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="include_subareas" type="boolean" required="false" default="false">


		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getGeneralStatistics">

		<cfset var areasIds = "">
		<cfset var allRelatedAreasIds = "">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
			</cfinvoke>

			<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

			<cfif isDefined("arguments.area_id")>

				<cfif arguments.include_subareas IS true>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreasIds" returnvariable="areasIds">
						<cfinvokeargument name="area_id" value="#arguments.area_id#">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>

				<cfset areasIds = ListAppend(areasIds, arguments.area_id)>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getParentAreasIds" returnvariable="allRelatedAreasIds">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="areas_list" value="#areasIds#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>

			<cfquery name="getGeneralStatistics" datasource="#client_dsn#">

				SELECT <cfloop array="#itemTypesArray#" index="curItemTypeId">#itemTypesStruct[curItemTypeId].table#.#itemTypesStruct[curItemTypeId].table#_count,</cfloop>
				users.users_count, areas.areas_count, users_login_success.users_login_success_count, users_login_failed.users_login_failed_count

				FROM

				<cfloop array="#itemTypesArray#" index="curItemTypeId">

					<cfif curItemTypeId IS 10>
						<cfset creation_date_field = "uploading_date">
					<cfelse>
						<cfset creation_date_field = "creation_date">
					</cfif>

					(
						SELECT count(*) AS #itemTypesStruct[curItemTypeId].table#_count
						FROM #client_abb#_#itemTypesStruct[curItemTypeId].table#
						WHERE 1=1
						<cfif isDefined("arguments.from_user")>
							AND user_in_charge = <cfqueryparam value="#arguments.from_user#" cfsqltype="cf_sql_integer">
						</cfif>
						<cfif isDefined("arguments.from_date")>
							AND	#creation_date_field# >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateFormat#')
						</cfif>
						<cfif isDefined("arguments.end_date")>
							AND	#creation_date_field# <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateTimeFormat#')
						</cfif>
						<cfif isDefined("arguments.area_id")>
							AND area_id IN (<cfqueryparam value="#areasIds#" list="true" cfsqltype="cf_sql_integer">)
						</cfif>
					) AS #itemTypesStruct[curItemTypeId].table#,
				</cfloop>

				(
					SELECT count(DISTINCT id) AS users_count
					FROM #client_abb#_users AS all_users
					<cfif isDefined("arguments.area_id")>
						INNER JOIN #client_abb#_areas_users AS areas_users
						ON all_users.id = areas_users.user_id
						AND areas_users.area_id IN (<cfqueryparam value="#allRelatedAreasIds#" list="true" cfsqltype="cf_sql_integer">)
					</cfif>
					WHERE 1=1
					<cfif isDefined("arguments.from_user")>
						AND id = <cfqueryparam value="#arguments.from_user#" cfsqltype="cf_sql_integer">
					</cfif>
					<cfif isDefined("arguments.from_date")>
						AND creation_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateFormat#')
					</cfif>
					<cfif isDefined("arguments.end_date")>
						AND	creation_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateTimeFormat#')
					</cfif>
				) AS users,


				(
					SELECT count(*) AS areas_count
					FROM #client_abb#_areas
					WHERE 1=1
					<cfif isDefined("arguments.from_user")>
						AND user_in_charge = <cfqueryparam value="#arguments.from_user#" cfsqltype="cf_sql_integer">
					</cfif>
					<cfif isDefined("arguments.from_date")>
						AND creation_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateFormat#')
					</cfif>
					<cfif isDefined("arguments.end_date")>
						AND	creation_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateTimeFormat#')
					</cfif>
					<cfif isDefined("arguments.area_id")>
						AND id IN (<cfqueryparam value="#areasIds#" list="true" cfsqltype="cf_sql_integer">)
					</cfif>
				) AS areas,


				(
					SELECT count(*) AS users_login_success_count
					FROM #client_abb#_logs
					WHERE method = 'loginUserInApplication'
					<cfif isDefined("arguments.from_user")>
						AND user_id = <cfqueryparam value="#arguments.from_user#" cfsqltype="cf_sql_integer">
					</cfif>
					<cfif isDefined("arguments.from_date")>
						AND time >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateFormat#')
					</cfif>
					<cfif isDefined("arguments.end_date")>
						AND time <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateTimeFormat#')
					</cfif>
				) AS users_login_success,

				(
					SELECT count(*) AS users_login_failed_count
					FROM #client_abb#_logs
					WHERE method = 'loginUser'
					<cfif isDefined("arguments.from_date")>
						AND time >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateFormat#')
					</cfif>
					<cfif isDefined("arguments.end_date")>
						AND time <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateTimeFormat#')
					</cfif>
				) AS users_login_failed

				;

			</cfquery>

		<cfreturn getGeneralStatistics>

	</cffunction>

</cfcomponent>

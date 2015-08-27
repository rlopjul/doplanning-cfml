<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "StatisticQuery">	


	<!--- getCategories --->

	<cffunction name="getCategories" output="false" returntype="query" access="public">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getCategories">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
			</cfinvoke>

			<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

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
						<cfif isDefined("arguments.from_date")>
						WHERE
						#creation_date_field# >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateFormat#')
						</cfif>
						<cfif isDefined("arguments.end_date")>
							<cfif NOT isDefined("arguments.from_date")>
								WHERE
							<cfelse>
								AND
							</cfif>
						#creation_date_field# <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateTimeFormat#')
						</cfif>
					) AS #itemTypesStruct[curItemTypeId].table#,
				</cfloop>

				( 
					SELECT count(*) AS users_count
					FROM #client_abb#_users
					<cfif isDefined("arguments.from_date")>
					WHERE
					creation_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateFormat#')
					</cfif>
					<cfif isDefined("arguments.end_date")>
						<cfif NOT isDefined("arguments.from_date")>
							WHERE
						<cfelse>
							AND
						</cfif>
					creation_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateTimeFormat#')
					</cfif>
				) AS users,


				(	
					SELECT count(*) AS areas_count
					FROM #client_abb#_areas
					<cfif isDefined("arguments.from_date")>
					WHERE
					creation_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateFormat#')
					</cfif>
					<cfif isDefined("arguments.end_date")>
						<cfif NOT isDefined("arguments.from_date")>
							WHERE
						<cfelse>
							AND
						</cfif>
					creation_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateTimeFormat#')
					</cfif>
				) AS areas,


				( 
					SELECT count(*) AS users_login_success_count 
					FROM #client_abb#_logs
					WHERE method = 'loginUserInApplication'
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
<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "StatisticManager">


	<!--- ----------------- GET GENERAL STATISTICS --------------------------------------------   --->

	<cffunction name="getGeneralStatistics" output="false" returntype="struct" access="public">
		<cfargument name="from_date" type="string" required="false">
		<cfargument name="end_date" type="string" required="false">

		<cfset var method = "getGeneralStatistics">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="includes/checkAdminAccess.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/StatisticQuery" method="getGeneralStatistics" returnvariable="statisticsQuery">
				<cfif isDefined("arguments.from_date")>
					<cfinvokeargument name="from_date" value="#from_date#"/>
				</cfif>
				<cfif isDefined("arguments.end_date")>
					<cfinvokeargument name="end_date" value="#end_date#"/>
				</cfif>
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#"/>
				<cfinvokeargument name="client_dsn" value="#client_dsn#"/>
			</cfinvoke>

			<cfset response = {result=true, query=#statisticsQuery#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!--- ------------------------------------------------------------------------------  --->


	<!--- ----------------------- GET TOTAL ITEMS BY USERS -------------------------------- --->

	<cffunction name="getTotalItemsByUser" output="false" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="include_subareas" type="boolean" required="false" default="false">
		<cfargument name="area_type" type="string" requierd="true">

		<cfset var method = "getTotalItemsByUser">

		<cfset var response = structNew()>
		<cfset var itemsByType = arrayNew(1)>
		<!---<cfset var itemsType = arrayNew(1)>--->
		<cfset var subAreasIds = "">
		<cfset var areasIds = "">

		<!---
		commented for development
		<cftry>--->

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfif arguments.include_subareas IS true>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreasIds" returnvariable="subAreasIds">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfset areasIds = ListAppend(subAreasIds, arguments.area_id)>

			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="listAllAreaItems" returnvariable="getAreaItemsResult">
				<cfif arguments.include_subareas IS true>
					<cfinvokeargument name="areas_ids" value="#areasIds#">
				<cfelse>
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfif>
				<cfinvokeargument name="area_type" value="#arguments.area_type#">

				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="withConsultations" value="#APPLICATION.moduleConsultations#">
				<cfinvokeargument name="withPubmedsComments" value="#APPLICATION.modulePubMedComments#">
				<cfinvokeargument name="withLists" value="#APPLICATION.moduleLists#">
				<cfinvokeargument name="withForms" value="#APPLICATION.moduleForms#">
				<cfinvokeargument name="withDPDocuments" value="#APPLICATION.moduleDPDocuments#">
				<cfinvokeargument name="withMailings" value="#APPLICATION.moduleMailing#">

				<cfinvokeargument name="full_content" value="false">
				<cfinvokeargument name="with_position" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset totalItemsQuery = getAreaItemsResult.query>

			<!--- getAreaItemTypesStruct --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
			</cfinvoke>

			<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

			<!--- Loop items types --->
			<cfloop array="#itemTypesArray#" index="itemTypeId">

				<cfif listFind("13,16", itemTypeId) IS 0><!---Typologies are not included--->

					<cfset itemTypeLabel = itemTypesStruct[itemTypeId].label>

					<!--- <cfset itemTypeName = itemTypesStruct[itemTypeId].name>
					<cfset itemTypeGender = itemTypesStruct[itemTypeId].gender>

					<cfset ArrayAppend(itemsType, {id=itemTypeId, name=itemTypeName, gender=itemTypeGender, label=itemTypeLabel})> --->

					<cfquery dbtype="query" name="itemsQuery">
						SELECT user_in_charge AS user_id, user_full_name, count(*) AS total
						FROM totalItemsQuery
						WHERE itemTypeId = <cfqueryparam value="#itemTypeId#" cfsqltype="cf_sql_integer">
						GROUP BY user_in_charge, user_full_name;
					</cfquery>

					<cfif itemsQuery.recordCount GT 0>

						<cfloop query="#itemsQuery#">
							<cfset itemTypeStruct = structNew()>
							<cfset itemTypeStruct.item_type_id = itemTypeId>
							<cfset itemTypeStruct.item_type_label = itemTypeLabel>
							<cfset itemTypeStruct.user_id = itemsQuery.user_id>
							<cfset itemTypeStruct.user_full_name = itemsQuery.user_full_name>
							<cfset itemTypeStruct.total = itemsQuery.total>

							<cfset ArrayAppend(itemsByType, itemTypeStruct)>
						</cfloop>

					<cfelse><!--- NO results --->

						<cfset itemTypeStruct = structNew()>
						<cfset itemTypeStruct.item_type_id = itemTypeId>
						<cfset itemTypeStruct.user_id = "">
						<cfset itemTypeStruct.user_full_name = "">
						<cfset itemTypeStruct.total = 0>

						<cfset ArrayAppend(itemsByType, itemTypeStruct)>

					</cfif>

				</cfif>

			</cfloop>

			<cfset response = {result=true, totalItems=#itemsByType#}>

			<!---
			commented for development
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>--->

		<cfreturn response>

	</cffunction>
	<!--- ------------------------------------------------------------------------------  --->



	<!--- ----------------------- GET ALL ITEMS -------------------------------- --->

	<cffunction name="getAllItems" output="false" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="include_subareas" type="boolean" required="false" default="false">
		<cfargument name="area_type" type="string" requierd="true">
		<cfargument name="parse_dates" type="boolean" required="false" default="true">

		<cfset var method = "getAllItems">

		<cfset var response = structNew()>
		<cfset var totalItems = arrayNew(1)>
		<cfset var itemsType = arrayNew(1)>
		<cfset var subAreasIds = "">
		<cfset var areasIds = "">

		<!---
		commented for development
		<cftry>--->

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfif arguments.include_subareas IS true>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreasIds" returnvariable="subAreasIds">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfset areasIds = ListAppend(subAreasIds, arguments.area_id)>

			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="listAllAreaItems" returnvariable="getAreaItemsResult">
				<cfif arguments.include_subareas IS true>
					<cfinvokeargument name="areas_ids" value="#areasIds#">
				<cfelse>
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfif>
				<cfinvokeargument name="area_type" value="#arguments.area_type#">

				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="withConsultations" value="#APPLICATION.moduleConsultations#">
				<cfinvokeargument name="withPubmedsComments" value="#APPLICATION.modulePubMedComments#">
				<cfinvokeargument name="withLists" value="#APPLICATION.moduleLists#">
				<cfinvokeargument name="withForms" value="#APPLICATION.moduleForms#">
				<cfinvokeargument name="withDPDocuments" value="#APPLICATION.moduleDPDocuments#">
				<cfinvokeargument name="withMailings" value="#APPLICATION.moduleMailing#">

				<cfinvokeargument name="full_content" value="false">
				<cfinvokeargument name="with_position" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset totalItemsQuery = getAreaItemsResult.query>

			<!--- getAreaItemTypesStruct --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
			</cfinvoke>

			<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

			<cfloop query="#totalItemsQuery#">

				<cfset itemTypeStruct = structNew()>
				<cfset itemTypeStruct.item_type_id = totalItemsQuery.itemTypeId>
				<cfset itemTypeStruct.item_type_label = itemTypesStruct[totalItemsQuery.itemTypeId].label>
				<cfif arguments.parse_dates IS true>
					<cfset itemTypeStruct.creation_date = dateFormat(totalItemsQuery.creation_date, APPLICATION.dateFormat)&" "&timeFormat(totalItemsQuery.creation_date, "HH:mm:ss")>
				<cfelse>
					<cfset itemTypeStruct.creation_date = totalItemsQuery.creation_date>
				</cfif>
 				<cfset itemTypeStruct.user_id = totalItemsQuery.user_in_charge>
				<cfset itemTypeStruct.user_full_name = totalItemsQuery.user_full_name>

				<cfset ArrayAppend(totalItems, itemTypeStruct)>

			</cfloop>

			<!--- Loop items types --->
			<cfloop array="#itemTypesArray#" index="itemTypeId">

				<cfset itemTypeName = itemTypesStruct[itemTypeId].name>
				<cfset itemTypeGender = itemTypesStruct[itemTypeId].gender>
				<cfset itemTypeLabel = itemTypesStruct[itemTypeId].label>

				<cfset ArrayAppend(itemsType, {id=itemTypeId, name=itemTypeName, gender=itemTypeGender, label=itemTypeLabel})>

			</cfloop>

			<cfset response = {result=true, totalItems=#totalItems#, itemsTypes=#itemsType#}>

			<!---
			commented for development
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>--->

		<cfreturn response>

	</cffunction>
	<!--- ------------------------------------------------------------------------------  --->


	<!--- ----------------------- GET TOTAL ITEMS BY DATE -------------------------------- --->

	<cffunction name="getTotalItemsByDay" output="false" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="include_subareas" type="boolean" required="false" default="false">
		<cfargument name="area_type" type="string" requierd="true">
		<cfargument name="parse_dates" type="boolean" required="false" default="true">

		<cfset var method = "getTotalItemsByDay">

		<cfset var response = structNew()>
		<cfset var totalItems = arrayNew(1)>
		<cfset var itemsType = arrayNew(1)>
		<cfset var subAreasIds = "">
		<cfset var areasIds = "">

		<!---
		commented for development
		<cftry>--->

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfif arguments.include_subareas IS true>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreasIds" returnvariable="subAreasIds">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfset areasIds = ListAppend(subAreasIds, arguments.area_id)>

			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="listAllAreaItems" returnvariable="getAreaItemsResult">
				<cfif arguments.include_subareas IS true>
					<cfinvokeargument name="areas_ids" value="#areasIds#">
				<cfelse>
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfif>
				<cfinvokeargument name="area_type" value="#arguments.area_type#">

				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="withConsultations" value="#APPLICATION.moduleConsultations#">
				<cfinvokeargument name="withPubmedsComments" value="#APPLICATION.modulePubMedComments#">
				<cfinvokeargument name="withLists" value="#APPLICATION.moduleLists#">
				<cfinvokeargument name="withForms" value="#APPLICATION.moduleForms#">
				<cfinvokeargument name="withDPDocuments" value="#APPLICATION.moduleDPDocuments#">
				<cfinvokeargument name="withMailings" value="#APPLICATION.moduleMailing#">

				<cfinvokeargument name="full_content" value="false">
				<cfinvokeargument name="with_position" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset totalItemsQuery = getAreaItemsResult.query>

			<!--- getAreaItemTypesStruct --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
			</cfinvoke>

			<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

			<cfset endDate = totalItemsQuery.creation_date[1]>
			<cfset startDate = totalItemsQuery.creation_date[totalItemsQuery.recordCount]>

			<!---<cfset startDate = dateAdd("d", -10, now())>
			<cfset endDate = now()>--->

			<cfset endDate =  dateAdd("d", 1, createDate(year(endDate), month(endDate), day(endDate)))>
			<cfset startDate = createDate(year(startDate), month(startDate), day(startDate))>

			<cfloop from="#startDate#" to="#endDate#" index="day" step="#CreateTimeSpan(1,0,0,0)#">

				<cfset dayEnd = dateAdd("d", 1, day)>
				<cfset dayEnd = dateAdd("s", -1, dayEnd)>

				<cfquery dbtype="query" name="dayItemsQuery">
					SELECT *
					FROM totalItemsQuery
					WHERE creation_date >= <cfqueryparam value="#day#" cfsqltype="cf_sql_timestamp">
					AND creation_date <= <cfqueryparam value="#dayEnd#" cfsqltype="cf_sql_timestamp">;
				</cfquery>

				<cfif dayItemsQuery.recordCount GT 0>

					<cfset dayItemsTypesIds = ValueList(dayItemsQuery.itemTypeId)>

					<cfset dayItemsTypesIds = ListRemoveDuplicates(dayItemsTypesIds)>

					<!--- Loop items types --->
					<cfloop list="#dayItemsTypesIds#" index="itemTypeId">

						<cfif listFind("13", itemTypeId) IS 0 AND listFind("16", itemTypeId) IS 0><!---Typologies are not included--->

							<cfset itemTypeLabel = itemTypesStruct[itemTypeId].label>

							<cfquery dbtype="query" name="dayTypeItemsQuery">
								SELECT user_in_charge AS user_id, user_full_name, count(*) AS total
								FROM dayItemsQuery
								WHERE itemTypeId = <cfqueryparam value="#itemTypeId#" cfsqltype="cf_sql_integer">
								GROUP BY user_in_charge, user_full_name;
							</cfquery>

							<cfif dayTypeItemsQuery.recordCount GT 0>

								<cfloop query="#dayTypeItemsQuery#">
									<cfset itemTypeStruct = structNew()>
									<cfset itemTypeStruct.item_type_id = itemTypeId>
									<cfset itemTypeStruct.item_type_label = itemTypeLabel>
									<cfset itemTypeStruct.user_id = dayTypeItemsQuery.user_id>
									<cfset itemTypeStruct.user_full_name = dayTypeItemsQuery.user_full_name>
									<cfset itemTypeStruct.total = dayTypeItemsQuery.total>
									<cfif arguments.parse_dates IS true>
										<cfset itemTypeStruct.creation_date = dateFormat(day, APPLICATION.dateFormat)>
									<cfelse>
										<cfset itemTypeStruct.creation_date = day>
									</cfif>

									<cfset ArrayAppend(totalItems, itemTypeStruct)>
								</cfloop>

							<cfelse><!--- NO results --->

								<!----<cfset itemTypeStruct = structNew()>
								<cfset itemTypeStruct.item_type_id = itemTypeId>
								<cfset itemTypeStruct.user_id = "">
								<cfset itemTypeStruct.user_full_name = "">
								<cfset itemTypeStruct.total = 0>
								<cfset itemTypeStruct.creation_date = day>

								<cfset ArrayAppend(totalItems, itemTypeStruct)>--->

							</cfif>

						</cfif>

					</cfloop>

				</cfif>


			</cfloop>

			<cfset response = {result=true, totalItems=#totalItems#, startDate=#startDate#, endDate=#endDate#}>

			<!---
			commented for development
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>--->

		<cfreturn response>

	</cffunction>
	<!--- ------------------------------------------------------------------------------  --->


</cfcomponent>

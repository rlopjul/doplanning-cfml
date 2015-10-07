<!---Copyright Era7 Information Technologies 2007-2014--->

<cfcomponent output="false">

	<cfset component = "UserManager">

	<cfinclude template="#APPLICATION.componentsPath#/includes/functions.cfm">


	<!--- -------------------------- isRootUser -------------------------------- --->
	<!---Obtiene si el usuario está en la raiz de la organización o no--->

	<cffunction name="isRootUser" returntype="boolean" access="public">
 		<cfargument name="get_user_id" type="numeric" required="yes">
 		<cfargument name="root_area_id" type="numeric" required="false">

 		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "isInternalUser">

		<cfset var root_area_id = "">

		<!--- <cfinvoke component="AreaManager" method="getRootAreaId" returnvariable="root_area_id">
		</cfinvoke> --->

		<cfif NOT isDefined("arguments.root_area_id")>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getRootArea" returnvariable="rootAreaQuery">
				<cfinvokeargument name="onlyId" value="true">
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfset root_area_id = rootAreaQuery.id>

		<cfelse>

			<cfset root_area_id = arguments.root_area_id>

		</cfif>

		<cfquery name="isRootUserQuery" datasource="#client_dsn#">
			SELECT user_id
			FROM #client_abb#_areas_users
			WHERE user_id = <cfqueryparam value="#arguments.get_user_id#" cfsqltype="cf_sql_integer">
			AND area_id = <cfqueryparam value="#root_area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>

		<cfif isRootUserQuery.recordCount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>

	</cffunction>


	<!--- ---------------------------- GET USERS TO NOTIFY LISTS ------------------------------- --->

	<cffunction name="getUsersToNotifyLists" returntype="struct" output="false" access="public">
		<!---<cfargument name="request" type="string" required="yes">--->
		<cfargument name="area_id" type="numeric" required="true">

		<cfargument name="itemTypeId" type="numeric" required="false">
		<cfargument name="categories_ids" type="string" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getUsersToNotifyLists">

		<cfset var internalUsersEmails = structNew()>
		<cfset var externalUsersEmails = structNew()>

		<cfset var internalUsersPhones = structNew()>
		<cfset var externalUsersPhones = structNew()>

        <cfset var structResponse = structNew()>

        <cfinvoke component="UserManager" method="getUsersToNotify" argumentcollection="#arguments#" returnvariable="arrayUsersToNotify">
			<!---<cfinvokeargument name="request" value="#arguments.request#"/>--->
		</cfinvoke>

		<cfloop list="#APPLICATION.languages#" index="curLang">

			<cfset internalUsersEmails[curLang] = "">
			<cfset externalUsersEmails[curLang] = "">

			<cfset internalUsersPhones[curLang] = "">
			<cfset externalUsersPhones[curLang] = "">

		</cfloop>

		<cfloop index="curUser" array="#arrayUsersToNotify#">

			<cfset curr_val = curUser.email>

			<cfset curr_phone = curUser.mobile_phone>
			<cfset curr_phone_ccode = curUser.mobile_phone_ccode>

			<cfif curUser.whole_tree_visible IS true>
				<!---<cfset listInternalUsers = ListAppend(listInternalUsers,curr_val,";")>--->
				<cfset internalUsersEmails[curUser.language] = ListAppend(internalUsersEmails[curUser.language],curr_val,";")>
				<cfif len(curr_phone) GT 0>
					<cfif APPLICATION.identifier EQ "dp">
						<cfset internalUsersPhones[curUser.language] = ListAppend(internalUsersPhones[curUser.language],curr_phone_ccode&curr_phone,";")>
					<cfelse><!---vpnet--->
						<cfset internalUsersPhones[curUser.language]  = ListAppend(internalUsersPhones[curUser.language],curr_phone,";")>
					</cfif>
				</cfif>
			<cfelse>
				<!---<cfset listExternalUsers = ListAppend(listExternalUsers,curr_val,";")>--->
				<cfset externalUsersEmails[curUser.language] = ListAppend(externalUsersEmails[curUser.language],curr_val,";")>
				<cfif len(curr_phone) GT 0>
					<cfif APPLICATION.identifier EQ "dp">
						<cfset externalUsersPhones[curUser.language] = ListAppend(externalUsersPhones[curUser.language],curr_phone_ccode&curr_phone,";")>
					<cfelse><!---vpnet--->
						<cfset externalUsersPhones[curUser.language] = ListAppend(externalUsersPhones[curUser.language],curr_phone,";")>
					</cfif>
				</cfif>
			</cfif>

		</cfloop>


        <cfset structResponse.structInternalUsersEmails = internalUsersEmails>
        <cfset structResponse.structExternalUsersEmails = externalUsersEmails>

		<cfset structResponse.structInternalUsersPhones = internalUsersPhones>
		<cfset structResponse.structExternalUsersPhones = externalUsersPhones>

		<cfreturn structResponse>

	</cffunction>



	<!--- ---------------------------- GET USERS TO NOTIFY  ------------------------------- --->

	<cffunction name="getUsersToNotify" returntype="array" output="false" access="public">
		<!---<cfargument name="request" type="string" required="yes">--->
		<cfargument name="area_id" type="numeric" required="true">

		<cfargument name="itemTypeId" type="numeric" required="false">
		<cfargument name="categories_ids" type="string" required="false">

		<cfargument name="notify_new_message" type="string" required="no" default="">
		<cfargument name="notify_new_file" type="string" required="no" default="">
		<cfargument name="notify_replace_file" type="string" required="no" default="">
		<cfargument name="notify_new_area" type="string" required="no" default="">

		<cfargument name="notify_new_entry" type="string" required="no" default="">
		<cfargument name="notify_new_link" type="string" required="no" default="">
		<cfargument name="notify_new_news" type="string" required="no" default="">
		<cfargument name="notify_new_event" type="string" required="no" default="">
		<cfargument name="notify_new_task" type="string" required="no" default="">
		<cfargument name="notify_new_consultation" type="string" required="no" default="">

		<cfargument name="notify_new_image" type="string" required="false" default="">
		<cfargument name="notify_new_typology" type="string" required="false" default="">
		<cfargument name="notify_new_list" type="string" required="false" default="">
		<cfargument name="notify_new_list_row" type="string" required="false" default="">
		<cfargument name="notify_new_list_view" type="string" required="false" default="">
		<cfargument name="notify_new_form" type="string" required="false" default="">
		<cfargument name="notify_new_form_row" type="string" required="false" default="">
		<cfargument name="notify_new_form_view" type="string" required="false" default="">
		<cfargument name="notify_new_pubmed" type="string" required="false" default="">
		<cfargument name="notify_new_dp_document" type="string" required="false" default="">
		<cfargument name="notify_new_mailing" type="string" required="false" default="">

		<cfargument name="notify_delete_file" type="string" required="false" default="">
		<cfargument name="notify_lock_file" type="string" required="false" default="">

		<cfargument name="notify_new_user_in_area" type="string" required="false" default="">

		<cfargument name="no_notifications" type="string" required="false" default="">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getUsersToNotify">

		<!---<cfset var xmlUser = "">
		<cfset var init_area_id = "">--->

		<cfset var usersArray = ArrayNew(1)>
		<cfset var areasArray = ArrayNew(1)>

		<!---PREFERENCES--->
		<!---<cfset var notify_new_message = "">
		<cfset var notify_new_file = "">
		<cfset var notify_replace_file = "">
		<cfset var notify_new_area = "">

		<cfset var notify_new_entry = "">
		<cfset var notify_new_link = "">
		<cfset var notify_new_news = "">
		<cfset var notify_new_event = "">
		<cfset var notify_new_task = "">
		<cfset var notify_new_consultation = "">

		<cfset var notify_new_image = "">
		<cfset var notify_new_typology = "">
		<cfset var notify_new_list = "">
		<cfset var notify_new_list_row = "">
		<cfset var notify_new_list_view = "">
		<cfset var notify_new_form = "">
		<cfset var notify_new_form_row = "">
		<cfset var notify_new_form_view = "">
		<cfset var notify_new_pubmed = "">

		<cfset var notify_delete_file = "">
		<cfset var notify_lock_file = "">

		<cfset var notify_new_user_in_area = "">--->


			<!---<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="xmlRequest" returnvariable="xmlRequest">
				<cfinvokeargument name="request" value="#arguments.request#">
			</cfinvoke>

			<cfxml variable="xmlUser">
				<cfoutput>
					#xmlRequest.request.parameters.user#
				</cfoutput>
			</cfxml>

			<cfset init_area_id = xmlRequest.request.parameters.area.xmlAttributes.id>--->


			<!--- ORDER --->
			<cfinclude template="#APPLICATION.componentsPath#/includes/usersOrder.cfm">


			<!--- getClient --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="selectClientQuery">
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			</cfinvoke>

			<cfif selectClientQuery.recordCount IS 0><!---The client does not exist--->

				<cfset error_code = 301>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<!---
			MUY IMPORTANTE: aquí no se puede usar la sesion

			<cfif ( (isDefined("SESSION.client_force_notifications") AND SESSION.client_force_notifications IS false) OR NOT isDefined("SESSION.client_force_notifications") ) AND isDefined("xmlRequest.request.parameters.preferences")>

		--->

			<cfinvoke component="UserManager" method="getAreaUsers" returnvariable="returnArrays">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="areasArray" value="#areasArray#">
				<cfinvokeargument name="include_user_log_in" value="true">
				<cfinvokeargument name="get_orientation" value="asc">

				<cfif selectClientQuery.force_notifications IS false>

					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="categories_ids" value="#arguments.categories_ids#">

					<cfinvokeargument name="notify_new_message" value="#arguments.notify_new_message#">
					<cfinvokeargument name="notify_new_file" value="#arguments.notify_new_file#">
					<cfinvokeargument name="notify_replace_file" value="#arguments.notify_replace_file#">
					<cfinvokeargument name="notify_new_area" value="#arguments.notify_new_area#">

					<cfinvokeargument name="notify_new_entry" value="#arguments.notify_new_entry#">
					<cfinvokeargument name="notify_new_link" value="#arguments.notify_new_link#">
					<cfinvokeargument name="notify_new_news" value="#arguments.notify_new_news#">
					<cfinvokeargument name="notify_new_event" value="#arguments.notify_new_event#">
					<cfinvokeargument name="notify_new_task" value="#arguments.notify_new_task#">
					<cfinvokeargument name="notify_new_consultation" value="#notify_new_consultation#">

					<cfinvokeargument name="notify_new_image" value="#arguments.notify_new_image#">
					<cfinvokeargument name="notify_new_typology" value="#arguments.notify_new_typology#">
					<cfinvokeargument name="notify_new_list" value="#arguments.notify_new_list#">
					<cfinvokeargument name="notify_new_list_row" value="#arguments.notify_new_list_row#">
					<cfinvokeargument name="notify_new_list_view" value="#arguments.notify_new_list_view#">
					<cfinvokeargument name="notify_new_form" value="#arguments.notify_new_form#">
					<cfinvokeargument name="notify_new_form_row" value="#arguments.notify_new_form_row#">
					<cfinvokeargument name="notify_new_form_view" value="#arguments.notify_new_form_view#">
					<cfinvokeargument name="notify_new_pubmed" value="#arguments.notify_new_pubmed#">
					<cfinvokeargument name="notify_new_dp_document" value="#arguments.notify_new_dp_document#">
					<cfinvokeargument name="notify_new_mailing" value="#arguments.notify_new_mailing#">

					<cfinvokeargument name="notify_delete_file" value="#arguments.notify_delete_file#">
					<cfinvokeargument name="notify_lock_file" value="#arguments.notify_lock_file#">

					<cfinvokeargument name="notify_new_user_in_area" value="#arguments.notify_new_user_in_area#">

					<cfinvokeargument name="no_notifications" value="false">

				</cfif>

				<cfinvokeargument name="enabled" value="true">
				<cfinvokeargument name="emailDefined" value="true">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfset usersArray = returnArrays.usersArray>

			<cfif arrayLen(usersArray) GT 0>

				<cfset usersArray = arrayOfStructsSort(usersArray, "#order_by#", "#order_type#", "textnocase")>

			</cfif>

		<cfreturn usersArray>


	</cffunction>


	<!--- PROVISIONAL

		Esto hay que quitarlo cuando se actualice a Lucee, ya que Lucee incluye una función para esto
--->

	<cfscript>
	    function GetQueryRow(query, rowNumber) {
	        var i = 0;
	        var rowData = StructNew();
	        var cols    = ListToArray(query.columnList);
	        for (i = 1; i lte ArrayLen(cols); i = i + 1) {
	            rowData[cols[i]] = query[cols[i]][rowNumber];
	        }
	        return rowData;
	    }
	</cfscript>

	<!---
	http://www.neiland.net/blog/article/converting-a-query-row-into-a-structure/

	<cfloop list="#arguments.queryObj.columnList#" index="colname">
      <cfset "returnStruct.#colname#" = arguments.queryObj[colname][arguments.row]>
    </cfloop>

    ---->


	<!--- ---------------------------- getAreaUsers ------------------------------- --->

	<!--- Hay un método en AreaQuery que se llama igual que este, pero este es más avanzado --->

	<cffunction name="getAreaUsers" returntype="struct" output="false" access="public">
		<cfargument name="area_id" type="string" required="yes">
		<cfargument name="areasArray" type="array" required="yes">
		<cfargument name="include_user_log_in" type="boolean" required="no" default="false">
		<cfargument name="get_orientation" type="string" required="no" default="desc">

		<cfargument name="itemTypeId" type="numeric" required="false">
		<cfargument name="categories_ids" type="string" required="false">

		<cfargument name="notify_new_message" type="string" required="no" default="">
		<cfargument name="notify_new_file" type="string" required="no" default="">
		<cfargument name="notify_replace_file" type="string" required="no" default="">
		<cfargument name="notify_new_area" type="string" required="no" default="">

		<cfargument name="notify_new_entry" type="string" required="no" default="">
		<cfargument name="notify_new_link" type="string" required="no" default="">
		<cfargument name="notify_new_news" type="string" required="no" default="">
		<cfargument name="notify_new_event" type="string" required="no" default="">
		<cfargument name="notify_new_task" type="string" required="no" default="">
		<cfargument name="notify_new_consultation" type="string" required="no" default="">

		<cfargument name="notify_new_image" type="string" required="false" default="">
		<cfargument name="notify_new_typology" type="string" required="false" default="">
		<cfargument name="notify_new_list" type="string" required="false" default="">
		<cfargument name="notify_new_list_row" type="string" required="false" default="">
		<cfargument name="notify_new_list_view" type="string" required="false" default="">
		<cfargument name="notify_new_form" type="string" required="false" default="">
		<cfargument name="notify_new_form_row" type="string" required="false" default="">
		<cfargument name="notify_new_form_view" type="string" required="false" default="">
		<cfargument name="notify_new_pubmed" type="string" required="false" default="">
		<cfargument name="notify_new_dp_document" type="string" required="false" default="">
		<cfargument name="notify_new_mailing" type="string" required="false" default="">

		<cfargument name="notify_delete_file" type="string" required="false" default="">
		<cfargument name="notify_lock_file" type="string" required="false" default="">

		<cfargument name="notify_new_user_in_area" type="string" required="false" default="">

		<cfargument name="no_notifications" type="string" required="false" default="">

		<cfargument name="with_external" type="string" required="false" default="true">
		<cfargument name="enabled" type="boolean" required="false">
		<cfargument name="emailDefined" type="boolean" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getAreaUsers">

		<cfset var usersArray = arrayNew(1)>

			<cfinvoke component="UserManager" method="getAreaUsersIds" returnvariable="usersIdsResult">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="areasArray" value="#arguments.areasArray#">

				<cfinvokeargument name="get_orientation" value="#arguments.get_orientation#">

				<cfinvokeargument name="userType" value="users">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfset usersList = usersIdsResult.usersList>
			<cfset areasArray = usersIdsResult.areasArray>
			<cfset areaMembersList = usersIdsResult.areaMembersList>

			<cfif listLen(usersList) GT 0>

				<cfquery name="areaUsersQuery" datasource="#client_dsn#">
					SELECT id, email, telephone, space_used, number_of_connections, last_connection, connected, session_id, creation_date, internal_user, root_folder_id, family_name, name, address, mobile_phone, telephone_ccode, mobile_phone_ccode, image_type, language, CONCAT_WS(' ', family_name, name) AS user_full_name,
						<!---The following columns are only used in full lists--->
						linkedin_url, twitter_url, dni, address, enabled
					FROM `#client_abb#_users` AS u
					WHERE u.id IN (#usersList#)
					<cfif isDefined("arguments.include_user_log_in") AND arguments.include_user_log_in NEQ true>
					AND u.id != #user_id#
					</cfif>
					<cfif notify_new_message NEQ "">
					AND u.notify_new_message = <cfqueryparam value="#notify_new_message#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif notify_new_file NEQ "">
					AND u.notify_new_file = <cfqueryparam value="#notify_new_file#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_replace_file NEQ "">
					AND u.notify_replace_file = <cfqueryparam value="#arguments.notify_replace_file#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_delete_file NEQ "">
					AND u.notify_delete_file = <cfqueryparam value="#arguments.notify_delete_file#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_lock_file NEQ "">
					AND u.notify_lock_file = <cfqueryparam value="#arguments.notify_lock_file#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_area NEQ "">
					AND u.notify_new_area = <cfqueryparam value="#arguments.notify_new_area#" cfsqltype="cf_sql_bit">
					</cfif>

					<cfif arguments.notify_new_entry NEQ "">
					AND u.notify_new_entry = <cfqueryparam value="#arguments.notify_new_entry#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_link NEQ "">
					AND u.notify_new_link = <cfqueryparam value="#arguments.notify_new_link#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_news NEQ "">
					AND u.notify_new_news = <cfqueryparam value="#arguments.notify_new_news#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_event NEQ "">
					AND u.notify_new_event = <cfqueryparam value="#arguments.notify_new_event#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_task NEQ "">
					AND u.notify_new_task = <cfqueryparam value="#arguments.notify_new_task#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_consultation NEQ "">
					AND u.notify_new_consultation = <cfqueryparam value="#arguments.notify_new_consultation#" cfsqltype="cf_sql_bit">
					</cfif>

					<cfif arguments.notify_new_image NEQ "">
					AND u.notify_new_image = <cfqueryparam value="#arguments.notify_new_image#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_typology NEQ "">
					AND u.notify_new_typology = <cfqueryparam value="#arguments.notify_new_typology#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_list NEQ "">
					AND u.notify_new_list = <cfqueryparam value="#arguments.notify_new_list#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_list_row NEQ "">
					AND u.notify_new_list_row = <cfqueryparam value="#arguments.notify_new_list_row#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_list_view NEQ "">
					AND u.notify_new_list_view = <cfqueryparam value="#arguments.notify_new_list_view#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_form NEQ "">
					AND u.notify_new_form = <cfqueryparam value="#arguments.notify_new_form#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_form_row NEQ "">
					AND u.notify_new_form_row = <cfqueryparam value="#arguments.notify_new_form_row#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_form_view NEQ "">
					AND u.notify_new_form_view = <cfqueryparam value="#arguments.notify_new_form_view#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_pubmed NEQ "">
					AND u.notify_new_pubmed = <cfqueryparam value="#arguments.notify_new_pubmed#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_dp_document NEQ "">
					AND u.notify_new_dp_document = <cfqueryparam value="#arguments.notify_new_dp_document#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif arguments.notify_new_mailing NEQ "">
					AND u.notify_new_mailing = <cfqueryparam value="#arguments.notify_new_mailing#" cfsqltype="cf_sql_bit">
					</cfif>

					<cfif arguments.notify_new_user_in_area NEQ "">
					AND u.notify_new_user_in_area = <cfqueryparam value="#arguments.notify_new_user_in_area#" cfsqltype="cf_sql_bit">
					</cfif>

					<cfif arguments.no_notifications NEQ "">
					AND u.no_notifications = <cfqueryparam value="#arguments.no_notifications#" cfsqltype="cf_sql_bit">
					</cfif>

					<cfif arguments.with_external EQ "false">
					AND u.internal_user = true
					</cfif>
					<cfif isDefined("arguments.enabled")>
					AND u.enabled = <cfqueryparam value="#arguments.enabled#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif isDefined("arguments.emailDefined") AND arguments.emailDefined IS true>
					AND LENGTH(email) > 0
					</cfif>

					<cfif isDefined("arguments.itemTypeId") AND listLen(arguments.categories_ids) GT 0>
					AND u.id NOT IN (
						<!---Obtiene los usuarios que tienen deshabilitadas TODAS las categorías pasadas en sus notificaciones--->
						SELECT users_categories_disabled.user_id
						FROM (
								SELECT user_id, count(*) AS matches
								FROM `#client_abb#_users_notifications_categories_disabled` AS categories_disabled
								WHERE item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">
								AND	area_id IN (<cfqueryparam value="#arguments.categories_ids#" cfsqltype="cf_sql_varchar" list="true">)
								GROUP by user_id
							) AS users_categories_disabled
						WHERE users_categories_disabled.matches = <cfqueryparam value="#listLen(arguments.categories_ids)#" cfsqltype="cf_sql_integer">
						)
					</cfif>
					;
				</cfquery>

				<cfif areaUsersQuery.recordCount GT 0>

					<cfloop query="areaUsersQuery">
						<!---
						<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="user">
							<cfinvokeargument name="id" value="#areaUsersQuery.id#">
							<cfinvokeargument name="email" value="#areaUsersQuery.email#">
							<cfinvokeargument name="telephone" value="#areaUsersQuery.telephone#">
							<cfinvokeargument name="space_used" value="#areaUsersQuery.space_used#">
							<cfinvokeargument name="number_of_connections" value="#areaUsersQuery.number_of_connections#">
							<cfinvokeargument name="last_connection" value="#areaUsersQuery.last_connection#">
							<cfinvokeargument name="connected" value="#areaUsersQuery.connected#">
							<cfinvokeargument name="session_id" value="#areaUsersQuery.session_id#">
							<cfinvokeargument name="creation_date" value="#areaUsersQuery.creation_date#">
							<cfinvokeargument name="whole_tree_visible" value="#areaUsersQuery.internal_user#">
							<cfinvokeargument name="root_folder_id" value="#areaUsersQuery.root_folder_id#">
							<cfinvokeargument name="family_name" value="#areaUsersQuery.family_name#">
							<cfinvokeargument name="name" value="#areaUsersQuery.name#">
							<cfinvokeargument name="address" value="#areaUsersQuery.address#">
							<cfinvokeargument name="areas_administration" value="">
							<cfinvokeargument name="mobile_phone" value="#areaUsersQuery.mobile_phone#">
							<cfinvokeargument name="telephone_ccode" value="#areaUsersQuery.telephone_ccode#">
							<cfinvokeargument name="mobile_phone_ccode" value="#areaUsersQuery.mobile_phone_ccode#">
							<cfinvokeargument name="image_type" value="#areaUsersQuery.image_type#">
							<cfinvokeargument name="language" value="#areaUsersQuery.language#">

							<cfif listFind(areaMembersList, areaUsersQuery.id) GT 0>
								<cfinvokeargument name="area_member" value="1">
							<cfelse>
								<cfinvokeargument name="area_member" value="0">
							</cfif>

							<cfinvokeargument name="return_type" value="object">
						</cfinvoke>
						--->

						<!---<cfset user = queryRowData(areaUsersQuery, areaUsersQuery.currentRow)>--->

						<cfset user = GetQueryRow(areaUsersQuery, areaUsersQuery.currentRow)>

						<cfset user.whole_tree_visible = areaUsersQuery.internal_user>
						<cfset user.areas_administration = "">

						<cfif listFind(areaMembersList, areaUsersQuery.id) GT 0>
							<cfset user.area_member = 1>
						<cfelse>
							<cfset user.area_member = 0>
						</cfif>

						<cfinvoke component="UserManager" method="appendUser" returnvariable="usersArrayUpdated">
							<cfinvokeargument name="usersArray" value="#usersArray#">
							<cfinvokeargument name="objectUser" value="#user#">
						</cfinvoke>

						<cfset usersArray = usersArrayUpdated>

					</cfloop>

				</cfif>

			</cfif>

			<cfset response = {usersArray=usersArray, areasArray=areasArray}>
			<cfreturn response>

	</cffunction>



	<!--- ---------------------------- getAreaAdministrators ------------------------------- --->

	<cffunction name="getAreaAdministrators" returntype="struct" output="false" access="public">
		<cfargument name="area_id" type="string" required="yes">
		<cfargument name="areasArray" type="array" required="yes">
		<cfargument name="include_user_log_in" type="boolean" required="no" default="false">
		<cfargument name="get_orientation" type="string" required="no" default="desc">

		<cfargument name="with_external" type="string" required="false" default="true">
		<cfargument name="enabled" type="boolean" required="false">
		<cfargument name="emailDefined" type="boolean" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getAreaAdministrators">

			<cfinvoke component="UserManager" method="getAreaUsersIds" returnvariable="usersIdsResult">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="areasArray" value="#arguments.areasArray#">

				<cfinvokeargument name="get_orientation" value="#arguments.get_orientation#">

				<cfinvokeargument name="userType" value="administrators">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfset usersList = usersIdsResult.usersList>
			<cfset areasArray = usersIdsResult.areasArray>
			<cfset areaMembersList = usersIdsResult.areaMembersList>

			<cfset usersArray = arrayNew(1)>

			<cfif listLen(usersList) GT 0>

				<cfquery name="areaUsersQuery" datasource="#client_dsn#">
					SELECT id, email, telephone, space_used, number_of_connections, last_connection, connected, session_id, creation_date, internal_user, root_folder_id, family_name, name, address, mobile_phone, telephone_ccode, mobile_phone_ccode, image_type, language
					FROM #client_abb#_users AS u
					WHERE u.id IN (#usersList#)
					<cfif isDefined("arguments.include_user_log_in") AND arguments.include_user_log_in NEQ true>
					AND u.id != #user_id#
					</cfif>

					<cfif arguments.with_external EQ "false">
					AND u.internal_user = true
					</cfif>
					<cfif isDefined("arguments.enabled")>
					AND u.enabled = <cfqueryparam value="#arguments.enabled#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif isDefined("arguments.emailDefined") AND arguments.emailDefined IS true>
					AND LENGTH(email) > 0
					</cfif>;
				</cfquery>

				<cfif areaUsersQuery.recordCount GT 0>

					<cfloop query="areaUsersQuery">
						<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="user">
							<cfinvokeargument name="id" value="#areaUsersQuery.id#">
							<cfinvokeargument name="email" value="#areaUsersQuery.email#">
							<cfinvokeargument name="telephone" value="#areaUsersQuery.telephone#">
							<cfinvokeargument name="space_used" value="#areaUsersQuery.space_used#">
							<cfinvokeargument name="number_of_connections" value="#areaUsersQuery.number_of_connections#">
							<cfinvokeargument name="last_connection" value="#areaUsersQuery.last_connection#">
							<cfinvokeargument name="connected" value="#areaUsersQuery.connected#">
							<cfinvokeargument name="session_id" value="#areaUsersQuery.session_id#">
							<cfinvokeargument name="creation_date" value="#areaUsersQuery.creation_date#">
							<cfinvokeargument name="whole_tree_visible" value="#areaUsersQuery.internal_user#">
							<cfinvokeargument name="root_folder_id" value="#areaUsersQuery.root_folder_id#">
							<cfinvokeargument name="family_name" value="#areaUsersQuery.family_name#">
							<cfinvokeargument name="name" value="#areaUsersQuery.name#">
							<cfinvokeargument name="address" value="#areaUsersQuery.address#">
							<cfinvokeargument name="areas_administration" value="">
							<cfinvokeargument name="mobile_phone" value="#areaUsersQuery.mobile_phone#">
							<cfinvokeargument name="telephone_ccode" value="#areaUsersQuery.telephone_ccode#">
							<cfinvokeargument name="mobile_phone_ccode" value="#areaUsersQuery.mobile_phone_ccode#">
							<cfinvokeargument name="image_type" value="#areaUsersQuery.image_type#">
							<cfinvokeargument name="language" value="#areaUsersQuery.language#">

							<cfif listFind(areaMembersList, areaUsersQuery.id) GT 0>
								<cfinvokeargument name="area_member" value="1">
							<cfelse>
								<cfinvokeargument name="area_member" value="0">
							</cfif>

							<cfinvokeargument name="return_type" value="object">
						</cfinvoke>

						<cfinvoke component="UserManager" method="appendUser" returnvariable="usersArrayUpdated">
							<cfinvokeargument name="usersArray" value="#usersArray#">
							<cfinvokeargument name="objectUser" value="#user#">
						</cfinvoke>

						<cfset usersArray = usersArrayUpdated>

					</cfloop>

				</cfif>

			</cfif>

			<cfset response = {usersArray=usersArray, areasArray=areasArray}>
			<cfreturn response>

	</cffunction>



	<!--- ---------------------------- getAreaUsersIds ------------------------------- --->

	<cffunction name="getAreaUsersIds" returntype="struct" output="false" access="public">
		<cfargument name="area_id" type="string" required="yes">
		<cfargument name="usersList" type="string" required="no" default="">
		<cfargument name="areasArray" type="array" required="yes">

		<cfargument name="get_orientation" type="string" required="no" default="desc"><!---desc/asc/both---><!---both: obtiene los usuarios de las áreas superiores e inferiores--->

		<cfargument name="userType" type="string" required="false" default="users"><!---users/administrators--->

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getAreaUsersIds">
		<cfset var areaMembersList = "">

			<cfif arrayFindCustom(areasArray, "#arguments.area_id#") IS 0><!---The area IS NOT searched before--->

				<cfquery name="membersQuery" datasource="#client_dsn#">
					SELECT user_id
					FROM #client_abb#_areas_#arguments.userType# AS a
					WHERE a.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfif membersQuery.recordCount GT 0>

					<cfloop query="membersQuery">

						<cfif listFind(usersList, membersQuery.user_id) IS 0>

							<cfset usersList = listAppend(usersList, membersQuery.user_id)>
							<cfset areaMembersList = listAppend(areaMembersList, membersQuery.user_id)>

						</cfif>

					</cfloop>

				</cfif>

				<cfset ArrayAppend(areasArray,"#arguments.area_id#")>

				<!--- Get Descendeant Areas --->
				<cfif arguments.get_orientation EQ "desc" OR arguments.get_orientation EQ "both">

					<cfquery datasource="#client_dsn#" name="getDescendantAreas">
						SELECT id AS area_id
						FROM #client_abb#_areas
						WHERE parent_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<cfif getDescendantAreas.recordCount GT 0>

						<cfloop query="getDescendantAreas">

							<cfinvoke component="UserManager" method="getAreaUsersIds" returnvariable="usersIdsResult">
								<cfinvokeargument name="area_id" value="#getDescendantAreas.area_id#">
								<cfinvokeargument name="usersList" value="#usersList#">
								<cfinvokeargument name="areasArray" value="#areasArray#">

								<cfinvokeargument name="get_orientation" value="desc">

								<cfinvokeargument name="userType" value="#arguments.userType#">

								<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
								<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
							</cfinvoke>
							<cfset usersList = usersIdsResult.usersList>
							<cfset areasArray = usersIdsResult.areasArray>

						</cfloop>

					</cfif>
				</cfif>

				<!--- Get Ascendant Areas --->
				<cfif arguments.get_orientation EQ "asc" OR arguments.get_orientation EQ "both">

					<cfquery datasource="#client_dsn#" name="getAscendantAreas">
						SELECT parent_id
						FROM #client_abb#_areas
						WHERE id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<cfif getAscendantAreas.recordCount GT 0 AND isNumeric(getAscendantAreas.parent_id)>

						<cfinvoke component="UserManager" method="getAreaUsersIds" returnvariable="usersIdsResult">
							<cfinvokeargument name="area_id" value="#getAscendantAreas.parent_id#">
							<cfinvokeargument name="usersList" value="#usersList#">
							<cfinvokeargument name="areasArray" value="#areasArray#">

							<cfinvokeargument name="get_orientation" value="asc">

							<cfinvokeargument name="userType" value="#arguments.userType#">

							<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
							<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
						</cfinvoke>
						<cfset usersList = usersIdsResult.usersList>
						<cfset areasArray = usersIdsResult.areasArray>

					</cfif>

				</cfif>

			</cfif>


			<cfset response = {usersList=usersList, areasArray=areasArray, areaMembersList=areaMembersList}>
			<cfreturn response>

	</cffunction>


	<!--- ---------------------------- APPEND USERS ------------------------------- --->

	<cffunction name="appendUser" returntype="array" output="false" access="public">
		<cfargument name="usersArray" type="array" required="yes">
		<cfargument name="objectUser" type="struct" required="yes">

		<cfset var method = "appendUser">

			<cfloop index="arrUser" array="#usersArray#">

				<cfif arrUser.id EQ objectUser.id>
					<cfreturn usersArray>
				</cfif>

			</cfloop>

			<cfset arrayAppend(usersArray,#objectUser#)>

			<cfreturn usersArray>

	</cffunction>



	<!--- getUserVisibleUsers --->

	<cffunction name="getUserVisibleUsers" output="false" returntype="struct" acces="public">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

			<cfset var usersList = "">
			<cfset var areasArray = arrayNew(1)>

			<cfquery name="getUserAreas" datasource="#client_dsn#">
				SELECT area_id
				FROM #client_abb#_areas_users
				WHERE user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_varchar">;
			</cfquery>

			<cfloop query="getUserAreas">

				<!---Obtiene los usuarios de las áreas hacia abajo y hacia arriba--->
				<!---En versiones anteriores de la aplicación sólo se mostraban los usuarios de las áreas inferiores, ya que los usuarios externos sólo podían ver los usuarios que estaban directamente asociados a las áreas a las que tienen acceso y sus áreas inferiores.--->

				<cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="getAreaUsersIds" argumentcollection="#arguments#" returnvariable="usersIdsResult">
					<cfinvokeargument name="area_id" value="#getUserAreas.area_id#">
					<cfinvokeargument name="usersList" value="#usersList#">
					<cfinvokeargument name="areasArray" value="#areasArray#">

					<cfinvokeargument name="get_orientation" value="both">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfset usersList = usersIdsResult.usersList>
				<cfset areasArray = usersIdsResult.areasArray>

			</cfloop>

			<cfreturn {usersList=usersList, areasArray=areasArray}>

	</cffunction>



	<!---  ---------------------CREATE USER------------------------------------ --->

	<cffunction name="createUser" returntype="struct" output="false" access="public">
		<cfargument name="family_name" type="string" required="true">
		<cfargument name="email" type="string" required="false" default="">
		<cfargument name="dni" type="string" required="true">
		<cfargument name="mobile_phone" type="string" required="true">
		<cfargument name="mobile_phone_ccode" type="string" required="true">
		<cfargument name="telephone" type="string" required="true">
		<cfargument name="telephone_ccode" type="string" required="true">
		<cfargument name="address" type="string" required="true">
		<cfargument name="language" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="password_temp" type="string" required="true">
		<cfargument name="files" type="array" required="false"/>
		<cfargument name="hide_not_allowed_areas" type="boolean" default="false">

		<cfargument name="linkedin_url" type="string" required="true">
		<cfargument name="twitter_url" type="string" required="true">
		<cfargument name="start_page" type="string" required="true">
		<cfargument name="information" type="string" required="true">
		<cfargument name="internal_user" type="boolean" required="false" default="false">
		<cfargument name="enabled" type="boolean" required="false" default="false">

		<cfargument name="login_ldap" type="string" required="false">
		<cfargument name="login_diraya" type="string" required="false">
		<cfargument name="perfil_cabecera" type="string" required="false">

		<cfargument name="center_id" type="numeric" required="false">
		<cfargument name="category_id" type="numeric" required="false">
		<cfargument name="service_id" type="numeric" required="false">
		<cfargument name="service" type="string" required="false">
		<cfargument name="other_1" type="string" required="false">
		<cfargument name="other_2" type="string" required="false">

		<cfargument name="typology_id" type="string" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "createUser">

		<cfset var response = structNew()>
		<cfset var clientQuery = "">
		<cfset var new_user_id = "">


			<!--- getClient --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
				<cfinvokeargument name="client_abb" value="#client_abb#">
			</cfinvoke>

			<cfif clientQuery.recordCount GT 0>

				<cfif listFind(APPLICATION.languages, arguments.language , ",") IS 0>
					<cfset response = {result=false, message="Idioma no válido"}>
					<cfreturn response>
				</cfif>

				<cfset arguments.email = Trim(arguments.email)>
				<cfset arguments.mobile_phone = Trim(arguments.mobile_phone)>


				<cftransaction>

					<cfif APPLICATION.userEmailRequired IS true OR len(arguments.email) GT 0>

						<!---checkEmail--->
						<cfif len(arguments.email) IS 0 OR NOT isValid("email",arguments.email)>
							<cfset response = {result=false, message="Email incorrecto"}>
							<cfreturn response>
						</cfif>

						<cfquery name="checkEmail" datasource="#client_dsn#">
							SELECT id
							FROM #client_abb#_users
							WHERE email=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">;
						</cfquery>

						<cfif checkEmail.recordCount GT 0><!---User email already used--->
							<!---<cfset error_code = 205>>--->
							<cfset response = {result=false, message="La dirección de email introducida ya está asociada a otro usuario de la aplicación"}>
							<cfreturn response>
						</cfif>

					</cfif>

					<cfif APPLICATION.moduleLdapUsers EQ true>

						<!---if login_ldap is defined--->
						<cfif len(arguments.login_ldap) GT 0>

							<!---Check if login already used--->
							<cfquery name="checkLoginLdap" datasource="#client_dsn#">
								SELECT *
								FROM #client_abb#_users
								WHERE login_ldap=<cfqueryparam value="#arguments.login_ldap#" cfsqltype="cf_sql_varchar">;
							</cfquery>

							<cfif checkLoginLdap.recordCount GT 0><!---User LDAP login already assigned to another user--->
								<!---<cfset error_code = 211>--->
								<cfset response = {result=false, message="El login introducido ya está asociado a otro usuario de la aplicación"}>
								<cfreturn response>
							</cfif>

							<!---Check if exist in LDAP (ONLY VPNET)--->
							<cfif APPLICATION.identifier EQ "vpnet">

								<cfinvoke component="UserLDAPManager" method="getLDAPUser" returnvariable="xmlResponseUser">
									<cfinvokeargument name="login_ldap" value="#arguments.login_ldap#">
									<cfinvokeargument name="return_type" value="xml">
								</cfinvoke>

							</cfif>

						</cfif>

						<cfif isDefined("arguments.login_diraya") AND len(arguments.login_diraya) GT 0>

							<!---Check if login already used--->
							<cfquery name="checkLoginDiraya" datasource="#client_dsn#">
								SELECT *
								FROM #client_abb#_users
								WHERE login_diraya = <cfqueryparam value="#arguments.login_diraya#" cfsqltype="cf_sql_varchar">;
							</cfquery>

							<cfif checkLoginDiraya.recordCount GT 0><!---User LDAP login already assigned to another user--->
								<!---<cfset error_code = 211>>--->
								<cfset response = {result=false, message="El login de Diraya introducido ya está asociado a otro usuario de la aplicación"}>
								<cfreturn response>
							</cfif>

						</cfif>

					</cfif>

					<!---Insert User in DataBase--->
					<cfquery name="insertUserQuery" datasource="#client_dsn#" result="insertUserResult">
						INSERT INTO #client_abb#_users
						SET email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
						name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
						family_name = <cfqueryparam value="#arguments.family_name#" cfsqltype="cf_sql_varchar">,
						telephone = <cfqueryparam value="#arguments.telephone#" cfsqltype="cf_sql_varchar">,
						address = <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">,
						password = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar">,
						sms_allowed = <cfqueryparam value="false" cfsqltype="cf_sql_bit">,
						mobile_phone = <cfqueryparam value="#arguments.mobile_phone#" cfsqltype="cf_sql_varchar">,
						creation_date = NOW(),
						<cfif len(arguments.telephone_ccode) GT 0>
							telephone_ccode = <cfqueryparam value="#arguments.telephone_ccode#" cfsqltype="cf_sql_integer">,
						<cfelse>
							telephone_ccode = <cfqueryparam null="true" cfsqltype="cf_sql_numeric">,
						</cfif>
						<cfif len(arguments.mobile_phone_ccode) GT 0>
							mobile_phone_ccode = <cfqueryparam value="#arguments.mobile_phone_ccode#" cfsqltype="cf_sql_integer">
						<cfelse>
							mobile_phone_ccode = <cfqueryparam null="true" cfsqltype="cf_sql_numeric">
						</cfif>,
						language = <cfqueryparam value="#arguments.language#" cfsqltype="cf_sql_varchar">,
						dni = <cfqueryparam value="#arguments.dni#" cfsqltype="cf_sql_varchar">,
						hide_not_allowed_areas = <cfqueryparam value="#arguments.hide_not_allowed_areas#" cfsqltype="cf_sql_bit">,
						information = <cfqueryparam value="#arguments.information#" cfsqltype="cf_sql_longvarchar">,
						internal_user = <cfqueryparam value="#arguments.internal_user#" cfsqltype="cf_sql_bit">,
						enabled = <cfqueryparam value="#arguments.enabled#" cfsqltype="cf_sql_bit">,
						linkedin_url = <cfqueryparam value="#arguments.linkedin_url#" cfsqltype="cf_sql_varchar">,
						twitter_url = <cfqueryparam value="#arguments.twitter_url#" cfsqltype="cf_sql_varchar">,
						start_page = <cfqueryparam value="#arguments.start_page#" cfsqltype="cf_sql_varchar">
						<cfif APPLICATION.moduleLdapUsers EQ true>
							<cfif isDefined("arguments.login_ldap") AND len(arguments.login_ldap) GT 0>
							, login_ldap = <cfqueryparam value="#arguments.login_ldap#" cfsqltype="cf_sql_varchar">
							</cfif>
							<cfif isDefined("arguments.login_diraya") AND len(arguments.login_diraya) GT 0>
							, login_diraya = <cfqueryparam value="#arguments.login_diraya#" cfsqltype="cf_sql_varchar">
							</cfif>
						</cfif>
						<cfif isDefined("arguments.perfil_cabecera")>
						, perfil_cabecera = <cfqueryparam value="#arguments.perfil_cabecera#" cfsqltype="cf_sql_varchar">
						</cfif>

						<cfif APPLICATION.identifier EQ "vpnet">
							, center_id = <cfqueryparam value="#arguments.center_id#" cfsqltype="cf_sql_integer">
							, category_id = <cfqueryparam value="#arguments.category_id#" cfsqltype="cf_sql_integer">
							, service_id = <cfqueryparam value="#arguments.service_id#" cfsqltype="cf_sql_integer">
							, service = <cfqueryparam value="#arguments.service#" cfsqltype="cf_sql_varchar">
							, other_1 = <cfqueryparam value="#arguments.other_1#" cfsqltype="cf_sql_varchar">
							, other_2 = <cfqueryparam value="#arguments.other_2#" cfsqltype="cf_sql_varchar">
						</cfif>
						;
					</cfquery>

					<!---Aquí se obtiene el id del usuario insertado en base de datos--->
					<cfquery name="getLastInsertId" datasource="#client_dsn#">
						SELECT LAST_INSERT_ID() AS last_insert_id FROM #client_abb#_users;
					</cfquery>
					<cfset new_user_id = getLastInsertId.last_insert_id>

					<!---Insert User Root Folder--->
					<cfquery name="insertRootFolderQuery" datasource="#client_dsn#" result="insertRootFolderResult">
						INSERT INTO #client_abb#_folders
						(name, creation_date, user_in_charge, description)
						VALUES(
							'Mis documentos',
							NOW(),
							<cfqueryparam value="#new_user_id#" cfsqltype="cf_sql_integer">,
							'Directorio raiz'
							);
					</cfquery>

					<cfquery name="getLastInsertId" datasource="#client_dsn#">
						SELECT LAST_INSERT_ID() AS last_insert_id FROM #client_abb#_folders;
					</cfquery>
					<cfset root_folder_id = getLastInsertId.last_insert_id>

					<cfquery name="insertRootFolderInUser" datasource="#client_dsn#">
						UPDATE #client_abb#_users
						SET root_folder_id = #root_folder_id#
						WHERE id = <cfqueryparam value="#new_user_id#" CFSQLType="cf_sql_integer">;
					</cfquery>


					<!--- setUserTypology --->
					<cfif isDefined("arguments.typology_id") AND isNumeric(arguments.typology_id)>

						<cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="setUserTypology" argumentcollection="#arguments#">
							<cfinvokeargument name="update_user_id" value="#new_user_id#"/>
						</cfinvoke>

					</cfif>

				</cftransaction>


				<cfif isDefined("arguments.files")>

					<!---Subida de imagen--->

					<cfinvoke component="#APPLICATION.coreComponentsPath#/UserImageFile" method="uploadUserImage">
						<cfinvokeargument name="files" value="#arguments.files#">
						<cfinvokeargument name="user_id" value="#new_user_id#">
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					</cfinvoke>

					<!---FIN subida de imagen--->

				</cfif>


				<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="selectUserQuery">
					<cfinvokeargument name="user_id" value="#new_user_id#">
					<cfinvokeargument name="with_ldap" value="#APPLICATION.moduleLdapUsers#">
					<cfif APPLICATION.identifier EQ "vpnet">
						<cfinvokeargument name="with_vpnet" value="true">
					</cfif>

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif selectUserQuery.recordCount IS 0><!---the user does not exist--->

					<cfset error_code = 204>

					<cfthrow errorcode="#error_code#">

				</cfif>

				<cfif arguments.enabled IS true AND len(arguments.email) GT 0>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newUser">
						<cfinvokeargument name="objectUser" value="#selectUserQuery#">
						<cfinvokeargument name="password_temp" value="#arguments.password_temp#">
						<cfinvokeargument name="client_id" value="#clientQuery.id#">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>

				<cfinclude template="includes/logRecord.cfm">

				<cfset response = {result=true, user_id=new_user_id}>


			<cfelse><!---The client does not exist--->

				<cfset error_code = 301>

				<cfthrow errorcode="#error_code#">

			</cfif>

		<cfreturn response>

	</cffunction>


	<!--- ----------------------------------- setUserTypology -------------------------------------- --->

	<cffunction name="setUserTypology" output="false" returntype="numeric" access="public">
		<cfargument name="update_user_id" type="numeric" required="true">
		<cfargument name="table_id" type="numeric" required="true"><!---Este parámetro viene incluído junto con el resto de campos de la tabla en el método outputRowFormInputs en RowHtml--->
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="action" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "setUserTypology">

		<cfset var row_id = "">

			<!--- getTable --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTable" returnvariable="tableQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="parse_dates" value="false">
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif tableQuery.recordCount IS 0><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="saveRow" argumentcollection="#arguments#" returnvariable="row_id">
				<cfinvokeargument name="with_transaction" value="false">
			</cfinvoke>

			<cfif arguments.action IS "create">

				<cfquery datasource="#client_dsn#" name="setUserTypology">
					UPDATE #client_abb#_users
					SET typology_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">,
					typology_row_id = <cfqueryparam value="#row_id#" cfsqltype="cf_sql_integer">
					WHERE id = <cfqueryparam value="#arguments.update_user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

			</cfif>

		<cfreturn row_id>

	</cffunction>



	<!--- ----------------------------------- clearUserTypology -------------------------------------- --->

	<cffunction name="clearUserTypology" output="false" returntype="void" access="public">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "clearUserTypology">

			<cfquery datasource="#client_dsn#" name="clearUserTypology">
				UPDATE #client_abb#_users
				SET typology_id = <cfqueryparam null="true" cfsqltype="cf_sql_integer">,
				typology_row_id = <cfqueryparam null="true" cfsqltype="cf_sql_integer">
				WHERE id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

	</cffunction>


	<!--- ------------------------------------- getEmptyUser -------------------------------------  --->

	<cffunction name="getEmptyUser" output="false" access="public" returntype="struct">
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getEmptyUser">

		<cfset var response = structNew()>

			<cfquery name="getEmptyUserQuery" datasource="#client_dsn#">
				SELECT *, id AS user_id
				FROM #client_abb#_users
				WHERE id = -1;
			</cfquery>

			<!--- getClient --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			</cfinvoke>

			<!--- generatePassword --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="generatePassword" returnvariable="newPassword">
				<cfinvokeargument name="numberOfCharacters" value="6">
			</cfinvoke>

			<cfset queryAddRow(getEmptyUserQuery, 1)>

			<cfset querySetCell(getEmptyUserQuery, "enabled", true)>
			<!---<cfset querySetCell(getEmptyUserQuery, "mobile_phone_ccode", "34")>
			<cfset querySetCell(getEmptyUserQuery, "telephone_ccode", "34")>--->
			<cfset querySetCell(getEmptyUserQuery, "hide_not_allowed_areas", 1)>
			<cfset querySetCell(getEmptyUserQuery, "language", clientQuery.default_language)>

			<cfset queryAddColumn(getEmptyUserQuery, "new_password")>
			<cfset querySetCell(getEmptyUserQuery, "new_password", newPassword)>

			<cfset response = {result=true, user=#getEmptyUserQuery#}>

		<cfreturn response>

	</cffunction>




</cfcomponent>

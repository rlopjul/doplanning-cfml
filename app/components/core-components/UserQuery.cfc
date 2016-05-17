<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">

	<cfset component = "UserQuery">

	<cfset dateTimeFormat = APPLICATION.dbDateTimeFormat>
	<cfset timeZoneTo = APPLICATION.dbTimeZoneTo>

	<cfset LIST_TEXT_VALUES_DELIMITER = "#chr(13)##chr(10)#">

	<!--- ------------------------------------- getUser -------------------------------------  --->

	<cffunction name="getUser" output="false" access="public" returntype="query">
		<cfargument name="user_id" type="numeric" required="true">
		<cfargument name="format_content" type="string" required="false" default="default">
		<cfargument name="with_ldap" type="boolean" required="false" default="false">
		<cfargument name="with_vpnet" type="boolean" required="false" default="false">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getUser">

			<cfquery name="getUserQuery" datasource="#arguments.client_dsn#">
				SELECT id, id AS user_id, email, telephone, telephone_ccode, family_name, name, address, mobile_phone, mobile_phone_ccode, internal_user, internal_user AS whole_tree_visible, image_file, image_type, dni, language, enabled, information, hide_not_allowed_areas, linkedin_url, twitter_url, typology_id, typology_row_id, no_notifications, start_page, start_page_locked, verified, verification_date, verification_code, user_administrator, area_admin_administrator, CONCAT_WS(' ', family_name, name) AS user_full_name
				<cfif arguments.format_content EQ "all">
				, space_used, number_of_connections, connected, session_id, root_folder_id, sms_allowed
					<cfif arguments.parse_dates IS true>
						, DATE_FORMAT(CONVERT_TZ(last_connection,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS last_connection
						, DATE_FORMAT(CONVERT_TZ(creation_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS creation_date
					<cfelse>
						, last_connection, creation_date
					</cfif>
				</cfif>
				<cfif arguments.with_ldap IS true>
				, login_ldap
				<!--- <cfif arguments.client_abb EQ "asnc" OR arguments.client_abb EQ "agsna"> --->
				<cfif APPLICATION.moduleLdapDiraya EQ true>
					, login_diraya
				</cfif>
				</cfif>
				<cfif arguments.with_vpnet IS true>
				, center_id, category_id, service_id, service, other_1, other_2
				</cfif>
				<cfif arguments.client_abb EQ "hcs">
					, perfil_cabecera
				</cfif>
				FROM `#arguments.client_abb#_users`
				WHERE id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>




		<cfreturn getUserQuery>

	</cffunction>



	<!--- ------------------------------------- getUserPreferences -------------------------------------  --->

	<cffunction name="getUserPreferences" output="false" access="public" returntype="query">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="parse_dates" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getUser">

			<cfquery name="getUserPreferencesQuery" datasource="#arguments.client_dsn#">
				SELECT id, id AS user_id, notify_new_message, notify_new_file, notify_replace_file, notify_new_area,
				notify_new_event, notify_new_task
				, notify_delete_file <!---, notify_dissociate_file--->
				<cfif APPLICATION.moduleAreaFilesLite IS true>
				, notify_lock_file
				</cfif>
				<cfif APPLICATION.moduleConsultations IS true>
				, notify_new_consultation
				</cfif>
				<cfif APPLICATION.modulePubMedComments IS true>
				, notify_new_pubmed
				</cfif>
				<cfif APPLICATION.modulefilesWithTables IS true>
				, notify_new_typology
				</cfif>
				<cfif APPLICATION.moduleLists IS true>
				, notify_new_list
				, notify_new_list_row
				, notify_new_list_view
				</cfif>
				<cfif APPLICATION.moduleForms IS true>
				, notify_new_form
				, notify_new_form_row
				, notify_new_form_view
				</cfif>
				<cfif APPLICATION.moduleDPDocuments IS true>
				, notify_new_dp_document
				</cfif>
				<cfif APPLICATION.moduleMailing IS true>
				, notify_new_mailing
				</cfif>
				<cfif APPLICATION.moduleWeb IS true>
					<cfif APPLICATION.identifier EQ "vpnet">
					, notify_new_link
					</cfif>
					, notify_new_entry, notify_new_news, notify_new_image
				</cfif>
				, notify_new_user_in_area
				, notify_been_associated_to_area
				, notify_app_news
				, notify_app_features
				, no_notifications
				, notifications_digest_type_id
				, notifications_web_digest_type_id
				<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(CONVERT_TZ(notifications_last_digest_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS notifications_last_digest_date
					, DATE_FORMAT(CONVERT_TZ(notifications_web_last_digest_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS notifications_web_last_digest_date
				<cfelse>
					, notifications_last_digest_date, notifications_web_last_digest_date
				</cfif>
				FROM #arguments.client_abb#_users
				WHERE id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

		<cfreturn getUserPreferencesQuery>

	</cffunction>


	<!---  -------------------GET USER NOTIFICATIONS CATEGORIES DISABLED----------------------   --->

	<cffunction name="getUserNotificationsCategoriesDisabled" returntype="query" output="false" access="public">
		<cfargument name="user_id" required="yes" type="numeric">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getUserNotificationsCategoriesDisabled">

			<cfquery name="getUserNotificationsCategoriesDisabled" datasource="#client_dsn#">
				SELECT users_notifications.user_id, users_notifications.item_type_id, users_notifications.area_id
				FROM `#client_abb#_users_notifications_categories_disabled` AS users_notifications
				WHERE users_notifications.user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

		<cfreturn getUserNotificationsCategoriesDisabled>

	</cffunction>


	<!---  -------------------GET USER NOTIFICATIONS TABLES CATEGORIES DISABLED----------------------   --->

	<cffunction name="getUserNotificationsTablesCategoriesDisabled" returntype="query" output="false" access="public">
		<cfargument name="user_id" required="yes" type="numeric">
		<cfargument name="with_categories" required="false" default="false">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getUserNotificationsTablesCategoriesDisabled">

			<cfquery name="getUserNotificationsTablesCategoriesDisabled" datasource="#client_dsn#">
				SELECT users_notifications.user_id, users_notifications.table_id, users_notifications.table_type_id, users_notifications.category_id
				<cfif arguments.with_categories IS true>
					, categories.*
				</cfif>
				FROM `#client_abb#_users_notifications_tables_categories_disabled` AS users_notifications
				INNER JOIN `#client_abb#_tables_special_categories`AS categories
				ON categories.category_id = users_notifications.category_id
				WHERE users_notifications.user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

		<cfreturn getUserNotificationsTablesCategoriesDisabled>

	</cffunction>


	<!--- ------------------------------------- getAllUsers -------------------------------------  --->

	<cffunction name="getAllUsers" output="false" access="public" returntype="query">
		<cfargument name="with_external" type="boolean" required="false" default="true"/>
		<cfargument name="search_text_re" type="string" required="false" default="">
		<cfargument name="order_by" type="string" required="false">
		<cfargument name="order_type" type="string" required="false">
		<cfargument name="limit" type="numeric" required="false">
		<cfargument name="typology_id" type="string" required="false">
		<cfargument name="users_ids" type="string" required="false"><!--- To select only users passed by id --->

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getAllUsers">

			<cfif isDefined("arguments.typology_id") AND isNumeric(arguments.typology_id)>

				<cfinvoke component="FieldQuery" method="getTableFields" returnvariable="fields">
					<cfinvokeargument name="table_id" value="#arguments.typology_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="with_types" value="true">
					<cfinvokeargument name="with_table" value="false">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>

			<cfquery name="getAllUsersQuery" datasource="#arguments.client_dsn#">
	      SELECT id, email, telephone, space_used, number_of_connections, last_connection, connected, session_id, u.creation_date, internal_user, root_folder_id, family_name, name, address, mobile_phone, telephone_ccode, mobile_phone_ccode, dni, image_type,
	    	CONCAT_WS(' ', family_name, name) AS user_full_name, enabled, typology_row_id, verified, user_administrator, area_admin_administrator
	    	<cfif arguments.client_abb EQ "hcs">
	    		, perfil_cabecera
	    	</cfif>
				<cfif APPLICATION.moduleLdapUsers EQ true>
					, login_ldap
				</cfif>
	      FROM #arguments.client_abb#_users AS u

	      <cfif isDefined("arguments.typology_id") AND ( isNumeric(arguments.typology_id) OR arguments.typology_id EQ "null") >

	      	<cfif arguments.typology_id EQ "null">

	      		WHERE u.typology_id IS NULL

	      	<cfelse>

	      		INNER JOIN `#client_abb#_users_typologies_rows_#arguments.typology_id#` AS table_row
						ON u.typology_id = <cfqueryparam value="#arguments.typology_id#" cfsqltype="cf_sql_integer">
	          AND u.typology_row_id = table_row.row_id

						<cfinclude template="#APPLICATION.coreComponentsPath#/includes/tableRowsSearchFields.cfm">

	      	</cfif>

	      </cfif>

				<cfif arguments.with_external EQ false>
					WHERE u.internal_user = true
				</cfif>

				<cfif len(arguments.search_text_re) GT 0>

					<cfif arguments.with_external EQ false OR ( isDefined("arguments.typology_id") AND ( isNumeric(arguments.typology_id) OR arguments.typology_id EQ "null") )>
					AND
					<cfelse>
					WHERE
					</cfif>
					(u.name REGEXP <cfqueryparam value="#arguments.search_text_re#" cfsqltype="cf_sql_varchar">
					OR u.family_name REGEXP <cfqueryparam value="#arguments.search_text_re#" cfsqltype="cf_sql_varchar">
					OR CONCAT(u.family_name, ' ', u.name) REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
					OR u.email REGEXP <cfqueryparam value="#arguments.search_text_re#" cfsqltype="cf_sql_varchar">
					OR u.address REGEXP <cfqueryparam value="#arguments.search_text_re#" cfsqltype="cf_sql_varchar">
					OR u.dni REGEXP <cfqueryparam value="#arguments.search_text_re#" cfsqltype="cf_sql_varchar">
					<cfif SESSION.client_abb EQ "hcs">
						OR u.information REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
						OR u.perfil_cabecera REGEXP <cfqueryparam value="#search_text_re#" cfsqltype="cf_sql_varchar">
					</cfif>)

				</cfif>

				<cfif isDefined("arguments.users_ids")>

					<cfif arguments.with_external EQ false OR len(arguments.search_text_re) GT 0>
						AND
					<cfelse>
						WHERE
					</cfif>
					u.id IN (<cfqueryparam value="#arguments.users_ids#" cfsqltype="cf_sql_varchar" list="true">)

				</cfif>

                ORDER BY <cfif isDefined("arguments.order_by")>#arguments.order_by# <cfif isDefined("arguments.order_type")>#arguments.order_type#</cfif></cfif>

                <cfif isDefined("arguments.limit")>
				LIMIT #arguments.limit#
				</cfif>;
            </cfquery>

		<cfreturn getAllUsersQuery>

	</cffunction>


	<!--- ------------------------------------- getAllUsers -------------------------------------  --->

	<cffunction name="getAllUsersWithPreferences" output="false" access="public" returntype="query">
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfargument name="parse_dates" type="boolean" required="false" default="false">

		<cfset var method = "getAllUsersWithPreferences">

			<cfquery name="getAllUsersQuery" datasource="#arguments.client_dsn#">
          SELECT *, id AS user_id

					<cfif arguments.parse_dates IS true>
						, DATE_FORMAT(CONVERT_TZ(creation_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS creation_date
						, DATE_FORMAT(CONVERT_TZ(last_update_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS last_update_date
						, DATE_FORMAT(CONVERT_TZ(notifications_last_digest_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS notifications_last_digest_date
						, DATE_FORMAT(CONVERT_TZ(notifications_web_last_digest_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS notifications_web_last_digest_date
					</cfif>

          FROM #arguments.client_abb#_users AS u;
      </cfquery>

		<cfreturn getAllUsersQuery>

	</cffunction>



	<!--- ------------------------------------- getAllUsersRelatedToAreas -------------------------------------  --->

	<cffunction name="getAllUsersRelatedToAreas" output="false" access="public" returntype="query">
		<cfargument name="areas_ids" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfargument name="parse_dates" type="boolean" required="false" default="false">

		<cfset var method = "getAllUsersRelatedToAreas">

			<cfquery name="getAllUsersRelatedToAreasQuery" datasource="#arguments.client_dsn#">
          SELECT *, id AS user_id

					<cfif arguments.parse_dates IS true>
						, DATE_FORMAT(CONVERT_TZ(creation_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS creation_date
						, DATE_FORMAT(CONVERT_TZ(last_update_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS last_update_date
						, DATE_FORMAT(CONVERT_TZ(notifications_last_digest_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS notifications_last_digest_date
						, DATE_FORMAT(CONVERT_TZ(notifications_web_last_digest_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS notifications_web_last_digest_date
					</cfif>

          FROM #arguments.client_abb#_users AS users
					INNER JOIN #arguments.client_abb#_areas_users AS areas_users
					ON users.id = areas_users.user_id
					AND areas_users.area_id IN (<cfqueryparam value="#arguments.areas_ids#" cfsqltype="cf_sql_integer" list="true">)
					GROUP BY id;
      </cfquery>

		<cfreturn getAllUsersRelatedToAreasQuery>

	</cffunction>


	<!------------------------ ASSIGN USER TO AREA -------------------------------------->

	<cffunction name="assignUserToArea" returntype="void" output="false" access="public">
		<cfargument name="area_id" type="numeric" required="true"/>
		<cfargument name="user_id" type="numeric" required="true"/>

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "assignUserToArea">

				<cfquery name="assignUserToArea" datasource="#client_dsn#">
					INSERT
					INTO #client_abb#_areas_users (area_id, user_id, association_date)
					VALUES(<cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">,
							NOW());
				</cfquery>

	</cffunction>


	<!------------------------ DISSOCIATE USER FROM AREA -------------------------------------->

	<cffunction name="dissociateUserFromArea" returntype="void" output="false" access="public">
		<cfargument name="area_id" type="numeric" required="true"/>
		<cfargument name="user_id" type="numeric" required="true"/>

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "dissociateUserFromArea">

				<cfquery name="dissociateUser" datasource="#client_dsn#">
					DELETE FROM #client_abb#_areas_users
					WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					AND user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

	</cffunction>


	<!------------------------ IS USER ASSOCIATED TO AREA-------------------------------------->
	<cffunction name="isUserAssociatedToArea" returntype="struct" output="false" access="public">
		<cfargument name="area_id" type="numeric" required="true"/>
		<cfargument name="user_id" type="numeric" required="true"/>

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "isUserAssociatedToArea">

		<cfset var response = structNew()>

			<!---isUserInArea--->
			<cfquery name="isUserInArea" datasource="#client_dsn#">
				SELECT user_id
				FROM #client_abb#_areas_users
				WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				AND user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif isUserInArea.recordCount GT 0><!--- The user is in the area  --->
				<cfset response = {result=true, isUserInArea=true}>
			<cfelse>
				<cfset response = {result=true, isUserInArea=false}>
			</cfif>

		<cfreturn response>

	</cffunction>


</cfcomponent>

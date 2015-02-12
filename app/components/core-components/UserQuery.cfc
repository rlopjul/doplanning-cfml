<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">

	<cfset component = "UserQuery">

	<!--- ------------------------------------- getUser -------------------------------------  --->
	
	<cffunction name="getUser" output="false" access="public" returntype="query">
		<cfargument name="user_id" type="numeric" required="true">
		<cfargument name="format_content" type="string" required="false" default="default">
		<cfargument name="with_ldap" type="boolean" required="false" default="false">
		<cfargument name="with_vpnet" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getUser">

			<cfquery name="getUserQuery" datasource="#arguments.client_dsn#">
				SELECT id, id AS user_id, email, telephone, telephone_ccode, family_name, name, address, mobile_phone, mobile_phone_ccode, internal_user, internal_user AS whole_tree_visible, image_file, image_type, dni, language, enabled, information, hide_not_allowed_areas, linkedin_url, twitter_url,
					CONCAT_WS(' ', family_name, name) AS user_full_name
				<cfif arguments.format_content EQ "all">
				, space_used, number_of_connections, last_connection, connected, session_id, creation_date, root_folder_id, sms_allowed
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

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getUser">

			<cfquery name="getUserPreferencesQuery" datasource="#arguments.client_dsn#">
				SELECT id, notify_new_message, notify_new_file, notify_replace_file, notify_new_area,
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
				FROM #arguments.client_abb#_users		
				WHERE id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;			
			</cfquery>

		<cfreturn getUserPreferencesQuery>

	</cffunction>


	<!--- ------------------------------------- getAllUsers -------------------------------------  --->
	
	<cffunction name="getAllUsers" output="false" access="public" returntype="query">
		<cfargument name="with_external" type="boolean" required="false" default="true"/>
		<cfargument name="search_text_re" type="string" required="false" default="">
		<cfargument name="order_by" type="string" required="false">
		<cfargument name="order_type" type="string" required="false">
		<cfargument name="limit" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getAllUsers">

			<cfquery name="getAllUsersQuery" datasource="#arguments.client_dsn#">
                SELECT id, email, telephone, space_used, number_of_connections, last_connection, connected, session_id, creation_date, internal_user, root_folder_id, family_name, name, address, mobile_phone, telephone_ccode, mobile_phone_ccode, image_type, 
                	CONCAT_WS(' ', family_name, name) AS user_full_name, enabled
                	<cfif arguments.client_abb EQ "hcs">
                		, perfil_cabecera
                	</cfif>
                FROM #arguments.client_abb#_users AS u				
				<cfif arguments.with_external EQ false>
					WHERE u.internal_user = true				
				</cfif>
				<cfif len(arguments.search_text_re) GT 0>
					<cfif arguments.with_external EQ false>
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

		<cfset var method = "getAllUsersWithPreferences">

			<cfquery name="getAllUsersQuery" datasource="#arguments.client_dsn#">
                SELECT *, id AS user_id
                FROM #arguments.client_abb#_users AS u;
            </cfquery>

		<cfreturn getAllUsersQuery>

	</cffunction>

</cfcomponent>
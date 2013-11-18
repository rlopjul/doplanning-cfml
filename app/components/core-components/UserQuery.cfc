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
				SELECT id, email, telephone, telephone_ccode, family_name, name, address, mobile_phone, mobile_phone_ccode, internal_user, internal_user AS whole_tree_visible, image_file, image_type, dni, language,
				CONCAT_WS(' ', family_name, name) AS user_full_name
				<cfif arguments.format_content EQ "all">
				, space_used, number_of_connections, last_connection, connected, session_id, creation_date, root_folder_id, sms_allowed
				</cfif> 
				<cfif arguments.with_ldap IS true>
				, login_ldap, login_diraya
				</cfif>
				<cfif arguments.with_vpnet IS true>
				, center_id, category_id, service_id, service, other_1, other_2
				</cfif>
				FROM `#arguments.client_abb#_users`
				WHERE id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

		<cfreturn getUserQuery>

	</cffunction>

</cfcomponent>
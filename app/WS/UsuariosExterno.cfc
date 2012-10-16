<!---Copyright Era7 Information Technologies 2007-2011

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 10-10-2011
	
--->
<cfcomponent output="false">
	
	<cfset component = "UsuariosExterno">
	
	<cfset login_component = "colabora_externo">
	<cfset password_component = "8KfT-2NXspV5FbX">

	<cffunction name="listarUsuarios" returntype="string" output="false" access="remote">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">
		<cfargument name="user_id" type="numeric" required="no">
		<cfargument name="email" type="string" required="no">
		<cfargument name="login_ldap" type="string" required="no">
		<cfargument name="login_diraya" type="string" required="no">
		
		<cfset var client_dsn = "vpnet_asnc">
		
		<cfset var order_by = "name">
		<cfset var order_type = "asc">
		
		<cfset var xmlResponse = "">
		
		<cftry>
		
			<cfif arguments.login EQ login_component AND arguments.password EQ password_component>		
			
				<cfquery name="getAllUsersQuery" datasource="#client_dsn#">
					SELECT *
					FROM asnc_users AS u				   
					<cfif isDefined("arguments.user_id")>
						WHERE u.id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">
					<cfelseif isDefined("arguments.email")>
						WHERE u.email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
					<cfelseif isDefined("arguments.login_ldap")>
						WHERE u.login_ldap = <cfqueryparam value="#arguments.login_ldap#" cfsqltype="cf_sql_varchar">
					<cfelseif isDefined("arguments.login_diraya")>
						WHERE u.login_diraya = <cfqueryparam value="#arguments.login_diraya#" cfsqltype="cf_sql_varchar">
					</cfif> 
					ORDER BY #order_by# #order_type#;
				</cfquery>
					
				<cfset usersXml = '<users'>
				<!---<cfif isDefined("xmlUser.user.xmlAttributes.space_used")>
					<!---Parse total_space_used to megabytes--->
					<cfset total_space_used = getTotals.total_space_used><!---file_size_full is the file_size from database without parse to megabytes--->
					<cfset total_space_used = total_space_used/(1024*1024)>
					<cfset total_space_used = round(total_space_used*100)/100>
					<cfset usersXml = usersXml&' total_space_used="#total_space_used#"'>
				</cfif>
				<cfif isDefined("xmlUser.user.xmlAttributes.number_of_connections")>
					<cfset usersXml = usersXml&' total_connections="#getTotals.total_connections#"'>
				</cfif>--->
				<cfset usersXml = usersXml&'>'>
					<cfloop query="getAllUsersQuery">
						<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="xmlUserResult">
								<cfinvokeargument name="id" value="#getAllUsersQuery.id#">
								<cfinvokeargument name="email" value="#getAllUsersQuery.email#">
								<cfinvokeargument name="telephone" value="#getAllUsersQuery.telephone#">
								<!---<cfinvokeargument name="space_used" value="#getAllUsersQuery.space_used#">
								<cfinvokeargument name="number_of_connections" value="#getAllUsersQuery.number_of_connections#">
								<cfinvokeargument name="last_connection" value="#getAllUsersQuery.last_connection#">
								<cfinvokeargument name="connected" value="#getAllUsersQuery.connected#">
								<cfinvokeargument name="session_id" value="#getAllUsersQuery.session_id#">--->
								<cfinvokeargument name="creation_date" value="#getAllUsersQuery.creation_date#">
								<!---<cfinvokeargument name="whole_tree_visible" value="#getAllUsersQuery.internal_user#">
								<cfinvokeargument name="root_folder_id" value="#getAllUsersQuery.root_folder_id#">--->
								<!---<cfinvokeargument name="general_administrator" value="">--->
								<cfinvokeargument name="name" value="#getAllUsersQuery.family_name#">
								<cfinvokeargument name="family_name" value="#getAllUsersQuery.name#">
								<cfinvokeargument name="address" value="#getAllUsersQuery.address#">
								<!---<cfinvokeargument name="areas_administration" value="">--->
								<cfinvokeargument name="mobile_phone" value="#getAllUsersQuery.mobile_phone#">
								<cfinvokeargument name="user_full_name" value="#getAllUsersQuery.family_name# #getAllUsersQuery.name#">
								<cfinvokeargument name="telephone_ccode" value="#getAllUsersQuery.telephone_ccode#">
								<cfinvokeargument name="mobile_phone_ccode" value="#getAllUsersQuery.mobile_phone_ccode#">
								<cfinvokeargument name="login_ldap" value="#getAllUsersQuery.login_ldap#">
								<cfinvokeargument name="login_diraya" value="#getAllUsersQuery.login_diraya#">
							<cfinvokeargument name="return_type" value="xml">
						</cfinvoke>
						
						<cfset usersXml = usersXml&xmlUserResult>
						
					</cfloop>
				<cfset usersXml = usersXml&'</users>'>
				
				<cfset xmlResponse = usersXml>
								
			<cfelse>
			
				<cfthrow message="Login o contraseña incorrecta">
				
			</cfif>
			
			<cfcatch>
				
				<cfset error = "<error><message>#cfcatch.Message#</message></error>">
				<cfset xmlResponse = error>
			
			</cfcatch>
		
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
</cfcomponent>
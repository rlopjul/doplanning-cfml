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
		<cfargument name="request" type="string" required="yes">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">
	
		<cfset var method = "getUsersToNotifyLists">
		
		<cfset var internalUsersEmails = structNew()>
		<cfset var externalUsersEmails = structNew()>
		
		<cfset var internalUsersPhones = structNew()>
		<cfset var externalUsersPhones = structNew()>
		
        <cfset var structResponse = structNew()>
		
        <cfinvoke component="UserManager" method="getUsersToNotify" returnvariable="arrayUsersToNotify">
			<cfinvokeargument name="request" value="#arguments.request#"/>

			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
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
		<cfargument name="request" type="string" required="yes">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">
	
		<cfset var method = "getUsersToNotify">
		
		<cfset var xmlUser = "">
		<cfset var init_area_id = "">

		<cfset var usersArray = ArrayNew(1)>
		<cfset var areasArray = ArrayNew(1)>
		
		<!---PREFERENCES--->
		<cfset var notify_new_message = "">
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

		<cfset var notify_new_user_in_area = "">
			
			
			<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="xmlRequest" returnvariable="xmlRequest">
				<cfinvokeargument name="request" value="#arguments.request#">
			</cfinvoke>
			
			<cfxml variable="xmlUser">
				<cfoutput>
					#xmlRequest.request.parameters.user#
				</cfoutput>
			</cfxml>
			
			<cfset init_area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
			
			
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
			MUY IMPORTANTE: esto había que corregirlo para que aquí no se usara ni fuese necesaria la SESION
			
			<cfif ( (isDefined("SESSION.client_force_notifications") AND SESSION.client_force_notifications IS false) OR NOT isDefined("SESSION.client_force_notifications") ) AND isDefined("xmlRequest.request.parameters.preferences")>	

		--->

			<cfif selectClientQuery.force_notifications IS false AND isDefined("xmlRequest.request.parameters.preferences")>
				
				<cfxml variable="xmlPreferences">
					<cfoutput>#xmlRequest.request.parameters.preferences#</cfoutput>
				</cfxml>
				
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_message")>
					<cfset notify_new_message = xmlPreferences.preferences.xmlAttributes.notify_new_message>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_file")>
					<cfset notify_new_file = xmlPreferences.preferences.xmlAttributes.notify_new_file>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_replace_file")>
					<cfset notify_replace_file = xmlPreferences.preferences.xmlAttributes.notify_replace_file>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_area")>
					<cfset notify_new_area = xmlPreferences.preferences.xmlAttributes.notify_new_area>
				</cfif>
				
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_entry")>
					<cfset notify_new_entry = xmlPreferences.preferences.xmlAttributes.notify_new_entry>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_link")>
					<cfset notify_new_link = xmlPreferences.preferences.xmlAttributes.notify_new_link>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_news")>
					<cfset notify_new_news = xmlPreferences.preferences.xmlAttributes.notify_new_news>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_event")>
					<cfset notify_new_event = xmlPreferences.preferences.xmlAttributes.notify_new_event>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_task")>
					<cfset notify_new_task = xmlPreferences.preferences.xmlAttributes.notify_new_task>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_consultation")>
					<cfset notify_new_consultation = xmlPreferences.preferences.xmlAttributes.notify_new_consultation>
				</cfif>

				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_image")>
					<cfset notify_new_image = xmlPreferences.preferences.xmlAttributes.notify_new_image>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_typology")>
					<cfset notify_new_typology = xmlPreferences.preferences.xmlAttributes.notify_new_typology>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_list")>
					<cfset notify_new_list = xmlPreferences.preferences.xmlAttributes.notify_new_list>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_list_row")>
					<cfset notify_new_list_row = xmlPreferences.preferences.xmlAttributes.notify_new_list_row>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_list_view")>
					<cfset notify_new_list_view = xmlPreferences.preferences.xmlAttributes.notify_new_list_view>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_form")>
					<cfset notify_new_form = xmlPreferences.preferences.xmlAttributes.notify_new_form>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_form_row")>
					<cfset notify_new_form_row = xmlPreferences.preferences.xmlAttributes.notify_new_form_row>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_form_view")>
					<cfset notify_new_form_view = xmlPreferences.preferences.xmlAttributes.notify_new_form_view>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_pubmed")>
					<cfset notify_new_pubmed = xmlPreferences.preferences.xmlAttributes.notify_new_pubmed>
				</cfif>

				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_delete_file")>
					<cfset notify_delete_file = xmlPreferences.preferences.xmlAttributes.notify_delete_file>
				</cfif>
				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_lock_file")>
					<cfset notify_lock_file = xmlPreferences.preferences.xmlAttributes.notify_lock_file>
				</cfif>

				<cfif isDefined("xmlPreferences.preferences.xmlAttributes.notify_new_user_in_area")>
					<cfset notify_new_user_in_area = xmlPreferences.preferences.xmlAttributes.notify_new_user_in_area>
				</cfif>
				
			</cfif>
			
			<cfinvoke component="UserManager" method="getAreaUsers" returnvariable="returnArrays">
				<cfinvokeargument name="area_id" value="#init_area_id#">
				<cfinvokeargument name="areasArray" value="#areasArray#">
				<cfinvokeargument name="include_user_log_in" value="true">
				<cfinvokeargument name="get_orientation" value="asc">
				<cfinvokeargument name="notify_new_message" value="#notify_new_message#">
				<cfinvokeargument name="notify_new_file" value="#notify_new_file#">
				<cfinvokeargument name="notify_replace_file" value="#notify_replace_file#">
				<cfinvokeargument name="notify_new_area" value="#notify_new_area#">
				
				<cfinvokeargument name="notify_new_entry" value="#notify_new_entry#">
				<cfinvokeargument name="notify_new_link" value="#notify_new_link#">	
				<cfinvokeargument name="notify_new_news" value="#notify_new_news#">
				<cfinvokeargument name="notify_new_event" value="#notify_new_event#">
				<cfinvokeargument name="notify_new_task" value="#notify_new_task#">	
				<cfinvokeargument name="notify_new_consultation" value="#notify_new_consultation#">

				<cfinvokeargument name="notify_new_image" value="#notify_new_image#">
				<cfinvokeargument name="notify_new_typology" value="#notify_new_typology#">
				<cfinvokeargument name="notify_new_list" value="#notify_new_list#">
				<cfinvokeargument name="notify_new_list_row" value="#notify_new_list_row#">
				<cfinvokeargument name="notify_new_list_view" value="#notify_new_list_view#">
				<cfinvokeargument name="notify_new_form" value="#notify_new_form#">
				<cfinvokeargument name="notify_new_form_row" value="#notify_new_form_row#">
				<cfinvokeargument name="notify_new_form_view" value="#notify_new_form_view#">
				<cfinvokeargument name="notify_new_pubmed" value="#notify_new_pubmed#">

				<cfinvokeargument name="notify_delete_file" value="#notify_delete_file#">
				<cfinvokeargument name="notify_lock_file" value="#notify_lock_file#">

				<cfinvokeargument name="notify_new_user_in_area" value="#notify_new_user_in_area#">

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
	
	<cffunction name="getAreaUsers" returntype="struct" output="false" access="public">
		<cfargument name="area_id" type="string" required="yes">
		<cfargument name="areasArray" type="array" required="yes">
		<cfargument name="include_user_log_in" type="boolean" required="no" default="false">
		<cfargument name="get_orientation" type="string" required="no" default="desc">
		
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

		<cfargument name="notify_delete_file" type="string" required="false" default="">
		<cfargument name="notify_lock_file" type="string" required="false" default="">

		<cfargument name="notify_new_user_in_area" type="string" required="false" default="">
		
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
					FROM #client_abb#_users AS u
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
					
					<cfif arguments.notify_new_user_in_area NEQ "">
					AND u.notify_new_user_in_area = <cfqueryparam value="#arguments.notify_new_user_in_area#" cfsqltype="cf_sql_bit">
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



</cfcomponent>
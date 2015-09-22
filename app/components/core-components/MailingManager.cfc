<!---Copyright Era7 Information Technologies 2007-2015--->
<cfcomponent output="false">

	<cfset component = "MailingManager">

	<cfset dateFormat = "%d-%m-%Y">

	<cfset langText = structNew()><!---Almacena los textos de los idiomas--->

	<cfinvoke component="#APPLICATION.coreComponentsPath#/Language" method="chargeLangText" returnvariable="langText">
		<cfinvokeargument name="filePath" value="#APPLICATION.componentsPath#/language/AlertManager.cfm">
	</cfinvoke>


	<!--- -------------------------------------- sendMailing ----------------------------------- --->

	<cffunction name="sendMailing" access="public" returntype="void">
		<cfargument name="objectItem" type="query" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="itemCategories" type="query" required="false">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="send_to_area_users" type="boolean" required="false">
		<cfargument name="send_to_test_users" type="boolean" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "sendMailing">

		<cfset var internalUsersEmails = structNew()>
		<cfset var externalUsersEmails = structNew()>
    <cfset var listInternalUsers = "">
		<cfset var listExternalUsers = "">

		<cfset var internalUsersPhones = "">
		<cfset var externalUsersPhones = "">
		<cfset var listInternalUsersPhones = "">
		<cfset var listExternalUsersPhones = "">

		<cfset var subject = "">
		<cfset var access_content = "">
		<cfset var alertItemHead = "">
		<cfset var alertContent = "">

		<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

		<cfif objectItem.recordCount IS 0><!---Item not found--->

			<cfset error_code = 501>

			<cfthrow errorcode="#error_code#">

		</cfif>

		<!--- getClient --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
			<cfinvokeargument name="client_abb" value="#client_abb#">
		</cfinvoke>

		<cfset var clientAppTitle = clientQuery.app_title>

		<!---Get area name--->
		<cfquery name="selectAreaQuery" datasource="#client_dsn#">
			SELECT id, name
			FROM #client_abb#_areas
			WHERE id = <cfqueryparam value="#objectItem.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		<cfif selectAreaQuery.recordCount IS 0>

			<cfset error_code = 301>

			<cfthrow errorcode="#error_code#">

		</cfif>


		<cfif arguments.send_to_area_users IS true>

			<!--- getItemCategories --->
			<cfif NOT isDefined("arguments.itemCategories")>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItemCategories" returnvariable="itemCategories">
					<cfinvokeargument name="item_id" value="#objectItem.id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

			</cfif>

	    <!--- getUsersToNotifyLists --->
	    <cfinvoke component="UserManager" method="getUsersToNotifyLists" returnvariable="usersToNotifyLists">
				<cfinvokeargument name="area_id" value="#objectItem.area_id#">
				<cfinvokeargument name="notify_new_#itemTypeName#" value="true">

				<cfif itemCategories.recordCount GT 0>
					<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
					<cfinvokeargument name="categories_ids" value="#valueList(itemCategories.category_id)#">
				</cfif>

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfset internalUsersEmails = usersToNotifyLists.structInternalUsersEmails>
			<cfset externalUsersEmails = usersToNotifyLists.structExternalUsersEmails>

		<cfelse>

			<cfloop list="#APPLICATION.languages#" index="curLang">

				<cfset internalUsersEmails[curLang] = "">
				<cfset externalUsersEmails[curLang] = "">

			</cfloop>

		</cfif>

		<cfif arguments.send_to_test_users IS true AND listLen(objectItem.email_addresses) GT 0>

			<cfset listInternalUsers = internalUsersEmails[clientQuery.default_language]>

			<cfloop list="#objectItem.email_addresses#" index="curTestAddress" delimiters=";">

				<cfif listFind(listInternalUsers, curTestAddress, ";") IS 0>
						<cfset listInternalUsers = ListAppend(listInternalUsers, curTestAddress, ";")>
				</cfif>

			</cfloop>

			<cfset internalUsersEmails[clientQuery.default_language] = listInternalUsers>

		</cfif>


		<cfloop list="#APPLICATION.languages#" index="curLang">

			<cfset listInternalUsers = internalUsersEmails[curLang]>
			<cfset listExternalUsers = externalUsersEmails[curLang]>

			<cfif len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0><!---Si hay usuarios a los que notificar--->

				<cfset head_content = objectItem.head_content>

				<cfsavecontent variable="foot_content">
				<cfoutput>
				 <p style="font-family:'Roboto', sans-serif; font-size:12px;">

						<a href="#APPLICATION.mainUrl#/login/unsubscribe.cfm?user=#arguments.user_id#&mailing=#objectItem.id#">#langText[curLang].mailing.unsubscribe_mailing#</a>

				 </p>
				</cfoutput>
				</cfsavecontent>

				<cfsavecontent variable="alertContent">
					<cfoutput>
					<div style="#objectItem.content_styles#">
					#objectItem.head_content#
					#objectItem.description#
					#objectItem.foot_content#
					</div>
					</cfoutput>
				</cfsavecontent>


				<!---INTERNAL USERS--->
				<cfif len(listInternalUsers) GT 0>

					<cfset subjectInternal = objectItem.title>

					<cfsavecontent variable="contentInternal">
					<cfoutput>

			#alertContent#

					</cfoutput>
					</cfsavecontent>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
						<cfinvokeargument name="from_name" value="#clientAppTitle#">
						<cfif listLen(listInternalUsers,";") GT 1>
							<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
							<cfinvokeargument name="bcc" value="#listInternalUsers#">
						<cfelse>
							<cfinvokeargument name="to" value="#listInternalUsers#">
						</cfif>
						<cfinvokeargument name="subject" value="#subjectInternal#">
						<cfinvokeargument name="content" value="#contentInternal#">
						<cfinvokeargument name="foot_content" value="#foot_content#">

						<cfif ( arguments.itemTypeId EQ 5 OR arguments.itemTypeId EQ 6 ) AND len(icalendarContent) GT 0>

							<cfinvokeargument name="attachment_type" value="text/calendar">
							<cfinvokeargument name="attachment_name" value="#itemTypeName#_#objectItem.id#.ics">
							<cfinvokeargument name="attachment_content" value="#icalendarContent#">

						</cfif>
					</cfinvoke>


				</cfif>

				<!---EXTERNAL USERS--->
				<cfif len(listExternalUsers) GT 0>

					<cfset subjectExternal = objectItem.title>

					<cfsavecontent variable="contentExternal">
					<cfoutput>

			#alertContent#

					</cfoutput>
					</cfsavecontent>


					<cfinvoke component="#APPLICATION.coreComponentsPath#/EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
						<cfinvokeargument name="from_name" value="#clientAppTitle#">
						<cfif listLen(listExternalUsers,";") GT 1>
							<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
							<cfinvokeargument name="bcc" value="#listExternalUsers#">
						<cfelse>
							<cfinvokeargument name="to" value="#listExternalUsers#">
						</cfif>
						<cfinvokeargument name="subject" value="#subjectExternal#">
						<cfinvokeargument name="content" value="#contentExternal#">
						<cfinvokeargument name="foot_content" value="#foot_content#">

						<cfif ( arguments.itemTypeId EQ 5 OR arguments.itemTypeId EQ 6 ) AND len(icalendarContent) GT 0>

							<cfinvokeargument name="attachment_type" value="text/calendar">
							<cfinvokeargument name="attachment_name" value="#itemTypeName#_#objectItem.id#.ics">
							<cfinvokeargument name="attachment_content" value="#icalendarContent#">

						</cfif>
					</cfinvoke>


				</cfif>

			</cfif><!---END len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0--->


		</cfloop><!---END APPLICATION.languages loop--->


	</cffunction>


	<!--- --------------------------- getMailingFootContent --------------------------- --->

	<!---<cffunction name="getMailingFootContent" access="private" returntype="string">
		<cfargument name="language" type="string" required="true">
		<cfargument name="user_id" type="numeric" required="true">

		<cfset var method = "getItemFootContent">

		<cfset var footContent = "">

		<cfsavecontent variable="footContent"><cfoutput>
			<p style="font-family:'Roboto', sans-serif; font-size:10px;"><span style="font-size:12px;">#langText[arguments.language].mailing.foot_content#.</span></p>
		</cfoutput>
		</cfsavecontent>

		<cfreturn footContent>

	</cffunction>--->

</cfcomponent>

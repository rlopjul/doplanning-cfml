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
		<cfargument name="action" type="string" required="yes">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "sendMailing">

		<cfset var internalUsersEmails = "">
		<cfset var externalUsersEmails = "">
    <cfset var listInternalUsers = "">
		<cfset var listExternalUsers = "">

		<cfset var internalUsersPhones = "">
		<cfset var externalUsersPhones = "">
		<cfset var listInternalUsersPhones = "">
		<cfset var listExternalUsersPhones = "">

		<cfset var subject = "">
		<cfset var area_name = "">
		<cfset var area_path = "">
    <cfset var root_area = structNew()>
		<cfset var access_content = "">
		<cfset var sms_message = "">
		<cfset var alertItemHead = "">
		<cfset var alertContent = "">
		<cfset var actionUser = "">
		<cfset var actionUserName = "">
		<cfset var icalendarContent = "">

		<cfset var includeItemContent = true>

		<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

		<cfif objectItem.recordCount IS 0><!---Item not found--->

			<cfset error_code = 501>

			<cfthrow errorcode="#error_code#">

		</cfif>

		<cfif arguments.itemTypeId IS 7><!---Consultations--->
			<!---<cfset includeItemContent = false>--->
			<cfif isDefined("APPLICATION.includeConsultationsInAlerts")>
				<cfset includeItemContent = APPLICATION.includeConsultationsInAlerts>
			<cfelse>
				<cfset includeItemContent = false>
			</cfif>
		</cfif>

		<cfif len(objectItem.description) GT 0>
			<!---Para solucionar problema con Flex--->
			<cfset objectItem.description = REReplace(objectItem.description,'[[:space:]]SIZE="',' style="font-size:',"ALL")>
			<!---<cfset objectItem.description = Replace(objectItem.description,' SIZE="',' style="font-size:',"ALL")>--->
		</cfif>


		<!---Get area name--->
		<cfquery name="selectAreaQuery" datasource="#client_dsn#">
			SELECT id, name
			FROM #client_abb#_areas
			WHERE id = <cfqueryparam value="#objectItem.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		<cfif selectAreaQuery.recordCount GT 0>

			<cfset area_name = selectAreaQuery.name>

		<cfelse><!---The area does not exist--->

			<cfset error_code = 301>

			<cfthrow errorcode="#error_code#">

		</cfif>

		<cfif arguments.itemTypeId LT 10>

			<!---fileDownloadUrl--->
			<cfif isNumeric(objectItem.attached_file_id) AND objectItem.attached_file_id GT 0>
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getDownloadFileUrl" returnvariable="downloadFileUrl">
					<cfinvokeargument name="file_id" value="#objectItem.attached_file_id#">
					<cfinvokeargument name="fileTypeId" value="1">
					<cfinvokeargument name="item_id" value="#objectItem.id#">
					<cfinvokeargument name="itemTypeName" value="#itemTypeName#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				</cfinvoke>
			</cfif>

			<!---imageDownloadUrl--->
			<cfif arguments.itemTypeId IS NOT 1 AND isNumeric(objectItem.attached_image_id) AND objectItem.attached_image_id GT 0>
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getDownloadFileUrl" returnvariable="downloadImageUrl">
					<cfinvokeargument name="file_id" value="#objectItem.attached_image_id#">
					<cfinvokeargument name="fileTypeId" value="1">
					<cfinvokeargument name="item_id" value="#objectItem.id#">
					<cfinvokeargument name="itemTypeName" value="#itemTypeName#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				</cfinvoke>
			</cfif>

		</cfif>

		<!--- icalendarContent --->
		<cfif ( arguments.itemTypeId IS 5 OR arguments.itemTypeId IS 6 ) AND includeItemContent IS true AND arguments.action NEQ "delete"><!--- Event OR Task --->

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="exportICalendarItem" returnvariable="exportICalendarItemResponse">
				<cfinvokeargument name="item_id" value="#objectItem.id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<!---<cfinvokeargument name="itemQuery" value="#objectItem#">--->

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfset icalendarContent = exportICalendarItemResponse.icalendar>

		</cfif>

		<!--- getItemCategories --->
		<cfif NOT isDefined("arguments.itemCategories")>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItemCategories" returnvariable="itemCategories">
				<cfinvokeargument name="item_id" value="#objectItem.id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

		</cfif>


		<!---getRootArea--->
		<cfinvoke component="AreaQuery" method="getRootArea" returnvariable="root_area">
			<cfinvokeargument name="onlyId" value="false">
			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
		</cfinvoke>
		<!---En el asunto se pone el nombre del área raiz--->

    <!--- getUsersToNotifyLists --->
    <cfinvoke component="UserManager" method="getUsersToNotifyLists" returnvariable="usersToNotifyLists">
			<!---<cfinvokeargument name="request" value="#getUsersRequest#"/>--->
			<cfinvokeargument name="area_id" value="#objectItem.area_id#">
			<cfif arguments.action NEQ "attached_file_deleted_virus" AND arguments.action NEQ "attached_image_deleted_virus">
				<cfinvokeargument name="notify_new_#itemTypeName#" value="true">
			</cfif>

			<cfif itemCategories.recordCount GT 0>
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
				<cfinvokeargument name="categories_ids" value="#valueList(itemCategories.category_id)#">
			</cfif>

			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
		</cfinvoke>

		<cfset internalUsersEmails = usersToNotifyLists.structInternalUsersEmails>
		<cfset externalUsersEmails = usersToNotifyLists.structExternalUsersEmails>

		<cfset internalUsersPhones = usersToNotifyLists.structInternalUsersPhones>
		<cfset externalUsersPhones = usersToNotifyLists.structExternalUsersPhones>

		<cfloop list="#APPLICATION.languages#" index="curLang">

			<cfset listInternalUsers = internalUsersEmails[curLang]>
			<cfset listExternalUsers = externalUsersEmails[curLang]>

			<cfset listInternalUsersPhones = internalUsersPhones[curLang]>
			<cfset listExternalUsersPhones = externalUsersPhones[curLang]>

			<cfif len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0><!---Si hay usuarios a los que notificar--->

				<!--- getAreaItemUrl --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaItemUrl" returnvariable="areaItemUrl">
					<cfinvokeargument name="item_id" value="#objectItem.id#">
					<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
					<cfinvokeargument name="area_id" value="#objectItem.area_id#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				</cfinvoke>
				
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
					#objectItem.description#
					</div>
					#objectItem.foot_content#
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
						<!--- <cfinvokeargument name="from" value="#SESSION.client_email_from#"> --->
						<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
						<cfif arguments.action NEQ "attached_file_deleted_virus" AND arguments.action NEQ "attached_image_deleted_virus">
							<cfinvokeargument name="from_name" value="#actionUserName#">
						</cfif>
						<cfif listLen(listInternalUsers,";") GT 1>
							<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
							<cfinvokeargument name="bcc" value="#listInternalUsers#">
						<cfelse>
							<cfinvokeargument name="to" value="#listInternalUsers#">
						</cfif>
						<cfinvokeargument name="subject" value="#subjectInternal#">
						<cfinvokeargument name="content" value="#contentInternal#">
						<cfinvokeargument name="head_content" value="#head_content#">
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
						<!--- <cfinvokeargument name="from" value="#SESSION.client_email_from#"> --->
						<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
						<cfif arguments.action NEQ "attached_file_deleted_virus" AND arguments.action NEQ "attached_image_deleted_virus">
							<cfinvokeargument name="from_name" value="#actionUserName#">
						</cfif>
						<cfif listLen(listExternalUsers,";") GT 1>
							<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
							<cfinvokeargument name="bcc" value="#listExternalUsers#">
						<cfelse>
							<cfinvokeargument name="to" value="#listExternalUsers#">
						</cfif>
						<cfinvokeargument name="subject" value="#subjectExternal#">
						<cfinvokeargument name="content" value="#contentExternal#">
						<cfinvokeargument name="head_content" value="#head_content#">
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

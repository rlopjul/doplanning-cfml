<!---Copyright Era7 Information Technologies 2007-2014--->
<cfcomponent output="false">

	<cfset component = "AlertManager">

	<cfset dateFormat = "%d-%m-%Y">

	<cfinclude template="#APPLICATION.componentsPath#/includes/loadLangText.cfm">


	<!--- --------------------------- getItemAccessContent --------------------------- --->
	
	<cffunction name="getItemAccessContent" access="private" returntype="string">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="language" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<!---<cfargument name="client_dsn" type="string" required="true">--->
 				
		<cfset var method = "getItemAccessContent">

		<cfset var accessContent = "">

		<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

		<!---itemUrl--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaItemUrl" returnvariable="areaItemUrl">
			<cfinvokeargument name="item_id" value="#arguments.item_id#">
			<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
			<cfinvokeargument name="area_id" value="#arguments.area_id#">

			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
		</cfinvoke>

		<cfif APPLICATION.twoUrlsToAccess IS false>
					
			<cfsavecontent variable="accessContent">
			<cfoutput>
			<cfif itemTypeId EQ 1 OR itemTypeId EQ 7><!--- Messages or Interconsultations --->
				-&nbsp;<b>#langText[arguments.language].new_item.access_to_reply#</b> <a target="_blank" href="#areaItemUrl#">#areaItemUrl#</a>

<!--- Google Go-To Action --->
<!--- 
<script type="application/ld+json">
{
"@context": "http://schema.org",
"@type": "EmailMessage",
"action": {
"@type": "ViewAction",
"url": "#areaItemUrl#"
},
"description": "#langText[arguments.language].new_item.reply_in# #APPLICATION.title#"
}
</script> --->


			<cfelse>
				-&nbsp;<cfif itemTypeGender EQ "male">#langText[arguments.language].new_item.access_to_item_male#<cfelse>#langText[arguments.language].new_item.access_to_item_female#</cfif> #langText[arguments.language].item[itemTypeId].name# #langText[arguments.language].new_item.access_to_item_link#: <a target="_blank" href="#areaItemUrl#">#areaItemUrl#</a>
			</cfif>					

			<cfif isDefined("SESSION.client_id")>
				<br/>-&nbsp;#langText[arguments.language].common.access_to_application#:
			<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#">#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#</a>
			</cfif>
			
			</cfoutput>
			</cfsavecontent>
			
			
		<cfelse><!---VPNET/AGSNA--->
		
			<cfsavecontent variable="accessContent">
			<cfoutput>
				<cfif itemTypeId EQ 1 OR itemTypeId EQ 7><!--- Messages or Interconsultations --->
					<b>#langText[arguments.language].new_item.access_to_reply#</b>:
				<cfelse>
					<cfif itemTypeGender EQ "male">#langText[arguments.language].new_item.access_to_item_male#
					<cfelse>#langText[arguments.language].new_item.access_to_item_female#</cfif> #langText[arguments.language].item[itemTypeId].name# #langText[arguments.language].new_item.access_to_item_links#:
				</cfif><br/>
			<!----&nbsp;Acceso interno <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#itemTypeName#.cfm?#itemTypeName#=#arguments.item_id#&abb=#SESSION.client_abb#">#APPLICATION.mainUrl##APPLICATION.path#/#itemTypeName#.cfm?#itemTypeName#=#arguments.item_id#&abb=#SESSION.client_abb#</a><br/>
			-&nbsp;Acceso externo <a target="_blank" href="#APPLICATION.alternateUrl##itemTypeName#.cfm?#itemTypeName#=#arguments.item_id#&abb=#SESSION.client_abb#">#APPLICATION.alternateUrl##itemTypeName#.cfm?#itemTypeName#=#arguments.item_id#&abb=#SESSION.client_abb#</a>--->
			-&nbsp;#langText[arguments.language].common.access_internal# <a target="_blank" href="#areaItemUrl#">#areaItemUrl#</a><br/>
			-&nbsp;#langText[arguments.language].common.access_external#  <a target="_blank" href="#APPLICATION.alternateUrl#/?abb=#SESSION.client_abb#&area=#arguments.area_id#&#itemTypeName#=#arguments.item_id#">#APPLICATION.alternateUrl#/?abb=#SESSION.client_abb#&area=#arguments.area_id#&#itemTypeName#=#arguments.item_id#</a>
			</cfoutput>
			</cfsavecontent>
			
			
			<!---<cfset access_default = '<br/><br/>Puede contestar al mensaje accediendo a la aplicación a través de: '>
		
			<cfsavecontent variable="access_content">
			<cfoutput>
			#access_default#<br/>
			-&nbsp;Acceso interno <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/">#APPLICATION.mainUrl##APPLICATION.path#/</a><br/>
			-&nbsp;Acceso externo <a target="_blank" href="#APPLICATION.alternateUrl#">#APPLICATION.alternateUrl#</a>
			</cfoutput>
			</cfsavecontent>--->	
		</cfif>
		
		<cfreturn accessContent>

	</cffunction>


	<!--- --------------------------- getTableRowAccessContent --------------------------- --->
	
	<cffunction name="getTableRowAccessContent" access="private" returntype="string">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="language" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">
 				
		<cfset var method = "getRowAccessContent">

		<cfset var accessContent = "">

		<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

		<!---itemUrl--->
		<!---<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaItemUrl" returnvariable="areaItemUrl">
			<cfinvokeargument name="item_id" value="#arguments.item_id#">
			<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
			<cfinvokeargument name="area_id" value="#arguments.area_id#">

			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
		</cfinvoke>--->

		<!---tableRowUrl--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getTableRowUrl" returnvariable="tableRowUrl">
			<cfinvokeargument name="table_id" value="#arguments.item_id#">
			<cfinvokeargument name="tableTypeName" value="#itemTypeName#">
			<cfinvokeargument name="row_id" value="#arguments.row_id#">
			<cfinvokeargument name="area_id" value="#arguments.area_id#">

			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
		</cfinvoke>

		<cfif APPLICATION.twoUrlsToAccess IS false>
					
			<cfsavecontent variable="accessContent">
			<cfoutput>
			
			-&nbsp;<cfif itemTypeGender EQ "male">#langText[arguments.language].new_table_row.access_to_row_male#<cfelse>#langText[arguments.language].new_table_row.access_to_row_female#</cfif> #langText[arguments.language].item[itemTypeId].name# #langText[arguments.language].new_item.access_to_item_link#:<br/><a target="_blank" href="#tableRowUrl#">#tableRowUrl#</a>

			<cfif isDefined("SESSION.client_id")>
				<br/>-&nbsp;#langText[arguments.language].common.access_to_application#:
			<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#">#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#</a>
			</cfif>
			
			</cfoutput>
			</cfsavecontent>
			
			
		<cfelse><!---VPNET/AGSNA--->
		
			<cfsavecontent variable="accessContent">
			<cfoutput>

				<cfif itemTypeGender EQ "male">#langText[arguments.language].new_table_row.access_to_row_male#
				<cfelse>#langText[arguments.language].new_table_row.access_to_row_female#</cfif> #langText[arguments.language].item[itemTypeId].name# #langText[arguments.language].new_item.access_to_item_links#:
				<br/>
			-&nbsp;#langText[arguments.language].common.access_internal# <a target="_blank" href="#tableRowUrl#">#tableRowUrl#</a><br/>
			-&nbsp;#langText[arguments.language].common.access_external#  <a target="_blank" href="#APPLICATION.alternateUrl#/?abb=#SESSION.client_abb#&area=#arguments.area_id#&#itemTypeName#=#arguments.item_id#&row=#arguments.row_id#">#APPLICATION.alternateUrl#/?abb=#SESSION.client_abb#&area=#arguments.area_id#&#itemTypeName#=#arguments.item_id#&row=#arguments.row_id#</a>
			</cfoutput>
			</cfsavecontent>
		</cfif>
		
		<cfreturn accessContent>

	</cffunction>



	<!--- --------------------------- getItemFootContent --------------------------- --->
	
	<cffunction name="getItemFootContent" access="private" returntype="string">
		<cfargument name="language" type="string" required="true">
 				
		<cfset var method = "getItemFootContent">

		<cfset var footContent = "">

		<cfset footContent = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;"><span style="color:##FF0000; font-size:12px;">#langText[arguments.language].common.foot_do_not_reply#.</span><br/>#langText[arguments.language].common.foot_content_default_1# #APPLICATION.title# #langText[arguments.language].new_item.foot_content_2# #APPLICATION.title#.<br />#langText[arguments.language].new_item.foot_content_3#.</p>'>
		
		<cfreturn footContent>

	</cffunction>
	


	<!--- -------------------------------------- newTableRow ------------------------------------ --->
	
	<cffunction name="newTableRow" access="public" returntype="void">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="false">
		<cfargument name="action" type="string" required="true"><!---create/modify/delete--->

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">	
				
		<cfset var method = "newTableRow">
		
		<cfset var internalUsersEmails = "">
		<cfset var externalUsersEmails = "">
        <cfset var listInternalUsers = "">
		<cfset var listExternalUsers = "">
		<cfset var area_id = "">
		<cfset var area_name = "">
		<cfset var area_path = "">
        <cfset var root_area = "">
		<cfset var access_content = "">
		<cfset var foot_content = "">
		<cfset var alertContent = "">
		<cfset var actionUserName = "">
		
		<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

		<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTable" returnvariable="getTableQuery">
			<cfinvokeargument name="table_id" value="#arguments.table_id#">
			<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			<cfinvokeargument name="parse_dates" value="true">
			<cfinvokeargument name="published" value="false">			
			
			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<cfif getTableQuery.recordCount GT 0>

			<cfset area_id = getTableQuery.area_id>

		<cfelse><!---Item does not exist--->
		
			<cfset error_code = 501>
		
			<cfthrow errorcode="#error_code#">

		</cfif>

		<!---Get area name--->
		<cfquery name="selectAreaQuery" datasource="#client_dsn#">
			SELECT id, name 
			FROM #client_abb#_areas
			WHERE id = <cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif selectAreaQuery.recordCount GT 0>
		
			<cfset area_name = selectAreaQuery.name>
			
		<cfelse><!---The area does not exist--->
			
			<cfset error_code = 301>
			
			<cfthrow errorcode="#error_code#">
		
		</cfif>
		
		<cfinvoke component="AreaQuery" method="getRootArea" returnvariable="root_area">
			<cfinvokeargument name="onlyId" value="false">
			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
		</cfinvoke>
		<!---En el asunto se pone el nombre del área raiz--->
		
		<cfsavecontent variable="getUsersParameters">
			<cfoutput>
				 <user id="" email=""	
			telephone=""		
			sms_allowed="" whole_tree_visible="">
					<family_name><![CDATA[]]></family_name>
					<name><![CDATA[]]></name>	
				</user>
				<area id="#area_id#"/> 
				<order parameter="family_name" order_type="asc" />
				<preferences 
					notify_new_#tableTypeName#_row="true">				
				</preferences>
			</cfoutput>
		</cfsavecontent>
		
		<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="createRequest" returnvariable="getUsersRequest">
			<cfinvokeargument name="request_parameters" value="#getUsersParameters#">
		</cfinvoke>
        
        <cfinvoke component="UserManager" method="getUsersToNotifyLists" returnvariable="usersToNotifyLists">
			<cfinvokeargument name="request" value="#getUsersRequest#"/>

			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
		</cfinvoke>
		
		<cfset internalUsersEmails = usersToNotifyLists.structInternalUsersEmails>
		<cfset externalUsersEmails = usersToNotifyLists.structExternalUsersEmails>

		<cfif isDefined("arguments.user_id")>
			<cfinvoke component="UserQuery" method="getUser" returnvariable="actionUserQuery">
				<cfinvokeargument name="user_id" value="#arguments.user_id#">
				<cfinvokeargument name="format_content" value="default">
				<cfinvokeargument name="with_ldap" value="false">
				<cfinvokeargument name="with_vpnet" value="false">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfset actionUserName = actionUserQuery.user_full_name>
		</cfif>
		
		<cfloop list="#APPLICATION.languages#" index="curLang">
		
			<cfset listInternalUsers = internalUsersEmails[curLang]>
			<cfset listExternalUsers = externalUsersEmails[curLang]>
		
			<cfif len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0><!---Si hay usuarios a los que notificar--->
				
				<cfswitch expression="#arguments.action#">
					<cfcase value="create">
						<cfset subject_action = "#langText[curLang].new_table_row.new_row# #langText[curLang].item[itemTypeId].name#">
						<!---<cfset action_value = langText[curLang].new_file.created>--->
					</cfcase>

					<cfcase value="modify">
						<cfset subject_action = "#langText[curLang].new_table_row.modify_row# #langText[curLang].item[itemTypeId].name#">
					</cfcase>

					<cfcase value="delete">
						<cfset subject_action = "#langText[curLang].new_table_row.delete_row# #langText[curLang].item[itemTypeId].name#">
					</cfcase>
				</cfswitch>

				<cfset subject = "[#root_area.name#][#subject_action#] "&getTableQuery.title>

				<cfif arguments.action NEQ "delete">
					
					<cfinvoke component="AlertManager" method="getTableRowAccessContent" returnvariable="access_content">
						<cfinvokeargument name="item_id" value="#arguments.table_id#"/>
						<cfinvokeargument name="itemTypeId" value="#itemTypeId#"/>
						<cfinvokeargument name="row_id" value="#arguments.row_id#"/>
						<cfinvokeargument name="area_id" value="#area_id#"/>
						<cfinvokeargument name="language" value="#curLang#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					</cfinvoke>

				</cfif>

				<cfinvoke component="AlertManager" method="getItemFootContent" returnvariable="foot_content">
					<cfinvokeargument name="language" value="#curLang#">
				</cfinvoke>				

				<cfsavecontent variable="alertContent">
					<cfoutput>
						#subject_action#: <strong style="font-size:14px;">#getTableQuery.title#</strong><br/>
						#langText[curLang].new_table_row.register_number#: #arguments.row_id#<br/>
						<cfif len(actionUserName) GT 0>
							#langText[curLang].common.user#: <strong>#actionUserName#</strong><br/>
						</cfif>
						<!---#langText[curLang].new_item.creation_date#: <strong>#objectItem.creation_date#</strong><br/>--->
						
					<cfif len(access_content) GT 0>
						<br/>
						<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>
					</cfif>
					</cfoutput>
				</cfsavecontent>
				
				<!---INTERNAL USERS--->
				<cfif len(listInternalUsers) GT 0>
					
					<cfinvoke component="AreaQuery" method="getAreaPath" returnvariable="area_path">
						<cfinvokeargument name="area_id" value="#area_id#">
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>
					
					<cfprocessingdirective suppresswhitespace="true">
					<cfsavecontent variable="contentInternal">
					<cfoutput>
			<!--- #langText[curLang].new_file.it_has# #action_value# #langText[curLang].new_file.a_file_on_the_area# --->#langText[curLang].common.area#: <strong>#area_name#</strong>.<br/>
			#langText[curLang].common.area_path#: #area_path#.<br/><br/>
			
			#alertContent#
					</cfoutput>
					</cfsavecontent>
					</cfprocessingdirective>				
				
					<cfinvoke component="#APPLICATION.componentsPath#/EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
						<cfif len(actionUserName) GT 0>
							<cfinvokeargument name="from_name" value="#actionUserName#">
						</cfif>
						<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
						<cfinvokeargument name="bcc" value="#listInternalUsers#">
						<cfinvokeargument name="subject" value="#subject#">
						<cfinvokeargument name="content" value="#contentInternal#">
						<cfinvokeargument name="foot_content" value="#foot_content#">
					</cfinvoke>
					
				</cfif>
				
		
				<!---EXTERNAL USERS--->
				<cfif len(listExternalUsers) GT 0>
					
					<cfprocessingdirective suppresswhitespace="true">
					<cfsavecontent variable="contentExternal">
					<cfoutput>
			<!--- #langText[curLang].new_file.it_has# #action_value# #langText[curLang].new_file.a_file_on_the_area# --->#langText[curLang].common.area#: <strong>#area_name#</strong> #langText[curLang].common.of_the_organization# #root_area.name#.<br/><br/>
			
			#alertContent#
					</cfoutput>
					</cfsavecontent>
					</cfprocessingdirective>				
				
					<cfinvoke component="#APPLICATION.componentsPath#/EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
						<cfif len(actionUserName) GT 0>
							<cfinvokeargument name="from_name" value="#actionUserName#">
						</cfif>
						<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
						<cfinvokeargument name="bcc" value="#listExternalUsers#">
						<cfinvokeargument name="subject" value="#subject#">
						<cfinvokeargument name="content" value="#contentExternal#">
						<cfinvokeargument name="foot_content" value="#foot_content#">
					</cfinvoke>		
						
				</cfif>
				
			</cfif><!---END len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0--->
			
		</cfloop><!---END APPLICATION.languages loop--->
		
	</cffunction>



	<!--- --------------------------- getTableFootContent --------------------------- --->
	
	<!---<cffunction name="getTableFootContent" access="private" returntype="string">
		<cfargument name="language" type="string" required="true">
 				
		<cfset var method = "getTableFootContent">

		<cfset var footContent = "">

		<cfset footContent = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;"><span style="color:##FF0000; font-size:12px;">#langText[arguments.language].common.foot_do_not_reply#.</span><br/>#langText[arguments.language].common.foot_content_default_1# #APPLICATION.title# #langText[arguments.language].new_item.foot_content_2# #APPLICATION.title#.<br />#langText[arguments.language].new_item.foot_content_3#.</p>'>
		
		<cfreturn footContent>

	</cffunction>--->


	<!--- -------------------------------------- sendDiaryAlerts ------------------------------------ --->
	
	<cffunction name="sendDiaryAlerts" output="false" access="public" returntype="void">

		<cfset var client_abb = "">
		<cfset var client_dsn = "">

		<cfset var nowDate = Now()>
		<cfset var todayDate = CreateDate( Year(nowDate), Month(nowDate), Day(nowDate) )>
		<cfset var todayDateFormatted = dateFormat(todayDate, APPLICATION.dateFormat)>
		<cfset var forceNotifications = "">
		<cfset var tasksReminderDays = "">
		<cfset var userAccessResult = "">
		<cfset var subject = "">

		<cftry>

			<cfinvoke component="ClientQuery" method="getClients" returnvariable="getClientsQuery">					
			</cfinvoke>

			<cfloop query="getClientsQuery">
				
				<cfif getClientsQuery.tasks_reminder_notifications IS true>

					<cfset client_abb = getClientsQuery.abbreviation>
					<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>

					<cftry>

						<!--- getAllUsers --->
						<cfinvoke component="UserQuery" method="getAllUsersWithPreferences" returnvariable="getAllUsersQuery">
							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

						<cfinvoke component="AreaQuery" method="getRootArea" returnvariable="rootArea">
							<cfinvokeargument name="onlyId" value="false">
							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>
						<!---En el asunto se pone el nombre del área raiz--->

						<cfset forceNotifications = getClientsQuery.force_notifications>
						<cfset tasksReminderDays = getClientsQuery.tasks_reminder_days>

						<cfloop query="getAllUsersQuery">

							<cfif getAllUsersQuery.enabled IS true AND len(getAllUsersQuery.email) GT 0>
								
								<cfset var curUserId = getAllUsersQuery.user_id>
								<cfset var curLang = getAllUsersQuery.language>
								<cfset var curUserEmail = getAllUsersQuery.email>

								<!--- Tasks Notifications --->
								<cfif getAllUsersQuery.notify_new_task IS true OR forceNotifications IS true>

									<cfset itemTypeId = 6>
									<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

									<!---<cfinvoke component="AreaManager" method="getAllUserAreasList" returnvariable="userAreasIds">
										<cfinvokeargument name="get_user_id" value="#curUserId#">

										<cfinvokeargument name="client_abb" value="#client_abb#">
										<cfinvokeargument name="client_dsn" value="#client_dsn#">
									</cfinvoke>

									<cfif listLen(userAreasIds) GT 0>--->
										
										<cfinvoke component="AreaItemQuery" method="getAreaItems" returnvariable="getAreaItemsResult">
											<!--- <cfinvokeargument name="areas_ids" value="#userAreasIds#"> --->
											<cfinvokeargument name="all_areas" value="true">
											<cfinvokeargument name="recipient_user" value="#curUserId#">
											<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
											<cfinvokeargument name="listFormat" value="true">
											<cfinvokeargument name="with_user" value="true">
											<cfinvokeargument name="with_area" value="true">
											<cfinvokeargument name="parse_dates" value="true"/>
											<cfinvokeargument name="done" value="false">
											
											<!--- 
											<cfif isDefined("arguments.from_date")>
											<cfinvokeargument name="from_date" value="#arguments.from_date#">
											</cfif>
											<cfif isDefined("arguments.end_date")>
											<cfinvokeargument name="end_date" value="#arguments.end_date#">
											</cfif> --->
											
											<cfinvokeargument name="published" value="false">
											
											<cfinvokeargument name="client_abb" value="#client_abb#">
											<cfinvokeargument name="client_dsn" value="#client_dsn#">
										</cfinvoke>

										<cfset var tasksQuery = getAreaItemsResult.query>

										<cfquery dbtype="query" name="expiredTasksQuery">
											SELECT *
											FROM tasksQuery
											WHERE end_date = <cfqueryparam value="#todayDateFormatted#" cfsqltype="cf_sql_varchar">;
										</cfquery>

										<cfif tasksReminderDays NEQ 0>
											
											<cfset futureDate = dateAdd("d", tasksReminderDays, todayDate)>
											<cfset futureDateFormatted = dateFormat(futureDate, APPLICATION.dateFormat)>

											<cfquery dbtype="query" name="futureTasksQuery">
												SELECT *
												FROM tasksQuery
												WHERE end_date = <cfqueryparam value="#futureDateFormatted#" cfsqltype="cf_sql_varchar">;
											</cfquery>
											
											<!---<cfdump var="#tasksQuery#">
											<cfdump var="#futureTasksQuery#">
											<cfoutput>
												#futureDate#<br/>
												#futureTasksQuery.recordCount#<br/>
											</cfoutput>--->											

										<cfelse>

											<cfset futureTasksQuery = queryNew("item_id")>

										</cfif>
										

										<cfif expiredTasksQuery.recordCount GT 0 OR futureTasksQuery.recordCount GT 0>
											
											<cfset var alertContent = "">
											<cfset var taskAlertContent = "">

											<cfif expiredTasksQuery.recordCount GT 0>
												
												<cfset var expiredTasksArray = arrayNew(1)>
												<cfinvoke component="Utils" method="queryToArray" returnvariable="expiredTasksArray">
													<cfinvokeargument name="data" value="#expiredTasksQuery#">
												</cfinvoke>		

												<cfset todayDateFormatted = dateFormat(todayDate, APPLICATION.dateFormat)>

												<cfset alertContent = '<span style="font-size:15px;">'&langText[curLang].tasks_reminder.tasks_expire_today&" #todayDateFormatted#:</span><br><br>">

												<cfloop array="#expiredTasksArray#" index="taskObject">

													<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaManager" method="canUserAccessToArea" returnvariable="userAreaAccessResult">
														<cfinvokeargument name="area_id" value="#taskObject.area_id#">
														<cfinvokeargument name="user_id" value="#curUserId#">

														<cfinvokeargument name="client_abb" value="#client_abb#">
														<cfinvokeargument name="client_dsn" value="#client_dsn#">
													</cfinvoke>

													<cfif userAreaAccessResult IS true>
														
														<cfinvoke component="AlertManager" method="getItemDiaryAlertContent" returnvariable="taskAlertContent">
															<cfinvokeargument name="item" value="#taskObject#">
															<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
															<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
															<cfinvokeargument name="language" value="#curLang#">

															<cfinvokeargument name="client_abb" value="#client_abb#">
														</cfinvoke>	

														<cfset alertContent = alertContent&taskAlertContent>

													</cfif>
													
												</cfloop>								
												
											</cfif>

											<cfif futureTasksQuery.recordCount GT 0>
												
												<cfset var futureTasksArray = arrayNew(1)>
												<cfinvoke component="Utils" method="queryToArray" returnvariable="futureTasksArray">
													<cfinvokeargument name="data" value="#futureTasksQuery#">
												</cfinvoke>		

												<cfif len(alertContent) GT 0>
													
													<cfset alertContent = alertContent&"<br>">

												</cfif>

												<cfset alertContent = alertContent&'<span style="font-size:15px;">'&langText[curLang].tasks_reminder.tasks_expire_days&" #tasksReminderDays# #langText[curLang].tasks_reminder.days#:</span><br><br>">

												<cfloop array="#futureTasksArray#" index="taskObject">

													<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaManager" method="canUserAccessToArea" returnvariable="userAreaAccessResult">
														<cfinvokeargument name="area_id" value="#taskObject.area_id#">
														<cfinvokeargument name="user_id" value="#curUserId#">
														
														<cfinvokeargument name="client_abb" value="#client_abb#">
														<cfinvokeargument name="client_dsn" value="#client_dsn#">
													</cfinvoke>

													<cfif userAreaAccessResult IS true>

														<cfinvoke component="AlertManager" method="getItemDiaryAlertContent" returnvariable="taskAlertContent">
															<cfinvokeargument name="item" value="#taskObject#">
															<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
															<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
															<cfinvokeargument name="language" value="#curLang#">

															<cfinvokeargument name="client_abb" value="#client_abb#">
														</cfinvoke>	

														<cfset alertContent = alertContent&taskAlertContent>

													</cfif>

												</cfloop>

											</cfif>

											<cfset subject = "[#rootArea.name#] "&langText[curLang].tasks_reminder.pending_tasks>

											<cfinvoke component="AlertManager" method="getDiaryAlertFootContent" returnvariable="footContent">
												<cfinvokeargument name="language" value="#curLang#">
											</cfinvoke>
											
											<!---<cfoutput>
												#todayDate#<br/>
												#futureDate#<br/>
												#curUserEmail#<br/>
												#alertContent#
											</cfoutput>--->
											
											<cfinvoke component="#APPLICATION.componentsPath#/EmailManager" method="sendEmail">
												<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
												<cfinvokeargument name="to" value="#curUserEmail#">
												<cfinvokeargument name="subject" value="#subject#">
												<cfinvokeargument name="content" value="#alertContent#">
												<cfinvokeargument name="foot_content" value="#footContent#">
											</cfinvoke>

										</cfif><!--- END expiredTasksQuery.recordCount GT 0 OR futureTasksQuery.recordCount GT 0 --->

									<!--- </cfif> --->

								</cfif>

							</cfif>

						</cfloop>

						<cfcatch>
							<cfinclude template="includes/errorHandler.cfm">						
						</cfcatch>

					</cftry>

				</cfif>

			</cfloop>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

	</cffunction>



	<!--- --------------------------- getItemDiaryAlertContent --------------------------- --->
	
	<cffunction name="getItemDiaryAlertContent" access="private" returntype="string">
		<cfargument name="item" type="struct" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="itemTypeName" type="string" required="true">
		<cfargument name="language" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">
 				
		<cfset var method = "getItemFootContent">

		<cfset var itemContent = "">
			

			<!---itemUrl--->
			<cfinvoke component="UrlManager" method="getAreaItemUrl" returnvariable="areaItemUrl">
				<cfinvokeargument name="item_id" value="#item.id#">
				<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
				<cfinvokeargument name="area_id" value="#item.area_id#">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			</cfinvoke>

			<cfsavecontent variable="itemContent">
				<cfoutput>

				<a href="#areaItemUrl#" target="_blank" style="font-size:14px;">#item.title#</a><br/>

				#langText[arguments.language].new_item.user#: <b>#item.user_full_name#</b><br/>
				<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->
				#langText[arguments.language].new_item.start_date#<cfif itemTypeId IS 5> #langText[arguments.language].new_item.of_event#</cfif>: #item.start_date# <cfif itemTypeId IS 5>#langText[arguments.language].new_item.hour#: #TimeFormat(item.start_time,"HH:mm")#</cfif><br/>
				#langText[arguments.language].new_item.end_date#<cfif itemTypeId IS 5> #langText[arguments.language].new_item.of_event#</cfif>: <b>#item.end_date#</b> <cfif itemTypeId IS 5>#langText[arguments.language].new_item.hour#: <b>#TimeFormat(item.end_time,"HH:mm")#</b></cfif><br/><br/>
				</cfif>

				</cfoutput>
			</cfsavecontent>
		
		<cfreturn itemContent>

	</cffunction>


	<!--- --------------------------- getFileFootContent --------------------------- --->
	
	<cffunction name="getDiaryAlertFootContent" access="private" returntype="string">
		<cfargument name="language" type="string" required="true">
 				
		<cfset var method = "getDiaryAlertFootContent">

		<cfset var footContent = "">

		<cfset footContent = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;"><span style="color:##FF0000; font-size:12px;">#langText[arguments.language].common.foot_do_not_reply#.</span><br/>#langText[arguments.language].common.foot_content_default_1# #APPLICATION.title#.<br />#langText[arguments.language].new_item.foot_content_3#.</p>'>
		
		<cfreturn footContent>

	</cffunction>


</cfcomponent>
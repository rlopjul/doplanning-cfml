<!---Copyright Era7 Information Technologies 2007-2013--->
<cfcomponent output="false">

	<cfset component = "AlertManager">

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



</cfcomponent>
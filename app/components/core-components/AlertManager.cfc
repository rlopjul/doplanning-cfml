<!---Copyright Era7 Information Technologies 2007-2014--->
<cfcomponent output="false">

	<cfset component = "AlertManager">

	<cfset dateFormat = "%d-%m-%Y">

	<cfset ALERT_TYPE_DOPLANNING = "doplanning">
	<cfset ALERT_TYPE_WEB = "web">

	<cfinclude template="#APPLICATION.componentsPath#/includes/loadLangText.cfm">


	<!--- -------------------------------------- newAreaItem ----------------------------------- --->

	<cffunction name="newAreaItem" access="public" returntype="void">
		<cfargument name="objectItem" type="query" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="itemCategories" type="query" required="false">
		<cfargument name="action" type="string" required="yes">
		<cfargument name="send_sms" type="boolean" required="no" default="false">
		<cfargument name="anti_virus_check_result" type="string" required="false">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "newAreaItem">

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

		<!---<cfsavecontent variable="getUsersParameters">
			<cfoutput>
				<user id="" email=""
			telephone="" mobile_phone="" mobile_phone_ccode=""
			sms_allowed="" whole_tree_visible="">
					<family_name><![CDATA[]]></family_name>
					<name><![CDATA[]]></name>
				</user>
					<area id ="#objectItem.area_id#"/>
				<order parameter="family_name" order_type="asc" />
				<cfif arguments.action NEQ "attached_file_deleted_virus" AND arguments.action NEQ "attached_image_deleted_virus">
					<preferences notify_new_#itemTypeName#="true">
					</preferences>
				</cfif>
			</cfoutput>
		</cfsavecontent>

		<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="createRequest" returnvariable="getUsersRequest">
			<cfinvokeargument name="request_parameters" value="#getUsersParameters#">
		</cfinvoke>--->

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

				<!--- getHeadContent --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getHeadContent" returnvariable="head_content">
					<cfinvokeargument name="language" value="#curLang#">
					<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
				</cfinvoke>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemFootContent" returnvariable="foot_content">
					<cfinvokeargument name="language" value="#curLang#">
				</cfinvoke>

				<cfswitch expression="#arguments.action#">

					<cfcase value="new"><!---Nuevo--->

						<cfif arguments.itemTypeId IS NOT 7 OR objectItem.parent_kind EQ "area">
							<cfif itemTypeGender EQ "male">
								<cfset action_name = "#langText[curLang].new_item.new_male# #langText[curLang].item[itemTypeId].name#">
							<cfelse>
								<cfset action_name = "#langText[curLang].new_item.new_female# #langText[curLang].item[itemTypeId].name#">
							</cfif>
							<cfset subject = "[#root_area.name#][#langText[curLang].item[itemTypeId].name#] #objectItem.title#">
						<cfelse><!---Respuesta a consulta--->

							<cfset action_name = "#langText[curLang].new_item.answer_to# #langText[curLang].item[itemTypeId].name#">
							<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">

						</cfif>

						<cfset actionBoxText = "">
						<cfset actionDate = objectItem.creation_date>


					</cfcase>

					<cfcase value="delete"><!---Eliminado--->

						<cfif itemTypeGender EQ "male">
							<cfset action_name = "#langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.deleted_male#">
						<cfelse>
							<cfset action_name = "#langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.deleted_female#">
						</cfif>

						<cfif itemTypeGender EQ "male">
							<cfset actionBoxText = langText[curLang].new_item.deleted_male>
						<cfelse>
							<cfset actionBoxText = langText[curLang].new_item.deleted_female>
						</cfif>
						<cfset actionDate = dateFormat(now(), APPLICATION.dateFormat)&" "&timeFormat(now(), "HH:mm:ss")>

						<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">

					</cfcase>

					<cfcase value="update"><!---Modificado--->

						<cfif itemTypeGender EQ "male">
							<cfset action_name = "#langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.modified_male#">
						<cfelse>
							<cfset action_name = "#langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.modified_female#">
						</cfif>

						<cfif itemTypeGender EQ "male">
							<cfset actionBoxText = langText[curLang].new_item.modified_male>
						<cfelse>
							<cfset actionBoxText = langText[curLang].new_item.modified_female>
						</cfif>
						<cfset actionDate = objectItem.last_update_date>

						<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">

					</cfcase>

					<cfcase value="done"><!---Realizada (tarea)--->

						<cfset action_name = "#langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.done_female#">
						<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">

						<cfset actionBoxText = langText[curLang].new_item.done_female>
						<cfset actionDate = objectItem.last_update_date>

					</cfcase>

					<cfcase value="close"><!---Cerrada (consulta)--->

						<cfset action_name = "#langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.closed_female#">
						<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">

						<cfset actionBoxText = langText[curLang].new_item.closed_female>
						<cfset actionDate = objectItem.last_update_date>

					</cfcase>

					<cfcase value="attached_file_deleted_virus"><!---Imagen adjunta eliminada por virus--->

						<cfset action_name = "#langText[curLang].new_item.attached_file_of# #langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.deleted_virus_male#">
						<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">

						<cfif itemTypeGender EQ "male">
							<cfset actionBoxText = langText[curLang].new_item.modified_male>
						<cfelse>
							<cfset actionBoxText = langText[curLang].new_item.modified_female>
						</cfif>
						<cfset actionDate = dateFormat(now(), APPLICATION.dateFormat)&" "&timeFormat(now(), "HH:mm:ss")>

					</cfcase>

					<cfcase value="attached_image_deleted_virus"><!---Imagen adjunta eliminada por virus--->

						<cfset action_name = "#langText[curLang].new_item.attached_image_of# #langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.deleted_virus_female#">
						<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">

						<cfif itemTypeGender EQ "male">
							<cfset actionBoxText = langText[curLang].new_item.modified_male>
						<cfelse>
							<cfset actionBoxText = langText[curLang].new_item.modified_female>
						</cfif>
						<cfset actionDate = dateFormat(now(), APPLICATION.dateFormat)&" "&timeFormat(now(), "HH:mm:ss")>

					</cfcase>

				</cfswitch>

				<cfinvoke component="UserQuery" method="getUser" returnvariable="actionUserQuery">
					<cfinvokeargument name="user_id" value="#arguments.user_id#">
					<cfinvokeargument name="format_content" value="default">
					<cfinvokeargument name="with_ldap" value="false">
					<cfinvokeargument name="with_vpnet" value="false">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

				<cfset actionUserName = actionUserQuery.user_full_name>


				<cfset sms_message = "#uCase(action_name)#:#objectItem.title#. AREA:#area_name#">

				<cfif len(sms_message) GT 160>
					<cfset sms_message = left(sms_message, 160)>
				</cfif>


				<!---CONTENIDO DEL EMAIL--->

				<cfif includeItemContent IS true>

					<!--- getItemHeadContent --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemHeadContent" returnvariable="itemHeadContent">
						<cfinvokeargument name="itemTypeId" value="#itemTypeId#"/>
						<cfinvokeargument name="itemTypeName" value="#itemTypeName#"/>
						<cfinvokeargument name="itemTitle" value="#objectItem.title#"/>
						<cfinvokeargument name="itemUrl" value="#areaItemUrl#"/>
						<cfinvokeargument name="action" value="#arguments.action#"/>
						<cfinvokeargument name="language" value="#curLang#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
					</cfinvoke>

					<cfsavecontent variable="alertItemHead">
						<cfoutput>

						<cfif arguments.action EQ "attached_file_deleted_virus" OR arguments.action EQ "attached_image_deleted_virus"><!--- DELETE VIRUS --->

							<b>#langText[curLang].new_item.virus_description#</b>:<br/>
							<i style="color:##FF0000;">#arguments.anti_virus_check_result#</i><br/>
							#langText[curLang].new_file.virus_advice#.<br/><br/>

						</cfif>

						#itemHeadContent#

						</cfoutput>
					</cfsavecontent>

					<!--- getItemButtons --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemButtons" returnvariable="itemButtonsContent">
						<cfinvokeargument name="item_id" value="#objectItem.id#"/>
						<cfinvokeargument name="itemTypeId" value="#itemTypeId#"/>
						<cfinvokeargument name="itemTypeName" value="#itemTypeName#"/>
						<cfinvokeargument name="itemUrl" value="#areaItemUrl#"/>
						<cfinvokeargument name="area_id" value="#objectItem.area_id#"/>
						<cfinvokeargument name="action" value="#arguments.action#"/>
						<cfinvokeargument name="language" value="#curLang#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
					</cfinvoke>

					<!--- getUserAndDateContent --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getUserAndDateContent" returnvariable="userAndDateContent">
						<cfinvokeargument name="user_id" value="#arguments.user_id#"/>
						<cfinvokeargument name="actionUserFullName" value="#actionUserName#"/>
						<cfinvokeargument name="actionDate" value="#actionDate#"/>
						<cfinvokeargument name="action" value="#arguments.action#"/>
						<cfinvokeargument name="actionBoxText" value="#actionBoxText#"/>
						<cfinvokeargument name="language" value="#curLang#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
					</cfinvoke>


					<cfsavecontent variable="alertItemContent">
						<cfoutput>

						<cfif arguments.action NEQ "new">

							<cfif itemTypeGender EQ "male">
								#langText[curLang].new_item.creation_user_male#:
							<cfelse>
								#langText[curLang].new_item.creation_user_female#:
							</cfif>
							<strong>#objectItem.user_full_name#</strong><br/>

							<cfif itemTypeGender EQ "male">
								#langText[curLang].new_item.creation_date#:
							<cfelse>
								#langText[curLang].new_item.creation_date#:
							</cfif>
							<strong>#objectItem.creation_date#</strong><br/>

						</cfif>

						<cfif itemTypeId IS NOT 1 AND len(objectItem.last_update_date) GT 0>
						#langText[curLang].new_item.last_update_date#: <strong>#objectItem.last_update_date#</strong><br/>
						</cfif>

						<cfif itemTypeId IS 6><!---Tasks--->
						#langText[curLang].new_item.assigned_to#: <b>#objectItem.recipient_user_full_name#</b><br/>
						</cfif>

						<cfif itemTypeWeb IS true><!--- WEB --->

							<cfif len(objectItem.publication_date) GT 0>
								#langText[curLang].new_item.publication_date#: <b>#objectItem.publication_date#</b> <!--- #langText[curLang].new_item.hour#: <b>#TimeFormat(objectItem.publication_time,"HH:mm")#</b> ---><br/>
							</cfif>
							<cfif APPLICATION.publicationValidation IS true AND len(objectItem.publication_validated) GT 0>
								#langText[curLang].new_item.publication_validated#: <b><cfif objectItem.publication_validated IS true>#langText[curLang].new_item.yes#<cfelse>#langText[curLang].new_item.no#</cfif></b><br/>
							</cfif>

						</cfif>

						<cfif itemCategories.recordCount GT 0>

							#langText[curLang].common.categories#:

							<cfloop query="#itemCategories#">

								<b style="color:##bbbbbb">#itemCategories.category_name#</b>&nbsp;&nbsp;&nbsp;

							</cfloop><br/>


						</cfif>

						<cfif arguments.itemTypeId LT 10>

							<cfif len(objectItem.link) GT 0 AND (itemTypeId NEQ 4 AND itemTypeId NEQ 5)>
								<cfif itemTypeId IS 3><!---Links--->
								#langText[curLang].new_item.link_url#:
								<cfelse>
								#langText[curLang].new_item.link#: </cfif><a href="#objectItem.link#" target="_blank" style="font-weight:bold;">#objectItem.link#</a><br/>
							</cfif>
							<cfif isDefined("objectItem.iframe_url") AND len(objectItem.iframe_url) GT 0>
							#langText[curLang].new_item.iframe_url#:
							<a href="#objectItem.iframe_url#" target="_blank" style="font-weight:bold;">#objectItem.iframe_url#</a><br/>
							</cfif>
							<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->
							#langText[curLang].new_item.start_date#<cfif itemTypeId IS 5> #langText[curLang].new_item.of_event#</cfif>: <b>#objectItem.start_date#</b> <cfif itemTypeId IS 5>#langText[curLang].new_item.hour#: <b>#TimeFormat(objectItem.start_time,"HH:mm")#</b></cfif><br/>
							#langText[curLang].new_item.end_date#<cfif itemTypeId IS 5> #langText[curLang].new_item.of_event#</cfif>: <b>#objectItem.end_date#</b> <cfif itemTypeId IS 5>#langText[curLang].new_item.hour#: <b>#TimeFormat(objectItem.end_time,"HH:mm")#</b></cfif><br/>
								<cfif itemTypeId IS 5>
								#langText[curLang].new_item.place#: <b>#objectItem.place#</b><br/>
								<cfelse>
								#langText[curLang].new_item.estimated_value#: <b>#objectItem.estimated_value#</b><br/>
								#langText[curLang].new_item.real_value#: <b>#objectItem.real_value#</b><br/>
								#langText[curLang].new_item.task_done#: <b><cfif objectItem.done IS true>#langText[curLang].new_item.yes#<cfelse>#langText[curLang].new_item.no#</cfif></b><br/>
								</cfif>
							</cfif>

							<cfif itemTypeId IS 8><!--- Publications --->

								<cfif isNumeric(objectItem.sub_type_id)>
									<cfinvoke component="#APPLICATION.coreComponentsPath#/ItemSubTypeQuery" method="getSubType" returnvariable="subTypeQuery">
										<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
										<cfinvokeargument name="sub_type_id" value="#objectItem.sub_type_id#">

										<cfinvokeargument name="client_abb" value="#client_abb#">
										<cfinvokeargument name="client_dsn" value="#client_dsn#">
									</cfinvoke>
									<cfif subTypeQuery.recordCount GT 0>
										#langText[curLang].new_item.type#: <b><cfif curLang EQ "es">#subTypeQuery.sub_type_title_es#<cfelse>#subTypeQuery.sub_type_title_en#</cfif></b><br/>
									</cfif>
								</cfif>

								<cfif len(objectItem.identifier) GT 0>
									#langText[curLang].new_item.identifier#: <b>#objectItem.identifier#</b><br/>

										<cfif isNumeric(objectItem.sub_type_id) AND subTypeQuery.recordCount GT 0 AND subTypeQuery.sub_type_id IS 1>
											<cfset pubmedUrl = "http://www.ncbi.nlm.nih.gov/pubmed/"&objectItem.identifier>
											#langText[curLang].new_item.link_to_pubmed#: <a href="#pubmedUrl#" target="_blank">#pubmedUrl#</a><br/>
										</cfif>
								</cfif>

								<cfif subTypeQuery.recordCount IS 0 OR subTypeQuery.sub_type_id NEQ 1>
									#langText[curLang].new_item.value#: <b>#objectItem.price#</b><br/>
								</cfif>

							</cfif>

							<cfif itemTypeId IS 5><!---Events--->
								#langText[curLang].new_item.price#: <b>#objectItem.price#</b><br/>
							</cfif>
							<cfif isNumeric(objectItem.attached_file_id) AND objectItem.attached_file_id GT 0>
								<cfif arguments.action NEQ "delete">
								#langText[curLang].new_item.attached_file#: <a href="#downloadFileUrl#" style="color:##35938c;font-size:16px;" target="_blank">#objectItem.attached_file_name#</a><br/>
								<cfelse>
								#langText[curLang].new_item.attached_file#: #objectItem.attached_file_name#<br/>
								</cfif>
							</cfif>
							<cfif arguments.itemTypeId IS NOT 1 AND isNumeric(objectItem.attached_image_id) AND objectItem.attached_image_id GT 0>
								<cfif arguments.action NEQ "delete">
								#langText[curLang].new_item.attached_image#: <a href="#downloadImageUrl#" style="color:##35938c;font-size:16px;" target="_blank">#objectItem.attached_image_name#</a><br/>
								<cfelse>
								#langText[curLang].new_item.attached_image#: #objectItem.attached_image_name#<br/>
								</cfif>
							</cfif>

						</cfif><!--- END arguments.itemTypeId LT 10 --->

						<cfif APPLICATION.publicationScope IS true AND ( arguments.itemTypeId IS 11 OR arguments.itemTypeId IS 12 )>
						#langText[curLang].new_item.publication_scope#: <strong>#objectItem.publication_scope_name#</strong><br/>
						</cfif>


						<div style="font-size:16px;color:##666666;font-family:'Roboto', sans-serif;padding-top:10px;">#objectItem.description#</div>

						<cfif (itemTypeId IS 4 OR itemTypeId IS 5) AND len(objectItem.link) GT 0><!---News, Events--->
						<br/>#langText[curLang].new_item.more_information#: <a href="#objectItem.link#" target="_blank">#objectItem.link#</a><br/>
						</cfif>

						<br/>

						<cfif arguments.action NEQ "delete"><!---Si el elemento no se elimina--->
							<!---<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>--->

							<table style="width:100%;margin-top:20px;">
								<tr>
									<td><!--- Share icon --->
										<img src="#APPLICATION.mainUrl##APPLICATION.htmlPath#/assets/v3/emails/icon_share.png" alt="#langText[curLang].common.go_to_item#"/>
									</td>
									<td style="padding-top:5px;">
										<a href="#areaItemUrl#" title="#langText[curLang].common.go_to_item#" style="color:##ababab;font-size:16px;text-decoration:none">#areaItemUrl#</a>
									</td>
								</tr>
								<tr>
									<td></td>
									<td style="background:none; border-top: 1px solid ##ddd; height:1px; line-height:1px; width:100%; margin:0px 0px 0px 0px; padding-bottom:10px;">&nbsp;
									</td>
								</tr>
							</table>

						</cfif>

						</cfoutput>
					</cfsavecontent>


					<cfsavecontent variable="alertContent">
						<cfoutput>

						#itemButtonsContent#

						<table style="width:100%;border-radius:4px;border-color:##dddddd;border-style:solid;border-width:1px;margin-top:10px;box-shadow:0 1px 4px rgba(0,0,0,0.3);padding:15px;"><!--- item container table --->

							#userAndDateContent#

							<tr style="padding-top:0;padding-bottom:0;margin-top:0;margin-bottom:0">
								<td style="padding-top:0;padding-bottom:0;margin-top:0;margin-bottom:0;font-size:14px;">

									#alertItemContent#

								</td>
							</tr>
						</table><!--- END item container table --->
						</cfoutput>
					</cfsavecontent>

				<cfelse><!---includeItemContent IS false--->

					<cfsavecontent variable="alertContent">
						<cfoutput>
						<!---<i>En este e-mail no se incluye el contenido <cfif itemTypeGender EQ "male">del<cfelse>de la</cfif> #lCase(itemTypeNameEs)#.</i><br/><br/>--->
						<cfif arguments.action NEQ "delete">
						<div style="border-color:##CCCCCC; border-style:solid; border-width:1px; padding:8px;">
							<strong style="font-size:14px;">#langText[curLang].new_item.to_view_content# <cfif itemTypeGender EQ "male">#langText[curLang].new_item.of_male#<cfelse>#langText[curLang].new_item.of_female#</cfif> #lCase(itemTypeNameEs)# #langText[curLang].new_item.you_must_access#:</strong><br/>

							<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemAccessContent" returnvariable="access_content">
								<cfinvokeargument name="language" value="#curLang#">
								<cfinvokeargument name="item_id" value="#objectItem.id#"/>
								<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
								<cfinvokeargument name="area_id" value="#objectItem.area_id#"/>

								<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
							</cfinvoke>


							<span style="color:##666666;">#access_content#</span>
						</div>
						</cfif>
						</cfoutput>
					</cfsavecontent>

				</cfif>


				<!---INTERNAL USERS--->
				<cfif len(listInternalUsers) GT 0>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getAreaPathContent" returnvariable="area_path">
						<cfinvokeargument name="area_id" value="#objectItem.area_id#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

					<cfset subjectInternal = subject>

					<cfsavecontent variable="contentInternal">
					<cfoutput>
			<!---<cfif arguments.action EQ "delete">
				#action_name# #langText[curLang].common.by_user# #actionUserName# #langText[curLang].common.on_the_area#
			<cfelse>
				#langText[curLang].common.area#:
			</cfif>
			<b>#area_name#</b>.<br/>
			#langText[curLang].common.area_path#:--->

			#alertItemHead#

			#area_path#

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

					<!---SMS--->
					<cfif APPLICATION.identifier NEQ "dp" AND arguments.send_sms IS true>

						<!---El envío de SMS ya no está disponible en las nuevas versiones, se deja habilitado para versiones antiguas. En el caso de que se vuelva a habilitar para todas las versiones, es necesario pasar SMSManager a core-components y que no requiera SESSION--->
						<cfinvoke component="#APPLICATION.componentsPath#/SMSManager" method="sendSMSNew">
							<cfinvokeargument name="text" value="#sms_message#">
							<cfinvokeargument name="recipients" value="#listInternalUsersPhones#">
						</cfinvoke>

					</cfif>

				</cfif>

				<!---EXTERNAL USERS--->
				<cfif len(listExternalUsers) GT 0>

					<cfset subjectExternal = subject>

					<cfsavecontent variable="contentExternal">
					<cfoutput>
			<!---#action_name# <cfif arguments.action EQ "delete">#langText[curLang].common.by_user# #actionUserName# </cfif>#langText[curLang].common.on_the_area# <b>#area_name#</b> #langText[curLang].common.of_the_organization# #root_area.name#.<br/><br/>--->

			#alertItemHead#

			<p><a href="#APPLICATION.mainUrl#/?abb=#arguments.client_abb#&area=#objectItem.area_id#" style="color:##009ed2;text-decoration:underline;font-size:15px;">#area_name#</a></p>

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

					<!---SMS--->
					<cfif APPLICATION.identifier NEQ "dp" AND arguments.send_sms IS true>

						<!---El envío de SMS ya no está disponible en las nuevas versiones, se deja habilitado para versiones antiguas. En el caso de que se vuelva a habilitar para todas las versiones, es necesario pasar SMSManager a core-components y que no requiera SESSION--->
						<cfinvoke component="#APPLICATION.componentsPath#/SMSManager" method="sendSMSNew">
							<cfinvokeargument name="text" value="#sms_message#">
							<cfinvokeargument name="recipients" value="#listExternalUsersPhones#">
						</cfinvoke>

					</cfif>

				</cfif>

			</cfif><!---END len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0--->


		</cfloop><!---END APPLICATION.languages loop--->


	</cffunction>


	<!--- --------------------------- getAreaPathContent --------------------------- --->

	<cffunction name="getAreaPathContent" access="private" returntype="string">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="from_area_id" type="numeric" required="false"><!---Define el área a partir de la cual se muestra la ruta--->
		<cfargument name="include_from_area" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var areaPath = "">

			<cfinvoke component="AreaQuery" method="getAreaPath" returnvariable="areaPath">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="separator" value=' <span style="color:##666666"> > </span> '>

				<cfinvokeargument name="with_base_link" value="#APPLICATION.mainUrl#/?abb=#arguments.client_abb#&area="/>
				<cfinvokeargument name="area_link_styles" value="color:##009ed2;text-decoration:none;"/>
				<cfinvokeargument name="cur_area_link_styles" value="text-decoration:underline"/>

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

		<cfreturn '<p style="font-size:15px;">'&areaPath&'</p>'>

	</cffunction>


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
		<cfset var accessClient = "">

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
			<cfif itemTypeId EQ 1 OR itemTypeId EQ 7><!--- Messages or Consultations --->
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

			<cfif arguments.client_abb EQ "hcs">
				<cfset accessClient = "doplanning">
			<cfelseif isDefined("SESSION.client_id")>
				<cfset accessClient = SESSION.client_id>
			</cfif>

			<cfif len(accessClient) GT 0>
				<br/>-&nbsp;#langText[arguments.language].common.access_to_application#:
			<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#accessClient#">#APPLICATION.mainUrl##APPLICATION.path#/#accessClient#</a>
			</cfif>

			</cfoutput>
			</cfsavecontent>


		<cfelse><!---VPNET/AGSNA--->

			<cfsavecontent variable="accessContent">
			<cfoutput>
				<cfif itemTypeId EQ 1 OR itemTypeId EQ 7><!--- Messages or Consultations --->
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
		<cfset var accessClient = "">

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

			<cfif arguments.client_abb EQ "hcs">
				<cfset accessClient = "doplanning">
			<cfelseif isDefined("SESSION.client_id")>
				<cfset accessClient = SESSION.client_id>
			</cfif>

			<cfif len(accessClient) GT 0>
				<br/>-&nbsp;#langText[arguments.language].common.access_to_application#:
			<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#accessClient#">#APPLICATION.mainUrl##APPLICATION.path#/#accessClient#</a>
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


	<!--- --------------------------- getHeadContent --------------------------- --->

	<cffunction name="getHeadContent" access="private" returntype="string">
		<cfargument name="language" type="string" required="true">
		<cfargument name="client_abb" type="string" required="true">

		<cfset var method = "getHeadContent">

		<cfset var headContent = "">
		<cfset var clientAppTitle = "">

		<cfif NOT isDefined("SESSION.client_app_title")>

			<!--- getClient --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			</cfinvoke>

			<cfset clientAppTitle = clientQuery.app_title>

		<cfelse>

			<cfset clientAppTitle = SESSION.client_app_title>

		</cfif>

		<cfsavecontent variable="headContent"><cfoutput><table style="width:100%;height:32px;background-color:##019ED3;padding-left:15px;color:##FFFFFF;font-size:14px"><tr><td><span class="color:##FFFFFF;font-size:14px;font-family:'Roboto', sans-serif;">#clientAppTitle#</span></td></tr></table><div style="height:15px;line-height:15px;">&nbsp;</div></cfoutput></cfsavecontent>

		<cfreturn headContent>

	</cffunction>


	<!--- --------------------------- getItemFootContent --------------------------- --->

	<cffunction name="getItemFootContent" access="private" returntype="string">
		<cfargument name="language" type="string" required="true">

		<cfset var method = "getItemFootContent">

		<cfset var footContent = "">

		<cfsavecontent variable="footContent"><cfoutput><p style="font-family:'Roboto', sans-serif; font-size:10px;"><span style="color:##FF0000; font-size:12px;">#langText[arguments.language].common.foot_do_not_reply#.</span><br/>#langText[arguments.language].common.foot_content_default_1# #APPLICATION.title# #langText[arguments.language].new_item.foot_content_2# #APPLICATION.title#.<br />#langText[arguments.language].new_item.foot_content_3#.</p></cfoutput></cfsavecontent>

		<cfreturn footContent>

	</cffunction>


	<!--- --------------------------- getItemHeadContent --------------------------- --->

	<cffunction name="getItemHeadContent" access="private" returntype="string">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="itemTypeName" type="string" required="true">
		<cfargument name="itemTitle" type="string" required="true">
		<cfargument name="itemUrl" type="string" required="true">
		<cfargument name="action" type="string" required="true">
		<cfargument name="language" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">

		<cfset var method = "getItemHeadContent">

		<cfset var headContent = "">

		<cfsavecontent variable="headContent"><cfoutput>
			<cfif arguments.action NEQ "delete"><a href="#arguments.itemUrl#"></cfif><img src="#APPLICATION.mainUrl##APPLICATION.htmlPath#/assets/v3/icons/#arguments.itemTypeName#.png" alt="#langText[arguments.language].item[arguments.itemTypeId].name#" title="#langText[arguments.language].item[arguments.itemTypeId].name#" style="width:60px"/><cfif arguments.action NEQ "delete"></a></cfif>

			<table style="width:100%;margin-top:5px;">
				<tr>
					<td style="padding:0"><!--- Title --->
						<span style="font-size:22px;font-weight:100;color:##009ED2">#arguments.itemTitle#</span>
					</td>
				</tr>
				<tr>
					<td style="border-collapse: collapse; background:none; border-bottom: 1px solid ##019ED3; height:1px; line-height:1px; width:100%; margin:0px 0px 0px 0px; padding-top:10px;padding-bottom:0;">
						&nbsp;
					</td>
				</tr>
			</table></cfoutput></cfsavecontent>

		<cfreturn headContent>

	</cffunction>


	<!--- --------------------------- getItemButtons --------------------------- --->

	<cffunction name="getItemButtons" access="private" returntype="string">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="itemTypeName" type="string" required="true">
		<cfargument name="itemUrl" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="action" type="string" required="true">
		<cfargument name="language" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">

		<cfset var method = "getItemButtons">

		<cfset var buttonsContent = "">

		<cfsavecontent variable="buttonsContent"><cfoutput>
			<table style="width:100%">
				<tr>
					<td style="text-align:left;">

						<cfif arguments.action NEQ "delete" AND arguments.action NEQ "delete_virus" AND arguments.action NEQ "delete_version_virus">

							<cfif arguments.itemTypeId IS 1>

								<!--- Reply --->
								<a href="#arguments.itemUrl#&reply" target="_blank" title="#langText[arguments.language].new_item.reply#"><img src="#APPLICATION.mainUrl##APPLICATION.htmlPath#/assets/v3/emails/btn_reply_#arguments.language#.png" alt="#uCase(langText[arguments.language].new_item.reply)#" title="#uCase(langText[arguments.language].new_item.reply)#"/></a><!--- <br/> --->

							<cfelseif arguments.itemTypeId IS 10>

								<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaFileUrl" returnvariable="downloadFileUrl">
									<cfinvokeargument name="file_id" value="#arguments.item_id#">
									<cfinvokeargument name="area_id" value="#arguments.area_id#">
									<cfinvokeargument name="download" value="true">
									<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
								</cfinvoke>

								<!--- Download --->
								<a href="#downloadFileUrl#" target="_blank" title="#uCase(langText[arguments.language].new_file.download)#"><img src="#APPLICATION.mainUrl##APPLICATION.htmlPath#/assets/v3/emails/btn_download_#arguments.language#.png" alt="#uCase(langText[arguments.language].new_file.download)#" title="#uCase(langText[arguments.language].new_file.download)#"/></a>

							</cfif>

							<!---
							BOTON CON TABLA
							No queda bien porque por algún motivo el color del texto no se puede poner blanco
							<table style="background-color:##e4514b;border-radius:4px;display:inline-block;color:##FFFFF6;">
								<tr>
									<td style="padding-left:10px;padding-right:10px;padding-top:4px;padding-bottom:4px;box-shadow:1px 1px 2px rgba(0,0,0,0.3)">
										<a href="#itemUrl#&reply" class="color:##FFFFF6;text-decoration:none;font-size:12px;" target="_blank"><img src="#APPLICATION.mainUrl##APPLICATION.htmlPath#/assets/v3/emails/icon_reply.png" alt="#uCase(langText[arguments.language].new_item.reply)#"/> <span class="color:##FFFFF6;text-decoration:none;font-size:12px;">#uCase(langText[arguments.language].new_item.reply)#</span>
										</a>
									</td>
								</tr>
							</table>
							--->

						</cfif>

					<td>
					<td style="text-align:right;">

						<cfif arguments.action NEQ "delete"><!--- View in area --->
							<a href="#APPLICATION.mainUrl##APPLICATION.htmlPath#/area_items.cfm?abb=#arguments.client_abb#&area=#arguments.area_id####arguments.itemTypeName##arguments.item_id#" title="Ver en área"><img src="#APPLICATION.mainUrl##APPLICATION.htmlPath#/assets/v3/emails/btn_view_in_area_#arguments.language#.png" alt="#uCase(langText[arguments.language].common.view_in_area)#" title="#uCase(langText[arguments.language].common.view_in_area)#"/></a>
						</cfif>

					</td>
				</tr>
			</table></cfoutput>
		</cfsavecontent>

		<cfreturn buttonsContent>

	</cffunction>




	<!--- --------------------------- getUserAndDateContent --------------------------- --->

	<cffunction name="getUserAndDateContent" access="private" returntype="string">
		<cfargument name="user_id" type="numeric" required="true">
		<cfargument name="actionUserFullName" type="string" required="true">
		<cfargument name="actionDate" type="string" required="true">
		<cfargument name="actionBoxText" type="string" required="true">
		<cfargument name="action" type="string" required="true">
		<cfargument name="language" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">

		<cfset var method = "getUserAndDateContent">

		<cfset var userAndDateContent = "">
		<cfset var actionBox = "">

		<cfif len(arguments.actionBoxText) GT 0>

			<cfoutput>
			<cfswitch expression="#arguments.action#">

				<cfcase value="new,create"><!---Nuevo--->

					<cfset actionBox = "">

				</cfcase>

				<cfcase value="update"><!---Modificado--->

					<cfsavecontent variable="actionBox">
						<table style="background-color:##019ed3;border-radius:4px;display:inline-block;">
							<tr>
								<td style="color:##FFFFFF;padding-left:2px;padding-right:2px;">
									#actionBoxText#
								</td>
							</tr>
						</table>
					</cfsavecontent>

				</cfcase>

				<cfcase value="done"><!---Realizada--->

					<cfsavecontent variable="actionBox">
						<table style="background-color:##82D0CA;border-radius:4px;display:inline-block;">
							<tr>
								<td style="color:##FFFFFF;padding-left:2px;padding-right:2px;">
									#actionBoxText#
								</td>
							</tr>
						</table>
					</cfsavecontent>

				</cfcase>

				<cfcase value="close"><!---Cerrada--->

					<cfsavecontent variable="actionBox">
						<table style="background-color:##EAD144;border-radius:4px;display:inline-block;">
							<tr>
								<td style="color:##FFFFFF;padding-left:2px;padding-right:2px;">
									#actionBoxText#
								</td>
							</tr>
						</table>
					</cfsavecontent>

				</cfcase>

				<cfcase value="delete"><!---Eliminado--->

					<cfsavecontent variable="actionBox">
						<table style="background-color:##e4514b;border-radius:4px;display:inline-block;">
							<tr>
								<td style="color:##FFFFFF;padding-left:2px;padding-right:2px;">
									#actionBoxText#
								</td>
							</tr>
						</table>
					</cfsavecontent>

				</cfcase>

				<cfcase value="attached_file_deleted_virus,attached_image_deleted_virus">

					<cfsavecontent variable="actionBox">
						<table style="background-color:##EAD144;border-radius:4px;display:inline-block;">
							<tr>
								<td style="color:##FFFFFF;padding-left:2px;padding-right:2px;">
									#actionBoxText#
								</td>
							</tr>
						</table>
					</cfsavecontent>

				</cfcase>

				<cfdefaultcase>

					<cfsavecontent variable="actionBox">
						<table style="background-color:##019ed3;border-radius:4px;display:inline-block;">
							<tr>
								<td style="color:##FFFFFF;padding-left:2px;padding-right:2px;">
									#actionBoxText#
								</td>
							</tr>
						</table>
					</cfsavecontent>

				</cfdefaultcase>

			</cfswitch>
			</cfoutput>

		</cfif>

		<cfsavecontent variable="userAndDateContent"><cfoutput>
			<tr style="padding-bottom:0;margin-bottom:0">
				<td style="padding-bottom:0;margin-bottom:0">

					<table style="width:100%;">
						<tr>
							<td><!--- User and date --->

								<table>
									<tr>
										<td style="vertical-align:middle">
											<span style="font-size:25px;color:##35938c;font-weight:100">#actionUserFullName#</span>&nbsp;&nbsp;&nbsp;&nbsp;
										</td>
										<td style="vertical-align:middle">
											<cfset spacePos = findOneOf(" ", actionDate)>
											<span style="font-size:20px;color:##254c65;font-weight:100;white-space:nowrap;">#left(actionDate, spacePos)#</span>&nbsp;&nbsp;&nbsp;
										</td>
										<td style="vertical-align:middle">
											<span style="font-size:20px;color:##888;font-weight:100;white-space:nowrap;">#right(actionDate, len(actionDate)-spacePos)#</span>&nbsp;&nbsp;
										</td>
										<td style="vertical-align:middle">
											#actionBox#
										</td>
									</tr>
								</table>

							</td>
						</tr>

						<tr>
							<td style="background:none; border-top: 1px solid ##eeeeee; height:1px; line-height:1px; width:100%; margin:0px 0px 0px 0px; padding-top:10px;">
								&nbsp;
							</td>
						</tr>
					</table>

				</td>
			</tr></cfoutput>
		</cfsavecontent>

		<cfreturn userAndDateContent>

	</cffunction>



	<!--- -------------------------------------- newTableRow ------------------------------------ --->

	<cffunction name="newTableRow" access="public" returntype="void">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="rowQuery" type="query" required="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="false">
		<cfargument name="action" type="string" required="true"><!---create/modify/delete--->
		<cfargument name="fields" type="query" required="false">

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
		<cfset var head_content = "">
		<cfset var foot_content = "">
		<cfset var alertContent = "">
		<cfset var actionUserName = "">
		<cfset var userAndDateContent = "">
		<cfset var rowStruct = structNew()>

		<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

		<!--- getTable --->
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

		<cfif NOT isDefined("arguments.fields")>

			<!---Table fields--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getTableFields" returnvariable="fields">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="with_types" value="true">
				<cfinvokeargument name="with_table" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

		</cfif>

		<!---generateRowStruct--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/RowManager" method="generateRowStruct" returnvariable="generateRowStructResponse">
			<cfinvokeargument name="table_id" value="#arguments.table_id#">
			<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			<cfinvokeargument name="rowQuery" value="#rowQuery#">
			<cfinvokeargument name="fields" value="#fields#">

			<cfinvokeargument name="withDateFormatted" value="true"/>
			<cfinvokeargument name="withDoPlanningElements" value="true"/>

			<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
			<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#"/>
		</cfinvoke>

		<cfset rowStruct = generateRowStructResponse.rowStruct>

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

		<!--- getItemCategories --->
		<cfif NOT isDefined("arguments.itemCategories")>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItemCategories" returnvariable="itemCategories">
				<cfinvokeargument name="item_id" value="#arguments.table_id#">
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

		</cfif>

    <cfinvoke component="UserManager" method="getUsersToNotifyLists" returnvariable="usersToNotifyLists">
			<!---<cfinvokeargument name="request" value="#getUsersRequest#"/>--->
			<cfinvokeargument name="area_id" value="#area_id#">
			<cfinvokeargument name="notify_new_#tableTypeName#_row" value="true">

			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
			<cfinvokeargument name="categories_ids" value="#valueList(itemCategories.category_id)#">

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
						<cfset actionBoxText = "">
					</cfcase>

					<cfcase value="modify">
						<cfset subject_action = "#langText[curLang].new_table_row.modify_row# #langText[curLang].item[itemTypeId].name#">
						<cfset actionBoxText = langText[curLang].new_item.modified_male>
					</cfcase>

					<cfcase value="delete">
						<cfset subject_action = "#langText[curLang].new_table_row.delete_row# #langText[curLang].item[itemTypeId].name#">
						<cfset actionBoxText = langText[curLang].new_item.deleted_male>
					</cfcase>
				</cfswitch>

				<cfset subject = "[#root_area.name#][#subject_action#] "&getTableQuery.title>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getHeadContent" returnvariable="head_content">
					<cfinvokeargument name="language" value="#curLang#">
					<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
				</cfinvoke>

				<cfinvoke component="AlertManager" method="getItemFootContent" returnvariable="foot_content">
					<cfinvokeargument name="language" value="#curLang#">
				</cfinvoke>


				<!--- getAreaItemUrl --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaItemUrl" returnvariable="areaItemUrl">
					<cfinvokeargument name="item_id" value="#arguments.table_id#">
					<cfinvokeargument name="itemTypeName" value="#tableTypeName#">
					<cfinvokeargument name="area_id" value="#area_id#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				</cfinvoke>

				<!--- getItemHeadContent --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemHeadContent" returnvariable="itemHeadContent">
					<cfinvokeargument name="language" value="#curLang#">
					<cfinvokeargument name="itemTypeId" value="#itemTypeId#"/>
					<cfinvokeargument name="itemTypeName" value="#tableTypeName#"/>
					<cfinvokeargument name="itemTitle" value="#getTableQuery.title#"/>
					<cfinvokeargument name="itemUrl" value="#areaItemUrl#"/>
					<cfinvokeargument name="action" value="#arguments.action#"/>

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
				</cfinvoke>

				<!--- getItemButtons --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemButtons" returnvariable="itemButtonsContent">
					<cfinvokeargument name="item_id" value="#arguments.table_id#"/>
					<cfinvokeargument name="itemTypeId" value="#itemTypeId#"/>
					<cfinvokeargument name="itemTypeName" value="#tableTypeName#"/>
					<cfinvokeargument name="itemUrl" value="#areaItemUrl#"/>
					<cfinvokeargument name="area_id" value="#area_id#"/>
					<cfinvokeargument name="action" value="#arguments.action#"/>
					<cfinvokeargument name="language" value="#curLang#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
				</cfinvoke>

				<cfif isDefined("arguments.user_id")>

					<cfset actionDate = dateFormat(now(), APPLICATION.dateFormat)&" "&timeFormat(now(), "HH:mm:ss")>

					<!--- getUserAndDateContent --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getUserAndDateContent" returnvariable="userAndDateContent">
						<cfinvokeargument name="user_id" value="#arguments.user_id#"/>
						<cfinvokeargument name="actionUserFullName" value="#actionUserName#"/>
						<cfinvokeargument name="actionDate" value="#actionDate#"/>
						<cfinvokeargument name="action" value="#arguments.action#"/>
						<cfinvokeargument name="actionBoxText" value="#actionBoxText#"/>
						<cfinvokeargument name="language" value="#curLang#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
					</cfinvoke>

				</cfif>


				<cfsavecontent variable="alertItemContent">
					<cfoutput>

					<!---<cfif len(actionUserName) GT 0>
						#langText[curLang].common.user#: <strong>#actionUserName#</strong><br/>
					</cfif>--->
					<!---#langText[curLang].new_item.creation_date#: <strong>#objectItem.creation_date#</strong><br/>--->
					<!---<cfif arguments.action NEQ "create">
						#langText[curLang].new_item.last_update_date#: <strong>#objectItem.last_update_date#</strong><br/>
					</cfif>--->

					<p style="font-size:16px;">

						#subject_action#<br/>
						<span style="color:##326686">#langText[curLang].new_table_row.register_number#</span>: #arguments.row_id#<br/><br/>

						<cfloop query="fields">

							<cfset field_name = "field_#fields.field_id#">
							<cfset field_value = rowStruct[field_name]>

							<cfif len(field_value) GT 0>

								<cfif fields.field_type_id IS 7><!--- BOOLEAN --->

									<cfif field_value IS true>
										<cfset field_value = langText[curLang].new_item.yes>
									<cfelseif field_Value IS false>
										<cfset field_value = langText[curLang].new_item.no>
									</cfif>

								<cfelseif fields.field_type_id IS 2><!--- LONG TEXT --->

									<cfset field_value = HTMLEditFormat(field_value)>

									<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="insertBR" returnvariable="field_value">
										<cfinvokeargument name="string" value="#field_value#">
									</cfinvoke>

									<cfset field_value = "<br/>"&field_value>

								</cfif>

							</cfif>

							<span style="color:##326686">#fields.label#</span>: #field_value#<br/>

						</cfloop>
					</p>

					<cfif arguments.action NEQ "delete">

						<!---tableRowUrl--->
						<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getTableRowUrl" returnvariable="tableRowUrl">
							<cfinvokeargument name="table_id" value="#arguments.table_id#">
							<cfinvokeargument name="tableTypeName" value="#tableTypeName#">
							<cfinvokeargument name="row_id" value="#arguments.row_id#">
							<cfinvokeargument name="area_id" value="#area_id#">

							<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						</cfinvoke>

						<table style="width:100%;margin-top:20px;">
							<tr>
								<td><!--- Share icon --->
									<img src="#APPLICATION.mainUrl##APPLICATION.htmlPath#/assets/v3/emails/icon_share.png" alt="#langText[curLang].common.go_to_item#"/>
								</td>
								<td style="padding-top:5px;">
									<a href="#tableRowUrl#" title="#langText[curLang].common.go_to_item#" style="color:##ababab;font-size:16px;text-decoration:none">#tableRowUrl#</a>
								</td>
							</tr>
							<tr>
								<td></td>
								<td style="background:none; border-top: 1px solid ##ddd; height:1px; line-height:1px; width:100%; margin:0px 0px 0px 0px; padding-bottom:10px;">&nbsp;
								</td>
							</tr>
						</table>

					</cfif>
					</cfoutput>
				</cfsavecontent>


				<cfsavecontent variable="alertContent">
					<cfoutput>

					#itemButtonsContent#

					<table style="width:100%;border-radius:4px;border-color:##dddddd;border-style:solid;border-width:1px;margin-top:10px;box-shadow:0 1px 4px rgba(0,0,0,0.3);padding:15px;"><!--- item container table --->

						#userAndDateContent#

						<tr style="padding-top:0;padding-bottom:0;margin-top:0;margin-bottom:0">
							<td style="padding-top:0;padding-bottom:0;margin-top:0;margin-bottom:0;font-size:14px;">

								#alertItemContent#

							</td>
						</tr>
					</table><!--- END item container table --->
					</cfoutput>
				</cfsavecontent>


				<!---INTERNAL USERS--->
				<cfif len(listInternalUsers) GT 0>

					<!---<cfinvoke component="AreaQuery" method="getAreaPath" returnvariable="area_path">
						<cfinvokeargument name="area_id" value="#area_id#">
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>--->

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getAreaPathContent" returnvariable="area_path">
						<cfinvokeargument name="area_id" value="#area_id#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

					<cfprocessingdirective suppresswhitespace="true">
					<cfsavecontent variable="contentInternal">
					<cfoutput>
			#itemHeadContent#

			<!--- #langText[curLang].new_file.it_has# #action_value# #langText[curLang].new_file.a_file_on_the_area# ---><!---#langText[curLang].common.area#: <strong>#area_name#</strong>.<br/>
			#langText[curLang].common.area_path#: #area_path#.<br/><br/>--->

			#area_path#

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
						<cfinvokeargument name="head_content" value="#head_content#">
						<cfinvokeargument name="foot_content" value="#foot_content#">
					</cfinvoke>

				</cfif>


				<!---EXTERNAL USERS--->
				<cfif len(listExternalUsers) GT 0>

					<cfprocessingdirective suppresswhitespace="true">
					<cfsavecontent variable="contentExternal">
					<cfoutput>
			#itemHeadContent#

			<!--- #langText[curLang].new_file.it_has# #action_value# #langText[curLang].new_file.a_file_on_the_area# ---><!---#langText[curLang].common.area#: <strong>#area_name#</strong> #langText[curLang].common.of_the_organization# #root_area.name#.<br/><br/>--->

			<p><a href="#APPLICATION.mainUrl#/?abb=#arguments.client_abb#&area=#area_id#" style="color:##009ed2;text-decoration:underline;font-size:15px;">#area_name#</a></p>


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
						<cfinvokeargument name="head_content" value="#head_content#">
						<cfinvokeargument name="foot_content" value="#foot_content#">
					</cfinvoke>

				</cfif>

			</cfif><!---END len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0--->

		</cfloop><!---END APPLICATION.languages loop--->

	</cffunction>


	<!--- -------------------------------------- sendDiaryAlerts ------------------------------------ --->

	<!--- Task alerts --->

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
		<cfset var headContent = "">

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
															<cfinvokeargument name="itemTypeGender" value="#itemTypeGender#">
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
															<cfinvokeargument name="itemTypeGender" value="#itemTypeGender#">
															<cfinvokeargument name="language" value="#curLang#">

															<cfinvokeargument name="client_abb" value="#client_abb#">
														</cfinvoke>

														<cfset alertContent = alertContent&taskAlertContent>

													</cfif>

												</cfloop>

											</cfif>

											<cfset subject = "[#rootArea.name#] "&langText[curLang].tasks_reminder.pending_tasks>

											<!--- getHeadContent --->
											<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getHeadContent" returnvariable="headContent">
												<cfinvokeargument name="language" value="#curLang#">
												<cfinvokeargument name="client_abb" value="#client_abb#"/>
											</cfinvoke>

											<cfinvoke component="AlertManager" method="getDiaryAlertFootContent" returnvariable="footContent">
												<cfinvokeargument name="language" value="#curLang#">
											</cfinvoke>

											<cfinvoke component="#APPLICATION.componentsPath#/EmailManager" method="sendEmail">
												<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
												<cfinvokeargument name="to" value="#curUserEmail#">
												<cfinvokeargument name="subject" value="#subject#">
												<cfinvokeargument name="content" value="#alertContent#">
												<cfinvokeargument name="head_content" value="#headContent#">
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

				</cfif><!--- END getClientsQuery.tasks_reminder_notifications IS true --->

			</cfloop><!--- END loop query="getClientsQuery" --->

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

	</cffunction>



	<!--- -------------------------------------- checkIfSendNotificationsToUser ------------------------------------ --->

	<cffunction name="checkIfSendNotificationsToUser" output="false" access="public" returntype="struct">
		<cfargument name="notificationsDigestTypeId" type="numeric" required="false">
		<cfargument name="userLastDigestDate" type="string" required="true">

			<cfset var sendNotifications = false>
			<cfset var currentDigestDate = createDate(year(now()), month(now()), day(now()))>
			<cfset var lastDigestDate = "">

			<cfif isDate(arguments.userLastDigestDate)>

				<cfset lastDigestDate = arguments.userLastDigestDate>

			<cfelse>

				<cfswitch expression="#arguments.notificationsDigestTypeId#">

					<cfcase value="1"><!--- daily --->

						<cfset lastDigestDate = dateAdd("d", -1, currentDigestDate)>
						<cfset sendNotifications = true>

					</cfcase>

					<cfcase value="2"><!--- weekly --->

						<cfset lastDigestDate = dateAdd("d", -7, currentDigestDate)>

					</cfcase>

					<cfcase value="3"><!--- monthly --->

						<cfset lastDigestDate = dateAdd("d", -30, currentDigestDate)>

					</cfcase>

				</cfswitch>

			</cfif>

			<cfset daysBetweenLastDigest = dateDiff("d", lastDigestDate, currentDigestDate)>

			<cfswitch expression="#arguments.notificationsDigestTypeId#">

				<cfcase value="1"><!--- daily --->

					<cfif daysBetweenLastDigest GT 0>
						<cfset sendNotifications = true>
					</cfif>

					<cfset currentDigestDate = lastDigestDate>

				</cfcase>

				<cfcase value="2"><!--- weekly --->

					<cfif daysBetweenLastDigest GT 6>
						<cfset sendNotifications = true>
					</cfif>

					<cfset currentDigestDate = dateAdd("d", -1, currentDigestDate)>

				</cfcase>

				<cfcase value="3"><!--- monthly --->

					<cfif daysBetweenLastDigest GT 29>
						<cfset sendNotifications = true>
					</cfif>

					<cfset currentDigestDate = dateAdd("d", -1, currentDigestDate)>

				</cfcase>

			</cfswitch>

		<cfreturn {sendNotifications=sendNotifications, lastDigestDate=lastDigestDate, currentDigestDate=currentDigestDate}>

	</cffunction>



	<!--- -------------------------------------- sendAllDiaryAlerts ------------------------------------ --->

	<cffunction name="sendAllDiaryAlerts" output="false" access="public" returntype="void">

		<cfset var client_abb = "">
		<cfset var client_dsn = "">

		<cfset var nowDate = Now()>
		<cfset var todayDate = CreateDate( Year(nowDate), Month(nowDate), Day(nowDate) )>
		<cfset var todayDateFormatted = dateFormat(todayDate, APPLICATION.dateFormat)>
		<cfset var forceNotifications = "">
		<cfset var tasksReminderDays = "">
		<cfset var userAccessResult = "">
		<cfset var subject = "">
		<cfset var headContent = "">
		<cfset var footContent = "">
		<cfset var userAreasIds = "">

		<cftry>

			<!--- getClients --->
			<cfinvoke component="ClientQuery" method="getClients" returnvariable="getClientsQuery">
			</cfinvoke>

			<!--- getAreaItemTypesStruct --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
			</cfinvoke>

			<cfset var itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

			<cfloop query="getClientsQuery">

				<cfset client_abb = getClientsQuery.abbreviation>
				<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>

				<cftry>

					<!--- ------ PROVISIONAL ---- --->
					<cfif client_abb EQ "hcs" OR client_abb EQ "bioinformatics7">

					<!---<cfset forceNotifications = getClientsQuery.force_notifications>--->

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

					<!--- getAreaItemTypesOptions --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemTypeQuery" method="getAreaItemTypesOptions" returnvariable="itemsTypesOptionsQuery">
						<cfinvokeargument name="client_abb" value="#client_abb#"/>
						<cfinvokeargument name="client_dsn" value="#client_dsn#"/>
					</cfinvoke>


					<cfloop query="getAllUsersQuery">

						<cfif getAllUsersQuery.enabled IS true AND len(getAllUsersQuery.email) GT 0 AND getAllUsersQuery.no_notifications IS false>

							<cfset var curLang = getAllUsersQuery.language>
							<cfset var curUserId = getAllUsersQuery.user_id>
							<cfset var curUserEmail = getAllUsersQuery.email>
							<cfset var curUserFullName = "#getAllUsersQuery.family_name# #getAllUsersQuery.name#">

							<!--- getHeadContent --->
							<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getHeadContent" returnvariable="headContent">
								<cfinvokeargument name="language" value="#getAllUsersQuery.language#">
								<cfinvokeargument name="client_abb" value="#client_abb#"/>
							</cfinvoke>

							<cfinvoke component="AlertManager" method="getDiaryAlertFootContent" returnvariable="footContent">
								<cfinvokeargument name="language" value="#getAllUsersQuery.language#">
							</cfinvoke>


							<!--- ------------------------------------------ DP NOTIFICATIONS ------------------------------------------------ --->

							<cfif isNumeric(getAllUsersQuery.notifications_digest_type_id)>

								<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="checkIfSendNotificationsToUser" returnvariable="checkNotificationsToUserResult">
									<cfinvokeargument name="notificationsDigestTypeId" value="#getAllUsersQuery.notifications_digest_type_id#">
									<cfinvokeargument name="userLastDigestDate" value="#getAllUsersQuery.notifications_last_digest_date#">
								</cfinvoke>

								<cfset var sendDPNotifications = checkNotificationsToUserResult.sendNotifications>

								<cfif sendDPNotifications IS true>

										<cfset var lastDigestDateDP = checkNotificationsToUserResult.lastDigestDate>
										<cfset var currentDigestDateDP = checkNotificationsToUserResult.currentDigestDate>
										<cfset var currentDigestDateDPFormatted = DateFormat(currentDigestDateDP, APPLICATION.dateFormat)>
										<cfset var lastDigestDateDPFormatted = DateFormat(lastDigestDateDP, APPLICATION.dateFormat)>
										<cfset var alertContentDP = "">

										<!--- Get DoPlanning Alerts --->
										<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getUserDiaryAlert" returnvariable="userDiaryAlertDP">
											<cfinvokeargument name="alertType" value="#ALERT_TYPE_DOPLANNING#">
											<cfinvokeargument name="user_id" value="#curUserId#">
											<cfinvokeargument name="language" value="#curLang#">
											<cfinvokeargument name="email" value="#curUserEmail#">
											<cfinvokeargument name="user_full_name" value="#curUserFullName#">
											<cfinvokeargument name="currentDigestDate" value="#currentDigestDateDP#">
											<cfinvokeargument name="lastDigestDate" value="#lastDigestDateDP#">
											<cfinvokeargument name="itemTypesStruct" value="#itemTypesStruct#">
											<cfinvokeargument name="itemTypesArray" value="#itemTypesArray#">
											<cfinvokeargument name="itemsTypesOptionsQuery" value="#itemsTypesOptionsQuery#">

											<cfinvokeargument name="client_abb" value="#client_abb#">
											<cfinvokeargument name="client_dsn" value="#client_dsn#">
										</cfinvoke>

										<cfif len(userDiaryAlertDP.alertContent) GT 0>

											<cfif lastDigestDateDPFormatted NEQ currentDigestDateDPFormatted>
												<cfset subjectAlertDP = "[#rootArea.name#] "&langText[curLang].notifications_digest.activity_summary&" #lastDigestDateDPFormatted# - #currentDigestDateDPFormatted#">
											<cfelse>
												<cfset subjectAlertDP = "[#rootArea.name#] "&langText[curLang].notifications_digest.activity_summary&" #lastDigestDateDPFormatted#">
											</cfif>

											<cfsavecontent variable="preAlertContentDP">
												<cfoutput>
												<p style="font-size:16px;">#langText[curLang].notifications_digest.activity_summary_for_user# #curUserFullName#	(<a href="mailto:#curUserEmail#" style="color:##35938">#curUserEmail#</a>)
												<cfif lastDigestDateDPFormatted EQ currentDigestDateDPFormatted>
													#lastDigestDateDPFormatted#
												<cfelse>
													#lastDigestDateDPFormatted# - #currentDigestDateDPFormatted#
												</cfif></p>
												</cfoutput>
											</cfsavecontent>

											<cfset alertContentDP = preAlertContentDP&userDiaryAlertDP.alertContent>
											<cfset alertContentDP = alertContentDP&"<br/><p>"&langText[curLang].notifications_digest.summary_advice&"</p>">

											<!--- sendEmail --->
											<cfinvoke component="#APPLICATION.componentsPath#/EmailManager" method="sendEmail">
												<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
												<cfinvokeargument name="to" value="#curUserEmail#">
												<cfinvokeargument name="subject" value="#subjectAlertDP#">
												<cfinvokeargument name="content" value="#alertContentDP#">
												<cfinvokeargument name="head_content" value="#headContent#">
												<cfinvokeargument name="foot_content" value="#footContent#">
											</cfinvoke>

											<!---<cfoutput>
												#alertContentDP#
											</cfoutput>--->

										</cfif>


										<cfquery name="updateUserLastDPNotificationsDate" datasource="#client_dsn#">
											UPDATE `#client_abb#_users` AS users
											SET notifications_last_digest_date = NOW()
											WHERE users.id = <cfqueryparam value="#curUserId#" cfsqltype="cf_sql_integer">;
										</cfquery>


									</cfif><!--- END sendDPNotifications IS true --->


								</cfif><!--- END isNumeric(getAllUsersQuery.notifications_digest_type_id) --->


								<!--- ------------------------------------------ WEB NOTIFICATIONS ------------------------------------------------ --->

								<cfif isNumeric(getAllUsersQuery.notifications_web_digest_type_id)>

									<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="checkIfSendNotificationsToUser" returnvariable="checkNotificationsToUserResult">
										<cfinvokeargument name="notificationsDigestTypeId" value="#getAllUsersQuery.notifications_web_digest_type_id#">
										<cfinvokeargument name="userLastDigestDate" value="#getAllUsersQuery.notifications_web_last_digest_date#">
									</cfinvoke>

									<cfset var sendWebNotifications = checkNotificationsToUserResult.sendNotifications>

									<cfif sendWebNotifications IS true>

										<cfset var lastDigestDateWeb = checkNotificationsToUserResult.lastDigestDate>
										<cfset var currentDigestDateWeb= checkNotificationsToUserResult.currentDigestDate>
										<cfset var currentDigestDateWebFormatted = DateFormat(currentDigestDateWeb, APPLICATION.dateFormat)>
										<cfset var lastDigestDateWebFormatted = DateFormat(lastDigestDateWeb, APPLICATION.dateFormat)>

										<!--- Send Web Alerts --->
										<!---Get web areas--->

										<cfinvoke component="#APPLICATION.coreComponentsPath#/WebQuery" method="getWebs" returnvariable="getWebQuery">
											<cfinvokeargument name="area_type" value="web">

											<cfinvokeargument name="client_abb" value="#client_abb#">
											<cfinvokeargument name="client_dsn" value="#client_dsn#">
										</cfinvoke>

										<cfif getWebQuery.recordCount GT 0>

											<!---<cfset userAreasIds = "">--->
											<cfset alertContentWeb = "">

											<cfloop query="getWebQuery">

												<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreasIds" returnvariable="subAreasIds">
													<cfinvokeargument name="area_id" value="#getWebQuery.area_id#">

													<cfinvokeargument name="client_abb" value="#client_abb#">
													<cfinvokeargument name="client_dsn" value="#client_dsn#">
												</cfinvoke>

												<!--- Get DoPlanning Alerts --->
												<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getUserDiaryAlert" returnvariable="userDiaryAlertWeb">
													<cfinvokeargument name="alertType" value="#ALERT_TYPE_WEB#">
													<cfinvokeargument name="user_id" value="#curUserId#">
													<cfinvokeargument name="language" value="#curLang#">
													<cfinvokeargument name="email" value="#curUserEmail#">
													<cfinvokeargument name="user_full_name" value="#curUserFullName#">
													<cfinvokeargument name="currentDigestDate" value="#currentDigestDateWeb#">
													<cfinvokeargument name="lastDigestDate" value="#lastDigestDateWeb#">
													<cfinvokeargument name="itemTypesStruct" value="#itemTypesStruct#">
													<cfinvokeargument name="itemTypesArray" value="#itemTypesArray#">
													<cfinvokeargument name="itemsTypesOptionsQuery" value="#itemsTypesOptionsQuery#">

													<cfinvokeargument name="userAreasIds" value="#subAreasIds#">
													<cfinvokeargument name="webPath" value="#getWebQuery.path#">
													<cfinvokeargument name="webPathUrl" value="#getWebQuery.path_url#">

													<cfinvokeargument name="client_abb" value="#client_abb#">
													<cfinvokeargument name="client_dsn" value="#client_dsn#">
												</cfinvoke>

												<cfif len(userDiaryAlertWeb.alertContent) GT 0>

													<cfif getWebQuery.recordCount GT 1>

														<cfset webLanguage = "">

														<cfswitch expression="#getWebQuery.language#">
															<cfcase value="es">
																<cfset webLanguage = "Español">
															</cfcase>
															<cfcase value="en">
																<cfset webLanguage = "English">
															</cfcase>
															<cfcase value="fr">
																<cfset webLanguage = "Français">
															</cfcase>
														</cfswitch>

														<cfset alertContentWeb = alertContentWeb&'<p style="margin-top:20px;font-size:26px">#webLanguage#</p>'&userDiaryAlertWeb.alertContent>

													<cfelse>

														<cfset alertContentWeb = alertContentWeb&userDiaryAlertWeb.alertContent>

													</cfif>

												</cfif>

											</cfloop>

											<cfif len(alertContentWeb) GT 0>

												<cfif lastDigestDateWebFormatted NEQ currentDigestDateWebFormatted>
													<cfset subjectWeb = "[#rootArea.name#] "&langText[curLang].notifications_digest.activity_summary_web&" #lastDigestDateWebFormatted# - #currentDigestDateWebFormatted#">
												<cfelse>
													<cfset subjectWeb = "[#rootArea.name#] "&langText[curLang].notifications_digest.activity_summary_web&" #lastDigestDateWebFormatted#">
												</cfif>

												<cfsavecontent variable="preAlertContentWeb">
													<cfoutput>
													<p style="font-size:16px;">#langText[curLang].notifications_digest.activity_summary_web#
													<cfif lastDigestDateWebFormatted EQ currentDigestDateWebFormatted>
														#lastDigestDateWebFormatted#
													<cfelse>
														#lastDigestDateWebFormatted# - #currentDigestDateWebFormatted#
													</cfif></p>
													</cfoutput>
												</cfsavecontent>

												<cfset alertContentWeb = preAlertContentWeb&alertContentWeb>

												<!--- sendEmail --->
												<cfinvoke component="#APPLICATION.componentsPath#/EmailManager" method="sendEmail">
													<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
													<cfinvokeargument name="to" value="#curUserEmail#">
													<cfinvokeargument name="subject" value="#subjectWeb#">
													<cfinvokeargument name="content" value="#alertContentWeb#">
													<cfinvokeargument name="head_content" value="#headContent#">
													<cfinvokeargument name="foot_content" value="#footContent#">
												</cfinvoke>


												<!---<cfoutput>
													#alertContentWeb#
												</cfoutput>--->

											</cfif><!--- END len(alertContentWeb) GT 0 --->

										</cfif><!---END getWebQuery.recordCount GT 0--->

										<cfquery name="updateUserLastWebNotificationsDate" datasource="#client_dsn#">
											UPDATE `#client_abb#_users` AS users
											SET notifications_web_last_digest_date = NOW()
											WHERE users.id = <cfqueryparam value="#curUserId#" cfsqltype="cf_sql_integer">;
										</cfquery>

									</cfif><!--- END sendWebNotifications --->

							</cfif><!--- END isNumeric(getAllUsersQuery.notifications_web_digest_type_id)--->



						</cfif><!--- END getAllUsersQuery.enabled IS true AND len(getAllUsersQuery.email) GT 0 AND getAllUsersQuery.no_notifications IS false --->

					</cfloop><!--- END loop query="getAllUsersQuery" --->


					</cfif><!--- END client_abb EQ "hcs" --->

					<cfcatch>
						<cfinclude template="includes/errorHandler.cfm">
					</cfcatch>

				</cftry>

			</cfloop><!--- END loop query="getClientsQuery" --->

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

	</cffunction>


	<!--- getUserDiaryAlert --->

	<cffunction name="getUserDiaryAlert" output="false" returntype="struct">
		<cfargument name="alertType" type="string" required="true"><!---doplanning / web--->
		<cfargument name="user_id" type="numeric" required="true">
		<cfargument name="language" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="currentDigestDate" type="date" required="true">
		<cfargument name="lastDigestDate" type="date" required="true">
		<cfargument name="itemTypesArray" type="array" required="true">
		<cfargument name="itemsTypesOptionsQuery" type="query" required="true">

		<cfargument name="userAreasIds" type="string" required="false">
		<cfargument name="webPath" type="string" required="false">
		<cfargument name="webPathUrl" type="string" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var curUserId = arguments.user_id>
		<cfset var curLang = arguments.language>
		<cfset var curUserEmail = arguments.email>
		<cfset var alertContent = "">


		<cfif arguments.alertType EQ ALERT_TYPE_WEB>

			<cfif NOT isDefined("arguments.userAreasIds") OR listLen(arguments.userAreasIds) IS 0>

				<cfthrow message="userAreasIds requerido para notificaciones web">

			</cfif>

		<cfelse>

			<cfset var userAreasIds = "">

			<cfinvoke component="AreaManager" method="getAllUserAreasList" returnvariable="userAreasIds">
				<cfinvokeargument name="get_user_id" value="#curUserId#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

		</cfif>

		<cfif listLen(userAreasIds) GT 0>

			<cfset var currentDigestDateFormatted = DateFormat(currentDigestDate, APPLICATION.dateFormat)>
			<cfset var lastDigestDateFormatted = DateFormat(lastDigestDate, APPLICATION.dateFormat)>

			<!--- getUserNotificationsCategoriesDisabled --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUserNotificationsCategoriesDisabled" returnvariable="userNotificationsDisabledQuery">
				<cfinvokeargument name="user_id" value="#curUserId#">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<!--- Loop items types --->
			<cfloop array="#itemTypesArray#" index="itemTypeId">

				<cfset var notifyItemType = true>

				<cfif arguments.alertType EQ ALERT_TYPE_WEB>

					<cfif itemTypeId EQ 2 OR itemTypeId EQ 9><!---Entries, Images--->
						<cfset notifyItemType = false>
					<cfelseif itemTypesStruct[itemTypeId].web IS false>
						<cfset notifyItemType = false>
					</cfif>

				<cfelse>

					<cfif itemTypesStruct[itemTypeId].noWeb IS false>
						<cfset notifyItemType = false>
					</cfif>

				</cfif>

				<cfif notifyItemType IS true>

					<cfset var itemTypeName = itemTypesStruct[itemTypeId].name>
					<cfset var itemTypeGender = itemTypesStruct[itemTypeId].gender>

					<cfset var categoriesAreasArray = arrayNew(1)>
					<cfset var noCategoriesSelected = false>

					<cfquery dbtype="query" name="itemTypeQuery">
						SELECT *
						FROM itemsTypesOptionsQuery
						WHERE item_type_id = <cfqueryparam value="#itemTypeId#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<cfif itemTypeQuery.recordCount GT 0 AND isNumeric(itemTypeQuery.category_area_id)><!--- Area category defined for the item --->

						<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreas" returnvariable="subAreasQuery">
							<cfinvokeargument name="area_id" value="#itemTypeQuery.category_area_id#">
							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

						<cfif subAreasQuery.recordCount GT 0><!--- Categories defined for the item --->

							<cfquery name="userNotificationsDisabledItem" dbtype="query">
								SELECT *
								FROM userNotificationsDisabledQuery
								WHERE item_type_id = <cfqueryparam value="#itemTypeId#" cfsqltype="cf_sql_integer">;
							</cfquery>

							<cfif userNotificationsDisabledItem.recordCount GT 0>

								<cfset categoriesAreasArray = queryColumnData(subAreasQuery,"id")>

								<cfloop query="userNotificationsDisabledItem">

									<cfset areaInArrayPosition = ArrayFind(categoriesAreasArray,userNotificationsDisabledItem.area_id)>

									<cfif areaInArrayPosition GT 0>

										<cfif arrayDeleteAt(categoriesAreasArray, areaInArrayPosition) IS false>
											<cfthrow message="Error al eliminar la posición #areaInArrayPosition# del array de categorías">
										</cfif>

									</cfif>

								</cfloop>

								<cfif arrayLen(categoriesAreasArray) IS 0>

									<cfset noCategoriesSelected = true>

								</cfif>

							</cfif>

						</cfif>

					</cfif><!--- END Category defined for the item --->


					<cfif noCategoriesSelected IS false>


						<cfif itemTypeId IS NOT 10>

							<cfinvoke component="AreaItemQuery" method="getAreaItems" returnvariable="getAreaItemsResult">
								<cfinvokeargument name="areas_ids" value="#userAreasIds#">
								<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
								<cfinvokeargument name="listFormat" value="true">
								<cfinvokeargument name="with_user" value="true">
								<cfinvokeargument name="with_area" value="true">
								<cfinvokeargument name="parse_dates" value="true"/>

								<cfinvokeargument name="from_date" value="#lastDigestDateFormatted#">
								<cfinvokeargument name="end_date" value="#currentDigestDateFormatted#">

								<cfif arguments.alertType EQ ALERT_TYPE_WEB AND APPLICATION.publicationValidation IS true>
									<cfinvokeargument name="published" value="true">
								<cfelse>
									<cfinvokeargument name="published" value="false">
								</cfif>

								<cfif arrayLen(categoriesAreasArray) GT 0>
									<cfinvokeargument name="categories_ids" value="#categoriesAreasArray#">
									<cfinvokeargument name="categories_condition" value="OR">
								</cfif>

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

							<cfset var itemsQuery = getAreaItemsResult.query>


						<cfelse><!--- Files --->


							<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getAreaFiles" returnvariable="getAreaFilesResult">
								<cfinvokeargument name="areas_ids" value="#userAreasIds#">
								<cfinvokeargument name="parse_dates" value="true">
								<cfinvokeargument name="with_user" value="true">
								<cfinvokeargument name="with_area" value="true">
								<cfinvokeargument name="with_typology" value="false">

								<cfinvokeargument name="from_date" value="#lastDigestDateFormatted#">
								<cfinvokeargument name="end_date" value="#currentDigestDateFormatted#">

								<cfif arguments.alertType EQ ALERT_TYPE_WEB AND APPLICATION.publicationValidation IS true>
									<cfinvokeargument name="published" value="true">
								<cfelse>
									<cfinvokeargument name="published" value="false">
								</cfif>

								<cfif arrayLen(categoriesAreasArray) GT 0>
									<cfinvokeargument name="categories_ids" value="#categoriesAreasArray#">
									<cfinvokeargument name="categories_condition" value="OR">
								</cfif>

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

							<cfset var itemsQuery = getAreaFilesResult.query>


						</cfif><!--- END itemTypeId IS NOT 10 --->

						<cfif itemsQuery.recordCount GT 0>

							<cfsavecontent variable="headItemsAlertContent">
								<cfoutput>
								<table style="width:100%;margin-top:15px;margin-bottom:20px;">
									<tr>
										<td style="padding:0"><!--- Title --->
											<span style="font-size:24px;font-weight:100;color:##000">#langText[curLang].item[itemTypeId].name_plural#</span>
										</td>
									</tr>
									<tr>
										<td style="border-collapse: collapse; background:none; border-bottom: 1px solid ##019ED3; height:1px; line-height:1px; width:100%; margin:0px 0px 0px 0px; padding-top:0;padding-bottom:0;">
											&nbsp;
										</td>
									</tr>
								</table>
								</cfoutput>
							</cfsavecontent>

							<cfset alertContent = alertContent&headItemsAlertContent>

							<cfset var itemsArray = arrayNew(1)>
							<cfinvoke component="Utils" method="queryToArray" returnvariable="itemsArray">
								<cfinvokeargument name="data" value="#itemsQuery#">
							</cfinvoke>

							<cfloop array="#itemsArray#" index="itemObject">

								<cfinvoke component="AlertManager" method="getItemDiaryAlertContent" returnvariable="itemAlertContent">
									<cfinvokeargument name="item" value="#itemObject#">
									<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
									<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
									<cfinvokeargument name="itemTypeGender" value="#itemTypeGender#">
									<cfinvokeargument name="language" value="#curLang#">

									<cfinvokeargument name="alertType" value="#arguments.alertType#">
									<cfinvokeargument name="webPathUrl" value="#arguments.webPathUrl#">
									<cfinvokeargument name="webPath" value="#arguments.webPath#">

									<cfinvokeargument name="client_abb" value="#client_abb#">
								</cfinvoke>

								<cfset alertContent = alertContent&itemAlertContent>

							</cfloop>

						<cfelse>

							<!---<cfoutput>
							No hay elementos: #itemTypeId#
							</cfoutput>--->

						</cfif><!--- END itemsQuery.recordCount GT 0 --->

					<cfelse>

					<!---<cfoutput>
						Ninguna categoría seleccionada: #itemTypeId#
					</cfoutput>--->


					</cfif><!--- END noCategoriesSelected IS false --->

				</cfif><!--- END notifyItemType --->

			</cfloop><!--- END array="#itemTypesArray#" --->



			<!--- Areas --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getAreas" returnvariable="getAreasResponse">
				<cfinvokeargument name="from_date" value="#lastDigestDateFormatted#">
				<cfinvokeargument name="end_date" value="#currentDigestDateFormatted#">
				<cfinvokeargument name="areas_ids" value="#userAreasIds#"/>
				<cfinvokeargument name="order_by" value="creation_date">
				<cfinvokeargument name="order_type" value="DESC">
				<cfinvokeargument name="parse_dates" value="true">
				<cfif arguments.alertType EQ ALERT_TYPE_WEB>
					<cfinvokeargument name="remove_order" value="true">
				</cfif>

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset areasQuery = getAreasResponse.areas>

			<cfif areasQuery.recordCount GT 0>

				<cfsavecontent variable="headAreasAlertContent">
					<cfoutput>
					<table style="width:100%;margin-top:15px;margin-bottom:20px;">
						<tr>
							<td style="padding:0"><!--- Title --->
								<span style="font-size:24px;font-weight:100;color:##000">
									<cfif arguments.alertType EQ ALERT_TYPE_WEB>
										#langText[curLang].common.pages#
									<cfelse>
										#langText[curLang].common.areas#
									</cfif>
								</span>
							</td>
						</tr>
						<tr>
							<td style="border-collapse: collapse; background:none; border-bottom: 1px solid ##019ED3; height:1px; line-height:1px; width:100%; margin:0px 0px 0px 0px; padding-top:0;padding-bottom:0;">
								&nbsp;
							</td>
						</tr>
					</table>
					</cfoutput>
				</cfsavecontent>
				<cfset alertContent = alertContent&headAreasAlertContent>

				<cfloop query="areasQuery">

					<cfset areaName = areasQuery.area_name>
					<cfset areaCreationDate = areasQuery.creation_date>
					<cfset spacePos = findOneOf(" ", areaCreationDate)>

					<cfif arguments.alertType EQ ALERT_TYPE_WEB>

						<!---areaWebUrl--->
						<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaWebPageFullUrl" returnvariable="areaUrl">
							<cfinvokeargument name="area_id" value="#areasQuery.area_id#">
							<cfinvokeargument name="name" value="#areasQuery.area_name#">
							<cfinvokeargument name="remove_order" value="true">
							<cfinvokeargument name="path_url" value="#arguments.webPathUrl#">
							<cfinvokeargument name="path" value="#arguments.webPath#">
						</cfinvoke>

					<cfelse>

						<!---areaUrl--->
						<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaUrl" returnvariable="areaUrl">
							<cfinvokeargument name="area_id" value="#areasQuery.area_id#">
							<cfinvokeargument name="client_abb" value="#client_abb#">
						</cfinvoke>

					</cfif>

					<cfsavecontent variable="areaContent">
						<cfoutput>
						<a href="#areaUrl#" target="_blank" style="font-size:18px;font-weight:100;color:##009ed2">#areaName#</a><br/>

						<span style="font-size:16px;color:254c65;font-weight:100;white-space:nowrap">#left(areaCreationDate, spacePos)#</span>&nbsp;&nbsp;<span style="font-size:16px;color:##888;font-weight:100;white-space:nowrap;">#right(areaCreationDate, len(areaCreationDate)-spacePos)#</span>

						<br/><br/>
						</cfoutput>
					</cfsavecontent>
					<cfset alertContent = alertContent&areaContent>


				</cfloop><!--- END loop areas --->

			</cfif><!--- END areasQuery.recordCount GT 0 --->


			<cfif arguments.alertType NEQ ALERT_TYPE_WEB>

				<!--- Users to areas --->

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getAreaUsers" returnvariable="usersQuery">
					<cfinvokeargument name="from_date" value="#lastDigestDateFormatted#">
					<cfinvokeargument name="end_date" value="#currentDigestDateFormatted#">
					<cfinvokeargument name="areas_ids" value="#userAreasIds#"/>
					<cfinvokeargument name="order_by" value="association_date">
					<cfinvokeargument name="order_type" value="DESC">
					<cfinvokeargument name="parse_dates" value="true">
					<cfinvokeargument name="with_area" value="true">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif usersQuery.recordCount GT 0>

					<cfsavecontent variable="headAreasAlertContent">
						<cfoutput>
						<table style="width:100%;margin-top:15px;margin-bottom:20px;">
							<tr>
								<td style="padding:0"><!--- Title --->
									<span style="font-size:24px;font-weight:100;color:##000">#langText[curLang].common.users#</span>
								</td>
							</tr>
							<tr>
								<td style="border-collapse: collapse; background:none; border-bottom: 1px solid ##019ED3; height:1px; line-height:1px; width:100%; margin:0px 0px 0px 0px; padding-top:0;padding-bottom:0;">
									&nbsp;
								</td>
							</tr>
						</table>
						</cfoutput>
					</cfsavecontent>
					<cfset alertContent = alertContent&headAreasAlertContent>

					<cfloop query="usersQuery">

						<!---areaUrl--->
						<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaUrl" returnvariable="areaUrl">
							<cfinvokeargument name="area_id" value="#usersQuery.area_id#">
							<cfinvokeargument name="client_abb" value="#client_abb#">
						</cfinvoke>

						<cfset userFullName = usersQuery.user_full_name>
						<cfset areaName = usersQuery.area_name>
						<cfset associationDate = usersQuery.association_date>

						<cfset spacePos = findOneOf(" ", associationDate)>

						<cfsavecontent variable="userContent">
							<cfoutput>
							<span style="font-size:18px;color:##35938c;font-weight:100">#userFullName#</span>&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:16px;color:254c65;font-weight:100;white-space:nowrap">#left(associationDate, spacePos)#</span>&nbsp;&nbsp;<span style="font-size:16px;color:##888;font-weight:100;white-space:nowrap;">#right(associationDate, len(associationDate)-spacePos)#</span><br/>
							<span style="font-size:16px;margin-top:0">Área:</span> <a href="#areaUrl#" target="_blank" style="font-size:16px;font-weight:100;color:##009ed2">#areaName#</a><br/>

							<br/><br/>
							</cfoutput>
						</cfsavecontent>
						<cfset alertContent = alertContent&userContent>

					</cfloop><!--- END loop areas --->

				</cfif><!--- END usersQuery.recordCount GT 0 --->

			</cfif><!--- END arguments.alertType NEQ ALERT_TYPE_WEB --->

		</cfif><!--- END listLen(userAreasIds) GT 0 --->


		<cfreturn {alertContent=alertContent}>

	</cffunction>



	<!--- --------------------------- getItemDiaryAlertContent --------------------------- --->

	<cffunction name="getItemDiaryAlertContent" output="false" access="private" returntype="string">
		<cfargument name="item" type="struct" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="itemTypeName" type="string" required="true">
		<cfargument name="itemTypeGender" type="string" required="true">
		<cfargument name="language" type="string" required="true">

		<cfargument name="alertType" type="string" required="false" default="#ALERT_TYPE_DOPLANNING#">
		<cfargument name="webPath" type="string" required="false">
		<cfargument name="webPathUrl" type="string" required="false">

		<cfargument name="client_abb" type="string" required="true">

		<cfset var method = "getItemFootContent">

		<cfset var itemContent = "">
		<cfset var actionDate = "">
		<cfset var actionBoxText = "">
		<cfset var actionBox = "">


			<cfif arguments.alertType EQ ALERT_TYPE_WEB>

				<cfif itemTypeId EQ 4 OR itemTypeId EQ 5 OR itemTypeId EQ 8><!--- News, event or publication --->

					<!---itemWebUrl--->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getItemWebPageFullUrl" returnvariable="areaItemUrl">
						<cfinvokeargument name="item_id" value="#item.id#">
						<cfinvokeargument name="itemTypeId" value="#itemTypeId#">

						<cfinvokeargument name="title" value="#item.title#">
						<cfinvokeargument name="path_url" value="#arguments.webPathUrl#">
						<cfinvokeargument name="path" value="#arguments.webPath#">
					</cfinvoke>

				<cfelse>

					<!---areaWebUrl--->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaWebPageFullUrl" returnvariable="areaItemUrl">
						<cfinvokeargument name="area_id" value="#item.area_id#">
						<cfinvokeargument name="name" value="#item.area_name#">
						<cfinvokeargument name="remove_order" value="true">
						<cfinvokeargument name="path_url" value="#arguments.webPathUrl#">
						<cfinvokeargument name="path" value="#arguments.webPath#">
					</cfinvoke>

				</cfif>

			<cfelse>

				<!---itemUrl--->
				<cfinvoke component="UrlManager" method="getAreaItemUrl" returnvariable="areaItemUrl">
					<cfinvokeargument name="item_id" value="#item.id#">
					<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
					<cfinvokeargument name="area_id" value="#item.area_id#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				</cfinvoke>

			</cfif>


			<cfif itemTypeId NEQ 10>

				<cfif itemTypeId EQ 1 OR itemTypeId EQ 7 OR item.creation_date EQ item.last_update_date>

					<cfset actionDate = item.creation_date>

				<cfelse>

					<cfset actionDate = item.creation_date>

					<cfif itemTypeGender EQ "male">
						<cfset actionBoxText = langText[language].new_item.modified_male>
					<cfelse>
						<cfset actionBoxText = langText[language].new_item.modified_female>
					</cfif>

				</cfif>

			<cfelse><!--- Files --->

				<cfif isDate(item.replacement_date)>

					<cfset actionDate = item.replacement_date>

					<cfset actionBoxText = langText[language].new_file.replaced>

				<cfelse>

					<cfset actionDate = item.uploading_date>

				</cfif>


			</cfif>

			<cfif len(actionBoxText) GT 0>

				<cfsavecontent variable="actionBox">
					<cfoutput>
					<table style="background-color:##019ed3;border-radius:4px;display:inline-block;">
						<tr>
							<td style="color:##FFFFFF;padding-left:2px;padding-right:2px;">
								#actionBoxText#
							</td>
						</tr>
					</table>
					</cfoutput>
				</cfsavecontent>

			</cfif>

			<cfset spacePos = findOneOf(" ", actionDate)>

			<cfif itemTypeId NEQ 10>
				<cfset itemTitle = item.title>
			<cfelse>
				<cfset itemTitle = item.name>
			</cfif>

			<cfif len(itemTitle) IS 0>
				<cfset itemTitle = "<i>"&langText[language].item[itemTypeId].name&" "&langText[language].common.no_title&"</i>">
			</cfif>

			<cfsavecontent variable="itemContent">
				<cfoutput>
				<a href="#areaItemUrl#" target="_blank" style="font-size:18px;font-weight:100;color:##009ed2">#itemTitle#</a>&nbsp;&nbsp;#actionBox#<br/>

				<span style="font-size:16px;color:##35938c;font-weight:100">#item.user_full_name#</span>&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-size:16px;color:254c65;font-weight:100;white-space:nowrap">#left(actionDate, spacePos)#</span><cfif itemTypeId NEQ 4>&nbsp;&nbsp;<span style="font-size:16px;color:##888;font-weight:100;white-space:nowrap;">#right(actionDate, len(actionDate)-spacePos)#</span></cfif>

				<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->
				<p style="font-size:16px;margin-top:0;">#langText[arguments.language].new_item.start_date#: #item.start_date# <cfif itemTypeId IS 5>#langText[arguments.language].new_item.hour#: #TimeFormat(item.start_time,"HH:mm")#</cfif><br/>
					<cfif itemTypeId IS 6><!--- Task --->
						#langText[arguments.language].new_item.end_date#: <b>#item.end_date#</b>
					<cfelse>
						#langText[arguments.language].new_item.end_date#: #item.end_date# <cfif itemTypeId IS 5>#langText[arguments.language].new_item.hour#: #TimeFormat(item.end_time,"HH:mm")#</cfif>
					</cfif>
				</p>
				<cfelse>
					<br/><br/>
				</cfif>
				</cfoutput>
			</cfsavecontent>

		<cfreturn itemContent>

	</cffunction>


	<!--- --------------------------- getDiaryAlertFootContent --------------------------- --->

	<cffunction name="getDiaryAlertFootContent" access="private" returntype="string">
		<cfargument name="language" type="string" required="true">

		<cfset var method = "getDiaryAlertFootContent">

		<cfset var footContent = "">

		<cfset footContent = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;"><span style="color:##FF0000; font-size:12px;">#langText[arguments.language].common.foot_do_not_reply#.</span><br/>#langText[arguments.language].common.foot_content_default_1# #APPLICATION.title#.<br />#langText[arguments.language].new_item.foot_content_3#.</p>'>

		<cfreturn footContent>

	</cffunction>


	<!--- -------------------------------------- newFile ------------------------------------ --->
	<!---new/associate/replace/delete file--->
	<cffunction name="newFile" access="public" returntype="void">
		<cfargument name="objectFile" type="query" required="yes">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="itemCategories" type="query" required="false">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="user_id" type="numeric" required="false">
		<cfargument name="fileVersionQuery" type="query" required="false">
		<cfargument name="action" type="string" required="yes"><!---new/associate/replace/dissociate/delete/lock/unlock/new_version/new_current_version/...--->

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "newFile">

		<cfset var fileItemTypeId = 10>

		<cfset var internalUsersEmails = "">
		<cfset var externalUsersEmails = "">
        <cfset var listInternalUsers = "">
		<cfset var listExternalUsers = "">
		<cfset var area_name = "">
		<cfset var area_path = "">
        <cfset var root_area = structNew()>
		<cfset var access_content = "">
		<cfset var foot_content = "">
		<cfset var fileAlertContent = "">
		<cfset var alertContent = "">
		<cfset var actionUserName = "">
		<cfset var userAndDateContent = "">

		<!---Get area name--->
		<cfquery name="selectAreaQuery" datasource="#client_dsn#">
			SELECT id, name
			FROM #client_abb#_areas
			WHERE id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
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

		<!---<cfsavecontent variable="getUsersParameters">
			<cfoutput>
				 <user id="" email=""
			telephone=""
			sms_allowed="" whole_tree_visible="">
					<family_name><![CDATA[]]></family_name>
					<name><![CDATA[]]></name>
				</user>
				<area id="#area_id#"/>
				<order parameter="family_name" order_type="asc" />
				<cfif arguments.action NEQ "delete_virus" AND arguments.action NEQ "delete_version_virus"><!---delete_virus y delete_version_virus se envía a todos los usuarios --->
					<preferences
					<cfswitch expression="#arguments.action#">

						<cfcase value="new,associate">
							notify_new_file="true"
						</cfcase>

						<cfcase value="replace,new_version,new_current_version,validate_version,reject_version,approve_version,cancel_revision,change_owner_to_area">
							notify_replace_file="true"
						</cfcase>

						<cfcase value="dissociate,delete">
							notify_delete_file="true"
						</cfcase>

						<cfcase value="lock,unlock">
							notify_lock_file="true"
						</cfcase>

					</cfswitch>
					<!---<cfif arguments.action EQ "replace" OR arguments.action EQ "new_version">

					<cfelseif arguments.action EQ "dissociate" OR arguments.action EQ "delete">

					<cfelseif arguments.action EQ "lock" OR arguments.action EQ "unlock">

					<cfelse>

					</cfif>--->>
					</preferences>
				</cfif>
			</cfoutput>
		</cfsavecontent>

		<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="createRequest" returnvariable="getUsersRequest">
			<cfinvokeargument name="request_parameters" value="#getUsersParameters#">
		</cfinvoke>--->

		<!--- getItemCategories --->
		<cfif NOT isDefined("arguments.itemCategories")>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItemCategories" returnvariable="itemCategories">
				<cfinvokeargument name="item_id" value="#objectFile.id#">
				<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#">
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

		</cfif>

        <cfinvoke component="UserManager" method="getUsersToNotifyLists" returnvariable="usersToNotifyLists">
			<!---<cfinvokeargument name="request" value="#getUsersRequest#"/>--->
			<cfinvokeargument name="area_id" value="#area_id#">

			<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#">
			<cfinvokeargument name="categories_ids" value="#valueList(itemCategories.category_id)#">

			<cfswitch expression="#arguments.action#">

				<cfcase value="new,associate">
					<cfinvokeargument name="notify_new_file" value="true">
				</cfcase>

				<cfcase value="replace,new_version,new_current_version,validate_version,reject_version,approve_version,cancel_revision,change_owner_to_area">
					<cfinvokeargument name="notify_replace_file" value="true">
				</cfcase>

				<cfcase value="dissociate,delete">
					<cfinvokeargument name="notify_delete_file" value="true">
				</cfcase>

				<cfcase value="lock,unlock">
					<cfinvokeargument name="notify_lock_file" value="true">
				</cfcase>

			</cfswitch>

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

					<cfcase value="new"><!--- new (Only area file) --->
						<cfset subject_action = langText[curLang].new_file.area_file>
						<cfset action_value = langText[curLang].new_file.created>
					</cfcase>

					<cfcase value="associate"><!--- associate --->
						<cfset subject_action = langText[curLang].new_file.file>
						<cfset action_value = langText[curLang].new_file.added>
					</cfcase>

					<cfcase value="replace"><!--- replace --->
						<cfset subject_action = langText[curLang].new_file.replaced_file>
						<cfset action_value = langText[curLang].new_file.replaced>
					</cfcase>

					<cfcase value="dissociate"><!--- dissociate --->
						<cfset subject_action = langText[curLang].new_file.dissociated_file>
						<cfset action_value = langText[curLang].new_file.dissociated>
					</cfcase>

					<cfcase value="delete"><!--- delete --->
						<cfset subject_action = langText[curLang].new_file.deleted_file>
						<cfset action_value = langText[curLang].new_file.deleted>
					</cfcase>

					<cfcase value="delete_virus"><!--- delete_virus --->
						<cfset subject_action = langText[curLang].new_file.deleted_file_virus>
						<cfset action_value = langText[curLang].new_file.deleted>
					</cfcase>

					<cfcase value="delete_version"><!--- delete_version --->
						<cfset subject_action = langText[curLang].new_file.deleted_version>
						<cfset action_value = langText[curLang].new_file.deleted>
					</cfcase>

					<cfcase value="delete_version_virus"><!--- delete_version_virus --->
						<cfset subject_action = langText[curLang].new_file.deleted_version_virus>
						<cfset action_value = langText[curLang].new_file.deleted>
					</cfcase>

					<cfcase value="lock"><!--- lock --->
						<cfset subject_action = langText[curLang].new_file.locked_file>
						<cfset action_value = langText[curLang].new_file.locked>
					</cfcase>

					<cfcase value="unlock"><!--- unlock --->
						<cfset subject_action = langText[curLang].new_file.unlocked_file>
						<cfset action_value = langText[curLang].new_file.unlocked>
					</cfcase>

					<cfcase value="new_version"><!--- new_version --->
						<cfset subject_action = langText[curLang].new_file.new_version>
						<cfset action_value = langText[curLang].new_file.new_version>
					</cfcase>

					<cfcase value="new_current_version"><!--- new_current_version --->
						<cfset subject_action = langText[curLang].new_file.new_current_version>
						<cfset action_value = langText[curLang].new_file.new_current_version>
					</cfcase>

					<cfcase value="validate_version"><!--- validate_version --->
						<cfset subject_action = langText[curLang].new_file.validated_version>
						<cfset action_value = langText[curLang].new_file.validated>
					</cfcase>

					<cfcase value="reject_version"><!--- reject_version --->
						<cfset subject_action = langText[curLang].new_file.rejected_version>
						<cfset action_value = langText[curLang].new_file.rejected>
					</cfcase>

					<cfcase value="approve_version"><!--- approve_version --->
						<cfset subject_action = langText[curLang].new_file.approved_version>
						<cfset action_value = langText[curLang].new_file.approved>
					</cfcase>

					<cfcase value="cancel_revision"><!--- cancel_revision --->
						<cfset subject_action = langText[curLang].new_file.canceled_revision>
						<cfset action_value = langText[curLang].new_file.canceled_revision>
					</cfcase>

					<cfcase value="change_owner_to_area"><!--- change_owner_to_area --->
						<cfset subject_action = langText[curLang].new_file.changed_owner_to_area>
						<cfset action_value = langText[curLang].new_file.changed_owner_to_area>
					</cfcase>

				</cfswitch>

				<cfset subject = "[#root_area.name#][#subject_action#] "&objectFile.name>

				<!---
				<cfif arguments.action NEQ "dissociate" AND arguments.action NEQ "delete" AND arguments.action NEQ "delete_virus">

					<cfinvoke component="AlertManager" method="getFileAccessContent" returnvariable="access_content">
						<cfinvokeargument name="file_id" value="#objectFile.id#"/>
						<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
						<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
						<cfinvokeargument name="language" value="#curLang#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					</cfinvoke>

				</cfif>
				--->

				<!--- getHeadContent --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getHeadContent" returnvariable="head_content">
					<cfinvokeargument name="language" value="#curLang#">
					<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
				</cfinvoke>

				<!--- getAreaFileUrl --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaFileUrl" returnvariable="areaFileUrl">
					<cfinvokeargument name="file_id" value="#objectFile.id#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				</cfinvoke>

				<!--- getItemHeadContent --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemHeadContent" returnvariable="itemHeadContent">
					<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#"/>
					<cfinvokeargument name="itemTypeName" value="file"/>
					<cfinvokeargument name="itemTitle" value="#objectFile.name#"/>
					<cfinvokeargument name="itemUrl" value="#areaFileUrl#"/>
					<cfinvokeargument name="action" value="#arguments.action#"/>
					<cfinvokeargument name="language" value="#curLang#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
				</cfinvoke>

				<cfsavecontent variable="alertItemHead">
					<cfif arguments.action EQ "attached_file_deleted_virus" OR arguments.action EQ "attached_image_deleted_virus"><!--- DELETE VIRUS --->

						<b>#langText[curLang].new_item.virus_description#</b>:<br/>
						<i style="color:##FF0000;">#arguments.anti_virus_check_result#</i><br/>
						#langText[curLang].new_file.virus_advice#.<br/><br/>

					</cfif>

					#itemHeadContent#
				</cfsavecontent>

				<!--- getItemButtons --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemButtons" returnvariable="itemButtonsContent">
					<cfinvokeargument name="item_id" value="#objectFile.id#"/>
					<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#"/>
					<cfinvokeargument name="itemTypeName" value="file"/>
					<cfinvokeargument name="itemUrl" value="#areaFileUrl#"/>
					<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
					<cfinvokeargument name="action" value="#arguments.action#"/>
					<cfinvokeargument name="language" value="#curLang#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
				</cfinvoke>

				<cfif isDefined("arguments.user_id")>

					<cfset actionDate = dateFormat(now(), APPLICATION.dateFormat)&" "&timeFormat(now(), "HH:mm:ss")>

					<cfif action_value EQ "new">
						<cfset actionBoxText = "">
					<cfelse>
						<cfset actionBoxText = action_value>
					</cfif>

					<!--- getUserAndDateContent --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getUserAndDateContent" returnvariable="userAndDateContent">
						<cfinvokeargument name="user_id" value="#arguments.user_id#"/>
						<cfinvokeargument name="actionUserFullName" value="#actionUserName#"/>
						<cfinvokeargument name="actionDate" value="#actionDate#"/>
						<cfinvokeargument name="action" value="#arguments.action#"/>
						<cfinvokeargument name="actionBoxText" value="#actionBoxText#"/>
						<cfinvokeargument name="language" value="#curLang#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
					</cfinvoke>

				</cfif>


				<cfinvoke component="AlertManager" method="getFileFootContent" returnvariable="foot_content">
					<cfinvokeargument name="language" value="#curLang#">
				</cfinvoke>

				<cfinvoke component="AlertManager" method="getFileAlertContent" returnvariable="fileAlertContent">
					<cfinvokeargument name="objectFile" value="#objectFile#">
					<cfinvokeargument name="language" value="#curLang#">
				</cfinvoke>

				<cfsavecontent variable="alertContent">
					<cfoutput>

					#itemButtonsContent#

					<table style="width:100%;border-radius:4px;border-color:##dddddd;border-style:solid;border-width:1px;margin-top:10px;box-shadow:0 1px 4px rgba(0,0,0,0.3);padding:15px;"><!--- item container table --->


						<cfif arguments.action NEQ "delete_version" AND arguments.action NEQ "delete_version_virus">

							#userAndDateContent#

						</cfif>

						<tr style="padding-top:0;padding-bottom:0;margin-top:0;margin-bottom:0">
							<td style="padding-top:0;padding-bottom:0;margin-top:0;margin-bottom:0;font-size:14px;">


							<!---<cfif arguments.action NEQ "new" AND arguments.action NEQ "associate">
								<strong>#subject_action#</strong>:<br/><br/>
							</cfif>--->

							<cfif arguments.action NEQ "delete_version" AND arguments.action NEQ "delete_version_virus">
								#langText[curLang].new_file.user#: <strong><cfif len(actionUserName) GT 0>#actionUserName#<cfelse>#objectFile.user_full_name#</cfif></strong><br />

								#fileAlertContent#
							</cfif>

							<cfif arguments.action EQ "delete_version" OR arguments.action EQ "delete_version_virus"><!--- DELETE VERSION --->

								<!---File version --->
								#langText[curLang].new_file.file_name#: <strong>#objectFile.name#</strong><br />
								#langText[curLang].new_file.user#: <strong>#arguments.fileVersionQuery.user_full_name#</strong><br />
								#langText[curLang].new_file.file#: <strong>#arguments.fileVersionQuery.file_name#</strong><br />
								#langText[curLang].new_file.upload_date#: <strong>#arguments.fileVersionQuery.uploading_date#</strong><br/>

							<cfelseif arguments.action EQ "reject_version"><!--- REJECT VERSION --->

								<!--- getFileVersion --->
								<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersions" returnvariable="getFileVersionsQuery">
									<cfinvokeargument name="file_id" value="#objectFile.id#">
									<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
									<cfinvokeargument name="limit" value="1">

									<cfinvokeargument name="client_abb" value="#client_abb#">
									<cfinvokeargument name="client_dsn" value="#client_dsn#">
								</cfinvoke>

								<cfset lastFileVersion = getFileVersionsQuery>

								<cfif lastFileVersion.revised IS true AND lastFileVersion.revision_result IS true><!---Approval reject--->
									#langText[curLang].file_approval.reject_reason#:<br/>
									<i>#lastFileVersion.approval_result_reason#</i><br/>
								<cfelse><!---Revision reject--->
								 	#langText[curLang].file_revision.reject_reason#:<br/>
									<i>#lastFileVersion.revision_result_reason#</i><br/>
								</cfif>

							</cfif>

							<cfif arguments.action EQ "delete_virus" OR arguments.action EQ "delete_version_virus"><!--- DELETE VIRUS --->
								<br/>
								<b>#langText[curLang].new_file.virus_description#</b>:<br/>
								<i style="color:##FF0000;">#objectFile.anti_virus_check_result#</i><br/>
								#langText[curLang].new_file.virus_advice#.<br/>

							</cfif>

							<!---<cfif len(access_content) GT 0>
								<br/>
								<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>
							</cfif>--->

							<cfif arguments.action NEQ "dissociate" AND arguments.action NEQ "delete" AND arguments.action NEQ "delete_virus">

								<table style="width:100%;margin-top:20px;">
									<tr>
										<td><!--- Share icon --->
											<img src="#APPLICATION.mainUrl##APPLICATION.htmlPath#/assets/v3/emails/icon_share.png" alt="#langText[curLang].common.go_to_item#"/>
										</td>
										<td style="padding-top:5px;">
											<a href="#areaFileUrl#" title="#langText[curLang].common.go_to_item#" style="color:##ababab;font-size:16px;text-decoration:none">#areaFileUrl#</a>
										</td>
									</tr>
									<tr>
										<td></td>
										<td style="background:none; border-top: 1px solid ##ddd; height:1px; line-height:1px; width:100%; margin:0px 0px 0px 0px; padding-bottom:10px;">&nbsp;
										</td>
									</tr>
								</table>

							</cfif>


							</td>
						</tr>
					</table><!--- END item container table --->
					</cfoutput>
				</cfsavecontent>


				<!---INTERNAL USERS--->
				<cfif len(listInternalUsers) GT 0>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getAreaPathContent" returnvariable="area_path">
						<cfinvokeargument name="area_id" value="#area_id#">
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

					<cfprocessingdirective suppresswhitespace="true">
					<cfsavecontent variable="contentInternal">
					<cfoutput>
			<!--- #langText[curLang].new_file.it_has# #action_value# #langText[curLang].new_file.a_file_on_the_area# ---><!---#langText[curLang].common.area#: <strong>#area_name#</strong>.<br/>
			#langText[curLang].common.area_path#: #area_path#.<br/><br/>--->
			#itemHeadContent#

			#area_path#

			#alertContent#
					</cfoutput>
					</cfsavecontent>
					</cfprocessingdirective>

					<cfinvoke component="EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
						<cfif len(actionUserName) GT 0 AND arguments.action NEQ "delete_virus" AND arguments.action NEQ "delete_version_virus">
							<cfinvokeargument name="from_name" value="#actionUserName#">
						</cfif>
						<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
						<cfinvokeargument name="bcc" value="#listInternalUsers#">
						<cfinvokeargument name="subject" value="#subject#">
						<cfinvokeargument name="content" value="#contentInternal#">
						<cfinvokeargument name="head_content" value="#head_content#">
						<cfinvokeargument name="foot_content" value="#foot_content#">
					</cfinvoke>

				</cfif>


				<!---EXTERNAL USERS--->
				<cfif len(listExternalUsers) GT 0>

					<cfprocessingdirective suppresswhitespace="true">
					<cfsavecontent variable="contentExternal">
					<cfoutput>
			#itemHeadContent#

			<!--- #langText[curLang].new_file.it_has# #action_value# #langText[curLang].new_file.a_file_on_the_area#
			#langText[curLang].common.area#: <strong>#area_name#</strong>
			#langText[curLang].common.of_the_organization# #root_area.name#.<br/><br/>--->

			<p><a href="#APPLICATION.mainUrl#/?abb=#arguments.client_abb#&area=#arguments.area_id#" style="color:##009ed2;text-decoration:underline;font-size:15px;">#area_name#</a></p>

			#alertContent#
					</cfoutput>
					</cfsavecontent>
					</cfprocessingdirective>

					<cfinvoke component="EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
						<cfinvokeargument name="from_name" value="#objectFile.user_full_name#">
						<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
						<cfinvokeargument name="bcc" value="#listExternalUsers#">
						<cfinvokeargument name="subject" value="#subject#">
						<cfinvokeargument name="content" value="#contentExternal#">
						<cfinvokeargument name="head_content" value="#head_content#">
						<cfinvokeargument name="foot_content" value="#foot_content#">
					</cfinvoke>

				</cfif>

			</cfif><!---END len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0--->

		</cfloop><!---END APPLICATION.languages loop--->

	</cffunction>



	<!--- --------------------------- getFileAlertContent --------------------------- --->

	<cffunction name="getFileAlertContent" access="private" returntype="string">
		<cfargument name="objectFile" type="query" required="true">
		<cfargument name="language" type="string" required="true">

		<cfset var method = "getFileAlertContent">

		<cfset var alertContent = "">

		<cfsavecontent variable="alertContent">
			<cfoutput>
			#langText[arguments.language].new_file.file_name#: <strong>#objectFile.name#</strong><br />
			#langText[arguments.language].new_file.file#: <strong>#objectFile.file_name#</strong><br />
			#langText[arguments.language].new_file.upload_date#: <strong>#objectFile.uploading_date#</strong><br/>
			<cfif len(objectFile.replacement_date) GT 0>
				<cfif objectFile.file_type_id IS NOT 3>
					#langText[arguments.language].new_file.replacement_date#: <strong>#objectFile.replacement_date#</strong><br/>
				<cfelse>
					#langText[arguments.language].new_file.last_version_date#: <strong>#objectFile.replacement_date#</strong><br/>
				</cfif>
			</cfif>
			<cfif isDefined("objectFile.publication_date") AND len(objectFile.publication_date) GT 0>
				#langText[arguments.language].new_item.publication_date#: <b>#objectFile.publication_date#</b><br/>
			</cfif>
			<cfif APPLICATION.publicationValidation IS true AND isDefined("objectFile.publication_date") AND len(objectFile.publication_validated) GT 0>
				#langText[arguments.language].new_item.publication_validated#: <b><cfif objectFile.publication_validated IS true>#langText[arguments.language].new_item.yes#<cfelse>#langText[arguments.language].new_item.no#</cfif></b><br/>
			</cfif>
			<cfif APPLICATION.publicationScope IS true AND len(objectFile.publication_scope_name) GT 0>
			#langText[arguments.language].new_item.publication_scope#: <strong>#objectFile.publication_scope_name#</strong><br/>
			</cfif>
			#langText[arguments.language].new_file.description#:<br/><br/>
			<div style="padding-left:15px;">#objectFile.description#</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn alertContent>

	</cffunction>


	<!--- --------------------------- getFileAccessContent --------------------------- --->

	<cffunction name="getFileAccessContent" access="private" returntype="string">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="language" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">

		<cfset var method = "getFileAccessContent">

		<cfset var accessContent = "">
		<cfset var accessClient = "">

		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaFileUrl" returnvariable="areaFileUrl">
			<cfinvokeargument name="file_id" value="#arguments.file_id#">
			<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
			<cfinvokeargument name="area_id" value="#arguments.area_id#">
			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaFileUrl" returnvariable="downloadFileUrl">
			<cfinvokeargument name="file_id" value="#arguments.file_id#">
			<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
			<cfinvokeargument name="area_id" value="#arguments.area_id#">
			<cfinvokeargument name="download" value="true">
			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
		</cfinvoke>


		<cfif APPLICATION.twoUrlsToAccess IS false>

			<cfsavecontent variable="accessContent">
			<cfoutput>
			-&nbsp;<b>#langText[language].new_file.access_to_file#</b>:
			<a target="_blank" href="#areaFileUrl#">#areaFileUrl#</a>

			<br/>-&nbsp;#langText[language].new_file.access_to_download_file#:
			<a target="_blank" href="#downloadFileUrl#">#downloadFileUrl#</a>

			<cfif arguments.client_abb EQ "hcs">
				<cfset accessClient = "doplanning">
			<cfelseif isDefined("SESSION.client_id")>
				<cfset accessClient = SESSION.client_id>
			</cfif>

			<cfif len(accessClient) GT 0>
				<br/>-&nbsp;#langText[language].common.access_to_application#:
				<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#accessClient#">#APPLICATION.mainUrl##APPLICATION.path#/#accessClient#</a>
			</cfif>
			</cfoutput>
			</cfsavecontent>

		<cfelse>

			<cfsavecontent variable="accessContent">
			<cfoutput>
			#langText[language].new_file.access_to_file_links#: <br/>
			-&nbsp;#langText[language].common.access_internal# <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/?area=#arguments.area_id#&file=#arguments.file_id#&abb=#arguments.client_abb#">#APPLICATION.mainUrl##APPLICATION.path#/?area=#arguments.area_id#&file=#arguments.file_id#&abb=#arguments.client_abb#</a><br/>
			-&nbsp;#langText[language].common.access_external# <a target="_blank" href="#APPLICATION.alternateUrl#/?area=#arguments.area_id#&file=#arguments.file_id#&abb=#arguments.client_abb#">#APPLICATION.alternateUrl#/?area=#arguments.area_id#&file=#arguments.file_id#&abb=#arguments.client_abb#</a>
			</cfoutput>
			</cfsavecontent>

		</cfif>

		<cfreturn accessContent>

	</cffunction>


	<!--- --------------------------- getFileFootContent --------------------------- --->

	<cffunction name="getFileFootContent" access="private" returntype="string">
		<cfargument name="language" type="string" required="true">

		<cfset var method = "getFileFootContent">

		<cfset var footContent = "">

		<cfset footContent = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;"><span style="color:##FF0000; font-size:12px;">#langText[arguments.language].common.foot_do_not_reply#.</span><br/>#langText[arguments.language].common.foot_content_default_1# #APPLICATION.title# #langText[arguments.language].new_item.foot_content_2# #APPLICATION.title#.<br />#langText[arguments.language].new_item.foot_content_3#.</p>'>

		<cfreturn footContent>

	</cffunction>



	<!--- -------------------------------------- assignUserToArea ------------------------------------ --->

	<cffunction name="assignUserToArea" access="public" returntype="void">
		<cfargument name="objectUser" type="query" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="new_area" type="boolean" required="no" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "assignUserToArea">

        <cfset var root_area = structNew()>
        <cfset var curLang = "">

        <cfset var objectArea = "">
        <cfset var access_content = "">

        <cfset var head_content = "">
        <cfset var head_content_user = "">

        <!---getArea--->
        <cfinvoke component="AreaQuery" method="getArea" returnvariable="objectArea">
            <cfinvokeargument name="area_id" value="#area_id#">
            <cfinvokeargument name="with_user" value="false">
            <cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
        </cfinvoke>

        <!---getRootArea--->
		<cfinvoke component="AreaQuery" method="getRootArea" returnvariable="root_area">
			<cfinvokeargument name="onlyId" value="false">
			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
		</cfinvoke>
		<!---En el asunto se pone el nombre del área raiz--->

		<!--- getAreaPath --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getAreaPathContent" returnvariable="area_path">
			<cfinvokeargument name="area_id" value="#objectArea.id#">
			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
		</cfinvoke>

		<!---areaUrl--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaUrl" returnvariable="areaUrl">
			<cfinvokeargument name="area_id" value="#objectArea.id#">

			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
		</cfinvoke>

		<!--- getClient --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
			<cfinvokeargument name="client_abb" value="#client_abb#">
		</cfinvoke>

        <cfif len(objectuser.email) GT 0 AND objectUser.enabled IS true AND ( clientQuery.force_notifications IS true OR objectUser.no_notifications IS false )><!--- user notifications enabled --->

			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUserPreferences" returnvariable="userPreferences">
				<cfinvokeargument name="user_id" value="#objectUser.id#"/>

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#"/>
			</cfinvoke>

			<cfif userPreferences.notify_been_associated_to_area IS true>

				<cfset curLang = objectUser.language>

		        <cfif arguments.new_area IS false>
					<cfset subject_user = "[#root_area.name#] #langText[curLang].assign_user.has_been_added_as_user#: "&objectArea.name>
				<cfelse>
					<cfset subject_user = "[#root_area.name#] #langText[curLang].assign_user.has_been_added_as_responsible#: "&objectArea.name>
				</cfif>

				<!--- getAreaHeadContent --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getAreaHeadContent" returnvariable="areaHeadContentUser">
					<cfinvokeargument name="objectArea" value="#objectArea#"/>
					<cfinvokeargument name="areaUrl" value="#areaUrl#"/>

					<cfinvokeargument name="language" value="#curLang#">
					<cfinvokeargument name="client_abb" value="#client_abb#"/>
				</cfinvoke>

				<cfsavecontent variable="html_text">
				<cfoutput>

					<cfif objectUser.whole_tree_visible IS true><!---INTERNAL USER--->
						#area_path#
					</cfif>

					#areaHeadContentUser#

					<tr style="padding-top:0;padding-bottom:0;margin-top:0;margin-bottom:0">
						<td style="padding-top:0;padding-bottom:0;margin-top:0;margin-bottom:0;font-size:14px;">

							<p style="font-size:16px;padding-left:5px;"><cfif arguments.new_area IS false>
							#langText[curLang].assign_user.has_been_added_to_area#
							<cfelse>
							#langText[curLang].assign_user.area_created# #langText[curLang].assign_user.you_are_responsible#
							</cfif></p>

							<cfif len(objectArea.description) GT 0>
							<p>#langText[curLang].common.area_description#:<br />
							#objectArea.description#
							</p>
							</cfif>

							<table style="width:100%;margin-top:20px;">
								<tr>
									<td><!--- Share icon --->
										<img src="#APPLICATION.mainUrl##APPLICATION.htmlPath#/assets/v3/emails/icon_share.png" alt="#langText[curLang].common.go_to_area#"/>
									</td>
									<td style="padding-top:5px;">
										<a href="#areaUrl#" style="color:##ababab;font-size:16px;text-decoration:none">#areaUrl#</a>
									</td>
								</tr>
								<tr>
									<td></td>
									<td style="background:none; border-top: 1px solid ##ddd; height:1px; line-height:1px; width:100%; margin:0px 0px 0px 0px; padding-bottom:10px;">&nbsp;
									</td>
								</tr>
							</table>

						</td>
					</tr>
				</table><!--- END item container table --->


		<!---		<br />
		<cfif arguments.new_area IS false>
		#langText[curLang].assign_user.has_been_added_to_area#: <strong>#objectArea.name#</strong> #langText[curLang].common.of_the_organization# #root_area.name#.<br />
		<cfelse>
		#langText[curLang].assign_user.area_created#: <strong>#objectArea.name#</strong>, #langText[curLang].assign_user.you_are_responsible#.<br />
		</cfif>
		<cfif objectUser.whole_tree_visible IS true><!---INTERNAL USER--->
			<!---<cfif len(area_path) GT 0>
				#langText[curLang].common.area_path#: #area_path#<br />
			</cfif>--->
			#area_path#
		</cfif>
		<br />
		<cfif len(objectArea.description) GT 0>
		#langText[curLang].common.area_description#:<br />
		#objectArea.description#<br />
		</cfif>
		<br/>
		<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content_user#</div>--->
				</cfoutput>
				</cfsavecontent>

				<!--- getHeadContent --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getHeadContent" returnvariable="head_content_user">
					<cfinvokeargument name="language" value="#curLang#">
					<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
				</cfinvoke>

				<cfset foot_content_user = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">#langText[curLang].common.foot_content_default_3# #APPLICATION.title#.</p>'>

				<cfinvoke component="EmailManager" method="sendEmail">
					<!--- <cfinvokeargument name="from" value="#SESSION.client_email_from#"> --->
					<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
					<cfinvokeargument name="to" value="#objectUser.email#">
					<cfinvokeargument name="subject" value="#subject_user#">
					<cfinvokeargument name="content" value="#html_text#">
					<cfinvokeargument name="head_content" value="#head_content_user#">
					<cfinvokeargument name="foot_content" value="#foot_content_user#">
				</cfinvoke>

			</cfif><!---END notify_been_associated_to_area IS true--->


		</cfif><!--- END user notifications enabled --->



		<cfif arguments.new_area IS false><!--- NO es la notificación de responsable de nueva área --->

	       <!---<cfsavecontent variable="getUsersParameters">
				<cfoutput>
					 <user id="" email="" whole_tree_visible="">
						<family_name><![CDATA[]]></family_name>
						<name><![CDATA[]]></name>
					</user>
					<area id="#arguments.area_id#"/>
					<order parameter="family_name" order_type="asc" />
					<preferences
						notify_new_user_in_area="true">
					</preferences>
				</cfoutput>
			</cfsavecontent>

			<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="createRequest" returnvariable="getUsersRequest">
				<cfinvokeargument name="request_parameters" value="#getUsersParameters#">
			</cfinvoke>--->

	        <cfinvoke component="UserManager" method="getUsersToNotifyLists" returnvariable="usersToNotifyLists">
				<!---<cfinvokeargument name="request" value="#getUsersRequest#"/>--->
				<cfinvokeargument name="area_id" value="#arguments.area_id#">

				<cfinvokeargument name="notify_new_user_in_area" value="true">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfset internalUsersEmails = usersToNotifyLists.structInternalUsersEmails>
			<cfset externalUsersEmails = usersToNotifyLists.structExternalUsersEmails>

			<!---<cfif isDefined("arguments.user_id")>
				<cfinvoke component="UserQuery" method="getUser" returnvariable="actionUserQuery">
					<cfinvokeargument name="user_id" value="#arguments.user_id#">
					<cfinvokeargument name="format_content" value="default">
					<cfinvokeargument name="with_ldap" value="false">
					<cfinvokeargument name="with_vpnet" value="false">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

				<cfset actionUserName = actionUserQuery.user_full_name>
			</cfif>--->

			<cfloop list="#APPLICATION.languages#" index="curLang">

				<!--- Delete user from lists --->

				<cfset listInternalUsers = internalUsersEmails[curLang]>
				<cfset listExternalUsers = externalUsersEmails[curLang]>

				<cfset listInternalUserPos = listContains(listInternalUsers, objectUser.email, ";")>

				<cfif listInternalUserPos GT 0>

					<cfset listInternalUsers = listDeleteAt(listInternalUsers, listInternalUserPos, ";")>

				<cfelse>

					<cfset listExternalUserPos = listContains(listExternalUsers, objectUser.email, ";")>

					<cfif listExternalUserPos GT 0>
						<cfset listExternalUsers = listDeleteAt(listExternalUsers, listExternalUserPos, ";")>
					</cfif>

				</cfif>


				<cfif len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0><!---Si hay usuarios a los que notificar--->

					<!---En el asunto se pone el nombre del área raiz--->
			        <!---<cfif arguments.new_area IS false>
						<cfset subject = "[#root_area.name#] #langText[curLang].assign_user.has_been_added_as_user#: "&objectArea.name>
					<cfelse>
						<cfset subject = "[#root_area.name#] #langText[curLang].assign_user.has_been_added_as_responsible#: "&objectArea.name>
					</cfif>--->

					<cfset subject = "[#root_area.name#] #langText[curLang].assign_user.new_user_in_area#: "&objectArea.name>
					<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">#langText[curLang].common.foot_content_default_3# #APPLICATION.title#.</p>'>

					<!--- getHeadContent --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getHeadContent" returnvariable="head_content">
						<cfinvokeargument name="language" value="#curLang#">
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
					</cfinvoke>

					<!---<cfinvoke component="AlertManager" method="getAreaAccessContent" returnvariable="accessContent">
						<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
						<cfinvokeargument name="language" value="#curLang#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					</cfinvoke>

					<cfsavecontent variable="alertContent">
					<cfoutput>
					<br />
			#langText[curLang].assign_user.new_user_in_area#: <strong>#objectArea.name#</strong> #langText[curLang].common.of_the_organization# #root_area.name#.<br />
			<br />
			#langText[curLang].common.user#: <b>#objectUser.user_full_name#</b><br/>
			<cfif len(objectArea.description) GT 0>
			#langText[curLang].common.area_description#:<br />
			#objectArea.description#<br />
			</cfif>

					</cfoutput>
					</cfsavecontent>--->

					<cfset actionDate = dateFormat(now(), APPLICATION.dateFormat)&" "&timeFormat(now(), "HH:mm:ss")>

					<cfsavecontent variable="alertContent">
					<cfoutput>
						<a href="#areaUrl#"><img src="#APPLICATION.mainUrl##APPLICATION.htmlPath#/assets/v3/emails/go_to_area_#curLang#.png" alt="#langText[curLang].common.go_to_area#" title="#langText[curLang].common.go_to_area#" /></a>

						<table style="width:100%;border-radius:4px;border-color:##dddddd;border-style:solid;border-width:1px;margin-top:10px;box-shadow:0 1px 4px rgba(0,0,0,0.3);padding:15px;"><!--- item container table --->

							<tr style="padding-bottom:0;margin-bottom:0">
								<td style="padding-bottom:0;margin-bottom:0">

									<table style="width:100%;">
										<tr>
											<td><!--- Area and date --->

												<table>
													<tr>
														<td style="vertical-align:middle">
															<span style="font-size:25px;color:##35938c;font-weight:100">#objectUser.user_full_name#</span>&nbsp;&nbsp;&nbsp;&nbsp;
														</td>
														<td style="vertical-align:middle">
															<cfset spacePos = findOneOf(" ", actionDate)>
															<span style="font-size:20px;color:##254c65;font-weight:100;white-space:nowrap;">#left(actionDate, spacePos)#</span>&nbsp;&nbsp;&nbsp;
														</td>
														<td style="vertical-align:middle">
															<span style="font-size:20px;color:##888;font-weight:100;white-space:nowrap;">#right(actionDate, len(actionDate)-spacePos)#</span>&nbsp;&nbsp;
														</td>
														<td style="vertical-align:middle">
															<!---#actionBox#--->
														</td>
													</tr>
												</table>

											</td>
										</tr>

										<!---<tr>
											<td style="background:none; border-top: 1px solid ##eeeeee; height:1px; line-height:1px; width:100%; margin:0px 0px 0px 0px; padding-top:10px;">
												&nbsp;
											</td>
										</tr>--->
									</table>

								</td>
							</tr>

							<tr style="padding-top:0;padding-bottom:0;margin-top:0;margin-bottom:0">
								<td style="padding-top:0;padding-bottom:0;margin-top:0;margin-bottom:0;font-size:14px;">

									<p style="font-size:16px;padding-left:5px;">
										#langText[curLang].assign_user.new_user_in_area#
									</p>


									<table style="width:100%;margin-top:20px;">
										<tr>
											<td><!--- Share icon --->
												<img src="#APPLICATION.mainUrl##APPLICATION.htmlPath#/assets/v3/emails/icon_share.png" alt="#langText[curLang].common.go_to_area#"/>
											</td>
											<td style="padding-top:5px;">
												<a href="#areaUrl#" style="color:##ababab;font-size:16px;text-decoration:none">#areaUrl#</a>
											</td>
										</tr>
										<tr>
											<td></td>
											<td style="background:none; border-top: 1px solid ##ddd; height:1px; line-height:1px; width:100%; margin:0px 0px 0px 0px; padding-bottom:10px;">&nbsp;
											</td>
										</tr>
									</table>

								</td>
							</tr>
						</table><!--- END item container table --->
					</cfoutput>
					</cfsavecontent>

					<!--- getAreaHeadContent --->
					<!---<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getAreaHeadContent" returnvariable="areaHeadContentUser">
						<cfinvokeargument name="objectArea" value="#objectArea#"/>
						<cfinvokeargument name="areaUrl" value="#areaUrl#"/>

						<cfinvokeargument name="language" value="#curLang#">
						<cfinvokeargument name="client_abb" value="#client_abb#"/>
					</cfinvoke>--->


					<!---INTERNAL USERS--->
					<cfif listLen(listInternalUsers, ";") GT 0>

						<cfsavecontent variable="contentInternal">
						<cfoutput>
							#area_path#

							#alertContent#
						</cfoutput>
						</cfsavecontent>

						<cfinvoke component="EmailManager" method="sendEmail">
							<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
							<!---<cfif len(actionUserName) GT 0 AND arguments.action NEQ "delete_virus" AND arguments.action NEQ "delete_version_virus">
								<cfinvokeargument name="from_name" value="#actionUserName#">
							</cfif>--->
							<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#"><!------>
							<cfinvokeargument name="bcc" value="#listInternalUsers#">
							<cfinvokeargument name="subject" value="#subject#">
							<cfinvokeargument name="content" value="#contentInternal#">
							<cfinvokeargument name="head_content" value="#head_content#">
							<cfinvokeargument name="foot_content" value="#foot_content#">
						</cfinvoke>

					</cfif>


					<!---EXTERNAL USERS--->
					<cfif listLen(listExternalUsers, ";") GT 0>

						<cfsavecontent variable="contentExternal">
						<cfoutput>
							<p><a href="#areaUrl#" style="color:##009ed2;text-decoration:underline;font-size:15px;">#objectArea.name#</a></p>

							#alertContent#
						</cfoutput>
						</cfsavecontent>
						<cfinvoke component="EmailManager" method="sendEmail">
							<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
							<!---<cfif len(actionUserName) GT 0 AND arguments.action NEQ "delete_virus" AND arguments.action NEQ "delete_version_virus">
								<cfinvokeargument name="from_name" value="#actionUserName#">
							</cfif>--->
							<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
							<cfinvokeargument name="bcc" value="#listExternalUsers#">
							<cfinvokeargument name="subject" value="#subject#">
							<cfinvokeargument name="content" value="#contentExternal#">
							<cfinvokeargument name="head_content" value="#head_content#">
							<cfinvokeargument name="foot_content" value="#foot_content#">
						</cfinvoke>

					</cfif>

				</cfif>

			</cfloop>


		</cfif>

	</cffunction>



	<!--- --------------------------- getAreaHeadContent --------------------------- --->

	<cffunction name="getAreaHeadContent" access="private" returntype="string">
		<cfargument name="objectArea" type="query" required="true">
		<cfargument name="areaUrl" type="string" required="true">
		<cfargument name="action" type="string" required="false">
		<cfargument name="language" type="string" required="true">


		<cfargument name="client_abb" type="string" required="true">

		<cfset var method = "getAreaHeadContent">

		<cfset var headContent = "">

		<cfset var actionDate = dateFormat(now(), APPLICATION.dateFormat)&" "&timeFormat(now(), "HH:mm:ss")>


		<cfsavecontent variable="headContent"><cfoutput>
			<a href="#areaUrl#"><img src="#APPLICATION.mainUrl##APPLICATION.htmlPath#/assets/v3/emails/go_to_area_#arguments.language#.png" alt="#langText[arguments.language].common.go_to_area#" title="#langText[arguments.language].common.go_to_area#" /></a>

			<table style="width:100%;border-radius:4px;border-color:##dddddd;border-style:solid;border-width:1px;margin-top:10px;box-shadow:0 1px 4px rgba(0,0,0,0.3);padding:15px;"><!--- item container table --->

				<tr style="padding-bottom:0;margin-bottom:0">
					<td style="padding-bottom:0;margin-bottom:0">

						<table style="width:100%;">
							<tr>
								<td><!--- Area and date --->

									<table>
										<tr>
											<td style="vertical-align:middle">
												<span style="font-size:25px;color:##444444;font-weight:100">#objectArea.name#</span>&nbsp;&nbsp;&nbsp;&nbsp;
											</td>
											<td style="vertical-align:middle">
												<cfset spacePos = findOneOf(" ", actionDate)>
												<span style="font-size:20px;color:##254c65;font-weight:100;white-space:nowrap;">#left(actionDate, spacePos)#</span>&nbsp;&nbsp;&nbsp;
											</td>
											<td style="vertical-align:middle">
												<span style="font-size:20px;color:##888;font-weight:100;white-space:nowrap;">#right(actionDate, len(actionDate)-spacePos)#</span>&nbsp;&nbsp;
											</td>
											<td style="vertical-align:middle">
												<!---#actionBox#--->
											</td>
										</tr>
									</table>

								</td>
							</tr>

							<!---<tr>
								<td style="background:none; border-top: 1px solid ##eeeeee; height:1px; line-height:1px; width:100%; margin:0px 0px 0px 0px; padding-top:10px;">
									&nbsp;
								</td>
							</tr>--->
						</table>

					</td>
				</tr>
		</cfoutput></cfsavecontent>

		<cfreturn headContent>

	</cffunction>





	<!--- -------------------------------------- newArea ------------------------------------ --->

	<cffunction name="newArea" access="public" returntype="void">
		<cfargument name="objectArea" type="query" required="yes">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "newArea">

		<cfset var internalUsersEmails = "">
		<cfset var externalUsersEmails = "">
		<cfset var listInternalUsers = "">
		<cfset var listExternalUsers = "">

        <cfset var root_area = "">
        <cfset var head_content = "">
		<cfset var foot_content = "">
		<cfset var alertContent = "">

		<!---<cfinclude template="includes/functionStartOnlySession.cfm">--->

        <!---<cfsavecontent variable="getUsersParameters">
			<cfoutput>
				 <user id="" email=""
			telephone="" sms_allowed="" whole_tree_visible="">
					<family_name><![CDATA[]]></family_name>
					<name><![CDATA[]]></name>
				</user>
				<area id="#objectArea.id#"/>
				<order parameter="family_name" order_type="asc" />
				<preferences notify_new_area="true">
				</preferences>
			</cfoutput>
		</cfsavecontent>

		<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="createRequest" returnvariable="getUsersRequest">
			<cfinvokeargument name="request_parameters" value="#getUsersParameters#">
		</cfinvoke>--->

        <cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="getUsersToNotifyLists" returnvariable="usersToNotifyLists">
			<!---<cfinvokeargument name="request" value="#getUsersRequest#"/>--->
			<cfinvokeargument name="area_id" value="#objectArea.id#"/>
			<cfinvokeargument name="notify_new_area" value="true"/>

			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
		</cfinvoke>

		<cfset internalUsersEmails = usersToNotifyLists.structInternalUsersEmails>
		<cfset externalUsersEmails = usersToNotifyLists.structExternalUsersEmails>

		<cfloop list="#APPLICATION.languages#" index="curLang">

			<cfset listInternalUsers = internalUsersEmails[curLang]>
			<cfset listExternalUsers = externalUsersEmails[curLang]>

			<cfif len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0><!---Si hay usuarios a los que notificar--->

				<!---getRootArea--->
				<cfinvoke component="AreaQuery" method="getRootArea" returnvariable="root_area">
					<cfinvokeargument name="onlyId" value="false">
					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>
				<!---En el asunto se pone el nombre del área raiz--->

				<!---<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getAreaAccessContent" returnvariable="access_content">
					<cfinvokeargument name="area_id" value="#objectArea.id#"/>
					<cfinvokeargument name="language" value="#curLang#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
				</cfinvoke>--->

				<!--- getHeadContent --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getHeadContent" returnvariable="head_content">
					<cfinvokeargument name="language" value="#curLang#">
					<cfinvokeargument name="client_abb" value="#client_abb#"/>
				</cfinvoke>

				<!---areaUrl--->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaUrl" returnvariable="areaUrl">
					<cfinvokeargument name="area_id" value="#objectArea.id#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				</cfinvoke>

				<!--- getAreaHeadContent --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getAreaHeadContent" returnvariable="areaHeadContent">
					<cfinvokeargument name="objectArea" value="#objectArea#"/>
					<cfinvokeargument name="areaUrl" value="#areaUrl#"/>

					<cfinvokeargument name="language" value="#curLang#">
					<cfinvokeargument name="client_abb" value="#client_abb#"/>
				</cfinvoke>

				<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">'&langText[curLang].common.foot_content_default_3&' #APPLICATION.title#.</p>'>
				<cfset subject = "[#root_area.name#][#langText[curLang].new_area.new_area#] #objectArea.name#">

				<cfsavecontent variable="alertContent">
				<cfoutput>

						#areaHeadContent#

						<tr style="padding-top:0;padding-bottom:0;margin-top:0;margin-bottom:0">
							<td style="padding-top:0;padding-bottom:0;margin-top:0;margin-bottom:0;font-size:14px;">

								<p style="font-size:16px;padding-left:5px;">#langText[curLang].new_area.area_created#</p>

								<cfif len(objectArea.description) GT 0>
								<p style="font-size:16px;padding-left:5px;"><b>#langText[curLang].common.area_description#:</b><br />
								#objectArea.description#
								</p>
								</cfif>

								<table style="width:100%;margin-top:20px;">
									<tr>
										<td><!--- Share icon --->
											<img src="#APPLICATION.mainUrl##APPLICATION.htmlPath#/assets/v3/emails/icon_share.png" alt="#langText[curLang].common.go_to_area#"/>
										</td>
										<td style="padding-top:5px;">
											<a href="#areaUrl#" style="color:##ababab;font-size:16px;text-decoration:none">#areaUrl#</a>
										</td>
									</tr>
									<tr>
										<td></td>
										<td style="background:none; border-top: 1px solid ##ddd; height:1px; line-height:1px; width:100%; margin:0px 0px 0px 0px; padding-bottom:10px;">&nbsp;
										</td>
									</tr>
								</table>

							</td>
						</tr>
					</table><!--- END item container table --->

				</cfoutput>
				</cfsavecontent>


				<!---INTERNAL USERS--->
				<cfif len(listInternalUsers) GT 0>

					<!---<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
						<cfinvokeargument name="area_id" value="#objectArea.id#">
					</cfinvoke>--->

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getAreaPathContent" returnvariable="area_path">
						<cfinvokeargument name="area_id" value="#objectArea.id#">
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

					<cfset subjectInternal = subject>

					<cfsavecontent variable="contentInternal">
					<cfoutput>
						#area_path#

						#alertContent#

			<!---<br />
			#langText[curLang].new_area.area_created#: <strong>#objectArea.name#</strong> #langText[curLang].new_area.on_the_organization# #root_area.name#, #langText[curLang].new_area.and_you_have_access#.<br />
			#langText[curLang].common.area_path#:#area_path#<br /><br />
			<br/>
			<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>--->
					</cfoutput>
					</cfsavecontent>

					<cfinvoke component="EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#SESSION.client_email_from#">
						<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
						<cfinvokeargument name="bcc" value="#listInternalUsers#">
						<cfinvokeargument name="subject" value="#subjectInternal#">
						<cfinvokeargument name="content" value="#contentInternal#">
						<cfinvokeargument name="head_content" value="#head_content#">
						<cfinvokeargument name="foot_content" value="#foot_content#">
					</cfinvoke>

				</cfif>

				<!---EXTERNAL USERS--->
				<cfif len(listExternalUsers) GT 0>

					<cfset subjectExternal = subject>

					<cfsavecontent variable="contentExternal">
					<cfoutput>

						<p><a href="#areaUrl#" style="color:##009ed2;text-decoration:underline;font-size:15px;">#objectArea.name#</a></p>

						#alertContent#

					<!---<br />
			#langText[curLang].new_area.area_created#: <strong>#objectArea.name#</strong> #langText[curLang].new_area.on_the_organization# #root_area.name#, #langText[curLang].new_area.and_you_have_access#.<br /><br />
			<cfif len(objectArea.description) GT 0>
			#langText[curLang].common.area_description#:<br />
			#objectArea.description#<br />
			</cfif>
			<br/>
			<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>--->
					</cfoutput>
					</cfsavecontent>

					<cfinvoke component="EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#SESSION.client_email_from#">
						<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
						<cfinvokeargument name="bcc" value="#listExternalUsers#">
						<cfinvokeargument name="subject" value="#subjectExternal#">
						<cfinvokeargument name="content" value="#contentExternal#">
						<cfinvokeargument name="head_content" value="#head_content#">
						<cfinvokeargument name="foot_content" value="#foot_content#">
					</cfinvoke>

				</cfif>

			</cfif><!---END len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0--->

		</cfloop><!---END APPLICATION.languages loop--->

	</cffunction>



	<!--- --------------------------- getAreaAccessContent --------------------------- --->

	<cffunction name="getAreaAccessContent" access="public" returntype="string">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="language" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">

		<cfset var method = "getAreaAccessContent">

		<cfset var accessContent = "">
		<cfset var accessClient = "">

		<!---areaUrl--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaUrl" returnvariable="areaUrl">
			<cfinvokeargument name="area_id" value="#arguments.area_id#">

			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
		</cfinvoke>

		<cfif APPLICATION.twoUrlsToAccess IS false>

			<cfsavecontent variable="accessContent">
			<cfoutput>
			-&nbsp;#langText[arguments.language].common.access_to_area#:
			<a target="_blank" href="#areaUrl#">#areaUrl#</a>


			<cfif arguments.client_abb EQ "hcs">
				<cfset accessClient = "doplanning">
			<cfelseif isDefined("SESSION.client_id")>
				<cfset accessClient = SESSION.client_id>
			</cfif>

			<cfif len(accessClient) GT 0>
				<br/>-&nbsp;#langText[arguments.language].common.access_to_application#:
				<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#accessClient#">#APPLICATION.mainUrl##APPLICATION.path#/#accessClient#</a>
			</cfif>

			</cfoutput>
			</cfsavecontent>

		<cfelse>

			<cfsavecontent variable="accessContent">
			<cfoutput>
			#langText[arguments.language].common.access_to_area_links#: <br/>
			-&nbsp;#langText[arguments.language].common.access_internal# <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/?area=#area_id#&abb=#arguments.client_abb#">#APPLICATION.mainUrl##APPLICATION.path#/?area=#area_id#&abb=#arguments.client_abb#</a><br/>
			-&nbsp;#langText[arguments.language].common.access_external# <a target="_blank" href="#APPLICATION.alternateUrl#/?area=#area_id#&abb=#arguments.client_abb#">#APPLICATION.alternateUrl#/?area=#area_id#&abb=#arguments.client_abb#</a>
			</cfoutput>
			</cfsavecontent>

		</cfif>

		<cfreturn accessContent>

	</cffunction>



</cfcomponent>

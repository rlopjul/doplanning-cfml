<!---Copyright Era7 Information Technologies 2007-2014--->
<cfcomponent output="false">

	<cfset component = "AlertManager">

	<cfset dateFormat = "%d-%m-%Y">

	<cfinclude template="#APPLICATION.componentsPath#/includes/loadLangText.cfm">


	<!--- -------------------------------------- newAreaItem ----------------------------------- --->
	
	<cffunction name="newAreaItem" access="public" returntype="void">
		<cfargument name="objectItem" type="query" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
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
		<cfset var alertContent = "">
		<cfset var actionUser = "">
		<cfset var actionUserName = "">
		
		<cfset var includeItemContent = true>
		
		<!---<cfinclude template="includes/functionStartOnlySession.cfm">--->
		
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
		
		<!---getRootArea--->
		<cfinvoke component="AreaQuery" method="getRootArea" returnvariable="root_area">
			<cfinvokeargument name="onlyId" value="false">
			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
		</cfinvoke>
		<!---En el asunto se pone el nombre del área raiz--->

		
		<cfsavecontent variable="getUsersParameters">
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
		</cfinvoke>
        
        <!--- getUsersToNotifyLists --->
        <cfinvoke component="UserManager" method="getUsersToNotifyLists" returnvariable="usersToNotifyLists">
			<cfinvokeargument name="request" value="#getUsersRequest#"/>

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
						
				<cfif arguments.action NEQ "delete"><!---Si el elemento no se elimina--->
					
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemAccessContent" returnvariable="access_content">
						<cfinvokeargument name="language" value="#curLang#">
						<cfinvokeargument name="item_id" value="#objectItem.id#"/>
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="area_id" value="#objectItem.area_id#"/>

						<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
					</cfinvoke>

				</cfif>
				
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
					
					</cfcase>
					
					<cfcase value="delete"><!---Eliminado--->
					
						<cfif itemTypeGender EQ "male">
							<cfset action_name = "#langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.deleted_male#">
						<cfelse>
							<cfset action_name = "#langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.deleted_female#">
						</cfif>
						
						<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">
	
					</cfcase>
					
					<cfcase value="update"><!---Modificado--->
					
						<cfif itemTypeGender EQ "male">
							<cfset action_name = "#langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.modified_male#">
						<cfelse>
							<cfset action_name = "#langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.modified_female#">
						</cfif>
						
						<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">
					
					</cfcase>
					
					<cfcase value="done"><!---Realizada (tarea)--->
						
						<cfset action_name = "#langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.done_female#">
						<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">
						
					</cfcase>				
					
					<cfcase value="close"><!---Cerrada (consulta)--->
					
						<cfset action_name = "#langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.closed_female#">
						<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">				
					
					</cfcase>

					<cfcase value="attached_file_deleted_virus"><!---Imagen adjunta eliminada por virus--->
						
						<cfset action_name = "#langText[curLang].new_item.attached_file_of# #langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.deleted_virus_male#">
						<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">				
					
					</cfcase>

					<cfcase value="attached_image_deleted_virus"><!---Imagen adjunta eliminada por virus--->
					
						<cfset action_name = "#langText[curLang].new_item.attached_image_of# #langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.deleted_virus_female#">
						<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">				
					
					</cfcase>
					
				</cfswitch>
				
				
				<cfset sms_message = "#uCase(action_name)#:#objectItem.title#. AREA:#area_name#">
				
				<cfif len(sms_message) GT 160>
					<cfset sms_message = left(sms_message, 160)>
				</cfif>
							
				
				<!---CONTENIDO DEL EMAIL--->

				<cfif includeItemContent IS true>
				
					<cfsavecontent variable="alertContent">
						<cfoutput>

						<cfif arguments.action EQ "attached_file_deleted_virus" OR arguments.action EQ "attached_image_deleted_virus"><!--- DELETE VIRUS --->

							<b>#langText[curLang].new_item.virus_description#</b>:<br/>
							<i style="color:##FF0000;">#arguments.anti_virus_check_result#</i><br/>
							#langText[curLang].new_file.virus_advice#.<br/><br/>
							
						</cfif>

						<cfif itemTypeId IS 1>#langText[curLang].new_item.subject#<cfelse>#langText[curLang].new_item.title#</cfif>: <strong style="font-size:14px;">#objectItem.title#</strong><br/>			
						#langText[curLang].new_item.user#: <b>#objectItem.user_full_name#</b><br/>		
						<cfif itemTypeId IS 6><!---Tasks--->
						#langText[curLang].new_item.assigned_to#: <b>#objectItem.recipient_user_full_name#</b><br/>
						</cfif>
						#langText[curLang].new_item.creation_date#: <strong>#objectItem.creation_date#</strong><br/>
						<cfif itemTypeId IS NOT 1 AND len(objectItem.last_update_date) GT 0>
						#langText[curLang].new_item.last_update_date#: <strong>#objectItem.last_update_date#</strong><br/>
						</cfif>
						
						<cfif itemTypeWeb IS true><!--- WEB --->

							<cfif len(objectItem.publication_date) GT 0>
								#langText[curLang].new_item.publication_date#: <b>#objectItem.publication_date#</b> <!--- #langText[curLang].new_item.hour#: <b>#TimeFormat(objectItem.publication_time,"HH:mm")#</b> ---><br/>
							</cfif>
							<cfif APPLICATION.publicationValidation IS true AND len(objectItem.publication_validated) GT 0>
								#langText[curLang].new_item.publication_validated#: <b><cfif objectItem.publication_validated IS true>#langText[curLang].new_item.yes#<cfelse>#langText[curLang].new_item.no#</cfif></b><br/>
							</cfif>

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
											#langText[curLang].new_item.link_to_pubmed#: <a href="http://www.ncbi.nlm.nih.gov/pubmed/#objectItem.identifier#" target="_blank">http://www.ncbi.nlm.nih.gov/pubmed/#objectItem.identifier#</a><br/>
										</cfif>
								</cfif>

								<cfif subTypeQuery.recordCount IS 0 OR subTypeQuery.sub_type_id NEQ 1>
									#langText[curLang].new_item.price#: <b>#objectItem.price#</b><br/>
								</cfif>

							</cfif>
							
							<cfif itemTypeId IS 5><!---Events--->
								#langText[curLang].new_item.price#: <b>#objectItem.price#</b><br/>
							</cfif>
							<cfif isNumeric(objectItem.attached_file_id) AND objectItem.attached_file_id GT 0>
								<cfif arguments.action NEQ "delete">
								#langText[curLang].new_item.attached_file#: <a href="#downloadFileUrl#" target="_blank">#objectItem.attached_file_name#</a><br/>
								<cfelse>
								#langText[curLang].new_item.attached_file#: #objectItem.attached_file_name#<br/>
								</cfif>
							</cfif>
							<cfif arguments.itemTypeId IS NOT 1 AND isNumeric(objectItem.attached_image_id) AND objectItem.attached_image_id GT 0>
								<cfif arguments.action NEQ "delete">
								#langText[curLang].new_item.attached_image#: <a href="#downloadImageUrl#" target="_blank">#objectItem.attached_image_name#</a><br/>
								<cfelse>
								#langText[curLang].new_item.attached_image#: #objectItem.attached_image_name#<br/>
								</cfif>
							</cfif>

						</cfif><!--- END arguments.itemTypeId LT 10 --->

						<cfif APPLICATION.publicationScope IS true AND ( arguments.itemTypeId IS 11 OR arguments.itemTypeId IS 12 )>
						#langText[curLang].new_item.publication_scope#: <strong>#objectItem.publication_scope_name#</strong><br/>
						</cfif>

						<br/>
						<div style="padding-left:15px;">#objectItem.description#</div>
						
						<cfif (itemTypeId IS 4 OR itemTypeId IS 5) AND len(objectItem.link) GT 0><!---News, Events--->
						<br/>#langText[curLang].new_item.more_information#: <a href="#objectItem.link#" target="_blank">#objectItem.link#</a><br/>
						</cfif>
						
						<br/>
						
						<cfif arguments.action NEQ "delete"><!---Si el elemento no se elimina--->
						<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>
						</cfif>
						</cfoutput>					
					</cfsavecontent>
					
				<cfelse><!---includeItemContent IS false--->
				
					<cfsavecontent variable="alertContent">
						<cfoutput>
						<!---<i>En este e-mail no se incluye el contenido <cfif itemTypeGender EQ "male">del<cfelse>de la</cfif> #lCase(itemTypeNameEs)#.</i><br/><br/>--->
						<cfif arguments.action NEQ "delete">
						<div style="border-color:##CCCCCC; border-style:solid; border-width:1px; padding:8px;">
							<strong style="font-size:14px;">#langText[curLang].new_item.to_view_content# <cfif itemTypeGender EQ "male">#langText[curLang].new_item.of_male#<cfelse>#langText[curLang].new_item.of_female#</cfif> #lCase(itemTypeNameEs)# #langText[curLang].new_item.you_must_access#:</strong><br/>
							
							<span style="color:##666666;">#access_content#</span>
						</div>
						</cfif>
						</cfoutput>
					</cfsavecontent>
					
				</cfif>
				
				<!---fromName--->
				<!---<cfif action NEQ "delete">
					<cfif itemTypeId IS NOT 6>
						<cfset fromName = objectItem.user_full_name>
					<cfelse><!---Tasks--->
						<cfif user_id IS objectItem.recipient_user AND objectItem.recipient_user NEQ objectItem.user_in_charge>
							<cfset fromName = objectItem.recipient_user_full_name>
						<cfelse>
							<cfset fromName = objectItem.user_full_name>
						</cfif>
					</cfif>
				</cfif>--->

				<cfinvoke component="UserQuery" method="getUser" returnvariable="actionUserQuery">
					<cfinvokeargument name="user_id" value="#arguments.user_id#">
					<cfinvokeargument name="format_content" value="default">
					<cfinvokeargument name="with_ldap" value="false">
					<cfinvokeargument name="with_vpnet" value="false">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

				<cfset actionUserName = actionUserQuery.user_full_name>

				<!---INTERNAL USERS--->
				<cfif len(listInternalUsers) GT 0>
				
					<cfinvoke component="AreaQuery" method="getAreaPath" returnvariable="area_path">
						<cfinvokeargument name="area_id" value="#objectItem.area_id#">
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>
					
					<cfset subjectInternal = subject>
				
					<cfsavecontent variable="contentInternal">
					<cfoutput>
			<cfif arguments.action EQ "delete">
				#action_name# #langText[curLang].common.by_user# #actionUserName# #langText[curLang].common.on_the_area#
			<cfelse>
				#langText[curLang].common.area#: 
			</cfif>
			<b>#area_name#</b>.<br/>
			#langText[curLang].common.area_path#: #area_path#<br/><br/>
			
			#alertContent#
					</cfoutput>		
					</cfsavecontent>

					<cfinvoke component="#APPLICATION.componentsPath#/EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#SESSION.client_email_from#">
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
						<cfinvokeargument name="foot_content" value="#foot_content#">
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
			#action_name# <cfif arguments.action EQ "delete">#langText[curLang].common.by_user# #actionUserName# </cfif>#langText[curLang].common.on_the_area# <b>#area_name#</b> #langText[curLang].common.of_the_organization# #root_area.name#.<br/><br/>
			
			#alertContent#
					</cfoutput>		
					</cfsavecontent>
					
					
					<cfinvoke component="#APPLICATION.componentsPath#/EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#SESSION.client_email_from#">
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
						<cfinvokeargument name="foot_content" value="#foot_content#">
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
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="user_id" type="numeric" required="false">
		<cfargument name="fileVersionQuery" type="query" required="false">
		<cfargument name="action" type="string" required="yes"><!---new/associate/replace/dissociate/delete/lock/unlock/new_version/new_current_version/...--->

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">
				
		<cfset var method = "newFile">
		
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
				<cfif arguments.action NEQ "delete_virus" AND arguments.action NEQ "delete_version_virus"><!---delete_virus y delete_version_virus se envía a todos los usuarios --->
					<preferences 
					<cfif arguments.action EQ "replace" OR arguments.action EQ "new_version">
						notify_replace_file="true"
					<cfelseif arguments.action EQ "dissociate" OR arguments.action EQ "delete">
						notify_delete_file="true"		
					<cfelseif arguments.action EQ "lock" OR arguments.action EQ "unlock">
						notify_lock_file="true"
					<cfelse>
						notify_new_file="true"
					</cfif>>				
					</preferences>
				</cfif>
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
						<cfset action_value = langText[curLang].new_file.replaced>
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
						<cfset action_value = langText[curLang].new_file.replaced>
					</cfcase>

					<cfcase value="new_current_version"><!--- new_current_version --->
						<cfset subject_action = langText[curLang].new_file.new_current_version>
						<cfset action_value = langText[curLang].new_file.replaced>
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

				<cfif arguments.action NEQ "dissociate" AND arguments.action NEQ "delete" AND arguments.action NEQ "delete_virus">
					
					<cfinvoke component="AlertManager" method="getFileAccessContent" returnvariable="access_content">
						<cfinvokeargument name="file_id" value="#objectFile.id#"/>
						<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
						<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
						<cfinvokeargument name="language" value="#curLang#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
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
					<cfif arguments.action NEQ "new" AND arguments.action NEQ "associate">
						<strong>#subject_action#</strong>:<br/><br/>
					</cfif>

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
						<cfif len(actionUserName) GT 0 AND arguments.action NEQ "delete_virus" AND arguments.action NEQ "delete_version_virus"> 
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
						<cfinvokeargument name="from_name" value="#objectFile.user_full_name#">
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
			
			<cfif isDefined("SESSION.client_id")>
				<br/>-&nbsp;#langText[language].common.access_to_application#:
				<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#">#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#</a>
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



</cfcomponent>
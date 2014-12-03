<!---Copyright Era7 Information Technologies 2007-2013

	Date of file creation: 03-04-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 11-06-2013
	
	05-07-2012 alucena: modificado newAreaItem para que se notifique según las preferencias de alertas de los nuevos elementos (enlaces, entradas, noticias y eventos)
	06-09-2012 alucena: quitado DateFormat de la fecha de inicio de los eventos newAreaItem, ya que aparecía el mes cambiado por el día, porque la fecha que viene no es un objeto de Coldfusion, sino un String
	26-09-2012 alucena: añadida comprobación de tamaño de lista de destinatarios al enviar por email en newAreaItem
	17-01-2013 alucena: cambiada la url de los elementos, quitado /html/
	22-04-2013 alucena: cambiado client_id por client_abb en las URLs con abb=
	07-05-2013 alucena: cambios para habilitar varios idiomas
	11-06-2013 alucena: cambiada comprobación de APPLICATION.identifier por APPLICATION.twoUrlsToAccess para mostrar o no direcciones externas e internas
	
--->
<cfcomponent output="false">

	<cfset component = "AlertManager">
	
	<cfinclude template="includes/loadLangText.cfm">
	
	<!--- -------------------------------------- newAreaItem ----------------------------------- --->
	
	<cffunction name="newAreaItem" access="public" returntype="void">
		<cfargument name="objectItem" type="query" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="action" type="string" required="yes">
		<cfargument name="send_sms" type="boolean" required="no" default="false">
		<cfargument name="anti_virus_check_result" type="string" required="false">
			
			<cfset var method = "newAreaItem">

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!---Alert--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newAreaItem">
				<cfinvokeargument name="objectItem" value="#arguments.objectItem#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="action" value="#arguments.action#">
				<cfinvokeargument name="send_sms" value="#arguments.send_sms#">
				<cfinvokeargument name="anti_virus_check_result" value="#arguments.anti_virus_check_result#">

				<cfinvokeargument name="user_id" value="#SESSION.user_id#">
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
		
		<!--- 

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
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
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

					<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				</cfinvoke>
			</cfif>

			<!---imageDownloadUrl--->
			<cfif arguments.itemTypeId IS NOT 1 AND isNumeric(objectItem.attached_image_id) AND objectItem.attached_image_id GT 0>
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getDownloadFileUrl" returnvariable="downloadImageUrl">
					<cfinvokeargument name="file_id" value="#objectItem.attached_image_id#">
					<cfinvokeargument name="fileTypeId" value="1">
					<cfinvokeargument name="item_id" value="#objectItem.id#">
					<cfinvokeargument name="itemTypeName" value="#itemTypeName#">

					<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				</cfinvoke>			
			</cfif>

		</cfif>
		
		
		<!---getRootArea--->
		<cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
		</cfinvoke>
		<!---En el asunto se pone el nombre del área raiz--->
		
		
		<cfxml variable="getUsersRequest">
			<cfoutput>
			<request>
			<parameters>
				 <user id="" email=""
			telephone="" mobile_phone="" mobile_phone_ccode=""		
			sms_allowed="" whole_tree_visible="">
				<family_name><![CDATA[]]></family_name>
				<name><![CDATA[]]></name>	
			</user>
				<area id ="#objectItem.area_id#"/> 
				<order parameter="family_name" order_type="asc" />
			<preferences notify_new_#itemTypeName#="true">				
			</preferences>
			</parameters>
			</request>
			</cfoutput>
		</cfxml>
        
        <!--- getUsersToNotifyLists --->
        <cfinvoke component="UserManager" method="getUsersToNotifyLists" returnvariable="usersToNotifyLists">
			<cfinvokeargument name="request" value="#getUsersRequest#"/>
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
							#langText[curLang].new_file.virus_advice#.<br/>
							
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
									<cfinvoke component="#APPLICATION.componentsPath#/ItemSubTypeManager" method="getSubType" returnvariable="subTypeQuery">
										<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
										<cfinvokeargument name="sub_type_id" value="#objectItem.sub_type_id#">
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

				<cfinvoke component="UserManager" method="getUser" returnvariable="actionUser">
					<cfinvokeargument name="get_user_id" value="#user_id#">
					<cfinvokeargument name="format_content" value="default">
					<cfinvokeargument name="return_type" value="query">
				</cfinvoke>

				<cfset actionUserName = actionUser.user_full_name>

				<!---INTERNAL USERS--->
				<cfif len(listInternalUsers) GT 0>
				
					<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
						<cfinvokeargument name="area_id" value="#objectItem.area_id#">
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

					<cfinvoke component="EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#SESSION.client_email_from#">
						<cfinvokeargument name="from_name" value="#actionUserName#">
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
					
						<cfinvoke component="SMSManager" method="sendSMSNew">
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
					
					
					<cfinvoke component="EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#SESSION.client_email_from#">
						<cfinvokeargument name="from_name" value="#actionUserName#">
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
					
						<cfinvoke component="SMSManager" method="sendSMSNew">
							<cfinvokeargument name="text" value="#sms_message#">
							<cfinvokeargument name="recipients" value="#listExternalUsersPhones#">
						</cfinvoke>
										
					</cfif>
					
				</cfif>
			
			</cfif><!---END len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0--->
			
	
		</cfloop><!---END APPLICATION.languages loop--->

		--->
	</cffunction>



	<!--- -------------------------------------- changeItemUser ------------------------------------ --->

	<cffunction name="changeItemUser" access="public" returntype="void">
		<cfargument name="objectItem" type="query" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="old_user_id" type="numeric" required="true">
		<cfargument name="new_user_id" type="numeric" required="true">
				
		<cfset var method = "changeItemUser">
		
		<cfset var area_name = "">
		<cfset var area_path = "">
        <cfset var root_area = structNew()>
		
		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">
		
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
		
		<cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
		</cfinvoke>
		<!---En el asunto se pone el nombre del área raiz--->
		

		<cfinvoke component="UserManager" method="getUser" returnvariable="oldUser">
			<cfinvokeargument name="get_user_id" value="#arguments.old_user_id#">
			<cfinvokeargument name="format_content" value="default">
			<cfinvokeargument name="return_type" value="query">
		</cfinvoke>

		<cfinvoke component="UserManager" method="getUser" returnvariable="newUser">
			<cfinvokeargument name="get_user_id" value="#arguments.new_user_id#">
			<cfinvokeargument name="format_content" value="default">
			<cfinvokeargument name="return_type" value="query">
		</cfinvoke>

		<cfset newUserFullName = newUser.user_full_name>
		
		
		<!---OLD USER--->

		<cfif len(oldUser.email) GT 0>

			<cfif itemTypeGender EQ "male">
				<cfset actionContent = #langText[oldUser.language].change_owner_item.owner_changed_male#>
			<cfelse>
				<cfset actionContent = #langText[oldUser.language].change_owner_item.owner_changed_female#>
			</cfif>

			<cfset oldUsersubject = "[#root_area.name#][#langText[oldUser.language].item[itemTypeId].name# #actionContent#] "&objectItem.title>

			<cfinvoke component="AlertManager" method="getChangeItemUserAlertContents" returnvariable="oldUserContent">
				<cfinvokeargument name="language" value="#oldUser.language#">
				<cfinvokeargument name="objectItem" value="#arguments.objectItem#"/>
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#"/>
				<cfinvokeargument name="area_id" value="#objectItem.area_id#"/>
				<cfinvokeargument name="new_user_full_name" value="#newUserFullName#"/>
			</cfinvoke>

			<cfif oldUser.internal_user IS true><!---INTERNAL USER--->
				
				<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
					<cfinvokeargument name="area_id" value="#objectItem.area_id#">
				</cfinvoke>
				
				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="oldUserContentInternal">
				<cfoutput>
		#langText[oldUser.language].change_owner_item.your_item_was_changed#<br/><br/>

		#langText[oldUser.language].common.area#: <strong>#area_name#</strong>.<br/>
		#langText[oldUser.language].common.area_path#: #area_path#.<br/><br/>
		
		#oldUserContent.alertContent#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>				

			<cfelse><!---EXTERNAL USER--->

				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="oldUserContentExternal">
				<cfoutput>
		#langText[oldUser.language].change_owner_item.your_item_was_changed#<br/><br/>

		#langText[oldUser.language].common.area#: <strong>#area_name#</strong> #langText[oldUser.language].common.of_the_organization# #root_area.name#.<br/><br/>
		
		#oldUserContent.alertContent#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>

			</cfif>
			
			<cfinvoke component="EmailManager" method="sendEmail">
				<cfinvokeargument name="from" value="#SESSION.client_email_from#">
				<cfinvokeargument name="to" value="#oldUser.email#">
				<cfinvokeargument name="subject" value="#oldUsersubject#">
				<cfif oldUser.internal_user IS true><!---INTERNAL USER--->
					<cfinvokeargument name="content" value="#oldUserContentInternal#">
				<cfelse>
					<cfinvokeargument name="content" value="#oldUserContentExternal#">
				</cfif>
				<cfinvokeargument name="foot_content" value="#oldUserContent.footContent#">
			</cfinvoke>

		</cfif>


		<!---NEW USER--->

		<cfif len(newUser.email) GT 0>

			<cfif itemTypeGender EQ "male">
				<cfset actionContent = #langText[newUser.language].change_owner_item.owner_changed_male#>
			<cfelse>
				<cfset actionContent = #langText[newUser.language].change_owner_item.owner_changed_female#>
			</cfif>
			<cfset newUserSubject = "[#root_area.name#][#langText[newUser.language].item[itemTypeId].name# #actionContent#] "&objectItem.title>

			<cfinvoke component="AlertManager" method="getChangeItemUserAlertContents" returnvariable="newUserContent">
				<cfinvokeargument name="language" value="#newUser.language#">
				<cfinvokeargument name="objectItem" value="#arguments.objectItem#"/>
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#"/>
				<cfinvokeargument name="area_id" value="#objectItem.area_id#"/>
				<cfinvokeargument name="new_user_full_name" value="#newUserFullName#"/>
			</cfinvoke>

			<cfif newUser.internal_user IS true><!---INTERNAL USER--->
				
				<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
					<cfinvokeargument name="area_id" value="#objectItem.area_id#">
				</cfinvoke>
				
				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="newUserContentInternal">
				<cfoutput>
		#langText[newUser.language].change_owner_item.you_have_new_item#<br/><br/>

		#langText[newUser.language].common.area#: <strong>#area_name#</strong>.<br/>
		#langText[newUser.language].common.area_path#: #area_path#.<br/><br/>
		
		#newUserContent.alertContent#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>				

			<cfelse><!---EXTERNAL USER--->

				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="newUserContentExternal">
				<cfoutput>
		#langText[newUser.language].change_owner_item.you_have_new_item#<br/><br/>

		#langText[newUser.language].common.area#: <strong>#area_name#</strong> #langText[newUser.language].common.of_the_organization# #root_area.name#.<br/><br/>
		
		#newUserContent.alertContent#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>

			</cfif>
			
			<cfinvoke component="EmailManager" method="sendEmail">
				<cfinvokeargument name="from" value="#SESSION.client_email_from#">
				<cfinvokeargument name="to" value="#newUser.email#">
				<cfinvokeargument name="subject" value="#newUserSubject#">
				<cfif newUser.internal_user IS true><!---INTERNAL USER--->
					<cfinvokeargument name="content" value="#newUserContentInternal#">
				<cfelse>
					<cfinvokeargument name="content" value="#newUserContentExternal#">
				</cfif>
				<cfinvokeargument name="foot_content" value="#newUserContent.footContent#">
			</cfinvoke>	
		
		</cfif>
				

	</cffunction>
	


	<!--- --------------------------- getChangeItemUserAlertContents --------------------------- --->
	
	<cffunction name="getChangeItemUserAlertContents" access="private" returntype="struct">
		<cfargument name="language" type="string" required="true">
		<cfargument name="objectItem" type="any" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="new_user_full_name" type="string" required="true">
 				
		<cfset var method = "getChangeItemUserAlertContents">

		<cfset var accessContent = "">
		<cfset var alertContent = "">
		<cfset var footContent = "">

		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemAccessContent" returnvariable="accessContent">
			<cfinvokeargument name="item_id" value="#objectItem.id#"/>
			<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#"/>
			<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
			<cfinvokeargument name="language" value="#arguments.language#">

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>

		<cfsavecontent variable="alertContent">
			<cfoutput>
			<cfif itemTypeId IS 1>#langText[arguments.language].new_item.subject#<cfelse>#langText[arguments.language].new_item.title#</cfif>: <strong style="font-size:14px;">#objectItem.title#</strong><br/>			
			#langText[arguments.language].change_owner_item.old_user#: <strong>#objectItem.user_full_name#</strong><br />
			#langText[arguments.language].change_owner_item.new_user#: <strong>#arguments.new_user_full_name#</strong><br />

			#langText[arguments.language].new_item.creation_date#: #objectItem.creation_date#<br/>
			<cfif itemTypeId IS NOT 1 AND len(objectItem.last_update_date) GT 0>
			#langText[arguments.language].new_item.last_update_date#: #objectItem.last_update_date#<br/>
			</cfif>
			<br/>
			<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#accessContent#</div>
			</cfoutput>
		</cfsavecontent>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemFootContent" returnvariable="footContent">
			<cfinvokeargument name="language" value="#arguments.language#">
		</cfinvoke>

		<cfreturn {alertContent=#alertContent#, footContent=#footContent#}>

	</cffunction>
	
	
	<!--- -------------------------------------- replaceFile ------------------------------------ --->
	
	<cffunction name="replaceFile" access="public" returntype="void">
		<cfargument name="objectFile" type="query" required="true">
				
		<cfset var method = "replaceFile">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
		<cfquery datasource="#client_dsn#" name="getFileAreas">
			SELECT *
			FROM #client_abb#_areas_files
			WHERE file_id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif getFileAreas.RecordCount GT 0>
			<cfloop query="getFileAreas">
				
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newFile">
					<cfinvokeargument name="objectFile" value="#arguments.objectFile#">
					<cfinvokeargument name="fileTypeId" value="#objectFile.file_type_id#"/>
					<cfinvokeargument name="area_id" value="#getFileAreas.area_id#">
					<cfinvokeargument name="user_id" value="#user_id#">
					<cfinvokeargument name="action" value="replace">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>	
				
			</cfloop>
		</cfif>
						
		
	</cffunction>
	


	<!--- -------------------------------------- changeFileUser ------------------------------------ --->

	<cffunction name="changeFileUser" access="public" returntype="void">
		<cfargument name="objectFile" type="query" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="old_user_id" type="numeric" required="true">
		<cfargument name="new_user_id" type="numeric" required="true">
				
		<cfset var method = "changeFileUser">
		
		<cfset var area_name = "">
		<cfset var area_path = "">
        <cfset var root_area = structNew()>
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
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
		
		<cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
		</cfinvoke>
		<!---En el asunto se pone el nombre del área raiz--->
		

		<cfinvoke component="UserManager" method="getUser" returnvariable="oldUser">
			<cfinvokeargument name="get_user_id" value="#arguments.old_user_id#">
			<cfinvokeargument name="format_content" value="default">
			<cfinvokeargument name="return_type" value="query">
		</cfinvoke>

		<cfinvoke component="UserManager" method="getUser" returnvariable="newUser">
			<cfinvokeargument name="get_user_id" value="#arguments.new_user_id#">
			<cfinvokeargument name="format_content" value="default">
			<cfinvokeargument name="return_type" value="query">
		</cfinvoke>

		<cfset newUserFullName = newUser.user_full_name>
		
		
		<!---OLD USER--->
		<cfset oldUsersubject = "[#root_area.name#][#langText[oldUser.language].change_owner_file.file_owner_changed#] "&objectFile.name>

		<cfinvoke component="AlertManager" method="getChangeFileUserAlertContents" returnvariable="oldUserContent">
			<cfinvokeargument name="language" value="#oldUser.language#">
			<cfinvokeargument name="objectFile" value="#arguments.objectFile#"/>
			<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
			<cfinvokeargument name="new_user_full_name" value="#newUserFullName#"/>
		</cfinvoke>

		<cfif oldUser.internal_user IS true><!---INTERNAL USER--->
			
			<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>
			
			<cfprocessingdirective suppresswhitespace="true">
			<cfsavecontent variable="oldUserContentInternal">
			<cfoutput>
	#langText[oldUser.language].change_owner_file.your_file_was_changed#<br/><br/>

	#langText[oldUser.language].common.area#: <strong>#area_name#</strong>.<br/>
	#langText[oldUser.language].common.area_path#: #area_path#.<br/><br/>
	
	#oldUserContent.alertContent#
			</cfoutput>
			</cfsavecontent>
			</cfprocessingdirective>				

		<cfelse><!---EXTERNAL USER--->

			<cfprocessingdirective suppresswhitespace="true">
			<cfsavecontent variable="oldUserContentExternal">
			<cfoutput>
	#langText[oldUser.language].change_owner_file.your_file_was_changed#<br/><br/>

	#langText[oldUser.language].common.area#: <strong>#area_name#</strong> #langText[oldUser.language].common.of_the_organization# #root_area.name#.<br/><br/>
	
	#oldUserContent.alertContent#
			</cfoutput>
			</cfsavecontent>
			</cfprocessingdirective>

		</cfif>
		
		<cfinvoke component="EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="#SESSION.client_email_from#">
			<cfinvokeargument name="to" value="#oldUser.email#">
			<cfinvokeargument name="subject" value="#oldUsersubject#">
			<cfif oldUser.internal_user IS true><!---INTERNAL USER--->
				<cfinvokeargument name="content" value="#oldUserContentInternal#">
			<cfelse>
				<cfinvokeargument name="content" value="#oldUserContentExternal#">
			</cfif>
			<cfinvokeargument name="foot_content" value="#oldUserContent.footContent#">
		</cfinvoke>


		<!---NEW USER--->
		<cfset newUserSubject = "[#root_area.name#][#langText[newUser.language].change_owner_file.file_owner_changed#] "&objectFile.name>

		<cfinvoke component="AlertManager" method="getChangeFileUserAlertContents" returnvariable="newUserContent">
			<cfinvokeargument name="language" value="#newUser.language#">
			<cfinvokeargument name="objectFile" value="#arguments.objectFile#"/>
			<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
			<cfinvokeargument name="new_user_full_name" value="#newUserFullName#"/>
		</cfinvoke>

		<cfif newUser.internal_user IS true><!---INTERNAL USER--->
			
			<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>
			
			<cfprocessingdirective suppresswhitespace="true">
			<cfsavecontent variable="newUserContentInternal">
			<cfoutput>
	#langText[newUser.language].change_owner_file.you_have_new_file#<br/><br/>

	#langText[newUser.language].common.area#: <strong>#area_name#</strong>.<br/>
	#langText[newUser.language].common.area_path#: #area_path#.<br/><br/>
	
	#newUserContent.alertContent#
			</cfoutput>
			</cfsavecontent>
			</cfprocessingdirective>				

		<cfelse><!---EXTERNAL USER--->

			<cfprocessingdirective suppresswhitespace="true">
			<cfsavecontent variable="newUserContentExternal">
			<cfoutput>
	#langText[newUser.language].change_owner_file.you_have_new_file#<br/><br/>

	#langText[newUser.language].common.area#: <strong>#area_name#</strong> #langText[newUser.language].common.of_the_organization# #root_area.name#.<br/><br/>
	
	#newUserContent.alertContent#
			</cfoutput>
			</cfsavecontent>
			</cfprocessingdirective>

		</cfif>
		
		<cfinvoke component="EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="#SESSION.client_email_from#">
			<cfinvokeargument name="to" value="#newUser.email#">
			<cfinvokeargument name="subject" value="#newUserSubject#">
			<cfif newUser.internal_user IS true><!---INTERNAL USER--->
				<cfinvokeargument name="content" value="#newUserContentInternal#">
			<cfelse>
				<cfinvokeargument name="content" value="#newUserContentExternal#">
			</cfif>
			<cfinvokeargument name="foot_content" value="#newUserContent.footContent#">
		</cfinvoke>	
		
				
	</cffunction>


	<!--- --------------------------- getChangeFileUserAlertContents --------------------------- --->
	
	<cffunction name="getChangeFileUserAlertContents" access="private" returntype="struct">
		<cfargument name="language" type="string" required="true">
		<cfargument name="objectFile" type="query" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="new_user_full_name" type="string" required="true">
 				
		<cfset var method = "getChangeFileUserFootContent">

		<cfset var accessContent = "">
		<cfset var alertContent = "">
		<cfset var footContent = "">

		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getFileAccessContent" returnvariable="accessContent">
			<cfinvokeargument name="file_id" value="#objectFile.id#"/>
			<cfinvokeargument name="fileTypeId" value="#objectFile.file_type_id#"/>
			<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
			<cfinvokeargument name="language" value="#arguments.language#">

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>

		<cfsavecontent variable="alertContent">
			<cfoutput>
			#langText[language].new_file.file_name#: <strong>#objectFile.name#</strong><br />
			#langText[language].change_owner_item.old_user#: <strong>#objectFile.user_full_name#</strong><br />
			#langText[language].change_owner_item.new_user#: <strong>#arguments.new_user_full_name#</strong><br />
			#langText[language].new_file.upload_date#: #objectFile.uploading_date#<br/>
			<cfif len(objectFile.replacement_date) GT 0>
				#langText[language].new_file.replacement_date#: #objectFile.replacement_date#<br/>
			</cfif>
			#langText[language].new_file.description#:<br/><br/>
			<div style="padding-left:15px;">#objectFile.description#</div>
			<br/>
			<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#accessContent#</div>
			</cfoutput>
		</cfsavecontent>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getFileFootContent" returnvariable="footContent">
			<cfinvokeargument name="language" value="#arguments.language#">
		</cfinvoke>

		<cfreturn {alertContent=#alertContent#, footContent=#footContent#}>

	</cffunction>



	<!--- -------------------------------------- requestFileApproval ------------------------------------ --->

	<cffunction name="requestFileApproval" access="public" returntype="void">
		<cfargument name="objectFile" type="query" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="action" type="string" required="true"><!--- revision/approval --->
				
		<cfset var method = "requestFileApproval">
		
		<cfset var area_name = "">
		<cfset var area_path = "">
        <cfset var root_area = structNew()>
        <cfset var action_user_id = "">
        <cfset var actionSubject = "">
        <cfset var actionText = "">
        <cfset var fileAlertContent = "">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
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
		
		<cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
		</cfinvoke>
		<!---En el asunto se pone el nombre del área raiz--->
		
		<cfif arguments.action IS "revision">
			<cfset action_user_id = objectFile.reviser_user>
		<cfelse>
			<cfset action_user_id = objectFile.approver_user>
		</cfif>

		<cfinvoke component="UserManager" method="getUser" returnvariable="actionUser">
			<cfinvokeargument name="get_user_id" value="#action_user_id#">
			<cfinvokeargument name="format_content" value="default">
			<cfinvokeargument name="return_type" value="query">
		</cfinvoke>

		<cfset actionUserFullName = actionUser.user_full_name>

		<cfif arguments.action IS "revision">
			<cfset actionSubject = langText[actionUser.language].file_revision.file_revision_request>
			<cfset actionText = langText[actionUser.language].file_revision.you_have_to_revise>
		<cfelse>
			<cfset actionSubject = langText[actionUser.language].file_approval.file_approval_request>
			<cfset actionText = langText[actionUser.language].file_approval.you_have_to_approve>
		</cfif>

		<!---ACTION USER--->
		<cfset actionUserSubject = "[#root_area.name#][#actionSubject#] "&objectFile.name>
					
		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getFileAccessContent" returnvariable="accessContent">
			<cfinvokeargument name="file_id" value="#objectFile.id#"/>
			<cfinvokeargument name="fileTypeId" value="#objectFile.file_type_id#"/>
			<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
			<cfinvokeargument name="language" value="#actionUser.language#">

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getFileFootContent" returnvariable="footContent">
			<cfinvokeargument name="language" value="#actionUser.language#">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getFileAlertContent" returnvariable="fileAlertContent">
			<cfinvokeargument name="objectFile" value="#arguments.objectFile#">
			<cfinvokeargument name="language" value="#actionUser.language#">
		</cfinvoke>

		<cfsavecontent variable="commonContent">
			<cfoutput>
			#fileAlertContent#
			<br/>
			<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#accessContent#</div>
			</cfoutput>
		</cfsavecontent>

		<cfif actionUser.internal_user IS true><!---INTERNAL USER--->
			
			<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>
			
			<cfprocessingdirective suppresswhitespace="true">
			<cfsavecontent variable="actionUserContentInternal">
			<cfoutput>
	#actionText#<br/><br/>

	#langText[actionUser.language].common.area#: <strong>#area_name#</strong>.<br/>
	#langText[actionUser.language].common.area_path#: #area_path#.<br/><br/>
	
	#commonContent#
			</cfoutput>
			</cfsavecontent>
			</cfprocessingdirective>				

		<cfelse><!---EXTERNAL USER--->

			<cfprocessingdirective suppresswhitespace="true">
			<cfsavecontent variable="actionUserContentExternal">
			<cfoutput>
	#actionText#<br/><br/>

	#langText[actionUser.language].common.area#: <strong>#area_name#</strong> #langText[actionUser.language].common.of_the_organization# #root_area.name#.<br/><br/>
	
	#commonContent#
			</cfoutput>
			</cfsavecontent>
			</cfprocessingdirective>

		</cfif>
		
		<cfinvoke component="EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="#SESSION.client_email_from#">
			<cfinvokeargument name="to" value="#actionUser.email#">
			<cfinvokeargument name="subject" value="#actionUserSubject#">
			<cfif actionUser.internal_user IS true><!---INTERNAL USER--->
				<cfinvokeargument name="content" value="#actionUserContentInternal#">
			<cfelse>
				<cfinvokeargument name="content" value="#actionUserContentExternal#">
			</cfif>
			<cfinvokeargument name="foot_content" value="#footContent#">
		</cfinvoke>	
		
				
	</cffunction>




    <!--- -------------------------------------- newArea ------------------------------------ --->
	
	<cffunction name="newArea" access="public" returntype="void">
		<cfargument name="objectArea" type="query" required="yes">
				
		<cfset var method = "newArea">
		
		<cfset var internalUsersEmails = "">
		<cfset var externalUsersEmails = "">
		<cfset var listInternalUsers = "">
		<cfset var listExternalUsers = "">
        
        <cfset var root_area = structNew()>
		<cfset var foot_content = "">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
		<!---getRootArea--->
		<cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
		</cfinvoke>
		<!---En el asunto se pone el nombre del área raiz--->
		
        <cfsavecontent variable="getUsersParameters">
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
		
		<cfinvoke component="RequestManager" method="createRequest" returnvariable="getUsersRequest">
			<cfinvokeargument name="request_parameters" value="#getUsersParameters#">
		</cfinvoke>
        
        <cfinvoke component="UserManager" method="getUsersToNotifyLists" returnvariable="usersToNotifyLists">
			<cfinvokeargument name="request" value="#getUsersRequest#"/>
		</cfinvoke>
		
		<cfset internalUsersEmails = usersToNotifyLists.structInternalUsersEmails>
		<cfset externalUsersEmails = usersToNotifyLists.structExternalUsersEmails>

		<cfloop list="#APPLICATION.languages#" index="curLang">
		
			<cfset listInternalUsers = internalUsersEmails[curLang]>
			<cfset listExternalUsers = externalUsersEmails[curLang]>
        
			<cfif len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0><!---Si hay usuarios a los que notificar--->

				<cfinvoke component="AlertManager" method="getAreaAccessContent" returnvariable="access_content">
					<cfinvokeargument name="area_id" value="#objectArea.id#"/>
					<cfinvokeargument name="language" value="#curLang#">
				</cfinvoke>
				
				<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">'&langText[curLang].common.foot_content_default_3&' #APPLICATION.title#.</p>'>	
				
				<cfset subject = "[#root_area.name#][#langText[curLang].new_area.new_area#] #objectArea.name#">
				
				<!---INTERNAL USERS--->
				<cfif len(listInternalUsers) GT 0>
				
					<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
						<cfinvokeargument name="area_id" value="#objectArea.id#">
					</cfinvoke>
					
					<cfset subjectInternal = subject>
				
					<cfsavecontent variable="contentInternal">
					<cfoutput>
					<br />
			#langText[curLang].new_area.area_created#: <strong>#objectArea.name#</strong> #langText[curLang].new_area.on_the_organization# #root_area.name#, #langText[curLang].new_area.and_you_have_access#.<br />
			#langText[curLang].common.area_path#: #area_path#.<br /><br />
			<cfif len(objectArea.description) GT 0>
			#langText[curLang].common.area_description#:<br /> 
			#objectArea.description#<br />
			</cfif>
			<br/>
			<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>
					</cfoutput>		
					</cfsavecontent>
					
					<cfinvoke component="EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#SESSION.client_email_from#">
						<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
						<cfinvokeargument name="bcc" value="#listInternalUsers#">
						<cfinvokeargument name="subject" value="#subjectInternal#">
						<cfinvokeargument name="content" value="#contentInternal#">
						<cfinvokeargument name="foot_content" value="#foot_content#">
					</cfinvoke>	
					
				</cfif>
				
				<!---EXTERNAL USERS--->
				<cfif len(listExternalUsers) GT 0>
					
					<cfset subjectExternal = subject>
					
					<cfsavecontent variable="contentExternal">
					<cfoutput>
					<br />
			#langText[curLang].new_area.area_created#: <strong>#objectArea.name#</strong> #langText[curLang].new_area.on_the_organization# #root_area.name#, #langText[curLang].new_area.and_you_have_access#.<br /><br />
			<cfif len(objectArea.description) GT 0>
			#langText[curLang].common.area_description#:<br /> 
			#objectArea.description#<br />
			</cfif>
			<br/>
			<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>
					</cfoutput>		
					</cfsavecontent>
					
					<cfinvoke component="EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#SESSION.client_email_from#">
						<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
						<cfinvokeargument name="bcc" value="#listExternalUsers#">
						<cfinvokeargument name="subject" value="#subjectExternal#">
						<cfinvokeargument name="content" value="#contentExternal#">
						<cfinvokeargument name="foot_content" value="#foot_content#">
					</cfinvoke>	
					
				</cfif>
		
			</cfif><!---END len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0--->
			
		</cfloop><!---END APPLICATION.languages loop--->
		
	</cffunction>


	<!--- --------------------------- getAreaAccessContent --------------------------- --->
	
	<cffunction name="getAreaAccessContent" access="private" returntype="string">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="language" type="string" required="true">
 				
		<cfset var method = "getAreaAccessContent">

		<cfset var accessContent = "">
		<cfset var accessClient = "">

		<!---areaUrl--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaUrl" returnvariable="areaUrl">
			<cfinvokeargument name="area_id" value="#arguments.area_id#">

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>
		
		<cfif APPLICATION.twoUrlsToAccess IS false>
		
			<cfsavecontent variable="accessContent">
			<cfoutput>
			-&nbsp;#langText[arguments.language].common.access_to_area#:
			<a target="_blank" href="#areaUrl#">#areaUrl#</a>
			

			<cfif SESSION.client_abb EQ "hcs">
				<cfset accessClient = "doplanning">
			<cfelse>
				<cfset accessClient = SESSION.client_id>
			</cfif>

			<br/>-&nbsp;#langText[arguments.language].common.access_to_application#:
			<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#accessClient#">#APPLICATION.mainUrl##APPLICATION.path#/#accessClient#</a>
			</cfoutput>
			</cfsavecontent>
			
		<cfelse>
		
			<cfsavecontent variable="accessContent">
			<cfoutput>
			#langText[arguments.language].common.access_to_area_links#: <br/>
			-&nbsp;#langText[arguments.language].common.access_internal# <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/?area=#area_id#&abb=#SESSION.client_abb#">#APPLICATION.mainUrl##APPLICATION.path#/?area=#area_id#&abb=#SESSION.client_abb#</a><br/>
			-&nbsp;#langText[arguments.language].common.access_external# <a target="_blank" href="#APPLICATION.alternateUrl#/?area=#area_id#&abb=#SESSION.client_abb#">#APPLICATION.alternateUrl#/?area=#area_id#&abb=#SESSION.client_abb#</a>
			</cfoutput>
			</cfsavecontent>
			
		</cfif>
		
		<cfreturn accessContent>

	</cffunction>
    
	
	<!--- -------------------------------------- assignUserToArea ------------------------------------ --->
	
	<cffunction name="assignUserToArea" access="public" returntype="void">
		<cfargument name="objectUser" type="query" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="new_area" type="boolean" required="no" default="false">
				
		<cfset var method = "assignUserToArea">
        
        <cfset var root_area = structNew()>
        <cfset var curLang = "">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
		<cfif objectUser.enabled IS true>

			<cfset curLang = objectUser.language>

	        <cfinvoke component="AreaManager" method="getArea" returnvariable="objectArea">
	            <cfinvokeargument name="get_area_id" value="#area_id#">
	            <cfinvokeargument name="format_content" value="default">
	            <cfinvokeargument name="return_type" value="object">
	        </cfinvoke>
	        	
	        <cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
	        </cfinvoke>
	        <!---En el asunto se pone el nombre del área raiz--->
	        <cfif arguments.new_area IS false>
				<cfset subject = "[#root_area.name#] #langText[curLang].assign_user.has_been_added_as_user#: "&objectArea.name>
			<cfelse>
				<cfset subject = "[#root_area.name#] #langText[curLang].assign_user.has_been_added_as_responsible#: "&objectArea.name>
			</cfif>
	        
			<cfif objectUser.whole_tree_visible IS true><!---INTERNAL USER--->
				<!---<cfset subject="[#APPLICATION.title#] Tiene acceso a una nueva área: "&objectArea.name>--->
				
				<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>
				
			<!---<cfelse>
				<cfset subject="[#APPLICATION.title#][#SESSION.client_name#] Tiene acceso a una nueva área: "&objectArea.name>--->
			</cfif>
					
			<cfinvoke component="AlertManager" method="getAreaAccessContent" returnvariable="access_content">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="language" value="#curLang#">
			</cfinvoke>
			
			<cfsavecontent variable="html_text">
			<cfoutput>
			<br />
	<cfif arguments.new_area IS false>
	#langText[curLang].assign_user.has_been_added_to_area#: <strong>#objectArea.name#</strong> #langText[curLang].common.of_the_organization# #root_area.name#.<br />
	<cfelse>
	#langText[curLang].assign_user.area_created#: <strong>#objectArea.name#</strong>, #langText[curLang].assign_user.you_are_responsible#.<br />
	</cfif>
	<cfif objectUser.whole_tree_visible IS true>
	#langText[curLang].common.area_path#: #area_path#.<br />
	</cfif>
	<br />
	<cfif len(objectArea.description) GT 0>
	#langText[curLang].common.area_description#:<br /> 
	#objectArea.description#<br />
	</cfif>
	<br/>
	<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>	
			</cfoutput>		
			</cfsavecontent>

			<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">#langText[curLang].common.foot_content_default_3# #APPLICATION.title#.</p>'>		
			
			<cfinvoke component="EmailManager" method="sendEmail">
				<cfinvokeargument name="from" value="#SESSION.client_email_from#">
				<cfinvokeargument name="to" value="#objectUser.email#">
				<cfinvokeargument name="subject" value="#subject#">
				<cfinvokeargument name="content" value="#html_text#">
				<cfinvokeargument name="foot_content" value="#foot_content#">
			</cfinvoke>

		</cfif>
		
	</cffunction>



	<!--- -------------------------------------- addUserToTable ------------------------------------ --->
	
	<cffunction name="addUserToTable" access="package" returntype="void">
		<cfargument name="tableQuery" type="query" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="userQuery" type="query" required="true">
				
		<cfset var method = "addUserToTable">
        
        <cfset var area_id = "">
        <cfset var root_area = structNew()>
        <cfset var curLang = "">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
		
		<cfset area_id = tableQuery.area_id>
		<cfset curLang = userQuery.language>

        <!---<cfinvoke component="AreaManager" method="getArea" returnvariable="objectArea">
            <cfinvokeargument name="get_area_id" value="#area_id#">
            <cfinvokeargument name="format_content" value="default">
            <cfinvokeargument name="return_type" value="object">
        </cfinvoke>--->
        	
        <cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
        </cfinvoke>
        <!---En el asunto se pone el nombre del área raiz--->

		<cfset subject = "[#root_area.name#] #langText[curLang].add_user_to_table.has_been_added_as_editor_of# #langText[curLang].item[itemTypeId].name#: "&tableQuery.title>
        
		<cfif userQuery.whole_tree_visible IS true><!---INTERNAL USER--->
			
			<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>

		</cfif>
				
		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemAccessContent" returnvariable="access_content">
			<cfinvokeargument name="language" value="#curLang#">
			<cfinvokeargument name="item_id" value="#tableQuery.table_id#"/>
			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
			<cfinvokeargument name="area_id" value="#area_id#"/>

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>
		
		<cfsavecontent variable="html_text">
		<cfoutput>
		<br />
#langText[curLang].add_user_to_table.has_been_added_as_editor_of# #langText[curLang].item[itemTypeId].name#: <strong>#tableQuery.title#</strong><br />

<cfif userQuery.whole_tree_visible IS true>
#langText[curLang].common.area_path#: #area_path#.<br />
</cfif>
<br/>
<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>	
		</cfoutput>		
		</cfsavecontent>

		<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">#langText[curLang].common.foot_content_default_3# #APPLICATION.title#.</p>'>		
		
		<cfinvoke component="EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="#SESSION.client_email_from#">
			<cfinvokeargument name="to" value="#userQuery.email#">
			<cfinvokeargument name="subject" value="#subject#">
			<cfinvokeargument name="content" value="#html_text#">
			<cfinvokeargument name="foot_content" value="#foot_content#">
		</cfinvoke>
		
	</cffunction>
	
	
	
	<!--- -------------------------------------- newUser ------------------------------------ --->
	
	<cffunction name="newUser" access="public" returntype="void">
		<cfargument name="objectUser" type="query" required="yes">
		<cfargument name="password_temp" type="string" required="no">
				
		<cfset var method = "newUser">
        
        <cfset var root_area = structNew()>
		<cfset var login_ldap = "">
		<cfset var curLang = "">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">	
		
		<cfif len(objectUser.language) IS 0>
			<cfset curLang = APPLICATION.defaultLanguage>
		<cfelse>
			<cfset curLang = objectUser.language>
		</cfif>

        <cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
        </cfinvoke>
        <!---En el asunto se pone el nombre del área raiz--->
        <cfset subject = "[#root_area.name#] #langText[curLang].new_user.you_has_been_registered_in_organization#.">
		
		<cfinvoke component="AlertManager" method="getApplicationAccess" returnvariable="access_content">
			<cfinvokeargument name="client_id" value="#SESSION.client_id#">
			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			<cfinvokeargument name="curLang" value="#curLang#"/>
		</cfinvoke>
		
		<!---Esto tiene que completarse con la generación de un código de ticket--->	
		<!---IMPORTANTE: Para confirmar su alta debe acceder a la siguiente dirección: #APPLICATION.mainUrl#/#SESSION.client_id#--->		
		<cfsavecontent variable="html_text">
		<cfoutput>
#langText[curLang].new_user.you_has_been_registered_in_application# #APPLICATION.title# #langText[curLang].common.of_the_organization# <b>#root_area.name#</b>.<br /><br />

<cfif APPLICATION.identifier NEQ "vpnet"><!---Default User--->
#langText[curLang].new_user.if_you_use_the_application#: <a href="#APPLICATION.termsOfUseUrl#">#APPLICATION.termsOfUseUrl#</a>.<br/><br/>

#langText[curLang].common.your_access_email#: <b>#objectUser.email#</b><br />
#langText[curLang].new_user.password#: <b>#arguments.password_temp#</b><br/>
#langText[curLang].common.you_must_change_password#.<br /><br/>

</cfif>
<cfif APPLICATION.moduleLdapUsers IS true><!---LDAP User--->
	
	<cfif APPLICATION.identifier NEQ "vpnet">
		
		#langText[curLang].new_user.also_you_can_use#: <br/>

		<cfif isDefined("arguments.objectUser.login_ldap") AND len(arguments.objectUser.login_ldap) GT 0>
			#APPLICATION.ldapName#: <b>#arguments.objectUser.login_ldap#</b><br/>
		</cfif>
		<cfif isDefined("arguments.objectUser.login_diraya") AND len(arguments.objectUser.login_diraya) GT 0>
			Diraya: <b>#arguments.objectUser.login_diraya#</b><br/>
		</cfif>

	<cfelse><!---vpnet--->

		<cfif isDefined("arguments.objectUser.login_ldap") AND len(arguments.objectUser.login_ldap) GT 0>
			<cfset ldap_name = APPLICATION.ldapName>
			<cfset login_ldap = arguments.objectUser.login_ldap>
		<cfelseif isDefined("arguments.objectUser.login_diraya")>
			<cfset ldap_name = "Diraya">
			<cfset login_ldap = arguments.objectUser.login_diraya>
		</cfif>
		#langText[curLang].new_user.user_access_identify_to# #ldap_name#.<br/>
		#langText[curLang].common.user#: <b>#login_ldap#</b><br/>

	</cfif>

</cfif><br/>

<cfif APPLICATION.identifier NEQ "vpnet">
	#langText[curLang].new_user.to_view_tutorials_access#: <a href="#APPLICATION.helpUrl#">#APPLICATION.helpUrl#</a><br/>
</cfif>
<br/>

<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;"><b>#access_content#</b></div>

		</cfoutput>		
		</cfsavecontent>
		
		<!---<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">#langText[curLang].common.foot_content_default_3# #APPLICATION.title#.</p>'>--->

		<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;"><span style="color:##FF0000; font-size:12px;">#langText[curLang].common.foot_do_not_reply#.</span><br/>#langText[curLang].common.foot_content_default_1# #APPLICATION.title#.</p>'>		
		
		<cfinvoke component="EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="#SESSION.client_email_from#">
			<cfinvokeargument name="to" value="#objectUser.email#">
			<cfinvokeargument name="subject" value="#subject#">
			<cfinvokeargument name="content" value="#html_text#">
			<cfinvokeargument name="foot_content" value="#foot_content#">
		</cfinvoke>
		
		
	</cffunction>	
	
	
	
	
	<!--- -------------------------------------- generateNewPassword ------------------------------------ --->
	
	<cffunction name="generateNewPassword" access="public" returntype="void">
		<cfargument name="user_full_name" type="string" required="true">
		<cfargument name="user_email" type="string" required="true">
		<cfargument name="user_password" type="string" required="true">
		<cfargument name="user_language" type="string" required="true"/>
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">
				
		<cfset var method = "generateNewPassword">
        
        <cfset var rootAreaQuery = structNew()>
		
		<cfset var curLang = arguments.user_language>
		
		<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getRootArea" returnvariable="rootAreaQuery">
			<cfinvokeargument name="onlyId" value="false">
			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>
			
        <cfset subject = "[#rootAreaQuery.name#] #langText[curLang].new_password.new_password_to_access# #APPLICATION.title#">
		
		<!---<cfinvoke component="AlertManager" method="getApplicationAccess" returnvariable="access_content">
		</cfinvoke>--->
		
	
		<cfsavecontent variable="html_text">
		<cfoutput>
#langText[curLang].new_password.new_password_to_access_application# #APPLICATION.title# #langText[curLang].common.of_the_organization# <b>#rootAreaQuery.name#</b>.<br /><br />

#langText[curLang].common.your_access_email#: #arguments.user_email#<br /><br/>
<span style="font-size:15px">#langText[curLang].new_password.new_password#: <b>#arguments.user_password#</b></span><br/><br/>
#langText[curLang].common.you_must_change_password#.<br /><br/>

<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#langText[curLang].common.access_to_application#: <br/><a href="#APPLICATION.mainUrl##APPLICATION.path#/html/login/?client_abb=#arguments.client_abb#" target="_blank">#APPLICATION.mainUrl##APPLICATION.path#/html/login/?client_abb=#arguments.client_abb#</a></div>

		</cfoutput>		
		</cfsavecontent>
		
		<!--- <cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">#langText[curLang].common.foot_content_default_3# #APPLICATION.title#.</p>'> --->		
		
		<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;"><span style="color:##FF0000; font-size:12px;">#langText[curLang].common.foot_do_not_reply#.</span><br/>#langText[curLang].common.foot_content_default_1# #APPLICATION.title#.</p>'>

		<cfinvoke component="EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
			<cfinvokeargument name="to" value="#arguments.user_email#">
			<cfinvokeargument name="subject" value="#subject#">
			<cfinvokeargument name="content" value="#html_text#">
			<cfinvokeargument name="foot_content" value="#foot_content#">
		</cfinvoke>
		
		
	</cffunction>	
	
	
	
	
	<!--- -------------------------------------- newIncidence ----------------------------------- --->
	
	<cffunction name="newIncidence" access="public" returntype="void">
		<cfargument name="objectIncidence" type="query" required="yes">
				
		<cfset var method = "newIncidence">
		
		<cfset var subject = "">
		<cfset var foot_content = "">
		<cfset var curLang = "es">

		<cfinclude template="includes/functionStartOnlySession.cfm">
		       
		<cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
        </cfinvoke>
        <cfset subject = "[#root_area.name#] Incidencia registrada.">
		
		<cfsavecontent variable="html_text">
			<cfoutput>
			Su incidencia ha sido registrada con los siguientes datos:<br/><br/>
			ID de incidencia: <strong>#client_abb##objectIncidence.id#</strong><br/>
			Fecha de registro: <strong>#objectIncidence.creation_date_formatted#</strong><br/>
			Tipo: <strong>#objectIncidence.title_es#</strong><br/>
			Referente a: <strong>#objectIncidence.related_to#</strong><br/>
			Asunto: <strong>#objectIncidence.title#</strong><br/>
			Descripción detallada: <br/> #objectIncidence.description#<br/><br/><br/>
			
			Recibirá información sobre la incidencia comunicada a través de su e-mail.<br/>
			Gracias por usar este servicio. 
			</cfoutput>		
		</cfsavecontent>
		
		<cfinvoke component="UserManager" method="getUser" returnvariable="objectUser">
			<cfinvokeargument name="get_user_id" value="#objectIncidence.user_in_charge#">
			<cfinvokeargument name="format_content" value="default">
			<cfinvokeargument name="return_type" value="object">
		</cfinvoke>
		
		<cfsavecontent variable="html_text_admin">
			<cfoutput>
			Incidencia registrada:<br/><br/>
			Cliente: <strong>#client_abb#</strong><br/>
			Usuario: <strong>#objectUser.family_name# #objectUser.name# (#objectUser.email#)</strong><br/>	
			ID de incidencia: <strong>#client_abb##objectIncidence.id#</strong><br/>
			Fecha de registro: <strong>#objectIncidence.creation_date_formatted#</strong><br/>
			Tipo: <strong>#objectIncidence.title_es#</strong><br/>
			Referente a: <strong>#objectIncidence.related_to#</strong><br/>
			Asunto: <strong>#objectIncidence.title#</strong><br/>
			Descripción detallada: <br/> #objectIncidence.description#
			</cfoutput>		
		</cfsavecontent>
		
		<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">#langText[curLang].common.foot_content_default_3# #APPLICATION.title#.</p>'>
		
		<cfinvoke component="EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="#SESSION.client_email_from#">
			<cfinvokeargument name="to" value="#objectUser.email#">
			<cfinvokeargument name="subject" value="#subject#">
			<cfinvokeargument name="content" value="#html_text#">
			<cfinvokeargument name="foot_content" value="#foot_content#">
		</cfinvoke>
		
		<cfinvoke component="EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="#SESSION.client_email_from#">
			<cfinvokeargument name="to" value="#APPLICATION.emailFail#">
			<cfinvokeargument name="subject" value="#subject#">
			<cfinvokeargument name="content" value="#html_text_admin#">
			<cfinvokeargument name="foot_content" value="#foot_content#">
		</cfinvoke>
		
		
	</cffunction>
	
	
	
	
	<!--- -------------------------------------- getApplicationAccess ------------------------------------ --->
	
	<cffunction name="getApplicationAccess" access="public" returntype="string">
		<cfargument name="client_id" type="string" required="true">
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="curLang" type="string" required="true"/>
				
		<cfset var method = "getApplicationAccess">
		
		<cfset var access_default = "">
		<cfset var access_content = "">
		<cfset var accessClient = "">
		
		<cfif APPLICATION.twoUrlsToAccess IS false>
		
			<cfset access_default = '#langText[curLang].common.access_to_application#: '>

			<cfif arguments.client_abb EQ "hcs">
				<cfset accessClient = "doplanning">
			<cfelse>
				<cfset accessClient = arguments.client_id>
			</cfif>
			
			<cfset access_content = '#access_default#<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#accessClient#">#APPLICATION.mainUrl##APPLICATION.path#/#accessClient#</a>'>	
			
		<cfelse>
			
			<cfsavecontent variable="access_content">
			<cfoutput>
			<!---<br/><br/>--->#langText[curLang].common.access_to_application_links#:<br/>
			-&nbsp;#langText[curLang].common.access_internal# <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/">#APPLICATION.mainUrl##APPLICATION.path#/</a><br/>
			-&nbsp;#langText[curLang].common.access_external# <a target="_blank" href="#APPLICATION.alternateUrl#">#APPLICATION.alternateUrl#</a>
			</cfoutput>
			</cfsavecontent>	
		
		</cfif>
	
		<cfreturn access_content>
		
	</cffunction>
	
	
	<!--- -------------------------------------- getLastAlertMessage ------------------------------------ --->
	
	<cffunction name="getLastAlertMessage" returntype="string" access="public">
		
		<cfset var method = "getLastAlertMessage">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfquery datasource="#APPLICATION.dsn#" name="APP_alert_messages">
				SELECT * 
				FROM APP_alert_messages 
				WHERE expiration_date > NOW();
			</cfquery>
			
			<cfquery datasource="#client_dsn#" name="alert_messages">
				SELECT * 
				FROM #client_abb#_alert_messages 
				WHERE expiration_date > NOW();
			</cfquery>
			
			<cfquery dbtype="query" name="getAlertMessage">
				SELECT * FROM APP_alert_messages
				UNION ALL
				SELECT * FROM alert_messages;	
			</cfquery>
			
			
			<cfif getAlertMessage.recordCount GT 0>
				<cfset alert_message = getAlertMessage.content>
			<cfelse>
				<cfset alert_message = "">
			</cfif>
			
			<cfset xmlResponseContent = "<alert_message><![CDATA[#alert_message#]]></alert_message>">
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- -------------------------------------- getLastAlertMessageAdmin ------------------------------------ --->
	
	<cffunction name="getLastAlertMessageAdmin" returntype="string" access="public">
		
		<cfset var method = "getLastAlertMessageAdmin">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			
			<cfset xmlResponseContent = "<alert_message><![CDATA[<b>Hola, este es el mensaje de #APPLICATION.title# para el administrador</b>]]></alert_message>">
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
</cfcomponent>
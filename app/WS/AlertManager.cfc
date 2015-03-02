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
	
	<!---<cfset foot_content_default = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">Este es un email automático enviado por la aplicación #APPLICATION.title#.<br /> No responda a este email.<br /> Si no desea recibir estos emails, puede desactivarlos accediendo al área "Preferencias" de la aplicación.</p>'>
	<cfset terms_of_use_default = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">El uso de #APPLICATION.title# implica la aceptación de los <a href="#APPLICATION.termsOfUseUrl#">términos de uso</a> por parte del usuario.</p>'>--->
	
	<cfinclude template="includes/loadLangText.cfm">
	
	<!--- -------------------------------------- newAreaItem ----------------------------------- --->
	
	<cffunction name="newAreaItem" access="public" returntype="void">
		<cfargument name="objectItem" type="struct" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="action" type="string" required="yes">
		<cfargument name="send_sms" type="boolean" required="no" default="false">
			
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
		<cfset var fromName = "">
		
		<cfset var includeItemContent = true>
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
		<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">
		
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
			
			
		<!---itemUrl--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaItemUrl" returnvariable="areaItemUrl">
			<cfinvokeargument name="item_id" value="#objectItem.id#">
			<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
			<cfinvokeargument name="area_id" value="#objectItem.area_id#">

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>
		
		<!---fileDownloadUrl--->
		<cfif isNumeric(objectItem.attached_file_id) AND objectItem.attached_file_id GT 0>
			<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getDownloadFileUrl" returnvariable="downloadFileUrl">
				<cfinvokeargument name="file_id" value="#objectItem.attached_file_id#">
				<cfinvokeargument name="item_id" value="#objectItem.id#">
				<cfinvokeargument name="itemTypeName" value="#itemTypeName#">

				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			</cfinvoke>
		</cfif>
		
		<!---imageDownloadUrl--->
		<cfif isNumeric(objectItem.attached_image_id) AND objectItem.attached_image_id GT 0>
			<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getDownloadFileUrl" returnvariable="downloadImageUrl">
				<cfinvokeargument name="file_id" value="#objectItem.attached_image_id#">
				<cfinvokeargument name="item_id" value="#objectItem.id#">
				<cfinvokeargument name="itemTypeName" value="#itemTypeName#">

				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			</cfinvoke>			
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
				
					<cfif APPLICATION.twoUrlsToAccess IS false>
					
						<cfsavecontent variable="access_content">
						<cfoutput>
						<cfif itemTypeId EQ 1 OR itemTypeId EQ 7><!--- Messages or Interconsultations --->
							-&nbsp;<strong>#langText[curLang].new_item.access_to_reply#</strong> <a target="_blank" href="#areaItemUrl#">#areaItemUrl#</a>
						<cfelse>
							-&nbsp;<cfif itemTypeGender EQ "male">#langText[curLang].new_item.access_to_item_male#<cfelse>#langText[curLang].new_item.access_to_item_female#</cfif> #langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.access_to_item_link#: <a target="_blank" href="#areaItemUrl#">#areaItemUrl#</a>
						</cfif>					

						
						<br/>-&nbsp;#langText[curLang].common.access_to_application#:
						<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#">#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#</a>
						
						</cfoutput>
						</cfsavecontent>
						
						
					<cfelse><!---VPNET/AGSNA--->
					
						<cfsavecontent variable="access_content">
						<cfoutput>
							<cfif itemTypeId EQ 1 OR itemTypeId EQ 7><!--- Messages or Interconsultations --->
								<strong>#langText[curLang].new_item.access_to_reply#</strong>:
							<cfelse>
								<cfif itemTypeGender EQ "male">#langText[curLang].new_item.access_to_item_male#
								<cfelse>#langText[curLang].new_item.access_to_item_female#</cfif> #langText[curLang].item[itemTypeId].name# #langText[curLang].new_item.access_to_item_links#:
							</cfif><br/>
						<!----&nbsp;Acceso interno <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#itemTypeName#.cfm?#itemTypeName#=#objectItem.id#&abb=#SESSION.client_abb#">#APPLICATION.mainUrl##APPLICATION.path#/#itemTypeName#.cfm?#itemTypeName#=#objectItem.id#&abb=#SESSION.client_abb#</a><br/>
						-&nbsp;Acceso externo <a target="_blank" href="#APPLICATION.alternateUrl##itemTypeName#.cfm?#itemTypeName#=#objectItem.id#&abb=#SESSION.client_abb#">#APPLICATION.alternateUrl##itemTypeName#.cfm?#itemTypeName#=#objectItem.id#&abb=#SESSION.client_abb#</a>--->
						-&nbsp;#langText[curLang].common.access_internal# <a target="_blank" href="#areaItemUrl#">#areaItemUrl#</a><br/>
						-&nbsp;#langText[curLang].common.access_external#  <a target="_blank" href="#APPLICATION.alternateUrl#/?area=#objectItem.area_id#&#itemTypeName#=#objectItem.id#&abb=#SESSION.client_abb#">#APPLICATION.alternateUrl#/?area=#objectItem.area_id#&#itemTypeName#=#objectItem.id#&abb=#SESSION.client_abb#</a>
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
					
				</cfif>
				
				<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;"><span style="color:##FF0000; font-size:12px;">#langText[curLang].common.foot_do_not_reply#.</span><br/>#langText[curLang].common.foot_content_default_1# #APPLICATION.title# #langText[curLang].new_item.foot_content_2# #APPLICATION.title#.<br />#langText[curLang].new_item.foot_content_3#.</p>'>			
				
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
					
				</cfswitch>
				
				
				<cfset sms_message = "#uCase(action_name)#:#objectItem.title#. AREA:#area_name#">
				
				<cfif len(sms_message) GT 160>
					<cfset sms_message = left(sms_message, 160)>
				</cfif>
							
				
				<!---CONTENIDO DEL EMAIL--->
				<cfif includeItemContent IS true>
				
					<cfsavecontent variable="alertContent">
						<cfoutput>
						<cfif itemTypeId IS 1>#langText[curLang].new_item.subject#<cfelse>#langText[curLang].new_item.title#</cfif>: <strong style="font-size:14px;">#objectItem.title#</strong><br/>			
						#langText[curLang].new_item.user#: <b>#objectItem.user_full_name#</b><br/>		
						<cfif itemTypeId IS 6><!---Tasks--->
						#langText[curLang].new_item.assigned_to#: <b>#objectItem.recipient_user_full_name#</b><br/>
						</cfif>
						#langText[curLang].new_item.creation_date#: <strong>#objectItem.creation_date#</strong><br/>
						<cfif itemTypeId IS NOT 1 AND len(objectItem.last_update_date) GT 0>
						#langText[curLang].new_item.last_update_date#: <strong>#objectItem.last_update_date#</strong><br/>
						</cfif>
					
						<cfif len(objectItem.link) GT 0>
						<cfif itemTypeId IS 3><!---Links--->
						#langText[curLang].new_item.link_url#: 
						<cfelse>
						#langText[curLang].new_item.link#: </cfif><a href="#objectItem.link#" target="_blank" style="font-weight:bold;">#objectItem.link#</a><br/>
						</cfif>
						<cfif len(objectItem.iframe_url) GT 0>
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
						<cfif isNumeric(objectItem.attached_file_id) AND objectItem.attached_file_id GT 0>
							<cfif arguments.action NEQ "delete">
							#langText[curLang].new_item.attached_file#: <a href="#downloadFileUrl#" target="_blank">#objectItem.attached_file_name#</a><br/>
							<cfelse>
							#langText[curLang].new_item.attached_file#: #objectItem.attached_file_name#<br/>
							</cfif>
						</cfif>
						<cfif isNumeric(objectItem.attached_image_id) AND objectItem.attached_image_id GT 0>
							<cfif arguments.action NEQ "delete">
							#langText[curLang].new_item.attached_image#: <a href="#downloadImageUrl#" target="_blank">#objectItem.attached_image_name#</a><br/>
							<cfelse>
							#langText[curLang].new_item.attached_image#: #objectItem.attached_image_name#<br/>
							</cfif>
						</cfif>
						
						<br/>
						<div style="padding-left:15px;">#objectItem.description#</div>
						
						<cfif len(objectItem.link) GT 0 AND (itemTypeId IS 4 OR itemTypeId IS 5)><!---Links, News, Events--->
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
				<cfif action NEQ "delete">
					<cfif itemTypeId IS NOT 6>
						<cfset fromName = objectItem.user_full_name>
					<cfelse><!---Tasks--->
						<cfif user_id IS objectItem.recipient_user AND objectItem.recipient_user NEQ objectItem.user_in_charge>
							<cfset fromName = objectItem.recipient_user_full_name>
						<cfelse>
							<cfset fromName = objectItem.user_full_name>
						</cfif>
					</cfif>
				</cfif>

				<!---INTERNAL USERS--->
				<cfif len(listInternalUsers) GT 0>
				
					<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
						<cfinvokeargument name="area_id" value="#objectItem.area_id#">
					</cfinvoke>
					
					<cfset subjectInternal = subject>
				
					<cfsavecontent variable="contentInternal">
					<cfoutput>
			<!--- #action_name# #langText[curLang].common.on_the_area# --->#langText[curLang].common.area#: <b>#area_name#</b>.<br/>
			#langText[curLang].common.area_path#: #area_path#<br/><br/>
			
			#alertContent#
					</cfoutput>		
					</cfsavecontent>

					<cfinvoke component="EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#SESSION.client_email_from#">
						<cfif len(fromName) GT 0>
							<cfinvokeargument name="from_name" value="#fromName#">
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
			#action_name# #langText[curLang].common.on_the_area# <b>#area_name#</b> #langText[curLang].common.of_the_organization# #root_area.name#.<br/><br/>
			
			#alertContent#
					</cfoutput>		
					</cfsavecontent>
					
					
					<cfinvoke component="EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#SESSION.client_email_from#">
						<cfif len(fromName) GT 0>
							<cfinvokeargument name="from_name" value="#fromName#">
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
					
						<cfinvoke component="SMSManager" method="sendSMSNew">
							<cfinvokeargument name="text" value="#sms_message#">
							<cfinvokeargument name="recipients" value="#listExternalUsersPhones#">
						</cfinvoke>
										
					</cfif>
					
				</cfif>
			
			</cfif><!---END len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0--->
			
	
		</cfloop><!---END APPLICATION.languages loop--->

		
	</cffunction>
	
	
	
	
	<!--- -------------------------------------- newFile ------------------------------------ --->
	<!---new/replace file--->
	<cffunction name="newFile" access="public" returntype="void">
		<cfargument name="objectFile" type="struct" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="action" type="string" required="yes">
				
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
		<cfset var alertContent = "">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
		<!---Get area name--->
		<cfquery name="selectAreaQuery" datasource="#client_dsn#">
			SELECT id, name 
			FROM #client_abb#_areas
			WHERE id = #arguments.area_id#
		</cfquery>
		
		<cfif selectAreaQuery.recordCount GT 0>
		
			<cfset area_name = selectAreaQuery.name>
			
		<cfelse><!---The area does not exist--->
			
			<cfset error_code = 301>
			
			<cfthrow errorcode="#error_code#">
		
		</cfif>
		
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaFileUrl" returnvariable="areaFileUrl">
			<cfinvokeargument name="file_id" value="#objectFile.id#">
			<cfinvokeargument name="area_id" value="#arguments.area_id#">

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>
		
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getDownloadFileUrl" returnvariable="downloadFileUrl">
			<cfinvokeargument name="file_id" value="#objectFile.id#">

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>
		
		<cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
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
				<cfif arguments.action EQ "associate">
					notify_new_file="true"				
				<cfelse>
					notify_replace_file="true"
				</cfif>>				
				</preferences>
			</cfoutput>
		</cfsavecontent>
		
		<cfinvoke component="RequestManager" method="createRequest" returnvariable="getUsersRequest">
			<cfinvokeargument name="request_parameters" value="#getUsersParameters#">
		</cfinvoke>
        
        <cfinvoke component="UserManager" method="getUsersToNotifyLists" returnvariable="usersToNotifyLists">
			<cfinvokeargument name="request" value="#getUsersRequest#"/>
		</cfinvoke>
        
        <!---<cfset listInternalUsers = usersToNotifyLists.listInternalUsers>
        <cfset listExternalUsers = usersToNotifyLists.listExternalUsers>--->
		
		<cfset internalUsersEmails = usersToNotifyLists.structInternalUsersEmails>
		<cfset externalUsersEmails = usersToNotifyLists.structExternalUsersEmails>

		<cfloop list="#APPLICATION.languages#" index="curLang">
		
			<cfset listInternalUsers = internalUsersEmails[curLang]>
			<cfset listExternalUsers = externalUsersEmails[curLang]>
		
			<cfif len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0><!---Si hay usuarios a los que notificar--->
								
				<!--- <cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">'&langText[curLang].common.foot_content_default_1&' #APPLICATION.title#.<br />'&langText[curLang].common.foot_content_default_2&'</p>'> --->

				<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;"><span style="color:##FF0000; font-size:12px;">#langText[curLang].common.foot_do_not_reply#.</span><br/>#langText[curLang].common.foot_content_default_1# #APPLICATION.title# #langText[curLang].new_item.foot_content_2# #APPLICATION.title#.<br />#langText[curLang].new_item.foot_content_3#.</p>'>
				
				
				<cfif APPLICATION.twoUrlsToAccess IS false>
				
					<cfsavecontent variable="access_content">
					<cfoutput>
					-&nbsp;#langText[curLang].new_file.access_to_file#:
					<a target="_blank" href="#areaFileUrl#">#areaFileUrl#</a>
					
					<br/>-&nbsp;#langText[curLang].new_file.access_to_download_file#:
					<a target="_blank" href="#downloadFileUrl#">#downloadFileUrl#</a>
					
					<br/>-&nbsp;#langText[curLang].common.access_to_application#:
					<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#">#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#</a>
					</cfoutput>
					</cfsavecontent>
					
					
				<cfelse>
				
					<cfsavecontent variable="access_content">
					<cfoutput>
					#langText[curLang].new_file.access_to_file_links#: <br/>
					-&nbsp;#langText[curLang].common.access_internal# <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/?area=#arguments.area_id#&file=#objectFile.id#&abb=#SESSION.client_abb#">#APPLICATION.mainUrl##APPLICATION.path#/?area=#arguments.area_id#&file=#objectFile.id#&abb=#SESSION.client_abb#</a><br/>
					-&nbsp;#langText[curLang].common.access_external# <a target="_blank" href="#APPLICATION.alternateUrl#/?area=#arguments.area_id#&file=#objectFile.id#&abb=#SESSION.client_abb#">#APPLICATION.alternateUrl#/?area=#arguments.area_id#&file=#objectFile.id#&abb=#SESSION.client_abb#</a>
					</cfoutput>
					</cfsavecontent>
					
				</cfif>
				
				<cfif arguments.action EQ "associate">
					
					<cfset subject = "[#root_area.name#][#langText[curLang].new_file.file#] "&objectFile.name>
					<cfset action_value = langText[curLang].new_file.added>	
				<cfelse>
					
					<cfset subject = "[#root_area.name#][#langText[curLang].new_file.replaced_file#] "&objectFile.name>
					<cfset action_value = langText[curLang].new_file.replaced>
				</cfif>
				
				<cfsavecontent variable="alertContent">
					<cfoutput>
					#langText[curLang].new_file.file_name#: <strong>#objectFile.name#</strong><br />
					#langText[curLang].new_file.user#: <strong>#objectFile.user_full_name#</strong><br />
					<cfif arguments.action EQ "associate">
					#langText[curLang].new_file.upload_date#: <strong>#objectFile.uploading_date#</strong><br/>
					<cfelse>
					#langText[curLang].new_file.replacement_date#: <strong>#objectFile.replacement_date#</strong><br/>
					</cfif>
					#langText[curLang].new_file.description#:<br/><br/>
					<div style="padding-left:15px;">#objectFile.description#</div>
					<br/>
					<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>
					</cfoutput>
				</cfsavecontent>
				
				<!---INTERNAL USERS--->
				<cfif len(listInternalUsers) GT 0>
					
					<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
						<cfinvokeargument name="area_id" value="#arguments.area_id#">
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
				
					<cfinvoke component="EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#SESSION.client_email_from#">
						<cfinvokeargument name="from_name" value="#objectFile.user_full_name#">
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
				
					<cfinvoke component="EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#SESSION.client_email_from#">
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
	
	
	
	<!--- -------------------------------------- replaceFile ------------------------------------ --->
	
	<cffunction name="replaceFile" access="remote" returntype="void">
		<cfargument name="objectFile" type="struct" required="yes">
				
		<cfset var method = "replaceFile">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
		<cfquery datasource="#client_dsn#" name="getFileAreas">
			SELECT *
			FROM #client_abb#_areas_files
			WHERE file_id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif getFileAreas.RecordCount GT 0>
			<cfloop query="getFileAreas">
				
				<cfinvoke component="AlertManager" method="newFile">
					<cfinvokeargument name="objectFile" value="#arguments.objectFile#">
					<cfinvokeargument name="area_id" value="#getFileAreas.area_id#">
					<cfinvokeargument name="action" value="replace">
				</cfinvoke>	
				
			</cfloop>
		</cfif>
						
		
	</cffunction>
	
	
    <!--- -------------------------------------- newArea ------------------------------------ --->
	
	<cffunction name="newArea" access="public" returntype="void">
		<cfargument name="objectArea" type="struct" required="yes">
				
		<cfset var method = "newArea">
		
		<cfset var internalUsersEmails = "">
		<cfset var externalUsersEmails = "">
		<cfset var listInternalUsers = "">
		<cfset var listExternalUsers = "">
        
        <cfset var root_area = structNew()>
		<cfset var foot_content = "">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
		<!---areaUrl--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaUrl" returnvariable="areaUrl">
			<cfinvokeargument name="area_id" value="#objectArea.id#">
			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>
		
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
        
        <!---<cfset listInternalUsers = usersToNotifyLists.listInternalUsers>
        <cfset listExternalUsers = usersToNotifyLists.listExternalUsers>--->
		
		<cfset internalUsersEmails = usersToNotifyLists.structInternalUsersEmails>
		<cfset externalUsersEmails = usersToNotifyLists.structExternalUsersEmails>

		<cfloop list="#APPLICATION.languages#" index="curLang">
		
			<cfset listInternalUsers = internalUsersEmails[curLang]>
			<cfset listExternalUsers = externalUsersEmails[curLang]>
        
			<cfif len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0><!---Si hay usuarios a los que notificar--->
								
				<cfif APPLICATION.twoUrlsToAccess IS false>
				
					<cfsavecontent variable="access_content">
					<cfoutput>
					-&nbsp;#langText[curLang].common.access_to_area#:
					<a target="_blank" href="#areaUrl#">#areaUrl#</a>
			
					<br/>-&nbsp;#langText[curLang].common.access_to_application#:
					<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#">#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#</a>
					</cfoutput>
					</cfsavecontent>
					
					
				<cfelse>
				
					<cfsavecontent variable="access_content">
					<cfoutput>
					#langText[curLang].common.access_to_area_links#: <br/>
					-&nbsp;#langText[curLang].common.access_internal# <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/?area=#objectArea.id#&abb=#SESSION.client_abb#">#APPLICATION.mainUrl##APPLICATION.path#/?area=#objectArea.id#&abb=#SESSION.client_abb#</a><br/>
					-&nbsp;#langText[curLang].common.access_external# <a target="_blank" href="#APPLICATION.alternateUrl#/?area=#objectArea.id#&abb=#SESSION.client_abb#">#APPLICATION.alternateUrl#/?area=#objectArea.id#&abb=#SESSION.client_abb#</a>
					</cfoutput>
					</cfsavecontent>
					
				</cfif>
				
				
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
    
	
	<!--- -------------------------------------- assignUserToArea ------------------------------------ --->
	
	<cffunction name="assignUserToArea" access="public" returntype="void">
		<cfargument name="objectUser" type="struct" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="new_area" type="boolean" required="no" default="false">
				
		<cfset var method = "assignUserToArea">
        
        <cfset var root_area = structNew()>
        <cfset var curLang = "">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
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
				
				
		<!---areaUrl--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaUrl" returnvariable="areaUrl">
			<cfinvokeargument name="area_id" value="#area_id#">
			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>
		
		<cfif APPLICATION.twoUrlsToAccess IS false>
		
			<cfsavecontent variable="access_content">
			<cfoutput>
			-&nbsp;#langText[curLang].common.access_to_area#:
			<a target="_blank" href="#areaUrl#">#areaUrl#</a>
	
			<br/>-&nbsp;#langText[curLang].common.access_to_application#:
			<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#">#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#</a>
			</cfoutput>
			</cfsavecontent>
			
			
		<cfelse>
		
			<cfsavecontent variable="access_content">
			<cfoutput>
			#langText[curLang].common.access_to_area_links#: <br/>
			-&nbsp;#langText[curLang].common.access_internal# <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/?area=#area_id#&abb=#SESSION.client_abb#">#APPLICATION.mainUrl##APPLICATION.path#/?area=#area_id#&abb=#SESSION.client_abb#</a><br/>
			-&nbsp;#langText[curLang].common.access_external# <a target="_blank" href="#APPLICATION.alternateUrl#/?area=#area_id#&abb=#SESSION.client_abb#">#APPLICATION.alternateUrl#/?area=#area_id#&abb=#SESSION.client_abb#</a>
			</cfoutput>
			</cfsavecontent>
			
		</cfif>
		
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
		
		
		
	</cffunction>
	
	
	
	<!--- -------------------------------------- newUser ------------------------------------ --->
	
	<cffunction name="newUser" access="public" returntype="void">
		<cfargument name="objectUser" type="struct" required="yes">
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
		
		
	</cffunction>	
	
	
	
	
	<!--- -------------------------------------- generateNewPassword ------------------------------------ --->
	
	<cffunction name="generateNewPassword" access="public" returntype="void">
		<cfargument name="user_full_name" type="string" required="true">
		<cfargument name="user_email" type="string" required="true">
		<cfargument name="user_password" type="string" required="true">
		<cfargument name="user_language" type="string" required="true"/>
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">
				
		<cfset var method = "newUser">
        
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
		
		<cfif APPLICATION.twoUrlsToAccess IS false>
		
			<cfset access_default = '#langText[curLang].common.access_to_application#: '>
			
			<cfset access_content = '#access_default#<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#arguments.client_id#">#APPLICATION.mainUrl##APPLICATION.path#/#arguments.client_id#</a>'>	
			
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
	
	<cffunction name="getLastAlertMessage" returntype="string" access="remote">
		
		<cfset var method = "getLastAlertMessage">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfquery datasource="#APPLICATION.dsn#" name="app_alert_messages">
				SELECT * 
				FROM app_alert_messages 
				WHERE expiration_date > NOW();
			</cfquery>
			
			<cfquery datasource="#client_dsn#" name="alert_messages">
				SELECT * 
				FROM #client_abb#_alert_messages 
				WHERE expiration_date > NOW();
			</cfquery>
			
			<cfquery dbtype="query" name="getAlertMessage">
				SELECT * FROM app_alert_messages
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
	
	<cffunction name="getLastAlertMessageAdmin" returntype="string" access="remote">
		
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
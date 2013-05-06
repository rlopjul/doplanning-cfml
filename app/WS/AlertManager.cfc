<!---Copyright Era7 Information Technologies 2007-2013

	Date of file creation: 03-04-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 17-01-2013
	
	05-07-2012 alucena: modificado newAreaItem para que se notifique según las preferencias de alertas de los nuevos elementos (enlaces, entradas, noticias y eventos)
	06-09-2012 alucena: quitado DateFormat de la fecha de inicio de los eventos newAreaItem, ya que aparecía el mes cambiado por el día, porque la fecha que viene no es un objeto de Coldfusion, sino un String
	26-09-2012 alucena: añadida comprobación de tamaño de lista de destinatarios al enviar por email en newAreaItem
	17-01-2013 alucena: cambiada la url de los elementos, quitado /html/
	22-04-2013 alucena: cambiado client_id por client_abb en las URLs con abb=
	
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
		
        <cfset var listInternalUsersEs = "">
		<cfset var listInternalUsersEn = "">
		<cfset var listExternalUsersEs = "">
		<cfset var listExternalUsersEn = "">
		
		<cfset var listInternalUsersPhones = "">
		<cfset var listExternalUsersPhones = "">
		
		<cfset var subject = "">		
		<cfset var area_name = "">
		<cfset var area_path = "">
        <cfset var root_area = structNew()>
		<cfset var access_content = "">
		<cfset var sms_message = "">
		
		<cfset var includeItemContent = true>
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
		<cfinclude template="includes/areaItemTypeSwitch.cfm">
		
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
        
        <cfinvoke component="UserManager" method="getUsersToNotifyLists" returnvariable="usersToNotifyLists">
			<cfinvokeargument name="request" value="#getUsersRequest#"/>
		</cfinvoke>
        
        <cfset listInternalUsers = usersToNotifyLists.listInternalUsers>
        <cfset listExternalUsers = usersToNotifyLists.listExternalUsers>
		
		<cfset listInternalUsersEs = usersToNotifyLists.listInternalUsers>
        <cfset listExternalUsersEn = usersToNotifyLists.listExternalUsers>
		
		<cfset listInternalUsersPhones = usersToNotifyLists.listInternalUsersPhones>
		<cfset listExternalUsersPhones = usersToNotifyLists.listExternalUsersPhones>
		
		<cfif len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0><!---Si hay usuarios a los que notificar--->
		
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
			
			<!---HAY QUE AGREGAR LOS IDIOMAS A ESTA PARTE PARA QUE LOS EMAILS PUEDAN ESTAR EN VARIOS IDIOMAS--->
			
			<!---itemUrl--->
			<cfinvoke component="#APPLICATION.componentsPath#/components/UrlManager" method="getAreaItemUrl" returnvariable="areaItemUrl">
				<cfinvokeargument name="item_id" value="#objectItem.id#">
				<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
				<cfinvokeargument name="area_id" value="#objectItem.area_id#">
			</cfinvoke>
			
			<!---fileDownloadUrl--->
			<cfif isNumeric(objectItem.attached_file_id) AND objectItem.attached_file_id GT 0>
				<cfinvoke component="#APPLICATION.componentsPath#/components/UrlManager" method="getDownloadFileUrl" returnvariable="downloadFileUrl">
					<cfinvokeargument name="file_id" value="#objectItem.attached_file_id#">
					<cfinvokeargument name="item_id" value="#objectItem.id#">
					<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
				</cfinvoke>
			</cfif>
			
			<!---imageDownloadUrl--->
			<cfif isNumeric(objectItem.attached_image_id) AND objectItem.attached_image_id GT 0>
				<cfinvoke component="#APPLICATION.componentsPath#/components/UrlManager" method="getDownloadFileUrl" returnvariable="downloadImageUrl">
					<cfinvokeargument name="file_id" value="#objectItem.attached_image_id#">
					<cfinvokeargument name="item_id" value="#objectItem.id#">
					<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
				</cfinvoke>			
			</cfif>
			
			
			<cfif arguments.action NEQ "delete"><!---Si el elemento no se elimina--->
			
				<cfif APPLICATION.identifier EQ "dp"><!---DP--->
				
					<cfsavecontent variable="access_content">
					<cfoutput>
					-&nbsp;<cfif itemTypeGender EQ "male">#langText.es.new_item.access_to_item_male#<cfelse>#langText.new_item.access_to_item_female#</cfif> #itemTypeNameEs# #langText.es.new_item.access_to_item_link# <a target="_blank" href="#areaItemUrl#">#areaItemUrl#</a>
					
					<br/>-&nbsp;#langText.es.new_item.access_to_application#
					<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#">#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#</a>
					</cfoutput>
					</cfsavecontent>
					
					
				<cfelseif APPLICATION.identifier EQ "vpnet">
				
					<cfsavecontent variable="access_content">
					<cfoutput><cfif itemTypeGender EQ "male">#langText.es.new_item.access_to_item_male#<cfelse>#langText.new_item.access_to_item_female#</cfif> #itemTypeNameEs# #langText.es.new_item.access_to_item_links#<br/>
					<!----&nbsp;Acceso interno <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#itemTypeName#.cfm?#itemTypeName#=#objectItem.id#&abb=#SESSION.client_abb#">#APPLICATION.mainUrl##APPLICATION.path#/#itemTypeName#.cfm?#itemTypeName#=#objectItem.id#&abb=#SESSION.client_abb#</a><br/>
					-&nbsp;Acceso externo <a target="_blank" href="#APPLICATION.alternateUrl##itemTypeName#.cfm?#itemTypeName#=#objectItem.id#&abb=#SESSION.client_abb#">#APPLICATION.alternateUrl##itemTypeName#.cfm?#itemTypeName#=#objectItem.id#&abb=#SESSION.client_abb#</a>--->
					-&nbsp;#langText.es.new_item.access_internal# <a target="_blank" href="#areaItemUrl#">#areaItemUrl#</a><br/>
					-&nbsp;#langText.es.new_item.access_external#  <a target="_blank" href="#APPLICATION.alternateUrl#/?area=#objectItem.area_id#&#itemTypeName#=#objectItem.id#&abb=#SESSION.client_abb#">#APPLICATION.alternateUrl#/?area=#objectItem.area_id#&#itemTypeName#=#objectItem.id#&abb=#SESSION.client_abb#</a>
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
			
			<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">'&langText.es.new_item.foot_content_1&' #APPLICATION.title# '&langText.es.new_item.foot_content_2&' #APPLICATION.title#.<br /> '&langText.es.new_item.foot_content_3&'</p>'>			
			
            <cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
            </cfinvoke>
            <!---EN EL ASUNTO SE PONE EL NOMBRE DEL ÁREA RAIZ--->
			
			<cfswitch expression="#arguments.action#">
				
				<cfcase value="new"><!---Nuevo--->
				
					<cfif arguments.itemTypeId IS NOT 7 OR objectItem.parent_kind EQ "area">
						<cfif itemTypeGender EQ "male">
							<cfset action_name = "#langText.es.new_item.new_male# #itemTypeNameEs#">
						<cfelse>
							<cfset action_name = "#langText.es.new_item.new_female# #itemTypeNameEs#">
						</cfif>
						<cfset subject = "[#root_area.name#][#itemTypeNameEs#] #objectItem.title#">
					<cfelse><!---Respuesta a consulta--->
						
						<cfset action_name = "#langText.es.new_item.answer_to# #itemTypeNameEs#">
						<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">
						
					</cfif>
				
				</cfcase>
				
				<cfcase value="delete"><!---Eliminado--->
				
					<cfif itemTypeGender EQ "male">
						<cfset action_name = "#itemTypeNameEs# eliminado">
					<cfelse>
						<cfset action_name = "#itemTypeNameEs# eliminada">
					</cfif>
					
					<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">

				</cfcase>
				
				<cfcase value="update"><!---Modificado--->
				
					<cfif itemTypeGender EQ "male">
						<cfset action_name = "#itemTypeNameEs# modificado">
					<cfelse>
						<cfset action_name = "#itemTypeNameEs# modificada">
					</cfif>
					
					<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">
				
				</cfcase>
				
				<cfcase value="done"><!---Realizada (tarea)--->
					
					<cfset action_name = "#itemTypeNameEs# realizada">
					<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">
					
				</cfcase>				
				
				<cfcase value="close"><!---Cerrada (consulta)--->
				
					<cfset action_name = "#itemTypeNameEs# cerrada">
					<cfset subject = "[#root_area.name#][#action_name#] #objectItem.title#">				
				
				</cfcase>
				
			</cfswitch>
			
			<!---<cfif arguments.action EQ "new"><!---Nuevo--->
			<cfelseif arguments.action EQ "delete"><!---Eliminado--->
			<cfelse><!---Modificado--->
			</cfif>--->
			
			<cfset sms_message = "#uCase(action_name)#:#objectItem.title#. ÁREA:#area_name#">
			
			<cfif len(sms_message) GT 160>
				<cfset sms_message = left(sms_message, 160)>
			</cfif>
						
			
			<!---CONTENIDO DEL EMAIL--->
			<cfif includeItemContent IS true>
			
				<cfsavecontent variable="alertContent">
					<cfoutput>
					<cfif itemTypeId IS 1>Asunto<cfelse>Título</cfif>: <strong style="font-size:14px;">#objectItem.title#</strong><br/>			
					Usuario: <b>#objectItem.user_full_name#</b><br/>		
					<cfif itemTypeId IS 6><!---Tasks--->
					Asignada a: <b>#objectItem.recipient_user_full_name#</b><br/>
					</cfif>
					Fecha de creación: <strong>#objectItem.creation_date#</strong><br/>
					<cfif itemTypeId IS NOT 1 AND len(objectItem.last_update_date) GT 0>
					Fecha de última modificación: <strong>#objectItem.last_update_date#</strong><br/>
					</cfif>
					<!---<cfif objectItem.attached_file_name NEQ "NULL" AND objectItem.attached_file_name NEQ "">--->
					<cfif len(objectItem.link) GT 0>
					<cfif itemTypeId IS 3><!---Links--->
					URL del enlace: 
					<cfelse>
					Enlace: </cfif><a href="#objectItem.link#" target="_blank" style="font-weight:bold;">#objectItem.link#</a><br/>
					</cfif>
					<cfif len(objectItem.iframe_url) GT 0>
					URL del contenido incrustado: 
					<a href="#objectItem.iframe_url#" target="_blank" style="font-weight:bold;">#objectItem.iframe_url#</a><br/>
					</cfif>
					<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->
					Fecha de inicio<cfif itemTypeId IS 5> del evento</cfif>: <b>#objectItem.start_date#</b> <cfif itemTypeId IS 5>Hora: <b>#TimeFormat(objectItem.start_time,"HH:mm")#</b></cfif><br/>
					Fecha de fin<cfif itemTypeId IS 5> del evento</cfif>: <b>#objectItem.end_date#</b> <cfif itemTypeId IS 5>Hora: <b>#TimeFormat(objectItem.end_time,"HH:mm")#</b></cfif><br/>
						<cfif itemTypeId IS 5>
						Lugar: <b>#objectItem.place#</b><br/>
						<cfelse>
						Valor estimado: <b>#objectItem.estimated_value#</b><br/>
						Valor real: <b>#objectItem.real_value#</b><br/>
						Tarea realizada: <b><cfif objectItem.done IS true>Sí<cfelse>No</cfif></b><br/>
						</cfif>
					</cfif>	
					<cfif isNumeric(objectItem.attached_file_id) AND objectItem.attached_file_id GT 0>
						<cfif arguments.action NEQ "delete">
						Archivo adjunto: <a href="#downloadFileUrl#" target="_blank">#objectItem.attached_file_name#</a><br/>
						<cfelse>
						Archivo adjunto: #objectItem.attached_file_name#<br/>
						</cfif>
					</cfif>
					<cfif isNumeric(objectItem.attached_image_id) AND objectItem.attached_image_id GT 0>
						<cfif arguments.action NEQ "delete">
						Imagen adjunta: <a href="#downloadImageUrl#" target="_blank">#objectItem.attached_image_name#</a><br/>
						<cfelse>
						Imagen adjunta: #objectItem.attached_image_name#<br/>
						</cfif>
					</cfif>
					
					<br/>
					<div style="padding-left:15px;">#objectItem.description#</div><!---<br/>--->
					
					<cfif len(objectItem.link) GT 0 AND (itemTypeId IS 4 OR itemTypeId IS 5)><!---Links, News, Events--->
					<br/>Más información: <a href="#objectItem.link#" target="_blank">#objectItem.link#</a><br/>
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
						<strong style="font-size:14px;">Para ver el contenido <cfif itemTypeGender EQ "male">del<cfelse>de la</cfif> #lCase(itemTypeNameEs)# debe acceder a la aplicación:</strong><br/>
						
						<span style="color:##666666;">#access_content#</span>
					</div>
					</cfif>
					</cfoutput>
				</cfsavecontent>
				
			</cfif>
			
			
            
			<!---INTERNAL USERS--->
			<cfif len(listInternalUsers) GT 0>
			
				<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
					<cfinvokeargument name="area_id" value="#objectItem.area_id#">
				</cfinvoke>
				
                <cfset subjectInternal = subject>
			
				<cfsavecontent variable="contentInternal">
				<cfoutput>
		#action_name# en el área: <b>#area_name#</b>.<br/>
		Ruta del área: #area_path#<br/><br/>
		
		#alertContent#
				</cfoutput>		
				</cfsavecontent>
				
				<cfinvoke component="EmailManager" method="sendEmail">
					<cfinvokeargument name="from" value="#SESSION.client_email_from#">
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
				<cfif arguments.send_sms IS true>
				
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
		#action_name# en el área <b>#area_name#</b> de la organización #root_area.name#.<br/><br/>
		
		#alertContent#
				</cfoutput>		
				</cfsavecontent>
				
				
				<cfinvoke component="EmailManager" method="sendEmail">
					<cfinvokeargument name="from" value="#SESSION.client_email_from#">
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
				<cfif arguments.send_sms IS true>
				
					<cfinvoke component="SMSManager" method="sendSMSNew">
						<cfinvokeargument name="text" value="#sms_message#">
						<cfinvokeargument name="recipients" value="#listExternalUsersPhones#">
					</cfinvoke>
									
				</cfif>
				
			</cfif>
	
		</cfif>
		
	</cffunction>
	
	
	
	
	<!--- -------------------------------------- newFile ------------------------------------ --->
	<!---new/replace file--->
	<cffunction name="newFile" access="public" returntype="void">
		<cfargument name="objectFile" type="struct" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="action" type="string" required="yes">
				
		<cfset var method = "newFile">
		
        <cfset var listInternalUsers = "">
		<cfset var listExternalUsers = "">
		<cfset var area_name = "">
		<cfset var area_path = "">
        <cfset var root_area = structNew()>
		<cfset var access_content = "">
		<cfset var foot_content = "">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
		
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
        
        <cfset listInternalUsers = usersToNotifyLists.listInternalUsers>
        <cfset listExternalUsers = usersToNotifyLists.listExternalUsers>
		
		<cfif len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0><!---Si hay usuarios a los que notificar--->
		
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
			

			
			<!---HAY QUE AGREGAR LOS IDIOMAS A ESTA PARTE PARA QUE LOS EMAILS PUEDAN ESTAR EN VARIOS IDIOMAS--->
			
			<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">'&langText.es.common.foot_content_default_1&' #APPLICATION.title#.<br />'&langText.es.common.foot_content_default_2&'</p>'>
			
			 <cfinvoke component="#APPLICATION.componentsPath#/components/UrlManager" method="getAreaFileUrl" returnvariable="areaFileUrl">
				<cfinvokeargument name="file_id" value="#objectFile.id#">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>
			
			<cfinvoke component="#APPLICATION.componentsPath#/components/UrlManager" method="getDownloadFileUrl" returnvariable="downloadFileUrl">
				<cfinvokeargument name="file_id" value="#objectFile.id#">
			</cfinvoke>
			
			<cfif APPLICATION.identifier EQ "dp">
			
				<cfsavecontent variable="access_content">
				<cfoutput>
				-&nbsp;Acceda directamente al archivo mediante el siguiente enlace:
				<a target="_blank" href="#areaFileUrl#">#areaFileUrl#</a>
				
				<br/>-&nbsp;Descargue el archivo mediante el siguiente enlace:
				<a target="_blank" href="#downloadFileUrl#">#downloadFileUrl#</a>
				
				<br/>-&nbsp;Acceda a la aplicación en la siguiente dirección:
				<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#">#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#</a>
				</cfoutput>
				</cfsavecontent>
				
				
			<cfelseif APPLICATION.identifier EQ "vpnet">
			
				<cfsavecontent variable="access_content">
				<cfoutput>
				Acceda directamente al archivo mediante los siguientes enlaces: <br/>
				-&nbsp;Acceso interno <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/?area=#arguments.area_id#&file=#objectFile.id#&abb=#SESSION.client_abb#">#APPLICATION.mainUrl##APPLICATION.path#/?area=#arguments.area_id#&file=#objectFile.id#&abb=#SESSION.client_abb#</a><br/>
				-&nbsp;Acceso externo <a target="_blank" href="#APPLICATION.alternateUrl#/?area=#arguments.area_id#&file=#objectFile.id#&abb=#SESSION.client_abb#">#APPLICATION.alternateUrl#/?area=#arguments.area_id#&file=#objectFile.id#&abb=#SESSION.client_abb#</a>
				</cfoutput>
				</cfsavecontent>
				

			</cfif>
			
			
            <cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
            </cfinvoke>
            <!---En el asunto se pone el nombre del área raiz--->
            <cfif arguments.action EQ "associate">
				
				<cfset subject = "[#root_area.name#][Archivo] "&objectFile.name>
                <cfset action_value = "añadido">	
            <cfelse>
                
                <cfset subject = "[#root_area.name#][Archivo Reemplazado] "&objectFile.name>
                <cfset action_value = "reemplazado">
            </cfif>
			
			<!---INTERNAL USERS--->
			<cfif len(listInternalUsers) GT 0>
				
				<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>
				
				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="contentInternal">
				<cfoutput>
				<br/>
		Se ha #action_value# un archivo en el área <strong>#area_name#</strong>.<br/>
		Ruta del área: #area_path#.<br/><br/>
		Nombre del archivo: <strong>#objectFile.name#</strong><br />
		Usuario: <strong>#objectFile.user_full_name#</strong><br />
		<cfif arguments.action EQ "associate">
		Fecha de subida del archivo: <strong>#objectFile.uploading_date#</strong><br/>
		<cfelse>
		Fecha de reemplazo del archivo: <strong>#objectFile.replacement_date#</strong><br/>
		</cfif>
		Descripción:<br/><br/>
		<div style="padding-left:15px;">#objectFile.description#</div>
		<br/>
		<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>				
			
				<cfinvoke component="EmailManager" method="sendEmail">
					<cfinvokeargument name="from" value="#SESSION.client_email_from#">
					<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
					<cfinvokeargument name="bcc" value="#listInternalUsers#">
					<cfinvokeargument name="subject" value="#subject#">
					<cfinvokeargument name="content" value="#contentInternal#">
					<cfinvokeargument name="foot_content" value="#foot_content#">
				</cfinvoke>
				
			</cfif>
			
	
			<!---EXTERNAL USERS--->
			<cfif len(listExternalUsers) GT 0>
				
				<!---<cfif arguments.action EQ "associate">
					<cfset subject = "[#APPLICATION.title#][#SESSION.client_name#][Nuevo Archivo] "&objectFile.name>
					<cfset action_value = "añadido">	
				<cfelse>
					<cfset subject = "[#APPLICATION.title#][#SESSION.client_name#][Archivo Reemplazado] "&objectFile.name>
					<cfset action_value = "reemplazado">
				</cfif>--->
				
				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="contentExternal">
				<cfoutput>
				<br/>
		Se ha #action_value# un archivo en el área <strong>#area_name#</strong> de la organización #root_area.name#.<br/><br/>
		Nombre del archivo: <strong>#objectFile.name#</strong><br />
		Usuario: <strong>#objectFile.user_full_name#</strong><br />
		<cfif arguments.action EQ "associate">
		Fecha de subida del archivo: <strong>#objectFile.uploading_date#</strong><br/>
		<cfelse>
		Fecha de reemplazo del archivo: <strong>#objectFile.replacement_date#</strong><br/>
		</cfif>
		Descripción:<br/><br/>
		<div style="padding-left:15px;">#objectFile.description#</div>
		<br/>
		<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>				
			
				<cfinvoke component="EmailManager" method="sendEmail">
					<cfinvokeargument name="from" value="#SESSION.client_email_from#">
					<cfinvokeargument name="to" value="#APPLICATION.emailFalseTo#">
					<cfinvokeargument name="bcc" value="#listExternalUsers#">
					<cfinvokeargument name="subject" value="#subject#">
					<cfinvokeargument name="content" value="#contentExternal#">
					<cfinvokeargument name="foot_content" value="#foot_content#">
				</cfinvoke>		
					
			</cfif>
			
		</cfif>
		
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
        
        <cfset var root_area = structNew()>
		<cfset var foot_content = "">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
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
        
        <cfset listInternalUsers = usersToNotifyLists.listInternalUsers>
        <cfset listExternalUsers = usersToNotifyLists.listExternalUsers>
        
        <cfif len(listInternalUsers) GT 0 OR len(listExternalUsers) GT 0><!---Si hay usuarios a los que notificar--->
			
			<!---HAY QUE AGREGAR LOS IDIOMAS A ESTA PARTE PARA QUE LOS EMAILS PUEDAN ESTAR EN VARIOS IDIOMAS--->
			<!---<cfinvoke component="AlertManager" method="getApplicationAccess" returnvariable="access_content">
			</cfinvoke>--->
			
			<!---areaUrl--->
			<cfinvoke component="#APPLICATION.componentsPath#/components/UrlManager" method="getAreaUrl" returnvariable="areaUrl">
				<cfinvokeargument name="area_id" value="#objectArea.id#">
			</cfinvoke>
			
			<cfif APPLICATION.identifier EQ "dp">
			
				<cfsavecontent variable="access_content">
				<cfoutput>
				-&nbsp;Acceda directamente al área mediante el siguiente enlace:
				<a target="_blank" href="#areaUrl#">#areaUrl#</a>
		
				<br/>-&nbsp;Acceda a la aplicación en la siguiente dirección:
				<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#">#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#</a>
				</cfoutput>
				</cfsavecontent>
				
				
			<cfelseif APPLICATION.identifier EQ "vpnet">
			
				<cfsavecontent variable="access_content">
				<cfoutput>
				Acceda directamente al área mediante los siguientes enlaces: <br/>
				-&nbsp;Acceso interno <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/?area=#objectArea.id#&abb=#SESSION.client_abb#">#APPLICATION.mainUrl##APPLICATION.path#/?area=#objectArea.id#&abb=#SESSION.client_abb#</a><br/>
				-&nbsp;Acceso externo <a target="_blank" href="#APPLICATION.alternateUrl#/?area=#objectArea.id#&abb=#SESSION.client_abb#">#APPLICATION.alternateUrl#/?area=#objectArea.id#&abb=#SESSION.client_abb#</a>
				</cfoutput>
				</cfsavecontent>
				
			</cfif>
			
			
			<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">'&langText.es.new_area.foot_content&'</p>'>	
			
            <cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
            </cfinvoke>
            <!---En el asunto se pone el nombre del área raiz--->
            <cfset subject = "[#root_area.name#][langText.es.new_area] #objectArea.name#">
            
			<!---INTERNAL USERS--->
			<cfif len(listInternalUsers) GT 0>
			
				<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
					<cfinvokeargument name="area_id" value="#objectArea.id#">
				</cfinvoke>
				
                <cfset subjectInternal = subject>
			
				<cfsavecontent variable="contentInternal">
				<cfoutput>
				<br />
		Se ha creado el área: <strong>#objectArea.name#</strong> en la organización #root_area.name#, y usted tiene acceso a ella.<br />
		Ruta del área: #area_path#.<br /><br />
		<cfif len(objectArea.description) GT 0>
		Descripción del área:<br /> 
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
        Se ha creado el área: <strong>#objectArea.name#</strong> en la organización #root_area.name#, y usted tiene acceso a ella.<br /><br />
		<cfif len(objectArea.description) GT 0>
		Descripción del área:<br /> 
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
	
		</cfif>		
		
	</cffunction>
    
	
	<!--- -------------------------------------- assignUserToArea ------------------------------------ --->
	
	<cffunction name="assignUserToArea" access="public" returntype="void">
		<cfargument name="objectUser" type="struct" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="new_area" type="boolean" required="no" default="false">
				
		<cfset var method = "assignUserToArea">
        
        <cfset var root_area = structNew()>
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
        <cfinvoke component="AreaManager" method="getArea" returnvariable="objectArea">
            <cfinvokeargument name="get_area_id" value="#area_id#">
            <cfinvokeargument name="format_content" value="default">
            <cfinvokeargument name="return_type" value="object">
        </cfinvoke>
        
		<!---<cfinvoke component="AreaManager" method="selectArea" returnvariable="result">
			<cfinvokeargument name="request" value='<request><parameters><area id="#area_id#"/></parameters></request>'>
		</cfinvoke>
		
		<cfxml variable="xmlAreaResponse">
			<cfoutput>
			#result#
			</cfoutput>
		</cfxml>
		
		<cfinvoke component="AreaManager" method="objectArea" returnvariable="objectArea">
				<cfinvokeargument name="xml" value="#xmlAreaResponse.response.result.area#">
				
				<cfinvokeargument name="return_type" value="object">
		</cfinvoke>--->	
	
		<!---<cfif arguments.new_area IS false>--->
			<!---<cfset subject="[#APPLICATION.title#] Tiene acceso a una nueva área: "&objectArea.name>--->
		<!---<cfelse>
			<cfset subject="[#APPLICATION.title#] Se ha creado una nueva área: "&objectArea.name>
		</cfif>--->
		
        <cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
        </cfinvoke>
        <!---En el asunto se pone el nombre del área raiz--->
        <cfif arguments.new_area IS false>
			<cfset subject = "[#root_area.name#] Ha sido asociado como usuario del área: "&objectArea.name>
		<cfelse>
			<cfset subject = "[#root_area.name#] Ha sido asociado como responsable del área: "&objectArea.name>
		</cfif>
        
		<cfif objectUser.whole_tree_visible IS true><!---INTERNAL USER--->
			<!---<cfset subject="[#APPLICATION.title#] Tiene acceso a una nueva área: "&objectArea.name>--->
			
			<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>
			
		<!---<cfelse>
			<cfset subject="[#APPLICATION.title#][#SESSION.client_name#] Tiene acceso a una nueva área: "&objectArea.name>--->
		</cfif>
				
		
		<!---HAY QUE AGREGAR LOS IDIOMAS A ESTA PARTE PARA QUE LOS EMAILS PUEDAN ESTAR EN VARIOS IDIOMAS--->
		<!---<cfinvoke component="AlertManager" method="getApplicationAccess" returnvariable="access_content">
		</cfinvoke>--->
		
		<!---areaUrl--->
		<cfinvoke component="#APPLICATION.componentsPath#/components/UrlManager" method="getAreaUrl" returnvariable="areaUrl">
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfinvoke>
		
		<cfif APPLICATION.identifier EQ "dp">
		
			<cfsavecontent variable="access_content">
			<cfoutput>
			-&nbsp;Acceda directamente al área mediante el siguiente enlace:
			<a target="_blank" href="#areaUrl#">#areaUrl#</a>
	
			<br/>-&nbsp;Acceda a la aplicación en la siguiente dirección:
			<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#">#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#</a>
			</cfoutput>
			</cfsavecontent>
			
			
		<cfelseif APPLICATION.identifier EQ "vpnet">
		
			<cfsavecontent variable="access_content">
			<cfoutput>
			Acceda directamente al área mediante los siguientes enlaces: <br/>
			-&nbsp;Acceso interno <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/?area=#area_id#&abb=#SESSION.client_abb#">#APPLICATION.mainUrl##APPLICATION.path#/?area=#area_id#&abb=#SESSION.client_abb#</a><br/>
			-&nbsp;Acceso externo <a target="_blank" href="#APPLICATION.alternateUrl#/?area=#area_id#&abb=#SESSION.client_abb#">#APPLICATION.alternateUrl#/?area=#area_id#&abb=#SESSION.client_abb#</a>
			</cfoutput>
			</cfsavecontent>
			
		</cfif>
		
		<cfsavecontent variable="html_text">
		<cfoutput>
		<br />
<cfif arguments.new_area IS false>
Ha sido asociado al área: <strong>#objectArea.name#</strong> de la organización #root_area.name#.<br />
<cfelse>
Se ha creado el área: <strong>#objectArea.name#</strong>, y usted ha sido asociado como responsable de la misma.<br />
</cfif>
<cfif objectUser.whole_tree_visible IS true>
Ruta del área: #area_path#.<br />
</cfif>
<br />
<cfif len(objectArea.description) GT 0>
Descripción del área:<br /> 
#objectArea.description#<br />
</cfif>
<br/>
<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>	
		</cfoutput>		
		</cfsavecontent>
		
		<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">No responda a este email.<br />Este es un email automático enviado por la aplicación #APPLICATION.title#.</p>'>		
		
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
		
		<cfinclude template="includes/functionStartOnlySession.cfm">	
		
		<!---<cfif objectUser.whole_tree_visible IS true><!---INTERNAL USER--->
			<cfset subject="[#APPLICATION.title#] Usted ha sido dado de alta en la aplicación.">
		<cfelse>
			<cfset subject="[#APPLICATION.title#][#SESSION.client_name#] Usted ha sido dado de alta en la aplicación.">
		</cfif>--->
		
        <cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
        </cfinvoke>
        <!---En el asunto se pone el nombre del área raiz--->
        <cfset subject = "[#root_area.name#] Usted ha sido dado de alta como usuario de la organización.">
		
		<cfinvoke component="AlertManager" method="getApplicationAccess" returnvariable="access_content">
		</cfinvoke>
		
		<!---Esto tiene que completarse con la generación de un código de ticket--->	
		<!---IMPORTANTE: Para confirmar su alta debe acceder a la siguiente dirección: #APPLICATION.mainUrl#/#SESSION.client_id#--->		
		<cfsavecontent variable="html_text">
		<cfoutput>
Ha sido dado de alta en la aplicación #APPLICATION.title# de la organización <b>#root_area.name#</b>.<br /><br />

<cfif APPLICATION.moduleLdapUsers NEQ "enabled"><!---Default User--->
IMPORTANTE: Si utiliza la aplicación acepta los términos de uso de la misma, que aparecen en la siguiente página: <a href="#APPLICATION.termsOfUseUrl#">#APPLICATION.termsOfUseUrl#</a>.<br/>

Su usuario de acceso es: <b>#objectUser.email#</b><br />
Contraseña: <b>#arguments.password_temp#</b><br/>
Debe cambiar la contraseña en el apartado "Preferencias" de la aplicación.<br /><br/>

Para ver los tutoriales de la aplicación acceda a: <a href="#APPLICATION.helpUrl#">#APPLICATION.helpUrl#</a><br/>
<cfelse><!---LDAP User--->
	<cfif isDefined("arguments.objectUser.login_ldap") AND len(arguments.objectUser.login_ldap) GT 0>
		<cfset ldap_name = APPLICATION.ldapName>
		<cfset login_ldap = arguments.objectUser.login_ldap>
	<cfelseif isDefined("arguments.objectUser.login_diraya")>
		<cfset ldap_name = "Diraya">
		<cfset login_ldap = arguments.objectUser.login_diraya>
	</cfif>
Su usuario de acceso es el usado para identificarse en #ldap_name#.<br/>
Usuario: <b>#login_ldap#</b><br/>
</cfif><br/>
<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>

		</cfoutput>		
		</cfsavecontent>
		
		<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">No responda a este email.<br />Este es un email automático enviado por la aplicación #APPLICATION.title#.</p>'>		
		
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
		<cfargument name="user_full_name" type="string" required="yes">
		<cfargument name="user_email" type="string" required="yes">
		<cfargument name="user_password" type="string" required="yes">
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">
				
		<cfset var method = "newUser">
        
        <cfset var rootAreaQuery = structNew()>
		
		
		<cfinvoke component="#APPLICATION.componentsPath#/components/AreaQuery" method="getRootArea" returnvariable="rootAreaQuery">
			<cfinvokeargument name="onlyId" value="false">
			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>
			
        <cfset subject = "[#rootAreaQuery.name#] Nueva contraseña de acceso a DoPlanning.">
		
		<!---<cfinvoke component="AlertManager" method="getApplicationAccess" returnvariable="access_content">
		</cfinvoke>--->
		
	
		<cfsavecontent variable="html_text">
		<cfoutput>
Ha solicitado una nueva contraseña para la aplicación #APPLICATION.title# de la organización <b>#rootAreaQuery.name#</b>.<br /><br />

Su usuario de acceso es: #arguments.user_email#<br /><br/>
<span style="font-size:15px">Nueva contraseña: <b>#arguments.user_password#</b></span><br/><br/>
Puede cambiar la contraseña en las preferencias de la aplicación.<br /><br/>

<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">Acceda a la aplicación en la siguiente dirección: <br/><a href="#APPLICATION.mainUrl##APPLICATION.path#/html/login/?client_abb=#arguments.client_abb#" target="_blank">#APPLICATION.mainUrl##APPLICATION.path#/html/login/?client_abb=#arguments.client_abb#</a></div>

		</cfoutput>		
		</cfsavecontent>
		
		<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">No responda a este email.<br />Este es un email automático enviado por la aplicación #APPLICATION.title#.</p>'>		
		
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
		
		<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">No responda a este email.<br />Este es un email automático enviado por la aplicación #APPLICATION.title#.</p>'>
		
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
				
		<cfset var method = "getApplicationAccess">
		
		<cfset var access_default = "">
		<cfset var access_content = "">
		
		<cfif APPLICATION.identifier EQ "dp">
		
			<cfset access_default = 'Puede acceder a la aplicación en la siguiente dirección: '>
			
			<cfset access_content = '#access_default#<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#">#APPLICATION.mainUrl##APPLICATION.path#/#SESSION.client_id#</a>'>	
			
		<cfelseif APPLICATION.identifier EQ "vpnet">
		
			<cfset access_default = '<br/><br/>Puede acceder a la aplicación a través de: '>
			
			<cfsavecontent variable="access_content">
			<cfoutput>
			#access_default#<br/>
			-&nbsp;Acceso interno <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/">#APPLICATION.mainUrl##APPLICATION.path#/</a><br/>
			-&nbsp;Acceso externo <a target="_blank" href="#APPLICATION.alternateUrl#">#APPLICATION.alternateUrl#</a>
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
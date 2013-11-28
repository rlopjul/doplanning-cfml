<!---Copyright Era7 Information Technologies 2007-2012

	Date of file creation: 07-10-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	
	20-03-2013 alucena: añadido campo DNI para todos los usuarios
	23-04-2013 alucena: updateUser modifica el campo language
	16-05-2013 alucena: outputUser incluye acceso a reunión virtual
	
--->
<cfcomponent output="true">

	<cfset component = "User">
	<cfset request_component = "UserManager">
	
	
	<cffunction name="selectUser" returntype="xml" output="false" access="public">
		<cfargument name="user_id" type="string" required="true">
		
		<cfset var method = "selectUser">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cftry>
			
			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<user id="#arguments.user_id#"/>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------------------- getUser ------------------------------------- --->
	
	<cffunction name="getUser" output="false" returntype="struct" access="public">
		<cfargument name="user_id" type="numeric" required="true">
		<cfargument name="format_content" type="string" required="no" default="default">
		
		<cfset var method = "getUser">
		
		<cfset var objectUser = structNew()>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="getUser" returnvariable="objectUser">				
				<cfinvokeargument name="get_user_id" value="#arguments.user_id#">
				<cfinvokeargument name="format_content" value="#arguments.format_content#">
				<cfinvokeargument name="return_type" value="object">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn objectUser>
		
	</cffunction>
	

	<cffunction name="getUserContacts" returntype="xml" output="false" access="public">
		<cfargument name="order_by" type="string" required="false" default="">
		<cfargument name="order_type" type="string" required="false" default="asc">
		
		<cfset var method = "getUserContacts">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cftry>
			
			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<contact id="" user_id="" mobile_phone_ccode="" mobile_phone="" email="">
						<family_name><![CDATA[]]></family_name>
						<name><![CDATA[]]></name>	
						<address><![CDATA[]]></address>	
						<organization><![CDATA[]]></organization>		
					</contact>
					<user_format><![CDATA[true]]></user_format>
					<cfif len(arguments.order_by) GT 0>
					<order parameter="#arguments.order_by#" order_type="#arguments.order_type#"/>
					</cfif>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<cffunction name="getUsers" returntype="struct" output="false" access="public">
		<cfargument name="search_text" type="string" required="false" default="">
		<cfargument name="order_by" type="string" required="false" default="family_name">
		<cfargument name="order_type" type="string" required="false" default="asc">
		<cfargument name="limit" type="numeric" required="false">
		
		<cfset var method = "getUsers">
				
		<cftry>
			
			<!---<cfsavecontent variable="request_parameters">
				<cfoutput>
					<user id="" mobile_phone_ccode="" mobile_phone="" email="" image_type="">
						<family_name><![CDATA[]]></family_name>
						<name><![CDATA[]]></name>		
					</user>
					<cfif len(arguments.order_by) GT 0>
					<order parameter="#arguments.order_by#" order_type="#arguments.order_type#"/>
					</cfif>
					<cfif len(arguments.search_text) GT 0>
					<search_text><![CDATA[#arguments.search_text#]]></search_text>
					</cfif>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>--->		

			<cfxml variable="xmlUser">
				<cfoutput>
					<user id="" mobile_phone_ccode="" mobile_phone="" email="" image_type="">
						<family_name><![CDATA[]]></family_name>
						<name><![CDATA[]]></name>		
					</user>
				</cfoutput>
			</cfxml>

			<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="getUsers" returnvariable="response">
				<cfinvokeargument name="xmlUser" value="#xmlUser#"/>
				<cfif len(arguments.search_text) GT 0>
					<cfinvokeargument name="search_text" value="#arguments.search_text#"/>
				</cfif>
				<cfif len(arguments.order_by) GT 0>
					<cfinvokeargument name="order_by" value="#arguments.order_by#"/>
					<cfinvokeargument name="order_type" value="#arguments.order_type#"/>
				</cfif>
				<cfif isDefined("arguments.limit")>
					<cfinvokeargument name="limit" value="#arguments.limit#"/>
				</cfif>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>
	
	
	
	
	<!--- ----------------------------------- getAllAreaUsers ------------------------------------- --->
	
	<cffunction name="getAllAreaUsers" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="order_by" type="string" required="false" default="family_name">
		<cfargument name="order_type" type="string" required="false" default="asc">
		
		<cfset var method = "getAllAreaUsers">
		
		<cfset var response = structNew()>
		
		<cftry>

			<cfxml variable="xmlUser">
				<cfoutput>
					<user id="" email="" image_type="" area_member="">
						<family_name><![CDATA[]]></family_name>
						<name><![CDATA[]]></name>		
					</user>
				</cfoutput>
			</cfxml>

			<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="getAllAreaUsers" returnvariable="response">
				<cfinvokeargument name="xmlUser" value="#xmlUser#"/>
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="order_by" value="#arguments.order_by#"/>
				<cfinvokeargument name="order_type" value="#arguments.order_type#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>				
																							
		</cftry>
		
		<cfreturn response>
		
	</cffunction>
	
	
	
	<cffunction name="getUserPreferences" output="false" returntype="query" access="public">
		
		<cfset var method = "getUserPreferences">
		
		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="getUserPreferences" returnvariable="response">
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.preferences>
		
	</cffunction>
	
	
	<cffunction name="updateUser" returntype="void" output="false" access="remote">
		<cfargument name="id" type="numeric" required="true">
		<cfargument name="family_name" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="dni" type="string" required="true">
		<cfargument name="mobile_phone" type="string" required="true">
		<cfargument name="mobile_phone_ccode" type="string" required="true">
		<cfargument name="address" type="string" required="true">
		<cfargument name="language" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="password_confirmation" type="string" required="true">
		<cfargument name="imagedata" type="string" required="false" default="">
		
		<cfset var method = "updateUser">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cftry>
			
			<!---<cfset response_page = "iframes/preferences_user_data.cfm">--->
			<cfset response_page = "preferences.cfm">
			
			<cfif arguments.password NEQ arguments.password_confirmation>
		
				<cfset message = "El nuevo password y su confirmación deben ser iguales.">
				<cfset message = URLEncodedFormat(message)>
				<cflocation url="#APPLICATION.htmlPath#/#response_page#?message=#message#" addtoken="no">
			
			</cfif>
			
			<cfif len(arguments.email) IS 0 AND NOT isValid("email",arguments.email)>
			
				<cfset message = "Debe introducir un email correcto.">
				<cfset message = URLEncodedFormat(message)>
				<cflocation url="#APPLICATION.htmlPath#/#response_page#?message=#message#" addtoken="no">
			
			</cfif>
			<cfif len(password) GT 0>
				<cfset password_encoded = hash(arguments.password)>
			</cfif>
			
			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<user id="#arguments.id#" 
					email="#arguments.email#"
					mobile_phone_ccode="#arguments.mobile_phone_ccode#" 
					mobile_phone="#arguments.mobile_phone#"
					telephone_ccode="#arguments.telephone_ccode#"
					telephone="#arguments.telephone#"
					language="#arguments.language#"
					<cfif isDefined("password_encoded")>
					password="#password_encoded#"
					</cfif>>
						<family_name><![CDATA[#arguments.family_name#]]></family_name>
						<name><![CDATA[#arguments.name#]]></name>
						<address><![CDATA[#arguments.address#]]></address>
						<dni><![CDATA[#arguments.dni#]]></dni>
					</user>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
			
			<cfset message = "Modificación guardada.">
			
			<!---Subida de imagen--->
			
			<cfif isDefined("arguments.imagedata") AND len(arguments.imagedata) GT 0>
			
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UserImageFile" method="uploadUserImage">
					<cfinvokeargument name="imagedata" value="#arguments.imagedata#">
					<cfinvokeargument name="user_id" value="#SESSION.user_id#">
					<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				</cfinvoke>		
				
				<cfset message = "Modificación guardada e imagen actualizada.">
			
			</cfif>
			
			<!---FIN subida de imagen--->
			
			
			<cfset message = URLEncodedFormat(message)>
            
            <cflocation url="#APPLICATION.htmlPath#/#response_page#?msg=#message#&res=1" addtoken="no">
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<cffunction name="updateUserPreferences" returntype="void" output="false" access="remote">
		<cfargument name="notify_new_message" type="string" required="false" default="false">
		<cfargument name="notify_new_file" type="string" required="false" default="false">
		<cfargument name="notify_replace_file" type="string" required="false" default="false">
		<cfargument name="notify_new_area" type="string" required="false" default="false">
		<cfargument name="notify_new_link" type="string" required="false" default="false">
		<cfargument name="notify_new_entry" type="string" required="false" default="false">
		<cfargument name="notify_new_news" type="string" required="false" default="false">
		<cfargument name="notify_new_event" type="string" required="false" default="false">
		<cfargument name="notify_new_task" type="string" required="false" default="false">
		<cfargument name="notify_new_consultation" type="string" required="false" default="false">

		<cfargument name="notify_new_image" type="string" required="false" default="false">
		<cfargument name="notify_new_typology" type="string" required="false" default="false">
		<cfargument name="notify_new_list" type="string" required="false" default="false">
		<cfargument name="notify_new_list_row" type="boolean" required="false" default="false">
		<cfargument name="notify_new_form" type="string" required="false" default="false">
		<cfargument name="notify_new_form_row" type="boolean" required="false" default="false">
		<cfargument name="notify_new_pubmed" type="string" required="false" default="false">

		<!--- <cfargument name="notify_dissociate_file" type="boolean" required="false" default="false"> --->
		<cfargument name="notify_delete_file" type="boolean" required="false" default="false">
		<cfargument name="notify_lock_file" type="boolean" required="false" default="false">
		
		<cfset var method = "updateUserPreferences">
		
		<cfset var response = structNew()>
		
		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="updateUserPreferences" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset msg = "Modificación guardada.">
			<cfelse>
				<cfset msg = response.message>
			</cfif>

			<cfset msg = URLEncodedFormat(msg)>
            
            <cflocation url="#APPLICATION.htmlPath#/iframes/preferences_alerts.cfm?msg=#msg#&res=#response.result#" addtoken="no">
			
			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>


	<cffunction name="updateUserLanguage" returntype="struct" output="false" access="public">
		<cfargument name="user_id" type="string" required="true">
		<cfargument name="language" type="string" required="true">
		
		<cfset var method = "updateUserLanguage">
		
		<cfset var request_parameters = "">
		<cfset var response = "">
		
		<cftry>
			
			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<user id="#arguments.user_id#" 
						language="#arguments.language#">
					</user>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="updateUser">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
			
			<cfset response = {result="true", message=""}>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>



	<!--- ----------------------------------- deleteUser -------------------------------------- --->

	<cffunction name="deleteUser" output="false" returntype="struct" access="public">
		<cfargument name="user_id" type="numeric" required="true"/>

		<cfset var method = "deleteUser">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="deleteUser" returnvariable="response">
				<cfinvokeargument name="delete_user_id" value="#arguments.user_id#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>


	

	<cffunction name="deleteUserImage" returntype="void" access="remote">
		<cfargument name="return_page" type="string" required="true">
		
		<cfset var method = "deleteUserImage">
		
		<cfset var response_page= "">
		<cfset var request_parameters = "">
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/UserImageFile" method="deleteUserImage">
				<cfinvokeargument name="user_id" value="#SESSION.user_id#">
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			</cfinvoke>		
				
			<cfset msg = "Imagen eliminada.">
			
			<cfset msg = URLEncodedFormat(msg)>
            
            <cflocation url="#arguments.return_page#?msg=#msg#&res=1" addtoken="no">	
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>



	<!--- ----------------------------------- assignUserToArea -------------------------------------- --->

	<cffunction name="assignUserToArea" output="false" returntype="struct" returnformat="json" access="remote">
		<cfargument name="area_id" type="numeric" required="true" />
		<cfargument name="user_id" type="numeric" required="true" />
		
		<cfset var method = "assignUserToArea">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="assignUserToArea" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="add_user_id" value="#arguments.user_id#"/>
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Usuario asociado">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>
	


	<!--- ----------------------------------- dissociateUserFromArea -------------------------------------- --->

	<cffunction name="dissociateUserFromArea" output="false" returntype="struct" returnformat="json" access="remote">
		<cfargument name="area_id" type="numeric" required="true" />
		<cfargument name="user_id" type="numeric" required="true" />
		
		<cfset var method = "dissociateUserFromArea">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="dissociateUserFromArea" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="dissociate_user_id" value="#arguments.user_id#"/>
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Usuario quitado del área">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>
	


	
	<cffunction name="outputUser" returntype="void" output="true" access="public">
		<cfargument name="objectUser" type="struct" required="true">
		<!---<cfargument name="contact_format" type="boolean" required="false" default="false">--->
		
		<cfset var method = "outputUser">
		
		<cfset var user_page = "">
		
		<cftry>
			
			<cfoutput>
			<div class="div_user_page_title">
			<cfif len(objectUser.image_type) GT 0>
				<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&medium=" alt="#objectUser.family_name# #objectUser.name#" class="item_img" style="margin-right:2px;"/>									
			<cfelse>							
				<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectUser.family_name# #objectUser.name#" class="item_img_default" style="margin-right:2px;"/>
			</cfif><br/>
			
			#objectUser.family_name# #objectUser.name#</div>
			<div class="div_separator"><!-- --></div>
			<div class="div_user_page_user">
				<div class="div_user_page_label"><span lang="es">Email:</span> <a href="mailto:#objectUser.email#" class="div_user_page_text">#objectUser.email#</a></div>
				<cfif len(objectUser.dni) GT 0>
				<div class="div_user_page_label"><span lang="es"><cfif APPLICATION.showDniTitle IS true>DNI<cfelse>Número de identificación</cfif>:</span> <span class="div_user_page_text">#objectUser.dni#</span></div>
				</cfif>
				<div class="div_user_page_label"><span lang="es">Teléfono:</span> <a href="tel:#objectUser.telephone#" class="div_user_page_text"><cfif len(objectUser.telephone) GT 0>#objectUser.telephone_ccode#</cfif> #objectUser.telephone#</a></div>
				<div class="div_user_page_label"><span lang="es">Teléfono móvil:</span> <a href="tel:#objectUser.mobile_phone#" class="div_user_page_text"><cfif len(objectUser.mobile_phone) GT 0>#objectUser.mobile_phone_ccode#</cfif> #objectUser.mobile_phone#</a></div>
				<cfif len(objectUser.address) GT 0>
				<div class="div_user_page_label"><span lang="es">Dirección:</span></div> 
				<div class="div_user_page_address">#objectUser.address#</div>
				</cfif>
				<cfif APPLICATION.moduleWebRTC IS true>
				<div style="padding-top:8px; clear:both;">
					<!---<img src="#APPLICATION.htmlPath#/assets/icons_dp/user_meeting.png" width="20" alt="Reunión virtual" lang="es"/>--->
					
					<div>
					<a href="#APPLICATION.htmlPath#/user_meeting.cfm?user=#objectUser.id#" target="_blank" onclick="openUrl('#APPLICATION.mainUrl##APPLICATION.htmlPath#/meeting/?user=#objectUser.id#&abb=#SESSION.client_abb#','_blank',event)" title="Reunión virtual" lang="es" class="btn btn-small btn-info"><i class="icon-facetime-video"></i>&nbsp; <span lang="es">Reunión virtual</span></a>
					</div>
					<div class="div_user_page_label"><span lang="es">URL de acceso a reunión virtual con este usuario:</span></div>
					<textarea class="input-block-level" readonly="readonly" style="height:50px; cursor:text">#APPLICATION.mainUrl##APPLICATION.htmlPath#/meeting/?user=#objectUser.id#&abb=#SESSION.client_abb#</textarea>
													
				</div>
				</cfif>
				
			</div>
			
			
			
			</cfoutput>								
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	<cffunction name="outputUserList" returntype="void" output="true" access="public">
		<cfargument name="xmlUser" type="xml" required="true">
		<cfargument name="page_type" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="contact_format" type="boolean" required="false" default="false">
		
		<cfset var method = "outputUserList">
		
		<cfset var user_page = "">
		
		<cftry>
		
			<!---Required vars
				page_type
				
				page_types:
					1 Usuarios de un área
						area_id required
					2 Contactos de un usuario
					3 Seleccionar usuarios
					4 Seleccionar contactos
			--->
			
			<cfif arguments.contact_format IS true>
				<cfset user_page = "contact.cfm">
			<cfelse>
				<cfif arguments.page_type IS 1>
					<cfset user_page = "area_user.cfm">
				<cfelse>
					<cfset user_page = "user.cfm">
				</cfif>
			</cfif>
			
			
			<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="objectUser">
					<cfinvokeargument name="xml" value="#xmlUser#">
					<cfinvokeargument name="return_type" value="object">
			</cfinvoke>	
			
			<cfoutput>
			<div class="div_user">
				<!---<div class="div_checkbox_user"><input type="checkbox" class="checkbox_user" name="#objectUser.email#" value="#objectUser.mobile_phone_ccode##objectUser.mobile_phone#"/></div>--->
				
				<div class="div_checkbox_user">
				<cfif APPLICATION.identifier EQ "dp">
				<input type="checkbox" class="checkbox_user" name="#objectUser.id#" value="e=#objectUser.email#;n=#objectUser.mobile_phone_ccode##objectUser.mobile_phone#"/>
				<cfelse><!---vpnet--->
				<input type="checkbox" class="checkbox_user" name="#objectUser.id#" value="e=#objectUser.email#;n=#objectUser.mobile_phone#"/>
				</cfif>
				</div>
				<div class="div_user_right">		
					<div class="div_text_user_name">
					<cfif page_type IS 1>
					<a href="#user_page#?area=#arguments.area_id#&user=#objectUser.id#" onclick="openUrl('#user_page#?area=#arguments.area_id#&user=#objectUser.id#','itemIframe',event)" class="text_item">
					<cfelse>
					<a href="#user_page#?user=#objectUser.id#" class="text_item">
					</cfif>
					<cfif objectUser.user_in_charge EQ "true"><strong></cfif>
					#objectUser.family_name# #objectUser.name#
					<cfif objectUser.user_in_charge EQ "true"></strong></cfif></a>
					</div>
					<div class="div_text_user_email"><a href="mailto:#objectUser.email#" class="text_user_data">#objectUser.email#</a></div><div class="div_text_user_mobile">
					<!---<cfif app_version EQ "mobile"><a href="tel:#objectUser.mobile_phone#" class="text_user_data">#objectUser.mobile_phone#</a>
					<cfelse>---><span>#objectUser.mobile_phone#</span>						
					<!---</cfif>--->
					</div>
				</div>
			</div>		
			<div class="div_separator"><!-- --></div>
			</cfoutput>								
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	<!---outputUsersSelectList (HTML Table)--->
	
	<cffunction name="outputUsersSelectList" returntype="void" output="true" access="public">
		<cfargument name="users" type="array" required="true">
		<cfargument name="page_type" type="numeric" required="true">
		<cfargument name="filter_enabled" type="boolean" required="false" default="false">
		
		<cfset var method = "outputUsersSelectList">
		
		<!---
			page_types
			1 select only one user
			2 multiple selection
		--->
		
		<cftry>
		
			<cfset numUsers = ArrayLen(users)>

			<cfif numUsers GT 0>
				
				<script type="text/javascript">
					$(document).ready(function() { 
						
						$("##listTable").tablesorter({ 
							<!---<cfif page_type IS 1>--->
							<cfif arguments.filter_enabled IS true>
							widgets: ['zebra','filter'],
							<cfelse>
							widgets: ['zebra'],
							</cfif>
							<!---<cfelse>
							widgets: ['zebra','select'],
							</cfif>--->
							sortList: [[1,0]] ,
							headers: { 
								0: { 
									sorter: false 
								}
							},
							<cfif arguments.filter_enabled IS true>
							widgetOptions : {
								filter_childRows : false,
								filter_columnFilters : true,
								filter_cssFilter : 'tablesorter-filter',
								filter_filteredRow : 'filtered',
								filter_formatter : null,
								filter_functions : null,
								filter_hideFilters : false,
								filter_ignoreCase : true,
								filter_liveSearch : true,
								//filter_reset : 'button.reset',
								filter_searchDelay : 300,
								filter_serversideFiltering: false,
								filter_startsWith : false,
								filter_useParsedData : false,
						    },
						    </cfif> 
						});
						
						<!---//  Adds "over" class to rows on mouseover
						$("##listTable tr").mouseover(function(){
						  $(this).addClass("over");
						});
	
						//  Removes "over" class from rows on mouseout
						$("##listTable tr").mouseout(function(){
						  $(this).removeClass("over");
						});--->
						
						<cfif page_type IS 1>
						$("##listTable tbody tr").click(function(){
							
							var selected = false;
							if($(this).hasClass("selected"))
								selected = true;
							
							$("##listTable tr").removeClass('selected');
							
							if(!selected)
								$(this).addClass("selected")
							
						});
						<cfelse>
						$("##listTable tbody tr").click(function(){
							
							if($(this).hasClass("selected"))
							var selected = false;
							if($(this).hasClass("selected"))
								selected = true;
														
							if(!selected)
								$(this).addClass("selected")
							else
								$(this).removeClass("selected")
						});
						</cfif>

						$("##listTable thead tr.tablesorter-filter-row").click(function(){
							$("##listTable tr").removeClass('selected');
						});
						
						$("##submit_select").click(function(){ 
											
							var usuarioId = null;
							var usuarioNombre = "";

							var parentWindowDefined = false;
							
							<cfif page_type IS 1>
								
								// Selección de usuario
								usuarioId = $("##listTable tr.selected input[type=hidden][name=user_id]").attr("value");
								
								if(usuarioId != null) {
							
									usuarioNombre = $("##listTable tr.selected input[type=hidden][name=user_full_name]").attr("value");

									if(window.opener != null){
										parentWindowDefined = ( $.isFunction(window.opener.setSelectedUser) || (typeof window.opener.setSelectedUser!='undefined') ); // Segunda comprobación para IE
									} 

									if(parentWindowDefined){

										window.opener.setSelectedUser(usuarioId, usuarioNombre);
										window.close();

									}else{

										setResponsibleUser(usuarioId, usuarioNombre);
									}
								
								}else{
									alert(window.lang.convert("No se ha seleccionado ningún usuario"));
								}

							<cfelse>
								
								if(window.opener != null){
									parentWindowDefined = ( $.isFunction(window.opener.addUser) || (typeof window.opener.addUser!='undefined') );
								}
									

								// Selección de usuarios para permisos
								if($("##listTable tr.selected").length > 0) {

									var allUsersAdded = true;
								
									$("##listTable tr.selected").each( function() {
									
										usuarioId = $("input[type=hidden][name=user_id]",this).attr("value");								
										usuarioNombre = $("input[type=hidden][name=user_full_name]",this).attr("value");
										
										if(parentWindowDefined){	

											if(window.opener.addUser(usuarioId, usuarioNombre))
												window.close();
											else
												alert(usuarioNombre+window.lang.convert(" ya está en la lista"));

										}else{

											if(addUser(usuarioId, usuarioNombre) == false)
												allUsersAdded = false;

										}

									});

									if(!parentWindowDefined){

										if(allUsersAdded){
											sendUsersForm();
											$("##submit_select").prop('disabled', true); 
										}
											
									}
									
								}else{
									alert(window.lang.convert("No se ha seleccionado ningún usuario"));
								}

							</cfif>
							
						}); 
							
					}); 
				</script>
				
				<cfoutput>
				<table id="listTable" class="table-hover">
					<thead>
						<tr>
							<th style="width:35px;" class="filter-false"></th>
							<th lang="es">Nombre</th>
							<th lang="es">Apellidos</th>
							<th lang="es">Email</th>
						</tr>
					</thead>
					
					<tbody>
					<!---<cfloop index="xmlIndex" from="1" to="#numUsers#" step="1">
						
						<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="objectUser">
							<cfinvokeargument name="xml" value="#xmlUsers.xmlChildren[1].xmlChildren[xmlIndex]#">
							<cfinvokeargument name="return_type" value="object">
						</cfinvoke>--->
					<cfloop index="objectUser" array="#users#">	
						<tr>
							<td style="text-align:center">
								<cfif len(objectUser.image_type) GT 0>
									<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" class="item_img"/>									
								<cfelse>							
									<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectUser.user_full_name#" class="item_img_default" />
								</cfif>
							</td>
							<td><input type="hidden" name="user_id" value="#objectUser.id#"/>
							<input type="hidden" name="user_full_name" value="#objectUser.family_name# #objectUser.name#"/>
							<span class="text_item">#objectUser.family_name#</span></td>
							<td><span class="text_item">#objectUser.name#</span></td>
							<td><span class="text_item">#objectUser.email#</span></td>
						</tr>
					</cfloop>
					</tbody>
					
				</table>
				</cfoutput>
				
				<div style="height:2px; clear:both;"><!-- --></div>
				<button type="button" id="submit_select" class="btn btn-primary" style="margin-left:5px;" lang="es"><cfif page_type IS 1>Asignar usuario seleccionado<cfelse>Añadir usuarios seleccionados</cfif></button>
				
			</cfif>
								
								
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	<!---outputUsersList (HTML TABLE)--->
	
	<cffunction name="outputUsersList" returntype="void" output="true" access="public">
		<cfargument name="users" type="array" required="true">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="user_in_charge" type="numeric" required="false" default="0">
		<cfargument name="show_area_members" type="boolean" required="false" default="false">
		<cfargument name="open_url_target" type="string" required="false" default="itemIframe">
		<cfargument name="filter_enabled" type="boolean" required="false" default="true">

		<cfargument name="list_id" type="numeric" required="false">
		
		<cfset var method = "outputUsersList">
		
		<cftry>
			
			<cfset numUsers = ArrayLen(users)>

			<cfif numUsers GT 0>
				
				<script type="text/javascript">
					$(document).ready(function() { 

						$("##listTable").tablesorter({ 
							<cfif arguments.filter_enabled IS true>
							widgets: ['zebra','filter','select'],
							<cfelse>
							widgets: ['zebra','select'],
							</cfif>
							sortList: [[1,0]] ,
							headers: { 
								0: { 
									sorter: false 
								}
								<!---<cfif APPLICATION.moduleWebRTC IS true>
								, 5: { 
									sorter: false 
								}
								</cfif>--->
							},
							<cfif arguments.filter_enabled IS true>
							widgetOptions : {
								filter_childRows : false,
								filter_columnFilters : true,
								filter_cssFilter : 'tablesorter-filter',
								filter_filteredRow : 'filtered',
								filter_formatter : null,
								filter_functions : null,
								filter_hideFilters : false,
								filter_ignoreCase : true,
								filter_liveSearch : true,
								//filter_reset : 'button.reset',
								filter_searchDelay : 300,
								filter_serversideFiltering: false,
								filter_startsWith : false,
								filter_useParsedData : false,
						    },
						    </cfif>

						});
						
						<!---//  Adds "over" class to rows on mouseover
						$("##listTable tr").mouseover(function(){
						  $(this).addClass("over");
						});
					
						//  Removes "over" class from rows on mouseout
						$("##listTable tr").mouseout(function(){
						  $(this).removeClass("over");
						});---->			
						
					}); 
				</script>
				
				<cfoutput>
				<table id="listTable" class="table-hover">
					<thead>
						<tr>
							<th style="width:35px;" class="filter-false"></th>
							<th lang="es">Nombre</th>
							<th lang="es">Apellidos</th>
							<th lang="es">Email</th>
							<cfif arguments.show_area_members IS true>
							<th style="width:110px;" lang="es">De esta área</th>
							</cfif>
							<!---<cfif APPLICATION.moduleWebRTC IS true>
							<th style="width:40px;" lang="es"></th>
							</cfif>--->
						</tr>
					</thead>
					
					<tbody>
					
					<cfset alreadySelected = false>
					
					<!---<cfloop index="xmlIndex" from="1" to="#numUsers#" step="1">
						
						<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="objectUser">
							<cfinvokeargument name="xml" value="#xmlUsers.xmlChildren[1].xmlChildren[xmlIndex]#">
							<cfinvokeargument name="return_type" value="object">
						</cfinvoke>--->

					<cfset userIndex = 0>

					<cfloop index="objectUser" array="#users#">	
						
						<cfset userIndex++>

						<cfif isDefined("arguments.area_id")>
							<cfset user_page_url = "area_user.cfm?area=#arguments.area_id#&user=#objectUser.id#"> 
						<cfelseif isDefined("arguments.list_id")>
							<cfset user_page_url = "list_user.cfm?user=#objectUser.id#&list=#arguments.list_id#"> 
						<cfelse>
							<cfset user_page_url = "user.cfm?user=#objectUser.id#"> 
						</cfif>
						
						<!---Item selection--->
						<cfset itemSelected = false>
						
						<cfif alreadySelected IS false>
						
							<cfif isDefined("URL.user")>
							
								<cfif URL.user IS objectUser.id>
									<!---Esta acción solo se completa si está en la versión HTML2--->
									<script type="text/javascript">
										openUrlHtml2('#user_page_url#','#arguments.open_url_target#');
									</script>
									<cfset itemSelected = true>
								</cfif>
								
							<cfelseif userIndex IS 1>
							
								<!---Esta acción solo se completa si está en la versión HTML2--->
								<script type="text/javascript">
									openUrlHtml2('#user_page_url#','#arguments.open_url_target#');
								</script>
								<cfset itemSelected = true>
								
							</cfif>
							
							<cfif itemSelected IS true>
								<cfset alreadySelected = true>
							</cfif>
							
						</cfif>
						
						<tr <cfif itemSelected IS true>class="selected"</cfif> onclick="openUrl('#user_page_url#','#arguments.open_url_target#',event)">
							<td style="text-align:center">
								<cfif len(objectUser.image_type) GT 0>
									<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" class="item_img"/>									
								<cfelse>							
									<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectUser.user_full_name#" class="item_img_default" />
								</cfif>
							</td>
							<td><span class="text_item" <cfif arguments.user_in_charge IS objectUser.id>style="font-weight:bold"</cfif>>#objectUser.family_name#</span></td>
							<td><span class="text_item" <cfif arguments.user_in_charge IS objectUser.id>style="font-weight:bold"</cfif>>#objectUser.name#</span></td>
							<td><span class="text_item" <cfif arguments.user_in_charge IS objectUser.id>style="font-weight:bold"</cfif>>#objectUser.email#</span></td>
							<cfif arguments.show_area_members IS true>
							<td><span class="text_item" lang="es" <cfif arguments.user_in_charge IS objectUser.id>style="font-weight:bold"</cfif>><cfif objectUser.area_member IS true>Sí<cfelse>No</cfif></span></td>
							</cfif>
							<!---<cfif APPLICATION.moduleWebRTC IS true>
							<td><a href="#APPLICATION.htmlPath#/user_meeting.cfm?user=#objectUser.id#" target="_blank" onclick="openUrl('#APPLICATION.htmlPath#/user_meeting.cfm?user=#objectUser.id#&abb=#SESSION.client_abb#','_blank',event)" title="Reunión virtual" lang="es"><img src="#APPLICATION.htmlPath#/assets/icons_dp/user_meeting.png" alt="Reunión virtual" lang="es"/></a></td>
							</cfif>--->
						</tr>
					</cfloop>
					</tbody>
					
				</table>

				<cfif arguments.user_in_charge GT 0>
					<div style="margin-top:10px">
						<small class="help-block" lang="es">Se muestra en negrita el responsable del área</small>
					</div>
				</cfif>
				</cfoutput>
			
			</cfif>
								
								
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>


	<!--- queryToArray --->
	<!---Este método se utiliza para convertir las consultas de usuarios en arrays, necesarios para outputUsersList--->
	<cffunction name="queryToArray" access="public" returntype="array" output="false" hint="This turns a query into an array of structures.">
		<cfargument name="data" type="query" required="yes" />

		<cfscript>
			// Define the local scope.
			var LOCAL = StructNew();

			// Get the column names as an array.
			LOCAL.Columns = ListToArray( ARGUMENTS.data.ColumnList );

			// Create an array that will hold the query equivalent.
			LOCAL.QueryArray = ArrayNew( 1 );

			// Loop over the query.
			for (LOCAL.RowIndex = 1 ; LOCAL.RowIndex LTE ARGUMENTS.data.RecordCount ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){

			// Create a row structure.
			LOCAL.Row = StructNew();

			// Loop over the columns in this row.
			for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE ArrayLen( LOCAL.Columns ) ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){

			// Get a reference to the query column.
			LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];

			// Store the query cell value into the struct by key.
			LOCAL.Row[ LOCAL.ColumnName ] = ARGUMENTS.data[ LOCAL.ColumnName ][ LOCAL.RowIndex ];

			}

			// Add the structure to the query array.
			ArrayAppend( LOCAL.QueryArray, LOCAL.Row );

			}

			// Return the array equivalent.
			return( LOCAL.QueryArray );
		</cfscript>

	</cffunction>
	
</cfcomponent>
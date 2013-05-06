<!---Copyright Era7 Information Technologies 2007-2012

	Date of file creation: 07-10-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 24-03-2013
	
	20-03-2013 alucena: añadido campo DNI para todos los usuarios
	23-04-2013 alucena: updateUser modifica el campo language
	
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
	
	
	<cffunction name="getUsers" returntype="xml" output="false" access="public">
		<cfargument name="search_text" type="string" required="false" default="">
		<cfargument name="order_by" type="string" required="false" default="">
		<cfargument name="order_type" type="string" required="false" default="asc">
		
		<cfset var method = "getUsers">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cftry>
			
			<cfsavecontent variable="request_parameters">
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
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	
	<!--- ----------------------------------- getAllAreaUsers ------------------------------------- --->
	
	<cffunction name="getAllAreaUsers" returntype="xml" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<!---<cfargument name="order_by" type="string" required="false" default="">
		<cfargument name="order_type" type="string" required="false" default="asc">--->
		
		<cfset var method = "getAllAreaUsers">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cftry>
			
			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<area id="#arguments.area_id#"/>
					<user id="" email="" image_type="" area_member="">
						<family_name><![CDATA[]]></family_name>
						<name><![CDATA[]]></name>		
					</user>
					<!---<cfif len(arguments.order_by) GT 0>
					<order parameter="#arguments.order_by#" order_type="#arguments.order_type#"/>
					</cfif>--->
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
	
	
	
	
	<cffunction name="getUserPreferences" returntype="xml" output="false" access="public">
		
		<cfset var method = "getUserPreferences">
		
		<cfset var xmlResponse = "">
		
		<cftry>
			
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
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
		
		<!---<cftry>--->
			
			<cfset response_page = "iframes/preferences_user_data.cfm">
			
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
			
				<cfinvoke component="#APPLICATION.componentsPath#/components/UserImageFile" method="uploadUserImage">
					<cfinvokeargument name="imagedata" value="#arguments.imagedata#">
					<cfinvokeargument name="user_id" value="#SESSION.user_id#">
					<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				</cfinvoke>		
				
				<cfset message = "Modificación guardada e imagen actualizada.">
			
			</cfif>
			
			<!---FIN subida de imagen--->
			
			
			<cfset message = URLEncodedFormat(message)>
            
            <cflocation url="#APPLICATION.htmlPath#/#response_page#?msg=#message#&res=1" addtoken="no">
			
			<!---<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>--->
		
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
		
		<cfset var method = "updateUserPreferences">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cftry>
			
			<cfsavecontent variable="request_parameters">
				<cfoutput>
				<preferences user_id="#SESSION.user_id#"
					notify_new_message="#arguments.notify_new_message#"
					notify_new_file="#arguments.notify_new_file#"
					notify_replace_file="#arguments.notify_replace_file#"
					notify_new_area="#arguments.notify_new_area#"
					
					<cfif APPLICATION.moduleWeb EQ "enabled">
						<cfif APPLICATION.identifier EQ "vpnet">
						notify_new_link="#arguments.notify_new_link#"
						</cfif>
					notify_new_entry="#arguments.notify_new_entry#"
					notify_new_news="#arguments.notify_new_news#"
					</cfif>
					notify_new_event="#arguments.notify_new_event#"
					notify_new_task="#arguments.notify_new_task#"
					notify_new_consultation="#arguments.notify_new_consultation#"
					/>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
			
			<cfset message = "Modificación guardada.">
			<cfset message = URLEncodedFormat(message)>
            
            <cflocation url="#APPLICATION.htmlPath#/iframes/preferences_alerts.cfm?msg=#message#&res=1" addtoken="no">
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!---<cffunction name="getUsersEmails" returntype="string" output="false" access="public">
		<cfargument name="users_ids" type="string" required="true">
		
		<cfset var method = "getUsersEmails">
		
		<cfset var usersEmails = "">
				
		<cftry>
			
			<cfquery datasource="#client_dsn#" name="getUsersEmails">
				SELECT *
				FROM #SESSION.client_abb#_users
				WHERE id IN (#arguments.users_ids#)
				ORDER BY FIELD(id,#arguments.users_ids#);
			</cfquery>
			
			<cfloop query="getUsersEmails">
				<cfset usersEmails = listAppend(usersEmails,getUsersEmails.email,";")>
			</cfloop>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn usersEmails>
		
	</cffunction>--->
	
	
	
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
				<div class="div_user_page_label"><span lang="es">Número de identificación - DNI:</span> <span class="div_user_page_text">#objectUser.dni#</span></div>
				</cfif>
				<div class="div_user_page_label"><span lang="es">Teléfono:</span> <a href="tel:#objectUser.telephone#" class="div_user_page_text"><cfif len(objectUser.telephone) GT 0>#objectUser.telephone_ccode#</cfif> #objectUser.telephone#</a></div>
				<div class="div_user_page_label"><span lang="es">Teléfono móvil:</span> <a href="tel:#objectUser.mobile_phone#" class="div_user_page_text"><cfif len(objectUser.mobile_phone) GT 0>#objectUser.mobile_phone_ccode#</cfif> #objectUser.mobile_phone#</a></div>
				<div class="div_user_page_label"><span lang="es">Dirección:</span></div> 
				<div class="div_user_page_address">#objectUser.address#</div>
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
		<cfargument name="xmlUsers" type="xml" required="true">
		<cfargument name="page_type" type="numeric" required="true">
		
		<cfset var method = "outputUsersSelectList">
		
		<!---
			page_types
			1 select only one
			2 multiple selection
		--->

		
		<cftry>
		
			<cfset numUsers = ArrayLen(xmlUsers.xmlChildren[1].XmlChildren)>

			<cfif numUsers GT 0>
				
				<script type="text/javascript">
					$(document).ready(function() { 
						
						/*$.tablesorter.addParser({
							id: "datetime",
							is: function(s) {
								return false; 
							},
							format: function(s,table) {
								s = s.replace(/\-/g,"/");
								s = s.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/, "$3/$2/$1");
								return $.tablesorter.formatFloat(new Date(s).getTime());
							},
							type: "numeric"
						});*/
						
						$("##listTable").tablesorter({ 
							<cfif page_type IS 1>
							widgets: ['zebra'],
							<cfelse>
							widgets: ['zebra','select'],
							</cfif>
							/*sortList: [[1,1]] ,*/
							headers: { 
								0: { 
									sorter: false 
								}
							} 
						});
						
						//  Adds "over" class to rows on mouseover
						$("##listTable tr").mouseover(function(){
						  $(this).addClass("over");
						});
					
						//  Removes "over" class from rows on mouseout
						$("##listTable tr").mouseout(function(){
						  $(this).removeClass("over");
						});
						
						
						<cfif page_type IS 1>
						$("##listTable tr").click(function(){
							
							var selected = false;
							if($(this).hasClass("selected"))
								selected = true;
							
							$("##listTable tr").removeClass('selected');
							
							if(!selected)
								$(this).addClass("selected")
							
						});
						</cfif>
						
						
						$("##submit_select").click(function(){ 
			
							if(window.opener != null){
								
								var usuarioId = null;
								var usuarioNombre = "";
								
								<cfif page_type IS 1>
									
									// Selección de usuario para responsable
									usuarioId = $("##listTable tr.selected input[type=hidden][name=user_id]").attr("value");
									
									if(usuarioId != null) {
								
										usuarioNombre = $("##listTable tr.selected input[type=hidden][name=user_full_name]").attr("value");
										
										window.opener.setRecipientUser(usuarioId, usuarioNombre);
																				
										window.close();
									
									}else{
										alert("No se ha seleccionado ningún usuario");
									}
										
								<cfelse>
								
									// Selección de usuarios para permisos
									if($("##listTable tr.selected").length > 0) {
									
										$("##listTable tr.selected").each( function() {
										
											usuarioId = $("input[type=hidden][name=user_id]",this).attr("value");								
											usuarioNombre = $("input[type=hidden][name=user_full_name]",this).attr("value");
																			
											if(!window.opener.addUsuarioPermiso(usuarioId, usuarioNombre))
												alert("El usuario "+usuarioNombre+" ya está en la lista");
			
										});
										
									}else{
										alert("No se ha seleccionado ningún usuario");
									}
									
								</cfif>
								
							}else{
								alert("Error: no se puede asignar el usuario seleccionado");
							}
						}); 
						
						
					}); 
				</script>
				
				<cfoutput>
				<table id="listTable" class="tablesorter">
					<thead>
						<tr>
							<th style="width:35px;"></th>
							<th>Nombre</th>
							<th>Apellidos</th>
							<th>Email</th>
						</tr>
					</thead>
					
					<tbody>
					<cfloop index="xmlIndex" from="1" to="#numUsers#" step="1">
						
						<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="objectUser">
							<cfinvokeargument name="xml" value="#xmlUsers.xmlChildren[1].xmlChildren[xmlIndex]#">
							<cfinvokeargument name="return_type" value="object">
						</cfinvoke>	
						
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
				<button type="button" id="submit_select" class="btn btn-primary" style="margin-left:5px;">Asignar usuario seleccionado</button>
				
			</cfif>
								
								
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	<!---outputUsersList (HTML Table)--->
	
	<cffunction name="outputUsersList" returntype="void" output="true" access="public">
		<cfargument name="xmlUsers" type="xml" required="true">
		<cfargument name="area_id" type="numeric" required="no">
		<cfargument name="user_in_charge" type="numeric" required="no" default="0">
		<cfargument name="show_area_members" type="boolean" required="no" default="false">
		
		<cfset var method = "outputUsersList">
		
		<cftry>
			
			<cfset numUsers = ArrayLen(xmlUsers.xmlChildren[1].XmlChildren)>

			<cfif numUsers GT 0>
				
				<script type="text/javascript">
					$(document).ready(function() { 
						
						/*$.tablesorter.addParser({
							id: "datetime",
							is: function(s) {
								return false; 
							},
							format: function(s,table) {
								s = s.replace(/\-/g,"/");
								s = s.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/, "$3/$2/$1");
								return $.tablesorter.formatFloat(new Date(s).getTime());
							},
							type: "numeric"
						});*/
						
						$("##listTable").tablesorter({ 
							widgets: ['zebra','select'],
							sortList: [[2,0]] ,
							headers: { 
								0: { 
									sorter: false 
								}
							} 
						});
						
						//  Adds "over" class to rows on mouseover
						$("##listTable tr").mouseover(function(){
						  $(this).addClass("over");
						});
					
						//  Removes "over" class from rows on mouseout
						$("##listTable tr").mouseout(function(){
						  $(this).removeClass("over");
						});			
						
					}); 
				</script>
				
				<cfoutput>
				<table id="listTable" class="tablesorter">
					<thead>
						<tr>
							<th style="width:35px;"></th>
							<th lang="es">Nombre</th>
							<th lang="es">Apellidos</th>
							<th lang="es">Email</th>
							<cfif arguments.show_area_members IS true>
							<th style="width:98px;" lang="es">De este área</th>
							</cfif>
						</tr>
					</thead>
					
					<tbody>
					
					<cfset alreadySelected = false>
					
					<cfloop index="xmlIndex" from="1" to="#numUsers#" step="1">
						
						<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="objectUser">
							<cfinvokeargument name="xml" value="#xmlUsers.xmlChildren[1].xmlChildren[xmlIndex]#">
							<cfinvokeargument name="return_type" value="object">
						</cfinvoke>	
						
						<cfif isDefined("arguments.area_id")>
							<cfset user_page_url = "area_user.cfm?area=#arguments.area_id#&user=#objectUser.id#"> 
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
										openUrlHtml2('#user_page_url#','itemIframe');
									</script>
									<cfset itemSelected = true>
								</cfif>
								
							<cfelseif xmlIndex IS 1>
							
								<!---Esta acción solo se completa si está en la versión HTML2--->
								<script type="text/javascript">
									openUrlHtml2('#user_page_url#','itemIframe');
								</script>
								<cfset itemSelected = true>
								
							</cfif>
							
							<cfif itemSelected IS true>
								<cfset alreadySelected = true>
							</cfif>
							
						</cfif>
						
						<tr <cfif itemSelected IS true>class="selected"</cfif> onclick="openUrl('#user_page_url#','itemIframe',event)">
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
						</tr>
					</cfloop>
					</tbody>
					
				</table>
				</cfoutput>
			
			</cfif>
								
								
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	<cffunction name="deleteUserImage" returntype="void" access="remote">
		<cfargument name="return_page" type="string" required="true">
		
		<cfset var method = "deleteUserImage">
		
		<cfset var response_page= "">
		<cfset var request_parameters = "">
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/components/UserImageFile" method="deleteUserImage">
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
	
	
</cfcomponent>
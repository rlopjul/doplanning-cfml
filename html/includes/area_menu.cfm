<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_menu_en.js" charset="utf-8" type="text/javascript"></script>

<div class="div_head_menu">
	
	
	<cfif isDefined("area_id")>
	
	
		<div class="navbar navbar-static-top">
		  <div class="navbar-inner">
			<!---<a class="brand" href="##">Mensajes</a>--->
			
			<cfif isDefined("area_name")>
				<!---<cfif area_allowed EQ true>
					<cfif area_type EQ "">
						<cfset area_image = "icons_#APPLICATION.identifier#/area_small.png">
					<cfelse>
						<cfset area_image = "icons_#APPLICATION.identifier#/area_web_small.png">
					</cfif>
				<cfelse>
					<cfif area_type EQ "">
						<cfset area_image = "icons_#APPLICATION.identifier#/area_small_disabled.png">
					<cfelse>
						<cfset area_image = "icons_#APPLICATION.identifier#/area_web_small_disabled.png">
					</cfif>
				</cfif>--->
				<cfif isDefined("objectArea")>
				<i class="icon-info-sign more_info_img" id="openAreaImg" onclick="openAreaInfo()" title="Mostrar información del área"></i>
				<i class="icon-info-sign more_info_img" id="closeAreaImg" onclick="openAreaInfo()" title="Ocultar información del área" style="display:none;"></i>
				</cfif>
				<cfif app_version EQ "mobile">
					<a href="area.cfm?area=#area_id#" class="navbar_brand">#area_name#</a>
				<cfelse>
					<span class="navbar_brand">#area_name#</span>
				</cfif>
			<cfelse><!---Está en la raiz--->
				<!---<div style="height:35px;"><!-- --></div>--->
			</cfif>
			
			
			<ul class="nav pull-right">
			  
			 <cfif area_allowed EQ true>
			 
			 	<li <cfif curElement EQ "items">class="active"</cfif>><a href="area_items.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/area.png" title="Todos los elementos del área" alt="Todos los elementos del área" lang="es"/></a></li>
					
				<cfif APPLICATION.moduleWeb EQ true AND area_type EQ "web" OR area_type EQ "intranet">
					<li <cfif curElement EQ "entries">class="active"</cfif>><a href="entries.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/entry.png" title="Elementos de contenidos WEB del área" alt="Elementos e contenidos WEB del área" lang="es"/></a></li>
					
					<li <cfif curElement EQ "news">class="active"</cfif>><a href="newss.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/news.png" title="Noticias WEB del área" alt="Noticias WEB del área" lang="es"/></a></li>
					
					<cfif APPLICATION.identifier EQ "vpnet">
					<li <cfif curElement EQ "links">class="active"</cfif>><a href="links.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/link.png" title="Enlaces del área" alt="Enlaces del área" lang="es"/></a></li>
					</cfif>
					
				</cfif>
				
				<cfif APPLICATION.moduleWeb NEQ true OR len(area_type) IS 0>
				<li <cfif curElement EQ "messages">class="active"</cfif>><a href="messages.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/message.png" title="Mensajes del área" alt="Mensajes del área" lang="es"/></a></li>
				</cfif>
				
				<cfif APPLICATION.moduleWeb NEQ true OR len(area_type) IS 0 OR APPLICATION.identifier EQ "vpnet">
				<li <cfif curElement EQ "files">class="active"</cfif>><a href="files.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/file.png" title="Archivos del área" alt="Archivos del área" lang="es"/></a></li>
				</cfif>
				
				<cfif APPLICATION.identifier EQ "dp" OR (APPLICATION.moduleWeb EQ true AND area_type EQ "web" OR area_type EQ "intranet")><!---Events--->
					<li <cfif curElement EQ "events">class="active"</cfif>><a href="events.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/event.png" title="Eventos del área" alt="Eventos del área" lang="es"/></a></li>
				</cfif>
				
				<cfif APPLICATION.moduleWeb NEQ true OR len(area_type) IS 0>
				
					<cfif APPLICATION.identifier EQ "dp"><!---Tasks--->
						<li <cfif curElement EQ "tasks">class="active"</cfif>><a href="tasks.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/task.png" title="Tareas del área" alt="Tareas del área" lang="es"/></a></li>			
					</cfif>
					
					<cfif APPLICATION.moduleConsultations IS true>
						<li <cfif curElement EQ "consultations">class="active"</cfif>><a href="consultations.cfm?area=#area_id#" title="Interconsultas del área" lang="es"><i class="icon-exchange" style="font-size:25px; color:##0088CC"></i></a></li>			
					</cfif>
				
				</cfif>
				
				<cfif APPLICATION.moduleLists IS true><!--- Lists --->

					<li <cfif curElement EQ "tables">class="active"</cfif>><a href="lists.cfm?area=#area_id#" title="Listas del área" lang="es"><i class="icon-table" style="font-size:26px; color:##7A7A7A"></i></a></li>

				</cfif>

				<li <cfif curElement EQ "users">class="active"</cfif>><a href="users.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/users.png" title="Usuarios del área" alt="Usuarios del área" lang="es"/></a></li>
				
				<cfif APPLICATION.moduleMessenger EQ true>
				<li><a onclick="<cfif app_version EQ "standard">window.parent.</cfif>App.openMessenger('<cfif app_version EQ "standard" AND NOT (CGI.HTTP_USER_AGENT CONTAINS "MSIE")>../</cfif>messenger_area.cfm?area=#area_id#')" style="cursor:pointer;"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/messenger_general.png" title="Messenger del área" alt="Messenger del área" lang="es"/></a></li>
				</cfif>
				
				<cfif APPLICATION.identifier EQ "vpnet" AND app_version NEQ "mobile">						
				
				<li><a href="#APPLICATION.path#/#SESSION.client_abb#/meeting.cfm?type=2&area=#area_id#" target="_blank"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/area_meeting.png" title="Acceder a Reunión virtual del área (SOLO PCs)" alt="Acceder a Reunión virtual del área (SOLO PCs)" lang="es" /></a></li>
				<li><a href="#APPLICATION.path#/#SESSION.client_abb#/meeting.cfm?type=1&area=#area_id#" target="_blank"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/area_presentation.png" title="Acceder a Presentación virtual del área (SOLO PCs)" alt="Acceder a Presentación virtual del área (SOLO PCs)" lang="es"/></a></li>		
				<cfelseif app_version NEQ "mobile">
				
					<cfif APPLICATION.moduleVirtualMeetings IS true>
						<li><a href="#APPLICATION.path#/#SESSION.client_abb#/meeting.cfm?type=3&area=#area_id#" target="_blank"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/area_meeting.png" title="Acceder a reunión virtual del área" alt="Acceder a reunión virtual del área" lang="es"/></a></li>
					</cfif>
					
				</cfif>
									
			<cfelse><!---Sin acceso--->
			
				<li><a><img src="#APPLICATION.htmlPath#/assets/icons/message_disabled.png" title="No tiene acceso para ver los mensajes de este área" alt="Mensajes" lang="es"/></a></li>
				<li><a><img src="#APPLICATION.htmlPath#/assets/icons/file_disabled.png" title="No tiene acceso para ver los archivos de este área" alt="Archivos" lang="es"/></a></li>
				
				<cfif APPLICATION.identifier NEQ "vpnet">
					<li><a><img src="#APPLICATION.htmlPath#/assets/icons/event_disabled.png" title="No tiene acceso para ver los eventos de este área" alt="Eventos" lang="es"/></a></li>
					<li><a><img src="#APPLICATION.htmlPath#/assets/icons/task_disabled.png" title="No tiene acceso para ver las tareas de este área" alt="Tareas" lang="es"/></a></li>
				</cfif>
						
				<li><a><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/users_disabled.png" title="No tiene acceso para ver los usuarios de este área" alt="Usuarios" lang="es"/></a></li>	
				
			</cfif>
			  
			</ul>
		  </div>
		</div>
		
	
		<!---<cfif area_allowed EQ true>

			<cfif APPLICATION.identifier EQ "vpnet" AND app_version NEQ "mobile">			
			<div><a href="#APPLICATION.path#/#SESSION.client_abb#/meeting.cfm?type=1&area=#area_id#" target="_blank"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/area_presentation.png" title="Acceder a Presentación virtual del área (SOLO PCs)" alt="Acceder a Presentación virtual del área (SOLO PCs)" /></a></div>				
			
			<div><a href="#APPLICATION.path#/#SESSION.client_abb#/meeting.cfm?type=2&area=#area_id#" target="_blank"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/area_meeting.png" title="Acceder a Reunión virtual del área (SOLO PCs)" alt="Acceder a Reunión virtual del área (SOLO PCs)" /></a></div>	
			</cfif>
			
			<cfif APPLICATION.moduleMessenger EQ true>
			<div><a onclick="<cfif app_version EQ "standard">window.parent.</cfif>App.openMessenger('<cfif app_version EQ "standard" AND NOT (CGI.HTTP_USER_AGENT CONTAINS "MSIE")>../</cfif>messenger_area.cfm?area=#area_id#')" style="cursor:pointer;"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/messenger_general.png" title="Messenger del área" alt="Messenger del área" /></a></div>
			</cfif>
			
			<div <cfif curElement EQ "users">class="current"</cfif>><a href="users.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/users_dark.gif" title="Usuarios del área" alt="Usuarios del área" /></a></div>
			
			
			<cfif APPLICATION.identifier EQ "dp" AND (APPLICATION.moduleWeb NEQ true OR len(area_type) IS 0)><!---Tasks--->
				<div <cfif curElement EQ "tasks">class="current"</cfif>><a href="tasks.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/tasks.png" title="Tareas del área" alt="Tareas del área" /></a></div>			
			</cfif>
			
			<cfif APPLICATION.identifier EQ "dp" OR (APPLICATION.moduleWeb EQ true AND area_type EQ "web" OR area_type EQ "intranet")><!---Events--->
				<div <cfif curElement EQ "events">class="current"</cfif>><a href="events.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/events.png" title="Eventos del área" alt="Eventos del área" /></a></div>
			</cfif>
			
			<cfif APPLICATION.moduleWeb NEQ true OR len(area_type) IS 0 OR APPLICATION.identifier EQ "vpnet">
			<div <cfif curElement EQ "files">class="current"</cfif>><a href="files.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/files.png" title="Archivos del área" alt="Archivos del área"/></a></div>
			</cfif>
			
			<cfif APPLICATION.moduleWeb NEQ true OR len(area_type) IS 0>
			<div <cfif curElement EQ "messages">class="current"</cfif>><a href="messages.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/messages.png" title="Mensajes del área" alt="Mensajes del área"/></a></div>
			</cfif>
			
			
			<cfif APPLICATION.moduleWeb EQ true AND area_type EQ "web" OR area_type EQ "intranet">
			
				<cfif APPLICATION.identifier EQ "vpnet">
				<div <cfif curElement EQ "links">class="current"</cfif>><a href="links.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/links.png" title="Enlaces del área" alt="Enlaces del área" /></a></div>
				</cfif>
				
				<div <cfif curElement EQ "news">class="current"</cfif>><a href="newss.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/newss.png" title="Noticias WEB del área" alt="Noticias WEB del área" /></a></div>
				<div <cfif curElement EQ "entries">class="current"</cfif>><a href="entries.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/entries.png" title="Entradas WEB del área" alt="Entradas WEB del área" /></a></div>
				
			</cfif>	
			
		<cfelse>
			<div><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/users_dark_disabled.gif" title="No tiene acceso para ver los usuarios de este área" /></div>
			<div><img src="#APPLICATION.htmlPath#/assets/icons/files_disabled.png" title="No tiene acceso para ver los archivos de este área"/></div>
			<div><img src="#APPLICATION.htmlPath#/assets/icons/messages_disabled.png" title="No tiene acceso para ver los mensajes de este área" /></div>			
		</cfif>--->
	
	
	</cfif><!---END isDefined("area_id")--->
	
	
	
	
</div>

<div style="clear:both"><!-- --></div>

<cfif isDefined("area_id")>
	
	<cfif isDefined("objectArea")>
		<cfinclude template="#APPLICATION.htmlPath#/includes/area_menu_info.cfm">
	</cfif>


</cfif><!---END isDefined("area_id")--->

<div style="clear:both; height:2px;"></div>

</cfoutput>
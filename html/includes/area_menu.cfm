<!---
AQUÍ OBTIENE SI SE ESTÁ EN LA VERSIÓN standard o móvil
app_version almacena si es la versión móvil o la estandar--->
<cfif find("iframes",CGI.SCRIPT_NAME) GT 0>
	<cfset app_version = "standard">
<cfelse>
	<cfset app_version = "mobile">
</cfif>

<cfset curPage = getFileFromPath(CGI.SCRIPT_NAME)>
<cfset curElement = "">

<cfif isDefined("itemTypeId")>

	<cfswitch expression="#itemTypeId#">
		<cfcase value="1">
			<cfset curElement = "messages">
		</cfcase>
		
		<cfcase value="2">
			<cfset curElement = "entries">
		</cfcase>
		
		<cfcase value="3">
			<cfset curElement = "links">
		</cfcase>
		
		<cfcase value="4">
			<cfset curElement = "news">
		</cfcase>
		
		<cfcase value="5">
			<cfset curElement = "events">
		</cfcase>
		
		<cfcase value="5">
			<cfset curElement = "events">
		</cfcase>
		
		<cfcase value="6">
			<cfset curElement = "tasks">
		</cfcase>
		
	</cfswitch>
	
<cfelse>
	
	<cfif find("file",curPage) GT 0>
		<cfset curElement = "files">
	<cfelseif find("user",curPage) GT 0>
		<cfset curElement = "users">
	</cfif>
	
</cfif>


<cfoutput>

<div class="div_head_menu">
	
	<cfif isDefined("area_id")>
		
		<cfif NOT isDefined("area_allowed")>
			<!---area_allowed--->
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="canUserAccessToArea" returnvariable="area_allowed">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>
		</cfif>
		
		<cfif NOT isDefined("area_name")>
			<!---Esto es para las páginas de mensajes, archivos, usuarios (la mayoría de las páginas excepto la de navegación del arbol area.cfm) que no reciben estos valores--->
			
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>
			
			<cfset area_name = objectArea.name>
			
		</cfif>
		
		<!---area_type--->
		<cfif NOT isDefined("area_type")>
			<!---Esto es para las páginas de mensajes, archivos, usuarios (la mayoría de las páginas excepto la de navegación del arbol area.cfm) que no reciben este valor--->
			<!---El tipo de un área depende del tipo de las áreas superiores que tenga.--->
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getAreaType" returnvariable="area_type">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>
		</cfif>

		
	</cfif>
	
	<cfif isDefined("area_name")>
	<div class="div_img_area_menu">		
		<cfif area_allowed EQ true>
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
		</cfif>
		<cfif isDefined("objectArea")><img src="#APPLICATION.htmlPath#/assets/icons/open_info.png" class="more_info_img" id="openAreaImg" onclick="openAreaInfo()" alt="Mostrar información del área" title="Mostrar información del área"/><img src="#APPLICATION.htmlPath#/assets/icons/close_info.png" class="more_info_img" id="closeAreaImg" onclick="openAreaInfo()" alt="Ocultar información del área" title="Ocultar información del área" style="display:none;" /></cfif><img src="#APPLICATION.htmlPath#/assets/#area_image#" alt="Icono área" />
		
	</div>
	<div class="div_text_area_menu">
	<a href="area.cfm?area=#area_id#">#area_name#</a>
	</div>
	<cfelse><!---Está en la raiz--->
		<div style="height:35px;"><!-- ---></div>
	</cfif>
	
	<cfif isDefined("area_id")>
	
	<div class="div_imgs_area_menu">
	
		<cfif area_allowed EQ true>
				

			<cfif APPLICATION.identifier EQ "vpnet" AND app_version NEQ "mobile">			
			<div><a href="#APPLICATION.path#/#SESSION.client_abb#/meeting.cfm?type=1&area=#area_id#" target="_blank"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/area_presentation.png" title="Acceder a Presentación virtual del área (SOLO PCs)" alt="Acceder a Presentación virtual del área (SOLO PCs)" /></a></div>				
			
			<div><a href="#APPLICATION.path#/#SESSION.client_abb#/meeting.cfm?type=2&area=#area_id#" target="_blank"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/area_meeting.png" title="Acceder a Reunión virtual del área (SOLO PCs)" alt="Acceder a Reunión virtual del área (SOLO PCs)" /></a></div>	
			</cfif>
			
			<cfif APPLICATION.moduleMessenger EQ "enabled">
			<div><a onclick="<cfif app_version EQ "standard">window.parent.</cfif>App.openMessenger('<cfif app_version EQ "standard" AND NOT (CGI.HTTP_USER_AGENT CONTAINS "MSIE")>../</cfif>messenger_area.cfm?area=#area_id#')" style="cursor:pointer;"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/messenger_general.png" title="Messenger del área" alt="Messenger del área" /></a></div>
			</cfif>
			
			<div <cfif curElement EQ "users">class="current"</cfif>><a href="users.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/users_dark.gif" title="Usuarios del área" alt="Usuarios del área" /></a></div>
			
			
			<cfif APPLICATION.identifier EQ "dp" AND (APPLICATION.moduleWeb NEQ "enabled" OR len(area_type) IS 0)><!---Tasks--->
				<div <cfif curElement EQ "tasks">class="current"</cfif>><a href="tasks.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/tasks.png" title="Tareas del área" alt="Tareas del área" /></a></div>			
			</cfif>
			
			<cfif APPLICATION.identifier EQ "dp" OR (APPLICATION.moduleWeb EQ "enabled" AND area_type EQ "web" OR area_type EQ "intranet")><!---Events--->
				<div <cfif curElement EQ "events">class="current"</cfif>><a href="events.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/events.png" title="Eventos del área" alt="Eventos del área" /></a></div>
			</cfif>
			
			<cfif APPLICATION.moduleWeb NEQ "enabled" OR len(area_type) IS 0 OR APPLICATION.identifier EQ "vpnet">
			<div <cfif curElement EQ "files">class="current"</cfif>><a href="files.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/files.png" title="Archivos del área" alt="Archivos del área"/></a></div>
			</cfif>
			
			<cfif APPLICATION.moduleWeb NEQ "enabled" OR len(area_type) IS 0>
			<div <cfif curElement EQ "messages">class="current"</cfif>><a href="messages.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/messages.png" title="Mensajes del área" alt="Mensajes del área"/></a></div>
			</cfif>
			
			
			<cfif APPLICATION.moduleWeb EQ "enabled" AND area_type EQ "web" OR area_type EQ "intranet">
			
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
		</cfif>
	
	</div>
	
	<cfif isDefined("objectArea")>
		<div id="areaInfo" class="more_info_content">
			<!---<div class="div_message_page_label" style="font-weight:bold;">Datos del área:</div>--->
			<cfif area_type NEQ "">
			<cfif area_type IS "web" OR area_type IS "intranet" AND (area_name NEQ "INTRANET" AND area_name NEQ "WEB PÚBLICA")><!---Las áreas raiz de web e intranet no tienen página, y se detectan porque parent_area_id no está definido (no es numérico)--->
				<div class="button_web" style="float:right; padding:4px;"><a href="#APPLICATION.path#/#area_type#/page.cfm?id=#area_id#" target="_blank" class="link_web">&nbsp;Ver área en #area_type#&nbsp;</a></div>
			</cfif>
			<div class="div_message_page_label">
			Tipo de área: <span class="text_message_page">#UCase(area_type)#</span>
			</div>
			</cfif>
			<div class="div_message_page_label">
			Responsable: <span class="text_message_page">#objectArea.user_full_name#</span>
			</div>
			<div class="div_message_page_label">
			Fecha de creación: <span class="text_message_page">#objectArea.creation_date#</span>
			</div>
			<div class="div_message_page_label">
			Descripcion:</div>
			<div class="div_message_page_description"><cfif len(objectArea.description) GT 0>#objectArea.description#<cfelse><i>No hay descripción del área</i></cfif></div>
		</div>
	</cfif>
	
	</cfif><!---END isDefined("area_id")--->
	<div style="clear:both"></div>
	
</div>
</cfoutput>
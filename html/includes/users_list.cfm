<!---Required vars
	page_type
	
	page_types:
		1 Usuarios de un área
			area_id required
		2 Contactos de un usuario
		3 Seleccionar usuarios
		4 Seleccionar contactos
--->

<cfset response_page = "">
<cfset selected = "">
<cfset subject = "">
<cfset content = "">
<cfif page_type IS 3 OR page_type IS 4>
	<cfif isDefined("URL.page")>
		<cfset response_page = URL.page>
		
		<cfif isDefined("URL.sel")>
			<cfset selected = URL.sel>
		</cfif>
		
		<cfif isDefined("URL.content")>
			<cfset content = URL.content>
		</cfif>
		
		<cfif isDefined("URL.subject")>
			<cfset subject = URL.subject>
		</cfif>
		
	<cfelse>
		<cflocation url="index.cfm" addtoken="no">
	</cfif>
</cfif>

<cfset current_page = CGI.SCRIPT_NAME>

<cfswitch expression="#page_type#">
	<cfcase value="1">
		<cfset getComponent = "Area">
		<cfset getMethod = "getAreaMembers">
		<cfset current_page = current_page&"?area="&URL.area>
	</cfcase>
	<cfcase value="2">
		<cfset getComponent = "User">
		<cfset getMethod = "getUserContacts">
		<cfset current_page = current_page&"?sel=">
	</cfcase>
	<cfcase value="3">
		<cfset getComponent = "User">
		<cfset getMethod = "getUsers">
		<cfset current_page = current_page&"?sel="&URL.sel&"&page=#response_page#&content=#content#&subject=#subject#">
	</cfcase>
	<cfcase value="4">
		<cfset getComponent = "User">
		<cfset getMethod = "getUserContacts">
		<cfset current_page = current_page&"?sel="&URL.sel&"&page=#response_page#&content=#content#&subject=#subject#">
	</cfcase>
</cfswitch>

<cfset order_by = "">
<cfset order_type = "asc">
<cfif isDefined("URL.order_by")>
	<cfif URL.order_by EQ "name" OR URL.order_by EQ "family_name">
		<cfset order_by = URL.order_by>
	</cfif>
	
	<cfif isDefined("URL.order_type")>
		<cfif URL.order_type EQ "asc" OR URL.order_type EQ "desc">
			<cfset order_type = URL.order_type>
		</cfif>
	</cfif>
</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/#getComponent#" method="#getMethod#" returnvariable="xmlResponse">	
	<cfif page_type IS 1>
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfif>
	<cfinvokeargument name="order_by" value="#order_by#">
	<cfinvokeargument name="order_type" value="#order_type#">
</cfinvoke>

<cfif page_type IS 1 OR page_type IS 3>
	<cfxml variable="xmlUsers">
			<cfoutput>
			#xmlResponse.response.result.users#
			</cfoutput>
	</cfxml>
	<cfset numUsers = ArrayLen(xmlUsers.users.XmlChildren)>
<cfelse>

	<cfxml variable="xmlUsers">
		<cfoutput>
		#xmlResponse.response.result.contacts#
		</cfoutput>
	</cfxml>
	<cfset numUsers = ArrayLen(xmlUsers.contacts.XmlChildren)>

</cfif>

<cfif response_page EQ "notifications.cfm">
	<cfinclude template="#APPLICATION.htmlPath#/includes/notifications_head.cfm">
<cfelseif response_page EQ "sms.cfm">
	<cfinclude template="#APPLICATION.htmlPath#/includes/sms_head.cfm">
</cfif>

<cfif page_type IS 3>
<div class="div_head_subtitle">
Selección de usuarios
</div>
<cfelseif page_type IS 4>
<div class="div_head_subtitle">
Selección de contactos
</div>
</cfif>

<div class="div_users">
<cfif numUsers GT 0>
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="userListHeader">
		<cfinvokeargument name="current_page" value="#current_page#">
		<cfinvokeargument name="order_by" value="#order_by#">
		<cfinvokeargument name="order_type" value="#order_type#">
</cfinvoke>
<cfif page_type IS 3 OR page_type IS 4>	
<cfoutput>
<form name="select_users" action="#response_page#?sel=#selected#&content=#content#&subject=#subject#" method="post">
</cfoutput>

	<div><input type="submit" class="btn btn-primary" value="Continuar" /></div>
</cfif>
	<cfif page_type IS 1><!---Usuarios de un área--->
		<cfloop index="xmlIndex" from="1" to="#numUsers#" step="1">
			
			<!---<cfif xmlIndex IS 1>
				<!---Esta acción solo se completa si está en la versión HTML2--->
				<cfoutput>
				<script type="text/javascript">
					openUrlHtml2('area_user.cfm?area=#area_id#&user=#xmlUsers.users.user[xmlIndex].xmlAttributes.id#','itemIframe');
				</script>
				</cfoutput>						
			</cfif>--->
			
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUserList">
					<cfinvokeargument name="xmlUser" value="#xmlUsers.users.user[xmlIndex]#">
					<cfinvokeargument name="page_type" value="#page_type#">
					<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>	
			
		</cfloop>
	<cfelseif page_type IS 3>
		<cfloop index="xmlIndex" from="1" to="#numUsers#" step="1">
			
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUserList">
					<cfinvokeargument name="xmlUser" value="#xmlUsers.users.user[xmlIndex]#">
					<cfinvokeargument name="page_type" value="#page_type#">
			</cfinvoke>	
			
		</cfloop>
	<cfelse>
		<cfloop index="xmlIndex" from="1" to="#numUsers#" step="1">
			
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUserList">
					<cfinvokeargument name="xmlUser" value="#xmlUsers.contacts.user[xmlIndex]#">
					<cfinvokeargument name="page_type" value="#page_type#">
					<cfinvokeargument name="contact_format" value="true">
			</cfinvoke>	
			
		</cfloop>
	</cfif>
<cfif page_type IS 3 OR page_type IS 4>
	<div><input type="submit" class="btn btn-primary" value="Continuar" /></div>
	
</form>	
</cfif>
<cfelse>
	<cfif page_type IS 1 OR page_type IS 3>
		No hay usuarios.
	<cfelse>
		No tiene ningún contacto introducido.
	</cfif>
</cfif>
</div>
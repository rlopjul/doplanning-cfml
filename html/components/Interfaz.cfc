<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 07-10-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 12-12-2008
	
--->
<cfcomponent output="true">

	<cfset component = "Interfaz">
	
	<!---
	includes/alert_message.cfm
	<cffunction name="messageElement" returntype="void" access="public">
		
		<cfset var method = "messageElement">
		
		<cfif isDefined(URL.message)>
		
			<cfset message = URL.message>
			<cfoutput>
				<div class="div_alert_message">
					#message#
				</div>
			</cfoutput>
			
		</cfif>
		
		<cftry>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>--->
	
	
	<cffunction name="returnElement" returntype="void" access="public">
		<cfargument name="return_page" type="string" required="true">
		
		<cfset var method = "returnElement">
		
		<cfoutput>
			<div class="div_return">
				<a href="#arguments.return_page#" class="a_return"><img src="#APPLICATION.htmlPath#/assets/icons/return.gif" title="Volver" alt="Volver" />
				Volver</a>
			</div>
		</cfoutput>
		
		<cftry>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		

	</cffunction>
	
	<cffunction name="goUpElement" returntype="void" access="public">
		<cfargument name="return_page" type="string" required="true">
		
		<cfset var method = "goUpElement">
		
		<cfoutput>
			<div class="div_return">
				<a href="#arguments.return_page#" class="a_return">Subir</a>
			</div>
		</cfoutput>
		
		<cftry>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		

	</cffunction>
	
	
	<cffunction name="userListHeader" returntype="void" access="public">
		<cfargument name="current_page" type="string" required="true">
		<cfargument name="order_by" type="string" required="true">
		<cfargument name="order_type" type="string" required="true">
		
		<cfset var method = "userListHeader">
		
		<cfset family_name_order_type = "asc">
		<cfset name_order_type = "desc">

		<cfif order_by EQ "family_name">
			<cfset name_order_type = "asc">
			<cfif order_type EQ "asc">
				<cfset family_name_order_type = "desc">
			<cfelse>
				<cfset family_name_order_type = "asc">
			</cfif>
		<cfelseif order_by EQ "name">
			<cfif order_type EQ "asc">
				<cfset name_order_type = "desc">
			<cfelse>
				<cfset name_order_type = "asc">
			</cfif>
		</cfif>
		<!---<cfif order_type EQ "asc">
			<cfset new_order_type = "desc">
		<cfelse>
			<cfset new_order_type = "asc">
		</cfif>--->
		
		<cfoutput>
			<div class="div_separator"><!-- --></div>
			<div class="div_users_header">
<!--				<div class="div_checkbox_users_header"><!---<input type="checkbox" class="checkbox_users_header"/>---></div>	-->
				<div class="div_user_right">		
					<div class="div_text_user_name"><span class="texto_normal" style="font-weight:bold;">Ordenar por:</span> <a href="#arguments.current_page#&order_by=family_name&order_type=#family_name_order_type#" class="texto_normal">Nombre</a> <a href="#arguments.current_page#&order_by=name&order_type=#name_order_type#" class="texto_normal">Apellido</a></div>
					<div class="div_text_user_email"></div><div class="div_text_user_mobile"></div>
				</div>
			</div>		
			<div class="div_separator"><!-- --></div>
		</cfoutput>
		
		<cftry>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		

	</cffunction>
	
</cfcomponent>
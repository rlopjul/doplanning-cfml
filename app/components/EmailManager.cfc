<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 27-10-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 10-06-2013
	
	26-09-2012 alucena: añadido port="#APPLICATION.emailServerPort#"
	21-05-2013 alucena: modificado sendEmail para enviar a través de la API de Mandrill
	29-05-2013 alucena: quitado head_content, no se usa en esta versión	
--->
<cfcomponent output="false">

	<cfset component = "EmailManager">
	
	<!--- ----------------------- SEND EMAIL -------------------------------- --->
	
	<cffunction name="sendEmail" access="public" returntype="void">
		<cfargument name="from" type="string" required="yes">
		<cfargument name="from_name" type="string" required="false">
		<cfargument name="to" type="string" required="yes">
		<cfargument name="bcc" type="string" required="no" default="">
		<cfargument name="subject" type="string" required="yes">
		<cfargument name="content" type="string" required="yes">
		<cfargument name="head_content" type="string" required="no">
		<cfargument name="foot_content" type="string" required="no">
		<cfargument name="styles" type="boolean" required="no" default="true">
		
		<cfset var method = "sendEmail">

		<cfinvoke component="#APPLICATION.coreComponentsPath#/EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="#arguments.from#">
			<cfinvokeargument name="from_name" value="#arguments.from_name#">
			<cfinvokeargument name="to" value="#arguments.to#">
			<cfinvokeargument name="bcc" value="#arguments.bcc#">
			<cfinvokeargument name="subject" value="#arguments.subject#">
			<cfinvokeargument name="content" value="#arguments.content#">
			<cfinvokeargument name="head_content" value="#arguments.head_content#">
			<cfinvokeargument name="foot_content" value="#arguments.foot_content#">
			<cfinvokeargument name="styles" value="#arguments.styles#">
		</cfinvoke>
		

	</cffunction>
	
	
	<!--- ----------------------- SEND NOTIFICATION -------------------------------- --->
	
	<cffunction name="sendNotification" returntype="String" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
		<!---<cfargument name="from" type="string" required="yes">
		<cfargument name="to" type="string" required="yes">	
		<cfargument name="subject" type="string" required="yes">	
		<cfargument name="text" type="string" required="yes">
		<cfargument name="html" type="string" required="yes">--->
		
		<cfset var method = "sendNotification">
		
		<cfset var from = "">
		<cfset var to = "">
		<cfset var subject = "">
		<cfset var text = "">
		<cfset var html = "">
						
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<!---check if the user logged in already exist--->
			<cfquery name="checkUser" datasource="#client_dsn#">
				SELECT * FROM #client_abb#_users
				WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			<cfif checkUser.recordCount IS 0><!---The user does not exist--->
				<cfset error_code = 204>
				
				<cfthrow errorcode="#error_code#"> 
			</cfif>
			
			<!---<cfset from = xmlRequest.request.parameters.notification.xmlAttributes.from>--->
			<!---Obtener el nombre del usuario que lo envia y ponerlo en el from--->
			<!---<cfset from = user_id>--->
			<cfset from = checkUser.family_name&" "&checkUser.name>
			<cfset to = xmlRequest.request.parameters.notification.xmlAttributes.recipients>
			<cfset subject = xmlRequest.request.parameters.notification.subject.xmlText>
			<cfset html_text = xmlRequest.request.parameters.notification.html_text.xmlText>
			
			<cfif len(html_text) GT 0>
		
				<cfset html_text = REReplace(html_text,'[[:space:]]SIZE="',' style="font-size:',"ALL")>

			</cfif>
			
			<cfset email_type = "html">	
			<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">No responda a este email.<br />Este email ha sido enviado mediante la aplicación #APPLICATION.title#.</p>'>			
			
			<cfinvoke component="EmailManager" method="sendEmail">
				<cfinvokeargument name="from" value="#SESSION.client_email_from#">
				<cfinvokeargument name="to" value="#to#">
				<cfinvokeargument name="subject" value="<#from#> #subject#">
				<cfinvokeargument name="content" value="#html_text#">
				<cfinvokeargument name="foot_content" value="#foot_content#">
				<cfinvokeargument name="styles" value="false">
			</cfinvoke>			 
			
			<cfset xmlResponseContent = '<notification from="#from#" recipients="#to#"/>'>
		
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
		
	</cffunction>
	
	
</cfcomponent>
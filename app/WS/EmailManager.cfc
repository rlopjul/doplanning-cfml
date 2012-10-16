<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 27-10-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 26-09-2012
	
	26-09-2012 alucena: añadido port="#APPLICATION.emailServerPort#"
	
--->
<cfcomponent output="false">

	<cfset component = "EmailManager">
	
	<!--- ----------------------- SEND EMAIL -------------------------------- --->
	
	<cffunction name="sendEmail" access="public" returntype="void">
		<cfargument name="from" type="string" required="yes">
		<cfargument name="to" type="string" required="yes">
		<cfargument name="bcc" type="string" required="no" default="">
		<cfargument name="subject" type="string" required="yes">
		<cfargument name="content" type="string" required="yes">
		<!---<cfargument name="head_content" type="string" required="no">--->
		<cfargument name="foot_content" type="string" required="no">
		<cfargument name="styles" type="boolean" required="no" default="true">
		<cfargument name="file_source" type="string" required="no">
		<!---<cfargument name="file_name" type="string" required="no">--->
		
		<cfset var method = "sendEmail">
		
		<!---<cfinclude template="includes/functionStartOnlySession.cfm">--->
		
		<cfset head_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;"><span style="color:##FF0000; font-size:12px;">No responda a este email.</span><br />Este email ha sido enviado mediante la aplicación #APPLICATION.title#.</p>'>
		
		<cfprocessingdirective suppresswhitespace="yes">
	<cfsavecontent variable="email_content">
	<!--Este mensaje está en formato HTML, si usted lee esto significa que su cliente de correo no le está mostrando el mensaje en dicho formato, por lo que no lo podrá ver correctamente--><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<cfif styles EQ true><style type="text/css">
<!--
body {
	<cfif APPLICATION.identifier EQ "dp">
	background-color:#FFFFFF;
	<!---background-color:#EEEEEE;--->
	color:#333333;
	<cfelse>
	background-color:#FFFFFF;
	color:#000000;
	</cfif>
	font-family:Verdana, Arial, Helvetica, sans-serif;
	font-size:12px;
}
-->
</style></cfif>
</head>
<body>
<cfoutput>
<cfif isDefined("head_content")>#head_content#<hr /><br /></cfif>
#arguments.content#
<cfif isDefined("arguments.foot_content")><br /><hr />#arguments.foot_content#</cfif>
</cfoutput>
</body>
</html>
	</cfsavecontent>
	
	<cfif APPLICATION.identifier EQ "dp">
	
		<cfif isDefined("SESSION.client_email_support")>
			<cfset email_failto = SESSION.client_email_support>
		<cfelse>
			<cfset email_failto = APPLICATION.emailFail>
		</cfif>
	
		<cfmail server="#APPLICATION.emailServer#" username="#APPLICATION.emailServerUserName#" password="#APPLICATION.emailServerPassword#" failto="#email_failto#" type="html" from="#arguments.from#" to="#arguments.to#" bcc="#arguments.bcc#" subject="#arguments.subject#" charset="utf-8" port="#APPLICATION.emailServerPort#">#email_content#</cfmail>
		
		<!---<cfinvoke webservice="http://195.34.71.223/apps/Era7SendEmail.cfc?wsdl" method="sendEmail" returnvariable="sendResult">
			<cfinvokeargument name="user" value="#hash('doplanning')#">
			<cfinvokeargument name="password" value="#hash('X6zklja56a0za65f')#">
			<cfinvokeargument name="serverUserName" value="#APPLICATION.emailServerUserName#">
			<cfinvokeargument name="serverPassword" value="#APPLICATION.emailServerPassword#">
			<cfinvokeargument name="from" value="#arguments.from#">
			<cfinvokeargument name="to" value="#arguments.to#">
			<cfinvokeargument name="bcc" value="#arguments.bcc#">
			<cfinvokeargument name="failto" value="#email_failto#">
			<cfinvokeargument name="subject" value="#arguments.subject#">
			<cfinvokeargument name="content" value="#email_content#">
			<cfinvokeargument name="file_path" value="">
		</cfinvoke>--->
	
	
	<cfelseif APPLICATION.identifier EQ "vpnet">

		<cfhttp url="#APPLICATION.mainUrl##APPLICATION.resourcesPath#/sendMail.jsp" method="post" result="pageResponse">				        <cfhttpparam name="email_from" type="formfield" value="#arguments.from#">
			<cfhttpparam name="email_to" type="formfield" value="#arguments.to#">
			<cfhttpparam name="email_bcc" type="formfield" value="#arguments.bcc#">
			<!---<cfhttpparam name="email_replyto" type="formfield" value="">--->
			<cfif isDefined("SESSION.client_email_support")>
				<cfhttpparam name="email_failto" type="formfield" value="#SESSION.client_email_support#">
			<cfelse>
				<cfhttpparam name="email_failto" type="formfield" value="#APPLICATION.emailFail#">
			</cfif>
			<cfhttpparam name="email_subject" type="formfield" value="#arguments.subject#">
			<cfhttpparam name="email_content" type="formfield" value="#email_content#">	
		</cfhttp>
		
		<cfset xmlResult = XmlParse(Trim(pageResponse.FileContent))>
		
		<cfif isDefined("xmlResult.response.xmlAttributes.status")>
			<cfif xmlResult.response.xmlAttributes.status NEQ "ok">
				<cfset error_code = 1302>
				<cfset error_message = xmlResult.response.error.title.xmlText>
				
				<cfthrow errorcode="#error_code#" message="#error_message# #xmlResult#">
			</cfif>
		<cfelse>
		
			<cfset error_code = 1302>
				
			<cfthrow errorcode="#error_code#" message="#xmlResult#">
		
		</cfif>
		
	</cfif>

	
</cfprocessingdirective>
	</cffunction>
	
	
	<!--- ----------------------- SEND NOTIFICATION -------------------------------- --->
	
	<cffunction name="sendNotification" returntype="String" output="false" access="remote">		
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
<!--- Copyright Era7 Information Technologies 2007-2015 --->
<cfcomponent output="false">

	<cfset component = "EmailManager">

	<!--- ----------------------- SEND EMAIL -------------------------------- --->

	<cffunction name="sendEmail" access="public" returntype="void">
		<cfargument name="from" type="string" required="yes">
		<cfargument name="from_name" type="string" required="false">
		<cfargument name="to" type="string" required="yes">
		<cfargument name="bcc" type="string" required="no">
		<cfargument name="subject" type="string" required="yes">
		<cfargument name="content" type="string" required="yes">
		<cfargument name="head_content" type="string" required="false">
		<cfargument name="foot_content" type="string" required="false">
		<cfargument name="styles" type="boolean" required="no" default="true">
		<cfargument name="attachment_type" type="string" required="false">
		<cfargument name="attachment_name" type="string" required="false">
		<cfargument name="attachment_content" type="string" required="false">

		<cfset var toEmails = "">
		<cfset var jsonFields = "">
		<cfset var jsonBody = "">
		<cfset var fromName = "">
		<cfset var responseResult = "">
		<cfset var attachmentbase64Value = "">

		<!--- <cfset head_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;"><span style="color:##FF0000; font-size:12px;">No responda a este email.</span><br />Este email ha sido enviado mediante la aplicación #APPLICATION.title#.</p>'> --->

<cfprocessingdirective suppresswhitespace="yes">
	<cfsavecontent variable="email_content">
	<!--Este mensaje está en formato HTML, si usted lee esto significa que su cliente de correo no le está mostrando el mensaje en dicho formato, por lo que no lo podrá ver correctamente--><!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<cfif styles EQ true><style type="text/css">
<!--
@import url(http://fonts.googleapis.com/css?family=Roboto);

body {
	color:#666666;
	font-family: 'Roboto', sans-serif;
	font-size:13px;
}
-->
</style></cfif>
<!---
<cfif APPLICATION.identifier EQ "dp">
background-color:#FFFFFF;
color:#333333;
<cfelse>
background-color:#FFFFFF;
color:#000000;
</cfif>
font-family:Verdana, Arial, Helvetica, sans-serif;--->
</head>
<body style="color:#666666;font-family:'Roboto', sans-serif;font-size:12px;">
<cfoutput>
<cfif isDefined("arguments.head_content")>#head_content#</cfif>
#arguments.content#
<cfif isDefined("arguments.foot_content")><br />#arguments.foot_content#</cfif>
<cfif APPLICATION.includeLegalTextInAlerts IS true>
	<p style="font-family:'Roboto',sans-serif;font-size:10px">Según lo previsto en la Ley 34/2002 de Servicios de la Sociedad de la Información y de Comercio Electrónico, así como en la Ley Orgánica 15/1999 del 13 de Diciembre, de Protección de Datos de Carácter Personal, le informamos que su dirección de correo electrónico figura en nuestros archivos automatizados, al objeto exclusivamente de remitirle información sobre servicios y actividades promovidas por #APPLICATION.title#. Usted puede en cualquier momento ejercitar su derecho de acceder, rectificar y en su caso, cancelar sus datos personales en el email #APPLICATION.emailReply# e indicándonos la operación a realizar.</p>
</cfif>
</cfoutput>
</body>
</html>
	</cfsavecontent>

	<cfif APPLICATION.identifier EQ "dp">

		<cfif isDefined("arguments.from_name") AND arguments.from_name NEQ APPLICATION.title>
			<cfset fromName = "#APPLICATION.title#-#arguments.from_name#">
		<cfelse>
			<cfset fromName = APPLICATION.title>
		</cfif>

		<cfif APPLICATION.emailSendMode EQ "SMTP">

			<!---<cfif isDefined("SESSION.client_email_support")>
				<cfset email_failto = SESSION.client_email_support>
			<cfelse>
				<cfset email_failto = APPLICATION.emailFail>
			</cfif>--->

			<cfset fullFrom = '"#fromName#" <#APPLICATION.emailFrom#>'>

			<cfif len(APPLICATION.emailServerUserName) IS NOT 0><!---With authentication--->

				<cfif APPLICATION.emailServerPort EQ 465><!--- SSL --->

					<cfmail server="#APPLICATION.emailServer#" username="#APPLICATION.emailServerUserName#" password="#APPLICATION.emailServerPassword#" type="html" from="#fullFrom#" to="#arguments.to#" bcc="#arguments.bcc#" subject="#arguments.subject#" charset="utf-8" port="#APPLICATION.emailServerPort#" useSSL="true">#email_content#</cfmail>

				<cfelse>

					<cfmail server="#APPLICATION.emailServer#" username="#APPLICATION.emailServerUserName#" password="#APPLICATION.emailServerPassword#" type="html" from="#fullFrom#" to="#arguments.to#" bcc="#arguments.bcc#" subject="#arguments.subject#" charset="utf-8" port="#APPLICATION.emailServerPort#">#email_content#</cfmail><!---failto="#email_failto#"--->

				</cfif>

			<cfelse><!---Without authentication--->

				<cfmail server="#APPLICATION.emailServer#" type="html" from="#fullFrom#" to="#arguments.to#" bcc="#arguments.bcc#" subject="#arguments.subject#" charset="utf-8" port="#APPLICATION.emailServerPort#">#email_content#</cfmail><!---from="#arguments.from#" failto="#email_failto#"--->

			</cfif>


		<cfelse><!---Send emails by Mandrill API--->

			<cfset toEmails = arrayNew()>

			<cfif len(arguments.to) GT 0 AND arguments.to NEQ APPLICATION.emailFalseTo>

				<cfloop list="#arguments.to#" index="toEmail" delimiters=";">

					<cfset arrayAppend(toEmails, {"email":"#toEmail#"})>

				</cfloop>

			</cfif>

			<cfif len(arguments.bcc) GT 0>

				<cfloop list="#arguments.bcc#" index="bccEmail" delimiters=";">

					<cfset arrayAppend(toEmails, {"email":"#bccEmail#"})>

				</cfloop>

			</cfif>

			<cfif arrayLen(toEmails) IS 0><!---Unexpected error--->
				<cfthrow errorcode="10000">
			</cfif>

			<cfset jsonFields = {

				"key": "#APPLICATION.emailServerPassword#",
				"message": {
					"html": "#email_content#",
					"subject": "#arguments.subject#",
					"from_email": "#APPLICATION.emailFrom#",
					"from_name": "#fromName#",
					"to": #toEmails#,
					"important": false,
					"track_opens": false,
					"track_clicks": false,
					"auto_text": false,
					"auto_html": false,
					"inline_css": false,
					"url_strip_qs": false,
					"preserve_recipients": false,
				},
				"async": true
			}>

			<cfif isDefined("arguments.attachment_content")>

       			<cfset attachmentbase64Value = binaryEncode(arguments.attachment_content.getBytes("UTF-8"),"base64")/>

				<cfset jsonFields.message.attachments = [
		            {
		                "type": "#arguments.attachment_type#",
		                "name": "#arguments.attachment_name#",
		                "content": "#attachmentbase64Value#"
		            }
	        	]>

			</cfif>


			<!---"to": [
				{
					"email": ""
				},
				{
					"email": ""
				}
			],

			"headers": {
				"Reply-To": "#APPLICATION.emailReply#"
			},--->


			<!--- Bug with Mandrill and special chars: https://parse.com/questions/sometimes-getting-mandrill-you-must-specify-a-key-value-error-when-sending-email --->

			<!---<cfset jsonBody = reReplace(serializeJSON(jsonFields),"[^\x00-\x7F]","","ALL")>--->
			<cfset jsonBody = serializeJSON(jsonFields)>

			<cfloop from="1" to="3" index="curAttempt">

				<cftry>

					<cfif APPLICATION.proxy IS true><!---With proxy--->

						<cfhttp method="post" url="https://mandrillapp.com/api/1.0/messages/send.json" proxyServer="10.104.1.7" proxyPort="8080" result="responseResult" charset="utf-8" timeout="56">
							<cfhttpparam type="header" name="Content-Type" value="application/json; charset=utf-8" />
							<cfhttpparam type="body" value="#jsonBody#">
						</cfhttp>

					<cfelse>

						<cfhttp method="post" url="https://mandrillapp.com/api/1.0/messages/send.json" result="responseResult" charset="utf-8" timeout="56">
							<cfhttpparam type="header" name="Content-Type" value="application/json; charset=utf-8" />
							<cfhttpparam type="body" value="#jsonBody#">
						</cfhttp>

						<!---
						<cfdump var="#jsonBody#">
						<cfdump var="#responseResult#"><cfabort>
						--->

					</cfif>

					<cfset mandrillResponse = deserializeJSON(responseResult.filecontent)>

					<cfbreak>

					<cfcatch>

						<cfif curAttempt GT 2><!--- API CONNECTION ERROR --->

							<cfset fullFrom = '"#fromName#" <#APPLICATION.emailFrom#>'>

							<!---<cfmail server="#APPLICATION.emailServer#" username="#APPLICATION.emailServerUserName#" password="#APPLICATION.emailServerPassword#" type="html" from="#fullFrom#" to="#arguments.to#" bcc="#arguments.bcc#" subject="#arguments.subject#" charset="utf-8" port="#APPLICATION.emailServerPort#">#email_content#</cfmail>--->

							<cfthrow message="Error al conectar con el servicio de envío de emails, no se ha enviado notificación por email a los usuarios. Por favor, inténtelo de nuevo. #cfcatch.message#"/>

						<cfelse>
							<cfset sleep(300)>
						</cfif>

					</cfcatch>

				</cftry>

			</cfloop>

			<cfif isDefined("responseResult") AND isDefined("mandrillResponse") AND responseResult.status_code NEQ 200>

				<cfthrow errorcode="1302" message="#mandrillResponse.message#">

			</cfif>

		</cfif>


	<cfelseif APPLICATION.identifier EQ "vpnet"><!--- VPNET --->


		<cfhttp url="#APPLICATION.mainUrl##APPLICATION.resourcesPath#/sendMail.jsp" method="post" result="pageResponse">
			<cfhttpparam name="email_from" type="formfield" value="#arguments.from#">
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

</cfcomponent>

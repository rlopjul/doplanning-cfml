<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>

<!---<cfscript>
sysObj = CreateObject("java", "java.lang.System");
sysObj.setProperty("mail.host", "10.72.32.24");
</cfscript>
--->
<!---<cfmail from="julior.lopez.sspa@juntadeandalucia.es" to="alucena@era7.com" subject="Prueba">
Hola, esto es una prueba de la aplicación
</cfmail>--->
<cfhttp url="#APPLICATION.mainUrl##APPLICATION.resourcesPath#/sendMail.jsp" method="post" result="pageResponse">
		<cfhttpparam name="email_from" type="formfield" value="support@era7.com">	
		<cfhttpparam name="email_to" type="formfield" value="alucena@era7.com">
		<cfhttpparam name="email_bcc" type="formfield" value="">
		<!---<cfhttpparam name="email_replyto" type="formfield" value="">--->
		<cfhttpparam name="email_failto" type="formfield" value="alucena@era7.com">
		<cfhttpparam name="email_subject" type="formfield" value="Prueba">
		<cfhttpparam name="email_content" type="formfield" value="Contenido">	
	</cfhttp>
	
Contenido:
<cfoutput>
#pageResponse.FileContent#
</cfoutput>

	<cfset xmlResult = XmlParse(Trim(pageResponse.FileContent))>
	
	<cfif xmlResult.response.xmlAttributes.status NEQ "ok">
		<cfset error_code = 1302>

		<cfthrow errorcode="#error_code#">
	</cfif>
<cfoutput>
<textarea>
#xmlResult#
</textarea>
</cfoutput>

</body>
</html>

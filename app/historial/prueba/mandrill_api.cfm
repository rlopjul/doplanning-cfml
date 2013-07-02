<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>

<!---<cfhttp method="post" url="https://mandrillapp.com/api/1.0/users/ping.json" result="resultVar">
	<cfhttpparam name="key" value="#APPLICATION.emailServerPassword#" type="formfield">
</cfhttp>--->

<!---<cfhttp method="post" url="https://mandrillapp.com/api/1.0/users/senders.json" result="resultVar" >
	<cfhttpparam name="key" value="#APPLICATION.emailServerPassword#" type="formfield">
</cfhttp>--->

<!---<cfset jsonFields = {
     "key" = "#APPLICATION.emailServerPassword#"
}>   

<cfhttp method="post" url="https://mandrillapp.com/api/1.0/users/senders.json" result="resultVar">
	<cfhttpparam type="header" name="Content-Type" value="application/json" />
    <cfhttpparam type="body" value="#serializeJSON(jsonFields)#">
</cfhttp>

<cfdump var="#resultVar#">

<cfset responseResult = deserializeJSON(resultVar.filecontent)>

<cfdump var="#responseResult#">--->


<!---<cfset message = structNew()>

<cfset message.html = "<strong>HOLA!</strong>">
<cfset message.subject = "Probando API Mandrill">
<cfset message.from_email = "doplanning@era7bioinformatics.com">
<cfset message.from_name = "DoPlanning Era7 Bioinformatics">
<cfset message_to = arrayNew()>
<cfset message_to_1 = structNew()>
<cfset message_to_1.email = "alucena@era7.com">
<cfset arrayAppend(message_to,message_to_1)>
<cfset message.to = message_to>
<cfset message.preserve_recipients = "false">


<cfhttp method="post" url="https://mandrillapp.com/api/1.0/messages/send.json" result="resultVar">
	<cfhttpparam name="key" value="#APPLICATION.emailServerPassword#" type="formfield">
</cfhttp>--->


<cfset toEmails = arrayNew()>

<cfset arrayAppend(toEmails, {"email":"alucena@era7.com"})>
<cfset arrayAppend(toEmails, {"email":"bugs@doplanning.net"})>

<cfset jsonFields = {

    "key": "#APPLICATION.emailServerPassword#",
    "message": {
        "html": "<p>Hola, esto es una prueba</p>",
        "subject": "Prueba API Mandrill",
        "from_email": "doplanning@era7bioinformatics.com",
        "from_name": "DoPlanning",
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


<!---

"to": [
	{
		"email": "alucena@era7.com"
	},
	{
		"email": "bugs@doplanning.net"
	}
],

"headers": {
	"Reply-To": "#APPLICATION.emailReply#"
},--->

<cfhttp method="post" url="https://mandrillapp.com/api/1.0/messages/send.json" result="responseResult">
	<cfhttpparam type="header" name="Content-Type" value="application/json" />
    <cfhttpparam type="body" value="#serializeJSON(jsonFields)#">
</cfhttp>

<cfdump var="#responseResult#">

<cfset mandrillResponse = deserializeJSON(responseResult.filecontent)>

<cfdump var="#mandrillResponse#">

<cfif responseResult.status_code NEQ 200>

	<cfoutput>
	Ha ocurrido un error inesperado enviando los emaiils: #mandrillResponse.message#
	</cfoutput>
	
<cfelse>

	Email enviado.

</cfif>

</body>
</html>

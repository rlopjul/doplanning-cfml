<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
</head>

<body>

<cfsavecontent variable="emailsList"></cfsavecontent>

<!---<cfif (SESSION.client_administrator EQ SESSION.user_id)>--->

	<cfset LIST_TEXT_VALUES_DELIMITER = "#chr(13)##chr(10)#">

	<cfset emailsList = replace(emailsList, LIST_TEXT_VALUES_DELIMITER, ",", "ALL")>

	<cfoutput>
		#emailsList#

		<br/><br/>EMAILS INCORRECTOS:<br/>

		<cfloop list="#emailsList#" item="emailItem">
			<cfif NOT isValid("email", trim(emailItem))>
			#emailItem#<br/>
			</cfif>
		</cfloop>

	</cfoutput>

<!---</cfif>--->

</body>
</html>

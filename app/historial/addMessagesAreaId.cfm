<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>

<!---<cfquery datasource="#APPLICATION.dsn#" name="getClients">
	SELECT abbreviation
	FROM APP_clients;
</cfquery>
	
<cfloop query="getClients">

	<cfset client_abb = getClients.abbreviation>
	
	<cfquery datasource="#client_dsn#" name="messagesList">
		SELECT *
		FROM #client_abb#_messages
	</cfquery>

	<cfif messagesList.recordCount GT 0>
		<cfloop query="messagesList">
		
			<cfset message_id = messagesList.id>
			
			<!---GET MESSAGE PARENT AREA--->
			<cfinvoke component="#APPLICATION.componentsPath#/MessageManager" method="getMessageParentArea" returnvariable="message_parent_id">
				<cfinvokeargument name="message_id" value="#message_id#">
				<cfinvokeargument name="client_abb_c" value="#client_abb#">
			</cfinvoke>
			
			<cfquery datasource="#client_dsn#">
				UPDATE #client_abb#_messages
				SET area_id = <cfqueryparam value="#message_parent_id#" cfsqltype="cf_sql_integer">
				WHERE id = #message_id#;
			</cfquery>
		
		</cfloop>
	</cfif>
	
	<cfoutput>
	Mensajes actualizados en #client_abb#<br/>
	</cfoutput>
	
</cfloop>--->


</body>
</html>

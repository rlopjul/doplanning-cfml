<cfif (SESSION.client_abb EQ "era7" AND (SESSION.user_id EQ "3" OR SESSION.user_id EQ "111" 
OR SESSION.user_id EQ "93" OR SESSION.user_id EQ "152" OR SESSION.user_id EQ "1")) OR (SESSION.client_abb EQ "web4bio7" AND SESSION.user_id EQ "4") OR (SESSION.client_abb EQ "software7" AND SESSION.user_id EQ "2")>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
table.clients {
	border-width: 1px;
	border-spacing: ;
	border-style: outset;
	border-color: gray;
	border-collapse: collapse;
	background-color: white;
}
/*table.clients th {
	border-width: 1px;
	padding: 1px;
	border-style: inset;
	border-color: gray;
	background-color: white;
	-moz-border-radius: ;
}*/
table.clients td {
	border-width: 1px;
	padding: 4px;
	border-style: inset;
	border-color: gray;
	background-color: white;
	-moz-border-radius: ;
}
</style>
<title>DoPlanning Clients</title>
</head>

<body>
<br/><br/>
<table class="clients">
	<tr>
		<td><b>Cliente</b></td>
		<td>Número de usuarios</td>
		<td>Espacio ocupado (MB)</td>
		<td>Espacio descargado (MB)</td>
		<td>SMS</td>
		<td>Número de conexiones</td>
		<td>Administrador</td>
	</tr>
	
	<cfquery datasource="#APPLICATION.dsn#" name="getClients">
		SELECT *
		FROM APP_clients;
	</cfquery>
	
	<cfloop query="getClients">
		<tr>
		<cfset cur_client_abb = getClients.abbreviation>
		<cfset cur_sms_used = getClients.number_of_sms_used>
		<cfset client_dsn = APPLICATION.identifier&"_"&getClients.abbreviation>
		<cfoutput>
			<td><a href="http://www.doplanning.net/#getClients.id#" target="_blank"><b>#getClients.name#</b></a></td>
		</cfoutput>

			<cfquery datasource="#client_dsn#" name="getClient">
				SELECT count(*) AS users, sum(space_used) AS users_space_used, sum(space_downloaded) AS users_space_downloaded, sum(number_of_connections) AS users_connections
				FROM #cur_client_abb#_users
			</cfquery>
			
			<cfquery datasource="#client_dsn#" name="getClientAdministrator">
				SELECT *
				FROM #cur_client_abb#_users AS users
				WHERE users.id = #getClients.administrator_id#;
			</cfquery>
		<cfoutput>
			<td>#getClient.users#</td>
			<td>#round((getClient.users_space_used/(1024*1024))*100)/100#</td>
			<td>#round((getClient.users_space_downloaded/(1024*1024))*100)/100#</td>
			<td>#cur_sms_used#</td>
			<td>#getClient.users_connections#</td>
			<td>#getClientAdministrator.family_name# #getClientAdministrator.name# <br/>#getClientAdministrator.email#</td>
		</cfoutput>
		<tr>
	</cfloop>
	
</table>
</body>
</html>

</cfif>
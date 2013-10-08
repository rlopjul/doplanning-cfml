<cfif (SESSION.client_abb EQ "era7" AND (SESSION.user_id EQ "3" OR SESSION.user_id EQ "111" 
OR SESSION.user_id EQ "93" OR SESSION.user_id EQ "152" OR SESSION.user_id EQ "1")) OR (SESSION.client_abb EQ "web4bio7" AND (SESSION.user_id EQ "4" OR SESSION.user_id EQ "9")) OR (SESSION.client_abb EQ "software7" AND SESSION.user_id EQ "2") OR (APPLICATION.identifier EQ "vpnet" AND SESSION.user_id IS 1) OR (SESSION.client_abb EQ "bioinformatics7" AND SESSION.user_id IS 10)>
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
	
<cfquery datasource="#APPLICATION.dsn#" name="getClients">
	SELECT *
	FROM APP_clients;
</cfquery>

<cfoutput>
TOTAL: #getClients.recordCount#
</cfoutput>

<br/><br/>
<table class="clients">
	<tr>
		<td><b>Cliente</b></td>
		<!--- <td>DB Migrada</td>
				<td>DB Final</td> --->
		<td>DB 2.1</td>
		<td>DB 2.5</td>
		<td>abb</td>
		<td>Usuarios</td>
		<td>Mensajes</td>
		<td>Archivos</td>
		<td>Áreas</td>
		<td>Contactos</td>
		<td>Conexiones</td>
		<td>Espacio ocupado (MB)</td>
		<td>Espacio descargado (MB)</td>
		<td>SMS</td>
		<td>Última conexión</td>
		<td>Fecha de creación</td>
		<td>Administrador</td>
	</tr>

	
	<cfloop query="getClients">
		<tr>
		<cfset cur_client_abb = getClients.abbreviation>
		<cfset cur_sms_used = getClients.number_of_sms_used>
		<cfset client_dsn = APPLICATION.identifier&"_"&getClients.abbreviation>

			<!---Esta consulta anterior no se puede ejecutar (da error) en versiones antiguas de MySQL--->
			<cfquery datasource="#client_dsn#" name="getClient">
				SELECT sum(space_used) AS users_space_used, sum(space_downloaded) AS users_space_downloaded, sum(number_of_connections) AS users_connections, creation_date
				FROM #cur_client_abb#_users;
			</cfquery>
			
			<cfquery datasource="#client_dsn#" name="getClientAdministrator">
				SELECT *
				FROM #cur_client_abb#_users AS users
				WHERE users.id = #getClients.administrator_id#;
			</cfquery>
			
			<cfquery datasource="#client_dsn#" name="getClientLastConnection">
				SELECT MAX(last_connection) AS client_last_connection
				FROM #cur_client_abb#_users AS users;
			</cfquery>
			
			<cfquery datasource="#client_dsn#" name="getUsersCount">
				SELECT count(*) AS users
				FROM #cur_client_abb#_users;
			</cfquery>
			
			<cfquery datasource="#client_dsn#" name="getMessagesCount">
				SELECT count(*) AS messages
				FROM #cur_client_abb#_messages;
			</cfquery>
			
			<cfquery datasource="#client_dsn#" name="getFilesCount">
				SELECT count(*) AS files
				FROM #cur_client_abb#_files;
			</cfquery>
			
			<cfquery datasource="#client_dsn#" name="getAreasCount">
				SELECT count(*) AS areas
				FROM #cur_client_abb#_areas;
			</cfquery>
			
			<cfquery datasource="#client_dsn#" name="getContactsCount">
				SELECT count(*) AS contacts
				FROM #cur_client_abb#_contacts;
			</cfquery>
			
			<!--- 
			<cfquery datasource="#client_dsn#" name="isNewDb">
				SHOW COLUMNS FROM #cur_client_abb#_users FROM dp_#cur_client_abb# WHERE Field = 'image_type';
			</cfquery>
			
			<cfif isNewDb.recordCount GT 0>
				<cfquery datasource="#client_dsn#" name="isFinalVersion">
					SHOW COLUMNS FROM #cur_client_abb#_entries FROM dp_#cur_client_abb# WHERE Field = 'iframe_display_type_id';
				</cfquery>
			</cfif> 
			--->
			
			<cfquery datasource="#client_dsn#" name="isDbDp21">
				SHOW TABLES LIKE '#cur_client_abb#_meetings_users_sessions';
			</cfquery>

			<cfquery datasource="#client_dsn#" name="isDbDp25">
				SHOW TABLES LIKE '#cur_client_abb#_lists';
			</cfquery>

		<cfoutput>
			<td><a href="http://doplanning.net/#getClients.id#" target="_blank"><b>#getClients.name#</b></a></td>
			<!---<td><cfif isNewDb.recordCount GT 0>Sí<cfelse><strong>No</strong></cfif></td>
			<td><cfif isNewDb.recordCount GT 0 AND isFinalVersion.recordCount GT 0>Sí<cfelse><strong>No</strong></cfif></td>--->
			<td><cfif isDbDp21.recordCount GT 0>Sí
			<cfelse><strong>No</strong>
			</cfif></td>
			<td><cfif isDbDp25.recordCount GT 0>Sí
			<cfelse><strong>No</strong>
			</cfif></td>
			<td>#getClients.abbreviation#</td>	
			<td>#getUsersCount.users#</td>	
			<td>#getMessagesCount.messages#</td>
			<td>#getFilesCount.files#</td>
			<td>#getAreasCount.areas#</td>	
			<td>#getContactsCount.contacts#</td>
			<td>#getClient.users_connections#</td>
			<td>#round((getClient.users_space_used/(1024*1024))*100)/100#</td>
			<td>#round((getClient.users_space_downloaded/(1024*1024))*100)/100#</td>
			<td>#cur_sms_used#</td>
			<td>#DateFormat(getClientLastConnection.client_last_connection, "DD-MM-YYYY")#</td>
			<td>#DateFormat(getClient.creation_date, "DD-MM-YYYY")#</td>
			<td>#getClientAdministrator.family_name# #getClientAdministrator.name# #getClientAdministrator.email#</td>
		</cfoutput>
		<tr>
	</cfloop>
	
</table>
</body>
</html>

</cfif>
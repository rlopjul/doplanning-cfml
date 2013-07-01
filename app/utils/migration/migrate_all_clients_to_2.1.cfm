<cfif (SESSION.client_abb EQ "software7" AND SESSION.user_id IS 2)>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Migrar Clientes a 2.1</title>
</head>

<body>

<cfif isDefined("FORM.migrate")>
	
	<cfquery datasource="#APPLICATION.dsn#" name="getClients">
		SELECT *
		FROM APP_clients;
	</cfquery>

	<cfloop query="getClients">

		<cfset cur_client_abb = getClients.abbreviation>
		<cfset client_dsn = APPLICATION.identifier&"_"&getClients.abbreviation>

		<cfquery datasource="#client_dsn#" name="isDbDp21">
			SHOW TABLES LIKE '#cur_client_abb#_meetings_users_sessions';
		</cfquery>

		<cfif isDbDp21.recordCount IS 0>

			<!---Nueva tabla--->
			<cfquery datasource="#client_dsn#">
				CREATE TABLE `#cur_client_abb#_meetings_users_sessions` (
				  `user_a_id` int(11) NOT NULL,
				  `user_b_id` int(11) NOT NULL,
				  `session_id` varchar(255) NOT NULL,
				  `creation_date` datetime NOT NULL,
				  PRIMARY KEY (`user_a_id`,`user_b_id`),
				  KEY `FK_#cur_client_abb#_meetings_users_sessions_2` (`user_b_id`),
				  CONSTRAINT `FK_#cur_client_abb#_meetings_users_sessions_1` FOREIGN KEY (`user_a_id`) REFERENCES `#cur_client_abb#_users` (`id`) ON DELETE CASCADE,
				  CONSTRAINT `FK_#cur_client_abb#_meetings_users_sessions_2` FOREIGN KEY (`user_b_id`) REFERENCES `#cur_client_abb#_users` (`id`) ON DELETE CASCADE
				) ENGINE=InnoDB DEFAULT CHARSET=utf8;
			</cfquery>

			<cfoutput>
				<strong>Cliente #cur_client_abb# migrado.</strong><br/>
			</cfoutput>

		<cfelse>

			<cfoutput>
				Cliente #cur_client_abb# ya migrado anteriormente.<br/>
			</cfoutput>

		</cfif>
			
	</cfloop>

<cfelse>

	<br/>
	<cfform method="post" action="#CGI.SCRIPT_NAME#">
		<cfinput type="submit" name="migrate" value="MIGRAR TODOS LOS CLIENTES">
	</cfform>

	
</cfif>

</body>
</html>

</cfif>
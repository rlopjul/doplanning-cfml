<cfif (SESSION.client_abb EQ "software7" AND SESSION.user_id IS 2)>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Migrar Cliente a 2.1</title>
</head>

<body>

<cfif isDefined("FORM.abb")>


	<cfset client_abb = FORM.abb>
	
	<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>
	
	<cfquery datasource="#APPLICATION.dsn#" name="getClient">
		SELECT *
		FROM APP_clients
		WHERE abbreviation = <cfqueryparam value="#client_abb#" cfsqltype="cf_sql_varchar">;
	</cfquery>

	<cfif getClient.recordCount IS 0>
		<cfthrow message="Error al obtener el cliente: #client_abb#">
	</cfif>
	
	<cfoutput>
	CLIENTE: #getClient.name#<br/>
	</cfoutput>
	
	<!---Modificaciones de la base de datos--->
	<cftransaction>
		
		<!---Nuevas tablas--->
		<cfquery datasource="#client_dsn#">
			CREATE TABLE `#client_abb#_meetings_users_sessions` (
			  `user_a_id` int(11) NOT NULL,
			  `user_b_id` int(11) NOT NULL,
			  `session_id` varchar(255) NOT NULL,
			  `creation_date` datetime NOT NULL,
			  PRIMARY KEY (`user_a_id`,`user_b_id`),
			  KEY `FK_#client_abb#_meetings_users_sessions_2` (`user_b_id`),
			  CONSTRAINT `FK_#client_abb#_meetings_users_sessions_1` FOREIGN KEY (`user_a_id`) REFERENCES `#client_abb#_users` (`id`) ON DELETE CASCADE,
			  CONSTRAINT `FK_#client_abb#_meetings_users_sessions_2` FOREIGN KEY (`user_b_id`) REFERENCES `#client_abb#_users` (`id`) ON DELETE CASCADE
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		</cfquery>
		
	</cftransaction>
	-Creada nueva tabla meetings_users_sessions.<br/>

	Modificaciones terminadas.<br/>
</cfif>
<br/>
<cfform method="post" action="#CGI.SCRIPT_NAME#">
	<label>Client Abb</label>
	<cfinput type="text" name="abb" value="" required="yes" message="Client abb requerido">
	<cfinput type="submit" name="migrate" value="MIGRAR">
</cfform>

</body>
</html>

</cfif>
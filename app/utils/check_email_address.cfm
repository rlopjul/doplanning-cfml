<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
</head>

<body>

<!---<cfif (SESSION.client_administrator EQ SESSION.user_id)>--->

	<cfset no_include_clients="">

	<cfquery datasource="#APPLICATION.dsn#" name="getClients">
		SELECT *
		FROM APP_clients;
	</cfquery>

	EMAILS INCORRECTOS:<br/>
	<cfloop query="getClients">
		
		<cfset client_dsn = APPLICATION.identifier&"_"&getClients.abbreviation>
		<cfset client_abb = getClients.abbreviation>
		<cfset client_name = getClients.name>
		
		<cfif listFind(no_include_clients, client_abb, ",") IS 0>
		
			<cfquery datasource="#client_dsn#" name="getUsers">
				SELECT *
				FROM #client_abb#_users;
			</cfquery>
				
			<cfoutput>
			<cfloop query="getUsers">
				<cfif NOT isValid("email", getUsers.email)>
				 '#getUsers.email#' (#getUsers.family_name# #getUsers.name# #getUsers.id#)<br/>
				</cfif>	
			</cfloop>
			</cfoutput>
			
		</cfif>
		
	</cfloop>

<!---</cfif>--->

</body>
</html>

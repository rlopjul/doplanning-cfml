<!---<cfif (SESSION.client_abb EQ "doplanning" AND SESSION.user_id IS 1)>--->
	
	<!DOCTYPE html>
	<html lang="es">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Migrar Clientes 2.8</title>
	</head>
	
	<body>
	
	<cfif isDefined("FORM.abb")>	

		<cfset new_client_abb = FORM.abb>
		<cfset client_datasource = APPLICATION.identifier&"_"&new_client_abb>
		
		<cfquery datasource="#APPLICATION.dsn#" name="getClient">
			SELECT *
			FROM app_clients
			WHERE abbreviation = <cfqueryparam value="#new_client_abb#" cfsqltype="cf_sql_varchar">;
		</cfquery>
	
		<cfif getClient.recordCount IS 0>
			<cfthrow message="Error al obtener el cliente: #new_client_abb#">
		</cfif>
		
		<cfoutput>
		CLIENTE: #getClient.name#<br/>
		</cfoutput>		
		
		<cfinclude template="#APPLICATION.resourcesPath#/includes/db/transaction_to_2.8.cfm">	
		
	<cfelseif isDefined("FORM.migrate")>
	
		<cfquery datasource="#APPLICATION.dsn#" name="getClients">
			SELECT *
			FROM app_clients;
		</cfquery>
	
		<cfloop query="getClients">
	
			<cfset new_client_abb = getClients.abbreviation>
			<cfset client_datasource = APPLICATION.identifier&"_"&getClients.abbreviation>
	
			<cfquery datasource="#client_datasource#" name="isDbDp28">
				SHOW TABLES LIKE '#new_client_abb#_webs';
			</cfquery>
	
			<cfif isDbDp28.recordCount IS 0>
				<cfoutput>
					Migrar #new_client_abb#<br/>
				</cfoutput>
			
				<cfinclude template="#APPLICATION.resourcesPath#/includes/db/transaction_to_2.8.cfm">	
				
			<cfelse>

				<cfoutput>
					Cliente #new_client_abb# ya migrado anteriormente.<br/>
				</cfoutput>
			
			</cfif>
		</cfloop>
		
		
	</cfif>
	<br/>
	<cfform method="post" action="#CGI.SCRIPT_NAME#">
		<label>Client Abb</label>
		<cfinput type="text" name="abb" value="" required="yes" message="Client ID requerido">
		<cfinput type="submit" name="migrate" value="MIGRAR">
	</cfform>
	
	
	<br/>
	<cfform method="post" action="#CGI.SCRIPT_NAME#">
		<cfinput type="submit" name="migrate" value="MIGRAR TODOS LOS CLIENTES">
	</cfform>
	
	</body>
	</html>

<!---</cfif>--->
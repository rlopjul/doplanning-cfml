	<!DOCTYPE html>
	<html lang="es">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<cfoutput>
		<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
	</cfoutput>
	<title>Migrar Clientes</title>
	</head>
	
	<body>
	
	<div class="container">

		<div class="row">

			<div class="col-sm-12">

				<h2>Migrar Clientes</h1>

			</div>

		</div>

	<cfif isDefined("FORM.client") AND isDefined("FORM.version")>	

		<cfif FORM.client EQ "all">

			<cfquery datasource="#APPLICATION.dsn#" name="getClients">
				SELECT *
				FROM APP_clients;
			</cfquery>
		
			<cfloop query="getClients">
		
				<cfset client_abb = getClients.abbreviation>
				<cfset client_dsn = APPLICATION.identifier&"_"&getClients.abbreviation>
		
				<cfinclude template="transaction_to_#FORM.version#.cfm">

			</cfloop>	
					
		<cfelse>

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
			

			<div class="row">

				<div class="col-sm-12">
					<cfinclude template="transaction_to_#FORM.version#.cfm">
				</div>

			</div>
			
		</cfif>

	<cfelse>


		<div class="row">

			<div class="col-sm-12">

				<cfform method="post" action="#CGI.SCRIPT_NAME#">

					<div class="form-group">
						<label>Versión</label>
						<select name="version">
							<option value="2.8.1">2.8.1</option>
						</select>
					</div>

					<div class="form-group">
						<select name="client">
							<option value="one">MIGRAR CLIENTE SELECCIONADO</option>
							<option value="all">MIGRAR TODOS LOS CLIENTES</option>
						</select>
					</div>

					<div class="form-group">
						<label>Cliente a migrar</label>

						<cfquery datasource="#APPLICATION.dsn#" name="getClients">
							SELECT *
							FROM APP_clients;
						</cfquery>
						<select name="abb">
							<cfoutput query="getClients">
								<option value="#getClients.abbreviation#">#getClients.name# (#getClients.abbreviation#)</option>
							</cfoutput>
						</select>
					</div>


					<cfinput type="submit" name="migrate" value="MIGRAR" class="btn btn-default btn-primary">
				</cfform>

			</div>

		</div>
		
	</cfif>

	</div>

	
	
	
	<!---<br/>
	<cfform method="post" action="#CGI.SCRIPT_NAME#">
		<cfinput type="submit" name="migrate" value="MIGRAR TODOS LOS CLIENTES">
	</cfform>--->
	
	</body>
	</html>
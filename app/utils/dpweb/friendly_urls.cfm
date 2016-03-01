	<!DOCTYPE html>
	<html lang="es">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<cfoutput>
		<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
	</cfoutput>
	<title>Cambiar URLs DoPlanning Web</title>
	</head>

	<body>

	<div class="container">

		<div class="row">

			<div class="col-sm-12">

				<h2>Cambiar URLs DoPlanning Web</h1>

			</div>

		</div>

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

			<cfset area_type = "web"><!---web/intranet--->

			<cfinvoke component="#APPLICATION.coreComponentsPath#/WebQuery" method="getWebs" returnvariable="getWebQuery">
				<cfinvokeargument name="area_type" value="#area_type#">

				<cfinvokeargument name="client_abb" value="#new_client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_datasource#">
			</cfinvoke>

			<cfif getWebQuery.recordCount GT 0>

				<cfloop query="getWebQuery">

					<cfif getWebQuery.area_type EQ area_type>

						#getWebQuery.path# <br/>

						<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="setSubAreasUrlId">
							<cfinvokeargument name="area_id" value="#getWebQuery.area_id#">
							<cfinvokeargument name="path" value="#getWebQuery.path#">

							<cfinvokeargument name="client_abb" value="#new_client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_datasource#">
						</cfinvoke>

					</cfif>

				</cfloop>

			</cfif>

			</cfoutput>


	<cfelse>


		<div class="row">

			<div class="col-sm-12">

				<cfform method="post" action="#CGI.SCRIPT_NAME#">

					<div class="form-group">
						<label>Web a cambiar URLs</label>

						<cfquery datasource="#APPLICATION.dsn#" name="getClients">
							SELECT *
							FROM app_clients;
						</cfquery>
						<select name="abb">
							<cfoutput query="getClients">
								<option value="#getClients.abbreviation#">#getClients.name# (#getClients.abbreviation#)</option>
							</cfoutput>
						</select>
					</div>

					<cfinput type="submit" name="migrate" value="MODIFICAR URLs" class="btn btn-default btn-primary">
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

<!DOCTYPE html>
<html lang="es">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<cfoutput>
		<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
	</cfoutput>
	<title>Cambiar URLs Áreas DoPlanning Web</title>
	</head>

	<body>

	<div class="container">

		<div class="row">

			<div class="col-sm-12">

				<h2>Cambiar URLs Áreas DoPlanning Web</h1>

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
			WEB CLIENTE: #getClient.name#<br/>

			<!---<cfset area_type = "web">---><!---web/intranet--->

			<cfinvoke component="#APPLICATION.coreComponentsPath#/WebQuery" method="getWebs" returnvariable="getWebQuery">
				<!---<cfinvokeargument name="area_type" value="#area_type#">--->

				<cfinvokeargument name="client_abb" value="#new_client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_datasource#">
			</cfinvoke>

			<cfif getWebQuery.recordCount GT 0>

				<cfloop query="getWebQuery">

					#getWebQuery.path# <br/>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="setSubAreasUrlId">
						<cfinvokeargument name="area_id" value="#getWebQuery.area_id#">
						<cfinvokeargument name="path" value="#getWebQuery.path#">

						<cfinvokeargument name="client_abb" value="#new_client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_datasource#">
					</cfinvoke>

				</cfloop>

			</cfif>

			</cfoutput>


	<cfelse>


		<div class="row">

			<div class="col-sm-12">

				<cfform method="post" action="#CGI.SCRIPT_NAME#">

					<div class="form-group">
						<label>Web a cambiar URLs</label>

						<!---<cfquery datasource="#APPLICATION.dsn#" name="getClients">
							SELECT *
							FROM app_clients;
						</cfquery>

						<select name="abb">
							<cfoutput query="getClients">
								<option value="#getClients.abbreviation#">#getClients.name# (#getClients.abbreviation#)</option>
							</cfoutput>
						</select>--->

						<cfoutput>

							<input type="text" name="abb" value="#SESSION.client_abb#" readonly class="form-control"/>

						</cfoutput>

						<p class="help-block">Solo se definirán los valores de URL vacíos, no se modificarán los valores de URL ya definidos</p>

					</div>

					<cfinput type="submit" name="migrate" value="MODIFICAR URLs" class="btn btn-default btn-primary">
				</cfform>

			</div>

		</div>


		<div class="row">

			<div class="col-sm-12" style="padding-top:40px;">

				<a href="friendly_urls_items.cfm">Cambiar URLs de elementos</a>

			</div>

		</div>

	</cfif>

	</div>



	</body>
</html>

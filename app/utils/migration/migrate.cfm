	<!DOCTYPE html>
	<html lang="es">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<cfoutput>
		<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
	</cfoutput>
	<title>Migrar Clientes DoPlanning</title>
	</head>

	<body>

	<div class="container">

		<div class="row">

			<div class="col-sm-12">

				<h2>Migrar Clientes DoPlanning</h1>

			</div>

		</div>

	<cfif isDefined("FORM.client") AND isDefined("FORM.version")>

		<cfif FORM.client EQ "all">

			<cfquery datasource="#APPLICATION.dsn#" name="getClients">
				SELECT *
				FROM app_clients;
			</cfquery>

			<cfset checkVersion = true>

			<cfloop query="getClients">

				<cfset new_client_abb = getClients.abbreviation>
				<cfset client_datasource = APPLICATION.identifier&"_"&getClients.abbreviation>

				<cfinclude template="#APPLICATION.resourcesPath#/includes/db/transaction_to_#FORM.version#.cfm">

			</cfloop>

		<cfelse>

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


			<div class="row">

				<div class="col-sm-12">
					<cfset checkVersion = true>
					<cfinclude template="#APPLICATION.resourcesPath#/includes/db/transaction_to_#FORM.version#.cfm">
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
							<option value="2.5">2.5</option>
							<option value="2.6">2.6</option>
							<option value="2.8">2.8</option>
							<option value="2.8.1">2.8.1</option>
							<option value="2.8.2">2.8.2</option>
							<option value="2.8.3">2.8.3</option>
							<option value="2.8.4">2.8.4 (Máscaras de campos decimales)</option>
							<option value="2.8.5">2.8.5 (Caché en árbol)</option>
							<option value="2.9">2.9 (Pestaña Home, Documento DoPlanning, Caché de permisos de áreas)</option>
							<option value="2.9.1">2.9.1 (Nº de versión de versiones de archivos)</option>
							<option value="2.9.2">2.9.2 (Nuevos tipos de campos listas y deshabilitar elementos de áreas)</option>
							<option value="2.9.3">2.9.3 (Áreas de sólo lectura, ocultar usuarios de área, nuevas preferencias en notificaciones)</option>
							<option value="2.10">2.10 (Papelera de elementos de área)</option>
							<option value="3.0.1">3.0.1 (Archivos con URL pública)</option>
							<option value="3.0.2">3.0.2 (Acciones en modificaciones de registros de listas y formularios)</option>
							<option value="3.0.3">3.0.3 Registro de descarga de archivos y pestaña estadísticas administración</option>
							<option value="3.0.4">3.0.4 Tipologías de usuarios, nueva pestaña tipologías administración</option>
							<option value="3.1">3.1 Categorías de elementos, notificaciones agrupadas, notificaciones web, deshabilitar notificaciones</option>
							<option value="3.2">3.2 Archivos adjuntos de listas y formularios, página de inicio personalizada y nuevo elemento boletín</option>
							<option value="3.2.1">3.2.1 Separadores de campos, nuevas opciones para campos, verificación de usuarios</option>
							<option value="3.2.2">3.2.2 Deshabilitar listado de registros por defecto en listas, error en fecha de publicación corregido</option>
							<option value="3.3">3.3 Categorías especiales para tablas y búsquedas predefinidas en listas</option>
							<option value="3.3.1">3.3.1 Campo registro de tabla referenciado</option>
							<option value="3.4">3.4 Publicación restringida en web a usuarios identificados</option>
							<option value="3.5">3.5 Opción en áreas para modo listado por defecto</option>
							<option value="3.6">3.6 Campo url_id para áreas y elementos web</option>
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
							FROM app_clients;
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

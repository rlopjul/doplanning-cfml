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

				<h2>Cambiar URLs Elementos DoPlanning Web</h1>

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

					<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="setSubAreasItemsUrlId">
						<cfinvokeargument name="area_id" value="#getWebQuery.area_id#">
						<cfinvokeargument name="itemTypeId" value="#FORM.itemTypeId#">
						<cfinvokeargument name="path" value="#getWebQuery.path#">
						<cfinvokeargument name="web_language" value="#getWebQuery.language#">

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

						<cfoutput>

							<input type="text" name="abb" value="#SESSION.client_abb#" readonly class="form-control"/>

						</cfoutput>

					</div>

					<div class="form-group">

						<label>Tipo de elemento</label>

						<select name="itemTypeId" class="form-control">
							<option value="4">Noticias</option>
							<option value="5">Eventos</option>
							<option value="8">Publicaciones</option>
						</select>

					</div>

					<p class="help-block">Solo se definirán los valores de URL vacíos, no se modificarán los valores de URL ya definidos</p>

					<cfinput type="submit" name="migrate" value="MODIFICAR URLs de ELEMENTOS" class="btn btn-default btn-primary">
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

<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_basica_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title# - Actualizar los usuarios cargados en DoPlanning</title>
<!-- InstanceEndEditable -->

<cfinclude template="#APPLICATION.htmlPath#/includes/html_head.cfm">

<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
</cfoutput>
</head>

<body onBeforeUnload="onUnloadPage()" onLoad="onLoadPage()" class="body_global">
<!---divLoading--->
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_page_div.cfm">
<cfif APPLICATION.identifier NEQ "dp">
	<div class="div_header">
		<a href="../../../html/"><div class="div_header_content"><!-- --></div></a>
		<div class="div_separador_header"><!-- --></div>
	</div>
</cfif>

<!-- InstanceBeginEditable name="header" -->

<!-- InstanceEndEditable -->

<div id="wrapper"><!--- wrapper --->
        
	<!---<div class="container">
		<div class="row">
			<div class="col-lg-8 col-lg-offset-2">
				<h1></h1>
				<p></p>
							
			</div>
		</div>
	</div>--->

	<!---<div class="div_contenedor_contenido">--->
	<!-- InstanceBeginEditable name="contenido" -->

<h2>2º Actualizar los usuarios cargados en DoPlanning</h1>

<br/>

<cfset client_abb = SESSION.client_abb>
<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>

<cfif isDefined("FORM.client_dsn")>
		
	<cfquery datasource="#APPLICATION.dsn#" name="getClient">
		SELECT *
		FROM app_clients
		WHERE abbreviation = <cfqueryparam value="#client_abb#" cfsqltype="cf_sql_varchar">;
	</cfquery>

	<cfif getClient.recordCount IS 0>
		<cfthrow message="Error al obtener el cliente: #client_abb#">
	</cfif>
	
	<cfoutput>
	Inicio de actualización.<br/>
	CLIENTE: #getClient.name#<br/>
	</cfoutput>
	
	<cfquery datasource="#client_dsn#" name="getUsersToUpdate">
		SELECT *
		FROM #client_abb#_users_to_update;
	</cfquery>

	<cftransaction>
		
		<cfloop query="getUsersToUpdate"><!---startrow="11" endrow="699"--->
			
			<cfquery datasource="#client_dsn#" name="getUser">
				SELECT *
				FROM #client_abb#_users
				WHERE id = #getUsersToUpdate.user_id#;
			</cfquery>

			<!---<cfdump var="#getUser#">

			<cfsavecontent variable="updateUser">
				<cfoutput>
					UPDATE #client_abb#_users
					SET family_name = '#getUsersToUpdate.name#',
					name = '#getUsersToUpdate.family_name_1#',
					dni = '#getUsersToUpdate.dni#',
					login_ldap = #getUsersToUpdate.login_dmsas#',
					internal_user = #getUsersToUpdate.internal_user#,
					perfil_cabecera = '#getUsersToUpdate.perfil_cabecera#'
					WHERE id = #getUsersToUpdate.user_id#;
				</cfoutput>
			</cfsavecontent>

			<cfdump var="#updateUser#">
			
			<br/><br/>
		--->

			<cfquery datasource="#client_dsn#" name="updateUser">
				UPDATE #client_abb#_users
				SET family_name = '#getUsersToUpdate.name#',
				name = '#getUsersToUpdate.family_name_1#',
				dni = '#getUsersToUpdate.dni#',
				login_ldap = '#trim(getUsersToUpdate.login_dmsas)#',
				internal_user = #getUsersToUpdate.internal_user#,
				perfil_cabecera = '#getUsersToUpdate.perfil_cabecera#'
				WHERE id = #getUsersToUpdate.user_id#;
			</cfquery>

			

			

		</cfloop>

	</cftransaction>

	Actualización terminada.<br/>

<cfelse>

	-Este proceso no es reversible.<br/>
	-Una vez pulsado el botón "Actualizar usuarios" <strong>debe esperar unos minutos hasta que se complete la operación</strong>.<br/><br/>

	<cftry>
		
		<cfquery datasource="#client_dsn#" name="getImportedUsersQuery">
			SELECT *
			FROM #SESSION.client_abb#_users_to_update;
		</cfquery>

		<cfif getImportedUsersQuery.recordCount GT 0>

			<script type="text/javascript">

				function onSubmitForm(){
					document.getElementById("submitDiv1").innerHTML = window.lang.translate('Importando...');
				}

			</script>

			<cfoutput>
			<cfform method="post" action="#CGI.SCRIPT_NAME#" onsubmit="onSubmitForm();">
				<label for="client_dsn">Identificador de aplicación DoPlanning en la que se crearán los usuarios:</label>
				<input name="client_dsn" id="client_dsn" type="text" value="#client_dsn#" readonly="true" />
				<div style="margin-top:5px" id="submitDiv1">
				<cfinput type="submit" name="import" class="btn btn-primary" value="Actualizar usuarios">
				</div>
			</cfform>
			</cfoutput>

			<strong>Usuarios a actualizar:</strong>				
			<cfdump var="#getImportedUsersQuery#" label="#SESSION.client_abb#_users_to_import" metainfo="no">

		<cfelse>

			<strong>No se puede realizar la actualización, no hay usuarios para actualizar.</strong>	

		</cfif>

		<cfcatch>
			<strong>ERROR, no se puede realizar la actualización. Antes debe cargar usuarios mediante <a href="update_1_users_from_csv.cfm">1º Cargar desde un CSV los usuarios</a>.</strong>
		</cfcatch>		
	</cftry>
	
</cfif>

<!-- InstanceEndEditable -->
	<!---</div>--->
	
</div>
<!--- END wrapper --->

</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_basica_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title# - Crear los usuarios cargados en DoPlanning</title>
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

<h2>2º Crear los usuarios cargados en DoPlanning</h1>

<br/>

<cfset client_abb = SESSION.client_abb>
<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>

<cfif isDefined("FORM.client_dsn")>

	<cfset add_to_areas_ids = "">

	<cfif isDefined("FORM.areas_ids")>
		<cfset add_to_areas_ids = FORM.areas_ids>
	</cfif>

	<cfif isDefined("FORM.area_id") AND len(FORM.area_id) GT 0>

		<cfif listContains(add_to_areas_ids, FORM.area_id, ";") IS 0>
			
			<cfset listAppend(add_to_areas_ids, FORM.area_id, ";")>

		</cfif>

	</cfif>

	<cfquery datasource="#APPLICATION.dsn#" name="getClient">
		SELECT *
		FROM app_clients
		WHERE abbreviation = <cfqueryparam value="#client_abb#" cfsqltype="cf_sql_varchar">;
	</cfquery>

	<cfif getClient.recordCount IS 0>
		<cfthrow message="Error al obtener el cliente: #client_abb#">
	</cfif>
	
	<cfoutput>
	Inicio de importación.<br/>
	CLIENTE: #getClient.name#<br/>
	ÁREAS por defecto: #add_to_areas_ids#<br/><br/>
	</cfoutput>
	

	<cfquery datasource="#client_dsn#" name="getUsersToImport">
		SELECT *
		FROM #client_abb#_users_to_import;
	</cfquery>

	<cfloop query="getUsersToImport" startrow="600"><!---startrow="11" endrow="699"--->
		
		<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="generatePassword" returnvariable="newPassword">
			<cfinvokeargument name="numberofCharacters" value="5">
		</cfinvoke>

		<!---<cfoutput>Contraseña: #newPassword#<br/></cfoutput>--->

		<!---
		<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="xmlUser">
			<cfinvokeargument name="name" value="#getUsersToImport.family_name_1# #getUsersToImport.family_name_2#">
			<!---<cfinvokeargument name="name" value="#getUsersToImport.family_name_1#">---><!---PARA EL HCS--->
			<cfinvokeargument name="family_name" value="#getUsersToImport.name#">
			<cfinvokeargument name="email" value="#Trim(getUsersToImport.email_login)#">
			<!---<cfinvokeargument name="telephone" value="">
			<cfinvokeargument name="telephone_ccode" value="">
			<cfinvokeargument name="mobile_phone" value="">
			<cfinvokeargument name="mobile_phone_ccode" value="">--->
			<cfinvokeargument name="password" value="#hash(newPassword)#"/>
			<cfinvokeargument name="password_temp" value="#newPassword#"/>
			<!---<cfif APPLICATION.moduleLdapUsers IS true>--->
			<cfinvokeargument name="login_ldap" value="#Trim(getUsersToImport.login_dmsas)#"/>
			<cfinvokeargument name="login_diraya" value="#Trim(getUsersToImport.login_diraya)#"/>
			<!---</cfif>--->
			<cfinvokeargument name="dni" value="#getUsersToImport.dni#"/>
			<cfinvokeargument name="address" value="#getUsersToImport.address#"/>
			<cfinvokeargument name="sms_allowed" value="false">
			<cfinvokeargument name="whole_tree_visible" value="false">
			<!--- <cfinvokeargument name="whole_tree_visible" value="true"> PARA EL HCS --->

			<cfinvokeargument name="perfil_cabecera" value="#getUsersToImport.perfil_cabecera#"/>
			
			<cfinvokeargument name="return_type" value="xml">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="createRequest" returnvariable="createUserRequest">
			<cfinvokeargument name="request_parameters" value='#xmlUser#'>
		</cfinvoke>

		<!---<cfdump var="#createUserRequest#"/>--->


		<cfxml variable="userResponseXml">
			<cfoutput>
			#createUserResponse#
			</cfoutput>
		</cfxml>

		--->


		<cfset importUserName = "#getUsersToImport.family_name_1# #getUsersToImport.family_name_2#">

		<!---createUser--->
		<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="createUser" returnvariable="createUserResponse">
			<cfinvokeargument name="name" value="#Trim(importUserName)#">
			<!---<cfinvokeargument name="name" value="#getUsersToImport.family_name_1#">---><!---PARA EL HCS--->
			<cfinvokeargument name="family_name" value="#Trim(getUsersToImport.name)#">
			<cfinvokeargument name="email" value="#Trim(getUsersToImport.email_login)#">
			<cfinvokeargument name="password" value="#hash(newPassword)#"/>
			<cfinvokeargument name="password_temp" value="#newPassword#"/>
			<!---<cfif APPLICATION.moduleLdapUsers IS true>--->
			<!---<cfinvokeargument name="login_ldap" value="#Trim(getUsersToImport.login_dmsas)#"/>
			<cfinvokeargument name="login_diraya" value="#Trim(getUsersToImport.login_diraya)#"/>--->
			<!---</cfif>--->
			<cfinvokeargument name="dni" value="#getUsersToImport.dni#"/>
			<cfinvokeargument name="address" value="#Trim(getUsersToImport.address)#"/>
			<cfinvokeargument name="mobile_phone" value="">
			<cfinvokeargument name="mobile_phone_ccode" value="">
			<cfinvokeargument name="telephone" value="">
			<cfinvokeargument name="telephone_ccode" value="">
			<cfinvokeargument name="internal_user" value="false">
			<!--- <cfinvokeargument name="whole_tree_visible" value="true"> PARA EL HCS --->
			<cfinvokeargument name="hide_not_allowed_areas" value="true">
			<cfinvokeargument name="enabled" value="true">

			<!---<cfinvokeargument name="perfil_cabecera" value="#getUsersToImport.perfil_cabecera#"/>--->
			<cfinvokeargument name="information" value="#Trim(getUsersToImport.perfil_cabecera)#">

			<cfinvokeargument name="language" value="es">
		</cfinvoke>

		

		<!---Si la respuesta es un error--->
		<!---<cfif isDefined("userResponseXml.response.error.xmlAttributes.code") AND isValid("integer",userResponseXml.response.error.xmlAttributes.code)>--->
		
		<cfif createUserResponse.result IS false>
			
			<cfoutput>
			<strong>Error al crear el usuario con email #getUsersToImport.email_login#: #createUserResponse.message#</strong><br/>
			</cfoutput>

		<cfelse>

			<cfset created_user_id = createUserResponse.user_id>

			<cfoutput>
			Usuario con email #getUsersToImport.email_login# creado correctamente con ID: #created_user_id#<br/>
			</cfoutput>


			<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="updateUserPreferences" returnvariable="updateUserPreferencesResponse">
				<cfinvokeargument name="update_user_id" value="#created_user_id#">

				<cfinvokeargument name="notify_new_message" value="true">
				<cfinvokeargument name="notify_new_file" value="true">
				<cfinvokeargument name="notify_replace_file" value="true">
				<cfinvokeargument name="notify_new_area" value="true">
				<cfinvokeargument name="notify_new_link" value="true">
				<cfinvokeargument name="notify_new_entry" value="true">
				<cfinvokeargument name="notify_new_news" value="true">
				<cfinvokeargument name="notify_new_event" value="true">
				<cfinvokeargument name="notify_new_task" value="true">
				<cfinvokeargument name="notify_new_consultation" value="true">

				<cfinvokeargument name="notify_new_image" value="true">
				<cfinvokeargument name="notify_new_typology" value="false">
				<cfinvokeargument name="notify_new_list" value="false">
				<cfinvokeargument name="notify_new_list_row" value="false">
				<cfinvokeargument name="notify_new_list_view" value="false">
				<cfinvokeargument name="notify_new_form" value="false">
				<cfinvokeargument name="notify_new_form_row" value="false">
				<cfinvokeargument name="notify_new_form_view" value="false">
				<cfinvokeargument name="notify_new_pubmed" value="false">

				<cfinvokeargument name="notify_delete_file" value="false">
				<cfinvokeargument name="notify_lock_file" value="false">

				<cfinvokeargument name="notify_new_user_in_area" value="false">
				<cfinvokeargument name="notify_been_associated_to_area" value="false">

				<cfinvokeargument name="notify_app_news" value="false">
				<cfinvokeargument name="notify_app_features" value="false">
			</cfinvoke>

			<cfif updateUserPreferencesResponse.result IS true>
				
				<!---<cfoutput>
					Preferencias cambiadas.<br/>
				</cfoutput>--->

			<cfelse>

				<cfoutput>
				<strong>Error al cambiar las preferencias de este usuario.<br/>
				</cfoutput>

			</cfif>

			<cfif isDefined("add_to_areas_ids") AND listLen(add_to_areas_ids,";") GT 0>

				<cfloop list="#add_to_areas_ids#" delimiters=";" index="add_to_area_id">

					<cfif isNumeric(add_to_area_id)>
						
						<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="assignUserToArea" returnvariable="assignToAreaResponse">
							<cfinvokeargument name="area_id" value="#add_to_area_id#">
							<cfinvokeargument name="add_user_id" value="#created_user_id#">
							<cfinvokeargument name="send_alert" value="false">
						</cfinvoke>

						<cfif assignToAreaResponse.result IS true>

							<!---<cfoutput>
								Añadido al área #add_to_area_id#.<br/>
							</cfoutput>--->
						
						<cfelse>

							<cfoutput>
							<strong>Error al añadir el usuario al área: #assignToAreaResponse.message#</strong><br/>
							</cfoutput>

						</cfif>

					</cfif>

				</cfloop>


			</cfif>


		</cfif>		
		

		<br/><br/>

	</cfloop>

	Importación terminada.<br/>

<cfelse>

	-Cada usuario creado en DoPlanning <b>recibirá un correo electrónico</b> con su cuenta y una contraseña generada de forma aleatoria.<br/>
	-Los usuarios no podrán ver todo el árbol de la organización (se crearán como usuarios externos).<br/>
	-A los usuarios se les añadirá por defecto al área indicada a continuación. No se enviará notificación del área o áreas a las que se ha añadido, ni a los usuarios ya existentes en las áreas.<br/>
	-Este proceso no es reversible.<br/>
	-Los usuarios ya existentes en DoPlanning no se podrán crear de nuevo y darán un error 205.<br/>
	-Una vez pulsado el botón "Importar usuarios" <strong>debe esperar unos minutos hasta que se complete la operación</strong>.<br/><br/>

	<cftry>
		
		<cfquery datasource="#client_dsn#" name="getImportedUsersQuery">
			SELECT *
			FROM #SESSION.client_abb#_users_to_import;
		</cfquery>

		<cfif getImportedUsersQuery.recordCount GT 0>

			<script type="text/javascript">

				function onSubmitForm(){
					document.getElementById("submitDiv1").innerHTML = window.lang.translate('Importando...');
				}

			</script>

			<cfoutput>
			<cfform method="post" action="#CGI.SCRIPT_NAME#" onsubmit="onSubmitForm();">
				<!---<label>Client Abb</label>
				<cfinput type="text" name="abb" value="" required="true" message="Client abb requerido">--->
				<label for="client_dsn">Identificador de aplicación DoPlanning en la que se crearán los usuarios:</label>
				<input name="client_dsn" id="client_dsn" type="text" value="#client_dsn#" readonly="true" />
				<!---<label for="area_id">ID de área a la que añadir los usuarios importados</label>
				<cfinput type="text" name="area_id" id="area_id" value="" class="input-mini" validate="integer" required="false" message="Area a la que añadir los usuarios requerida (valor numérico)"/><!---value="5"--->--->
				<label for="areas_ids">IDs de area o áreas a la que añadir los usuarios importados, separadas por ;</label>
				<cfinput type="text" name="areas_ids" id="areas_ids" value="2;4" class="input-mini" required="false"/>
					
				<div style="margin-top:5px" id="submitDiv1">
				<cfinput type="submit" name="import" class="btn btn-primary" value="Importar usuarios">
				</div>
			</cfform>
			</cfoutput>

			<strong>Usuarios a importar:</strong>				
			<cfdump var="#getImportedUsersQuery#" label="#SESSION.client_abb#_users_to_import" metainfo="no">

		<cfelse>

			<strong>No se puede realizar la importación, no hay usuarios para importar.</strong>	

		</cfif>

		<cfcatch>
			<strong>ERROR, no se puede realizar la importación. Antes debe cargar usuarios mediante <a href="import_1_users_from_csv.cfm">1º Cargar desde un CSV los usuarios</a>.</strong>
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
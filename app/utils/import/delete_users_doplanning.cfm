<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_basica_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title# - Eliminar usuarios de DoPlanning</title>
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

<h2>Eliminar usuarios de DoPlanning</h1>

<br/>

<cfset client_abb = SESSION.client_abb>
<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>

<cfquery datasource="#client_dsn#" name="getUsersToDelete">
	SELECT #client_abb#_users.id, #client_abb#_users.email, #client_abb#_users.creation_date, #client_abb#_users.last_connection AS ultima_conexion, number_of_connections, #client_abb#_users.family_name AS nombre, #client_abb#_users.name AS apellidos
	FROM #client_abb#_users
	WHERE ( last_connection IS NULL AND number_of_connections = 0 AND creation_date < MAKEDATE(2012,1) )
	OR last_connection < MAKEDATE(2012,1)
	ORDER BY last_connection DESC;
</cfquery>


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

	<cfdump var="#getUsersToDelete#">
		
	<cfloop query="getUsersToDelete"><!--- startrow --->
		
		<cfset delete_user_id = getUsersToDelete.id>

		<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="xmlUser">
			<cfinvokeargument name="id" value="#delete_user_id#"/>
			
			<cfinvokeargument name="return_type" value="xml">
		</cfinvoke>

		<cfdump var="#xmlUser#">

		<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="createRequest" returnvariable="deleteUserRequest">
			<cfinvokeargument name="request_parameters" value='#xmlUser#'>
		</cfinvoke>

		<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="deleteUser" returnvariable="deleteUserResponse">
			<cfinvokeargument name="request" value="#deleteUserRequest#">
		</cfinvoke>

		<cfxml variable="userResponseXml">
			<cfoutput>
			#deleteUserResponse#
			</cfoutput>
		</cfxml>

		<!---Si la respuesta es un error--->
		<cfif isDefined("userResponseXml.response.error.xmlAttributes.code") AND isValid("integer",userResponseXml.response.error.xmlAttributes.code)>
			
			<cfoutput>
			<strong>Error al eliminar el usuario con ID : #delete_user_id#</strong><br/>
			</cfoutput>

		<cfelse>

			<cfoutput>
			Usuario eliminado con ID: #delete_user_id#<br/>
			</cfoutput>

		</cfif>			

	</cfloop>

	Usuarios eliminados.<br/>

<cfelse>

	-Este proceso no es reversible.<br/>
	-Una vez pulsado el botón "ELIMINAR usuarios" <strong>debe esperar unos minutos hasta que se complete la operación</strong>.<br/><br/>

	<!---<cftry>--->
		
		<cfif getUsersToDelete.recordCount GT 0>

			<script type="text/javascript">

				function onSubmitForm(){
					document.getElementById("submitDiv1").innerHTML = window.lang.translate('Importando...');
				}

			</script>

			<cfoutput>
			<cfform method="post" action="#CGI.SCRIPT_NAME#" onsubmit="onSubmitForm();">
				<label for="client_dsn">Identificador de aplicación DoPlanning en la que se eliminarán los usuarios:</label>
				<input name="client_dsn" id="client_dsn" type="text" value="#client_dsn#" readonly="true" />
				<div style="margin-top:5px" id="submitDiv1">
				<cfinput type="submit" name="import" class="btn btn-primary" value="ELIMINAR usuarios">
				</div>
			</cfform>
			</cfoutput>

			<cfoutput>
				<strong>Usuarios a eliminar (#getUsersToDelete.recordCount#):</strong>
			</cfoutput>			
			<cfdump var="#getUsersToDelete#" label="#SESSION.client_abb#_users_to_delete" metainfo="no">

		<cfelse>

			<strong>No se puede realizar la eliminación, no hay usuarios para eliminar.</strong>	

		</cfif>

		<!---<cfcatch>
			<strong>ERROR, no se puede realizar la eliminación.</strong>
		</cfcatch>		
	</cftry>--->
	
</cfif>

<!-- InstanceEndEditable -->
	<!---</div>--->
	
</div>
<!--- END wrapper --->

</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
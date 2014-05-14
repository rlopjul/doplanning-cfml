<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_basica_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2014 (www.era7.com)-->
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<!---<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />--->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title# - Eliminar usuarios de DoPlanning</title>
<!-- InstanceEndEditable -->
<link href="../../../html/assets/favicon.ico" rel="shortcut icon" type="image/x-icon">
<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">
<link href="#APPLICATION.themeCSSPath#" rel="stylesheet">
<!---
	<script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <link href="//netdna.bootstrapcdn.com/respond-proxy.html" id="respond-proxy" rel="respond-proxy" />
    <link href="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.gif" id="respond-redirect" rel="respond-redirect" />
    <script src="//oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <script src="#APPLICATION.htmlPath#/scripts/respond/respond.proxy.js"></script>
--->
<!--[if lt IE 9]>
	<script src="#APPLICATION.htmlPath#/scripts/html5shiv/html5shiv.js"></script>
    <script src="#APPLICATION.htmlPath#/scripts/respond/respond.min.js"></script>
<![endif]-->
<!--[if lt IE 8]>
  	<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-ie7/bootstrap-ie7.css" rel="stylesheet" rel="stylesheet">
<![endif]-->
<!---<link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome-ie7.min.css" rel="stylesheet">--->
<!--[if IE 7]>
	<link href="#APPLICATION.htmlPath#/font-awesome/css/font-awesome-ie7.min.css" rel="stylesheet">
<![endif]-->

<link href="../../../html/styles/styles.min.css?v=2.1" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "vpnet">
<link href="../../../html/styles/styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="../../../html/styles/styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<!---using caps S (Screen), Pocket IE ignores it. Windows Mobile 6.1 ignores media="handled"--->  
<link href="../../../html/styles/styles_screen.css" rel="stylesheet" type="text/css" media="Screen" />
<link href="../../../html/styles/styles_mobiles.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 800px)" />
<!---<link href="../html/styles_mobiles.css" rel="stylesheet" type="text/css" media="handheld" />
<link href="../html/styles_iphone.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 480px)" />--->
</cfoutput>

<cfif APPLICATION.identifier EQ "vpnet">
	<!---Esto solo debe mantenerse para la versión vpnet (por el Messenger)--->
	<script src="../../../SpryAssets/includes/xpath.js"></script>
	<script src="../../../SpryAssets/includes/SpryData.js"></script>
	<script src="../../../SpryAssets/includes/SpryXML.js"></script>
	<script src="../../../SpryAssets/includes/SpryDOMUtils.js"></script>
	<cfif APPLICATION.moduleMessenger EQ true>
		<script src="../../scripts/App.js"></script>
		<script src="../../../html/scripts/MessengerControl.js"></script>
		<cfif isDefined("SESSION.user_id")>
		<script type="text/javascript">
		window.onload = function (){
			Messenger.Private.initGetNewConversations();
		}
		</script>
		</cfif>
	</cfif>
</cfif>

<cfoutput>
<script src="#APPLICATION.jqueryJSPath#"></script>
<script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang-dp.js" charset="utf-8" ></script>
<script src="#APPLICATION.htmlPath#/language/base_en.js" charset="utf-8"></script>
<script src="../../../html/scripts/functions.min.js?v=2.1"></script>
</cfoutput>

<script type="text/javascript">
	//Language
	jquery_lang_js.prototype.defaultLang = 'es';
	jquery_lang_js.prototype.currentLang = 'es';
	window.lang = new jquery_lang_js();
	
	$().ready(function () {
		window.lang.run();
	});
</script>

<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
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
<div class="div_contenedor_contenido">
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
		FROM APP_clients
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
					document.getElementById("submitDiv1").innerHTML = window.lang.convert('Importando...');
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
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
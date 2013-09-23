<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_basica_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<!--Developed and copyright by Era7 Information Technologies 2007-2013 (www.era7.com)-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /><!--- Fuerza a IE que renderize el contenido en la última versión (que no habilite el modo de compatibilidad) --->
<!---<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />--->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title# - Cargar usuarios desde CSV</title>
<!-- InstanceEndEditable -->
<link href="../../../html/assets/favicon.ico" rel="shortcut icon" type="image/x-icon">
<link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
<link href="#APPLICATION.baseCSSIconsPath#" rel="stylesheet">

<link href="../../../html/styles/styles.min.css" rel="stylesheet" type="text/css" media="all" />
<cfif APPLICATION.identifier EQ "vpnet">
<link href="../../../html/styles/styles_vpnet.css" rel="stylesheet" type="text/css" media="all" />
<cfelse>
<link href="../../../html/styles/styles_dp.css" rel="stylesheet" type="text/css" media="all" />
</cfif>
<!--using caps S (Screen), Pocket IE ignores it. Windows Mobile 6.1 ignores media="handled"-->  
<link href="../../../html/styles/styles_screen.css" rel="stylesheet" type="text/css" media="Screen" />
<link href="../../../html/styles/styles_mobiles.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 800px)" />
<!---<link href="../html/styles_mobiles.css" rel="stylesheet" type="text/css" media="handheld" />
<link href="../html/styles_iphone.css" rel="stylesheet" type="text/css" media="only screen and (max-device-width: 480px)" />--->
</cfoutput>

<cfif APPLICATION.identifier EQ "vpnet">
	<!---Esto solo debe mantenerse para la versión vpnet (por el Messenger)--->
	<script type="text/javascript" src="../../../SpryAssets/includes/xpath.js"></script>
	<script type="text/javascript" src="../../../SpryAssets/includes/SpryData.js"></script>
	<script type="text/javascript" src="../../../SpryAssets/includes/SpryXML.js"></script>
	<script type="text/javascript" src="../../../SpryAssets/includes/SpryDOMUtils.js"></script>
	<cfif APPLICATION.moduleMessenger EQ true>
		<script type="text/javascript" src="../../scripts/App.js"></script>
		<script type="text/javascript" src="../../../html/scripts/MessengerControl.js"></script>
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
<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.js" charset="utf-8" ></script>
<script src="#APPLICATION.htmlPath#/language/base_en.js" charset="utf-8" type="text/javascript"></script>
<script type="text/javascript" src="../../../html/scripts/functions.min.js"></script>
</cfoutput>

<script type="text/javascript">
	//Language
	jquery_lang_js.prototype.defaultLang = 'es';
	jquery_lang_js.prototype.currentLang = 'es';
	window.lang = new jquery_lang_js();
	
	$().ready(function () {
		//Language
		window.lang.run();
	});
</script>

<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
</head>

<body class="body_global">
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

<h2>1º Cargar usuarios a partir de CSV</h1>

<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

		
<cfif isDefined("FORM.file") AND isDefined("FORM.table_to")>
							
		<cfinvoke component="ImportData" method="importTable" returnvariable="result" argumentcollection="#FORM#">
		</cfinvoke>		
		
		<cfif result.result IS true><!---The insert or modify is success--->

			<cfset message = #result.message#>
			<cfset alert_class = "alert-success">
			
		<cfelse><!---There is an error in the insert--->
		
			<cfset message = #result.message#>
			<cfset alert_class = "alert-error">
			
		</cfif>
		
		<cfoutput>
		<div class="alert #alert_class#">#message#</div>
		

		<strong>Datos importados:</strong>
		<cfquery datasource="#client_dsn#" name="getImportedUsersQuery">
			SELECT *
			FROM #SESSION.client_abb#_users_to_import;
		</cfquery>						
		
		<cfdump var="#getImportedUsersQuery#" label="#SESSION.client_abb#_users_to_import" metainfo="no">

		<div style="margin-top:10px"><a href="#CGI.SCRIPT_NAME#" class="btn">Volver</a></div>

		</cfoutput>
<cfelse>
	
		<cfset numColumns = 9>
		<cfset arrayColumnsTo = arrayNew(1)>
		<cfset arrayColumnsTo[1] = "email_login">
		<cfset arrayColumnsTo[2] = "name">
		<cfset arrayColumnsTo[3] = "family_name_1">
		<cfset arrayColumnsTo[4] = "family_name_2">
		<cfset arrayColumnsTo[5] = "dni"><!---ESTE CAMPO NO SE USA PARA CREAR EL USUARIO SE USA EL NIF, POR LO QUE ESTE CAMPO SE PUEDE QUITAR UNO DE LOS DOS--->
		<cfset arrayColumnsTo[6] = "nif">
		<cfset arrayColumnsTo[7] = "address">
		<!---<cfif APPLICATION.moduleLdapUsers IS true>--->
			<cfset arrayColumnsTo[8] = "login_dmsas">
			<cfset arrayColumnsTo[9] = "login_diraya">
		<!---</cfif>--->
		<!---<cfset arrayColumnsTo[10] = "province">
		<cfset arrayColumnsTo[11] = "phone_es">
		<cfset arrayColumnsTo[12] = "fax_es">
		<cfset arrayColumnsTo[13] = "web_es">
		<cfset arrayColumnsTo[14] = "contact_name_es">
		<cfset arrayColumnsTo[15] = "charge_es">
		<cfset arrayColumnsTo[16] = "email_login">--->
		
		<cfset arrayColumnsFrom = arrayNew(1)>
		<cfset arrayColumnsFrom[1] = "email_login">
		<cfset arrayColumnsFrom[2] = "name">
		<cfset arrayColumnsFrom[3] = "family_name_1">
		<cfset arrayColumnsFrom[4] = "family_name_2">
		<cfset arrayColumnsFrom[5] = "dni"><!---ESTE CAMPO NO SE USA PARA CREAR EL USUARIO SE USA EL NIF, POR LO QUE ESTE CAMPO SE PUEDE QUITAR UNO DE LOS DOS--->
		<cfset arrayColumnsFrom[6] = "nif">
		<cfset arrayColumnsFrom[7] = "address">
		<!---<cfif APPLICATION.moduleLdapUsers IS true>--->
			<cfset arrayColumnsFrom[8] = "login_dmsas">
			<cfset arrayColumnsFrom[9] = "login_diraya">
		<!---</cfif>--->
		<!---<cfset arrayColumnsFrom[10] = "PROVINCIA">
		<cfset arrayColumnsFrom[11] = "TEL">
		<cfset arrayColumnsFrom[12] = "FAX">
		<cfset arrayColumnsFrom[13] = "WEB">
		<cfset arrayColumnsFrom[14] = "CONTACTO">
		<cfset arrayColumnsFrom[15] = "CARGO">
		<cfset arrayColumnsFrom[16] = "CORREO ELECTRONICO">--->
		

		<cfoutput>

		<br/>
		
		El archivo utilizado para realizar esta importación deberá tener las siguientes características:<br/>
		
		<p style="padding-left:12px;">
			-Debe ser un <strong>archivo .csv delimitado por ; codificado en iso-8859-1</strong> (codificación por defecto en Windows).<br />
			-El <strong>orden de las columnas</strong> requerido es:<br />
			<em><cfloop from="1" to="#arrayLen(#arrayColumnsFrom#)#" index="curIndex" step="1">
			#arrayColumnsFrom[curIndex]#
				<cfif curIndex LT arrayLen(arrayColumnsFrom)>
				,
				</cfif>
			</cfloop></em><br/>
			-Cualquier cambio de orden de columnas provocará un error al cargar los datos o unos datos cargados incorrectos.<br/>
			<!----En el archivo no debe aparecer ninguna fila con los títulos de las columnas.<br/>--->
			-La primera fila del archivo corresponderá a los títulos de las columnas. Los títulos de las columnas pueden ser diferentes a los indicados, pero <strong>no pueden contener espacios, tildes o caracteres especiales</strong>.<br/>
			-Si no se cumplen las características anteriores, la importación no se podrá realizar correctamente.
			<br/>
			-<a href="usuarios_ejemplo.csv">Aquí</a> puede descargar un archivo de ejemplo.<br/>
		</p><br/>

		Detalle de esta importación:
		<p style="padding-left:12px;">
			-Al realizar esta carga <strong>se borrarán todos los datos de usuarios cargados previamente mediante esta página</strong>, por lo tanto cada vez que se suba un archivo se perderán los datos cargados en el anterior.<br/>
			-Los usuarios cargados mediante esta página no afectan a los existente en DoPlanning.<br/>
			-En esta carga los usuarios no recibirán ningún tipo de notificación.<br/>
			-Si la importación se lleva a cabo correctamente, se mostrarán los datos importados. Es necesario comprobar que estos datos son correctos y que no hay ningún error en los mismos.<br/>
			-Para crear en DoPlanning los usuarios, tras cargarlos mediante esta página es necesario seguir con el siguiente paso: <a href="import_2_users_to_doplanning.cfm" target="_blank">2º Crear los usuarios cargados en DoPlanning.</a><br/>
			-Una vez pulsado el botón "Cargar usuarios" <strong>debe esperar unos minutos hasta que se complete la operación</strong>.
		</p>
		<br/>
		
		

		<!---<cfloop from="1" to="#arrayLen(#arrayColumnsTo#)#" index="curIndex" step="1">
		#arrayColumnsTo[curIndex]#
			<cfif curIndex LT arrayLen(arrayColumnsTo)>
			,
			</cfif>
		</cfloop>--->

		<script type="text/javascript">

			function onSubmitForm(){
				document.getElementById("submitDiv1").innerHTML = window.lang.convert('Cargando...');
			}

		</script>

		<cfform name="import_data" method="post" action="#CGI.SCRIPT_NAME#" enctype="multipart/form-data" onsubmit="onSubmitForm();">
			
			<input name="num_colums" value="#numColumns#" type="hidden" />
				
			<cfloop from="1" to="#numColumns#" index="curColum">
			<input type="hidden" name="col_to_#curColum#" value="#arrayColumnsTo[#curColum#]#"/>
			</cfloop>
			
			<label for="client_dsn">Identificador de aplicación DoPlanning para la que se cargarán los usuarios:</label>
			<input name="client_dsn" id="client_dsn" type="text" value="#client_dsn#" readonly="true" />	
			
			<label for="table_to">Tabla donde se cargarán los usarios</label>
			<input type="text" name="table_to" id="table_to" value="#SESSION.client_abb#_users_to_import" readonly="true"/>

			<label for="file">Archivo CSV con los usuarios a importar</label>
			<cfinput name="file" id="file" type="file" width="100%" required="yes" message="Archivo de datos requerido para la actualización" />
			<div style="margin-top:5px" id="submitDiv1">
				<input type="submit" value="Cargar usuarios" class="btn btn-primary" />
			</div>
					
		</cfform>
		</cfoutput>
	
	
</cfif>

<!-- InstanceEndEditable -->
</div>
</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>
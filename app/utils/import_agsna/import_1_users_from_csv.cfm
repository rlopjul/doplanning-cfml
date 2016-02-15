<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_basica_general_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title# - Cargar usuarios desde CSV</title>
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
		<cfset arrayColumnsTo[5] = "dni">
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
		<cfset arrayColumnsFrom[5] = "dni">
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
				document.getElementById("submitDiv1").innerHTML = window.lang.translate('Cargando...');
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
	<!---</div>--->

</div>
<!--- END wrapper --->

</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>

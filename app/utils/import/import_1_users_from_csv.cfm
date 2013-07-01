<cfif SESSION.client_administrator EQ SESSION.user_id>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>


<cfif isDefined("FORM.file") AND isDefined("FORM.table_to")>
							
		<cfinvoke component="ImportData" method="importTable" returnvariable="result" argumentcollection="#FORM#">
		</cfinvoke>		
		
		<cfif result.result IS true><!---The insert or modify is success--->

			<cfset message = #result.message#>
			
		<cfelse><!---There is an error in the insert--->
		
			<cfset message = #result.message#>
			
		</cfif>
		
		<cfoutput>
		<br/><br/>
		<div class="div_message">#message#</div>
		</cfoutput>						
		
<cfelse>
	
	
	
		<br/><br/>
		
		<cfset numColumns = 9>
		<cfset arrayColumnsTo = arrayNew(1)>
		<cfset arrayColumnsTo[1] = "login">
		<cfset arrayColumnsTo[2] = "name">
		<cfset arrayColumnsTo[3] = "family_name_1">
		<cfset arrayColumnsTo[4] = "family_name_2">
		<cfset arrayColumnsTo[5] = "login_dmsas">
		<cfset arrayColumnsTo[6] = "login_diraya">
		<cfset arrayColumnsTo[7] = "dni">
		<cfset arrayColumnsTo[8] = "nif">
		<cfset arrayColumnsTo[9] = "address">
		<!---<cfset arrayColumnsTo[10] = "province">
		<cfset arrayColumnsTo[11] = "phone_es">
		<cfset arrayColumnsTo[12] = "fax_es">
		<cfset arrayColumnsTo[13] = "web_es">
		<cfset arrayColumnsTo[14] = "contact_name_es">
		<cfset arrayColumnsTo[15] = "charge_es">
		<cfset arrayColumnsTo[16] = "email_login">--->
		
		<cfset arrayColumnsFrom = arrayNew(1)>
		<cfset arrayColumnsFrom[1] = "login">
		<cfset arrayColumnsFrom[2] = "name">
		<cfset arrayColumnsFrom[3] = "family_name_1">
		<cfset arrayColumnsFrom[4] = "family_name_2">
		<cfset arrayColumnsFrom[5] = "login_dmsas">
		<cfset arrayColumnsFrom[6] = "login_diraya">
		<cfset arrayColumnsFrom[7] = "dni">
		<cfset arrayColumnsFrom[8] = "nif">
		<cfset arrayColumnsFrom[9] = "address">
		<!---<cfset arrayColumnsFrom[10] = "PROVINCIA">
		<cfset arrayColumnsFrom[11] = "TEL">
		<cfset arrayColumnsFrom[12] = "FAX">
		<cfset arrayColumnsFrom[13] = "WEB">
		<cfset arrayColumnsFrom[14] = "CONTACTO">
		<cfset arrayColumnsFrom[15] = "CARGO">
		<cfset arrayColumnsFrom[16] = "CORREO ELECTRONICO">--->
		

		
		<cfoutput>
		<p>
		Importar los datos mediante un archivo .csv delimitado por ; codificado en iso-8859-1 (codificación por defecto en Windows).<br/><br/>
		Para realizar la importación debe tener en cuenta lo siguiente:<br/>
			<div style="padding-left:12px;">
			-El orden de las columnas requerido es:<br />
			<em><cfloop from="1" to="#arrayLen(#arrayColumnsFrom#)#" index="curIndex" step="1">
			#arrayColumnsFrom[curIndex]#
				<cfif curIndex LT arrayLen(arrayColumnsFrom)>
				,
				</cfif>
			</cfloop></em><br/>
			-Cualquier cambio de orden de columnas provocará un error al actualizar la tabla o una actualización incorrecta.<br/>
<!----En el archivo no debe aparecer ninguna fila con los títulos de las columnas.<br/>--->
-Los títulos de las columnas pueden ser diferentes a los indicados, pero no pueden contener espacios, tildes o caracteres especiales.<br/>
-Una vez pulsado el botón actualizar debe esperar unos minutos hasta que se complete la operación.<br/>

-<strong>Al realizar esta actualización se perderán todos los datos existentes en la tabla.</strong>
			</div>
		</p><br/><br/>
		
		

		<!---<cfloop from="1" to="#arrayLen(#arrayColumnsTo#)#" index="curIndex" step="1">
		#arrayColumnsTo[curIndex]#
			<cfif curIndex LT arrayLen(arrayColumnsTo)>
			,
			</cfif>
		</cfloop>--->
		
		<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

		<cfform name="import_data" method="post" action="#CGI.SCRIPT_NAME#" enctype="multipart/form-data" onsubmit="hideButtom('submitButton');">
			<label>CLIENT DSN</label><input name="client_dsn" type="text" value="#client_dsn#" readonly="true" />
			<input name="num_colums" value="#numColumns#" type="hidden" />
			<input type="hidden" name="table_to" value="#SESSION.client_abb#_users_to_import" />
				
			<cfloop from="1" to="#numColumns#" index="curColum">
			<input type="hidden" name="col_to_#curColum#" value="#arrayColumnsTo[#curColum#]#"/>
			</cfloop>
			<table style="width:100%">
				<tr>
					<td style="width:25%;"><span class="attribute_normal">Archivo CSV</span></td>
					<td style="width:70%;"><cfinput name="file" type="file" width="100%" required="yes" message="Archivo de datos requerido para la actualización" /></td>
					<td style="width:5%;"></td>
				</tr>									
				<tr>
					<td></td>
					<td><span id="submitButton" class="text_wait"><input type="submit" value="Importar" class="input_submit" /></span></td>
					<td></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td></td>
					<td></td>
				</tr>
			</table>
			
		</cfform>
		</cfoutput>
	
	
	</cfif>


</body>
</html>

</cfif>

<!--- 

SCRIPT para crear la tabla

CREATE TABLE `dp_software7`.`software7_users_to_import` (
  `user_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `login` VARCHAR(255) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `family_name_1` VARCHAR(255) NOT NULL,
  `family_name_2` VARCHAR(255) NOT NULL,
  `login_dmsas` VARCHAR(255) NOT NULL,
  `login_diraya` VARCHAR(255) NOT NULL,
  `dni` VARCHAR(255) NOT NULL,
  `nif` VARCHAR(255) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`user_id`)
)
ENGINE = InnoDB;

--->
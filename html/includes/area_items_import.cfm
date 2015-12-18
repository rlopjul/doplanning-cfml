<cfif isDefined("URL.itemTypeId") AND isNumeric(URL.itemTypeId)>

<cfset itemTypeId = URL.itemTypeId>

<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfif isDefined("FORM.files")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="importItems" returnvariable="actionResponse" argumentcollection="#FORM#">
	</cfinvoke>

	<cfif actionResponse.result IS true><!---The import is success--->

		<cflocation url="area_items.cfm?area=#area_id#&res=1&msg=#actionResponse.message#" addtoken="false">

	<cfelse><!---There is an error in the import--->

		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset fileArray = actionResponse.fileArray>

	</cfif>

</cfif>

<cfif app_version NEQ "mobile">
	<cfoutput>
	<div class="div_message_page_title">#table.title#</div>
	<div class="div_separator"><!-- --></div>
	</cfoutput>
</cfif>

<div class="div_head_subtitle">
	<cfoutput>
	<span lang="es">Importar #uCase(itemTypeNameEsP)#</span>
	</cfoutput>
</div>

<div class="div_separator"><!-- --></div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="contenedor_fondo_blanco">

<cfoutput>

<cfif isDefined("fileArray") AND arrayLen(fileArray) GT 0>

	<h5>Valores cargados del archivo:</h5>
	<table class="table-bordered" style="font-size:10px; margin-bottom:20px;">
		<tbody>

			<tr>
				<td></td>
				<cfloop from="1" to="#ArrayLen(fileArray[1])#" step="1" index="curColumn">
					<td style="color:##CCCCCC">#curColumn#</td>
				</cfloop>
			</tr>
		<cfloop from="1" to="#ArrayLen(fileArray)#" step="1" index="curRow">

			<tr>
				<td style="color:##CCCCCC">#curRow#</td>
			<cfloop from="1" to="#ArrayLen(fileArray[1])#" step="1" index="curColumn">

				<cfset fieldValue = fileArray[curRow][curColumn]>
				<td>#fieldValue#</td>

			</cfloop>
			</tr>

		</cfloop>
		</tbody>
	</table>

</cfif>

	<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypeFields" returnvariable="itemTypeFields">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		<cfinvokeargument name="import" value="true">
	</cfinvoke>

	<cfset itemTypesFieldsSorted = structSort(itemTypeFields, "numeric", "asc", "position")>

	<p class="help-block" style="font-size:12px;">
		<span lang="es">El archivo utilizado para realizar esta importación deberá tener las siguientes características:</span><br/>

			<span lang="es">-Tipo de archivo:</span> <strong lang="es">.csv o .txt</strong> <span lang="es">delimitado por ; o por tabulaciones.</span><br>
			<span lang="es">Punto y coma es la delimitación por defecto en el SO Windows en España (esto varía en configuraciones por defecto de otros paises o idiomas).</span><br/>
			-<span lang="es">Codificación</span>: <strong>Windows-1252</strong> <span lang="es">(codificación por defecto en Windows)</span>.<br /><!---iso-8859-1--->

			-<span lang="es">Número de columnas</span>: <strong>#structCount(itemTypeFields)#</strong>.<br />

			-<strong lang="es">Orden de las columnas</strong>:<br />
			<em><cfloop array="#itemTypesFieldsSorted#" index="fieldName">
				<cfset field = itemTypeFields[fieldName]>
				#field.label#,
			</cfloop></em><br/>

			<span lang="es">-Si el orden de las columnas no corresponde con el anterior la importación no se realizará correctamente.</span><br/>
			-<strong lang="es">Campos fecha</strong>: <span lang="es">formatos válidos las fechas:</span> <i lang="es">DD-MM-AAAA, DD/MM/AAAA</i>.<br/>

			<span lang="es">-Si no se cumplen las características anteriores, la importación no se podrá realizar correctamente.</span>
			<br/>
			<!--- -<a href="usuarios_ejemplo.csv">Aquí</a> puede descargar un archivo de ejemplo.<br/>--->
		<br/>
		<span lang="es">No se enviará notificación instantánea de los nuevos elementos a los usuarios.</span><br/>
		<span lang="es">Una vez pulsado el botón "Importar elementos" debe esperar hasta que se complete la operación.</span>
	</p>

	<script type="text/javascript">

		function onSubmitForm(){

			document.getElementById("submitDiv1").innerHTML = window.lang.translate('Enviando...');

		}

	</script>

	<cfform name="import_data" method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" enctype="multipart/form-data" onsubmit="onSubmitForm();" class="form-horizontal">

		<input type="hidden" name="itemTypeId" value="#itemTypeId#" />
		<input type="hidden" name="area_id" value="#area_id#" />

		<div class="row">
			<div class="col-sm-6">
				<label class="control-label" for="file" lang="es">Archivo CSV con los registros a importar</label>
				<cfinput name="files[]" id="file" type="file" required="yes" accept=".csv,.tsv,text/plain" message="Archivo de datos requerido para la importación" class="form-control">
			</div>
		</div>

		<div class="row">
			<label for="delimiter" class="col-xs-6 col-sm-3 col-md-2 control-label" style="text-align:left" lang="es">Delimitador de campos</label>
			<div class="col-xs-5 col-sm-3 col-md-3">
				<select name="delimiter" id="delimiter" class="form-control">
					<option value=";" <cfif isDefined("FORM.delimiter") AND FORM.delimiter EQ ";">selected="selected"</cfif> lang="es">Punto y coma ;</option>
					<option value="tab" <cfif isDefined("FORM.delimiter") AND FORM.delimiter EQ "tab">selected="selected"</cfif> lang="es">Tabulación</option>
				</select>
			</div>
		</div>

		<div class="row">
			<div class="col-sm-12">
		      <div class="checkbox">
		        <label>
		          <input type="checkbox" name="start_row" value="1"<cfif isDefined("FORM.start_row")>checked</cfif>> <span lang="es">Importar primera fila del archivo</span>
		        </label>
		        <small class="help-block" style="margin-bottom:0" lang="es">Por defecto no se importa la primera fila del archivo (fila para los títulos de las columnas)</small>
		      </div>
		    </div>
		</div>

		<div class="row" style="margin-top:20px">
			<div class="col-sm-12" id="submitDiv1">
				<input type="submit" value="Importar elementos" class="btn btn-primary" lang="es" />

				<a href="area_items.cfm?area=#area_id#" class="btn btn-default" style="float:right" lang="es">Cancelar</a>
			</div>
		</div>

	</cfform>



</cfoutput>

</div><!--- END contenedor_fondo_blanco --->

</cfif><!--- URL.itemTypeId --->

<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
	<cfset table_id = URL[tableTypeName]>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>

<cfif isDefined("FORM.file")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="importRowsXml" returnvariable="actionResponse" argumentcollection="#FORM#">
	</cfinvoke>

	<!---<cfdump var="#actionResponse#">--->

	<cfif actionResponse.result IS true><!---The import is success--->

		<cflocation url="#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#&res=1&msg=#actionResponse.message#" addtoken="false">

	<cfelse><!---There is an error in the import--->

		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset fileArray = actionResponse.fileArray>

	</cfif>

</cfif>

<!--- Table --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<cfset area_id = table.area_id>

<!---Table fields--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	<cfinvokeargument name="with_types" value="true"/>
</cfinvoke>
<cfset fields = fieldsResult.tableFields>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfif app_version NEQ "mobile">
	<cfoutput>
	<div class="div_message_page_title">#table.title#</div>
	<div class="div_separator"><!-- --></div>
	</cfoutput>
</cfif>

<div class="div_head_subtitle">
	<span lang="es">Importar registros a partir de archivo XML</span>
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

	<cfset booleanFields = false>
	<cfset dateFields = true>
	<cfset listFields = true>

	<p class="help-block" style="font-size:12px;">
		<span lang="es">El archivo utilizado para realizar esta importación deberá tener las siguientes características:</span><br/>

			<span lang="es">-Tipo de archivo:</span> <strong lang="es">.xml</strong> <br>
			-<span lang="es">Codificación</span>: <strong>UTF-8</strong>.<br />

			<span lang="es">-Si no se cumplen las características anteriores, la importación no se podrá realizar correctamente.</span>
			<br/>
			<!--- -<a href="usuarios_ejemplo.csv">Aquí</a> puede descargar un archivo de ejemplo.<br/>--->
		<br/>
		<span lang="es">No se enviará notificación instantánea de los nuevos registros a los usuarios.</span><br/>
		<span lang="es">Una vez pulsado el botón "Importar registros" debe esperar hasta que se complete la operación, que puede llevar unos minutos.</span>
	</p>

	<script type="text/javascript">

		function onSubmitForm(){

			document.getElementById("submitDiv1").innerHTML = window.lang.translate('Enviando...');

		}

	</script>

	<cfform name="import_data" method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" enctype="multipart/form-data" onsubmit="onSubmitForm();" class="form-horizontal">

		<input type="hidden" name="table_id" value="#table_id#" />
		<input type="hidden" name="tableTypeId" value="#tableTypeId#" />

		<div class="row">
			<div class="col-sm-6">
				<label class="control-label" for="file" lang="es">Archivo XML con los registros a importar</label>
				<cfinput name="file" id="file" type="file" required="yes" accept=".xml,text/plain" message="Archivo de datos requerido para la importación" class="form-control">
			</div>
		</div>

		<div class="row">
			<div class="col-sm-12">
		      <div class="checkbox">
		        <label>
		          <input type="checkbox" name="delete_rows" value="true" <cfif isDefined("FORM.delete_rows")>checked</cfif>> <span lang="es">Borrar todos los registros existentes en <cfif tableTypeGender EQ "male">el<cfelse>la</cfif> #tableTypeNameEs#</span>
		        </label>
		      </div>
		    </div>
		</div>

		<!---<div class="row">
			<div class="col-sm-12">
		      <div class="checkbox">
		        <label>
		          <input type="checkbox" name="cancel_on_error" value="false" <cfif isDefined("FORM.cancel_on_error")>checked</cfif>> <span lang="es">No cancelar si hay errores en importación de registros</span>
		        </label>
		      </div>
		    </div>
		</div>--->

		<div class="row" style="margin-top:20px">
			<div class="col-sm-12" id="submitDiv1">
				<input type="submit" value="Importar registros" class="btn btn-primary" lang="es" />

				<a href="#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#&area=#area_id#" class="btn btn-default" style="float:right" lang="es">Cancelar</a>
			</div>
		</div>

	</cfform>



</cfoutput>

</div><!--- END contenedor_fondo_blanco --->

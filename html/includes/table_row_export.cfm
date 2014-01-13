<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
	<cfset table_id = URL[tableTypeName]>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>

<!--- Table --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<cfset area_id = table.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>
<div class="div_message_page_title">#table.title#</div>
<div class="div_separator"><!-- --></div>
</cfoutput>

<div class="div_head_subtitle">
	<span lang="es">Exportar registros</span>
</div>

<div class="div_separator"><!-- --></div>

<div class="contenedor_fondo_blanco">

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfoutput>

	<p class="help-block" style="font-size:12px;">
		Se generará un archivo con codificación iso-8859-1 con el contenido de los registros.
	</p>

	<script type="text/javascript">

		function onSubmitForm(){

			document.getElementById("submitDiv1").innerHTML = window.lang.convert('Exportación solicitada...');

			showLoading = false;
		}

	</script>

	<cfform name="export_data" method="post" action="table_row_export_download.cfm?#CGI.QUERY_STRING#" onsubmit="onSubmitForm();" class="form-horizontal">

		<input type="hidden" name="table_id" value="#table_id#" />
		<input type="hidden" name="tableTypeId" value="#tableTypeId#" />

		<div class="row">
			<label for="delimiter" class="col-xs-6 col-sm-3 col-md-2 control-label" style="text-align:left">Delimitador de campos</label>
			<div class="col-xs-5 col-sm-3 col-md-3">
				<select name="delimiter" id="delimiter" class="form-control">
					<option value=";" <cfif isDefined("FORM.delimiter") AND FORM.delimiter EQ ";">selected="selected"</cfif>>Punto y coma ;</option>
					<option value="tab" <cfif isDefined("FORM.delimiter") AND FORM.delimiter EQ "tab">selected="selected"</cfif>>Tabulación</option>
				</select>
			</div>
		</div>

		<div class="row">
			<div class="col-sm-12">
		      <b>Incluir las siguientes columnas:</b>
		    </div>
		</div>

		<div class="row">
			<div class="col-sm-12">
		      <div class="checkbox">
		        <label>
		          <input type="checkbox" name="include_creation_date" value="true">Fecha de creación</label>
		      </div>
		    </div>
		</div>

		<div class="row">
			<div class="col-sm-12">
		      <div class="checkbox">
		        <label>
		          <input type="checkbox" name="include_last_update_date" value="true">Fecha de última modificación</label>
		      </div>
		    </div>
		</div>

		<div class="row">
			<div class="col-sm-12">
		      <div class="checkbox">
		        <label>
		          <input type="checkbox" name="include_insert_user" value="true">Usuario creación</label>
		      </div>
		    </div>
		</div>

		<div class="row">
			<div class="col-sm-12">
		      <div class="checkbox">
		        <label>
		          <input type="checkbox" name="include_update_user" value="true">Usuario última modificación</label>
		      </div>
		    </div>
		</div>

		<div class="row" style="margin-top:20px">
			<div class="col-sm-12" id="submitDiv1">
				<input type="submit" value="Exportar registros" class="btn btn-primary" />
				<a href="#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#&area=#area_id#" class="btn btn-default" style="float:right" lang="es">Cancelar</a>
			</div>
		</div>
				
	</cfform>



</cfoutput>
	
</div><!--- END contenedor_fondo_blanco --->
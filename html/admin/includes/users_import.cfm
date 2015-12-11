<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="isUserUserAdministrator" returnvariable="isUserUserAdministratorResponse">
	<cfinvokeargument name="check_user_id" value="#SESSION.user_id#">
</cfinvoke>

<cfif isUserUserAdministratorResponse.result IS 0 OR isUserUserAdministratorResponse.isUserAdministrator NEQ true>

	<div class="alert alert-warning" role="alert"><i class="fa fa-warning"></i> <span lang="es">No dispone de permiso.</span></div>

<cfelse>

	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 lang="es">Importar usuarios</h4>
		</div>

	 	<div class="modal-body">

			<script>
			function postImportUsersForm() {

				$('body').modalmanager('loading');

				$('##fileupload').fileupload('send', {fileInput: $('##file')})
    			.success(function ( data, status ) {

    				if(status == "success"){

				  		var result = $.parseJSON(data);
				  		var message = result.message;

							if(result == true)
				  			hideDefaultModal();

				  		$('body').modalmanager('removeLoading');

				  		showAlertMessage(message, result.result);

				  	}else
							showAlertErrorModal(status);

    			}).error(function ( data, status )  {

    				showAlertErrorModal(status);

    			}).complete(function ( data, status )  { });

			}


			$(function () {
			    $('##fileupload').fileupload({
			        dataType: 'text',
			        autoUpload: false,
			        replaceFileInput: false,
			        fileInput: $('##file'),
			        forceIframeTransport: true //Required to enable upload in IE
			        /*submit: function (e, data) {
			        	return false;
			        },*/
			    });

			    setImportType("xml");
			});


			function setImportType(importType) {

				/*if(importType == "xml"){

					$("##xmlImportInputs").show();
					$("##cssImportInputs").hide();

				}else{*/

					//$("##xmlImportInputs").hide();
					$("##cssImportInputs").show();

				//}

			}


			</script>

			<div id="progress">
			    <div class="bar" style="width: 0%;"></div>
			</div>

			<form id="fileupload" action="#APPLICATION.htmlComponentsPath#/User.cfc?method=importUsers" method="post" enctype="multipart/form-data" class="form-horizontal">

				<!---
				<div class="row">
					<label for="import_type" class="col-xs-5 col-sm-2 col-md-3 control-label" style="text-align:left" lang="es">Tipo de importación</label>
					<div class="col-xs-7 col-sm-10 col-md-9">
						<select name="import_type" id="importType" class="form-control" onchange="setImportType($('##importType').val());">
							<option value="xml" <cfif isDefined("FORM.import_type") AND FORM.import_type EQ "xml">selected="selected"</cfif>>Archivo XML (importación de varios niveles de áreas)</option>
							<option value="txt" <cfif isDefined("FORM.import_type") AND FORM.import_type EQ "txt">selected="selected"</cfif>>Archivo CSV (importación de un sólo nivel de áreas)</option>
						</select>
					</div>
				</div>
				--->

				<input type="hidden" name="import_type" value="csv" />



				<!--- Users Typologies --->

				<cfset typologyTableTypeId = 4>

				<cfset selected_typology_id = "null">

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAllTypologies" returnvariable="getAllTypologiesResponse">
					<cfinvokeargument name="tableTypeId" value="#typologyTableTypeId#">
				</cfinvoke>
				<cfset typologies = getAllTypologiesResponse.query>

				<cfif typologies.recordCount GT 0>

					<div class="row">

						<div class="col-sm-12">

							<label for="typology_id" class="col-xs-5 col-sm-3 control-label" lang="es">Tipología</label>

							<div class="col-xs-7 col-sm-9">

								<select name="typology_id" id="typology_id" class="form-control" onchange="loadTypology($('##typology_id').val());">
									<option value="null" <cfif selected_typology_id EQ "null">selected="selected"</cfif> lang="es">Básica</option>
									<cfif typologies.recordCount GT 0>
										<cfloop query="typologies">
											<option value="#typologies.id#" <cfif typologies.id IS selected_typology_id>selected="selected"</cfif>>#typologies.title#</option>
										</cfloop>
									</cfif>
								</select>

							</div>

						</div>

					</div>

				</cfif>

				<div class="row">
					<div class="col-sm-12">
						<noscript><b>Debe habilitar JavaScript para la subida de archivos</b></noscript>
						<label class="control-label" for="file">Archivo con las áreas a importar</label>
						<input type="file" name="files[]" id="file" multiple required="true" accept=".csv,.tsv,text/plain,.xml" message="Archivo de datos requerido para la importación" class="form-control">
					</div>
				</div>


				<div class="row">
					<div class="col-sm-12">
							<div class="checkbox">
								<label>
									<input type="checkbox" name="notify_user" value="1"<cfif isDefined("FORM.notify_user")>checked</cfif>> <span lang="es">Enviar email con usuario y contraseña</span>
								</label>
								<small class="help-block" lang="es">Envía a cada usuario un email con su cuenta de usuario y contraseña</small>
							</div>
						</div>
				</div>


				<div id="cssImportInputs">

					<div class="row">
						<label for="delimiter" class="col-xs-6 col-sm-3 col-md-4 control-label" style="text-align:left" lang="es">Delimitador de campos</label>
						<div class="col-xs-5 col-sm-3 col-md-4">
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
					        <small class="help-block" lang="es">Por defecto no se importa la primera fila del archivo (fila para los títulos de las columnas)</small>
					      </div>
					    </div>
					</div>


					<p class="help-block" style="font-size:12px;" lang="es">
						El archivo utilizado para realizar esta importación deberá tener las siguientes características:<br/>

							-Tipo de archivo: <strong>.csv o .txt</strong> delimitado por ; o por tabulaciones.<br/>
							-Codificación: <strong>iso-8859-1</strong> (codificación por defecto en Windows).<br />
							-Cada fila del archivo corresponderá a un usuario.<br/>
							-<strong>Orden de las columnas que deberá tener el archivo</strong>:<br />
							<em>Email, Nombre, Apellidos, Dirección, Código País Teléfono, Teléfono, Teléfono, Código País, Móvil, Móvil, Usuario interno, Activo<cfif SESSION.client_abb EQ "hcs">, Perfil de cabecera</cfif></em>
							<br/>
							-Si no se cumplen las características anteriores, la importación no se podrá realizar correctamente.
							<br/>
							<!--- -<a href="usuarios_ejemplo.csv">Aquí</a> puede descargar un archivo de ejemplo.<br/>--->
						<br/>
						<!---Si se produce un error durante la importación, no se importará ningún área.<br/>--->
						Una vez pulsado el botón "Importar" debe esperar hasta que se complete la operación.
					</p>

				</div>

				<!---
				<div id="xmlImportInputs">

					<p class="help-block" style="font-size:12px;" lang="es">
						El archivo utilizado para realizar esta importación deberá tener las siguientes características:<br/>

							-Tipo de archivo: <strong>.xml</strong><br/>
							-Codificación: <strong>utf-8</strong><br />
							-Formato:<br/>
					</p>
							<cfsavecontent variable="areaFormatContent"><area>
	<name><![CDATA[Nombre del área padre]]></name>
	<description><![CDATA[Descripción del área padre]]></description>
	<area>
		<name><![CDATA[Nombre del área hija]]></name>
		<description><![CDATA[Descripción del área hija]]></description>
	</area>
</area></cfsavecontent>
							#HTMLCodeFormat(areaFormatContent)#
					<p class="help-block" style="font-size:12px;" lang="es">
						Puede obtener un ejemplo de archivo de este tipo utilizando la funcionalidad de exportar áreas.<br/>
						Si se produce un error durante la importación, no se importará ningún área.<br/>
						No se enviará notificación de ninguna acción relacionada con esta importación a los usuarios.<br/>
						Una vez pulsado el botón "Importar" debe esperar hasta que se complete la operación.
					</p>

				</div>
				--->

			</form>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true"><span lang="es">Cancelar</span></button>
		    <button class="btn btn-primary" onclick="submitAreaModal(event)"><span lang="es">Importar</span></button>
		</div>

		<script>
			function submitAreaModal(e){

		    if(e.preventDefault)
				e.preventDefault();

	    	if( $("##file").val().length > 0 ){
	    		postImportUsersForm();
	    	} else {
	    		showAlertModal("Debe seleccionar un archivo");
	    	}

			}
		</script>

	</cfoutput>

</cfif>

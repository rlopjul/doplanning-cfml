<cfif isDefined("URL.parent")>
	
	<cfset parent_area_id = URL.parent>

	<!--- Get parent area --->
	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getArea" returnvariable="objectParentArea">	
		<cfinvokeargument name="get_area_id" value="#parent_area_id#">
		<cfinvokeargument name="return_type" value="query">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="objectArea" returnvariable="objectArea">
		<cfinvokeargument name="return_type" value="object">
	</cfinvoke>

	<!--- Set default responsible --->
	<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="getUser" returnvariable="userQuery">				
		<cfinvokeargument name="get_user_id" value="#SESSION.user_id#">
		<cfinvokeargument name="format_content" value="default">
		<cfinvokeargument name="return_type" value="query">
	</cfinvoke>

	<cfset objectArea.user_in_charge = userQuery.id>
	<cfset objectArea.user_full_name = userQuery.user_full_name>

	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 id="areaModalLabel">Importar áreas</h4>
		</div>

	 	<div class="modal-body">

		    <!---<noscript>Debe habilitar JavaScript para la subida de archivos</noscript>
		    <label class="control-label" for="fileupload">Archivo CSV con los registros a importar</label>
		    <input id="fileupload" type="file" name="files[]" data-url="UploadManager.cfc?method=uploadFile" multiple>

		    <form id="fileupload" action="UploadManager.cfc?method=uploadFile" method="POST" enctype="multipart/form-data">
				<input type="file" name="files[]" multiple>
			</form>--->

			<script>
			function postImportAreasForm() {

				$('body').modalmanager('loading');

				/*var jqXHR = $('##fileupload').fileupload('send', {files: $('##file')[0].files})
    			.success(function (result, textStatus, jqXHR) {

    				var message = result.message;

			  		hideDefaultModal();

			  		disableNextTabChange = true;
			  		updateTreeWithSelectedArea(#parent_area_id#);
			  		
			  		$('body').modalmanager('removeLoading');

			  		showAlertMessage(message, result.result);

    			}).error(function (jqXHR, textStatus, errorThrown) {

    				alert("Error: "+textStatus+" "+errorThrown);

    			}).complete(function (result, textStatus, jqXHR) { });*/

				$('##fileupload').fileupload('send', {fileInput: $('##file')})
    			.success(function ( data, status ) {

    				if(status == "success"){

				  		var result = $.parseJSON(data);
				  		var message = result.message;

				  		hideDefaultModal();

				  		disableNextTabChange = true;
				  		updateTreeWithSelectedArea(#parent_area_id#);

				  		$('body').modalmanager('removeLoading');

				  		showAlertMessage(message, result.result);

				  	}else
						alert(status);

    			}).error(function ( data, status )  {

    				alert("Error: "+status);

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
			});
			
			</script>

			<div id="progress">
			    <div class="bar" style="width: 0%;"></div>
			</div>
	  
			<form id="fileupload" action="#APPLICATION.htmlComponentsPath#/Area.cfc?method=importAreas" method="post" enctype="multipart/form-data" class="form-horizontal"><!---class="form-inline"--->
				<cfif isDefined("area_id")>
					<input type="hidden" name="area_id" id="area_id" value="#area_id#" />
				<cfelseif isDefined("parent_area_id")>
					<input type="hidden" name="parent_id" id="parent_id" value="#parent_area_id#" />		
				</cfif>

				<cfif isDefined("objectParentArea")>
				<div class="row">
					<div class="col-sm-12">
						<label class="control-label" for="name" lang="es">Área padre de las áreas</label>
						<input type="text" name="parent_name" id="parent_name" value="#objectParentArea.name#" class="form-control" readonly="true" />
					</div>
				</div>
				</cfif>

				<div class="row">
					<div class="col-sm-12">
						<label class="control-label" for="user_full_name" lang="es">Responsable</label>
						<input type="hidden" name="user_in_charge" id="user_in_charge" value="#objectArea.user_in_charge#" required="true"/>
						<input type="text" name="user_in_charge_full_name" id="user_in_charge_full_name" value="#objectArea.user_full_name#" required="true" readonly="true" class="form-control" /> <button type="button" class="btn btn-default" onclick="showSelectUserModal()">Seleccionar usuario</button>
					</div>
				</div>

				<cfinclude template="area_menu_inputs.cfm" />

				<div class="row">
					<div class="col-sm-12">
						<noscript><b>Debe habilitar JavaScript para la subida de archivos</b></noscript>
						<label class="control-label" for="file">Archivo CSV con los nombres de las áreas a importar</label>
						<input type="file" name="files[]" id="file" multiple required="true" accept=".csv,.tsv,text/plain" message="Archivo de datos requerido para la importación" class="form-control">
					</div>
				</div>

				<div class="row">
					<label for="delimiter" class="col-xs-6 col-sm-3 col-md-4 control-label" style="text-align:left">Delimitador de campos</label>
					<div class="col-xs-5 col-sm-3 col-md-4">
						<select name="delimiter" id="delimiter" class="form-control">
							<option value=";" <cfif isDefined("FORM.delimiter") AND FORM.delimiter EQ ";">selected="selected"</cfif>>Punto y coma ;</option>
							<option value="tab" <cfif isDefined("FORM.delimiter") AND FORM.delimiter EQ "tab">selected="selected"</cfif>>Tabulación</option>
						</select>
					</div>
				</div>

				<div class="row">
					<div class="col-sm-12">
				      <div class="checkbox">
				        <label>
				          <input type="checkbox" name="start_row" value="1"<cfif isDefined("FORM.start_row")>checked</cfif>> Importar primera fila del archivo
				        </label>
				        <small class="help-block">Por defecto no se importa la primera fila del archivo (fila para los títulos de las columnas)</small>
				      </div>
				    </div>
				</div>


				<p class="help-block" style="font-size:12px;">
					El archivo utilizado para realizar esta importación deberá tener las siguientes características:<br/>
				
						-Tipo de archivo: <strong>.csv o .txt</strong> delimitado por ; o por tabulaciones.<br/>
						-Codificación: <strong>iso-8859-1</strong> (codificación por defecto en Windows).<br />
						-El archivo debe contener al menos 1 columna para el nombre del área.<br />
						-<strong>Orden de las columnas</strong>:<br />
						<em>Nombre del área, Descripción</em> (columna opcional)
						<br/>
						-Si no se cumplen las características anteriores, la importación no se podrá realizar correctamente.
						<br/>
						<!--- -<a href="usuarios_ejemplo.csv">Aquí</a> puede descargar un archivo de ejemplo.<br/>--->
					<br/>
					Si se produce un error durante la importación, no se importará ningún área.<br/>
					No se enviará notificación de ninguna acción relacionada con esta importación a los usuarios.<br/>
					Una vez pulsado el botón "Importar" debe esperar hasta que se complete la operación.
				</p>
				
			</form>

			<cfinclude template="user_select_modal.cfm" />

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancelar</button>
		    <button class="btn btn-primary" id="areaModifySubmit" onclick="submitAreaModal(event)">Importar</button>
		</div>

		<script>
			function submitAreaModal(e){

			    if(e.preventDefault)
					e.preventDefault();
			    
			    if( $.isNumeric($("##user_in_charge").val()) ){
			    	
			    	if( $("##file").val().length > 0 ){
			    		postImportAreasForm();
			    	} else {
			    		alert("Debe seleccionar un archivo");
			    	}

				} else {

					alert("Debe seleccionar un usuario responsable");
				}

			}
		</script>

	</cfoutput>
	
</cfif>
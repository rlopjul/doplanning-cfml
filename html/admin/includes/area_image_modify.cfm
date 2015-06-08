<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	
	<cfset area_id = URL.area>

	<cfset return_page = "area_users.cfm?area=#area_id#">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>

	<cfoutput>

		<script>

			$(function () {

				var imageId = "#objectArea.image_id#";

				if($.isNumeric(imageId))
					$('##imageHelp').hide();

			    $('##areaForm').fileupload({
			        dataType: 'text',
			        autoUpload: false,
			        replaceFileInput: false,
			        fileInput: $('##file'),
			        forceIframeTransport: true, //Required to enable upload in IE
			        acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
			        maxFileSize: 5000000, // 5 MB
			        previewMaxWidth: 400,
		    		previewMaxHeight: 400,
		    		previewCrop: true, // Force cropped images
		    		add: function (e, data) {

		    			window.URL = window.URL || window.webkitURL;

		    			if(window.URL !== undefined){
		    				$('##areaImage').attr('src', window.URL.createObjectURL(data.files[0]));
			        		$('##deleteAreaImageButton').hide();
			        		$('##imageHelp').hide();
		    			}

			        }

			    });


			    $("##deleteAreaImageButton").click(function() {

					if(confirmAction('eliminar')) {

						$('body').modalmanager('loading');

						var requestUrl = "#APPLICATION.htmlComponentsPath#/Area.cfc?method=deleteAreaImage&area_id=#area_id#";

						$.ajax({
						  type: "POST",
						  url: requestUrl,
						  success: function(data, status) {

						  	$('body').modalmanager('removeLoading');

						  	if(status == "success"){
						  		if(data.result == true){
							  		$('##deleteAreaImageButton').hide();
							  		$('##areaImage').attr('src', '#APPLICATION.resourcesPath#/downloadAreaImage.cfm?id=#area_id#&no-cache=#RandRange(0,999)#');
							  		$('##imageHelp').show();
							  		openUrl("#return_page#", "areaIframe");
						  		} else {
						  			var message = data.message;
							  		showAlertModal(message);
						  		}		
						  		
						  	}else
								showAlertErrorModal(status);
							
						  },
						  dataType: "json"
						});

					}
				
				});

			});
		
		</script>


		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 id="areaModalLabel" lang="es">Modificar imagen de área</h4>
		</div>

	 	<div class="modal-body">
	  
			<cfform id="areaForm" method="post" enctype="multipart/form-data" class="form-horizontal" action="#APPLICATION.htmlComponentsPath#/Area.cfc?method=updateAreaImage">
				<cfif isDefined("area_id")>
					<input type="hidden" name="area_id" id="area_id" value="#area_id#" />
				</cfif>
				
				<div class="row">
					<div class="col-sm-12">
						<img id="areaImage" alt="Imagen del área" src="#APPLICATION.resourcesPath#/downloadAreaImage.cfm?id=#area_id#&no-cache=#RandRange(0,999)#" style="max-height:50px;">
					</div>
				</div>

				<div class="row" style="margin-top:5px;">
					<div class="col-sm-12">
						<cfif isNumeric(objectArea.image_id)>
							<button type="button" id="deleteAreaImageButton" title="Eliminar imagen actual" class="btn btn-danger btn-xs" lang="es"><i class="icon-remove"></i> <span lang="es">Eliminar</span></button>
						</cfif>
						<p class="bg-info" style="padding:5px;" id="imageHelp" lang="es">La imagen que se muestra es la heredada de las áreas superiores. Puede asignar una imagen a esta área y pasará a ser la que se muestre en esta y en las áreas inferiores, siempre que las inferiores no tengan una imagen definida.</p><!---text-info--->
					</div>
				</div>
				<div class="row" style="margin-top:5px;">
					<div class="col-sm-12">
						<span lang="es">Área</span>: <strong>#objectArea.name#</strong>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-12">
						<label class="control-label" for="image_file" lang="es">Imagen:</label>
						<!---<cfinput type="file" name="image_file" id="image_file" class="form-control" /><br/>--->
						<noscript><b lang="es">Debe habilitar JavaScript para la subida de archivos</b></noscript>
						<input type="file" name="files[]" id="file" multiple accept="image/*" class="form-control">
						<small class="help-block">
							<span lang="es">Si no se asigna una imagen a esta área se mostrará la heredada de las áreas superiores.</span><br>
							<span lang="es">El tamaño que se muestra en la previsualización no es el tamaño en el que se mostrará la imagen.</span><br>
							<span lang="es">Debe subir la imagen al tamaño que desea que aparezca en DoPlanning o en la web.</span>
						</small>
					</div>
				</div>

				<div class="row">
					<div class="col-sm-12">
						<label class="control-label" for="link" lang="es">URL:</label>
						<cfinput type="text" name="link" id="link" value="#objectArea.link#" required="false" class="form-control" />
						<small class="help-block" lang="es">URL a la que se enlazará al hacer clic en la imagen (opcional).</small>
					</div>
				</div>

			</cfform>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true" lang="es">Cancelar</button>
		    <button class="btn btn-primary" id="areaModifySubmit" onclick="submitAreaModal(event)" lang="es">Guardar cambios</button>
		</div>

		<script>
			function submitAreaModal(e){

			    if(e.preventDefault)
					e.preventDefault();

				$('body').modalmanager('loading');

				/*postModalForm("##areaForm", "#APPLICATION.htmlComponentsPath#/Area.cfc?method=updateAreaImage", "#return_page#", "areaIframe");*/

				var requestUrl = "#APPLICATION.htmlComponentsPath#/Area.cfc?method=updateAreaImage";
				var formId = "##areaForm";

				if( $('##file').val().length == 0) { //Sin archivo

					$.ajax({
						  type: "POST",
						  url: requestUrl,
						  data: $(formId).serialize(),
						  success: function(data, status) {

						  	if(status == "success"){
						  		var message = data.message;

						  		hideDefaultModal();
						  		$('body').modalmanager('removeLoading');

						  		showAlertMessage(message, data.result);

						  		openUrl("#return_page#", "areaIframe");
						  	}else{

						  		showAlertErrorModal(status);
						  	}
							
						  },
						  dataType: "json"
						});

				} else {
			
					$(formId).fileupload('send', {fileInput: $('##file'), url: requestUrl})
						.success(function ( data, status ) {

							if(status == "success"){

						  		var result = $.parseJSON(data);
						  		var message = result.message;

						  		hideDefaultModal();
						  		$('body').modalmanager('removeLoading');

						  		showAlertMessage(message, result.result);

						  		openUrl("#return_page#", "areaIframe");
						  	}else
						  		showAlertErrorModal(status);

						}).error(function ( data, status )  {

							showAlertErrorModal(status);

						}).complete(function ( data, status )  { });

				}
				
				return false;

			}
		</script>

	</cfoutput>

</cfif>
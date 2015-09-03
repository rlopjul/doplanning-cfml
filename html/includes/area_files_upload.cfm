<cfif isDefined("URL.area") AND isValid("integer",URL.area)>
	<cfset area_id = URL.area>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>

<cfoutput>

<!--- <!-- Bootstrap styles -->
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
<!-- Generic page styles -->
<link rel="stylesheet" href="#APPLICATION.path#/jquery/jquery-file-upload/css/style.css">
--->
<!-- blueimp Gallery styles -->
<link rel="stylesheet" href="//blueimp.github.io/Gallery/css/blueimp-gallery.min.css">
<!-- CSS to style the file input field as button and adjust the Bootstrap progress bars -->
<link rel="stylesheet" href="#APPLICATION.path#/jquery/jquery-file-upload/css/jquery.fileupload.css">
<link rel="stylesheet" href="#APPLICATION.path#/jquery/jquery-file-upload/css/jquery.fileupload-ui.css">
<!-- CSS adjustments for browsers with JavaScript disabled -->
<noscript><link rel="stylesheet" href="#APPLICATION.path#/jquery/jquery-file-upload/css/jquery.fileupload-noscript.css"></noscript>
<noscript><link rel="stylesheet" href="#APPLICATION.path#/jquery/jquery-file-upload/css/jquery.fileupload-ui-noscript.css"></noscript>

<!---
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8"></script>
 --->

<!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/vendor/jquery.ui.widget.js"></script>
<!-- The Templates plugin is included to render the upload/download listings -->
<script src="//blueimp.github.io/JavaScript-Templates/js/tmpl.min.js"></script>
<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="//blueimp.github.io/JavaScript-Load-Image/js/load-image.all.min.js"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="//blueimp.github.io/JavaScript-Canvas-to-Blob/js/canvas-to-blob.min.js"></script>
<!--- <!-- Bootstrap JS is not required, but included for the responsive demo navigation -->
<script src="//netdna.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
--->
<!-- blueimp Gallery script -->
<script src="//blueimp.github.io/Gallery/js/jquery.blueimp-gallery.min.js"></script>
<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.iframe-transport.js"></script>
<!-- The basic File Upload plugin -->
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.fileupload.js"></script>
<!-- The File Upload processing plugin -->
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.fileupload-process.js"></script>
<!-- The File Upload image preview & resize plugin -->
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.fileupload-image.js"></script>
<!-- The File Upload audio preview plugin -->
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.fileupload-audio.js"></script>
<!-- The File Upload video preview plugin -->
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.fileupload-video.js"></script>
<!-- The File Upload validation plugin -->
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.fileupload-validate.js"></script>
<!-- The File Upload user interface plugin -->
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/jquery.fileupload-ui.js"></script>
<!--- <!-- The main application script -->
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/main.js"></script>
--->
<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>

<!-- The XDomainRequest Transport is included for cross-domain file deletion for IE 8 and IE 9 -->
<!--[if (gte IE 8)&(lt IE 10)]>
<script src="#APPLICATION.path#/jquery/jquery-file-upload/js/cors/jquery.xdr-transport.js"></script>
<![endif]-->

<script>
    var area_id = #area_id#;
    var url = "#APPLICATION.htmlComponentsPath#/File.cfc?method=uploadFileRemote";
    var curFile = 0;
</script>

</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<script>

function setFileTypeId(fileTypeId, fileUploadId) {

    if(fileTypeId == 3){

        //$("##documentUsersContainer").show();
        $("#documentVersionIndex"+fileUploadId).show();
				$("#publicFile"+fileUploadId).hide();


    }else{

        //$("##documentUsersContainer").hide();
        $("#documentVersionIndex"+fileUploadId).hide();
				$("#publicFile"+fileUploadId).show();
    }

}

$(function () {
    'use strict';

    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        url: url
        <!---, paramName: "Filedata[]"--->
        <!---, formData: {area_id:area_id, fileTypeId:fileTypeId}--->
    });

    <!---// Enable iframe cross-domain access via redirect option:
    $('#fileupload').fileupload(
        'option',
        'redirect',
        window.location.href.replace(
            /\/[^\/]*$/,
            '/cors/result.html?%s'
        )
    );--->

    <!---if (window.location.hostname === 'blueimp.github.io') {
        // Demo settings:
        $('#fileupload').fileupload('option', {
            url: '//jquery-file-upload.appspot.com/',
            // Enable image resizing, except for Android and Opera,
            // which actually support image resizing, but fail to
            // send Blob objects via XHR requests:
            disableImageResize: /Android(?!.*Chrome)|Opera/
                .test(window.navigator.userAgent),
            maxFileSize: 5000000,
            acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
        });
        // Upload server status check for browsers with CORS support:
        if ($.support.cors) {
            $.ajax({
                url: '//jquery-file-upload.appspot.com/',
                type: 'HEAD'
            }).fail(function () {
                $('<div class="alert alert-danger"/>')
                    .text('Upload server currently unavailable - ' +
                            new Date())
                    .appendTo('#fileupload');
            });
        }
    } else {
        // Load existing files:
        $('#fileupload').addClass('fileupload-processing');
        $.ajax({
            // Uncomment the following to send cross-domain cookies:
            //xhrFields: {withCredentials: true},
            url: $('#fileupload').fileupload('option', 'url'),
            dataType: 'json',
            context: $('#fileupload')[0]
        }).always(function () {
            $(this).removeClass('fileupload-processing');
        }).done(function (result) {
            $(this).fileupload('option', 'done')
                .call(this, $.Event('done'), {result: result});
        });
    }--->

    <!--- https://github.com/blueimp/jQuery-File-Upload/wiki/How-to-submit-additional-Form-Data --->
     $('#fileupload').bind('fileuploadsubmit', function (e, data) {

        var inputs = data.context.find(':input');
        if (inputs.filter(function () {
                return !this.value && $(this).prop('required');
            }).first().focus().length) {

            data.context.find('button').prop('disabled', false);
            return false;
        }

				var categoriesInput = data.context.find("input[name='categories_ids[]']");

				if (categoriesInput.length > 0 && data.context.find("input[name='categories_ids[]']:checked").length == 0){
					alert(window.lang.translate("Debe seleccionar al menos una categoría para poder subir el archivo"));

					data.context.find('button').prop('disabled', false);
					return false;
				}


        data.formData = inputs.serializeArray();

    });


    $(window).on('beforeunload', function(event){

        var activeUploads = $('#fileupload').fileupload('active');

        if(activeUploads > 0){

            showLoadingPage(false);

            var alertMessage = window.lang.translate('Está subiendo archivos, si cambia de página se cancelará la subida');

            return alertMessage;
        }

    });


		<cfif len(area_type) GT 0><!--- WEB --->

		$( document ).on( "focus", "input.datepicker", function() {

		    $(this).datepicker({
					format: 'dd-mm-yyyy',
					weekStart: 1,
					language: 'es',
					todayBtn: 'linked',
					autoclose: true
				});

		});

		</cfif>

});
</script>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="userQuery">
    <cfinvokeargument name="user_id" value="#SESSION.user_id#">
    <cfinvokeargument name="format_content" value="default">
    <cfinvokeargument name="return_type" value="query">
</cfinvoke>

<cfset file_reviser_user = userQuery.id>
<!---<cfset file_reviser_user_full_name = userQuery.user_full_name>--->
<cfset file_approver_user = userQuery.id>
<!---<cfset file_approver_user_full_name = userQuery.user_full_name>--->

<div class="div_head_subtitle"><span lang="es">Subir varios archivos</span></div>

<div><!---class="container-fluid"--->

    <cfif FindNoCase('MSIE',CGI.HTTP_USER_AGENT) GT 0 AND ( FindNoCase('MSIE 6',CGI.HTTP_USER_AGENT) GT 0 OR FindNoCase('MSIE 7',CGI.HTTP_USER_AGENT) GT 0 OR FindNoCase('MSIE 8',CGI.HTTP_USER_AGENT) GT 0 )><!--- OLD IE --->

        <div class="row">

            <div class="col-sm-12">
                <div class="alert alert-warning" role="alert">
                    Esta funcionalidad no es compatible con su versión de Internet Explorer. Debe actualizar a la versión 10 o superior para poder utilizarla.
                </div>
            </div>

        </div>

    <cfelse>

         <!-- The file upload form used as target for the file upload widget -->
        <form id="fileupload" method="POST" enctype="multipart/form-data">
            <!-- Redirect browsers with JavaScript disabled to the origin page -->
            <noscript><input type="hidden" name="redirect" value="https://blueimp.github.io/jQuery-File-Upload/"></noscript>
            <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
            <div class="row fileupload-buttonbar">
                <div class="col-lg-7">
                    <!-- The fileinput-button span is used to style the file input field as button -->
                    <span class="btn btn-primary fileinput-button">
                        <i class="icon-plus icon-white"></i>
                        <span lang="es">Añadir archivos</span>
                        <input type="file" name="files[]" multiple>
                    </span>

                    <button type="submit" class="btn btn-default start">
                        <i class="icon-upload"></i>
                        <span lang="es">Iniciar todos</span>
                    </button>
                    <button type="reset" class="btn btn-warning cancel">
                        <i class="icon-remove-sign"></i>
                        <span lang="es">Cancelar todos</span>
                    </button>
                   <!--- <button type="button" class="btn btn-danger delete">
                        <i class="glyphicon glyphicon-trash"></i>
                        <span>Delete</span>
                    </button>

                    <input type="checkbox" class="toggle">--->

                    <cfif FindNoCase('MSIE 9',CGI.HTTP_USER_AGENT) IS 0>

                        <div class="well"><i class="icon-plus" style="color:#5BB75B;font-size:22px;"></i>&nbsp;<span lang="es" style="font-size:16px;">Puede arrastrar aquí los archivos que desea subir.</span></div>

                    </cfif>

                    <!-- The global file processing state -->
                    <span class="fileupload-process"></span>
                </div>
                <!-- The global progress state -->
                <div class="col-lg-5 fileupload-progress fade">
                    <!-- The global progress bar -->
                    <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                        <div class="progress-bar progress-bar-success" style="width:0%;"></div>
                    </div>
                    <!-- The extended global progress state -->
                    <div class="progress-extended">&nbsp;</div>
                </div>
            </div>

            <!-- The table listing the files available for upload/download -->
            <table role="presentation" class="table table-striped"><tbody class="files"></tbody></table>
        </form>

    </cfif>

</div>


<!-- The blueimp Gallery widget -->
<div id="blueimp-gallery" class="blueimp-gallery blueimp-gallery-controls" data-filter=":even">
    <div class="slides"></div>
    <h3 class="title"></h3>
    <a class="prev">‹</a>
    <a class="next">›</a>
    <a class="close">×</a>
    <a class="play-pause"></a>
    <ol class="indicator"></ol>
</div>

<script>
    openUrlHtml2('empty.cfm','itemIframe');
</script>

<!--- getScopes --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Scope" method="getScopes" returnvariable="getScopesResult">
</cfinvoke>
<cfset scopesQuery = getScopesResult.scopes>

<!--- Categories --->
<!--- getAreaItemTypesOptions --->
<cfset fileItemTypeId = 10>
<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItemType" method="getAreaItemTypesOptions" returnvariable="getItemTypesOptionsResponse">
	<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#"/>
</cfinvoke>

<cfset itemTypeOptions = getItemTypesOptionsResponse.query>

<cfif isNumeric(itemTypeOptions.category_area_id)>

	<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

	<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreas" returnvariable="subAreas">
		<cfinvokeargument name="area_id" value="#itemTypeOptions.category_area_id#">
		<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		<cfinvokeargument name="client_dsn" value="#client_dsn#">
	</cfinvoke>

</cfif>

<!-- The template to display files available for upload -->
<script id="template-upload" type="text/x-tmpl">
<cfoutput>
{% for (var i=0, file; file=o.files[i]; i++) { %}

    {% curFile = curFile+1; %}

    <tr class="template-upload fade">
        <td>

            <span class="preview"></span>

        </td>

        <td colspan="3">


            <span class="name">{%=file.name%} (<span class="size">Processing...</span>)</span><br/>

            <cfoutput>
            <input type="hidden" name="area_id" value="#area_id#"/>
            <input type="hidden" name="reviser_user" id="reviser_user" value="#file_reviser_user#" />
            <input type="hidden" name="approver_user" id="approver_user" value="#file_approver_user#" />
            </cfoutput>
            <div class="form-horizontal">

                <div class="form-group" style="margin-bottom:0">

                    <label for="fileTypeId{%=curFile%}" class="col-sm-2 control-label" lang="es">Tipo</label>

                    <div class="col-sm-10">
                        <select name="fileTypeId" id="fileTypeId{%=curFile%}" class="form-control" onchange="setFileTypeId($('##fileTypeId{%=curFile%}').val(),{%=curFile%});">
                            <option value="1" selected="selected" lang="es">Archivo de usuario</option>
														<cfif APPLICATION.moduleAreaFilesLite IS true>
															<option value="2" lang="es">Archivo de área sin circuito de calidad</option>
															<cfif len(area_type) IS 0>
	                            	<option value="3" lang="es">Archivo de área con circuito de calidad</option>
															</cfif>
														</cfif>
                        </select>
                    </div>

                </div>

                <div class="form-group" style="margin-bottom:0">

                    <label for="name{%=curFile%}" class="col-sm-2 control-label" lang="es">Nombre</label>

                    <div class="col-sm-10">
                        <input type="text" name="name" id="name{%=curFile%}" value="{%=file.name%}" class="form-control" required/>
                    </div>

                </div>

                <div class="form-group" style="margin-bottom:0">

                    <label for="description{%=curFile%}" class="col-sm-2 control-label" lang="es">Descripción</label>

                    <div class="col-sm-10">
                        <input type="text" name="description" id="description{%=curFile%}" value="" class="form-control"/>
                    </div>

                </div>

                <div class="form-group" id="documentVersionIndex{%=curFile%}" style="display:none">

                    <label lang="es" for="version_index{%=curFile%}" class="col-sm-2 control-label">Número de versión</label>

                    <div class="col-sm-10">
                        <input type="number" name="version_index" id="version_index{%=curFile%}" value="1" min="0" class="form-control" style="width:100px;" />
                    </div>

                </div>

                <cfif scopesQuery.recordCount GT 0>

                    <div class="form-group" style="margin-bottom:0">

                        <label for="publication_scope_id{%=curFile%}" class="col-sm-2 control-label" lang="es">Ámbito de publicación</label>

                        <div class="col-sm-10">
                            <select name="publication_scope_id" id="publication_scope_id{%=curFile%}" class="form-control">
                                <cfoutput>
                                <cfloop query="scopesQuery">
                                    <option value="#scopesQuery.scope_id#" <cfif findNoCase(area_type, scopesQuery.name) GT 0>selected="selected"</cfif>>#scopesQuery.name#</option>
                                </cfloop>
                                </cfoutput>
                            </select>
                        </div>

                    </div>

                </cfif>

								<cfif isNumeric(itemTypeOptions.category_area_id)>

									<div class="form-group" style="margin-bottom:0">

										<label for="categories_ids{%=curFile%}" lang="es" class="col-sm-2 control-label">Categorías</label>

										<div class="col-sm-10">

											<cfif subAreas.recordCount GT 0>

												<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaHtml" method="outputSubAreasInput">
													<cfinvokeargument name="area_id" value="#itemTypeOptions.category_area_id#">
													<cfinvokeargument name="subAreas" value="#subAreas#">
													<cfinvokeargument name="recursive" value="false">
													<cfinvokeargument name="field_name" value="categories_ids"/>
													<cfinvokeargument name="field_input_type" value="checkbox">
													<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
													<cfinvokeargument name="client_dsn" value="#client_dsn#">
												</cfinvoke>

												<p class="help-block" lang="es">Estas categorías permiten a los usuarios clasificar los elementos y filtrar las notificaciones por email que se reciben</p>

											<cfelse>

												<p class="help-block" lang="es">Este elemento tiene un área para categorías seleccionada pero esta área no tiene subareas para definir las categorías</p>

											</cfif>

										</div>

									</div>

								</cfif>


								<cfif len(area_type) GT 0 ><!--- WEB Publish file --->


									<div class="form-group" style="margin-bottom:0">

										<div class="col-sm-2">
											<label class="control-label" for="publication_date"><span lang="es">Fecha de publicación</span>:</label>
										</div>

										<cfset publication_date = DateFormat(now(), APPLICATION.dateFormat)>

										<div class="col-sm-10">

											<input type="text" name="publication_date" id="publication_date" class="form-control datepicker" value="#publication_date#" required>

											<input type="hidden" name="publication_hour" value="00"/>
											<input type="hidden" name="publication_minute" value="00"/>

											<small class="help-block" lang="es">Si está definida, el archivo se publicará en la fecha especificada (sólo para publicación en web e intranet).</small>

										</div>

									</div>

									<cfif APPLICATION.publicationValidation IS true>

										<!--- isUserAreaResponsible --->
										<cfif is_user_area_responsible IS true>

											<div class="form-group" style="margin-bottom:0">

												<div class="col-sm-11 col-sm-offset-1">

													<div class="checkbox">
														<label>
															<input type="checkbox" name="publication_validated" id="publication_validated" value="true" class="checkbox_locked" /> Aprobar publicación
														</label>
														<!---<small class="help-block" lang="es">Valida el archivo para que pueda ser publicado (sólo para publicación en web e intranet).</small>--->
													</div>

												</div>

											</div>

										</cfif>

									</cfif>


								</cfif>



								<div class="form-group" style="margin-bottom:0" id="publicFile{%=curFile%}">

									<div class="col-sm-11 col-sm-offset-1">

										<div class="checkbox">
										    <label>
										    	<input type="checkbox" name="public" value="true"> <span lang="es">Habilitar URL pública para poder</span> <b lang="es">compartir el archivo con cualquier usuario</b>
										    </label>
									  </div>

									</div>

								</div>



								<!--- getClient --->
								<cfinvoke component="#APPLICATION.htmlPath#/components/Client" method="getClient" returnvariable="clientQuery">
									<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
								</cfinvoke>

								<cfif clientQuery.force_notifications IS false>

									<div class="form-group" style="margin-bottom:0">

										<div class="col-sm-11 col-sm-offset-1">

											<div class="checkbox">
												<label>
													<input type="checkbox" name="no_notify" id="no_notify" value="true" /> NO enviar notificación por email
												</label>
											</div>

										</div>

									</div>

								</cfif>


            </div>

            <strong class="error text-danger"></strong>

            <div style="height:5px;"></div>

            <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="progress-bar progress-bar-success" style="width:0%;"></div></div>


            {% if (!i && !o.options.autoUpload) { %}
                <button class="btn btn-primary start" disabled>
                    <i class="icon-upload"></i>
                    <span lang="es">Iniciar</span>
                </button>
            {% } %}
            {% if (!i) { %}
                <button class="btn btn-warning cancel">
                    <i class="icon-remove-sign"></i>
                    <span lang="es">Cancelar</span>
                </button>
            {% } %}


        </td>

    </tr>

{% } %}
</cfoutput>
</script>
<!-- The template to display files available for download -->
<script id="template-download" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-download fade">
        <td>
            <span class="preview">
                {% if (file.thumbnailUrl) { %}
                    <a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%}" data-gallery><img src="{%=file.thumbnailUrl%}"></a>
                {% } %}
            </span>
        </td>
        <td>
            <p class="name">
                {% if (file.url) { %}
                    <a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%}" {%=file.thumbnailUrl?'data-gallery':''%}>{%=file.name%}</a>
                {% } else { %}
                    <span>{%=file.name%}</span>
                {% } %}
            </p>
            {% if (file.error) { %}
                <div><span class="label label-danger">Error</span> {%=file.error%}</div>
            {% } else { %}
                <div><span class="label label-success" lang="es">Subido</span></div>
            {% } %}

        </td>
        <td>
            <span class="size">{%=o.formatFileSize(file.size)%}</span>
        </td>
        <td>
            {% if (file.deleteUrl) { %}
                <button class="btn btn-danger delete" data-type="{%=file.deleteType%}" data-url="{%=file.deleteUrl%}"{% if (file.deleteWithCredentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %}>
                    <i class="icon-remove"></i>
                    <span>Eliminar</span>
                </button>
                <input type="checkbox" name="delete" value="1" class="toggle">
            {% } else { %}
                <button class="btn btn-default cancel">
                    <i class="icon-remove-circle"></i>
                    <span lang="es">Quitar de la lista</span>
                </button>
            {% } %}
            {% if (file.file_id) { %}
                <a class="btn btn-default" onclick="openUrl('area_file_modify.cfm?area={%=area_id%}&file={%=file.file_id%}&fileTypeId={%=file.fileTypeId%}&return_page=file.cfm','itemIframe',event)">
                    <i class="icon-edit"></i>
                    <span lang="es">Modificar datos</span>
                </a>
                <cfoutput>
                <a class="btn btn-default" href="#APPLICATION.htmlPath#/file.cfm?file={%=file.file_id%}&area={%=area_id%}" target="_blank" lang="es">
                    <i class="icon-external-link"></i>
                </a>
                </cfoutput>
            {% } %}

        </td>
    </tr>
{% } %}
</script>

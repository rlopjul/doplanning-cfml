<!---
page_types
1 create/update user from administration
2 update user from preferences
3 register user (public form)
--->
<cfif page_type NEQ 3>
	<cfset client_abb = SESSION.client_abb>
	<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>
</cfif>

<cfoutput>

<script src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js"></script>
<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>
<!---<script src="#APPLICATION.htmlPath#/scripts/tablesFunctions.js"></script>--->
<script src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>

<script>

	$(function () {

	    $('##updateUserData').fileupload({
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
    				$('##userImage').attr('src', window.URL.createObjectURL(data.files[0]));
	        		$('##deleteImageButton').hide();
    			}

	        }

	    });/*.on('fileuploadprocessalways', function (e, data) {
		    var index = data.index,
		        file = data.files[index],
		        node = $(data.context.children()[index]);
		    if (file.preview) {
		      node
		        .prepend('<br/>')
		        .prepend(file.preview)
		    }
		    if (file.error) {
		      node
		        .append('<br/>')
		        .append($('<span class="text-danger"/>').text(file.error));
		    }
		});*/

	 	$('##telephone').mask('000000000');
	 	$('##mobile_phone').mask('000000000');

	 	$('##telephone_ccode').mask('0000');
	 	$('##mobile_phone_ccode').mask('0000');

	 	<cfif APPLICATION.showDniTitle IS true>
	 	$("##dni").mask('00000000A');
	 	</cfif>

	});

</script>

<!--- Importante: este formulario no se envía como formulario HTML, se obtienen sus valores y se envian mediante JavaScript --->

<cfform id="updateUserData" name="user_form" method="post" enctype="multipart/form-data" class="form-horizontal">

	<script>

		var railo_custom_form;

		if( typeof LuceeForms !== 'undefined' && $.isFunction(LuceeForms) )
			railo_custom_form = new LuceeForms('userForm');
		else
			railo_custom_form = new RailoForms('userForm');

	</script>

	<cfif page_type EQ 3>
		<input type="hidden" name="client_abb" value="#client_abb#" />
	<cfelse>
		<input type="hidden" name="user_id" value="#objectUser.user_id#" />
	</cfif>

	<cfif page_type IS 1>
		<input type="hidden" name="adminFields" value="true" />
	</cfif>

	<!---<cfif page_type EQ 3>

		<div class="row">
			<div class="col-sm-6">

	</cfif>--->

	<div class="row">

		<cfif page_type NEQ 3>

			<div class="col-sm-3">

				<div class="row">
					<div class="col-sm-12">

						<cfif isNumeric(objectUser.id)>

							<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUserImage">
								<cfinvokeargument name="user_id" value="#objectUser.id#">
								<cfinvokeargument name="user_id" value="#objectUser.id#">
								<cfinvokeargument name="user_full_name" value="#objectUser.family_name# #objectUser.name#">
								<cfinvokeargument name="user_image_type" value="#objectUser.image_type#">
								<cfinvokeargument name="class" value="img-thumbnail img-responsive"/>
							</cfinvoke>

							<cfif len(objectUser.image_file) GT 0 AND len(objectUser.image_type)>
								<div>
									<button type="button" id="deleteImageButton" title="Eliminar imagen" class="btn btn-danger btn-xs" lang="es"><i class="icon-remove"></i> <span lang="es">Eliminar imagen</span></button>
								</div>
							</cfif>

						<cfelse>

							<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default_medium.png" id="userImage" class="img-thumbnail" style="text-align:right; margin-bottom:3px;" alt="Usuario sin imagen" title="Usuario sin imagen" lang="es"/>

						</cfif>

					</div>
				</div>

			</div>

		</cfif><!--- END page_type NEQ 3 --->

		<cfif page_type IS 3>
			<div class="col-sm-10">
		<cfelse>
			<div class="col-sm-9">
		</cfif>

			<cfif page_type NEQ 3>
				<div class="row">

					<label class="col-xs-5 col-sm-4 col-md-3 control-label" for="file" lang="es">Imagen del usuario</label>

					<div class="col-xs-7 col-sm-8 col-md-9">
						<noscript><b>Debe habilitar JavaScript para la subida de archivos y poder guardar cambios de este formulario</b></noscript>
						<input type="file" name="files[]" id="file" multiple accept="image/*" class="form-control">
					</div>

				</div>
			</cfif>

			<div class="row">

				<label for="family_name" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es">Nombre</label>

				<div class="col-xs-7 col-sm-8 col-md-9">
					<input type="text" name="family_name" id="family_name" value="#objectUser.family_name#" class="form-control"/>
				</div>

			</div>

			<div class="row">

				<label for="name" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es">Apellidos</label>

				<div class="col-xs-7 col-sm-8 col-md-9">
					<input type="text" name="name" id="name" value="#objectUser.name#" class="form-control"/>
				</div>

			</div>


			<div class="row">

				<label for="email" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es"><span lang="es">Email</span> <cfif APPLICATION.userEmailRequired IS true OR page_type IS 3>*</cfif></label>
				<!---<cfif APPLICATION.userEmailRequired IS true>
					<cfinput type="text" name="email" id="email" value="#objectUser.email#" required="true" validate="email" message="Dirección de email válida requerida" class="form-control"/>
				<cfelse>--->

				<div class="col-xs-7 col-sm-8 col-md-9">
					<input type="email" name="email" id="email" value="#objectUser.email#" class="form-control" autocomplete="off" title="Introduzca una dirección de email válida" <cfif APPLICATION.userEmailRequired IS true OR page_type IS 3>required</cfif>/>
				</div>
				<!---<label id="email-error" class="label label-danger" for="email" lang="es">Introduzca una dirección de email correcta.</label>--->
				<!---</cfif>--->

			</div>

			<cfif APPLICATION.moduleLdapUsers EQ true><!--- LDAP --->

				<div class="row">

					<label for="login_ldap" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es">Login #APPLICATION.ldapName#</label>
					<!--- <cfif SESSION.client_abb EQ "hcs">Login #APPLICATION.ldapName#
					<cfelseif SESSION.client_abb EQ "asnc">Login ASNC
					<cfelseif SESSION.client_abb EQ "agsna">Login DMSAS
					<cfelse>Login LDAP
					</cfif> --->
					<div class="col-xs-7 col-sm-8 col-md-9">
						<input type="text" name="login_ldap" id="login_ldap" value="#objectUser.login_ldap#" class="form-control" autocomplete="off" />
					</div>

				</div>

				<cfif APPLICATION.moduleLdapDiraya EQ true >
					<div class="row">

						<label for="login_diraya" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es">Login Diraya</label>

						<div class="col-xs-7 col-sm-8 col-md-9">
							<input type="text" name="login_diraya" id="login_diraya" value="#objectUser.login_diraya#" class="form-control" autocomplete="off" />
						</div>

					</div>
				</cfif>

			</cfif>

			<cfif ( page_type IS 1 AND NOT isNumeric(objectUser.user_id) ) OR page_type IS 3>
				<cfset passwordRequired = true>
			<cfelse>
				<cfset passwordRequired = false>
			</cfif>

			<div class="row">

				<label for="password" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es"><cfif passwordRequired><span lang="es">Contraseña</span> *<cfelse>Nueva contraseña</cfif></label>

				<div class="col-xs-7 col-sm-8 col-md-9">
					<input type="password" name="password" id="password" <cfif isDefined("objectUser.new_password") AND page_type IS NOT 3>value="#objectUser.new_password#"</cfif> class="form-control" value="" autocomplete="off" <cfif passwordRequired>required title="Introduzca contraseña"</cfif> />
				</div>

			</div>

			<div class="row">

				<label for="password_confirmation" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es"><span lang="es">Confirmar contraseña</span><cfif passwordRequired> *</cfif></label>

				<div class="col-xs-7 col-sm-8 col-md-9">
					<input type="password" name="password_confirmation" id="password_confirmation" <cfif isDefined("objectUser.new_password") AND page_type IS NOT 3>value="#objectUser.new_password#"</cfif> class="form-control" value="" autocomplete="off" <cfif passwordRequired>required title="Introduzca confirmación de la contraseña"</cfif> />
				</div>

			</div>

			<cfif page_type NEQ 3>
				<div class="row">

					<label class="col-xs-5 col-sm-4 col-md-3 control-label" for="language" lang="es">Idioma</label>

					<div class="col-xs-7 col-sm-8 col-md-9">
						<select name="language" id="language" class="form-control">
							<option value="es" <cfif objectUser.language EQ "es">selected="selected"</cfif>>Español</option>
							<option value="en" <cfif objectUser.language EQ "en">selected="selected"</cfif>>English</option>
						</select>
					</div>

				</div>
			<cfelse>

				<input type="hidden" name="language" value="#objectUser.language#"/>

			</cfif>


			<cfif page_type NEQ 3>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/StartPageManager" method="getStartPageTypesStruct" returnvariable="startPagesTypesStruct">
					<cfinvokeargument name="client_abb" value="#client_abb#">
				</cfinvoke>

				<cfset startPagesArray = structSort(startPagesTypesStruct, "numeric", "ASC", "position")>

				<!---<label class="control-label" for="item_type_id" id="subTypeLabel"><span lang="es">Tipo de elemento de DoPlanning</span> *</label>
				<select name="item_type_id" id="item_type_id" class="form-control" onchange="fieldItemTypeChange($('##item_type_id').val());" <cfif page_type IS 2>disabled</cfif>>
					<cfloop array="#itemTypesArray#" index="itemTypeId">
						<cfif itemTypesStruct[itemTypeId].showInSelect IS true>
							<option value="#itemTypeId#" lang="es" <cfif isDefined("field.item_type_id") AND field.item_type_id IS itemTypeId>selected="selected"</cfif>>#itemTypesStruct[itemTypeId].label#</option>
						</cfif>
					</cfloop>
				</select>--->

				<div class="row">

					<label class="col-xs-5 col-sm-4 col-md-3 control-label" for="start_page" lang="es">Página de inicio</label>

					<div class="col-xs-7 col-sm-8 col-md-9">

						<cfif objectUser.start_page_locked IS true>

							<input type="hidden" name="start_page" value="#objectUser.start_page#" />
							<input type="text" name="start_page_label" class="form-control" readonly value="Página personalizada" />

						<cfelse>
							<select name="start_page" id="start_page" class="form-control">

								<cfset startPageExists = false>
								<cfset startPageSelected = false>

								<cfif len(objectUser.start_page) IS 0>
									<cfset startPageSelected = true>
									<cfset startPageExists = true>
								</cfif>
								<option value="" lang="es" <cfif startPageSelected IS true>selected</cfif>>Página por defecto (Lo último)</option>


								<cfinvoke component="#APPLICATION.htmlComponentsPath#/Web" method="getWeb" returnvariable="getWebResult">
				    			<cfinvokeargument name="path" value="intranet">
				    		</cfinvoke>

				        <cfset intranetQuery = getWebResult.query>

								<cfloop array="#startPagesArray#" index="startPageId">
									<cfset startPageSelected = false>

									<cfif startPageId NEQ 24 OR intranetQuery.recordCount GT 0><!--- Check intranet start page --->

										<cfif startPagesTypesStruct[startPageId].page EQ objectUser.start_page>
											<cfset startPageSelected = true>
											<cfset startPageExists = true>
										</cfif>
										<option value="#startPagesTypesStruct[startPageId].page#" lang="es" <cfif startPageSelected EQ true>selected="selected"</cfif>>#startPagesTypesStruct[startPageId].label#</option>

									</cfif>

								</cfloop>

								<cfif startPageExists IS false>
									<option value="#objectUser.start_page#" lang="es" selected="selected">Página personalizada</option>
								</cfif>

							</select>
						</cfif>


					</div>

				</div>

			</cfif><!--- END page_type NEQ 3 --->


			<cfif page_type IS 1>

				<div class="row">
					<div class="col-xs-offset-5 col-sm-offset-4 col-md-offset-3 col-xs-7 col-sm-8 col-md-9">

						<div class="checkbox">
							<label>
								<input type="checkbox" name="internal_user" id="internal_user" value="true" <cfif isDefined("objectUser.internal_user") AND objectUser.internal_user IS true>checked="checked"</cfif> /> <span lang="es">Usuario interno</span>
							</label>
							<small class="help-block" lang="es">Los usuarios internos pueden ver todo el árbol de la organización, y no sólo las áreas a las que tienen acceso.</small>
						</div>

					</div>
				</div>

			</cfif>

			<cfif page_type NEQ 3>

			<div class="row">
				<div class="col-xs-offset-5 col-sm-offset-4 col-md-offset-3 col-xs-7 col-sm-8 col-md-9">

					<div class="checkbox">
						<label>
							<input type="checkbox" name="hide_not_allowed_areas" id="hide_not_allowed_areas" value="true" <cfif isDefined("objectUser.hide_not_allowed_areas") AND objectUser.hide_not_allowed_areas IS true>checked="checked"</cfif> /> <span lang="es">Mostrar sólo áreas con acceso</span>
						</label>
						<small class="help-block" lang="es">En el árbol de áreas sólo se mostrarán las áreas con permiso de acceso.</small>
					</div>

				</div>
			</div>

			</cfif>

			<cfif page_type IS 1>

				<div class="row">
					<div class="col-xs-offset-5 col-sm-offset-4 col-md-offset-3 col-xs-7 col-sm-8 col-md-9">

						<div class="checkbox">
							<label>
								<input type="checkbox" name="verified" id="verified" value="true" <cfif isDefined("objectUser.verified") AND objectUser.verified IS true>checked="checked"</cfif> /> <span lang="es">Verificado</span>
							</label>
							<small class="help-block" lang="es">Si el usuario no se marca como verificado, tras ser dado de alta deberá acceder a verificar su cuenta de correo para poder usar la aplicación y recibir emails de la misma.</small>
						</div>

					</div>
				</div>

				<div class="row">
					<div class="col-xs-offset-5 col-sm-offset-4 col-md-offset-3 col-xs-7 col-sm-8 col-md-9">

						<div class="checkbox">
							<label>
								<input type="checkbox" name="enabled" id="enabled" value="true" <cfif isDefined("objectUser.enabled") AND objectUser.enabled IS true>checked="checked"</cfif> /> <span lang="es">Activo</span>
							</label>
							<small class="help-block" lang="es">Los usuarios no activos no podrán acceder a la aplicación ni recibirán notificaciones por email y seguirán siendo visibles en todos los listados de la aplicación.</small>
						</div>

					</div>
				</div>

				<div class="row">
					<div class="col-xs-offset-5 col-sm-offset-4 col-md-offset-3 col-xs-7 col-sm-8 col-md-9">

						<div class="checkbox">
							<label>
								<input type="checkbox" name="user_administrator" id="user_administrator" value="true" <cfif isDefined("objectUser.user_administrator") AND objectUser.user_administrator IS true>checked="checked"</cfif> /> <span lang="es">Administrador de usuarios</span>
							</label>
							<small class="help-block" lang="es">El usuario podrá gestionar los usuarios de la aplicación.</small>
						</div>

					</div>
				</div>

			</cfif>

			<cfif APPLICATION.showDniTitle IS true OR page_type NEQ 3>
			<div class="row">

				<label for="dni" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es"><cfif APPLICATION.showDniTitle IS true>DNI<cfelse>Número de identificación</cfif></label>

				<div class="col-xs-7 col-sm-8 col-md-9">
					<input type="text" name="dni" id="dni" value="#objectUser.dni#" class="form-control" />
				</div>

			</div>
			</cfif>

			<div class="row">

				<label for="mobile_phone" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es">Teléfono móvil</label>

				<div class="col-xs-7 col-sm-8 col-md-9">
					<div class="row">
						<div class="col-xs-5 col-sm-3 col-md-3">
							<div class="input-group">
								<span class="input-group-addon">+</span>
								<input type="text" name="mobile_phone_ccode" id="mobile_phone_ccode" value="#objectUser.mobile_phone_ccode#" class="form-control" placeholder="34" />
							</div>
						</div>
						<div class="col-xs-7 col-sm-9 col-md-9">
							<input type="text" name="mobile_phone" id="mobile_phone" value="#objectUser.mobile_phone#" class="form-control" placeholder="999999999" />
						</div>
					</div>
				</div>

			</div>

			<div class="row">

				<label for="telephone" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es">Teléfono</label>

				<div class="col-xs-7 col-sm-8 col-md-9">
					<div class="row">
						<div class="col-xs-5 col-sm-3 col-md-3">
							<div class="input-group">
  								<span class="input-group-addon">+</span>
								<input type="text" name="telephone_ccode" id="telephone_ccode" value="#objectUser.telephone_ccode#" class="form-control" placeholder="34" />
							</div>
						</div>
						<div class="col-xs-7 col-sm-9 col-md-9">
							<input type="text" name="telephone" id="telephone" value="#objectUser.telephone#" class="form-control" placeholder="999999999" />
						</div>
					</div>
				</div>

			</div>

			<div class="row">

				<label for="linkedin_url" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es">URL LinkedIn</label>

				<div class="col-xs-7 col-sm-8 col-md-9">
					<input type="url" name="linkedin_url" id="linkedin_url" value="#objectUser.linkedin_url#" class="form-control" title="Introduzca una URL válida" />
				</div>

			</div>

			<div class="row">

				<label for="twitter_url" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es">URL Twitter</label>

				<div class="col-xs-7 col-sm-8 col-md-9">
					<input type="url" name="twitter_url" id="twitter_url" value="#objectUser.twitter_url#" class="form-control" title="Introduzca una URL válida" />
				</div>

			</div>

			<cfif client_abb NEQ "ceseand" OR page_type IS 1>
				<div class="row">

					<label for="address" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es">Dirección</label>

					<div class="col-xs-7 col-sm-8 col-md-9">
						<textarea name="address" id="address" class="form-control" rows="2">#objectUser.address#</textarea>
					</div>

				</div>
			<cfelse>
				<input type="hidden" name="address" value="#objectUser.address#">
			</cfif>

			<cfif page_type IS 1>

				<cfif client_abb EQ "hcs">

					<div class="row">

						<label for="perfil_cabecera" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es">Perfil de cabecera</label>

						<div class="col-xs-7 col-sm-8 col-md-9">
							<input type="text" name="perfil_cabecera" id="perfil_cabecera" value="#objectUser.perfil_cabecera#" class="form-control" />
							<small class="help-block" lang="es">Sólo visible desde la administración para todos los usuarios administradores.</small>
						</div>

					</div>

				</cfif>

				<div class="row">

					<label for="information" class="col-xs-5 col-sm-4 col-md-3 control-label" lang="es">Información</label>

					<div class="col-xs-7 col-sm-8 col-md-9">
						<textarea type="text" name="information" id="information" class="form-control" rows="2">#objectUser.information#</textarea>
						<small class="help-block" lang="es">Sólo visible desde la administración para todos los usuarios administradores.</small>
					</div>

				</div>

			</cfif>


		</div><!---END col-sm-9--->

	</div><!---END row--->


	<div class="row">

		<cfif page_type IS 3>
			<div class="col-sm-10">
		<cfelse>
			<div class="col-sm-12">
		</cfif>

		<!--- Users Typologies --->
		<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAllTypologies" returnvariable="getAllTypologiesResponse">
			<cfinvokeargument name="tableTypeId" value="4">
		</cfinvoke>
		<cfset typologies = getAllTypologiesResponse.query>--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getAllTypologies" returnvariable="typologies">
			<cfinvokeargument name="tableTypeId" value="4">

			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<cfif typologies.recordCount GT 0>

			<cfif typologies.recordCount IS 1>
				<cfset default_typology_id = typologies.id>
			<cfelse>
				<cfset default_typology_id = "">
			</cfif>

			<cfif isNumeric(objectUser.typology_id)>
				<cfset selected_typology_id = objectUser.typology_id>
			<cfelseif page_type IS 3><!---IS register user page--->
				<cfset selected_typology_id = default_typology_id>
			<cfelse>
				<cfset selected_typology_id = "">
			</cfif>

			<script>

				function loadTypology(typologyId,rowId) {

					if(!isNaN(typologyId)){

						<!---showLoadingPage(true);--->

						$("##typologyContainer").html('<span lang="es">Cargando...</span>');

						<cfif page_type IS 3>
						var typologyPage = "#APPLICATION.htmlPath#/public/user_typology_row_form_inputs.cfm?typology="+typologyId+"&abb=#client_abb#";
						<cfelse>
						var typologyPage = "#APPLICATION.htmlPath#/html_content/user_typology_row_form_inputs.cfm?typology="+typologyId;
						</cfif>

						var noCacheNumber = generateRandom();
						typologyPage = typologyPage+'&n='+noCacheNumber;

						if(!isNaN(rowId)){
							typologyPage = typologyPage+"&row="+rowId;
						}

						$("##typologyContainer").load(typologyPage, function() {

							<!---showLoadingPage(false);--->

						});

					} else {

						$("##typologyContainer").empty();
					}
				}

				$(function () {

					<cfif isNumeric(selected_typology_id)>
						<cfif page_type IS 1 AND NOT isNumeric(objectUser.user_id)>
							loadTypology(#selected_typology_id#, '');
						<cfelseif isDefined("objectUser.typology_row_id") AND isNumeric(objectUser.typology_row_id)>
							loadTypology(#selected_typology_id#, #objectUser.typology_row_id#);
						<cfelse>
							loadTypology(#selected_typology_id#, '');
						</cfif>
					</cfif>

				});

			</script>

			<cfif typologies.recordCount IS 1 AND page_type NEQ 1>

				<!---<input type="hidden" name="typology_id" id="typology_id" value="#typologies.id#">

			<cfelseif page_type IS 2>--->

				<input type="hidden" name="typology_id" id="typology_id" value="#selected_typology_id#">

			<cfelse>

				<div class="row">

						<label for="typology_id" class="col-xs-5 col-sm-4 col-md-3 control-label"><span lang="es">Tipología</span>: *</label>

						<div class="col-xs-7 col-sm-8 col-md-9">
							<select name="typology_id" id="typology_id" onchange="loadTypology($('##typology_id').val(),'');" class="form-control">
								<option value="" <cfif NOT isNumeric(selected_typology_id)>selected="selected"</cfif> lang="es">Básica</option>
								<cfloop query="typologies">
									<option value="#typologies.id#" <cfif typologies.id IS selected_typology_id>selected="selected"</cfif> <cfif default_typology_id IS typologies.id>style="font-weight:bold"</cfif>>#typologies.title#</option>
								</cfloop>
							</select>
						</div>

				</div>

			</cfif>

			<!--- Typology fields --->
			<div id="typologyContainer"></div>

		</cfif>

		</div><!---END col-sm-9 col-sm-offset-3--->

	</div><!---END row--->


	<!---<cfif APPLICATION.identifier EQ "vpnet">
	</cfif>---><!--- END APPLICATION.identifier EQ "vpnet" --->


</cfform>
</cfoutput>

<!--- 
page_types
1 create/update user from administration
2 update user from preferences --->


<cfoutput>

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

<form id="updateUserData" method="post" enctype="multipart/form-data" class="form-horizontal">
	<input type="hidden" name="user_id" value="#objectUser.user_id#" />

	<cfif page_type IS 1>
		<input type="hidden" name="adminFields" value="true" />		
	</cfif>
	
	<div class="row">
	
		<cfif APPLICATION.identifier NEQ "vpnet">

		<div class="col-sm-2 col-md-2">

			<div class="row">
				<div class="col-sm-12">

				<cfif len(objectUser.image_file) GT 0 AND len(objectUser.image_type)>
					<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.image_file#&type=#objectUser.image_type#&medium=" id="userImage" alt="Imagen del usuario" class="img-thumbnail" style="text-align:right; margin-bottom:3px;" />
					<br/>
					
					<!--- 
					<cfset url_return_page = "&return_page="&URLEncodedFormat("#APPLICATION.htmlPath#/iframes/preferences_user_data.cfm")>
					<a href="#APPLICATION.htmlComponentsPath#/User.cfc?method=deleteUserImage#url_return_page#" onclick="return confirmAction('eliminar');" id="deleteImageButton" title="Eliminar imagen" class="btn btn-danger btn-xs" lang="es"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a> --->
					
					<button type="button" id="deleteImageButton" title="Eliminar imagen" class="btn btn-danger btn-xs" lang="es"><i class="icon-remove"></i> <span lang="es">Eliminar</span></button>
					
				<cfelse>
					
					<img src="#APPLICATION.htmlPath#/assets/icons/user_default_medium.png" id="userImage" class="img-thumbnail" style="text-align:right; margin-bottom:3px;" alt="Usuario sin imagen" title="Usuario sin imagen" lang="es"/>
					
				</cfif>

				</div>
			</div>

		</div>
	
		<div class="col-sm-5 col-md-5"><!---col-md-offset-1--->
			
			<div class="row">
				<div class="col-sm-12">

					<label class="control-label" for="file" lang="es">Imagen del usuario:</label>

					<noscript><b>Debe habilitar JavaScript para la subida de archivos y poder guardar cambios de este formulario</b></noscript>
					<input type="file" name="files[]" id="file" multiple accept="image/*" class="form-control">
				
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-12 col-md-12">

					<label for="family_name" class="control-label" lang="es">Nombre:</label>
					<input type="text" name="family_name" id="family_name" value="#objectUser.family_name#" class="form-control"/>

				</div>
			</div>

			<div class="row">
				<div class="col-sm-12 col-md-12">
			
					<label for="name" class="control-label" lang="es">Apellidos:</label> 
					<input type="text" name="name" id="name" value="#objectUser.name#" class="form-control"/>

				</div>
			</div>	


			<div class="row">
				<div class="col-sm-12 col-md-12">
		
					<label for="email" class="control-label" lang="es">Email:</label>
					<!---<cfif APPLICATION.userEmailRequired IS true>
						<cfinput type="text" name="email" id="email" value="#objectUser.email#" required="true" validate="email" message="Dirección de email válida requerida" class="form-control"/>
					<cfelse>--->
						<input type="email" name="email" id="email" value="#objectUser.email#" class="form-control" autocomplete="off" title="Introduzca una dirección de email válida" <cfif APPLICATION.userEmailRequired IS true>required="true"</cfif>/>
					<!---<label id="email-error" class="label label-danger" for="email" lang="es">Introduzca una dirección de email correcta.</label>--->
					<!---</cfif>--->
				</div>
			</div>		

			<cfif APPLICATION.moduleLdapUsers EQ true><!--- LDAP --->

				<div class="row">
					<div class="col-sm-12 col-md-12">

						<label for="login_ldap" class="control-label" lang="es" style="text-align:left">Login #APPLICATION.ldapName#:</label>
						<!--- <cfif SESSION.client_abb EQ "hcs">Login #APPLICATION.ldapName#
						<cfelseif SESSION.client_abb EQ "asnc">Login ASNC
						<cfelseif SESSION.client_abb EQ "agsna">Login DMSAS
						<cfelse>Login LDAP
						</cfif> --->
						<input type="text" name="login_ldap" id="login_ldap" value="#objectUser.login_ldap#" class="form-control" autocomplete="off" />

					</div>
				</div>

				<cfif APPLICATION.moduleLdapDiraya EQ true >
					<div class="row">
						<div class="col-sm-12 col-md-12">

							<label for="login_diraya" class="control-label" lang="es">Login Diraya</label>
							<input type="text" name="login_diraya" id="login_diraya" value="#objectUser.login_diraya#" class="form-control" autocomplete="off" />

						</div>
					</div>
				</cfif>

			</cfif>

			<div class="row">
				<div class="col-sm-9">

					<label for="password" class="control-label" lang="es">Nueva contraseña:</label>
					<input type="password" name="password" id="password" <cfif isDefined("objectUser.new_password")>value="#objectUser.new_password#"</cfif> class="form-control" value="" autocomplete="off" />

				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-9">

					<label for="password_confirmation" class="control-label" lang="es">Confirmar contraseña:</label>
					<input type="password" name="password_confirmation" id="password_confirmation" <cfif isDefined("objectUser.new_password")>value="#objectUser.new_password#"</cfif> class="form-control" value="" autocomplete="off" />

				</div>
			</div>

			<cfif page_type IS 1>
				
				<div class="row">
					<div class="col-sm-12">
	
						<div class="checkbox">
							<label>
								<input type="checkbox" name="internal_user" id="internal_user" value="true" <cfif isDefined("objectUser.internal_user") AND objectUser.internal_user IS true>checked="checked"</cfif> /> Usuario interno
							</label>
							<small class="help-block">Los usuarios internos pueden ver todo el árbol de la organización, y no sólo las áreas a las que tienen acceso.</small>
						</div>

					</div>
				</div>	

			</cfif>

			<div class="row">
				<div class="col-sm-12">

					<div class="checkbox">
						<label>
							<input type="checkbox" name="hide_not_allowed_areas" id="hide_not_allowed_areas" value="true" <cfif isDefined("objectUser.hide_not_allowed_areas") AND objectUser.hide_not_allowed_areas IS true>checked="checked"</cfif> /> <span lang="es">Mostrar sólo áreas con acceso</span>
						</label>
						<small class="help-block" lang="es">En el árbol de áreas sólo se mostrarán las áreas con permiso de acceso.</small>
					</div>

				</div>
			</div>	

			<cfif page_type IS 1>

				<div class="row">
					<div class="col-sm-12">
	
						<div class="checkbox">
							<label>
								<input type="checkbox" name="enabled" id="enabled" value="true" <cfif isDefined("objectUser.enabled") AND objectUser.enabled IS true>checked="checked"</cfif> /> Activo
							</label>
							<small class="help-block">Los usuarios no activos no podrán acceder a la aplicación ni recibirán notificaciones por email y seguirán siendo visibles en todos los listados de la aplicación.</small>
						</div>

					</div>
				</div>	

			</cfif>

		</div>
			
		<!---<div class="fileupload fileupload-new" data-provides="fileupload">
		  <div class="input-group">
			<div class="uneditable-input span3"><i class="icon-file fileupload-exists"></i> <span class="fileupload-preview"></span></div><span class="btn btn-file"><span class="fileupload-new">Select file</span><span class="fileupload-exists">Change</span><input type="file" /></span><a href="##" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
		  </div>
		</div>--->
			
		</cfif>
		
		
		<div class="col-sm-5 col-md-5"><!--- col-md-offset-1--->

			<div class="row">
				<div class="col-sm-8">

					<label for="dni" class="control-label" lang="es"><cfif APPLICATION.showDniTitle IS true>DNI<cfelse>Número de identificación</cfif>:</label>
					<input type="text" name="dni" id="dni" value="#objectUser.dni#" class="form-control" />

				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-8">

					<label class="control-label" for="language" lang="es">Idioma:</label>
					
					<select name="language" id="language" class="form-control">
						<option value="es" <cfif objectUser.language EQ "es">selected="selected"</cfif>>Español</option>
						<option value="en" <cfif objectUser.language EQ "en">selected="selected"</cfif>>English</option>
					</select>
					
				</div>
			</div>

			<div class="row">
				<div class="col-sm-12">

					<label for="mobile_phone" class="control-label" lang="es">Teléfono móvil:</label>

					<div class="input-group">
						<input type="text" name="mobile_phone_ccode" id="mobile_phone_ccode" value="#objectUser.mobile_phone_ccode#" class="form-control" style="width:42px;"/>
						<input type="text" name="mobile_phone" id="mobile_phone" value="#objectUser.mobile_phone#" class="form-control" style="width:150px;"/>
					</div>

				</div>								
			</div>

			<div class="row">
				<div class="col-sm-12">

					<label for="telephone" class="control-label" lang="es">Teléfono:</label>

					<div class="input-group">
						<input type="text" name="telephone_ccode" id="telephone_ccode" value="#objectUser.telephone_ccode#" class="form-control" style="width:42px;"/>
						<input type="text" name="telephone" id="telephone" value="#objectUser.telephone#" class="form-control" style="width:150px;"/>
					</div>

				</div>
			</div>	

			<div class="row">
				<div class="col-sm-12">

					<label for="linkedin_url" class="control-label" lang="es">URL Perfil LinkedIn:</label>
					<input type="url" name="linkedin_url" id="linkedin_url" value="#objectUser.linkedin_url#" class="form-control" title="Introduzca una URL válida" />

				</div>
			</div>

			<div class="row">
				<div class="col-sm-12">

					<label for="twitter_url" class="control-label" lang="es">URL Perfil Twitter:</label>
					<input type="url" name="twitter_url" id="twitter_url" value="#objectUser.twitter_url#" class="form-control" title="Introduzca una URL válida" />

				</div>
			</div>		
				
			<div class="row">
				<div class="col-sm-12">

					<label for="address" class="control-label" lang="es">Dirección:</label>
					<textarea type="text" name="address" id="address" class="form-control" rows="2">#objectUser.address#</textarea>

				</div>
			</div>
			
			<cfif page_type IS 1>

				<cfif SESSION.client_abb EQ "hcs">
					
					<div class="row">
						<div class="col-sm-12">

							<label for="perfil_cabecera" class="control-label" lang="es">Perfil de cabecera:</label>
							<input type="text" name="perfil_cabecera" id="perfil_cabecera" value="#objectUser.perfil_cabecera#" class="form-control" />
							<small class="help-block">Sólo visible desde la administración para todos los usuarios administradores.</small>

						</div>
					</div>

				</cfif>

				<div class="row">
					<div class="col-sm-12">

						<label for="information" class="control-label" lang="es">Información:</label>
						<textarea type="text" name="information" id="information" class="form-control" rows="2">#objectUser.information#</textarea>
						<small class="help-block">Sólo visible desde la administración para todos los usuarios administradores.</small>

					</div>
				</div>

			</cfif>

		</div>
		
	</div>
	
	<!--- 
	<div>
		<input type="submit" class="btn btn-primary" name="modify" value="Guardar" lang="es" />
	</div> --->
	
</form>
</cfoutput>
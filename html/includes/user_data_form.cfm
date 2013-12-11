<cfoutput>
<!---
<script src="#APPLICATION.htmlPath#/scripts/bootstrap/bootstrap-fileupload.js" type="text/javascript"></script>--->

<cfform action="#APPLICATION.htmlComponentsPath#/User.cfc?method=updateUser" method="post" enctype="multipart/form-data" style="margin-left:15px;" onsubmit="return setLanguageBeforeSend(this)">
	<input type="hidden" name="id" value="#objectUser.id#" />
	
	<div class="row">
	
		
		<cfif APPLICATION.identifier NEQ "vpnet">
	
		<!---<div style="float:right; margin-right:5px; margin-top:5px;">--->
		<div class="col-md-3">

				<div style="text-align:left;">
				<cfif len(objectUser.image_file) GT 0 AND len(objectUser.image_type)>
					<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.image_file#&type=#objectUser.image_type#&medium=" alt="Imagen del usuario" class="img-thumbnail" style="text-align:right; margin-bottom:3px;" />
					<br/>
					
					<cfset url_return_page = "&return_page="&URLEncodedFormat("#APPLICATION.htmlPath#/iframes/preferences_user_data.cfm")>
					<a href="#APPLICATION.htmlComponentsPath#/User.cfc?method=deleteUserImage#url_return_page#" onclick="return confirmAction('eliminar');" title="Eliminar imagen" class="btn btn-danger btn-xs" lang="es"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>
					
					
				<cfelse>
					
					<img src="#APPLICATION.htmlPath#/assets/icons/user_default_medium.png" class="img-thumbnail" style="text-align:right; margin-bottom:3px;" alt="Usuario sin imagen" title="Usuario sin imagen" lang="es"/>
					
				</cfif>
				</div>			
				<div>
					<label class="control-label" for="imagedata" lang="es">Imagen del usuario:</label>
					<div class="controls">
						<input type="file" name="imagedata" id="imagedata" accept="image/*"/>
					</div>
				</div>
				
				<label for="family_name" lang="es">Nombre:</label>
				<input type="text" name="family_name" id="family_name" value="#objectUser.family_name#"/>
				
				<label for="name" lang="es">Apellidos:</label> 
				<input type="text" name="name" id="name" value="#objectUser.name#" />
				
		</div>
			
		<!---<div class="fileupload fileupload-new" data-provides="fileupload">
		  <div class="input-group">
			<div class="uneditable-input span3"><i class="icon-file fileupload-exists"></i> <span class="fileupload-preview"></span></div><span class="btn btn-file"><span class="fileupload-new">Select file</span><span class="fileupload-exists">Change</span><input type="file" /></span><a href="##" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
		  </div>
		</div>--->
			
		</cfif>
		
		
		<div class="col-md-3">
		
			<label for="email" lang="es">Email:</label>
			<cfinput type="text" name="email" id="email" value="#objectUser.email#" required="true" validate="email" message="Dirección de email válida requerida" />
				
			<label for="dni" lang="es"><cfif APPLICATION.showDniTitle IS true>DNI<cfelse>Número de identificación</cfif>:</label>
			<input type="text" name="dni" id="dni" value="#objectUser.dni#" />
		
			<label class="control-label" for="language" lang="es">Idioma:</label>
			<div class="controls">
				<select name="language" id="language">
					<option value="es" <cfif objectUser.language EQ "es">selected="selected"</cfif>>Español</option>
					<option value="en" <cfif objectUser.language EQ "en">selected="selected"</cfif>>English</option>
				</select>
			</div>
			
			<label for="mobile_phone" style="float:left;" lang="es">Teléfono móvil:</label>
			<div style="float:left; width:55px;"><input type="text" name="mobile_phone_ccode" value="#objectUser.mobile_phone_ccode#" style="width:42px;"/></div> 		
			<div style="float:left; width:100px;"><input type="text" name="mobile_phone" id="mobile_phone" value="#objectUser.mobile_phone#" style="width:100%;"/></div>
			
			<div style="clear:left"></div>
			
			<label for="telephone" style="float:left;" lang="es">Teléfono:</label>
			<div style="float:left; width:55px;"><input type="text" name="telephone_ccode" value="#objectUser.telephone_ccode#" style="width:42px;"/></div>
			<div style="float:left; width:100px;"><input type="text" name="telephone" id="telephone" value="#objectUser.telephone#" style="width:100%" /></div>
		
			<div style="clear:left;"></div>
				
			<label for="address" lang="es">Dirección:</label>
			<textarea type="text" name="address" id="address" class="form-control" rows="2"/>#objectUser.address#</textarea>
			
			<label for="password" lang="es">Nueva contraseña:</label>
			<input type="password" name="password" id="password" value="" autocomplete="false" />
			
			<label for="password_confirmation" lang="es">Confirmar nueva contraseña:</label>
			<input type="password" name="password_confirmation" id="password_confirmation" value="" autocomplete="false" />
		
		</div>
		
	</div>
	
	
	<div>
	<input type="submit" class="btn btn-primary" name="modify" value="Guardar" lang="es" />
	</div>
</cfform>
</cfoutput>

<!---<script type="text/javascript">
	$(function() {
		$('.fileupload').fileupload({
			  uploadtype: "image",
			  name: "imagedata"
			});
	});
</script>--->
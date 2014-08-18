<cfoutput>
<script src="#APPLICATION.htmlPath#/language/preferences_alerts_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinclude template="alert_message.cfm">

<!---<div class="div_head_subtitle">
Preferencias de notificaciones
</div>--->

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Client" method="getClient" returnvariable="clientQuery">
	<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
</cfinvoke>

<div class="contenedor_fondo_blanco">

<cfif clientQuery.force_notifications IS true>
	
	<div class="alert alert-info"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Su organización tiene deshabilitadas las opciones de preferencias de notificaciones. Contacte con el administrador pará más información.</span></div>

<cfelse>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUserPreferences" returnvariable="preferences">
	</cfinvoke>

	<p style="padding-left:15px;"><span lang="es">Enviar un email cuando:</span></p>

	<cfoutput>
	<form action="#APPLICATION.htmlComponentsPath#/User.cfc?method=updateUserPreferences" method="post" class="form-horizontal">
		
		<div class="row">

			<div class="col-sm-1" style="padding-right:0px;text-align:center;">

			</div>

			<div class="col-sm-11">
				<label class="checkbox">
					<input type="checkbox" name="select_all" checked="checked" onclick="toggleCheckboxesChecked(this.checked);"/> Seleccionar/quitar todas
				</label>
			</div>
		</div>

		<div class="row">

			<div class="col-sm-1" style="padding-right:0px;text-align:center;">
				<img src="#APPLICATION.htmlPath#/assets/icons/message.png" alt="Nuevo mensaje" />
			</div>
			
			<div class="col-sm-11">
				<label class="checkbox">
				 	<input type="checkbox" name="notify_new_message" value="true" <cfif preferences.notify_new_message IS true>checked="checked"</cfif> />
					<span lang="es">Un mensaje ha sido creado o eliminado</span>
				</label>
			</div>
		</div>

	<cfif APPLICATION.moduleWeb EQ true><!---Web--->

	<cfif APPLICATION.identifier EQ "vpnet">
		<div class="row">

			<div class="col-sm-1" style="padding-right:0px;text-align:center;">
				<img src="#APPLICATION.htmlPath#/assets/icons/link_new.png" alt="Nuevo enlace" />
			</div>

			<div class="col-sm-11">
				<label class="checkbox">
					<input type="checkbox" name="notify_new_link" value="true" <cfif preferences.notify_new_link IS true>checked="checked"</cfif> />
					<span lang="es">Un enlace ha sido creado, modificado o eliminado</span>
				</label>
			</div>
		</div>
	</cfif>

		<div class="row">

			<div class="col-sm-1" style="padding-right:0px;text-align:center;">
				<img src="#APPLICATION.htmlPath#/assets/icons/entry.png" alt="Nuevo elemento de contenido web" />
			</div>

			<div class="col-sm-11">
				<label class="checkbox">
					<input type="checkbox" name="notify_new_entry" value="true" <cfif preferences.notify_new_entry IS true>checked="checked"</cfif> />
					<span lang="es">Un elemento de contenido web ha sido creado, modificado o eliminado</span>
				</label>
			</div>
		</div>

		<div class="row">

			<div class="col-sm-1" style="padding-right:0px;text-align:center;">
				<img src="#APPLICATION.htmlPath#/assets/icons/news.png" alt="Nueva noticia" />
			</div>

			<div class="col-sm-11">
				<label class="checkbox">
					<input type="checkbox" name="notify_new_news" value="true" <cfif preferences.notify_new_news IS true>checked="checked"</cfif> />
					<span lang="es">Una noticia ha sido creada, modificada o eliminada</span>
				</label>
			</div>
		</div>

		<div class="row">

			<div class="col-sm-1" style="padding-right:0px;text-align:center;">
				<img src="#APPLICATION.htmlPath#/assets/icons/image.png" alt="Nueva noticia" />
			</div>

			<div class="col-sm-11">
				<label class="checkbox">
					<input type="checkbox" name="notify_new_image" value="true" <cfif preferences.notify_new_image IS true>checked="checked"</cfif> />
					<span lang="es">Una imagen ha sido creada, modificada o eliminada</span>
				</label>
			</div>
		</div>

	</cfif>
		
		<div class="row">

			<div class="col-sm-1" style="padding-right:0px;text-align:center;">
				<img src="#APPLICATION.htmlPath#/assets/icons/event.png" alt="Nuevo evento" />
			</div>

			<div class="col-sm-11">
				<label class="checkbox">
					<input type="checkbox" name="notify_new_event" value="true" <cfif preferences.notify_new_event IS true>checked="checked"</cfif> />
					<span lang="es">Un evento ha sido creado, modificado o eliminado</span>
				</label>
			</div>
		</div>

	<cfif APPLICATION.identifier EQ "dp">
		
		<div class="row">

			<div class="col-sm-1" style="padding-right:0px;text-align:center;">
				<img src="#APPLICATION.htmlPath#/assets/icons/task.png" alt="Nueva tarea" />
			</div>

			<div class="col-sm-11">
				<label class="checkbox">
					<input type="checkbox" name="notify_new_task" value="true" <cfif preferences.notify_new_task IS true>checked="checked"</cfif> />
					<span lang="es">Una tarea ha sido creada, modificada o eliminada</span>
				</label>
			</div>
		</div>
		
	</cfif>

	<cfif APPLICATION.modulefilesWithTables IS true>
		<div class="row">
			<div class="col-sm-1" style="padding-right:0px;text-align:center;">
				<i class="icon-file-text" style="font-size:28px; color:##7A7A7A; margin-left:6px;"></i>
			</div>

			<div class="col-sm-11">
				<label class="checkbox">
					<input type="checkbox" name="notify_new_typology" value="true" <cfif preferences.notify_new_typology IS true>checked="checked"</cfif> />
					<span lang="es">Una tipología ha sido creada, modificada o eliminada</span>
				</label>
			</div>
		</div>	
	</cfif>

	<cfif APPLICATION.moduleConsultations IS true>
		<div class="row">
			<div class="col-sm-1" style="padding-right:0px;text-align:center;">
				<i class="icon-exchange" style="font-size:28px; color:##0088CC"></i>
			</div>

			<div class="col-sm-11">

				<label class="checkbox">
					<input type="checkbox" name="notify_new_consultation" value="true" <cfif preferences.notify_new_consultation IS true>checked="checked"</cfif> />
					<!---<img src="#APPLICATION.htmlPath#/assets/icons/consultation.png" alt="Nueva interconsulta" />---><span lang="es">Una interconsulta ha sido creada, respondida, cerrada o eliminada</span>
				</label>

			</div>

		</div>
	</cfif>

			<cfif APPLICATION.modulePubMedComments IS true>
			<div class="row">
				<div class="col-sm-1" style="padding-right:0px;text-align:center;">
					<img src="#APPLICATION.htmlPath#/assets/icons/pubmed.png" alt="Nueva publicación" />
				</div>

				<div class="col-sm-11">
					<label class="checkbox">
						<input type="checkbox" name="notify_new_pubmed" value="true" <cfif preferences.notify_new_pubmed IS true>checked="checked"</cfif> />
						<span lang="es">Una publicación ha sido creada, modificada o eliminada</span>
					</label>
				</div>
			</div>	
			</cfif>

			<div class="row">
				<div class="col-sm-1" style="padding-right:0px;text-align:center;">
					<img src="#APPLICATION.htmlPath#/assets/icons/area_new.png" alt="Crear area" />	
				</div>

				<div class="col-sm-11">
					<label class="checkbox">
						<input type="checkbox" name="notify_new_area" value="true" <cfif preferences.notify_new_area IS true>checked="checked"</cfif> />
						<span lang="es">Un área nueva ha sido creada</span>
					</label>
				</div>			
			</div>

			<div class="form_separator"></div>

			<!--- Files --->
			<div class="row">
			    <div class="col-sm-1" style="padding-right:0px;text-align:center;">
			    	<img src="#APPLICATION.htmlPath#/assets/icons/file.png" alt="Archivo" />
			    </div>
			    <div class="col-sm-11">

			    	<div class="row">
			          <div class="col-sm-6">
				    	<label class="checkbox">
							<input type="checkbox" name="notify_new_file" value="true" <cfif preferences.notify_new_file IS true>checked="checked"</cfif> />
							<!--- <img src="#APPLICATION.htmlPath#/assets/icons/file_new.png" alt="Archivo asociado" /> --->
							<span lang="es">Archivo ha sido asociado a un área</span>
						</label>
			          </div>
			          <div class="col-sm-6">
			          	<label class="checkbox">
							<input type="checkbox" name="notify_replace_file" value="true" <cfif preferences.notify_replace_file IS true>checked="checked"</cfif> />
							<!--- <img src="#APPLICATION.htmlPath#/assets/icons/file_replace.png" alt="Archivo reemplazado" /> --->
							<span lang="es">Archivo ha sido reemplazado</span>
						</label>
			          </div>
		          	</div>

		          	<div class="row">
			          <!---<div class="col-sm-5">
			          	<label class="checkbox">
							<input type="checkbox" name="notify_dissociate_file" value="true" <cfif preferences.notify_dissociate_file IS true>checked="checked"</cfif> />
							<span lang="es">Archivo ha sido quitado de un área</span>
						</label>
					  </div>--->
			          <div class="col-sm-6">
			          	<label class="checkbox">
							<input type="checkbox" name="notify_delete_file" value="true" <cfif preferences.notify_delete_file IS true>checked="checked"</cfif> />
							<span lang="es">Archivo ha sido eliminado/quitado de un área</span>
						</label>
			          </div>

			          <cfif APPLICATION.moduleAreaFilesLite>
			          	<div class="col-sm-6">
				          	<label class="checkbox">
								<input type="checkbox" name="notify_lock_file" value="true" <cfif preferences.notify_lock_file IS true>checked="checked"</cfif> />
								<span lang="es">Archivo de área ha sido bloqueado/desbloqueado</span>
							</label>
						</div>
			          </cfif>
		          	</div>
		          		
		      		<!---<div class="row">
			          <div class="col-sm-5">
			          	<label class="checkbox">
							<input type="checkbox" name="notify_new_file" value="true" <cfif preferences.notify_new_file IS true>checked="checked"</cfif> />
							<span lang="es">Archivo de área ha sido desbloqueado</span>
						</label>
			          </div>
		          	</div>--->
			    </div>
			</div>


	<cfif APPLICATION.moduleLists IS true>

		  <div class="form_separator"></div>

		  <div class="row">
		    <div class="col-sm-1" style="padding-right:0px;text-align:center;">
		    	<img src="#APPLICATION.htmlPath#/assets/icons/list.png" alt="Lista" />
		    </div>
		    <div class="col-sm-11">

		    	<div class="row">
		          <div class="col-sm-6">
			    	<label class="checkbox">
						<input type="checkbox" name="notify_new_list" value="true" <cfif preferences.notify_new_list IS true>checked="checked"</cfif> />
						<span lang="es">Una lista ha sido creada, modificada o eliminada</span>
					</label>
				  </div>

				  <div class="col-sm-6">
				  	<label class="checkbox">
						<input type="checkbox" name="notify_new_list_row" value="true" <cfif preferences.notify_new_list_row IS true>checked="checked"</cfif> />
						<span lang="es">Un registro de lista ha sido creado, modificado o eliminado</span>
					</label>
				  </div>
				</div>

				<div class="row">

				  <div class="col-sm-6">
				  	<label class="checkbox">
						<input type="checkbox" name="notify_new_list_view" value="true" <cfif preferences.notify_new_list_view IS true>checked="checked"</cfif> />
						<span lang="es">Una vista de lista ha sido creada, modificada o eliminada</span>
					</label>
				  </div>

				</div>


		    </div>
		  </div>

		<!---<div class="form-group">
		<label class="checkbox">
			<input type="checkbox" name="notify_new_list" value="true" <cfif preferences.notify_new_list IS true>checked="checked"</cfif> />
			<img src="#APPLICATION.htmlPath#/assets/icons/list.png" alt="Nueva lista" />
			<span lang="es">Una lista ha sido creada, modificada o eliminada</span>
		</label>
		</div>--->	
	</cfif>


	<cfif APPLICATION.moduleForms IS true>

		<div class="form_separator"></div>

		  <div class="row">
		    <div class="col-sm-1" style="padding-right:0px;text-align:center;">
		    	<img src="#APPLICATION.htmlPath#/assets/icons/form.png" alt="Formulario" />
		    </div>
		    <div class="col-sm-11">

		    	<div class="row">

		          <div class="col-sm-6">
			    	<label class="checkbox">
						<input type="checkbox" name="notify_new_form" value="true" <cfif preferences.notify_new_form IS true>checked="checked"</cfif> />
						<span lang="es">Un formulario ha sido creado, modificado o eliminado</span>
					</label>
				  </div>

				  <div class="col-sm-6">
				  	<label class="checkbox">
						<input type="checkbox" name="notify_new_form_row" value="true" <cfif preferences.notify_new_form_row IS true>checked="checked"</cfif> />
						<span lang="es">Un registro de formulario ha sido creado, modificado o eliminado</span>
					</label>
				  </div>

				</div>

				<div class="row">

				  <div class="col-sm-6">
				  	<label class="checkbox">
						<input type="checkbox" name="notify_new_form_view" value="true" <cfif preferences.notify_new_form_view IS true>checked="checked"</cfif> />
						<span lang="es">Una vista de formulario ha sido creada, modificada o eliminada</span>
					</label>
				  </div>

				</div>

		    </div>
		  </div>
		<!---<label class="checkbox">
			<input type="checkbox" name="notify_new_form" value="true" <cfif preferences.notify_new_form IS true>checked="checked"</cfif> />
			<img src="#APPLICATION.htmlPath#/assets/icons/form.png" alt="Nuevo formulario" />
			<span lang="es">Un formulario ha sido creado, modificado o eliminado</span>
		</label>--->
	</cfif>

		<!---<table  class="table table-bordered">

			<tr>
				<td rowspan="3">
					<img src="#APPLICATION.htmlPath#/assets/icons/file.png" alt="Archivo" />
				</td>
				<td>
					<label class="checkbox">
						<input type="checkbox" name="notify_new_file" value="true" <cfif preferences.notify_new_file IS true>checked="checked"</cfif> />
						<span lang="es">Archivo ha sido asociado a un área</span>
					</label>
				</td>
				<td>
					<label class="checkbox">
						<input type="checkbox" name="notify_replace_file" value="true" <cfif preferences.notify_replace_file IS true>checked="checked"</cfif> />
						<span lang="es">Archivo ha sido reemplazado</span>
					</label>
				</td>
			</tr>
			<tr>
				<td>
					<label class="checkbox">
						<input type="checkbox" name="notify_new_file" value="true" <cfif preferences.notify_new_file IS true>checked="checked"</cfif> />
						<span lang="es">Archivo ha sido quitado de un área</span>
					</label>
				</td>
				<td>
					<label class="checkbox" style="margin-right:10px;">
						<input type="checkbox" name="notify_new_file" value="true" <cfif preferences.notify_new_file IS true>checked="checked"</cfif> />
						<span lang="es">Archivo ha sido eliminado</span>
					</label>					
				</td>
			</tr>

		</table>--->

		<div style="height:10px;"></div>

		<input type="submit" class="btn btn-primary" name="modify" value="Guardar" lang="es"/>
	</form>
	</cfoutput>

</cfif>

</div><!--- END contenedor_fondo_blanco --->
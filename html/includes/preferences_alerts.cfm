<!---<cfoutput>
<script src="#APPLICATION.htmlPath#/language/preferences_alerts_en.js" charset="utf-8"></script>
</cfoutput>--->

<!---
IMPORTANTE: Falta por añadir las notificaciones del Documento DoPlanning
--->

<cfinclude template="alert_message.cfm">

<!---<div class="div_head_subtitle">
Preferencias de notificaciones
</div>--->

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Client" method="getClient" returnvariable="clientQuery">
	<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
</cfinvoke>

<div><!--- class="contenedor_fondo_blanco"--->

<cfif clientQuery.force_notifications IS true>

	<div class="alert alert-info"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Su organización tiene deshabilitadas las opciones de preferencias de notificaciones. Contacte con el administrador pará más información.</span></div>

<cfelse>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUserPreferences" returnvariable="preferences">
	</cfinvoke>

	<!---<div style="padding-left:15px;"></div>--->



	<cfoutput>
	<form action="#APPLICATION.htmlComponentsPath#/User.cfc?method=updateUserPreferences" method="post" id="updateUserAlertPreferences"><!---class="form-horizontal"--->

		<div class="form-horizontal"><!--- style="padding-left:10px"--->

			<div class="row">
				<div class="col-sm-offset-1 col-sm-3 col-md-2">

					<input type="submit" class="btn btn-primary btn-block" name="modify" value="Guardar" lang="es"/>

				</div>
			</div>

			<div class="row">

				<div class="col-sm-12">

					<h4 lang="es">Notificaciones instantáneas</h4>

				</div>

			</div>

			<cfif SESSION.client_abb EQ "ceseand">
				<script>
						$(function() {

							$("##collapseInstantNotifications").collapse('hide')

						});
				</script>

				<a class="btn btn btn-info" role="button" data-toggle="collapse" href="##collapseInstantNotifications" aria-expanded="false" aria-controls="collapseInstantNotifications">
				  Mostrar notificaciones instantáneas
				</a>
			</cfif>

			<div <cfif SESSION.client_abb EQ "ceseand">class="collapse"</cfif> id="collapseInstantNotifications">

					<div class="row">

						<div class="col-sm-12">

							<h5 lang="es">Enviar un email cuando:</h5>

						</div>

					</div>

					<div class="row">

						<div class="col-sm-2">


						</div>

						<div class="col-sm-10">

							<div class="row">

								<div class="col-sm-offset-1 col-sm-11">
									<label style="margin-bottom:15px;">
										<input type="checkbox" name="select_all" checked="checked" onclick="toggleContainerCheckboxesChecked('instantNotifications',this.checked);"/> <span lang="es">Seleccionar/quitar todas</span>
									</label>
								</div>

							</div>

						</div>

					</div>

					<div class="row" id="instantNotifications">

						<div class="col-sm-2">


						</div>

						<div class="col-sm-10">

							<div class="row">

								<div class="col-sm-1" style="text-align:center;">
									<img src="#APPLICATION.htmlPath#/assets/v3/icons/message.png" alt="Mensaje" lang="es" />
								</div>

								<div class="col-sm-11">
									<label style="margin-bottom:15px;">
									 	<input type="checkbox" name="notify_new_message" value="true" <cfif preferences.notify_new_message IS true>checked="checked"</cfif> />
										<span lang="es">Un mensaje ha sido creado o eliminado</span>
									</label>
								</div>
							</div>

						<cfif APPLICATION.moduleWeb EQ true><!---Web--->

						<cfif APPLICATION.identifier EQ "vpnet">
							<div class="row">

								<div class="col-sm-1" style="text-align:center;">
									<img src="#APPLICATION.htmlPath#/assets/v3/icons/link_new.png" alt="Enlace" lang="es" />
								</div>

								<div class="col-sm-11">
									<label style="margin-bottom:15px;">
										<input type="checkbox" name="notify_new_link" value="true" <cfif preferences.notify_new_link IS true>checked="checked"</cfif> />
										<span lang="es">Un enlace ha sido creado, modificado o eliminado</span>
									</label>
								</div>
							</div>
						</cfif>

							<div class="row">

								<div class="col-sm-1" style="text-align:center;">
									<img src="#APPLICATION.htmlPath#/assets/v3/icons/entry.png" alt="Elemento de contenido web" lang="es" />
								</div>

								<div class="col-sm-11">
									<label style="margin-bottom:15px;">
										<input type="checkbox" name="notify_new_entry" value="true" <cfif preferences.notify_new_entry IS true>checked="checked"</cfif> />
										<span lang="es">Un elemento de contenido web ha sido creado, modificado o eliminado</span>
									</label>
								</div>
							</div>

							<div class="row">

								<div class="col-sm-1" style="text-align:center;">
									<img src="#APPLICATION.htmlPath#/assets/v3/icons/news.png" alt="Noticia" lang="es" />
								</div>

								<div class="col-sm-11">
									<label style="margin-bottom:15px;">
										<input type="checkbox" name="notify_new_news" value="true" <cfif preferences.notify_new_news IS true>checked="checked"</cfif> />
										<span lang="es">Una noticia ha sido creada, modificada o eliminada</span>
									</label>
								</div>
							</div>

							<div class="row">

								<div class="col-sm-1" style="text-align:center;">
									<img src="#APPLICATION.htmlPath#/assets/v3/icons/image.png" alt="Imagen" lang="es" />
								</div>

								<div class="col-sm-11">
									<label style="margin-bottom:15px;">
										<input type="checkbox" name="notify_new_image" value="true" <cfif preferences.notify_new_image IS true>checked="checked"</cfif> />
										<span lang="es">Una imagen ha sido creada, modificada o eliminada</span>
									</label>
								</div>
							</div>

						</cfif>

							<div class="row">

								<div class="col-sm-1" style="text-align:center;">
									<img src="#APPLICATION.htmlPath#/assets/v3/icons/event.png" alt="Evento" lang="es" />
								</div>

								<div class="col-sm-11">
									<label style="margin-bottom:15px;">
										<input type="checkbox" name="notify_new_event" value="true" <cfif preferences.notify_new_event IS true>checked="checked"</cfif> />
										<span lang="es">Un evento ha sido creado, modificado o eliminado</span>
									</label>
								</div>
							</div>

						<cfif APPLICATION.identifier EQ "dp">

							<div class="row">

								<div class="col-sm-1" style="text-align:center;">
									<img src="#APPLICATION.htmlPath#/assets/v3/icons/task.png" alt="Tarea" lang="es" />
								</div>

								<div class="col-sm-11">
									<label style="margin-bottom:15px;">
										<input type="checkbox" name="notify_new_task" value="true" <cfif preferences.notify_new_task IS true>checked="checked"</cfif> />
										<span lang="es">Una tarea ha sido creada, modificada o eliminada</span>
									</label>
								</div>
							</div>

						</cfif>

						<cfif APPLICATION.moduleDPDocuments IS true>

							<div class="row">

								<div class="col-sm-1" style="text-align:center;">
									<img src="#APPLICATION.htmlPath#/assets/v3/icons/dp_document.png" alt="Documento DoPlanning" lang="es" />
								</div>

								<div class="col-sm-11">
									<label style="margin-bottom:15px;">
										<input type="checkbox" name="notify_new_dp_document" value="true" <cfif preferences.notify_new_dp_document IS true>checked="checked"</cfif> />
										<span lang="es">Un documento DoPlanning ha sido creado, modificado o eliminado</span>
									</label>
								</div>
							</div>

						</cfif>

						<cfif APPLICATION.modulefilesWithTables IS true>
							<div class="row">
								<div class="col-sm-1" style="text-align:center;">
									<img src="#APPLICATION.htmlPath#/assets/v3/icons/typology.png" alt="Tipología" lang="es" />
								</div>

								<div class="col-sm-11">
									<label style="margin-bottom:15px;">
										<input type="checkbox" name="notify_new_typology" value="true" <cfif preferences.notify_new_typology IS true>checked="checked"</cfif> />
										<span lang="es">Una tipología ha sido creada, modificada o eliminada</span>
									</label>
								</div>
							</div>
						</cfif>

						<cfif APPLICATION.moduleConsultations IS true>
							<div class="row">
								<div class="col-sm-1" style="text-align:center;">
									<i class="icon-exchange" style="font-size:28px; color:##0088CC"></i>
								</div>

								<div class="col-sm-11">

									<label style="margin-bottom:15px;">
										<input type="checkbox" name="notify_new_consultation" value="true" <cfif preferences.notify_new_consultation IS true>checked="checked"</cfif> />
										<!---<img src="#APPLICATION.htmlPath#/assets/v3/icons/consultation.png" alt="Nueva consulta" />---><span lang="es">Una consulta ha sido creada, respondida, cerrada o eliminada</span>
									</label>

								</div>

							</div>
						</cfif>

								<cfif APPLICATION.modulePubMedComments IS true>
								<div class="row">
									<div class="col-sm-1" style="text-align:center;">
										<img src="#APPLICATION.htmlPath#/assets/v3/icons/pubmed.png" alt="Nueva publicación" />
									</div>

									<div class="col-sm-11">
										<label style="margin-bottom:15px;">
											<input type="checkbox" name="notify_new_pubmed" value="true" <cfif preferences.notify_new_pubmed IS true>checked="checked"</cfif> />
											<span lang="es">Una publicación ha sido creada, modificada o eliminada</span>
										</label>
									</div>
								</div>
								</cfif>

								<div class="row">
									<div class="col-sm-1" style="text-align:center;">
										<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/area.png" alt="Crear area" />
									</div>

									<div class="col-sm-11">

										<label style="margin-bottom:15px;">
											<input type="checkbox" name="notify_new_area" value="true" <cfif preferences.notify_new_area IS true>checked="checked"</cfif> />
											<span lang="es">Un área nueva ha sido creada</span>
										</label>

									</div>
								</div>

								<div class="row">
									<div class="col-sm-1" style="text-align:center;">
										<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/users.png" alt="Usuario" />
									</div>

									<div class="col-sm-11">

										<div class="row">
											<div class="col-sm-12">

												<label>
													<input type="checkbox" name="notify_new_user_in_area" value="true" <cfif preferences.notify_new_user_in_area IS true>checked="checked"</cfif> />
													<span lang="es">Un usuario ha sido asociado a un área</span>
												</label>

											</div>

										</div>

										<div class="row">
											<div class="col-sm-12">

												<label style="margin-bottom:15px;">
													<input type="checkbox" name="notify_been_associated_to_area" value="true" <cfif preferences.notify_been_associated_to_area IS true>checked="checked"</cfif> />
													<span lang="es">He sido asociado como usuario a un área</span>
												</label>

											</div>
										</div>

									</div>
								</div>



							<div class="form_separator"></div>

							<!--- Files --->
							<div class="row">
							    <div class="col-sm-1" style="text-align:center;">
							    	<img src="#APPLICATION.htmlPath#/assets/v3/icons/file.png" alt="Archivo" />
							    </div>
							    <div class="col-sm-11">

							    	<div class="row">
							          <div class="col-sm-12">
								    	<label>
											<input type="checkbox" name="notify_new_file" value="true" <cfif preferences.notify_new_file IS true>checked="checked"</cfif> />
											<!--- <img src="#APPLICATION.htmlPath#/assets/v3/icons/file_new.png" alt="Archivo asociado" /> --->
											<span lang="es">Un archivo ha sido asociado a un área</span>
										</label>
							          </div>
							        </div>

							        <div class="row">
							         <div class="col-sm-12">
							          	<label>
											<input type="checkbox" name="notify_replace_file" value="true" <cfif preferences.notify_replace_file IS true>checked="checked"</cfif> />
											<!--- <img src="#APPLICATION.htmlPath#/assets/v3/icons/file_replace.png" alt="Archivo reemplazado" /> --->
											<!---<span lang="es"></span>--->
											<span lang="es">Un archivo ha sido reemplazado o ha cambiado su estado (ha sido validado, rechazado, ...)</span>
										</label>
							          </div>
						          	</div>

					          	   <!---<cfif APPLICATION.moduleAreaFilesLite>--->
						          	<div class="row">
							          	<div class="col-sm-12">
								          	<label style="margin-bottom:15px;">
												<input type="checkbox" name="notify_lock_file" value="true" <cfif preferences.notify_lock_file IS true>checked="checked"</cfif> />
												<span lang="es">Un archivo de área ha sido bloqueado/desbloqueado</span>
											</label>
										</div>
									</div>
						          <!---</cfif>---->

						          	<div class="row">
							          <!---<div class="col-sm-5">
							          	<label>
											<input type="checkbox" name="notify_dissociate_file" value="true" <cfif preferences.notify_dissociate_file IS true>checked="checked"</cfif> />
											<span lang="es">Archivo ha sido quitado de un área</span>
										</label>
									  </div>--->
							          <div class="col-sm-12">
							          	<label>
											<input type="checkbox" name="notify_delete_file" value="true" <cfif preferences.notify_delete_file IS true>checked="checked"</cfif> />
											<span lang="es">Un archivo ha sido eliminado/quitado de un área</span>
										</label>
							          </div>
							        </div>




						      		<!---<div class="row">
							          <div class="col-sm-5">
							          	<label>
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
						    <div class="col-sm-1" style="text-align:center;">
						    	<img src="#APPLICATION.htmlPath#/assets/v3/icons/list.png" alt="Lista" />
						    </div>
						    <div class="col-sm-11">

						    	<div class="row">

						          <div class="col-sm-12">
							    	<label>
										<input type="checkbox" name="notify_new_list" value="true" <cfif preferences.notify_new_list IS true>checked="checked"</cfif> />
										<span lang="es">Una lista ha sido creada, modificada o eliminada</span>
									</label>
								  </div>

								</div>

								<div class="row">

								  <div class="col-sm-12">
								  	<label>
										<input type="checkbox" name="notify_new_list_row" value="true" <cfif preferences.notify_new_list_row IS true>checked="checked"</cfif> />
										<span lang="es">Un registro de lista ha sido creado, modificado o eliminado</span>
									</label>
								  </div>

								</div>

								<div class="row">

								  <div class="col-sm-12">
								  	<label style="margin-bottom:15px;">
										<input type="checkbox" name="notify_new_list_view" value="true" <cfif preferences.notify_new_list_view IS true>checked="checked"</cfif> />
										<span lang="es">Una vista de lista ha sido creada, modificada o eliminada</span>
									</label>
								  </div>

								</div>


						    </div>
						  </div>

						<!---<div class="form-group">
						<label>
							<input type="checkbox" name="notify_new_list" value="true" <cfif preferences.notify_new_list IS true>checked="checked"</cfif> />
							<img src="#APPLICATION.htmlPath#/assets/v3/icons/list.png" alt="Nueva lista" />
							<span lang="es">Una lista ha sido creada, modificada o eliminada</span>
						</label>
						</div>--->
					</cfif>


					<cfif APPLICATION.moduleForms IS true>

						<div class="form_separator"></div>

						  <div class="row">
						    <div class="col-sm-1" style="text-align:center;">
						    	<img src="#APPLICATION.htmlPath#/assets/v3/icons/form.png" alt="Formulario" />
						    </div>
						    <div class="col-sm-11">

						    	<div class="row">

						          <div class="col-sm-12">
							    	<label>
										<input type="checkbox" name="notify_new_form" value="true" <cfif preferences.notify_new_form IS true>checked="checked"</cfif> />
										<span lang="es">Un formulario ha sido creado, modificado o eliminado</span>
									</label>
								  </div>

								</div>

								<div class="row">

								  <div class="col-sm-12">
								  	<label>
										<input type="checkbox" name="notify_new_form_row" value="true" <cfif preferences.notify_new_form_row IS true>checked="checked"</cfif> />
										<span lang="es">Un registro de formulario ha sido creado, modificado o eliminado</span>
									</label>
								  </div>

								</div>

								<div class="row">

								  <div class="col-sm-12">
								  	<label style="margin-bottom:15px;">
										<input type="checkbox" name="notify_new_form_view" value="true" <cfif preferences.notify_new_form_view IS true>checked="checked"</cfif> />
										<span lang="es">Una vista de formulario ha sido creada, modificada o eliminada</span>
									</label>
								  </div>

								</div>

						    </div>
						  </div>
						<!---<label>
							<input type="checkbox" name="notify_new_form" value="true" <cfif preferences.notify_new_form IS true>checked="checked"</cfif> />
							<img src="#APPLICATION.htmlPath#/assets/v3/icons/form.png" alt="Nuevo formulario" />
							<span lang="es">Un formulario ha sido creado, modificado o eliminado</span>
						</label>--->
					</cfif>


					<cfif APPLICATION.moduleMailing IS true>

						<div class="form_separator"></div>

						<div class="row">

							<div class="col-sm-1" style="text-align:center;">
								<img src="#APPLICATION.htmlPath#/assets/v3/icons/mailing.png" alt="Boletín" lang="es" />
							</div>

							<div class="col-sm-11">
								<label style="margin-bottom:15px;">
									<input type="checkbox" name="notify_new_mailing" value="true" <cfif preferences.notify_new_mailing IS true>checked="checked"</cfif> />
									<span lang="es">Un boletín ha sido enviado</span>
								</label>
							</div>
						</div>

					</cfif>

					<cfif SESSION.client_abb NEQ "hcs">

						<div class="form_separator"></div>

						<div class="row">
							<div class="col-sm-1" style="text-align:center;">
								<cfif APPLICATION.title EQ "DoPlanning">
									<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/organization.png" alt="DoPlanning" />
								</cfif>
							</div>
							<div class="col-sm-11">

								<div class="row">

							      <div class="col-sm-12">
							    	<label>
										<input type="checkbox" name="notify_app_features" value="true" <cfif preferences.notify_app_features IS true>checked="checked"</cfif> />
										<span lang="es">Nuevas funcionalidades de #APPLICATION.title#</span>
									</label>
								  </div>

								</div>

								<div class="row">

								  <div class="col-sm-12">
								  	<label style="margin-bottom:15px;">
										<input type="checkbox" name="notify_app_news" value="true" <cfif preferences.notify_app_news IS true>checked="checked"</cfif> />
										<span lang="es">Noticias de #APPLICATION.title#</span>
									</label>
								  </div>

								</div>
							</div>
						</div>

					</cfif>


						<!---<div style="height:10px;"></div>--->

						<div class="row">
							<div class="col-sm-12">
								<div style="height:10px"></div>
							</div>
						</div>

					</div><!--- END col-sm-offset-2 col-sm-10 --->


				</div><!--- END class="row" --->



			</div><!---END div collapse--->


			<div class="row">

				<div class="col-sm-12">

					<h4 lang="es">Notificaciones periódicas</h4>

				</div>

			</div>


			<div class="row">

				<div class="col-sm-12">

					<div class="row">

						<div class="col-sm-3">

					 		<label for="notifications_digest_type_id">Enviar un resumen de la actividad:</label>

					 	</div>

					 	<div class="col-sm-9">

							<select name="notifications_digest_type_id" id="notifications_digest_type_id" class="form-control">
								<option value="" lang="es">Nunca</option>
								<option value="1" <cfif preferences.notifications_digest_type_id IS 1>selected="selected"</cfif> lang="es">Todos los días</option>
								<option value="2" <cfif preferences.notifications_digest_type_id IS 2>selected="selected"</cfif> lang="es">Cada 7 días</option>
								<option value="3" <cfif preferences.notifications_digest_type_id IS 3>selected="selected"</cfif> lang="es">Cada 30 días</option>
							</select>

						</div>

					</div>

					<p class="help-block">
						<span lang="es">Este resumen incluye notificaciones relativas a la creación y modificación de elementos de áreas. No incluye notificaciones de acciones tales como el bloqueo o solicitud de aprobación de archivos o el cambio de área de elementos.</span><br/>
						<cfif len(preferences.notifications_last_digest_date) GT 0>
							<span lang="es">Fecha último resumen:</span> #DateFormat(preferences.notifications_last_digest_date, APPLICATION.dateFormat)#. <span lang="es">Esta fecha indica la última fecha en la que se comprobó si había elementos para incluir en la notificación periódica.</span>
						</cfif>
					</p>

				</div>

			</div>

			<div class="row">

				<div class="col-sm-12">

					<h4 lang="es">Notificaciones web</h4>

				</div>

			</div>


			<div class="row">

				<div class="col-sm-12">

					<div class="row">

						<div class="col-sm-3">

							<label for="notifications_web_digest_type_id">Enviar un resumen de la actividad web:</label>

						</div>

						<div class="col-sm-9">

							<select name="notifications_web_digest_type_id" id="notifications_web_digest_type_id" class="form-control">
								<option value="" lang="es">Nunca</option>
								<option value="1" <cfif preferences.notifications_web_digest_type_id IS 1>selected="selected"</cfif> lang="es">Todos los días</option>
								<option value="2" <cfif preferences.notifications_web_digest_type_id IS 2>selected="selected"</cfif> lang="es">Cada 7 días</option>
								<option value="3" <cfif preferences.notifications_web_digest_type_id IS 3>selected="selected"</cfif> lang="es">Cada 30 días</option>
							</select>

						</div>

					</div>

					<p class="help-block">

						<span lang="es">Este resumen incluye notificaciones relativas a la creación y modificación de los siguientes contenidos de la web: noticias, eventos, archivos, publicaciones, listas, formularios y áreas (páginas).</span><br/>
						<cfif len(preferences.notifications_web_last_digest_date) GT 0>
						 	<span lang="es">Fecha del último resumen web:</span> #DateFormat(preferences.notifications_web_last_digest_date, APPLICATION.dateFormat)#. <span lang="es">Esta fecha indica la última fecha en la que se comprobó si había elementos para incluir en la notificación periódica.</span>
						</cfif>

					</p>

				</div>

			</div>



			<div class="row">

				<div class="col-sm-12">

					<h4 lang="es">Categorías de notificaciones</h4>

					<p class="help-block" lang="es">
						El administrador de la organización define las categorías disponibles para filtrar las notificaciones.<br/>
						Cada vez que se añada una nueva categoría, estará seleccionada de forma automática para todos los usuarios de la organización.
					</p>

				</div>

			</div>

			<div class="row">

				<!---<div class="col-sm-12">

					<div class="row">--->

					<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

					<cfset categoriesDefined = false>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUserNotificationsCategoriesDisabled" returnvariable="
userNotificationsDisabledQuery">
						<cfinvokeargument name="user_id" value="#SESSION.user_id#">
						<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfif NOT isDefined("itemTypesArray")>

						<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
						</cfinvoke>

						<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

					</cfif>

					<cfset counterCategories = 0>

					<cfloop array="#itemTypesArray#" index="itemTypeId">

						<cfif itemTypeId NEQ 13 AND itemTypeId NEQ 14 AND itemTypeId NEQ 15 AND itemTypeId NEQ 16>

							<!--- getAreaItemTypesOptions --->
							<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItemType" method="getAreaItemTypesOptions" returnvariable="getItemTypesOptionsResponse">
								<cfinvokeargument name="itemTypeId" value="#itemTypeId#"/>
							</cfinvoke>

							<cfset itemTypeOptions = getItemTypesOptionsResponse.query>

							<cfif itemTypeOptions.recordCount GT 0 AND isNumeric(itemTypeOptions.category_area_id)>

								<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreas" returnvariable="subAreas">
									<cfinvokeargument name="area_id" value="#itemTypeOptions.category_area_id#">
									<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
									<cfinvokeargument name="client_dsn" value="#client_dsn#">
								</cfinvoke>

								<cfif subAreas.recordCount GT 0>

									<cfset categoriesDefined = true>

									<cfset counterCategories = counterCategories+1>

									<!---<div class="row" style="padding-bottom:20px;">--->

									<cfif counterCategories MOD 2 IS NOT 0>
										<div class="row">
									</cfif>

									<div class="col-sm-6" style="padding-bottom:20px;">

										<div class="row">

											<label class="col-sm-2 control-label" lang="es">#itemTypesStruct[itemTypeId].labelPlural#</label>

											<div class="col-sm-10">

												<cfset selectedAreasList = valueList(subAreas.id)>

												<cfquery name="userNotificationsDisabledItem" dbtype="query">
													SELECT *
													FROM userNotificationsDisabledQuery
													WHERE item_type_id = <cfqueryparam value="#itemTypeId#" cfsqltype="cf_sql_integer">;
												</cfquery>

												<cfif userNotificationsDisabledItem.recordCount GT 0>

													<cfloop query="userNotificationsDisabledItem">

														<cfset areaInListPosition = ListFind(selectedAreasList,userNotificationsDisabledItem.area_id)>

														<cfif areaInListPosition GT 0>

															<cfset selectedAreasList = listDeleteAt(selectedAreasList, areaInListPosition)>

														</cfif>

													</cfloop>

												</cfif>

												<div class="checkbox">

													<label>
														<input type="checkbox" name="select_all_#itemTypeId#" checked="checked" onclick="toggleContainerCheckboxesChecked('itemTypeCategories#itemTypeId#',this.checked);"/> <span lang="es">Seleccionar/quitar todas</span>
													</label>

												</div>

												<div id="itemTypeCategories#itemTypeId#">

													<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaHtml" method="outputSubAreasInput">
														<cfinvokeargument name="area_id" value="#itemTypeOptions.category_area_id#">
														<cfinvokeargument name="subAreas" value="#subAreas#">
														<cfif len(selectedAreasList) GT 0>
															<cfinvokeargument name="selected_areas_ids" value="#selectedAreasList#">
														</cfif>
														<cfinvokeargument name="recursive" value="false">
														<cfinvokeargument name="field_name" value="categories_#itemTypesStruct[itemTypeId].name#_ids"/>
														<cfinvokeargument name="field_input_type" value="checkbox">
														<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
														<cfinvokeargument name="client_dsn" value="#client_dsn#">
													</cfinvoke>

												</div>

											</div>

										</div><!--- END row --->

									</div><!--- END col-sm-6 --->

									<cfif counterCategories MOD 2 IS 0>
										</div>
									</cfif>

									<!---</div>--->

								</cfif>


							</cfif>

						</cfif>

					</cfloop>

					<cfif counterCategories MOD 2 IS NOT 0>
						</div>
					</cfif>

					<cfif categoriesDefined IS false>

						<div class="alert alert-info" role="alert" style="padding-top:10px;padding-bottom:10px;"><span lang="es">No hay categorías definidas en tu organización</span></div>

					</cfif>


					<!---
					</div><!---END row--->

				</div><!---END col-sm-12--->
				--->

			</div><!--- END row --->



			<cfif SESSION.client_abb EQ "hcs"><!---CESEAND--->

				<div class="row">


					<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUserNotificationsTablesCategoriesDisabled" returnvariable="
userTablesNotificationsTDisabledQuery">
						<cfinvokeargument name="user_id" value="#SESSION.user_id#">
						<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getAllTableSpecialCategories" returnvariable="allSpecialCategories">
						<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfquery name="specialCategoriesTables" dbtype="query">
						SELECT DISTINCT table_id, table_type_id
						FROM allSpecialCategories;
					</cfquery>

					<cfloop query="#specialCategoriesTables#">

						<cfset table_id = specialCategoriesTables.table_id>
						<cfset tableTypeId = specialCategoriesTables.table_type_id>

						<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTable" returnvariable="getTableQuery">
							<cfinvokeargument name="table_id" value="#table_id#">
							<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
							<cfinvokeargument name="parse_dates" value="false">
							<cfinvokeargument name="published" value="false">

							<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

						<cfif getTableQuery.recordCount GT 0>

							<!---<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTableSpecialCategories" returnvariable="tableSpecialCategories">
								<cfinvokeargument name="table_id" value="#table_id#">
								<cfinvokeargument name="tableTypeId" value="#tableTypeId#">

								<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>--->

							<cfquery name="tableSpecialCategories" dbtype="query">
								SELECT *
								FROM allSpecialCategories
								WHERE table_id = <cfqueryparam value="#table_id#" cfsqltype="cf_sql_integer">
								AND table_type_id = <cfqueryparam value="#tableTypeId#" cfsqltype="cf_sql_integer">
							</cfquery>

							<cfif tableSpecialCategories.recordCount GT 0>


								<div class="col-sm-6" style="padding-bottom:20px;">

									<div class="row">

										<label class="col-sm-2 control-label" lang="es">#getTableQuery.title#</label>

										<div class="col-sm-10">

											<cfset selectedCategoriesList = valueList(tableSpecialCategories.category_id)>

											<cfquery name="userTableNotificationsDisabledItem" dbtype="query">
												SELECT *
												FROM userTablesNotificationsTDisabledQuery
												WHERE table_id = <cfqueryparam value="#table_id#" cfsqltype="cf_sql_integer">
												AND table_type_id = <cfqueryparam value="#tableTypeId#" cfsqltype="cf_sql_integer">;
											</cfquery>

											<cfif userTableNotificationsDisabledItem.recordCount GT 0>

												<cfloop query="userTableNotificationsDisabledItem">

													<cfset categoryInListPosition = ListFind(selectedCategoriesList,userTableNotificationsDisabledItem.category_id)>

													<cfif categoryInListPosition GT 0>

														<cfset selectedCategoriesList = listDeleteAt(selectedCategoriesList, categoryInListPosition)>

													</cfif>

												</cfloop>

											</cfif>

											<div class="checkbox">

												<label>
													<input type="checkbox" name="select_all_table_categories_#table_id#" checked="checked" onclick="toggleContainerCheckboxesChecked('tableSpecialCategories#table_id#',this.checked);"/> <span lang="es">Seleccionar/quitar todas</span>
												</label>

											</div>

											<div id="tableSpecialCategories#table_id#">

												<cfloop query="tableSpecialCategories">

													<cfif listFind(selectedCategoriesList, tableSpecialCategories.category_id) GT 0>
														<cfset categorySelected = true>
													<cfelse>
														<cfset categorySelected = false>
													</cfif>

													<div class="checkbox">
													  <label>
													    <input type="checkbox" name="categories_table_#tableTypeId#_#table_id#_ids[]" value="#tableSpecialCategories.category_id#" <cfif categorySelected>checked</cfif> />&nbsp;#tableSpecialCategories.title#
													  </label>
													</div>
													<div class="clearfix"></div>

												</cfloop>

											</div>

										</div>

									</div><!--- END row --->

								</div><!--- END col-sm-6 --->


							</cfif><!---END tableSpecialCategories.recordCount GT 0--->


						</cfif><!---END getTableQuery.recordCount GT 0--->


					</cfloop>



				</div>

			</cfif>



			<div class="row">

				<div class="col-sm-12">

					<h4 lang="es">Deshabilitar todas las notificaciones</h4>

				</div>

			</div>

			<div class="row">

				<div class="col-sm-12">

				  	<div>
					    <label>
					      <input type="checkbox" name="no_notifications" value="true" class="checkbox_locked" <cfif preferences.no_notifications IS true>checked="checked"</cfif> />
							<span lang="es">Deshabilitar todas las notificaciones automáticas</span>
					    </label>
					</div>

					<p class="help-block" lang="es">
						IMPORTANTE: no se recibirá ningún tipo de notificación de la aplicación, exceptuando la de recuperación de contraseña. Tampoco serán enviadas acciones que requieran la atención del usuario tales como la aprobación o revisión de archivos de área.
					</p>

				</div>

			</div>

			<div class="row">
				<div class="col-sm-12">
					<div style="height:30px"></div>
				</div>
			</div>


			<div class="row">
				<div class="col-sm-offset-1 col-sm-3 col-md-2">

					<input type="submit" class="btn btn-primary btn-block" name="modify" value="Guardar" lang="es"/>

				</div>
			</div>

			<div class="row">
				<div class="col-sm-12">
					<div style="height:30px"></div>
				</div>
			</div>



		</div><!--- END class="form-horizontal"--->
	</form>

	</cfoutput>

</cfif>

</div><!--- END contenedor_fondo_blanco --->

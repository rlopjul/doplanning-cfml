<cfset app_version = "html2">
<cfset return_path = "#APPLICATION.htmlPath#/iframes/">

<cfif isDefined("URL.limit")>
	<cfset limit_to = URL.limit>
<cfelse>
	<cfset limit_to = 20>
</cfif>

<div class="row" id="lastItemsHead">
	<div class="col-sm-12">
		<div class="navbar navbar-default navbar-static-top">
			<div class="container-fluid">
				<span class="navbar-brand" lang="es">Últimos elementos</span>

				<form class="navbar-form navbar-right">
					<div class="form-group">
						<label for="limit" class="control-label" lang="es">Mostrar</label>
						<select name="limit" id="limit" class="form-control" onchange="loadHome();">
							<option value="20" <cfif limit_to IS 20>selected="selected"</cfif>>20</option>
							<option value="50" <cfif limit_to IS 50>selected="selected"</cfif>>50</option>
							<option value="100" <cfif limit_to IS 100>selected="selected"</cfif>>100</option>
						</select>
					</div>
					<!---<a class="btn btn-default btn-md navbar-btn navbar-right" onclick="loadHome();" title="Actualizar" lang="es"><i class="icon-refresh icon-white"></i></a>--->
					<button type="button" class="btn btn-default btn-sm navbar-btn" onclick="loadHome();" title="Actualizar" lang="es" style="margin-bottom:0;margin-top:0"><i class="icon-refresh icon-white"></i></button>
				</form>

			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-sm-12" id="lastItemsContainer" style="overflow:auto;">

<!--- All items --->

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllItems" returnvariable="getAllItemsResult">
	<cfif isDefined("limit_to") AND isNumeric(limit_to)>
	<cfinvokeargument name="limit" value="#limit_to#">
	</cfif>
	<cfinvokeargument name="full_content" value="true">
</cfinvoke>

<cfset itemsQuery = getAllItemsResult.query>

<!---<cfdump var="#areaItemsQuery#">--->


<cfif itemsQuery.recordCount GT 0>
	
	<!---<cfset area_type = "">
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsList">
		<cfinvokeargument name="itemsQuery" value="#itemsQuery#">
		<cfinvokeargument name="area_type" value="#area_type#">
		<cfinvokeargument name="app_version" value="#app_version#">
	</cfinvoke>--->

	<cfoutput>
	<cfloop query="itemsQuery">
						
		<cfset itemTypeId = itemsQuery.itemTypeId>
		
		<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
	
		<cfif isDefined("arguments.return_page")>
			<cfset rpage = arguments.return_page>
		<cfelse>
			<cfset rpage = "#lCase(itemTypeNameP)#.cfm?area=#itemsQuery.area_id#">
		</cfif>
		
		<cfif itemTypeId NEQ 10>
			<cfset item_page_url = "#itemTypeName#.cfm?#itemTypeName#=#itemsQuery.id#&return_page=#URLEncodedFormat(rpage)#">
		<cfelse><!---Files--->
			<cfset item_page_url = "#itemTypeName#.cfm?#itemTypeName#=#itemsQuery.id#&area=#area_id#&return_page=#URLEncodedFormat(rpage)#">
		</cfif>
		
	
		<div class="row"><!--- row item container --->
			<div class="col-sm-12">

				<div class="panel panel-default">
				  <div class="panel-body">
				   	
				   	<div class="row">

				   		<div class="col-sm-11">

					   		<div class="media"><!--- item user name and date --->
							  	<a class="media-left">
							    
								  	<cfif itemsQuery.itemTypeId IS 10>
								  		
								  		<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
											<cfinvokeargument name="file_id" value="#itemsQuery.id#">
											<cfinvokeargument name="area_id" value="#itemsQuery.area_id#">
										</cfinvoke>

								  	</cfif>

								    <cfif itemsQuery.itemTypeId IS NOT 10 OR itemsQuery.file_type_id IS 1>

								    	<cfif NOT isNumeric(itemsQuery.last_update_user_id) OR itemsQuery.user_in_charge EQ itemsQuery.last_update_user_id>
								    		<cfset userInCharge = itemsQuery.user_in_charge>
								    		<cfset userImageType = itemsQuery.user_image_type>
								    		<cfset userFullName = itemsQuery.user_full_name>
								    	<cfelse>
								    		<!--- Last update user --->
								    		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
												<cfinvokeargument name="user_id" value="#itemsQuery.last_update_user_id#">
											</cfinvoke>

											<cfset userInCharge = objectUser.id>
											<cfset userImageType = objectUser.image_type>
											<cfset userFullName = objectUser.user_full_name>
								    	</cfif>
								    	

									<cfelse><!--- Area files --->

										<cfif isNumeric(objectFile.replacement_user)>
											<cfset userInCharge = objectFile.replacement_user>
											<cfset userImageType = objectFile.replacement_user_image_type>
											<cfset userFullName = objectFile.replacement_user_full_name>
										<cfelse>
											<cfset userInCharge = itemsQuery.user_in_charge>
									    	<cfset userImageType = itemsQuery.user_image_type>
									    	<cfset userFullName = itemsQuery.user_full_name>
										</cfif>
										
										<!---<i><span lang="es">Área</span></i>--->
									</cfif>

									<cfif len(userImageType) GT 0>
										<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#userInCharge#&type=#userImageType#&small=" alt="#userFullName#" style="width:38px" />								
									<cfelse>							
										<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#userFullName#" style="width:38px" />
									</cfif>

							 	</a>
							 	<div class="media-body">

									#userFullName# 
									<cfif itemsQuery.itemTypeId IS 10><!---Files---->
										<cfif isNumeric(objectFile.replacement_user)>
											<span class="label label-info" lang="es">Nueva versión</span>									
										</cfif>
									<cfelseif itemTypeId NEQ 1 AND itemTypeId NEQ 7 AND itemsQuery.creation_date NEQ itemsQuery.last_update_date>

										<span class="label label-info" lang="es">Modificación</span>	

									</cfif>
									<br/>

									<cfif itemTypeId EQ 1 OR itemTypeId EQ 7 OR itemsQuery.creation_date EQ itemsQuery.last_update_date><!--- Creation date --->

										<cfinvoke component="#APPLICATION.componentsPath#/DateManager" method="timestampToString" returnvariable="stringDate">
											<cfinvokeargument name="timestamp_date" value="#itemsQuery.creation_date#">
										</cfinvoke>							
										<cfset spacePos = findOneOf(" ", stringDate)>
										<span>
											<cfif spacePos GT 0>
											#left(stringDate, spacePos)#
											<cfelse><!---Esto es para que no de error en versiones antiguas de DoPlanning que tienen la fecha en otro formato--->
											#stringDate#
											</cfif>
										</span>
										<cfif spacePos GT 0>
											<span>#right(stringDate, len(stringDate)-spacePos)#</span>
										</cfif>

									<cfelse><!--- Last update date --->
										
										<cfinvoke component="#APPLICATION.componentsPath#/DateManager" method="timestampToString" returnvariable="stringLastDate">
											<cfinvokeargument name="timestamp_date" value="#itemsQuery.last_update_date#">
										</cfinvoke>							
										<cfset spacePosLast = findOneOf(" ", stringLastDate)>
										<span>
											#left(stringLastDate, spacePosLast)#
										</span>
										<cfif spacePosLast GT 0>
											<span>#right(stringLastDate, len(stringLastDate)-spacePosLast)#</span>
										</cfif>

									</cfif>								

								</div>
							</div>

						</div>	

						<div class="col-sm-1"><!--- item type icon --->
							<div class="pull-right">

								<cfif itemTypeId IS 6><!---Tasks--->
							
									<cfif itemsQuery.done IS true>
										<img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_done.png" alt="Tarea realizada" title="Tarea realizada" style="width:40px;"/>
									<cfelse>
										<img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_not_done.png" alt="Tarea no realizada" title="Tarea no realizada" style="width:40px;"/>
									</cfif>
									
								<cfelseif itemTypeId IS 7><!--- Consultation --->
								
									<i class="icon-exchange" style="font-size:25px; color:##0088CC"></i>

								<cfelseif itemTypeId IS 10><!--- File --->

									<cfif itemsQuery.file_type_id IS 1><!--- User file --->
										<!---<img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#.png" class="item_img" alt="#itemTypeNameEs#" title="#itemTypeNameEs#"/>--->

										<cfif itemTypeId IS 10>

											<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFileIconsTypes" returnvariable="iconTypes">
											</cfinvoke>

											<cfset fileType = lCase(replace(itemsQuery.file_type,".",""))>
											
											<cfif listFind (iconTypes, fileType)>
												<cfset fileIcon = "_"&fileType>
											<cfelse>
												<cfset fileIcon = "">
											</cfif>

											<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#itemsQuery.id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar"><img src="#APPLICATION.htmlPath#/assets/icons/file#fileIcon#.png" style="width:40px;"/></a>

										</cfif>


									<cfelseif itemsQuery.file_type_id IS 2><!--- Area file --->

										<cfif itemsQuery.locked IS true>
											<img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_area_locked.png" class="item_img" alt="#itemTypeNameEs# del área bloqueado" title="#itemTypeNameEs# del área bloqueado" style="width:40px;"/>
										<cfelse>
											<img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_area.png" class="item_img" alt="#itemTypeNameEs# del área" title="#itemTypeNameEs# del área" style="width:40px;"/>
										</cfif>

									<cfelseif itemsQuery.file_type_id IS 3>

										<cfif itemsQuery.locked IS true>
											<img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_edited_locked.png" class="item_img" alt="#itemTypeNameEs# del área bloqueado" title="#itemTypeNameEs# del área bloqueado" style="width:40px;"/>
										<cfelse>
											<img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_edited.png" class="item_img" alt="#itemTypeNameEs# del área en edición" title="#itemTypeNameEs# del área en edición" style="width:40px;"/>
										</cfif>

									</cfif>

								<cfelseif itemTypeId IS NOT 3><!---No es link--->
								
									<img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#.png" alt="#itemTypeNameEs#" title="#itemTypeNameEs#" style="width:40px;"/>
										
								<cfelse><!---style="max-width:none;" Requerido para corregir un bug con Bootstrap en Chrome--->
									<a href="#APPLICATION.htmlPath#/go_to_link_link.cfm?#itemTypeName#=#itemsQuery.id#" style="float:left;" target="_blank" title="Visitar el enlace" onclick="openUrl('#APPLICATION.htmlPath#/go_to_link_link.cfm?#itemTypeName#=#itemsQuery.id#','_self',event)"><img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#.png" style="width:40px;"/></a>
								</cfif>

							</div>
						</div>
					</div>

					<div class="row">

						<div class="col-sm-12">
							<hr style="margin:0"/>
						</div>

					</div>

					<div class="row">

						<div class="col-sm-11">

							<cfset titleClass = "text_item">

							<cfif itemTypeId IS 6 AND itemsQuery.done IS false><!--- Task not done --->
								<cfif dateCompare(now(), itemsQuery.end_date, "d") IS 1>
									<cfset titleClass = titleClass&" text_red"> 
								</cfif>
							</cfif>

							<cfset titleContent = itemsQuery.title>

							<!---
							<cfif len(titleContent) IS 0>

								<cfset itemDescription = itemsQuery.description>

								<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="removeHTML" returnvariable="itemDescription">
									<cfinvokeargument name="string" value="#itemDescription#">
								</cfinvoke>

								<cfif len(itemsQuery.description) GT 100>
									<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="leftToNextSpace" returnvariable="itemContent">
										<cfinvokeargument name="str" value="#itemDescription#">
										<cfinvokeargument name="count" value="100">
									</cfinvoke>
									<cfset titleContent = "<i>#itemContent#...</i>">
								<cfelse>
									<cfset titleContent = "<i>#itemDescription#</i>">
								</cfif>
							
							</cfif>
							--->				

							<h4>#titleContent#</h4><!---<h5>--->

							<cfif itemTypeId IS 5 OR itemTypeId IS 6><!--- Events, Tasks --->
								
								<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getItem" returnvariable="objectItem">
									<cfinvokeargument name="item_id" value="#itemsQuery.id#">
									<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
								</cfinvoke>

								<b lang="es">Fecha de inicio</b> <span>#objectItem.start_date#
								<cfif itemTypeId IS 5>#TimeFormat(objectItem.start_time,"HH:mm")#</cfif></span>&nbsp; 

								<b lang="es">Fecha de fin</b> <span>#objectItem.end_date# 
								<cfif itemTypeId IS 5>#TimeFormat(objectItem.end_time,"HH:mm")#</cfif></span>&nbsp; 
								
							
								<cfif itemTypeId IS 5><!---Events--->
									<b lang="es">Lugar</b> <span>#objectItem.place#</span>
								<cfelse><!---Tasks--->
									<b lang="es">Realizada</b> <span lang="es"><cfif objectItem.done IS true>Sí<cfelse>No</cfif></span>
								</cfif>

								<br>

							<cfelseif itemTypeId IS 7><!--- Consultations --->

								<b lang="es">Estado</b> <span lang="es"><cfswitch expression="#itemsQuery.state#">
									<cfcase value="created">Enviada</cfcase>
									<cfcase value="read">Leída</cfcase>
									<cfcase value="answered">Respondida</cfcase>
									<cfcase value="closed"><strong lang="es">Cerrada</strong></cfcase>
								</cfswitch></span>

							</cfif>


							<cfif itemTypeId EQ 10><!--- Files --->

								<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#itemsQuery.id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar"><i class="icon-download-alt"></i> #itemsQuery.file_name#</a><br/>

							<cfelse>


								<cfif isNumeric(itemsQuery.attached_file_id) OR isNumeric(itemsQuery.attached_image_id) OR (len(itemsQuery.link) GT 0 AND itemsQuery.link NEQ "http://")>
									
									<div style="clear:both;margin-bottom:5px;">
										<cfif isNumeric(itemsQuery.attached_file_id)>

											<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#itemsQuery.attached_file_id#&#itemTypeName#=#itemsQuery.id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar"><i class="icon-paper-clip"></i></a>
											<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#itemsQuery.attached_file_id#&#itemTypeName#=#itemsQuery.id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar">#itemsQuery.attached_file_name#</a><br/>

											<!---<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#itemsQuery.attached_file_id#&#itemTypeName#=#itemsQuery.id#" onclick="return downloadFileLinked(this,event)" class="btn btn-sm btn-default" title="Descargar archivo adjunto"><i class="icon-paper-clip" style="font-size:14px;"></i></a>--->

											<!---<span class="divider">&nbsp;</span>--->
										</cfif>

										<cfif isNumeric(itemsQuery.attached_image_id)>

											<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#itemsQuery.attached_image_id#&#itemTypeName#=#itemsQuery.id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar"><i class="icon-camera"></i></a>
											<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#itemsQuery.attached_image_id#&#itemTypeName#=#itemsQuery.id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar">#itemsQuery.attached_image_name#</a><br/>

											<!---<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#itemsQuery.attached_image_id#&#itemTypeName#=#itemsQuery.id#" onclick="return downloadFileLinked(this,event)" class="btn btn-sm btn-default" title="Descargar imagen adjunta"><i class="icon-camera" style="font-size:13px;"></i></a>--->

											<!---<span class="divider">&nbsp;</span>--->
										</cfif>

										<cfif len(itemsQuery.link) GT 0 AND itemsQuery.link NEQ "http://">
											<a href="#itemsQuery.link#" target="_blank"><i class="icon-external-link-sign"></i></a>
											<a href="#itemsQuery.link#" target="_blank">#itemsQuery.link#</a><br/>
										</cfif>
									</div>

								</cfif>
								

							</cfif>


							<div style="clear:both;margin-bottom:10px;">
								<cfif itemTypeId NEQ 20>
									#itemsQuery.description#
								<cfelse>
									<textarea name="description#itemsQuery.id#" class="form-control" style="height:500px;" readonly>#itemsQuery.description#</textarea>
									<cfinvoke component="#APPLICATION.htmlComponentsPath#/CKEditorManager" method="loadComponent">
										<cfinvokeargument name="name" value="description#itemsQuery.id#">
										<cfinvokeargument name="language" value="#SESSION.user_language#"/>
										<cfinvokeargument name="height" value="500"/>
										<cfinvokeargument name="toolbar" value="DP_document"/>
										<cfinvokeargument name="readOnly" value="true"/>
										<cfinvokeargument name="toolbarStartupExpanded" value="false"/>
										<cfinvokeargument name="toolbarCanCollapse" value="true"/>
									</cfinvoke>	
								</cfif>
							</div>
							
						</div>

						<div class="col-sm-1">
							<div class="pull-right" style="padding-top:10px;">

								<cfif itemTypeId NEQ 10>
								
									<cfif isNumeric(itemsQuery.attached_file_id)>
									
										<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFileIconsTypes" returnvariable="iconTypes">
										</cfinvoke>

										<cfset fileType = lCase(listLast(itemsQuery.attached_file_name,"."))>

										<!---<cfset fileType = lCase(replace(itemsQuery.file_type,".",""))>--->
													
										<cfif listFind (iconTypes, fileType)>
											<cfset fileIcon = "_"&fileType>
										<cfelse>
											<cfset fileIcon = "">
										</cfif>

										<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#itemsQuery.attached_file_id#&#itemTypeName#=#itemsQuery.id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar"><img src="#APPLICATION.htmlPath#/assets/icons/file#fileIcon#.png"/></a>

									</cfif>

									<cfif isNumeric(itemsQuery.attached_image_id)>
									
										<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFileIconsTypes" returnvariable="iconTypes">
										</cfinvoke>

										<cfset fileType = lCase(listLast(itemsQuery.attached_image_name,"."))>

										<!---<cfset fileType = lCase(replace(itemsQuery.file_type,".",""))>--->
													
										<cfif listFind (iconTypes, fileType)>
											<cfset fileIcon = "_"&fileType>
										<cfelse>
											<cfset fileIcon = "">
										</cfif>

										<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#itemsQuery.attached_image_id#&#itemTypeName#=#itemsQuery.id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar"><img src="#APPLICATION.htmlPath#/assets/icons/file#fileIcon#.png"/></a>

									</cfif>

								</cfif>

								<!---Attached files--->
								<!---
								<cfif itemTypeId IS 10><!--- File --->
								<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#itemsQuery.id#" onclick="return downloadFileLinked(this,event)" title="Descargar archivo"><i class="icon-download-alt" style="font-size:13px;"></i><span class="hidden">3</span></a>
								<cfelseif isNumeric(itemsQuery.attached_file_id)>
								<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#itemsQuery.attached_file_id#&#itemTypeName#=#itemsQuery.id#" onclick="return downloadFileLinked(this,event)" title="Descargar archivo adjunto"><i class="icon-paper-clip" style="font-size:14px;"></i><span class="hidden">1</span></a>
								</cfif>

								<cfif isNumeric(itemsQuery.attached_image_id)>
								<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#itemsQuery.attached_image_id#&#itemTypeName#=#itemsQuery.id#" onclick="return downloadFileLinked(this,event)" title="Descargar imagen adjunta"><i class="icon-camera" style="font-size:13px;"></i><span class="hidden">2</span></a>
								
								</cfif>--->

							</div>
						</div>

					</div>


					<div class="row">
						<div class="col-sm-12">
							<!---
							<div class="pull-left">
								Área: <a onclick="openUrl('area_items.cfm?area=#itemsQuery.area_id#&#itemTypeName#=#itemsQuery.id#','areaIframe',event)" title="Ir al área">#itemsQuery.area_name#</a>															
							</div>
							---->
							<div class="pull-right">

								<!---Attached files--->
								<cfif itemTypeId IS 10><!--- File --->
									<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#itemsQuery.id#" onclick="return downloadFileLinked(this,event)" class="btn btn-sm btn-primary" title="Descargar archivo"><i class="icon-download-alt" style="font-size:13px;"></i></a>
									<span class="divider">&nbsp;</span>
								</cfif>

								<cfif itemTypeId IS 11 OR itemTypeId IS 12 OR itemTypeId IS 14 OR itemTypeId IS 15 OR itemTypeId IS 16><!---Lists, Forms And Views--->
									<a onclick="openUrl('#itemTypeName#_rows.cfm?#itemTypeName#=#itemsQuery.id#','areaIframe',event)" class="btn btn-sm btn-default" title="Registros"><i class="icon-list" style="font-size:15px;"></i></a>
								</cfif>

								<cfset item_id = itemsQuery.id>

								<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path#area_items.cfm?area=#area_id#&#itemTypeName#=#item_id#")>
								<cfset url_return_path = "&return_path="&URLEncodedFormat("#return_path#area_items.cfm?area=#area_id#&#itemTypeName#=#item_id#")>

								<cfif itemTypeId IS 1 OR itemTypeId IS 7><!---Solo para mensajes y consultas--->

									<cfif itemTypeId IS 1 OR itemsQuery.state NEQ "closed">
										<a onclick="openUrl('area_items.cfm?area=#itemsQuery.area_id#&#itemTypeName#=#itemsQuery.id#&reply','areaIframe',event)" class="btn btn-sm btn-primary" title="Responder" lang="es"><i class="icon-reply"></i></a>
										<span class="divider">&nbsp;</span>
									</cfif>
							
								<cfelse><!---Si no es mensaje--->
							
									
									<!---<cfif APPLICATION.moduleWeb IS true AND len(area_type) GT 0>

										<cfif is_user_area_responsible IS true>
											
											<!--- publication validation --->
											<cfif itemsQuery.publication_validated IS false>

												<cfif SESSION.client_abb NEQ "hcs" OR NOT isDefined("itemsQuery.publication_scope_id") OR itemsQuery.publication_scope_id NEQ 1><!---En el DP HCS el ámbito de publicación 1 es DoPlanning, que NO necesita aprobación de publicación--->
													<a href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=changeItemPublicationValidation&item_id=#item_id#&itemTypeId=#itemTypeId#&validate=true#url_return_path#" onclick="return confirmReversibleAction('Permitir la publicación en web');" title="Permitir la publicación en web" class="btn btn-success btn-sm"><i class="icon-check"></i> <span lang="es">Aprobar publicación</span></a>
												</cfif>

											<cfelse>
												<a href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=changeItemPublicationValidation&item_id=#item_id#&itemTypeId=#itemTypeId#&validate=false#url_return_path#" onclick="return confirmReversibleAction('Impedir la publicación en web');" title="Permitir la publicación en web" class="btn btn-warning btn-sm"><i class="icon-remove-sign"></i> <span lang="es">Desaprobar publicación</span></a>
											</cfif>
										</cfif>


									</cfif>--->


								</cfif>

								<a href="#APPLICATION.htmlPath#/#itemTypeName#.cfm?#itemTypeName#=#item_id#" title="Abrir en nueva ventana" target="_blank" class="btn btn-default btn-sm" lang="es"><i class="icon-external-link"></i></a>
								<span class="divider">&nbsp;</span>
								<a onclick="openUrl('area_items.cfm?area=#itemsQuery.area_id#&#itemTypeName#=#itemsQuery.id#','areaIframe',event)" class="btn btn-sm btn-info" title="Ir al área"><img src="#APPLICATION.htmlPath#/assets/icons_dp/area_small.png" alt="Area" title="Ver en área"><span lang="es">Ver en área</a>

							</div>
						</div>
					</div>


					</div>
				</div>
			
			</div><!--- END col --->
		</div><!---END row item container--->
	</cfloop>
	</cfoutput>

<cfelse>		

	<cfoutput>
	<span lang="es">No hay elementos</span>
	</cfoutput>

	<div class="alert alert-info" style="margin-top:10px;"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Accede a las áreas de la organización a través de la pestaña</span> <a onclick="showTreeTab()" style="cursor:pointer" lang="es">Árbol</a> <span lang="es">para crear nuevos elementos</span></div>

</cfif>


	</div>
</div>
<cfoutput>

	<script>

		$(function() {

			$('##areaItemsMenu').on('affix.bs.affix', function () {
			     $('##areaItemsMenu').css("top", $('##mainNavBarFixedTop').height()-2);
			     <!---$("##areaItemsMenu").css("z-index", 1);--->
			});


			$('##areaItemsMenu').affix({
		      	offset: {
		       		top: $('##mainNavBarFixedTop').height()-$('##areaItemsMenu').height()
		      	}
			});

			<!---$(window).bind('scroll', function() {
			    ($(window).scrollTop() > 100) ? $('##areaItemsMenu').addClass('goToTop') : $('##areaItemsMenu').removeClass('goToTop');
			 });--->

		});

	</script>

	<nav class="navbar-default" id="areaItemsMenu">

		<div class="container">

			<div class="row">

			<div class="col-sm-12">

		<div class="btn-toolbar" style="padding-bottom:10px;" role="toolbar">


			<!--- ------------------------------------------------ DESPLEGABLE NUEVO ELEMENTO ------------------------------------------------ --->

			<cfif objectArea.read_only IS false>

				<cfif app_version NEQ "mobile">

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
					</cfinvoke>

					<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

				</cfif>

				<cfset previousLoopCurButton = 0>

				<cfloop array="#itemTypesArray#" index="curItemTypeId">

					<cfif curItemTypeId NEQ 14 AND curItemTypeId NEQ 15 AND curItemTypeId NEQ 16>
						<cfif ( ( areaTypeWeb AND itemTypesStruct[curItemTypeId].web ) OR ( areaTypeWeb IS false AND itemTypesStruct[curItemTypeId].noWeb ) ) AND objectArea["item_type_#curItemTypeId#_enabled"] IS true>

							<cfset previousLoopCurButton = previousLoopCurButton+1>

						</cfif>

					</cfif>

				</cfloop>


				<cfif previousLoopCurButton GT 0>

					<div class="btn-group" id="newItemDropDown">
					  <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false" aria-controls="newItemMenu" title="Nuevo elemento" lang="es">
					    <i class="icon-plus" style="color:##35938B;font-size:18px;"></i><span class="sr-only" lang="es">Nuevo elemento</span></span>
					  </button>
					  <ul class="dropdown-menu" id="newItemMenu">

					  		<li>

					  		<div class="row" style="width:450px;" role="menu">

					        	<ul class="list-unstyled col-md-6">


						    <cfset loopCurButton = 0>

							<cfloop array="#itemTypesArray#" index="curItemTypeId">

								<cfif curItemTypeId NEQ 14 AND curItemTypeId NEQ 15 AND curItemTypeId NEQ 16 AND ( curItemTypeId NEQ 7 OR APPLICATION.moduleConsultations IS true ) AND ( curItemTypeId NEQ 13 OR APPLICATION.modulefilesWithTables IS true ) AND ( curItemTypeId NEQ 8 OR APPLICATION.modulePubMedComments IS true ) AND ( curItemTypeId NEQ 20 OR APPLICATION.moduleDPDocuments IS true ) AND ( (curItemTypeId NEQ 2 AND curItemTypeId NEQ 4 AND curItemTypeId NEQ 9) OR APPLICATION.moduleWeb EQ true )>

									<cfif objectArea["item_type_#curItemTypeId#_enabled"] IS true AND ( ( areaTypeWeb AND itemTypesStruct[curItemTypeId].web ) OR ( areaTypeWeb IS false AND itemTypesStruct[curItemTypeId].noWeb ) ) AND ( (curItemTypeId NEQ 11 AND curItemTypeId NEQ 12 AND curItemTypeId NEQ 13 AND curItemTypeId NEQ 17) OR is_user_area_responsible )>

										<cfset loopCurButton = loopCurButton+1>

										<cfif itemTypesStruct[curItemTypeId].gender EQ "male">
											<cfset newItemTitle = "Nuevo">
										<cfelse>
											<cfset newItemTitle = "Nueva">
										</cfif>

										<li>

												<cfif curItemTypeId IS 10><!---File--->
													<a onclick="openUrlLite('area_file_new.cfm?area=#area_id#&fileTypeId=1', 'itemIframe')" title="#newItemTitle# #itemTypesStruct[curItemTypeId].label#" lang="es" role="menuitem" class="btn-new-item-dp"><!--- href="area_file_new.cfm?area=#area_id#&fileTypeId=1" --->
												<cfelse>
													<a onclick="openUrlLite('#itemTypesStruct[curItemTypeId].name#_new.cfm?area=#area_id#', 'itemIframe')" title="#newItemTitle# #itemTypesStruct[curItemTypeId].label#" lang="es" role="menuitem" class="btn-new-item-dp">
												</cfif>

												<img src="#APPLICATION.htmlPath#/assets/v3/icons/#itemTypesStruct[curItemTypeId].name#.png" alt="#newItemTitle# #itemTypesStruct[curItemTypeId].label#" lang="es"/>

												<span lang="es">#itemTypesStruct[curItemTypeId].label#</span>
											</a>

										</li>

										<cfif curItemTypeId IS 10>

											<li>

												<cfif APPLICATION.moduleAreaFilesLite IS true><!---AND len(area_type) IS 0--->
												<a onclick="openUrlLite('area_file_new.cfm?area=#area_id#&fileTypeId=2', 'itemIframe')" title="Archivo de área" lang="es" class="btn-new-item-dp" role="menuitem"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>---> <img src="#APPLICATION.htmlPath#/assets/v3/icons/file_area.png" />
													<span lang="es">Archivo de área</span>
												</a>
												</cfif>

											</li>

											<li>
												<a onclick="openUrlLite('area_files_upload.cfm?area=#area_id#', 'itemIframe')" class="btn-new-item-dp" title="Subir varios archivos" lang="es" role="menuitem"><img src="#APPLICATION.htmlPath#/assets/v3/icons/files.png" />
													<span lang="es">Subir varios archivos</span>
												</a>
											</li>

										</cfif>

										<cfif curItemTypeId EQ 6><!--- Cierra la primera columna --->

											</ul><!--- END list-unstyled col-md-6 --->
											<ul class="list-unstyled col-md-6">

										</cfif>

										<cfif loopCurButton EQ previousLoopCurButton>
											<cfbreak>
										</cfif>

									</cfif>
								</cfif>

							</cfloop>


								</ul><!--- END list-unstyled col-md-6 --->

				            </div><!--- END row --->

				            </li>

					  </ul><!--- END dropdown-menu --->

					</div>

				</cfif>


			</cfif>

			<!--- ------------------------------------------------- FIN DESPLEGABLE NUEVO ELEMENTO ------------------------------------------------ --->


			<!--- ------------------------------------------------ DESPLEGABLE FILTRADO DE ELEMENTOS ---------------------------------------------- --->

			<cfif area_allowed EQ true>

				<div class="btn-group" id="filterAreaElements">

					<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false" aria-controls="filterAreaElementsMenu" title="Filtrar" lang="es">

						<i class="icon-filter" style="color:##EAD142"></i>

						<span lang="es">VER</span> <span class="caret"></span>

					</button>

					<ul class="dropdown-menu" id="filterAreaElementsMenu"> <!---dropdown-menu-right--->

						<li>

						<div class="row" style="width:450px;" role="menu">

					         <ul class="list-unstyled col-md-6">


									<li>

										<cfif find("user",CGI.SCRIPT_NAME) GT 0 OR ( isDefined("itemTypeId") AND itemTypeId EQ 13 AND ( NOT isDefined("URL.mode") OR URL.mode NEQ "list" ) )><!--- No está en el listado de todos los elementos, está en listado de un tipo de elemento --->
											<a href="area_items.cfm?area=#area_id#" role="menuitem">
										<cfelseif isDefined("itemTypeId") OR ( isDefined("URL.mode") AND URL.mode EQ "list" )>
											<a href="area_items.cfm?area=#area_id#&mode=list" role="menuitem">
										<cfelse><!--- Está en el listado desarrollado de todos los elementos --->
											<a onclick="setItemsFilter('*')" role="menuitem">
										</cfif>
											<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/area.png" title="Todos los elementos del área" alt="Todos los elementos del área" lang="es" style="height:35px;" />
											<span lang="es">Elementos del área</span>
										</a>

									</li>


							    	<cfloop array="#itemTypesArray#" index="curItemTypeId">


							    		<cfif ( curItemTypeId NEQ 13 OR APPLICATION.modulefilesWithTables IS true ) AND ( curItemTypeId NEQ 7 OR APPLICATION.moduleConsultations IS true ) AND ( curItemTypeId NEQ 13 OR APPLICATION.moduleForms IS true ) AND ( curItemTypeId NEQ 8 OR APPLICATION.modulePubMedComments IS true ) AND ( curItemTypeId NEQ 20 OR APPLICATION.moduleDPDocuments IS true ) AND ( (curItemTypeId NEQ 2 AND curItemTypeId NEQ 4 AND curItemTypeId NEQ 9) OR APPLICATION.moduleWeb EQ true )>

							    			<cfif areaTypeWeb AND itemTypesStruct[curItemTypeId].web OR areaTypeWeb IS false AND itemTypesStruct[curItemTypeId].noWeb>

												<li>

													<!---<a href="#itemTypesStruct[curItemTypeId].namePlural#.cfm?area=#area_id#" title="#itemTypesStruct[curItemTypeId].labelPlural#" lang="es">--->

													<cfif find("user",CGI.SCRIPT_NAME) GT 0><!---Listado de usuarios--->

														<a href="area_items.cfm?area=#area_id#&filter=#itemTypesStruct[curItemTypeId].name#" title="#itemTypesStruct[curItemTypeId].labelPlural#" lang="es" role="menuitem">

													<cfelseif isDefined("itemTypeId") OR isDefined("URL.mode") AND URL.mode EQ "list"><!--- No está en el listado de todos los elementos, está en listado de un tipo de elemento --->

														<cfif curItemTypeId NEQ 14 AND curItemTypeId NEQ 15><!--- Si no es vista de lista o vista de formulario --->
															<a href="#itemTypesStruct[curItemTypeId].namePlural#.cfm?area=#area_id#" title="#itemTypesStruct[curItemTypeId].labelPlural#" lang="es" role="menuitem">
														<cfelse>
															<a href="area_items.cfm?area=#area_id#&filter=#itemTypesStruct[curItemTypeId].name#&mode=" title="#itemTypesStruct[curItemTypeId].labelPlural#" lang="es" role="menuitem">
														</cfif>

													<cfelse><!--- Está en el listado desarrollado de todos los elementos --->


														<cfif curItemTypeId NEQ 13>
															<a onclick="setItemsFilter('#itemTypesStruct[curItemTypeId].name#')" title="#itemTypesStruct[curItemTypeId].labelPlural#" lang="es" role="menuitem">
														<cfelse><!--- Typologies --->
															<a href="typologies.cfm?area=#area_id#" title="#itemTypesStruct[curItemTypeId].labelPlural#" lang="es" role="menuitem">
														</cfif>


							    					</cfif>

														<img src="#APPLICATION.htmlPath#/assets/v3/icons/#itemTypesStruct[curItemTypeId].name#.png" alt="#itemTypesStruct[curItemTypeId].labelPlural#" lang="es" style="height:35px"/>


														<span lang="es">#itemTypesStruct[curItemTypeId].labelPlural#</span>
													</a>

												</li>

											</cfif>

										</cfif>

										<cfif curItemTypeId EQ 12><!--- Cierra la primera columna --->

											</ul><!--- END list-unstyled col-md-6 --->
											<ul class="list-unstyled col-md-6">

										</cfif>


									</cfloop>

									<!---
									<cfif APPLICATION.modulefilesWithTables IS true><!---AND is_user_area_responsible>--->
										<li><!---Typologies--->
											<a href="#itemTypesStruct[13].namePlural#.cfm?area=#area_id#" title="#itemTypesStruct[13].labelPlural#" lang="es">
												<img src="#APPLICATION.htmlPath#/assets/v3/icons/#itemTypesStruct[13].name#.png" alt="#itemTypesStruct[13].labelPlural#" lang="es" style="height:35px"/>
												<span lang="es">#itemTypesStruct[13].labelPlural#</span>
											</a>
										</li>
									</cfif>
									--->

									<li><!---Users--->
										<a href="users.cfm?area=#area_id#" lang="es" role="menuitem">
											<!---<i class="icon-group" style="margin-left:2px;margin-right:2px;"></i>--->
											<img src="#APPLICATION.htmlPath#/assets/v3/icons_#APPLICATION.identifier#/users.png" title="Usuarios del área" alt="Usuarios del área" lang="es" style="height:35px"/>
											<span lang="es">Usuarios</span>
										</a>
									</li>


								</ul><!--- END list-unstyled col-md-6 --->

				            </div><!--- END row --->

				        <li>

					</ul><!--- END dropdown-menu --->

				</div>


				<!---INDICADOR FILTRADO ACTUAL--->
				<cfif isDefined("itemTypeId")>

					<div class="btn-group">

						<span class="btn btn-link" style="cursor:default;color:##000000">
							<cfif itemTypeId IS 7><!---Consultations--->
								<i class="icon-exchange" style="font-size:24px;color:##0088CC;margin-left:5px;margin-right:5px;"></i>
							<cfelseif itemTypeId IS 13><!---Typologies--->
								<i class="icon-file-text" style="font-size:24px;color:##7A7A7A"></i>
							<cfelse>
								<img src="#APPLICATION.htmlPath#/assets/v3/icons/#itemTypesStruct[itemTypeId].name#.png" style="height:26px;" alt="#itemTypesStruct[itemTypeId].labelPlural#"lang="es"/>
							</cfif>

							<cfif isDefined("URL.#itemTypesStruct[itemTypeId].name#")>
								<span lang="es">#itemTypesStruct[itemTypeId].label#</span>
							<cfelse>
								<span lang="es">#itemTypesStruct[itemTypeId].labelPlural#</span>
							</cfif>

							<span id="totalItemsLabel"><cfif isDefined("numItems")>&nbsp;<span class="label label-primary label-as-badge" id="totalItemsValue">#numItems#</span></cfif></span>

						</span>

					</div>


				<cfelseif curElement EQ "item">

					<div class="btn-group">

						<span class="btn btn-link" style="cursor:default;color:##000000">

							<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/area.png" title="Todos los elementos del área" alt="Todos los elementos del área" lang="es" style="height:26px;" />
							<span lang="es">Elementos del área</span>

							<span id="totalItemsLabel"><cfif isDefined("numItems")>&nbsp;<span class="label label-primary label-as-badge" id="totalItemsValue">#numItems#</span></cfif></span>

						</span>

					</div>

				<cfelseif curElement EQ "user">

					<div class="btn-group">

						<span class="btn btn-link" style="cursor:default;color:##000000">

							<img src="#APPLICATION.htmlPath#/assets/v3/icons_#APPLICATION.identifier#/users.png" title="Usuarios del área" alt="Usuarios del área" lang="es" style="height:26px"/>
							<cfif isDefined("URL.user")>
								<span lang="es">Usuario del área</span>
							<cfelse>
								<span lang="es">Usuarios del área</span>
							</cfif>

							<span id="totalItemsLabel"><cfif isDefined("numItems")>&nbsp;<span class="label label-primary label-as-badge" id="totalItemsValue">#numItems#</span></cfif></span>

						</span>

					</div>

				<cfelse>

					<div class="btn-group">

						<span class="btn btn-link" style="cursor:default;color:##000000">

							<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/area.png" title="Todos los elementos del área" alt="Todos los elementos del área" lang="es" id="curFilterImg" style="height:26px;" />
							<span lang="es" id="curFilterLabel">Elementos del área</span>

							<span id="totalItemsLabel"><cfif isDefined("numItems")>&nbsp;<span class="label label-primary label-as-badge" id="totalItemsValue">#numItems#</span></cfif></span>

						</span>

					</div>

				</cfif>

				<!--- FIN INDICADOR FILTRADO ACTUAL --->


			</cfif>

			<!--- ---------------------------------------------- FIN DESPLEGABLE FILTRADO DE ELEMENTOS ---------------------------------------------- --->


			<cfif find("user",CGI.SCRIPT_NAME) IS 0 AND find("typologies",CGI.SCRIPT_NAME) IS 0><!--- No es el listado de usuarios ni el de tipologías --->

				<cfif NOT isDefined("itemTypeId")>

					<div class="btn-group pull-right">

						<button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false" title="Exportar contenido" lang="es">
							<i class="icon-circle-arrow-down" style="font-size:14px; line-height:23px;"></i> <span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#APPLICATION.htmlPath#/area_items_pdf.cfm?area=#area_id#" target="_blank" title="PDF" lang="es">PDF</a></li>
							<li><a href="#APPLICATION.htmlPath#/area_items_doc.cfm?area=#area_id#" target="_blank" title="PDF" lang="es">DOC (Word)</a></li>
							<li><a href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=exportAreaItemsDownload&area_id=#area_id#" onclick="return downloadFileLinked(this,event)" title="CSV" lang="es">CSV (Excel)</a></li>
						</ul>

					</div>

					<cfif NOT isDefined("URL.mode") OR URL.mode NEQ "list">

						<div class="btn-group pull-right">
							<a href="area_items.cfm?area=#area_id#&mode=list" class="btn btn-default btn-sm" id="listModeLink"><i class="icon-th-list" style="font-size:14px; line-height:23px;"></i> <span lang="es">Modo lista</span></a>
						</div>

					<cfelseif URL.mode EQ "list">

						<div class="btn-group pull-right">
							<a href="area_items.cfm?area=#area_id#&mode=" class="btn btn-default btn-sm"><i class="icon-th-large" style="font-size:14px; line-height:23px;"></i> <span lang="es">Modo completo</span></a>
						</div>

					</cfif>


				<cfelse><!--- itemTypeId --->


					<cfif itemTypeId IS 1 OR itemTypeId IS 7><!---Messages OR consultations--->

						<cfif NOT isDefined("URL.mode") OR URL.mode EQ "list">

							<div class="btn-group pull-right">
								<a href="#lCase(itemTypeNameP)#.cfm?area=#area_id#&mode=tree" class="btn btn-default btn-sm"><i class="icon-sitemap" style="font-size:14px; line-height:23px;"></i> <span lang="es">Modo árbol</span></a>
							</div>

						</cfif>

						<!---<span class="divider">&nbsp;</span>--->

					<cfelseif itemTypeId IS 6><!---Tasks--->

						<!---<div class="btn-group pull-right">
							<a href="#lCase(itemTypeNameP)#.cfm?area=#area_id#&mode=gantt" class="btn btn-default btn-sm"><i class="icon-tasks" style="font-size:14px; line-height:23px;"></i> <span lang="es">Diagrama de Gantt</span></a>
						</div>--->

						<!---<span class="divider">&nbsp;</span>--->

					</cfif>

					<cfif itemTypeId IS 1 OR itemTypeId IS 2 OR itemTypeId IS 4 OR itemTypeId IS 5><!--- Messages, Entries, News and events --->

						<cfif is_user_area_responsible IS true>

							<!--- getClient --->
							<cfinvoke component="#APPLICATION.htmlPath#/components/Client" method="getClient" returnvariable="clientQuery">
								<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
							</cfinvoke>

							<cfset url_return_page = "&return_page="&URLEncodedFormat("#APPLICATION.htmlPath#/#itemTypeNameP#.cfm?area=#area_id#")>

							<div class="btn-group pull-right">

								<a href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteAreaItems&area_id=#area_id#&itemTypeId=#itemTypeId#&moveToBin=#clientQuery.bin_enabled##url_return_page#" onclick="return confirmAction('eliminar');" class="btn btn-default btn-sm"><i class="icon-remove" style="font-size:14px; line-height:23px;"></i> <span lang="es">Eliminar todos <cfif itemTypeGender EQ "male">los<cfelse>las</cfif> #itemTypeNameEsP# del área</span></a>

							</div>

						</cfif>

						<div class="btn-group pull-right">
							<a href="area_items_import.cfm?area=#area_id#&itemTypeId=#itemTypeId#" class="btn btn-default btn-sm"><i class="fa fa-arrow-up" style="font-size:14px; line-height:23px;"></i> <span lang="es">Importar #itemTypeNameEsP#</span></a>
						</div>

					</cfif>

					<cfif isDefined("URL.mode") AND URL.mode EQ "tree">

						<div class="btn-group pull-right">
							<a href="#lCase(itemTypeNameP)#.cfm?area=#area_id#&mode=list" class="btn btn-default btn-sm"><i class="icon-th-list" style="font-size:14px; line-height:23px;"></i> <span lang="es">Modo lista</span></a>
						</div>

					</cfif>

					<cfif NOT isDefined("URL.mode") OR URL.mode EQ "list" OR URL.mode EQ "tree">

						<div class="btn-group pull-right">
							<a href="area_items.cfm?area=#area_id#&filter=#itemTypeName#&mode=" class="btn btn-default btn-sm"><i class="icon-th-large" style="font-size:14px; line-height:23px;"></i> <span lang="es">Modo completo</span></a>
						</div>

					</cfif>


				</cfif>


				<!---<div class="btn-group pull-right">
					<a href="users.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Usuarios del área" lang="es"><i class="icon-group" style="font-size:14px; line-height:23px;"></i></a>
				</div>--->


				<cfif app_version NEQ "mobile">

					<div class="btn-group pull-right">

						<cfif NOT isDefined("itemTypeId")>

							<cfif app_version NEQ "mobile">
							<a href="#APPLICATION.htmlPath#/area_items.cfm?area=#area_id#<cfif isDefined('URL.mode')>&mode=#URL.mode#</cfif>" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
							</cfif>

							<a href="#APPLICATION.htmlPath#/area_items_full.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Expandir contenido" lang="es" target="_blank"><i class="icon-external-link-sign" style="font-size:14px; line-height:23px;"></i></a>

						<cfelse>

							<cfif app_version NEQ "mobile">
								<div class="btn-group pull-right">
									<a href="#APPLICATION.htmlPath#/#lCase(itemTypeNameP)#.cfm?area=#area_id#<cfif isDefined('URL.mode')>&mode=#URL.mode#</cfif>" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
								</div>
							</cfif>

						</cfif>

					</div>

					<cfif NOT isDefined("itemTypeId")>

						<div class="btn-group pull-right">
							<a href="area_items.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>
						</div>

					<cfelse>

						<div class="btn-group pull-right">
							<a href="#lCase(itemTypeNameP)#.cfm?area=#area_id#&mode=list" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>
						</div>

					</cfif>

				</cfif>


			<cfelse><!--- Listado de usuarios o de tipologías --->

				<cfif isDefined("URL.mode") AND URL.mode EQ "list">

					<div class="btn-group pull-right">
						<a href="#CGI.SCRIPT_NAME#?area=#area_id#&mode=" class="btn btn-default btn-sm"><i class="icon-th-large" style="font-size:14px; line-height:23px;"></i> <span lang="es">Modo completo</span></a>
					</div>

				<cfelse>

					<div class="btn-group pull-right">
						<a href="#CGI.SCRIPT_NAME#?area=#area_id#&mode=list" class="btn btn-default btn-sm"><i class="icon-th-list" style="font-size:14px; line-height:23px;"></i> <span lang="es">Modo lista</span></a>
					</div>

				</cfif>

				<cfif app_version NEQ "mobile">
					<div class="btn-group pull-right">
						<a href="#CGI.SCRIPT_NAME#?area=#area_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>
					</div>
				</cfif>

			</cfif>



			<cfif APPLICATION.moduleWeb EQ true AND ( area_type EQ "web" OR area_type EQ "intranet" ) AND isDefined("webPathUrl")>

				<!---areaWebUrl--->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaWebPageFullUrl" returnvariable="areaPageFullUrl">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="name" value="#objectArea.name#">
					<cfinvokeargument name="remove_order" value="true">
					<cfinvokeargument name="path_url" value="#webPathUrl#">
					<cfinvokeargument name="path" value="#webPath#">
				</cfinvoke>

				<!---<span class="divider">&nbsp;</span>--->

				<div class="btn-group pull-right">

					<a href="#areaPageFullUrl#" class="btn btn-default btn-sm" title="Ver en #area_type#" lang="es" target="_blank"><i class="icon-globe" style="font-size:14px; line-height:23px;"></i></a>

					<cfif SESSION.client_abb EQ "hcs"><!--- Sólo disponible para el HCS porque requiere login en la web --->

						<!---areaWebUrl preview--->
						<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaWebPageFullUrl" returnvariable="areaPageFullUrlPreview">
							<cfinvokeargument name="area_id" value="#area_id#">
							<cfinvokeargument name="name" value="#objectArea.name#">
							<cfinvokeargument name="remove_order" value="true">
							<cfinvokeargument name="path_url" value="#webPathUrl#">
							<cfinvokeargument name="path" value="#webPath#">
							<cfinvokeargument name="preview" value="true">
						</cfinvoke>

						<a href="#areaPageFullUrlPreview#" class="btn btn-default btn-sm" title="Vista previa en #area_type# (incluye elementos no publicados)" lang="es" target="_blank"><i class="icon-eye-open" style="font-size:14px; line-height:23px;"></i></a>

					</cfif>

				</div>

			</cfif>

		</div><!--- END btn-toolbar --->

		</div><!--- END col-sm-12 --->

		</div><!--- END row --->

		</div><!---END container-fluid--->

	</nav><!--- END nav --->
</cfoutput>

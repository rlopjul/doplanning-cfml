<div class="row">

	<div><!--- class="col-sm-12" aquí no se mete col-sm-12 aposta porque añade un padding en las pantallas muy pequeñas --->

		<!---<nav class="navbar-default navbar-fixed-top" style="top:80px;padding-top:20px;">

			<div class="container">

				<div class="col-xs-offset-2 col-sm-offset-0 col-xs-2 col-sm-1">
					<cfoutput>
					<img src="#APPLICATION.htmlPath#/assets/v3/icons/tree.png" alt="Árbol" lang="es" />
					</cfoutput>
				</div>

				<div class="col-xs-8 col-sm-11">

					<div class="page-header" style="border-bottom-color:#254E65">
					  <h1 style="color:#254E65">Árbol de áreas</h1>
					</div>

				</div>

			</div>

		</nav>--->


		<nav class="navbar-default navbar-static-top" id="mainNavBarFixedTop"><!--- style="top:80px;padding-top:20px;"--->

			<button type="button" class="hamburger is-closed" data-toggle="offcanvas" aria-expanded="false" aria-controls="sidebar-wrapper" title="Menú principal" lang="es">
				<span class="hamb-top"></span>
				<span class="hamb-middle"></span>
				<span class="hamb-bottom"></span>
				<span class="sr-only" lang="es">Menú principal</span>
			</button>

			<cfoutput>


			<cfset head_col_1_class = "col-xs-offset-2 col-xs-10 col-sm-offset-1 col-sm-2 col-md-offset-0 col-md-1 app_page_head_icon">
		  	<cfset head_col_2_class = "col-xs-12 col-sm-9 col-md-11">

			<cfset bar_bg = "##DDDDDD">

			<cfsavecontent variable="page_head_content">

				<cfif find("last_items.cfm", CGI.SCRIPT_NAME) GT 0>

					<cfset bar_bg = "##E86C66">

					<div class="#head_col_1_class#">
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/home.png" alt="Lo último" lang="es" aria-hidden="true" />
					</div>

					<div class="#head_col_2_class#">

						<div class="page-header" style="border-bottom-color:##E4514B">
						  <h1 style="color:##E4514B" lang="es">Lo último</h1>
						</div>

					</div>


				<cfelseif find("tree.cfm", CGI.SCRIPT_NAME) GT 0>

					<cfset bar_bg = "##2F6380">

					<div class="#head_col_1_class#">
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/tree.png" alt="Árbol" lang="es" aria-hidden="true" />
					</div>

					<div class="#head_col_2_class#">

						<div class="page-header" style="border-bottom-color:##254E65">
						  <h1 style="color:##254E65" lang="es">Árbol de áreas</h1>
						</div>

					</div>

				<cfelseif find("search", CGI.SCRIPT_NAME) GT 0>

					<cfset bar_bg = "##4FBFB7">

					<div class="#head_col_1_class#">
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/search.png" alt="Búsqueda" lang="es" aria-hidden="true" />
					</div>

					<div class="#head_col_2_class#">

						<div class="page-header" style="border-bottom-color:##4FBFB7">
						  <h1 style="color:##36948C" lang="es">Búsqueda</h1>
						</div>

					</div>

				<cfelseif isDefined("objectItem") AND isDefined("objectItem.title") AND isDefined("objectItem.id") AND isNumeric(objectItem.id)><!--- Items --->

					<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItemPageHead">
						<cfinvokeargument name="item_id" value="#objectItem.id#"/>
						<cfinvokeargument name="item" value="#objectItem#">
						<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
						<cfinvokeargument name="itemTypeNameEs" value="#itemTypeNameEs#">
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfinvoke>


				<cfelseif isDefined("item") AND isDefined("item.title")><!--- Items --->

					<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItemPageHead">
						<cfinvokeargument name="item_id" value="#item.id#"/>
						<cfinvokeargument name="item" value="#item#">
						<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
						<cfinvokeargument name="itemTypeNameEs" value="#itemTypeNameEs#">
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfinvoke>

				<cfelseif isDefined("objectFile") AND isDefined("objectFile.id") AND isNumeric(objectFile.id)><!--- Files --->

					<div class="#head_col_1_class#">
						<a href="#APPLICATION.htmlPath#/#itemTypeName#.cfm?#itemTypeName#=#objectFile.id#&area=#area_id#">
							<!---<img src="#APPLICATION.htmlPath#/assets/v3/icons/#itemTypeName#.png" alt="#itemTypeNameEs#" title="#itemTypeNameEs#" />--->

							<cfif objectFile.file_type_id IS 1><!--- User file --->
								<img src="#APPLICATION.htmlPath#/assets/v3/icons/file.png" alt="Archivo" title="Archivo"/>
							<cfelseif objectFile.file_type_id IS 2><!--- Area file --->
								<cfif objectFile.locked IS true>
									<img src="#APPLICATION.htmlPath#/assets/v3/icons/file_area_locked.png" alt="Archivo del área bloqueado" title="Archivo del área bloqueado"/>
								<cfelse>
									<img src="#APPLICATION.htmlPath#/assets/v3/icons/file_area.png" alt="Archivo del área" title="Archivo del área"/>
								</cfif>
							<cfelseif objectFile.file_type_id IS 3>
								<cfif objectFile.locked IS true>
									<img src="#APPLICATION.htmlPath#/assets/v3/icons/file_edited_locked.png" alt="Archivo del área en edición" title="Archivo del área bloqueado"/>
								<cfelse>
									<img src="#APPLICATION.htmlPath#/assets/v3/icons/file_edited.png" alt="Archivo del área en edición" title="Archivo del área en edición"/>
								</cfif>
							</cfif>
						</a>
					</div>

					<div class="#head_col_2_class#">

						<div class="page-header" style="border-bottom-color:##019ED3">

						 	<div class="row row_page_head_title">
								<div class="col-sm-10">
									<h1 style="color:##009ED2;">#objectFile.name#</h1>
								</div>
								<div class="col-sm-2">
									<a href="area_items.cfm?area=#area_id####itemTypeName##objectFile.id#" class="btn btn-sm btn-info pull-right"><img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/area_small_white.png" alt="Área" lang="es"/> <span lang="es">Ver en área</span></a>
								</div>
							</div>

						</div>

					</div>

				<cfelseif isDefined("view") AND isDefined("view.title") AND isNumeric(view.id)><!--- Views --->

					<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItemPageHead">
						<cfinvokeargument name="item_id" value="#view.id#"/>
						<cfinvokeargument name="item" value="#view#">
						<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
						<cfinvokeargument name="itemTypeNameEs" value="#itemTypeNameEs#">
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfinvoke>

				<cfelseif isDefined("table_id") AND isDefined("table.title")><!--- Tables --->

					<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItemPageHead">
						<cfinvokeargument name="item_id" value="#table_id#"/>
						<cfinvokeargument name="item" value="#table#">
						<cfinvokeargument name="itemTypeName" value="#tableTypeName#">
						<cfinvokeargument name="itemTypeNameEs" value="#tableTypeNameEs#">
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfinvoke>

				<cfelseif isDefined("area_id") AND isDefined("area_name")><!--- Areas --->

					<cfif NOT isDefined("area_type") OR area_type EQ "">
						<cfset bar_bg = "##019ED3">
					<cfelse>
						<cfset bar_bg = "##DDDDDD">
					</cfif>

					<div class="#head_col_1_class#">

						<!---<cfif area_allowed EQ true>--->
							<cfif area_type EQ "">
								<cfset area_image = "icons_#APPLICATION.identifier#/area.png">
							<cfelseif area_type EQ "intranet">
								<cfset area_image = "icons_#APPLICATION.identifier#/area_intranet.png">
							<cfelse>
								<cfset area_image = "icons_#APPLICATION.identifier#/area_web.png">
							</cfif>
						<!---<cfelse>
							<cfif area_type EQ "">
								<cfset area_image = "icons_#APPLICATION.identifier#/area_disabled.png">
							<cfelse>
								<cfset area_image = "icons_#APPLICATION.identifier#/area_web_disabled.png">
							</cfif>
						</cfif>--->


						<img src="#APPLICATION.htmlPath#/assets/v3/#area_image#" alt="Area" aria-hidden="true" style="display:inline">


					</div>

					<div class="#head_col_2_class#">

						<div class="page-header" style="border-bottom-color:##009ED2">

							<h1 style="color:##009ED2">#area_name#

							  <cfif isDefined("objectArea")>
										<cfset areaInfoEnabled = true>
								  	<small style="float:right">
										<a class="navbar-link" data-toggle="collapse" href="##areaInfo" aria-expanded="false" aria-controls="areaInfo" lang="es" title="Mostrar información del área" id="openAreaImg">
											<i class="icon-info-sign more_info_img" <!---onclick="openAreaInfo()"--->></i>
										</a>
										<a class="navbar-link" data-toggle="collapse" href="##areaInfo" aria-expanded="false" aria-controls="areaInfo" lang="es" title="Ocultar información del área" id="closeAreaImg" style="display:none;">
											<i class="icon-info-sign more_info_img" <!---onclick="openAreaInfo()"--->></i>
										</a>
									</small>
								</cfif>

							</h1>

						</div>

					</div>


				<cfelseif find("bin.cfm", CGI.SCRIPT_NAME) GT 0><!--- Bin --->

					<cfset bar_bg = "##EAD144">

					<!---<div style="width:56px;height:54px;background:##EAD144"></div>--->

					<div class="#head_col_1_class#">
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/bin.png" alt="Papelera" lang="es" aria-hidden="true" />
					</div>


					<div class="#head_col_2_class#">

						<div class="page-header" style="border-bottom-color:##EAD144">
							<h1 style="color:##EAD144" lang="es">Papelera</h1>
						</div>

					</div>

				<cfelseif find("preferences", CGI.SCRIPT_NAME) GT 0><!--- Preferences --->

					<cfset bar_bg = "##4FBFB7">

					<div class="#head_col_1_class#">
						<!---<div style="width:56px;height:54px;background:##82D0CA"></div>--->
						<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_preferences.png" alt="Usuario" lang="es" aria-hidden="true" />
					</div>

					<div class="#head_col_2_class#">

						<div class="page-header" style="border-bottom-color:##82D0CA">
							<cfif find("preferences_user_data.cfm", CGI.SCRIPT_NAME) GT 0>
								<h1 style="color:##82D0CA" lang="es">Datos personales</h1>
							<cfelseif find("preferences_alerts.cfm", CGI.SCRIPT_NAME) GT 0>
								<h1 style="color:##82D0CA" lang="es">Preferencias de notificaciones</h1>
							<cfelse><!--- preferences.cfm --->
								<h1 style="color:##82D0CA" lang="es">Preferencias </h1>
							</cfif>
						</div>

					</div>

				<cfelseif isDefined("URL.user")><!--- User --->

					<div class="#head_col_1_class#">
						<div style="width:56px;height:54px;background:##DDDDDD"></div>
					</div>

					<div class="#head_col_2_class#">

						<div class="page-header" style="border-bottom-color:##009ED2">

							<h1 style="color:##009ED2" lang="es">Usuario</h1>

						</div>

					</div>

				</cfif>

			</cfsavecontent>


		  	<div class="container-fluid" style="background-color:#bar_bg#;height:30px;">

				<div class="row">

					<div class="col-sm-12">

						 <div class="container">

						 	<div class="row">

						 		<div class="col-sm-12" id="appClientTitle">

						 			<span class="visible-xs" style="<cfif bar_bg EQ '##DDDDDD'>color:##777777<cfelse>color:##FFF</cfif>;">#SESSION.client_app_title#</span>

						 			<span class="hidden-xs" style="<cfif bar_bg EQ '##DDDDDD'>color:##777777<cfelse>color:##FFF</cfif>;">#SESSION.client_app_title#</span>

						 		</div>

						 	</div>

						 </div>

					</div>

				</div>

		  	</div>

		  	<div class="container" style="padding-top:20px;">

		  		<div class="row">

		  			#page_head_content#

				</div><!--- END row --->

			</div><!--- END container --->

		</cfoutput>

		</nav>

	</div>

</div>

<script>

	$(document).ready( function(){

		<!--- Set browser new URL --->
		<cfoutput>

		<cfif isDefined("rewriteCurUrlPage")>
			var curPageUrl = "#rewriteCurUrlPage#";
			History.replaceState(History.getState().data, History.options.initialTitle, curPageUrl);
		<cfelseif NOT isDefined("URL.abb") AND APPLICATION.dpUrlRewrite IS true>

			<cfif len(CGI.QUERY_STRING) GT 0>
				<cfset newQueryString = "?#CGI.QUERY_STRING#&abb=#SESSION.client_abb#">
			<cfelse>
				<cfset newQueryString = "?abb=#SESSION.client_abb#">
			</cfif>

			var urlHash = "";
			if(window.location.hash) {
				urlHash = window.location.hash;
			}

			History.replaceState(History.getState().data, History.options.initialTitle, "#newQueryString#"+urlHash);

		</cfif>

		</cfoutput>

	});

</script>

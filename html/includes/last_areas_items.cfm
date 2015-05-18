<!---<cfset app_version = "html2">
<cfset return_path = "#APPLICATION.htmlPath#/iframes/">--->

<cfinclude template="#APPLICATION.htmlPath#/includes/app_version.cfm">


 
<script>

	$(function() {

		$('#lastItemsHead').affix({
	      	offset: {
	       		top: 1 <!--- top 1 para corregir un fallo de que al hacer clic sobre la barra se aplica affix ---> 
	      	}
		});	
		
		$('#lastItemsHead').on('affix.bs.affix', function () {
		     $('#lastItemsHead').css("top", $('#mainNavBarFixedTop').height());
		});

	});

</script>



<cfif isDefined("URL.limit")>
	<cfset limit_to = URL.limit>
<cfelse>
	<cfset limit_to = 20>
</cfif>

<div class="row">

<nav class="navbar-default" id="lastItemsHead">

	<div class="container">

		<div class="row">

	<cfif app_version EQ "mobile">

		<cfoutput>

		<!--- ------------------------------------------------ DESPLEGABLE FILTRADO DE ELEMENTOS ---------------------------------------------- --->

		<cfinclude template="#APPLICATION.htmlPath#/includes/isotope_scripts.cfm">

		<div class="col-sm-10">

			<div class="btn-toolbar" style="padding-bottom:10px;" role="toolbar">

				<div class="btn-group" id="filterAreaElements">

					<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false" title="Filtrar" lang="es">

						<i class="icon-filter" style="color:##EAD142"></i>
							
						<span lang="es">VER</span> <span class="caret"></span>

					</button>

					<ul class="dropdown-menu" role="menu"> <!---dropdown-menu-right--->

						<li>	

						 	<div class="row" style="width:450px;">

				               	<ul class="list-unstyled col-md-6">   

									<li>

										<!---
										<cfif find("user",CGI.SCRIPT_NAME) GT 0><!--- No está en el listado de todos los elementos, está en listado de un tipo de elemento --->
											<a href="area_items.cfm?area=#area_id#">
										<cfelseif isDefined("itemTypeId") OR isDefined("URL.mode") AND URL.mode EQ "list">
											<a href="area_items.cfm?area=#area_id#&mode=list">
										<cfelse><!--- Está en el listado desarrollado de todos los elementos --->
											<a onclick="setItemsFilter('*')">
										</cfif>--->
										<cfif isDefined("URL.filter") AND ( filter EQ "area" OR filter EQ "user" )><!---Listado de areas o usuarios--->
											<a href="#CGI.SCRIPT_NAME#?limit=#limit_to#">
										<cfelse>
											<a onclick="setItemsFilter('*')">		
										</cfif>
												<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/area.png" title="Todos los elementos de área" alt="Todos los elementos de áreas" lang="es" style="height:35px;" />
												<span lang="es">Elementos de áreas</span>
											</a>

									</li>


							    	<cfloop array="#itemTypesArray#" index="curItemTypeId">


							    		<cfif curItemTypeId NEQ 13 AND ( curItemTypeId NEQ 7 OR APPLICATION.moduleConsultations IS true ) AND ( curItemTypeId NEQ 13 OR APPLICATION.moduleForms IS true ) AND ( curItemTypeId NEQ 8 OR APPLICATION.modulePubMedComments IS true ) AND ( curItemTypeId NEQ 20 OR APPLICATION.moduleDPDocuments IS true ) AND ( (curItemTypeId NEQ 2 AND curItemTypeId NEQ 4 AND curItemTypeId NEQ 9) OR APPLICATION.moduleWeb EQ true )>

											<li>
												
												<!---<a href="#itemTypesStruct[curItemTypeId].namePlural#.cfm?area=#area_id#" title="#itemTypesStruct[curItemTypeId].labelPlural#" lang="es">--->

												<cfif isDefined("URL.filter") AND ( filter EQ "area" OR filter EQ "user" )><!---Listado de areas o usuarios--->

													<a href="#CGI.SCRIPT_NAME#?filter=#itemTypesStruct[curItemTypeId].name#&limit=#limit_to#" title="#itemTypesStruct[curItemTypeId].labelPlural#" lang="es">

												<cfelse><!--- Está en el listado desarrollado de todos los elementos --->

													<a onclick="setItemsFilter('#itemTypesStruct[curItemTypeId].name#')" title="#itemTypesStruct[curItemTypeId].labelPlural#" lang="es">

						    					</cfif>
													
													<img src="#APPLICATION.htmlPath#/assets/v3/icons/#itemTypesStruct[curItemTypeId].name#.png" alt="#itemTypesStruct[curItemTypeId].labelPlural#" lang="es" style="height:35px"/>
													

													<span lang="es">#itemTypesStruct[curItemTypeId].labelPlural#</span>
												</a>
												
											</li>

										</cfif>

										<cfif curItemTypeId EQ 6><!--- Cierra la primera columna --->
											
											</ul><!--- END list-unstyled col-md-6 --->
											<ul class="list-unstyled col-md-6">   

										</cfif>

									</cfloop>

									<li>
										<a href="#CGI.SCRIPT_NAME#?filter=area&limit=#limit_to#" title="Áreas" lang="es">
											<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/area_small.png" alt="Areas" lang="es" style="height:35px"/>
											<span lang="es">Áreas</span>
										</a>
									 
									</li>
									
									<li> 
									
										<a href="#CGI.SCRIPT_NAME#?filter=user&limit=#limit_to#" title="Usuarios" lang="es">
											<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/users.png" alt="Usuarios" lang="es" style="height:35px"/>
											<span lang="es">Usuarios</span>
										</a>

									</li>

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
										
									<!---<li>
										<!---Users--->
										<a href="users.cfm?area=#area_id#" lang="es">
											<!---<i class="icon-group" style="margin-left:2px;margin-right:2px;"></i>--->
											<img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/users.png" title="Usuarios del área" alt="Usuarios del área" lang="es" style="height:35px"/>
											<span lang="es">Usuarios</span>
										</a>
									</li>---->
									

								</ul><!--- END list-unstyled col-md-6 --->

			                </div><!--- END row --->

						</li>

					</ul><!--- END dropdown-menu --->

				</div><!--- END btn-group --->

				

				<!---INDICADOR FILTRADO ACTUAL--->

				<div class="btn-group">

					<span class="btn btn-link" style="cursor:default;color:##000000">

						<cfif isDefined("URL.filter") AND filter EQ "area">
							<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/area_small.png" title="Todos los elementos del área" alt="Todos los elementos del área" lang="es" id="curFilterImg" style="height:26px;" />
							<span lang="es" id="curFilterLabel">Areas con actividad reciente</span>
						<cfelseif isDefined("URL.filter") AND filter EQ "user">
							<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/users.png" title="Todos los elementos del área" alt="Todos los elementos del área" lang="es" id="curFilterImg" style="height:26px;" />
							<span lang="es" id="curFilterLabel">Usuarios con actividad reciente</span>
						<cfelse>
							<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/area.png" title="Todos los elementos del área" alt="Todos los elementos del área" lang="es" id="curFilterImg" style="height:26px;" />
							<span lang="es" id="curFilterLabel">Elementos de área</span>
						</cfif>

					</span>

				</div>

				<!--- FIN INDICADOR FILTRADO ACTUAL --->

			</div><!--- END btn-toolbar --->

		</div><!--- END col-sm-10 --->

		</cfoutput>

		<!--- ---------------------------------------------- FIN DESPLEGABLE FILTRADO DE ELEMENTOS ---------------------------------------------- --->


		<!--- ---------------------------------------------- DESPLEGABLE LÍMITE DE ELEMENTOS ---------------------------------------------------- --->

		<div class="col-sm-2">
			
			<form class="form-horizontal">
				<div class="form-group">
					<label class="col-xs-2 col-sm-4 col-lg-offset-1 control-label" for="limit" lang="es">Mostrar</label>

					<div class="col-xs-3 col-sm-8 col-lg-6">
						<select name="limit" id="limit" class="form-control" onchange="loadHome();">
							<option value="20" <cfif limit_to IS 20>selected="selected"</cfif>>20</option>
							<option value="50" <cfif limit_to IS 50>selected="selected"</cfif>>50</option>
							<option value="100" <cfif limit_to IS 100>selected="selected"</cfif>>100</option>
							<option value="500" <cfif limit_to IS 500>selected="selected"</cfif>>500</option>
						</select>
					</div>
				</div>		
			</form>

		</div>

		<!--- ---------------------------------------------- FIN DESPLEGABLE LÍMITE DE ELEMENTOS ------------------------------------------------ --->


	<cfelse>

		<div class="col-sm-12">

			<div class="navbar navbar-default navbar-static-top">
				<div class="container-fluid">
					<span class="navbar-brand" lang="es">Lo último</span>

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
						<cfif rightContent IS true>
							<button type="button" class="btn btn-default btn-sm navbar-btn" onclick="loadHome();" title="Actualizar" lang="es" style="margin-bottom:0;margin-top:0"><i class="icon-refresh icon-white"></i></button>
						</cfif>
						
					</form>

				</div>
			</div>

		</div>

	</cfif>

</div><!--- END row --->

</div><!--- END container --->

</nav><!--- END nav --->

</div><!--- END row --->


<div class="row">
	<div class="col-sm-12" id="lastItemsContainer" >


<cfif isDefined("URL.filter") AND URL.filter EQ "area">
	
	<!--- getLastUsedAreas --->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getLastUsedAreas" returnvariable="getAllItemsResult">
		<cfif isDefined("limit_to") AND isNumeric(limit_to)>
		<cfinvokeargument name="limit" value="#limit_to#">
		</cfif>
	</cfinvoke>

<cfelseif isDefined("URL.filter") AND URL.filter EQ "user">

	<!--- getLastActivityUsers --->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getLastActivityUsers" returnvariable="getAllItemsResult">
		<cfif isDefined("limit_to") AND isNumeric(limit_to)>
		<cfinvokeargument name="limit" value="#limit_to#">
		</cfif>
	</cfinvoke>

<cfelse>

	<!--- All items --->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllItems" returnvariable="getAllItemsResult">
		<cfif isDefined("limit_to") AND isNumeric(limit_to)>
		<cfinvokeargument name="limit" value="#limit_to#">
		</cfif>
		<cfinvokeargument name="full_content" value="true">
		<cfinvokeargument name="withArea" value="true">
	</cfinvoke>

</cfif>


<cfset itemsQuery = getAllItemsResult.query>

<!---<cfdump var="#itemsQuery#">--->


<cfif itemsQuery.recordCount GT 0>

	<cfinclude template="#APPLICATION.htmlPath#/includes/app_version.cfm">

	<cfif isDefined("URL.filter") AND URL.filter EQ "area">

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="loggedUser">
			<cfinvokeargument name="user_id" value="#SESSION.user_id#">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="outputAreasFullList">
			<cfinvokeargument name="areasQuery" value="#itemsQuery#">
			<cfinvokeargument name="loggedUser" value="#loggedUser#">
		</cfinvoke>

	<cfelseif isDefined("URL.filter") AND URL.filter EQ "user">

		<cfset usersArray = getAllItemsResult.users>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersFullList">
			<cfinvokeargument name="usersArray" value="#usersArray#">
			<!---<cfinvokeargument name="itemTypesStruct" value="#itemTypesStruct#">--->
		</cfinvoke>

	<cfelse>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsFullList">
			<cfinvokeargument name="itemsQuery" value="#itemsQuery#">
			<cfinvokeargument name="return_path" value="#APPLICATION.htmlPath#/iframes/">
			<cfinvokeargument name="showLastUpdate" value="true">
			<cfinvokeargument name="app_version" value="#app_version#">
		</cfinvoke>

	</cfif>

<cfelse>		

	<cfoutput>
	<span lang="es">No hay elementos</span>
	</cfoutput>

	<div class="alert alert-info" style="margin-top:10px;"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Accede a las áreas de la organización a través de la pestaña</span> <a onclick="showTreeTab()" style="cursor:pointer" lang="es">Árbol</a> <span lang="es">para crear nuevos elementos</span></div>

</cfif>


	</div>
</div>
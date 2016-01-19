<!---Copyright Era7 Information Technologies 2007-2015

	Date of file creation: 30-09-2008
	File created by: alucena

--->
<cfcomponent output="false">

	<cfset component = "Area">
	<cfset request_component = "AreaManager">


	<!--- ----------------------------------- getMainTree -------------------------------------- --->

	<cffunction name="getMainTree" output="false" returntype="struct" access="public">
		<cfargument name="get_user_id" type="numeric" required="false">

		<cfset var method = "getMainTree">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getMainTree" returnvariable="response">
				<cfinvokeargument name="get_user_id" value="#arguments.get_user_id#">
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ----------------------------------- getMainTreeAdmin -------------------------------------- --->

	<cffunction name="getMainTreeAdmin" output="false" returntype="struct" access="public">
		<cfargument name="get_user_id" type="numeric" required="false">

		<cfset var method = "getMainTreeAdmin">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getMainTreeAdmin" returnvariable="response">
				<cfinvokeargument name="get_user_id" value="#arguments.get_user_id#">
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ----------------------------------- getAreaContent -------------------------------------- --->

	<cffunction name="getAreaContent" returntype="xml" output="false" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="allowed" type="boolean" required="yes">
		<cfargument name="areaType" type="string" required="no" default="">

		<cfset var method = "getAreaContent">

		<cfset var xmlResponse = "">
		<cfset var response = "">

		<cftry>

			<!---checkAreaAccess--->
			<!---No se chequea porque se tiene que poder acceder a las areas que hay dentro por si tenemos acceso a alguna--->

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaContent" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="allowed" value="#arguments.allowed#">
				<cfinvokeargument name="areaType" value="#arguments.areaType#">

				<cfinvokeargument name="withSubAreas" value="true">
				<cfinvokeargument name="withSubSubAreas" value="false">
			</cfinvoke>

			<cfxml variable="xmlResponse"><cfoutput>#response#</cfoutput></cfxml>


			<cfcatch>

				<!---Esto está puesto aquí para intentar detectar un error que daba--->
				<!---<cfinvoke component="#APPLICATION.componentsPath#/EmailManager" method="sendEmail">
					<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
					<cfinvokeargument name="to" value="alucena@era7.com">
					<cfinvokeargument name="bcc" value="">
					<cfinvokeargument name="subject" value="Error en #APPLICATION.title# getAreaContent">
					<cfinvokeargument name="content" value="#arguments.area_id# #response#">
					<cfinvokeargument name="foot_content" value="">
				</cfinvoke>--->

				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn xmlResponse>

	</cffunction>


	<!--- ----------------------------------- getParentAreaId -------------------------------------- --->

	<!---<cffunction name="getParentAreaId" returntype="numeric" access="public">
		<cfargument name="area_id" type="numeric" required="true">

		<cfset var method = "getParentAreaId">

		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">

		<cfset var parent_area_id = "">

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/#request_component#" method="#method#" returnvariable="parent_area_id">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn parent_area_id>

	</cffunction>--->

	<!--- ----------------------------------- getArea ------------------------------------- --->

	<!---Este método NO hay que usarlo en páginas en las que su contenido se cague con JavaScript (páginas de html_content) porque si hay un error este método redirige a otra página. En esas páginas hay que obtener el Area directamente del AreaManager y comprobar si result es true o false para ver si hay error y mostrarlo correctamente--->

	<cffunction name="getArea" output="false" returntype="query" access="public">
		<cfargument name="area_id" type="numeric" required="true">

		<cfset var method = "getArea">

		<cfset var objectArea = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getArea" returnvariable="objectArea">
				<cfinvokeargument name="get_area_id" value="#arguments.area_id#">
				<cfinvokeargument name="return_type" value="query">
			</cfinvoke>

			<cfcatch>
				<!--- En las páginas en las que se carga con JavaScript el contenido no debe haber redirecciones a otras páginas
				EN EL CASO DE ESTAS PÁGINAS NO HAY QUE USAR ESTE MÉTODO, HAY QUE USAR DIRECTAMENTE getArea de AreaManager y comprobar en el resultado si es true o false para mostrar si hay error--->
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn objectArea>

	</cffunction>


	<!--- ----------------------------------- canUserAccessToArea ------------------------------------- --->

	<cffunction name="canUserAccessToArea" output="false" returntype="boolean" access="public">
		<cfargument name="area_id" type="numeric" required="true">

		<cfset var method = "canUserAccessToArea">

		<cfset var access_result = false>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="canUserAccessToArea" returnvariable="access_result">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn access_result>

	</cffunction>


	<!--- ----------------------------------- checkAreaAdminAccess ------------------------------------- --->

	<cffunction name="checkAreaAdminAccess" output="false" returntype="void" access="public">
		<cfargument name="area_id" type="numeric" required="true">

		<cfset var method = "checkAreaAdminAccess">

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAreaAdminAccess" returnvariable="access_result">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

	</cffunction>


	<!--- ----------------------------------- isUserAreaResponsible ------------------------------------- --->

	<cffunction name="isUserAreaResponsible" output="false" returntype="boolean" access="public">
		<cfargument name="area_id" type="numeric" required="true">

		<cfset var method = "isUserAreaResponsible">

		<cfset var access_result = false>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="isUserAreaResponsible" returnvariable="access_result">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn access_result>

	</cffunction>


	<!--- ----------------------------------- getAreaType ------------------------------------- --->

	<cffunction name="getAreaType" output="false" returntype="string" access="public">
		<cfargument name="area_id" type="numeric" required="yes">

		<cfset var method = "getAreaType">

		<cfset var areaType = "">

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="#method#" returnvariable="areaTypeResult">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn areaTypeResult.areaType>

	</cffunction>


	<!--- ----------------------------------- getAreaTypeWeb ------------------------------------- --->

	<cffunction name="getAreaTypeWeb" output="false" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">

		<cfset var method = "getAreaTypeWeb">

		<cfset var response = "">

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="#method#" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ----------------------------------- getAreaFiles ------------------------------------- --->

	<cffunction name="getAreaFiles" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">

		<cfset var method = "getAreaFiles">

		<cfset var response = structNew()>

		<cftry>

			<!---<cfsavecontent variable="request_parameters">
				<cfoutput>
					<area id="#arguments.area_id#"/>
				</cfoutput>
			</cfsavecontent>

			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>--->

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaFiles" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>

	<!--- ----------------------------------- getAreaMembers ------------------------------------- --->

	<cffunction name="getAreaMembers" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="order_by" type="string" required="false" default="family_name">
		<cfargument name="order_type" type="string" required="false" default="asc">

		<cfset var method = "getAreaMembers">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaMembers" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="order_by" value="#arguments.order_by#"/>
				<cfinvokeargument name="order_type" value="#arguments.order_type#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>


	</cffunction>


	<!--- ----------------------------------- createArea -------------------------------------- --->

	<cffunction name="createArea" output="false" returntype="struct" returnformat="json" access="remote">

		<cfset var method = "createArea">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="createArea" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "Área creada">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ----------------------------------- importAreas -------------------------------------- --->

	<cffunction name="importAreas" output="false" returntype="string" returnformat="plain" access="remote">
		<!---NO se puede usar returnformat="json" porque da problemas con la subida de archivos en IE
		Es necesario usar returnformat="plain" para que devuelva texto plano y serializeJSON para generar el JSON de respuesta
		https://github.com/blueimp/jQuery-File-Upload/wiki/Setup#content-type-negotiation--->

		<cfset var method = "importAreas">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="importAreas" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "#response.areasCount# áreas importadas">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>

		<!---<cfoutput>#serializeJSON(response)#</cfoutput>--->

		<cfreturn serializeJSON(response)>

	</cffunction>


	<!--- ----------------------------------- updateAreaImage -------------------------------------- --->

	<cffunction name="updateAreaImage" output="false" returntype="string" returnformat="plain" access="remote">
		<!---NO se puede usar returnformat="json" porque da problemas con la subida de archivos en IE
		Es necesario usar returnformat="plain" para que devuelva texto plano y serializeJSON para generar el JSON de respuesta
		https://github.com/blueimp/jQuery-File-Upload/wiki/Setup#content-type-negotiation--->

		<cfargument name="area_id" type="numeric" required="true"/>
		<cfargument name="files" type="array" required="false"/>

		<cfset var method = "updateAreaImage">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="updateArea" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "Imagen de área modificada">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn serializeJSON(response)>

	</cffunction>


	<!--- ----------------------------------- updateArea -------------------------------------- --->

	<cffunction name="updateArea" output="false" returntype="struct" returnformat="json" access="remote">
		<cfargument name="area_id" type="numeric" required="true"/>

		<cfset var method = "updateArea">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="updateArea" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "Área modificada">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ----------------------------------- moveArea -------------------------------------- --->

	<cffunction name="moveArea" output="false" returntype="struct" returnformat="json" access="remote">
		<cfargument name="area_id" type="numeric" required="true"/>
		<cfargument name="parent_id" type="numeric" required="true"/>

		<cfset var method = "moveArea">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="moveArea" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "Área movida">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- deleteAreaImage --->

	<cffunction name="deleteAreaImage" output="false" returntype="struct" returnformat="json" access="remote">
		<cfargument name="area_id" type="numeric" required="true">

		<cfset var method = "deleteAreaImage">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="deleteAreaImage" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "Imagen eliminada.">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>




	<!--- ----------------------------------- deleteArea -------------------------------------- --->

	<cffunction name="deleteArea" output="false" returntype="struct" returnformat="json" access="remote">
		<cfargument name="area_id" type="numeric" required="true"/>

		<cfset var method = "deleteArea">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="deleteArea" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "Área eliminada">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ----------------------------------- outputSubAreasSelect ------------------------------------- --->

	<cffunction name="outputSubAreasSelect" output="true" access="public" returntype="void">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="selected_areas_ids" type="string" required="false">
		<cfargument name="level" type="numeric" required="false" default="1">
		<cfargument name="recursive" type="boolean" required="false" default="false">

		<cfset var method = "outputSubAreasSelect">

		<cftry>

			<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaHtml" method="outputSubAreasSelect">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="selected_areas_ids" value="#arguments.selected_areas_ids#">
				<cfinvokeargument name="level" value="#arguments.level#">
				<cfinvokeargument name="recursive" value="#arguments.recursive#">

				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirect.cfm">
			</cfcatch>

		</cftry>

	</cffunction>


	<!--- ----------------------- GET LAST USED AREAS -------------------------------- --->

	<cffunction name="getLastUsedAreas" returntype="struct" access="public">
		<cfargument name="limit" type="numeric" required="false">

		<cfset var method = "getLastUsedAreas">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getLastUsedAreas" returnvariable="response">
				<cfinvokeargument name="limit" value="#arguments.limit#">
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- outputAreasFullList --->

	<cffunction name="outputAreasFullList" returntype="void" output="true" access="public">
		<cfargument name="areasQuery" type="query" required="true">
		<cfargument name="loggedUser" type="query" required="false">
		<cfargument name="small" type="boolean" required="false" default="false">

		<cfset var method = "outputAreasFullList">

		<cfset var area_path = "">

		<cftry>

			<cfoutput>

			<cfloop query="areasQuery">
				<div class="row">
					<div class="col-sm-12">

						<div class="panel panel-default">
						  	<div class="panel-body">

							   	<div class="row">

							   		<div class="col-xs-12">

										<cfif arguments.small EQ true>
											<h5>
										<cfelse>
											<h4>
										</cfif>

											#areasQuery.area_name#

											<cfif isDefined("areasQuery.last_update_date")>

												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

												<cfinvoke component="#APPLICATION.componentsPath#/DateManager" method="timestampToString" returnvariable="stringLastDate">
													<cfinvokeargument name="timestamp_date" value="#areasQuery.last_update_date#">
												</cfinvoke>
												<cfset spacePosLast = findOneOf(" ", stringLastDate)>
												<small class="text_date">
													#left(stringLastDate, spacePosLast)#
												</small>&nbsp;&nbsp;&nbsp;
												<cfif spacePosLast GT 0>
													<small class="text_hour">#right(stringLastDate, len(stringLastDate)-spacePosLast)#</small>
												</cfif>

											</cfif>

										<cfif arguments.small EQ true>
											</h5>
										<cfelse>
											</h4>
										</cfif>


										<cfif loggedUser.internal_user IS true>

											<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaPath" returnvariable="area_path">
												<cfinvokeargument name="area_id" value="#area_id#">
												<cfinvokeargument name="separator" value=" > ">
												<cfinvokeargument name="cur_area_link_class" value="current_area">

												<cfinvokeargument name="with_base_link" value="area_items.cfm?area="/>
											</cfinvoke>

										<cfelse>

											<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getHighestAreaUserAssociated" returnvariable="getHighestAreaResponse">
												<cfinvokeargument name="area_id" value="#area_id#"/>
												<cfinvokeargument name="user_id" value="#SESSION.user_id#"/>
												<cfinvokeargument name="userType" value="users"/>
											</cfinvoke>

											<!---<cfif getHighestAreaResponse.result IS true>--->

												<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaPath" returnvariable="area_path">
													<cfinvokeargument name="area_id" value="#area_id#">
													<cfinvokeargument name="separator" value=" > ">
													<cfinvokeargument name="from_area_id" value="#getHighestAreaResponse.highest_area_id#">
													<cfinvokeargument name="include_from_area" value="true">
													<cfinvokeargument name="cur_area_link_class" value="current_area">

													<cfinvokeargument name="with_base_link" value="area_items.cfm?area="/>
												</cfinvoke>

											<!---</cfif>--->

										</cfif>

									</div>



								</div><!--- END row --->

								<div class="row">

									<cfif arguments.small EQ true>

										<div class="col-xs-10">

									<cfelse>

										<div class="col-xs-12">

									</cfif>

										<p style="<cfif arguments.small EQ true>font-size:12px;<cfelse>font-size:15px;</cfif>">#area_path#</p>

									</div>

									<cfif arguments.small EQ true>

										<div class="col-xs-2">

											<div class="pull-right">
												<a href="area_items.cfm?area=#areasQuery.area_id#" class="btn btn-sm btn-info" title="Ir al área"><span lang="es"><img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/area_small_white.png" alt="Area" title="Ver área"> Ir al área</span></a>
											</div>

										</div>

									</cfif>

								</div>

								<cfif arguments.small EQ false>
									<div class="row">

										<div class="col-sm-12">

											<div class="pull-right">

												<a href="area_items.cfm?area=#areasQuery.area_id#" class="btn btn-sm btn-info" title="Ir al área"><span lang="es"><img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/area_small_white.png" alt="Area" title="Ver área"> Ir al área</span></a>

											</div>

										</div>

									</div><!--- END row --->
								</cfif>

							</div><!--- END panel-body --->
						</div><!--- END panel panel-default --->

					</div><!--- END col --->
				</div><!---END row item container--->
			</cfloop>


			<!---
			<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/css/bootstrap-modal-bs3patch.css" rel="stylesheet">
			<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/css/bootstrap-modal.css" rel="stylesheet">

			<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/js/bootstrap-modal.js"></script>
			<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/js/bootstrap-modalmanager.js"></script>

			<script>
				<!---To enable the loading spinner in Bootstrap 3--->
				$.fn.modal.defaults.spinner = $.fn.modalmanager.defaults.spinner =
			    '<div class="loading-spinner" style="width: 200px; margin-left: -100px;">' +
			        '<div class="progress progress-striped active">' +
			            '<div class="progress-bar" style="width: 100%;"></div>' +
			        '</div>' +
			    '</div>';
			    <!--- To set modal max height --->
				$.fn.modal.defaults.maxHeight = function(){
				    return $(window).height() - 170;
				}
			</script>

			<script>
				// Modal
				var $modal = null;

				function loadAreaTree(areaId){

					$('body').modalmanager('loading');

					var noCacheNumber = generateRandom();

					var url = "html_content/tree_modal.cfm?area="+areaId;

					$modal.load(url, '', function(){
					  $modal.modal({width:740, backdrop:'static'});/*680*/
					});
				}

				$(document).ready(function () {

					// Modal
					$modal = $('#ajax-modal');

				});
			</script>

			<!--- Modal Window --->
			<div id="ajax-modal" class="modal container fade" tabindex="-1"></div><!---hide funcionaba en bs2--->--->

			</cfoutput>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

	</cffunction>



	<!--- getAreas --->

	<cffunction name="getAreas" returntype="struct" output="false" access="public">
		<cfargument name="search_text" type="string" required="true">
		<!---<cfargument name="order_by" type="string" required="false" default="name">
		<cfargument name="order_type" type="string" required="false" default="asc">--->
		<cfargument name="limit" type="numeric" required="true">

		<cfset var method = "getAreas">

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreas" returnvariable="response">
				<cfinvokeargument name="search_text" value="#arguments.search_text#"/>
				<!---<cfif len(arguments.order_by) GT 0>
					<cfinvokeargument name="order_by" value="#arguments.order_by#"/>
					<cfinvokeargument name="order_type" value="#arguments.order_type#"/>
				</cfif>--->
				<cfinvokeargument name="limit" value="#arguments.limit#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- redirectToFirstAreaWithAccess --->

	<cffunction name="redirectToFirstAreaWithAccess" returntype="void" output="false" access="public">
		<cfargument name="get_user_id" type="numeric" required="true">

		<cfset var method = "redirectToFirstAreaWithAccess">

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getRootAreaId" returnvariable="rootAreaid">
			</cfinvoke>

			<!---Se obtiene si el usuario está en el área raiz--->
			<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="isRootUser" returnvariable="userInRootArea">
			  <cfinvokeargument name="get_user_id" value="#arguments.get_user_id#">
			  <cfinvokeargument name="root_area_id" value="#rootAreaId#">
			</cfinvoke>

			<cfif userInRootArea IS true>

				<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

			  <!---Se obtiene la lista de las áreas raices visibles (la raiz real no se muestra en el árbol de la aplicación)--->
			  <cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getVisibleRootAreas" returnvariable="userRootAreasQuery">
			    <cfinvokeargument name="root_area_id" value="#rootAreaid#">
			    <cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			    <cfinvokeargument name="client_dsn" value="#client_dsn#">
			  </cfinvoke>

			<cfelse>

			  <cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getUserRootAreas" returnvariable="userRootAreasQuery">
			    <cfinvokeargument name="get_user_id" value="#arguments.get_user_id#">
			  </cfinvoke>

			</cfif>

			<cfif userRootAreasQuery.recordCount GT 0>

			  <cflocation url="#APPLICATION.htmlPath#/area_items.cfm?area=#userRootAreasQuery.id#" addtoken="false">

			<cfelse>

			  <cflocation url="#APPLICATION.htmlPath#/tree.cfm" addtoken="false">

			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

	</cffunction>


</cfcomponent>

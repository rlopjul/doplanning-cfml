<cfset client_abb = SESSION.client_abb>
<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>

<!---<cfif isDefined("URL.from_date")>
	<cfset from_date = URL.from_date>
<cfelse>
	<cfset from_date = "">
</cfif>

<cfif isDefined("URL.end_date")>
	<cfset end_date = URL.end_date>
<cfelse>
	<cfset end_date = "">
</cfif>--->

<cfif isDefined("URL.include_subareas") AND URL.include_subareas IS true>
	<cfset include_subareas = URL.include_subareas>
<cfelse>
	<cfset include_subareas = "">
</cfif>

<cfif isDefined("URL.area_id") AND isNumeric(URL.area_id)>
	<cfset area_id = URL.area_id>

	<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getParentAreasIds" returnvariable="parentAreasIds">
		<cfinvokeargument name="area_id" value="#area_id#">

		<cfinvokeargument name="client_abb" value="#client_abb#">
		<cfinvokeargument name="client_dsn" value="#client_dsn#">
	</cfinvoke>

	<cfset areasIds = ListAppend(parentAreasIds, area_id)>
	<cfif include_subareas IS true>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreasIds" returnvariable="subAreasIds">
			<cfinvokeargument name="area_id" value="#area_id#">

			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<cfset areasIds = ListAppend(subAreasIds, areasIds)>

	</cfif>

<cfelse>
	<cfset area_id = "">
</cfif>

<cfif isDefined("URL.include_without_connections") AND URL.include_without_connections IS true>
	<cfset include_without_connections = true>
<cfelse>
	<cfset include_without_connections = false>
</cfif>

<!--- getGeneralStatistics --->
<cfinvoke component="#APPLICATION.componentsPath#/StatisticManager" method="getTotalItemsByUser" returnvariable="getStatisticsResponse">
	<cfinvokeargument name="group_by_users" value="true">
	<!---<cfif len(from_date) GT 0>
		<cfinvokeargument name="from_date" value="#from_date#"/>
	</cfif>
	<cfif len(end_date) GT 0>
		<cfinvokeargument name="end_date" value="#end_date#"/>
	</cfif>--->
	<cfif isNumeric(area_id)>
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfif>
	<cfif include_subareas IS true>
		<cfinvokeargument name="include_subareas" value="true">
		<cfinvokeargument name="subareas_ids" value="#subAreasIds#">
	</cfif>
</cfinvoke>

<cfset itemsByUsers = getStatisticsResponse.itemsByUsers>
<cfset usersWithItems = structCount(itemsByUsers)>

<cfset order_by = "user_full_name">
<cfset order_type = "ASC">

<!--- getAllUsers --->
<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="getAllUsers" returnvariable="response">
	<cfinvokeargument name="order_by" value="#order_by#">
	<cfinvokeargument name="order_type" value="#order_type#">
	<cfinvokeargument name="return_type" value="query">
</cfinvoke>

<cfset usersQuery = response.users>

<cfif isNumeric(area_id)>

	<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getAllUsersRelatedToAreas" returnvariable="relatedUsersQuery">
		<cfinvokeargument name="areas_ids" value="#areasIds#">

		<cfinvokeargument name="client_abb" value="#client_abb#">
		<cfinvokeargument name="client_dsn" value="#client_dsn#">
	</cfinvoke>

	<cfset relatedUsersQueryIds = valueList(relatedUsersQuery.user_id)>

</cfif>

<!---
<cfif isNumeric(area_id)>

	<!--- getAllAreaUsers --->
	<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="getAllAreaUsers" returnvariable="response">
		<cfinvokeargument name="area_id" value="#area_id#"/>
		<cfinvokeargument name="order_by" value="#order_by#"/>
		<cfinvokeargument name="order_type" value="#order_type#"/>
	</cfinvoke>

	<cfset areaUsers = response.users>
	<cfset areaUsersIds = valueList(areaUsers.user_id)>

</cfif>
---->

<!--- getAreaItemTypesStruct --->
<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
</cfinvoke>

<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>


<cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>
<script src="#APPLICATION.htmlPath#/scripts/tablesFunctions.js?v=2"></script>
</cfoutput>

<script>

	<!---

	$(function() {

		$('#from_date').datepicker({
		  format: 'dd-mm-yyyy',
		  autoclose: true,
		  weekStart: 1,
		  language: 'es',
		  todayBtn: 'linked',
		  endDate: $('#end_date').val()
		});

		$('#end_date').datepicker({
		  format: 'dd-mm-yyyy',
		  weekStart: 1,
		  language: 'es',
		  todayBtn: 'linked',
		  autoclose: true
		});

	});


	function setEndDate(){
		$('#from_date').datepicker('setEndDate', $('#end_date').val());
	}

	function setFromDate(){
		$('#end_date').datepicker('setStartDate', $('#from_date').val());
	}

	--->

	function setSelectedArea(areaId, areaName) {

		$("#area_id").val(areaId);
		$("#area_name").val(areaName);

	}

	function clearFieldSelectedArea(){

		$("#area_id").val("");
		$("#area_name").val("");

	}

	<cfoutput>

	function openAreaSelector(){

		return openPopUp('#APPLICATION.htmlPath#/iframes/area_select.cfm');

	}

	</cfoutput>

</script>

<div class="container">

	<div class="row">
		<div class="col-sm-12">
			<div class="div_message_page_title" lang="es">Estadísticas de usuarios</div>
		</div>
	</div>

	<cfoutput>

	<div class="row">
		<div class="col-sm-12">

			<div class="div_search_bar">

				<form method="get" name="statistics_form" action="#CGI.SCRIPT_NAME#" class="form-horizontal">

					<!---<div class="row">

						<label for="from_date" class="col-xs-5 col-sm-3 control-label" lang="es"><i class="icon-calendar"></i>&nbsp;&nbsp;<span lang="es">Fecha desde</span></label>

						<div class="col-xs-7 col-sm-9">
							<input type="text" name="from_date" id="from_date" class="form-control input_datepicker" value="#from_date#" onchange="setFromDate()">
						</div>

					</div>

					<div class="row">

						<label for="end_date" class="col-xs-5 col-sm-3 control-label"><i class="icon-calendar"></i>&nbsp;&nbsp;<span lang="es">Fecha hasta</span></label>

						<div class="col-xs-7 col-sm-9">
							<input type="text" name="end_date" id="end_date" value="#end_date#" class="form-control input_datepicker" onchange="setEndDate()"/>
						</div>

					</div>--->

					<div class="row" id="listAreaSelector">
						<cfif isNumeric(area_id)>
							<!--- getArea --->
							<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="selectedArea">
								<cfinvokeargument name="area_id" value="#area_id#">
							</cfinvoke>
							<cfset area_name = selectedArea.name>
						<cfelse>
							<cfset area_name = "">
						</cfif>

						<label for="area_id" id="listAreaText" class="col-xs-5 col-sm-3 control-label" lang="es">Área</label>

						<div class="col-xs-6 col-sm-7 col-md-8">
							<input type="hidden" name="area_id" id="area_id" value="#area_id#" />
							<input type="text" name="area_name" id="area_name" class="form-control" value="#area_name#" readonly="true" onclick="openAreaSelector()" />
						</div>
						<div class="col-xs-1 col-sm-1 col-md-1">
							<button onclick="clearFieldSelectedArea()" type="button" class="btn btn-default" lang="es" title="Quitar área seleccionada"><i class="icon-remove"></i></button>
						</div>
					</div>

					<div class="row">
						<div class="col-xs-5 col-sm-3"></div>
						<div class="col-sm-3 col-md-2">
							<button onclick="return openAreaSelector()" type="button" class="btn btn-default" lang="es">Seleccionar área</button>
						</div>

						<div class="col-xs-offset-5 col-xs-7 col-sm-offset-0 col-sm-6">

							<div class="checkbox">
						    <label>
						      <input type="checkbox" name="include_subareas" value="true" <cfif include_subareas IS true>checked</cfif>> <span lang="es">Incluir áreas inferiores a la seleccionada</span>
						    </label>
						  </div>

						</div>
					</div>

					<div class="row">

						<div class="col-xs-5 col-sm-3">
						</div>

						<div class="col-xs-7 col-sm-9">
							<div class="checkbox">
								<label>
									<input type="checkbox" name="include_without_connections" value="true" <cfif include_without_connections IS true>checked</cfif>> <span lang="es">Incluir usuarios que no han accedido a la aplicación</span>
								</label>
							</div>
						</div>

					</div>

					<div class="row">
						<div class="col-sm-offset-3 col-sm-10">
							<input type="submit" name="search" class="btn btn-primary" style="margin-top:30px;" lang="es" value="Filtrar" />
						</div>
					</div>

				</form>

			</div>

		</div>
	</div>

</div><!---END div container--->

<script>

	$(document).ready(function() {

		$("##statisticsTable").tablesorter({

			widgets: ['zebra','filter','stickyHeaders'<cfif usersWithItems LT 180>,'math'</cfif> ],
			headers: {
				0: {
					sorter: "text"
				}
			}
			, widgetOptions : {
				filter_childRows : false,
				filter_columnFilters : true,
				filter_cssFilter : 'tablesorter-filter',
				filter_filteredRow   : 'filtered',
				filter_formatter : null,
				filter_functions : null,
				filter_hideFilters : false,
				filter_ignoreCase : true,
				filter_liveSearch : true,
				//filter_reset : 'button.reset',
				filter_searchDelay : 300,
				filter_serversideFiltering: false,
				filter_startsWith : false,
				filter_useParsedData : false

					, math_data     : 'math' // data-math attribute
			    , math_ignore   : [0]
			    , math_mask     : '##000,##'
			    <!---. math_mask     : '##,####0.00'--->
			    <!---, math_complete : function($cell, wo, result, value, arry) {
			        var txt = '<span class="align-decimal"> ' + result + '</span>';
			        if ($cell.attr('data-math') === 'all-sum') {
			          // when the "all-sum" is processed, add a count to the end
			          return txt + ' (Sum of ' + arry.length + ' cells)';
			        }
			        return txt;
			    } --->

		    }
		});

	});
</script>

<div class="container-fluid" style="position:absolute;width:100%;left:0;">

	<div class="row">
		<div class="col-sm-12">

			<table id="statisticsTable" class="table table-hover table-bordered table-striped tablesorter-bootstrap data-table" style="margin-top:20px;">

				<thead>
					<tr>
						<th><span lang="es">Usuario</span></th>

						<th><span lang="es">Accesos a la aplicación</span></th>

						<!--- Loop items types --->
						<cfloop array="#itemTypesArray#" index="itemTypeId">

							<cfif listFind("13,16", itemTypeId) IS 0><!---Typologies are not included--->

								<th><span lang="es">#itemTypesStruct[itemTypeId].labelPlural#</span></th>

							</cfif>

						</cfloop>

					</tr>
				</thead>

				<cfif usersWithItems LT 180>
					<tfoot>
					  <tr>
					   	<th></th>
					   	<th data-math="col-sum"></th>
							<!--- Loop items types --->
							<cfloop array="#itemTypesArray#" index="itemTypeId">

								<cfif listFind("13,16", itemTypeId) IS 0><!---Typologies are not included--->

									<th data-math="col-sum"></th>

								</cfif>

							</cfloop>
						</tr>
					</tfoot>
				</cfif>

				<tbody>

					<cfset usersCount = 0>

					<cfloop query="#usersQuery#">

						<cfif usersQuery.number_of_connections GT 0 OR include_without_connections IS true>

							<cfif NOT isNumeric(area_id) OR isDefined("itemsByUsers[usersQuery.id]") OR ListFind(relatedUsersQueryIds, usersQuery.id) GT 0>

								<cfset usersCount = usersCount+1>

								<tr>

									<td>#usersQuery.user_full_name#</td>

									<td>#usersQuery.number_of_connections#</td>

									<!--- Loop items types --->
									<cfloop array="#itemTypesArray#" index="itemTypeId">

										<cfif listFind("13,16", itemTypeId) IS 0><!---Typologies are not included--->

											<cfif isDefined("itemsByUsers[usersQuery.id].items[itemTypeId].total")>

												<td>#itemsByUsers[usersQuery.id].items[itemTypeId].total#</td>

											<cfelse>

												<td>0</td>

											</cfif>

										</cfif>

									</cfloop>

								</tr>

							</cfif>

						</cfif>

					</cfloop>

				</tbody>

			</table>

		</div>
	</div>

	<div class="row">

		<div class="col-sm-12">
				#usersCount# <span lang="es">Usuarios</span>
		</div>

	</div>

	</cfoutput>

</div>
